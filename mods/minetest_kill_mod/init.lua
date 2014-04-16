suicide = {}
kill_list = {}
hp_list = {}

minetest.register_privilege("kill", {
    description = "Убивает игрока", 
    give_to_singleplayer = true
  })

minetest.register_privilege("set_hp", {
    description = "Позволяет менять кол-во здоровья игрокам", 
    give_to_singleplayer = true
  })


minetest.register_chatcommand("kill", {
    params = "<имя игрока> | используй без параметров и увидишь справку",
    description = "Немедленно убивает игрока",
    privs = {kill=true},
    func = function(name, param)
        if param == "" then
            minetest.chat_send_player(name, "Ипользовать так: /kill <имя игрока>")            
            return
        end
        if param == "/me" then
           table.insert(kill_list, name)
        elseif minetest.env:get_player_by_name(param) then
            table.insert(kill_list, param)
            minetest.chat_send_all(param .. " был убит. Это сделал " .. name .. ".")
           -- minetest.log("action", param .. " был убит. Это сделал " .. name .. ".")
            return
        end
    end
})


minetest.register_chatcommand("killme", {    
    description = "Совершить суицид",  
    func = function(name, param)
           table.insert(kill_list, name)        
            suicide[name]=1
            minetest.chat_send_all(name .. " сделал себе харакири...")
          --  minetest.log("action", name .. " сделал себе харакири...")
    return   
    end
})

minetest.register_chatcommand("hp", {
    params = "<имя игрока> <кол-во очков жизни> | используй без параметров и увидишь справку",
    description = "Позволяет менять кол-во здоровья игрокам. /hp <имя игорока> 0 ничем не отличается от команды /kill",
    privs = {set_hp=true},
    func = function(name, param)
        if param == "" then
            minetest.chat_send_player(name, "Использовать так: /hp <имя игрока> <кол-во очков жизни>")
            return
        end
        user, hp = string.match(param, " *([%w%-]+) *(%d*)")
        hp = tonumber(hp) 
        if type(hp) ~= "number" then
            minetest.chat_send_player(name, "Не могу сделать чьё-то здоровье равным ЭТОМУ!\n" .. 
                                            "Нужно указать целое положительное число.")
           return
        end
        if minetest.env:get_player_by_name(user) then
            table.insert(hp_list, {user, hp})
            minetest.chat_send_player(name, user .. ": кол-во очков жизни теперь равно " .. hp .. ".")
         --   minetest.log("action", name .. " установил кол-во очков жизни юзеру " .. user .. " равным " .. hp ..".")
            return
        end
    end
})


minetest.register_globalstep(
   function(dtime)
           for j,kill in ipairs(kill_list) do
               minetest.env:get_player_by_name(kill):set_hp(0)
               minetest.log("action", kill .. " was instantly killed.")                               
               table.remove(kill_list,j)
           end

           for j,hps in ipairs(hp_list) do
               minetest.env:get_player_by_name(hps[1]):set_hp(hps[2])
               minetest.log("action", hps[1] .. "'s HP have been changed to " .. hps[2] .. ".")                               
               table.remove(hp_list,j)
           end
   end
)




suicide = {}
kill_list = {}
hp_list = {}

minetest.register_privilege("kill", {
    description = "Kills a player", 
    give_to_singleplayer = true
  })

minetest.register_privilege("set_hp", {
    description = "Sets HP of a player", 
    give_to_singleplayer = true
  })


minetest.register_chatcommand("kill", {
    params = "<playername> | use w/o params to see help message",
    description = "Instantly kills playername",
    privs = {kill=true},
    func = function(name, param)
        if param == "" then
            minetest.chat_send_player(name, "Use like this: /kill <playername>")
            return
        end
        if param == "/me" then
           table.insert(kill_list, name)
        elseif minetest.get_player_by_name(param) then
            table.insert(kill_list, param)
            minetest.chat_send_all(param .. " has been killed by " .. name .. ".")
            --minetest.log("action", param .. " has been killed by " .. name .. ".")
            return
        end
    end
})


minetest.register_chatcommand("killme", {    
    description = "Commit suicide",
    func = function(name, param)
           table.insert(kill_list, name)        
            suicide[name]=1
            minetest.chat_send_all(name .. " has performed a harakiri...")
            --minetest.log("action", name .. " has performed a harakiri...")
    return   
    end
})

minetest.register_chatcommand("hp", {
    params = "<playername> <desired HP> | Use w/o any params to see a help message",
    description = "Sets playername HP. \"/hp <playername> 0\" equals to \"/kill\"",
    privs = {set_hp=true},
    func = function(name, param)
        if param == "" then
            minetest.chat_send_player(name, "Use it like this: /hp <playername> <desired HP>")
            return
        end
        user, hp = string.match(param, " *([%w%-]+) *(%d*)")
        hp = tonumber(hp) 
        if type(hp) ~= "number" then
            minetest.chat_send_player(name, "Can't set anyone's HP to THIS!\n" .. 
                                            "Try to use a whole positive number.")
           return
        end
        if minetest.get_player_by_name(user) then
            table.insert(hp_list, {user, hp})
            minetest.chat_send_player(name, user .. ": HP has been set to " .. hp .. ".")
            --minetest.log("action", name .. " has set " .. user .. "\'s HP to " .. hp ..".")
            return
        end
    end
})


minetest.register_globalstep(
   function(dtime)
           for j,kill in ipairs(kill_list) do
               minetest.get_player_by_name(kill):set_hp(0)
               minetest.log("action", kill .. " was instantly killed.")                               
               table.remove(kill_list,j)
           end

           for j,hps in ipairs(hp_list) do
               minetest.get_player_by_name(hps[1]):set_hp(hps[2])
               minetest.log("action", hps[1] .. "'s HP have been changed to " .. hps[2] .. ".")                               
               table.remove(hp_list,j)
           end
   end
)

print('[OK] Kill/Set HP loaded')



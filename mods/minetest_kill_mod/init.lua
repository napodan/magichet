suicide = {}
kill_list = {}
hp_list = {}

minetest.register_privilege("kill", {
    description = "������� ������", 
    give_to_singleplayer = true
  })

minetest.register_privilege("set_hp", {
    description = "��������� ������ ���-�� �������� �������", 
    give_to_singleplayer = true
  })


minetest.register_chatcommand("kill", {
    params = "<��� ������> | ��������� ��� ���������� � ������� �������",
    description = "���������� ������� ������",
    privs = {kill=true},
    func = function(name, param)
        if param == "" then
            minetest.chat_send_player(name, "����������� ���: /kill <��� ������>")            
            return
        end
        if param == "/me" then
           table.insert(kill_list, name)
        elseif minetest.env:get_player_by_name(param) then
            table.insert(kill_list, param)
            minetest.chat_send_all(param .. " ��� ����. ��� ������ " .. name .. ".")
           -- minetest.log("action", param .. " ��� ����. ��� ������ " .. name .. ".")
            return
        end
    end
})


minetest.register_chatcommand("killme", {    
    description = "��������� ������",  
    func = function(name, param)
           table.insert(kill_list, name)        
            suicide[name]=1
            minetest.chat_send_all(name .. " ������ ���� ��������...")
          --  minetest.log("action", name .. " ������ ���� ��������...")
    return   
    end
})

minetest.register_chatcommand("hp", {
    params = "<��� ������> <���-�� ����� �����> | ��������� ��� ���������� � ������� �������",
    description = "��������� ������ ���-�� �������� �������. /hp <��� �������> 0 ����� �� ���������� �� ������� /kill",
    privs = {set_hp=true},
    func = function(name, param)
        if param == "" then
            minetest.chat_send_player(name, "������������ ���: /hp <��� ������> <���-�� ����� �����>")
            return
        end
        user, hp = string.match(param, " *([%w%-]+) *(%d*)")
        hp = tonumber(hp) 
        if type(hp) ~= "number" then
            minetest.chat_send_player(name, "�� ���� ������� ���-�� �������� ������ �����!\n" .. 
                                            "����� ������� ����� ������������� �����.")
           return
        end
        if minetest.env:get_player_by_name(user) then
            table.insert(hp_list, {user, hp})
            minetest.chat_send_player(name, user .. ": ���-�� ����� ����� ������ ����� " .. hp .. ".")
         --   minetest.log("action", name .. " ��������� ���-�� ����� ����� ����� " .. user .. " ������ " .. hp ..".")
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




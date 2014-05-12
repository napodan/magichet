rad = 20

minetest.register_privilege("broadcast", {
    description = "Broadcast the message within giver radius", 
    give_to_singleplayer = false
  })


minetest.register_chatcommand("shout", {
    params = "<���������> | ��������� ��� ����������, ����� ������� �������",
    description = "��� ������� ������ �� ������, ������� ����� �� ������ 20 ������ �� ���",
    privs = {broadcast=true},
    func = function(name, param)
        if param == "" then
            minetest.chat_send_player(name, "������������ ���: /shout <���������>")
            return
        end
        local pl = minetest.env:get_player_by_name(name)
        if pl ~= nil then 
           local pos = pl:getpos()
           local obj = minetest.env:get_objects_inside_radius(pos, rad)
           for j,pla in ipairs(obj) do
               if pla:is_player() then
                  local nam = pla:get_player_name()
                  minetest.chat_send_player(nam, param)
               end
           end
        end
    end
})

print('[OK] Broadcast loaded')

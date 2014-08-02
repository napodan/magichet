local connected_hud = {}

--playerlist
minetest.register_globalstep(function(dtime)

  local players = minetest.get_connected_players()
  local pl = ''
  local numb = 0

        for k,player in ipairs(players) do
            local playern = player:get_player_name()
            pl = pl .. playern
            if pl~=''
            then pl = pl .. ', \n'
            end
            numb = numb+1
         end

        for k,player in ipairs(players) do
            local playern = player:get_player_name()
            local controls = player:get_player_control()
            if (not connected_hud[playern])
            and ((controls.sneak==true) and (controls.aux1==true)) then
               connected_hud[playern] =
                    player:hud_add({
                hud_elem_type = "text",
                position = {x=1, y=0.105},
                offset = {x=-240, y=200},
                alignment = {x=1, y=-1},
                number = 0xFF8000,
                text = tostring(numb) .. ':\n' .. pl,
            })
            end
            if (connected_hud[playern])
            and ((controls.aux1==false) or (controls.sneak==false))
            then
                player:hud_remove(connected_hud[playern])
                connected_hud[playern]=nil
            end
        end
end)


function findapos()
    local pos = {x=0,y=0,z=0}
    local vm = minetest.get_voxel_manip()
    local minp,maxp = vm:read_from_map({x=0,y=0,z=0},{x=0,y=100,z=0})
    local data = vm:get_data()
    local area = VoxelArea:new{MinEdge=minp, MaxEdge=maxp}

    local c_air = minetest.get_content_id("air")

        for y=minp.y,maxp.y do
                        local vi  = area:index(0, y  , 0)
                        local vip = area:index(0, y+1, 0)
                        if  data[vi] == c_air
                        and data[vip] == c_air
                        then
                            pos.y = y
                            break
                        end
        end
    return pos
end

minetest.register_chatcommand("spawn", {
    description = "Teleports you to the spawn point (2000 meters away max)",
    func = function(name, param)
        local pl = minetest.get_player_by_name(name)
        if pl ~= nil then
           local playerPos = pl:getpos()
            playerPos.x = math.floor(playerPos.x)
            playerPos.y = math.floor(playerPos.y)
            playerPos.z = math.floor(playerPos.z)
            local distance = math.floor(math.sqrt((0-playerPos.x)^2+(10-playerPos.y)^2+(0-playerPos.z)^2))
            if distance<=2000 then
               pl:setpos(findapos())
            else
               minetest.chat_send_player(name, 'You\'re too far ('.. distance ..
                                               ') from the spawn point... Need to be within 2000 away.')
            end
        end
    end
})

print('[OK] Admin doughnuts loaded')

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



minetest.register_chatcommand("spawn", {
    description = "Телепортация на спавн (максимум 1000 блоков)",
    func = function(name, param)
        local pl = minetest.env:get_player_by_name(name)
        if pl ~= nil then
           local playerPos = pl:getpos()
            playerPos.x = math.floor(playerPos.x)
            playerPos.y = math.floor(playerPos.y)
            playerPos.z = math.floor(playerPos.z)
            local distance = math.floor(math.sqrt((0-playerPos.x)^2+(10-playerPos.y)^2+(0-playerPos.z)^2))
            if distance<=1000 then
               pl:setpos({x=0,y=10,z=0})
            else
               minetest.chat_send_player(name, 'Ты слишком далеко от спавна... Нужно быть в 1000 блоках от него')
            end
        end
    end
})

minetest.register_chatcommand("dofile", {
    description = "Just DO it!",
    privs = {server=true},
    func = function(name, param)
        if param ~= nil then
        dofile(param)
        end
    end
})

--[[ -- to many problems
local placenode=minetest.item_place_node
function minetest.item_place_node(itemstack, placer, pointed_thing)
   if placer and placer:is_player() then
      local p = placer:getpos()
      local pos = pointed_thing.above
      if not p or not pos then
         print ('not PLAYER or NO_POS' )
         return
      end
      if  p.x > pos.x then p.x=math.floor(p.x) else p.x=math.ceil(p.x) end
      if  p.z > pos.z then p.z=math.floor(p.z) else p.z=math.ceil(p.z) end
      if  p.y < pos.y then p.y=math.ceil(p.y+0.1) end

    --  p = {x=math.modf(p.x),y=math.modf(p.y+0.5),z=math.modf(p.z)}
   --   pos = {x=math.modf(pos.x),y=math.modf(pos.y),z=math.modf(pos.z)}
      minetest.debug(minetest.pos_to_string(p) .. ' vs ' .. minetest.pos_to_string(pos))
      if  p.x == pos.x
      and p.y == pos.y
      and p.z == pos.z
      then
          print('PLACEMENT FORBIDDEN!')
          return
      else
          placenode(itemstack, placer, pointed_thing)
      return itemstack, placer, pointed_thing
      end
   else
       print('Not PLACER or PLACER_IS_NOT_A_PLAYER. Falling back...')
       placenode(itemstack, placer, pointed_thing)
   end
end
]]--


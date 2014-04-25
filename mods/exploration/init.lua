local aeons = {}

-- if there's some saved data, then load it
local input = io.open(minetest.get_worldpath().."/aeons.lua", "r")
if input then
  io.close(input)
  dofile(minetest.get_worldpath().."/aeons.lua")
-- otherwise set aeons to default value (e.g. vanilla Minecraft...
else
    aeons = {['vanilla']=true,               --     -64.....256
             ['extra nodes']=false,          --   -1000.....256
             ['something strange']=false,    --   -2000.....256
             ['ancient civilization']=false, --   -5000.....256
             ['hell is underneath']=false,   --   -8000.....256
             ['floatlands']=false,           --   -8000.....512
             ['aliens']=false,               --  -16000.....512
             ['meadows of heaven']=false,    --  -16000...16000
             ['dimentional doors']=false,    --  -16000...16000, 17000..32000 [force load]
             ['the bottom']=false,           -- -maxint..maxint
             }
end

-- Then to override digging func to prohibit it until some event.
local do_dig_node = minetest.node_dig
function minetest.node_dig(pos, node, digger)
    local y = pos.y
    local n = node.name:find('exploration:bedrock')
    local dig = false
    if (((y>=-60 and y<=256) or (y>=-8000 and y<=-5000)) and aeons['vanilla'] and not n) then dig=true end
    if y>=-1000  and y<=256   and aeons['extra nodes']          and not n then dig=true end
    if y>=-2000  and y<=256   and aeons['something strange']    and not n then dig=true end
    if y>=-5000  and y<=256   and aeons['ancient civilization'] and not n then dig=true end
    if y>=-8000  and y<=256   and aeons['hell is underneath']   and not n then dig=true end
    if y>=-8000  and y<=512   and aeons['floatlands']           and not n then dig=true end
    if y>=-16000 and y<=512   and aeons['aliens']               and not n then dig=true end
    if y>=-16000 and y<=16000 and aeons['meadows of heaven']    and not n then dig=true end
    if (((y>=-16000 and y<=16000) or (y>=17000 and y<=32000)) and aeons['dimentional doors'] and not n) then dig=true end
    if y<= 16000 and aeons['the bottom']                        and not n then dig=true end
    -- return nils if we have failed all checks
    if dig then do_dig_node(pos,node,digger) end
    return
end

-- teleport to spawn if tried to acces inaccessible :)
--[[
local stepp = 0
minetest.register_globalstep(function(dtime)
   stepp=stepp+dtime
   if stepp>0.5 then
      stepp=0
      local players=minetest.get_connected_players()
      for i,player in ipairs(players) do
          local pos = player:getpos()
          if pos then
              local x = pos.x
              local y = pos.y
              local z = pos.z
              if (not (y>-8000 and y<-5000)) and y<  -61 and not aeons['extra nodes']          then player:setpos({x=x,   y=-60, z=z}) end
              if (not (y>-8000 and y<-5000)) and y<-1001 and not aeons['something strange']    then player:setpos({x=x, y=-1000, z=z}) end
              if (not (y>-8000 and y<-5000)) and y<-2001 and not aeons['ancient civilization'] then player:setpos({x=x, y=-2000, z=z}) end

              if y>  256 and not aeons['foatlands'] then player:setpos({x=x,   y=256, z=z}) end
              if y<-8000 and not aeons['aliens']    then player:setpos({x=x, y=-8000, z=z}) end

              if y>16000 and not aeons['dimentional doors'] then player:setpos({x=x, y=16000, z=z}) end

              if (y<17001) and not (y<16000) and aeons['dimentional doors'] then player:setpos({x=x, y=17000, z=z}) end
              if (y>16000) and not (y>17000) and aeons['dimentional doors'] then player:setpos({x=x, y=16000, z=z}) end

              if y<=-16001 and not aeons['the bottom'] then player:setpos({x=x, y=-16000, z=z}) end
          end
      end
   end
end)]]

-- Now to define fake bedrock >:)
minetest.register_node("exploration:bedrock", {
    description = "Fake bedrock",
    tiles = {"default_bedrock.png"},
    drawtype = "normal",
    sunlight_propagates = true,
    paramtype = "light",
    groups = {cracky=default.dig.obsidian},
})


minetest.register_chatcommand("aeons", {
    func = function(name, param)
           aeons[param] = not aeons[param]
           minetest.chat_send_player(name,minetest.serialize(aeons[param]))
           return
    end
})


minetest.register_on_generated(function(minp, maxp, seed)

    minetest.after(10,function(dtime)
        local x1 = maxp.x
        local y1 = maxp.y
        local z1 = maxp.z
        local x0 = minp.x
        local y0 = minp.y
        local z0 = minp.z
        local vm = minetest.get_voxel_manip()
        local minp2,maxp2 = vm:read_from_map(minp,maxp)
        local data = vm:get_data()
        local area = VoxelArea:new{MinEdge=minp2, MaxEdge=maxp2}
        local c_bedrock = minetest.get_content_id("exploration:bedrock")
        --print('starting at ' .. minetest.pos_to_string({x=x1+x0/2,y=y1+y0/2,z=z1+z0/2}))
        for z=z0,z1 do
            for y=y0,y1 do
                -- 1st barrier
                if y>=-64 and y<=-60 then
                    for x=x0,x1 do
                        if math.random()<0.8 then
                            local vi = area:index(x, y, z)
                            data[vi] = c_bedrock
                        end
                        if y==-64 then
                            local vi = area:index(x, y, z)
                            data[vi] = c_bedrock
                        end
                    end

                -- 2nd barrier
                elseif y>=-1004 and y<=-1000 then
                    for x=x0,x1 do
                        if math.random()<0.8 then
                            local vi = area:index(x, y, z)
                            data[vi] = c_bedrock
                        end
                        if y==-1004 then
                            local vi = area:index(x, y, z)
                            data[vi] = c_bedrock
                        end
                    end

                -- 3rd barrier
                elseif y>=-2004 and y<=-2000 then
                    for x=x0,x1 do
                        if math.random()<0.8 then
                            local vi = area:index(x, y, z)
                            data[vi] = c_bedrock
                        end
                        if y==-2004 then
                            local vi = area:index(x, y, z)
                            data[vi] = c_bedrock
                        end
                    end

                -- 4th barrier
                elseif y>=-5004 and y<=-5000 then
                    for x=x0,x1 do
                        if math.random()<0.8 then
                            local vi = area:index(x, y, z)
                            data[vi] = c_bedrock
                        end
                        if y==-5004 then
                            local vi = area:index(x, y, z)
                            data[vi] = c_bedrock
                        end
                    end

                -- 5th barrier
                elseif y>=-8004 and y<=-8000 then
                    for x=x0,x1 do
                        if math.random()<0.8 then
                            local vi = area:index(x, y, z)
                            data[vi] = c_bedrock
                        end
                        if y==-8004 then
                            local vi = area:index(x, y, z)
                            data[vi] = c_bedrock
                        end
                    end

                -- 6th barrier
                elseif y>=-16004 and y<=-16000 then
                    for x=x0,x1 do
                        if math.random()<0.8 then
                            local vi = area:index(x, y, z)
                            data[vi] = c_bedrock
                        end
                        if y==-16004 then
                            local vi = area:index(x, y, z)
                            data[vi] = c_bedrock
                        end
                    end
               end
            end
        end
        vm:set_data(data)
        vm:set_lighting({day=0, night=0})
        vm:calc_lighting()
        vm:write_to_map(data)
        vm:update_map()
   end)
end)

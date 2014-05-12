local save_timer = 10
local stmr = 0

-- init aeons tables
local aeons = {['vanilla']={},              --     -64.....256
               ['extra nodes']={},          --   -1000.....256
               ['something strange']={},    --   -2000.....256
               ['ancient civilization']={}, --   -5000.....256
               ['hell is underneath']={},   --   -8000.....256
               ['floatlands']={},           --   -8000.....512
               ['aliens']={},               --  -16000.....512
               ['meadows of heaven']={},    --  -16000...16000
               ['dimentional doors']={},    --  -16000...16000, 17000..32000 [force load]
               ['the bottom']={},           -- -maxint..maxint
              }

-- if there's some saved data, then load it
local input = io.open(minetest.get_worldpath().."/aeons.lua", "r")
if input then
  io.close(input)
  dofile(minetest.get_worldpath().."/aeons.lua")
end


minetest.register_on_joinplayer(function(player)
    local pll = player:get_player_name()
    aeons['vanilla'][pll] = true
end)


-- Then to override digging func to prohibit it until some event.
local do_dig_node = minetest.node_dig
function minetest.node_dig(pos, node, digger)
    local y = pos.y
    local n = node.name:find('exploration:bedrock')
    local dig = false
    local pll = digger:get_player_name()
    if (((y>=-60 and y<=256) or (y>=-8000 and y<=-5000)) and aeons['vanilla'][pll] and not n) then dig=true end
    if y>=-1000  and y<=256   and aeons['extra nodes'][pll]          and not n then dig=true end
    if y>=-2000  and y<=256   and aeons['something strange'][pll]    and not n then dig=true end
    if y>=-5000  and y<=256   and aeons['ancient civilization'][pll] and not n then dig=true end
    if y>=-8000  and y<=256   and aeons['hell is underneath'][pll]   and not n then dig=true end
    if y>=-8000  and y<=512   and aeons['floatlands'][pll]           and not n then dig=true end
    if y>=-16000 and y<=512   and aeons['aliens'][pll]               and not n then dig=true end
    if y>=-16000 and y<=16000 and aeons['meadows of heaven'][pll]    and not n then dig=true end
    if (((y>=-16000 and y<=16000) or (y>=17000 and y<=32000)) and aeons['dimentional doors'][pll] and not n) then dig=true end
    if y<= 16000 and aeons['the bottom'][pll]                        and not n then dig=true end
    -- return nils if we have failed all checks
 --   dig=true
    if dig then do_dig_node(pos,node,digger) end
    return
end


function find_a_pos()
    local pos = {x=0,y=0,z=0}
    if global_spawnpoint then
       pos.x = global_spawnpoint.x    
       pos.y = global_spawnpoint.y
       pos.z = global_spawnpoint.z    
    end       
    local vm = minetest.get_voxel_manip()
    local minp,maxp = vm:read_from_map({x=pos.x,y=0,z=pos.z},{x=pos.x,y=100,z=pos.z})
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


-- teleport to spawn if tried to acces inaccessible :)
local stepp = 0
minetest.register_globalstep(function(dtime)
   
   -- save data every save_timer seconds
   stmr = stmr + dtime
   if stmr > save_timer then
      stmr = 0
      local output = io.open(minetest.get_worldpath().."/aeons.lua", "w")
      if output then
         o  = minetest.serialize(aeons)
         i  = string.find(o, "return")
         o1 = string.sub(o, 1, i-1)
         o2 = string.sub(o, i-1, -1)
         output:write(o1 .. "\n")
         output:write("aeons = minetest.deserialize('" .. o2 .. "')\n")
         io.close(output)
      end                    
   end
   
   stepp=stepp+dtime
   if stepp>0.5 then
      stepp=0
      local players=minetest.get_connected_players()
      for i,player in ipairs(players) do
          local pos = player:getpos()
          if pos then
              local y = pos.y              
              local tp = nil

              if (not (y>-8000 and y<-5000)) and y<  -61 and not aeons['extra nodes'][pll]          then tp = 'extra nodes' end
              if (not (y>-8000 and y<-5000)) and y<-1001 and not aeons['something strange'][pll]    then tp = 'something strange' end
              if (not (y>-8000 and y<-5000)) and y<-2001 and not aeons['ancient civilization'][pll] then tp = 'ancient civilization' end

              if y>  256 and not aeons['floatlands'][pll] then tp = 'floatlands' end
              if y<-8000 and not aeons['aliens'][pll]    then tp = 'aliens' end

              if y>16000 and not aeons['dimentional doors'][pll] then tp = 'dimentional doors' end

              if (y<17001) and not (y<16000) and aeons['dimentional doors'][pll] then tp = 'dimentional doors' end
              if (y>16000) and not (y>17000) and aeons['dimentional doors'][pll] then tp = 'dimentional doors' end

              if y<=-16001 and not aeons['the bottom'][pll] then tp = 'the bottom' end

              if tp then
                 local objs = minetest.get_objects_inside_radius(pos, 10)
                 for i, obj in ipairs(objs) do
                     if obj:is_player() then
                        local pll = obj:get_player_name()
                        -- anyone can take anyone else with him/her deeper than allowed...
                        if aeons[tp][pll] then
                           tp = nil
                           return
                        end
                     end
                 end

                 if minetest.find_node_near(pos, 5, "exploration:notp_"..tp) then
                    -- do NOT teleport if there's a notp node near
                    -- ToDo: make it activated with mesecons/electricity
                    return
                 end

                 -- teleport if nothing prevents from it
                 local spawn = find_a_pos()
                 player:setpos({x=spawn.x,   y=spawn.y, z=spawn.z})                 

              end
          end
      end
   end
end)




-- Now to define fake bedrock >:)
minetest.register_node("exploration:bedrock", {
    description = "Fake bedrock",
    tiles = {"default_bedrock.png"},
    drawtype = "normal",
    sunlight_propagates = true,
    paramtype = "light",
    groups = {cracky=default.dig.obsidian},
})

-- chat command to hack aeons
minetest.register_chatcommand("aeons", {
    func = function(name, param)
           aeons[param][name] = not aeons[param][name]
           minetest.chat_send_player(name, param .. ' is like this now: ' .. minetest.serialize(aeons[param][name]))
           return
    end
})

-- barriers that separate aeons
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

print('[OK] Exploration loaded')

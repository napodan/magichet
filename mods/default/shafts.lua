local shseed = nil

local smin = tonumber(minetest.setting_get("shafts_start_altitude"))    -- higher
local smax = tonumber(minetest.setting_get("shafts_end_altitude"))      -- lower

if not smax then smax = -30  end
if not smin then smin = -500 end

local shafts = {}

local loot = {
{name = "farming:bread",              imin = 1, imax = 3, chance = 3/16},
{name = "farming:seeds_pumpkin",      imin = 2, imax = 4, chance = 2/16},
{name = "farming:seeds_melon",        imin = 2, imax = 4, chance = 2/16},
{name = "default:ingot_iron",         imin = 1, imax = 5, chance = 2/16},
{name = "default:lump_coal",          imin = 3, imax = 8, chance = 2/16},
{name = "mesecons:wire_00000000_off", imin = 4, imax = 9, chance = 1/16},
{name = "default:ingot_gold",         imin = 1, imax = 3, chance = 1/16},
{name = "default:ore_lapis",          imin = 4, imax = 9, chance = 1/16},
{name = "default:ore_lapis",          imin = 4, imax = 9, chance = 1/16},
{name = "default:block_diamond",      imin = 1, imax = 2, chance = 3/80},
{name = "4items:saddle",              imin = 1, imax = 1, chance = 3/80},
{name = "default:rails",              imin = 4, imax = 8, chance = 1/80},
{name = "default:pick_iron",          imin = 1, imax = 1, chance = 1/80},
{name = "enchantment:book",           imin = 1, imax = 1, chance = 1/80},
{name = "adbs:horse_armor",           imin = 1, imax = 1, chance = 1/80},
}

local function place_loot(pos)
     local meta = minetest.get_meta(pos)
     local inv = meta:get_inventory()
     for i=1,27 do
         local rnd = math.random()
         if rnd<4/16 then
            local n = math.random(1,#loot)          
            local chance = loot[n].chance
               if chance>rnd then            
                  inv:set_stack("main", i,ItemStack(loot[n].name.." "..math.random(loot[n].imin,loot[n].imax)))
               end 
         end
     end
end

local c_wood = minetest.get_content_id("default:wood")
local c_fenc = minetest.get_content_id("default:fence")
local c_cweb = minetest.get_content_id("default:cobweb")
local c_rail = minetest.get_content_id("default:rail")
local c_torc = minetest.get_content_id("default:torch")
local c_igno = minetest.get_content_id("ignore")
local c_air  = minetest.get_content_id("air")

local function get_bseed(minp)
      return shseed + math.floor(3*minp.x/37) + math.floor(547*minp.z/63)
end

local function check_chunk(minp,maxp)
   if (maxp.y < smax) and (minp.y > smin) then
      for _,pos in pairs(shafts) do
          if  pos.x >= minp.x and pos.x <=maxp.x 
          and pos.y >= minp.y and pos.y <=maxp.y 
          and pos.z >= minp.z and pos.z <=maxp.z
          then 
              return false 
          end
      end
      local air =  minetest.find_nodes_in_area(minp, maxp, "air")
      local pi = PseudoRandom(get_bseed(minp))
      local s = pi:next(1, 400)
      if s>60 then 
         return false 
      else      
         table.insert(shafts,{x=minp.x+10, y = minp.y+10, z= minp.z+10})
         print('mineshaft at '.. minetest.pos_to_string({x=minp.x+10, y = minp.y+10, z= minp.z+10}))
         return true
      end
   else
      return false   
   end
end

local sector={
                { { x = -1, y = 0, z = 7, name = "default:fence"},  -- 1  +z
                  { x =  1, y = 0, z = 7, name = "default:fence"},
                  { x = -1, y = 0, z = 3, name = "default:fence"},
                  { x =  1, y = 0, z = 3, name = "default:fence"},
                  { x = -1, y = 1, z = 7, name = "default:fence"},
                  { x =  1, y = 1, z = 7, name = "default:fence"},
                  { x = -1, y = 1, z = 3, name = "default:fence"},
                  { x =  1, y = 1, z = 3, name = "default:fence"},
                  { x = -1, y = 2, z = 7, name = "default:wood"},
                  { x =  0, y = 2, z = 7, name = "default:wood"},
                  { x =  1, y = 2, z = 7, name = "default:wood"},
                  { x = -1, y = 2, z = 3, name = "default:wood"},
                  { x =  0, y = 2, z = 3, name = "default:wood"},
                  { x =  1, y = 2, z = 3, name = "default:wood"},
                },
                { { z = -1, y = 0, x = 7, name = "default:fence"},  -- 2  +x 
                  { z =  1, y = 0, x = 7, name = "default:fence"},
                  { z = -1, y = 0, x = 3, name = "default:fence"},
                  { z =  1, y = 0, x = 3, name = "default:fence"},
                  { z = -1, y = 1, x = 7, name = "default:fence"},
                  { z =  1, y = 1, x = 7, name = "default:fence"},
                  { z = -1, y = 1, x = 3, name = "default:fence"},
                  { z =  1, y = 1, x = 3, name = "default:fence"},
                  { z = -1, y = 2, x = 7, name = "default:wood"},
                  { z =  0, y = 2, x = 7, name = "default:wood"},
                  { z =  1, y = 2, x = 7, name = "default:wood"},
                  { z = -1, y = 2, x = 3, name = "default:wood"},
                  { z =  0, y = 2, x = 3, name = "default:wood"},
                  { z =  1, y = 2, x = 3, name = "default:wood"},
                },
                { { x = -1, y = 0, z =  7, name = "default:fence"}, -- 3  -z
                  { x =  1, y = 0, z =  7, name = "default:fence"},
                  { x = -1, y = 0, z = -3, name = "default:fence"},
                  { x =  1, y = 0, z = -3, name = "default:fence"},
                  { x = -1, y = 1, z =  7, name = "default:fence"},
                  { x =  1, y = 1, z =  7, name = "default:fence"},
                  { x = -1, y = 1, z = -3, name = "default:fence"},
                  { x =  1, y = 1, z = -3, name = "default:fence"},
                  { x = -1, y = 2, z =  7, name = "default:wood"},
                  { x =  0, y = 2, z =  7, name = "default:wood"},
                  { x =  1, y = 2, z =  7, name = "default:wood"},
                  { x = -1, y = 2, z = -3, name = "default:wood"},
                  { x =  0, y = 2, z = -3, name = "default:wood"},
                  { x =  1, y = 2, z = -3, name = "default:wood"},
                },
                { { z = -1, y = 0, x =  7, name = "default:fence"}, -- 4  -x
                  { z =  1, y = 0, x =  7, name = "default:fence"},
                  { z = -1, y = 0, x = -3, name = "default:fence"},
                  { z =  1, y = 0, x = -3, name = "default:fence"},
                  { z = -1, y = 1, x =  7, name = "default:fence"},
                  { z =  1, y = 1, x =  7, name = "default:fence"},
                  { z = -1, y = 1, x = -3, name = "default:fence"},
                  { z =  1, y = 1, x = -3, name = "default:fence"},
                  { z = -1, y = 2, x =  7, name = "default:wood"},
                  { z =  0, y = 2, x =  7, name = "default:wood"},
                  { z =  1, y = 2, x =  7, name = "default:wood"},
                  { z = -1, y = 2, x = -3, name = "default:wood"},
                  { z =  0, y = 2, x = -3, name = "default:wood"},
                  { z =  1, y = 2, x = -3, name = "default:wood"},
                }
}

local function distance(pos1,pos2)
      return ((pos1.x-pos2.x)^2 + (pos1.y-pos2.y)^2 + (pos1.z-pos2.z)^2)^0.5   
end

local function generate_shaft(p, dir, length, depth, data, area)
      local pos = {x=p.x, y=p.y, z=p.z}
	  local sideways = {}
	  for i=1,depth do
	      local new_dir = math.random(0,1)
		  local slice = math.random(1,math.ceil(length/2))
		  if new_dir == 0 then new_dir = -1 end
		  local pp
		  if     dir == 1 then
    		     pp = {x=p.x, y=p.y, z=p.z+slice*8}
		  elseif dir == 2 then
    		     pp = {x=p.x+slice*8, y=p.y, z=p.z}
		  elseif dir == 3 then
    		     pp = {x=p.x, y=p.y, z=p.z-(slice+1)*8}
		  elseif dir == 4 then
    		     pp = {x=p.x-(slice+1)*8, y=p.y, z=p.z}
          end		               
		 if pp then 
                local found = false
                for _,sideway in pairs(sideways) do
                    if pp.x==sideway.pos.x and pp.y==sideway.pos.y and pp.z == sideway.pos.z 
                    or (pp and pos and distance(pp,sideway.pos)<250) 
                    then
                       found = true
                       break
                    end
                end
             if not found then   
                table.insert(sideways,{pos = pp,length = math.random(1,20),dir = new_dir})    -- insert # of the sector AFTER which a sideway may start and it's direction: 0=left,1=right		  
             end
          end
	  end
	  for i=1,length do
	      if     dir == 1 then -- +z
                 for x=-1,1 do 
                     for y=0,3 do
                         for z=0,7 do
                            if y == 0 then
                               if data[area:index(pos.x+x,pos.y+y-1, pos.z+z)] == c_air
                               or data[area:index(pos.x+x,pos.y+y-1, pos.z+z)] == c_igno           
                               then
                                   data[area:index(pos.x+x,pos.y+y, pos.z+z)] = c_wood
                                  --minetest.set_node({x=pos.x+x,y=pos.y+y,z=pos.z+z},{name='default:wood'})                                  
                               end
                            else
                                --minetest.set_node({x=pos.x+x,y=pos.y+y,z=pos.z+z},{name='air'})
                                data[area:index(pos.x+x,pos.y+y, pos.z+z)] = c_air
                                if y == 3 and math.random(1,100)<30 then
                                   --minetest.set_node({x=pos.x+x,y=pos.y+y,z=pos.z+z},{name='cobweb:cobweb'})
                                   data[area:index(pos.x+x,pos.y+y, pos.z+z)] = c_cweb
                                end
                                if y == 2 and x~=0 and math.random(1,100)<5 then
                                   --minetest.set_node({x=pos.x+x,y=pos.y+y,z=pos.z+z},{name='cobweb:cobweb'})
                                   data[area:index(pos.x+x,pos.y+y, pos.z+z)] = c_cweb
                                end
                                if y == 1 and x~=0 and math.random(1,200)<5 then
                                   --minetest.set_node({x=pos.x+x,y=pos.y+y,z=pos.z+z},{name='cobweb:cobweb'})
                                   data[area:index(pos.x+x,pos.y+y, pos.z+z)] = c_torc
                                end
                                if y == 1 and x==0 and math.random(1,100)<40 then
                                   --minetest.set_node({x=pos.x+x,y=pos.y+y,z=pos.z+z},{name='default:rail'})
                                   data[area:index(pos.x+x,pos.y+y, pos.z+z)] = c_rail
                                end
                            end
                         end
    			    end
                   end
                   for _,node in pairs(sector[1]) do
                       --minetest.set_node({x=pos.x+node.x,y=pos.y+node.y+1,z=pos.z+node.z},{name=node.name})
                       data[area:index(pos.x+node.x,pos.y+node.y+1, pos.z+node.z)] = minetest.get_content_id(node.name)
                   end 
                   pos.z = pos.z +8

		  elseif dir == 2 then -- +x
                 for x=0,7 do
                     for y=0,3 do
                         for z=-1,1 do
                            if y == 0 then
                               if data[area:index(pos.x+x,pos.y+y-1, pos.z+z)] == c_air
                               or data[area:index(pos.x+x,pos.y+y-1, pos.z+z)] == c_igno
                               then
                                  -- minetest.set_node({x=pos.x+x,y=pos.y+y,z=pos.z-z},{name='default:wood'})
                                  data[area:index(pos.x+x,pos.y+y, pos.z+z)] = c_wood
                               end
                            else   
                                --minetest.set_node({x=pos.x+x,y=pos.y+y,z=pos.z+z},{name='air'})
                                data[area:index(pos.x+x,pos.y+y, pos.z+z)] = c_air
                                if y == 3 and math.random(1,100)<30 then
                                   --minetest.set_node({x=pos.x+x,y=pos.y+y,z=pos.z+z},{name='cobweb:cobweb'})
                                   data[area:index(pos.x+x,pos.y+y, pos.z+z)] = c_cweb
                                end
                                if y == 2 and z~=0 and math.random(1,100)<5 then
                                   --minetest.set_node({x=pos.x+x,y=pos.y+y,z=pos.z+z},{name='cobweb:cobweb'})
                                   data[area:index(pos.x+x,pos.y+y, pos.z+z)] = c_cweb
                                end
                                if y == 1 and x~=0 and math.random(1,200)<5 then
                                   --minetest.set_node({x=pos.x+x,y=pos.y+y,z=pos.z+z},{name='cobweb:cobweb'})
                                   data[area:index(pos.x+x,pos.y+y, pos.z+z)] = c_torc
                                end
                                if y == 1 and x==0 and math.random(1,100)<40 then
                                   --minetest.set_node({x=pos.x+x,y=pos.y+y,z=pos.z+z},{name='default:rail'})
                                   data[area:index(pos.x+x,pos.y+y, pos.z+z)] = c_rail
                                end
                            end
                         end
                      end
                   end
                   for _,node in pairs(sector[2]) do
                     --  minetest.set_node({x=pos.x+node.x,y=pos.y+node.y+1,z=pos.z+node.z},{name=node.name})
                     data[area:index(pos.x+node.x,pos.y+node.y+1, pos.z+node.z)] = minetest.get_content_id(node.name)
                   end 
			 pos.x = pos.x +8
                   
		  elseif dir == 3 then -- -z
 		     pos.z = pos.z -8
                 for x=-1,1 do 
                     for y=0,3 do
                         for z=0,7 do
                            if y == 0 then                            
                               if data[area:index(pos.x+x,pos.y+y-1, pos.z-z)] == c_air
                               or data[area:index(pos.x+x,pos.y+y-1, pos.z-z)] == c_igno
                               then
                                  --minetest.set_node({x=pos.x+x,y=pos.y+y,z=pos.z-z},{name='default:wood'})
                                  data[area:index(pos.x+x,pos.y+y, pos.z-z)] = c_wood
                               end
                            else
                                --minetest.set_node({x=pos.x+x,y=pos.y+y,z=pos.z+z},{name='air'})
                                data[area:index(pos.x+x,pos.y+y, pos.z-z)] = c_air
                                if y == 3 and math.random(1,100)<30 then
                                   --minetest.set_node({x=pos.x+x,y=pos.y+y,z=pos.z+z},{name='cobweb:cobweb'})
                                   data[area:index(pos.x+x,pos.y+y, pos.z-z)] = c_cweb
                                end
                                if y == 2 and x~=0 and math.random(1,100)<5 then
                                   --minetest.set_node({x=pos.x+x,y=pos.y+y,z=pos.z+z},{name='cobweb:cobweb'})
                                   data[area:index(pos.x+x,pos.y+y, pos.z-z)] = c_cweb
                                end
                                if y == 1 and x~=0 and math.random(1,200)<5 then
                                   --minetest.set_node({x=pos.x+x,y=pos.y+y,z=pos.z+z},{name='cobweb:cobweb'})
                                   data[area:index(pos.x+x,pos.y+y, pos.z-z)] = c_torc
                                end
                                if y == 1 and x==0 and math.random(1,100)<40 then
                                   --minetest.set_node({x=pos.x+x,y=pos.y+y,z=pos.z+z},{name='default:rail'})
                                   data[area:index(pos.x+x,pos.y+y, pos.z-z)] = c_rail
                                end
                            end
                         end
			    end
                   end
                   for _,node in pairs(sector[3]) do
                       --minetest.set_node({x=pos.x+node.x,y=pos.y+node.y+1,z=pos.z+node.z},{name=node.name})
                      data[area:index(pos.x+node.x,pos.y+node.y+1, pos.z+node.z)] = minetest.get_content_id(node.name)
                   end 
                   
		  elseif dir == 4 then -- -x
                 pos.x = pos.x -8
                 for x=0,7 do
                     for y=0,3 do
                         for z=-1,1 do
                            if y == 0 then
                               if data[area:index(pos.x-x,pos.y+y-1, pos.z+z)] == c_air
                               or data[area:index(pos.x-x,pos.y+y-1, pos.z+z)] == c_igno
                               then
                                  --minetest.set_node({x=pos.x+x,y=pos.y+y,z=pos.z-z},{name='default:wood'})
                                  data[area:index(pos.x-x,pos.y+y, pos.z+z)] = c_wood
                               end
                            else
                                --minetest.set_node({x=pos.x+x,y=pos.y+y,z=pos.z+z},{name='air'})
                                data[area:index(pos.x-x,pos.y+y, pos.z+z)] = c_air
                                if y == 3 and math.random(1,100)<30 then
                                   --minetest.set_node({x=pos.x+x,y=pos.y+y,z=pos.z+z},{name='cobweb:cobweb'})
                                   data[area:index(pos.x-x,pos.y+y, pos.z+z)] = c_cweb
                                end
                                if y == 2 and z~=0 and math.random(1,100)<5 then
                                   --minetest.set_node({x=pos.x+x,y=pos.y+y,z=pos.z+z},{name='cobweb:cobweb'})
                                   data[area:index(pos.x-x,pos.y+y, pos.z+z)] = c_cweb
                                end
                                if y == 1 and x~=0 and math.random(1,200)<11 then
                                   --minetest.set_node({x=pos.x+x,y=pos.y+y,z=pos.z+z},{name='cobweb:cobweb'})
                                   data[area:index(pos.x-x,pos.y+y, pos.z+z)] = c_torc
                                end
                                if y == 1 and x==0 and math.random(1,100)<40 then
                                   --minetest.set_node({x=pos.x+x,y=pos.y+y,z=pos.z+z},{name='default:rail'})
                                   data[area:index(pos.x-x,pos.y+y, pos.z+z)] = c_rail
                                end
                            end
                         end
                      end
			 end
				 for _,node in pairs(sector[4]) do
                             --minetest.set_node({x=pos.x+node.x,y=pos.y+node.y+1,z=pos.z+node.z},{name=node.name})
                            data[area:index(pos.x+node.x,pos.y+node.y+1, pos.z+node.z)] = minetest.get_content_id(node.name)
				 end 
		  end
      end	  
   
      for _,sideway in pairs(sideways) do
          local new_dir = dir + sideway.dir
          if new_dir == 5 then new_dir = 1 end		  
          if new_dir == 0 then new_dir = 4 end		  
             generate_shaft(sideway.pos,new_dir, sideway.length,depth-1,data,area)
	  end
end

minetest.register_on_mapgen_init(function(mgparams)
    shseed = mgparams.seed
end)

minetest.register_on_generated(function(minp, maxp, seed)
        if not check_chunk(minp,maxp) then return end
        local r = {x=math.abs(minp.x-maxp.x),y=math.abs(minp.y-maxp.y),z=math.abs(minp.x-maxp.x)}
        local p = {x=minp.x+math.random(r.x), y=minp.y+math.random(r.y), z=minp.z+math.random(r.z),}
        local vm,emin,emax = minetest.get_mapgen_object('voxelmanip')
        local data = vm:get_data()
        local area = VoxelArea:new{MinEdge={x=emin.x, y=emin.y, z=emin.z}, MaxEdge={x=emax.x, y=emax.y, z=emax.z},}
        generate_shaft(p,math.random(1,4),math.random(1,10),3, data, area)
        vm:set_data(data)
        vm:calc_lighting({x=minp.x-16, y=minp.y, z=minp.z-16}, {x=maxp.x+16, y=maxp.y, z=maxp.z+16})
        vm:write_to_map(data)
        vm:update_map()        
end)

print('[OK] Mine shafts loaded')

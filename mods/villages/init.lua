mg = {}

local ENABLE_SNOW = false

local DMAX = 20
local AREA_SIZE = 80

c_air           = minetest.get_content_id("air")
c_gravel        = minetest.get_content_id("default:gravel")
c_stone         = minetest.get_content_id("default:stone")
c_ignore        = minetest.get_content_id("ignore")
c_wood          = minetest.get_content_id("default:wood")
c_cobble        = minetest.get_content_id("default:cobble")
c_torch         = minetest.get_content_id("default:torch")
c_desert_cobble = minetest.get_content_id("desert_uses:desert_cobble")
c_desert_stone  = minetest.get_content_id("default:desert_stone")
c_tree          = minetest.get_content_id("default:tree")
c_dirt          = minetest.get_content_id("default:dirt")
c_stone         = minetest.get_content_id("default:stone")
c_water         = minetest.get_content_id("default:water_source")
c_ice           = minetest.get_content_id("default:ice")
c_sand          = minetest.get_content_id("default:sand")
c_sandstone     = minetest.get_content_id("default:sandstone")
c_desert_sand   = minetest.get_content_id("default:desert_sand")
c_desert_stone  = minetest.get_content_id("default:desert_stone")

-- stores positions of generated villages
vvvg = {}
-- default water level
water_level = 1
wseed = nil

local function save_villages()
    local output = io.open(minetest.get_worldpath().."/villages.lua", "w")
    if output then
       output:write("vvvg = minetest.deserialize('" .. minetest.serialize(vvvg) .. "')\n")
       io.close(output)
    end
end

local function load_villages()
   local input = io.open(minetest.get_worldpath().."/villages.lua", "r")
   if input then
      io.close(input)
      dofile(minetest.get_worldpath().."/villages.lua")
   --   print(minetest.serialize(vvvg))
   else
      save_villages()
   end
end

minetest.register_on_mapgen_init(function(mgparams)
        load_villages()
        water_level = mgparams.water_level or 1
        wseed = mgparams.seed
end)

local function cliff(x, n)
        return 0.2*x*x - x + n*x - n*n*x*x - 0.01 * math.abs(x*x*x) + math.abs(x)*100*n*n*n*n
end

local function get_base_surface_at_point(x, z, vn, vh, ni, noise1, noise2, noise3, noise4)
       local result = find_base_pos(x,vh,z)
       local dst = result.y
       return dst
end

local function surface_at_point(x, z, ...)
        return get_base_surface_at_point(x, z, unpack({...}))
end

local SMOOTHED = AREA_SIZE+2*DMAX
local HSMOOTHED = AREA_SIZE+DMAX
local INSIDE = AREA_SIZE-DMAX

local function smooth(x, z, ...)
        local s=0
        local w=0
        for xi=-DMAX, DMAX do
        for zi=-DMAX, DMAX do
                local d2=xi*xi+zi*zi
                if d2<DMAX*DMAX then
                        local w1 = 1-d2/(DMAX*DMAX)
                        local w2 = 15/16*w1*w1
                        w = w+w2
                        s=s+w2*surface_at_point(x+xi, z+zi, unpack({...}))
                end
        end
        end
        return s/w
end

local function smooth_surface(x, z, vnoise, vx, vz, vs, vh, ...)
        local vn
        if vs ~= 0 then
                vn = (vnoise:get2d({x=x, y=z})-2)*20+(40/(vs*vs))*((x-vx)*(x-vx)+(z-vz)*(z-vz))
        else
                vn = 1000
        end
        return surface_at_point(x, z, vn, vh, unpack({...}))
end

function inside_village(x, z, vx, vz, vs, vnoise)
        return ((vnoise:get2d({x=x, y=z})-2)*20+(40/(vs*vs))*((x-vx)*(x-vx)+(z-vz)*(z-vz)))<=40
end

function get_bseed(minp)
        return wseed + math.floor(5*minp.x/47) + math.floor(873*minp.z/91)
end

function get_bseed2(minp)
        return wseed + math.floor(87*minp.x/47) + math.floor(73*minp.z/91) + math.floor(31*minp.y/12)
end

local function add_leaves(data, vi, c_leaves, c_snow)
        if data[vi]==c_air or data[vi]==c_ignore or data[vi] == c_snow then
                data[vi] = c_leaves
        end
end

dofile(minetest.get_modpath(minetest.get_current_modname()).."/we.lua")
dofile(minetest.get_modpath(minetest.get_current_modname()).."/rotate.lua")
dofile(minetest.get_modpath(minetest.get_current_modname()).."/buildings.lua")
dofile(minetest.get_modpath(minetest.get_current_modname()).."/villages.lua")

function get_biome_table(minp, humidity, temperature, range)
        if range == nil then range = 1 end
        local l = {}
        for xi = -range, range do
        for zi = -range, range do
                local mnp, mxp = {x=minp.x+xi*80,z=minp.z+zi*80}, {x=minp.x+xi*80+80,z=minp.z+zi*80+80}
                local pr = PseudoRandom(get_bseed(mnp))
                local bxp, bzp = pr:next(mnp.x, mxp.x), pr:next(mnp.z, mxp.z)
                local h, t = humidity:get2d({x=bxp, y=bzp}), temperature:get2d({x=bxp, y=bzp})
                l[#l+1] = {x=bxp, z=bzp, h=h, t=t}
        end
        end
        return l
end

local function get_distance(x1, x2, z1, z2)
        return (x1-x2)*(x1-x2)+(z1-z2)*(z1-z2)
end

function get_nearest_biome(biome_table, x, z)
        local m = math.huge
        local k = 0
        for key, bdef in ipairs(biome_table) do
                local dist = get_distance(bdef.x, x, bdef.z, z)
                if dist<m then
                        m=dist
                        k=key
                end
        end
        return biome_table[k]
end

local function get_perlin_map(seed, octaves, persistance, scale, minp, maxp)
        local sidelen = maxp.x - minp.x +1
        local pm = minetest.get_perlin_map(
                {offset=0, scale=1, spread={x=scale, y=scale, z=scale}, seed=seed, octaves=octaves, persist=persistance},
                {x=sidelen, y=sidelen, z=sidelen}
        )
        return pm:get2dMap_flat({x = minp.x, y = minp.z, z = 0})
end

local function copytable(t)
        local t2 = {}
        for key, val in pairs(t) do
                t2[key] = val
        end
        return t2
end

local loot = {}
local all_items

minetest.after(0,function()
        all_items = minetest.registered_items
        -- fill the "loot" table conserning the rarity of the items
        for i,def in pairs(all_items) do        
           if not def.groups
           or (not def.groups.not_in_creative_inventory and not def.groups.not_in_craft_guide) then
                   if def.rarity then
                      for j=1,def.rarity do
                          table.insert(loot,def.name)
                      end
                   else
                       table.insert(loot,def.name)
                   end
           end
        end
end)


-- Func to get random element from a table
local function random_elem(array)
   return array[math.random(#array)]
end

local function mg_generate(minp, maxp, emin, emax, vm)
        local a = VoxelArea:new{
                MinEdge={x=emin.x, y=emin.y, z=emin.z},
                MaxEdge={x=emax.x, y=emax.y, z=emax.z},
        }

        local sidelen = maxp.x-minp.x+1
        local noise1raw = minetest.get_perlin(12345, 6, 0.5, 256)

        local vx,vz,vs,vh
        local exitloop = false
        for xi = -1, 1 do
            for zi = -1, 1 do
                vx,vz,vs,vh = village_at_point({x=minp.x+xi*80,z=minp.z+zi*80}, noise1raw)
                if vs ~= 0 then
                   exitloop = true
                   break
               end
            end
            if exitloop then break end
        end

        local fnd
        for k=1,#vvvg do
            if vvvg[k].vx==vx and vvvg[k].vz==vz then
               fnd=true
               return
            end
        end

        if not fnd then
           table.insert(vvvg,{vx=vx,vz=vz})
           save_villages()
        end

        local pr = PseudoRandom(get_bseed(minp))
        local village_noise = minetest.get_perlin(7635, 3, 0.5, 16)
        local data = vm:get_data()
        local ni = 1
        local humidity
        local temperature
        local villages_to_grow = {}
        local ni = 0

        local va = VoxelArea:new{MinEdge=minp, MaxEdge=maxp}
        if vh<1 then vh = 1 end
        local to_add = generate_village(vx, vz, vs, vh, minp, maxp, data, a, village_noise, villages_to_grow)
        if not to_add or #to_add<1 then return end

        -- a village has spawned at: vx, vz

        vm:set_data(data)
        vm:calc_lighting({x=minp.x-16, y=minp.y, z=minp.z-16}, {x=maxp.x+16, y=maxp.y, z=maxp.z+16})
        vm:write_to_map(data)
        vm:update_map()

        local meta
        local bed = false
        for _, n in pairs(to_add) do
            if minetest.get_content_id(n.node.name) ~= c_ignore then
               minetest.set_node(n.pos, n.node)
               if n.meta ~= nil then
                  meta = minetest.get_meta(n.pos)
                  if n.meta.formspec then n.meta.formspec = nil end
                  if n.node.name == "default:chest" then
                     local inv = meta:get_inventory()
                     local items = inv:get_list("main")
                     -- every chest may contain up to numitems items
                     local numitems = pr:next(0, 5)
                     for i=1,numitems do
                         local itemname = random_elem(loot)
                         local stack = ItemStack(itemname)
                         if not minetest.registered_items[itemname].tool_capabilities then                            
                            stack:set_count(math.random(0,10))
                         else
                             local wear = math.random()*65000 -- never get a new item                             
                             stack:set_wear(wear)                         
                         end
                         local size = inv:get_size("main")
                         local ind = pr:next(1, size)
                         while not inv:get_stack("main",ind):is_empty() do
                               ind = pr:next(1, size)
                            end
                         inv:set_stack("main", ind, stack)
                     end
                  end
                end
            end
        end
end

minetest.register_on_generated(function(minp, maxp, seed)
   local vm,emin,emax = minetest.get_mapgen_object('voxelmanip')
   mg_generate(minp, maxp, emin, emax, vm)
end)

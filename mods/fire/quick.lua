local D = 1

local function get_area_p0p1(pos)
        local p0 = {
           x=pos.x-D,
           y=pos.y-D,
           z=pos.z-D,
        }
        local p1 = {
           x=pos.x+D,
           y=pos.y+D,
           z=pos.z+D,
        }
        return p0, p1
end

local maxNewFlames = 0x400
local newFlames = 0

local function resetFlames()
   newFlames = 0
   minetest.after(2,resetFlames)
end
resetFlames()

-- Ignite neighboring nodes

function spreadFlames(p0)
   if minetest.setting_getbool("fire") then
      if newFlames < maxNewFlames then
         newFlames = newFlames + 1
         local minp,maxp = get_area_p0p1(p0)
         local nearby = minetest.env:find_nodes_in_area(minp,maxp,"group:flammable")
         for n,pos in pairs(nearby) do
            minetest.env:set_node(pos,{name="fire:quick_flame"})
         end
         minetest.env:remove_node(p0)
      end
   else
      minetest.env:remove_node(p0)
   end
end

minetest.register_node("fire:quick_flame", {
	description = "Fire",
	drawtype = "glasslike",
	tile_images = {"fire_quick_flame.png"},
	light_source = 14,
	groups = {dig_immediate=3},
	drop = 'fire:quick_flame',
	walkable = false,
})

-- Ignite neighboring nodes
minetest.register_abm(
   {
      nodenames = {"fire:quick_flame"},
      interval = 1 ,
      chance = 1,
      action = spreadFlames,
})

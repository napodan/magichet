minetest.register_node("voltbuild:geothermal_generator",{description="Geothermal Generator",
	groups={energy=1,cracky=2},
	tiles = {"voltbuild_geothermal_generator_side.png"},
	documentation={summary="Generates electricity from lava nodes directly next to this machine.\n"..
		"More lava nodes surrounding it help generate electricity faster."},
	voltbuild = {max_energy=15,max_tier=1,max_stress=2000,optime=5.0, 
		energy_type_image = "default_lava.png", psize = 3,
		speed = function (pos)
		local meta=minetest.env:get_meta(pos)
		local prod = 0
		for x = pos.x-1, pos.x+1 do
		for y = pos.y-1+math.abs(pos.x-x), pos.y+1-math.abs(pos.x-x) do
		for z = pos.z-1+math.min(math.abs(pos.x-x)+math.abs(pos.y-y),1), 
			pos.z+1-math.min(math.abs(pos.x-x)+math.abs(pos.y-y),1) do
			local n = minetest.env:get_node({x=x,y=y,z=z})
			if n.name == "default:lava_source" or n.name == "default:lava_flowing" then
				prod = prod+1
			end
		end
		end
		end
		return prod
		end},
	on_construct = function(pos)
		local meta = minetest.env:get_meta(pos)
		meta:set_int("energy",0)
		meta:set_int("energyf",0)
		meta:set_string("formspec", generators.get_formspec(pos)..
				"image["..voltbuild.image_location.."default_lava.png]")
		generators.on_construct(pos)
	end,
	can_dig = generators.can_dig,
	allow_metadata_inventory_put = voltbuild.allow_metadata_inventory_put,
	allow_metadata_inventory_move = voltbuild.allow_metadata_inventory_move,
})

components.register_abm({
	nodenames={"voltbuild:geothermal_generator"},
	interval=1.0,
	chance=1,
	action = voltbuild.generation_abm,
})

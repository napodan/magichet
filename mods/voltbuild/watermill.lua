minetest.register_node("voltbuild:watermill",{description="Watermill",
	groups={energy=1,cracky=2},
	tiles={"itest_watermill_top.png", "itest_watermill_top.png", "itest_watermill_side.png"},
	documentation={summary="Generates electricity from water nodes near this machine.\n"..
		"More water nodes surrounding it help generate electricity faster."},
	voltbuild = {max_energy=5,max_tier=1,max_stress=2000,optime=52.0, energy_type_image = "voltbuild_water.png", psize = 1,
		speed = function (pos)
		local meta=minetest.env:get_meta(pos)
		local prod = 0
		for x = pos.x-1, pos.x+1 do
		for y = pos.y-1, pos.y+1 do
		for z = pos.z-1, pos.z+1 do
			local n = minetest.env:get_node({x=x,y=y,z=z})
			if n.name == "default:water_source" or n.name == "default:water_flowing" then
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
				"image["..voltbuild.image_location.."voltbuild_water.png]")
		generators.on_construct(pos)
	end,
	can_dig = generators.can_dig,
	allow_metadata_inventory_put = voltbuild.allow_metadata_inventory_put,
	allow_metadata_inventory_move = voltbuild.allow_metadata_inventory_move,
})

components.register_abm({
	nodenames={"voltbuild:watermill"},
	interval=1.0,
	chance=1,
	action = voltbuild.generation_abm,
})

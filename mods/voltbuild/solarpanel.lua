minetest.register_node("voltbuild:solar_panel",{description="Solar panel",
	groups={energy=1,cracky=2},
	tiles={"itest_solar_panel_top.png", "itest_solar_panel_side.png", "itest_solar_panel_side.png"},
	documentation = {summary = "Machine that generates electricity when out in the sun."},
	voltbuild = {max_energy=500,max_tier=1,max_stress=2000,active=true, energy_type_image="itest_sun.png", psize = 1,
		speed = function (pos)
			local l=minetest.env:get_node_light({x=pos.x, y=pos.y+1, z=pos.z})
			local meta=minetest.env:get_meta(pos)
			if not l or l < 15 then
				return 0
			else
				return 1
			end
		end},
	on_construct = function(pos)
		local meta = minetest.env:get_meta(pos)
		meta:set_int("energy",0)
		meta:set_string("formspec", generators.get_formspec(pos)..
				"image["..voltbuild.image_location.."itest_sun.png]")
		generators.on_construct(pos)
	end,
	can_dig = generators.can_dig,
	allow_metadata_inventory_put =  voltbuild.allow_metadata_inventory_put,
	allow_metadata_inventory_move = voltbuild.allow_metadata_inventory_move,
})

components.register_abm({
	nodenames={"voltbuild:solar_panel"},
	interval=1.0,
	chance=1,
	action = voltbuild.generation_abm,
})

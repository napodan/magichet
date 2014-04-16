minetest.register_node("voltbuild:batbox",{description="BatBox",
	groups={energy=1, cracky=2, energy_consumer=1, energy_storage=1},
	paramtype2 = "facedir",
	legacy_facedir_simple = true,
	tiles={"itest_batbox_side.png", "itest_batbox_side.png", "itest_batbox_output.png", "itest_batbox_side.png", "itest_batbox_side.png", "itest_batbox_side.png"},
	voltbuild = {max_energy = 3000, max_psize = 32, max_tier=1,
		max_stress=2000,active=true},
	documentation = {summary="Low voltage energy storage for later use."},
	on_construct = function(pos)
		local meta = minetest.env:get_meta(pos)
		meta:set_int("energy",0)
		meta:set_string("formspec", storage.get_formspec(pos))
		storage.on_construct(pos)
	end,
	can_dig = storage.can_dig,
	allow_metadata_inventory_put = voltbuild.allow_metadata_inventory_put,
	allow_metadata_inventory_move = voltbuild.allow_metadata_inventory_move,
})

components.register_abm({
	nodenames={"voltbuild:batbox"},
	interval=1.0,
	chance=1,
	action = storage.abm
})

minetest.register_node("voltbuild:mfe_unit",{description="MFE Unit",
	groups={energy=1, cracky=2, energy_consumer=1, energy_storage=1},
	paramtype2 = "facedir",
	legacy_facedir_simple = true,
	tiles={"itest_mfe_side.png", "itest_mfe_side.png", "itest_mfe_output.png", "itest_mfe_side.png", "itest_mfe_side.png", "itest_mfe_side.png"},
	voltbuild = {max_energy = 24000, max_psize = 128, max_tier=2,max_stress=2000,
		active=true},
	documentation = {summary="Medium voltage energy storage for later use."},
	on_construct = function(pos)
		local meta = minetest.env:get_meta(pos)
		meta:set_int("energy",0)
		meta:set_string("formspec", storage.get_formspec(pos))
		storage.on_construct(pos)
	end,
	can_dig = storage.can_dig,
	allow_metadata_inventory_put = voltbuild.allow_metadata_inventory_put,
	allow_metadata_inventory_move = voltbuild.allow_metadata_inventory_move,
})

components.register_abm({
	nodenames={"voltbuild:mfe_unit"},
	interval=1.0,
	chance=1,
	action = storage.abm
})

minetest.register_node("voltbuild:mfs_unit",{description="MFS Unit",
	groups={energy=1, cracky=2, energy_consumer=1, energy_storage=1},
	paramtype2 = "facedir",
	legacy_facedir_simple = true,
	tiles={"itest_mfsu_side.png", "itest_mfsu_side.png", "itest_mfsu_output.png", "itest_mfsu_side.png", "itest_mfsu_side.png", "itest_mfsu_side.png"},
	voltbuild = {max_energy = 240000, max_psize = 512,max_tier=3,max_stress=2000,
		active=true},
	documentation = {summary="High voltage energy storage for later use."},
	on_construct = function(pos)
		local meta = minetest.env:get_meta(pos)
		meta:set_int("energy",0)
		meta:set_string("formspec", storage.get_formspec(pos))
		storage.on_construct(pos)
	end,
	can_dig = storage.can_dig,
	allow_metadata_inventory_put = voltbuild.allow_metadata_inventory_put,
	allow_metadata_inventory_move = voltbuild.allow_metadata_inventory_move,
})

components.register_abm({
	nodenames={"voltbuild:mfs_unit"},
	interval=1.0,
	chance=1,
	action = storage.abm
})


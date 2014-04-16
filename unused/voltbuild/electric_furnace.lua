voltbuild.recipes.cooking = {}
voltbuild.recipes.cooking.__index = function (table,key)
	return function(c)
		local produced,after_produced = minetest.get_craft_result({method = "cooking", width = 1, items=c.items})
		return produced,after_produced
	end
end
setmetatable(voltbuild.recipes.cooking,voltbuild.recipes.cooking)

local electric_furnace = {
	description = "Electric furnace",
	tiles = {"itest_electric_furnace_side.png", "itest_electric_furnace_side.png", "itest_electric_furnace_side.png", "itest_electric_furnace_side.png", "itest_electric_furnace_side.png", "itest_electric_furnace_front.png"},
	paramtype2 = "facedir",
	groups = {energy=1, energy_consumer=1, cracky=2,tubedevice=1,tubedevice_receiver=1},
	legacy_facedir_simple = true,
	sounds = default.node_sound_stone_defaults(),
	voltbuild = {max_tier=1,energy_cost=2,max_stress=2000,max_psize=32,max_energy=12},
	documentation = {summary = "An electric version of the furnace. No coal required! Just electricity."},
	cooking_method="cooking",
	tube = consumers.tube,
	on_construct = function(pos)
		local meta = minetest.env:get_meta(pos)
		meta:set_int("energy",0)
		local inv = meta:get_inventory()
		inv:set_size("src", 1)
		inv:set_size("dst", 4)
		meta:set_string("formspec", consumers.get_formspec(pos)..
				voltbuild.production_spec)
		consumers.on_construct(pos)
	end,
	can_dig = function(pos,player)
		local meta = minetest.env:get_meta(pos)
		local inv = meta:get_inventory()
		return inv:is_empty("src") and inv:is_empty("dst") and
			consumers.can_dig(pos,player)
	end,
	allow_metadata_inventory_put = voltbuild.allow_metadata_inventory_put,
	allow_metadata_inventory_move = voltbuild.allow_metadata_inventory_move,
}
if pipeworks_path then
	electric_furnace.after_place_node = function (pos)
		tube_scanforobjects(pos)
	end
	electric_furnace.after_dig_node = function(pos)
		tube_scanforobjects(pos)
	end
end
minetest.register_node("voltbuild:electric_furnace", electric_furnace)

local active_furnace = {
	drop = "voltbuild:electric_furnace", 
	groups={not_in_creative_inventory=1},
	tiles = {"itest_electric_furnace_side.png", "itest_electric_furnace_side.png", 
		"itest_electric_furnace_side.png", "itest_electric_furnace_side.png", 
		"itest_electric_furnace_side.png", "itest_electric_furnace_front_active.png"}
}
active_furnace = voltbuild.deep_copy(electric_furnace,active_furnace)
minetest.register_node("voltbuild:electric_furnace_active", active_furnace)

components.register_abm({
	nodenames = {"voltbuild:electric_furnace","voltbuild:electric_furnace_active"},
	interval = 1.0,
	chance = 1,
	action = voltbuild.production_abm,
})

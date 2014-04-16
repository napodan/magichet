voltbuild.recipes.compressing = {}
compressor_recipes = voltbuild.recipes.compressing
compressor = {}

function compressor.register_compressor_recipe(string1,string2)
	voltbuild.register_machine_recipe(string1,string2,"compressing")
end
compressor.get_craft_result = voltbuild.get_craft_result


local compressor_properties = {
	description = "compressor",
	tiles = {"itest_compressor_side.png", "itest_compressor_side.png", "itest_compressor_side.png",
		"itest_compressor_side.png", "itest_compressor_side.png", "itest_compressor_front.png"},
	paramtype2 = "facedir",
	groups = {energy=1, energy_consumer=1, cracky=2,tubedevice=1,tubedevice_receiver=1},
	legacy_facedir_simple = true,
	sounds = default.node_sound_stone_defaults(),
	voltbuild = {max_tier=1,energy_cost=2,max_stress=2000,max_energy=12,max_psize=32},
	documentation = {summary="Machine that uses compression to craft other items."},
	cooking_method="compressing",
	tube = consumers.tube,
	on_construct = function(pos)
		local meta = minetest.env:get_meta(pos)
		meta:set_int("energy",0)
		local inv = meta:get_inventory()
		inv:set_size("src", 1)
		inv:set_size("dst", 4)
		meta:set_string("formspec", consumers.get_formspec(pos)..
				voltbuild.production_spec..
				consumers.get_progressbar(0,1,
					"itest_compressor_progress_bg.png",
					"itest_compressor_progress_fg.png"))
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
	compressor_properties.after_place_node = function (pos)
		tube_scanforobjects(pos)
	end
	compressor_properties.after_dig_node = function(pos)
		tube_scanforobjects(pos)
	end
end
minetest.register_node("voltbuild:compressor", compressor_properties)
local active_compressor= {
	drop = "voltbuild:compressor", 
	tiles = {"itest_compressor_side.png", "itest_compressor_side.png", "itest_compressor_side.png",
		"itest_compressor_side.png", "itest_compressor_side.png", "itest_compressor_front_active.png"},
	groups={not_in_creative_inventory=1},
}
active_compressor = voltbuild.deep_copy(compressor_properties,active_compressor)
minetest.register_node("voltbuild:compressor_active", active_compressor)

components.register_abm({
	nodenames = {"voltbuild:compressor","voltbuild:compressor_active"},
	interval = 1.0,
	chance = 1,
	action=voltbuild.production_abm,
})

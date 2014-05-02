voltbuild.recipes.extracting = {}
extractor_recipes = voltbuild.recipes.extracting
extractor = {}

function extractor.register_extractor_recipe(string1,string2)
	voltbuild.register_machine_recipe(string1,string2,"extracting")
end
extractor.get_craft_result = voltbuild.get_craft_result
function extractor.register_function_recipe(string1,func)
	voltbuild.register_function_recipe(string1,func,"extracting")
end

local extractor_properties = {
	description = "Extractor",
	tiles = {"itest_extractor_side.png", "itest_extractor_side.png", "itest_extractor_side.png", "itest_extractor_side.png", "itest_extractor_side.png", "itest_extractor_front.png"},
	paramtype2 = "facedir",
	groups = {energy=1, energy_consumer=1, cracky=2,tubedevice=1,tubedevice_receiver=1},
	legacy_facedir_simple = true,
	sounds = default.node_sound_stone_defaults(),
	voltbuild = {max_tier=1,energy_cost=2,max_stress=2000,max_psize=32,max_energy=12},
	cooking_method = "extracting",
	documentation = {summary="Machine that uses extraction to craft other items.\n"..
		"Much more effective at making rubber than a furnace is."},
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
					"itest_extractor_progress_bg.png",
					"itest_extractor_progress_fg.png"))
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
	extractor_properties.after_place_node = function (pos)
		tube_scanforobjects(pos)
	end
	extractor_properties.after_dig_node = function(pos)
		tube_scanforobjects(pos)
	end
end
minetest.register_node("voltbuild:extractor", extractor_properties)
local active_extractor= {
	drop = "voltbuild:extractor", 
	tiles = {"itest_extractor_side.png", "itest_extractor_side.png", "itest_extractor_side.png",
		"itest_extractor_side.png", "itest_extractor_side.png", "itest_extractor_front_active.png"},
	groups={not_in_creative_inventory=1},
}
active_extractor = voltbuild.deep_copy(extractor_properties,active_extractor)
minetest.register_node("voltbuild:extractor_active", active_extractor)

components.register_abm({
	nodenames = {"voltbuild:extractor","voltbuild:extractor_active"},
	interval = 1.0,
	chance = 1,
	action=voltbuild.production_abm,
})

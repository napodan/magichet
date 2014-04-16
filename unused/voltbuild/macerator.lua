voltbuild.recipes.grinding= {}
macerator_recipes = voltbuild.recipes.grinding
macerator = {}

function macerator.register_macerator_recipe(string1,string2)
	voltbuild.register_machine_recipe(string1,string2,"grinding")
end
macerator.get_craft_result=voltbuild.get_craft_result

local macerator_properties = {
	description = "Macerator",
	tiles = {"itest_macerator_side.png", "itest_macerator_side.png", "itest_macerator_side.png",
		"itest_macerator_side.png", "itest_macerator_side.png", "itest_macerator_front.png"},
	paramtype2 = "facedir",
	groups = {energy=1, energy_consumer=1, cracky=2,tubedevice=1,tubedevice_receiver=1},
	legacy_facedir_simple = true,
	sounds = default.node_sound_stone_defaults(),
	voltbuild = {max_energy=12,max_tier=1,energy_cost=2,max_stress=2000,speed=5,max_psize=32},
	documentation = {summary="Machine that uses grinding to craft other items.\n"..
		"Much more efficient to place ores in this machine first before cooking the ores."},
	cooking_method="grinding",
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
					"itest_macerator_progress_bg.png",
					"itest_macerator_progress_fg.png"))
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
	macerator_properties.after_place_node = function (pos)
		tube_scanforobjects(pos)
	end
	macerator_properties.after_dig_node = function(pos)
		tube_scanforobjects(pos)
	end
end
minetest.register_node("voltbuild:macerator",macerator_properties) 
local active_macerator = {
	drop = "voltbuild:macerator", 
	groups={not_in_creative_inventory=1},
	tiles = {"itest_macerator_side.png", "itest_macerator_side.png", "itest_macerator_side.png",
		"itest_macerator_side.png", "itest_macerator_side.png", "itest_macerator_front_active.png"},
}
active_macerator = voltbuild.deep_copy(macerator_properties,active_macerator)
minetest.register_node("voltbuild:macerator_active",active_macerator) 

components.register_abm({
	nodenames = {"voltbuild:macerator","voltbuild:macerator_active"},
	interval = 1.0,
	chance = 1,
	action=voltbuild.production_abm
})

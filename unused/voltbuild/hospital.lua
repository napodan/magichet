minetest.register_craftitem("voltbuild:medpack", {
	description = "Medpack",
	inventory_image = "voltbuild_medpack.png",
	on_place = minetest.item_eat(8, "default:glass 4"),
})

minetest.register_node("voltbuild:hospital", {
	description = "Hospital",
	tiles = {"voltbuild_hospital_top.png","voltbuild_hospital_bottom.png","voltbuild_hospital_side.png",
		"voltbuild_hospital_side.png","voltbuild_hospital_back.png","voltbuild_hospital_front.png"},
	paramtype2 = "facedir",
	groups = {energy=1,energy_consumer=1,cracky=2},
	legacy_facedir_simple = true,
	sounds = default.node_sound_stone_defaults(),
	voltbuild = {max_tier=2,energy_cost=40,max_stress=2000,max_energy=120,max_psize=128,optime=10.0},
	documentation = {summary = "A building that heals nearby players when powered."},
	on_construct = function(pos)
		local meta = minetest.env:get_meta(pos)
		meta:set_int("energy",0)
		local inv = meta:get_inventory()
		meta:set_string("formspec", consumers.get_formspec(pos)..
				consumers.get_progressbar(0,1,
					"itest_macerator_progress_bg.png",
					"itest_macerator_progress_fg.png"))
		consumers.on_construct(pos)
	end,
	can_dig = voltbuild.can_dig,
	allow_metadata_inventory_put = voltbuild.allow_metadata_inventory_put,
	allow_metadata_inventory_move = voltbuild.allow_metadata_inventory_move,
})

components.register_abm({
	nodenames = {"voltbuild:hospital"},
	interval = 1.0,
	chance = 1,
	action = function (pos,node,active_object_count,active_object_count_wider)
		local meta = minetest.env:get_meta(pos)
		local energy = meta:get_int("energy")
		local energy_cost = minetest.registered_nodes[node.name]["voltbuild"]["energy_cost"]
		local hp_max = 20

		if meta:get_string("stime") == "" then
			meta:set_float("stime",0)
		end

		if meta:get_string("active") == "" then
			meta:set_int("active",0)
		end

		local heal_time = minetest.registered_nodes[node.name]["voltbuild"]["optime"]
		local objects = minetest.get_objects_inside_radius(pos,3)
		local players = {}
		for k,object in pairs(objects) do
			if object:is_player() and object:get_hp() < hp_max then
				table.insert(players,object)
			end
		end
		if next(players) and energy >= energy_cost then
			meta:set_float("stime",meta:get_float("stime")+1.0)
			meta:set_int("active",1)
		else
			meta:set_int("active",0)
		end
		while meta:get_float("stime") > heal_time and energy >= energy_cost do
			meta:set_float("stime",meta:get_float("stime")-heal_time)
			meta:set_int("energy",meta:get_int("energy")-energy_cost)
			for k,player in pairs(players) do
				player:set_hp(player:get_hp()+5)
			end
		end
		meta:set_string("formspec", consumers.get_formspec(pos)..
				consumers.get_progressbar(meta:get_float("stime"),
					heal_time,
					"itest_extractor_progress_bg.png",
					"itest_extractor_progress_fg.png"))
	end,
})

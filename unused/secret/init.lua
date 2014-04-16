--Mod by artur99
--Contact: david1989mail@yahoo.com / david1989mail@yahoo.com / artur99.hostyd.com
--Finished working on 3.28.2013
--Version:0.3
--Download link: http://minetest.artur99.hostyd.com/secret/downloadv03.php

minetest.register_craft({
	output = 'secret:secret 3',
	recipe = {
		{'default:glass', 'default:sand', 'default:glass'},
		{'', 'default:glass', ''},
		{'', 'default:torch', ''},	}})
minetest.register_node("secret:secret", {		description = "Secret Essence",
	tiles = {"secret.png"},
	inventory_image = ("secret.png"),
	groups = {snappy=2,choppy=2,oddly_breakable_by_hand=2},})








minetest.register_node("secret:chestwood", {		description = "Secret Chest - Wood",
	tiles = {"default_wood.png"},
	inventory_image = ("woodsecretchest.png"),
	groups = {snappy=2,choppy=2,oddly_breakable_by_hand=2},
	on_construct = function(pos)
	local meta = minetest.env:get_meta(pos)
	meta:set_string("formspec",
				"size[8,9]"..
				"list[current_name;main;0,0;8,4;]"..
				"list[current_player;main;0,5;8,4;]")

		local inv = meta:get_inventory()
		inv:set_size("main", 8*4)	end,
	can_dig = function(pos,player)
		local meta = minetest.env:get_meta(pos);
		local inv = meta:get_inventory()
		return inv:is_empty("main")	end,
	on_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
		minetest.log("action", player:get_player_name()..
				" moves stuff in chest at "..minetest.pos_to_string(pos))	end,
    on_metadata_inventory_put = function(pos, listname, index, stack, player)
		minetest.log("action", player:get_player_name()..
				" moves stuff to chest at "..minetest.pos_to_string(pos))
	end,
    on_metadata_inventory_take = function(pos, listname, index, stack, player)
		minetest.log("action", player:get_player_name()..
				" takes stuff from chest at "..minetest.pos_to_string(pos))
	end,
})




minetest.register_craft({
	output = 'secret:chestwood',
	recipe = {
		{'secret:secret', 'default:chest', 'secret:secret'},
		{'default:wood', 'default:wood', 'default:wood'},
		{'', '', ''},
	}
})
--Secret Chest - Wood








--Secret Chest - Cobblestone
minetest.register_craft({
	output = 'secret:chestcobble',
	recipe = {
		{'secret:secret', 'default:chest', 'secret:secret'},
		{'default:cobble', 'default:cobble', 'default:cobble'},
		{'', '', ''},}})

minetest.register_node("secret:chestcobble", {		description = "Secret Chest - Cobblestone",
	tiles = {"default_cobble.png"},
	inventory_image = ("cobblesecretchest.png"),
	groups = {snappy=2,choppy=2,oddly_breakable_by_hand=2},
	on_construct = function(pos)
	local meta = minetest.env:get_meta(pos)
	meta:set_string("formspec",
				"size[8,9]"..
				"list[current_name;main;0,0;8,4;]"..
				"list[current_player;main;0,5;8,4;]")

		local inv = meta:get_inventory()
		inv:set_size("main", 8*4)	end,
	can_dig = function(pos,player)
		local meta = minetest.env:get_meta(pos);
		local inv = meta:get_inventory()
		return inv:is_empty("main")	end,
	on_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
		minetest.log("action", player:get_player_name()..
				" moves stuff in chest at "..minetest.pos_to_string(pos))	end,
    on_metadata_inventory_put = function(pos, listname, index, stack, player)
		minetest.log("action", player:get_player_name()..
				" moves stuff to chest at "..minetest.pos_to_string(pos))
	end,
    on_metadata_inventory_take = function(pos, listname, index, stack, player)
		minetest.log("action", player:get_player_name()..
				" takes stuff from chest at "..minetest.pos_to_string(pos))
	end,
})
--Secret Chest - Cobblestone End







--Secret Chest - Stone
minetest.register_craft({
	output = 'secret:cheststone',
	recipe = {
		{'secret:secret', 'default:chest', 'secret:secret'},
		{'default:stone', 'default:stone', 'default:stone'},
		{'', '', ''},}})

minetest.register_node("secret:cheststone", {		description = "Secret Chest - Stone",
	tiles = {"default_stone.png"},
	inventory_image = ("stonesecretchest.png"),
	groups = {snappy=2,choppy=2,oddly_breakable_by_hand=2},
	on_construct = function(pos)
	local meta = minetest.env:get_meta(pos)
	meta:set_string("formspec",
				"size[8,9]"..
				"list[current_name;main;0,0;8,4;]"..
				"list[current_player;main;0,5;8,4;]")

		local inv = meta:get_inventory()
		inv:set_size("main", 8*4)	end,
	can_dig = function(pos,player)
		local meta = minetest.env:get_meta(pos);
		local inv = meta:get_inventory()
		return inv:is_empty("main")	end,
	on_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
		minetest.log("action", player:get_player_name()..
				" moves stuff in chest at "..minetest.pos_to_string(pos))	end,
    on_metadata_inventory_put = function(pos, listname, index, stack, player)
		minetest.log("action", player:get_player_name()..
				" moves stuff to chest at "..minetest.pos_to_string(pos))
	end,
    on_metadata_inventory_take = function(pos, listname, index, stack, player)
		minetest.log("action", player:get_player_name()..
				" takes stuff from chest at "..minetest.pos_to_string(pos))
	end,
})









minetest.register_craft({
	output = 'secret:chestsand',
	recipe = {
		{'secret:secret', 'default:chest', 'secret:secret'},
		{'default:sand', 'default:sand', 'default:sand'},
		{'', '', ''},}})

minetest.register_node("secret:chestsand", {		description = "Secret Chest - Sand",
	tiles = {"default_sand.png"},
	inventory_image = ("sandsecretchest.png"),
	groups = {snappy=2,choppy=2,oddly_breakable_by_hand=2},
	on_construct = function(pos)
	local meta = minetest.env:get_meta(pos)
	meta:set_string("formspec",
				"size[8,9]"..
				"list[current_name;main;0,0;8,4;]"..
				"list[current_player;main;0,5;8,4;]")

		local inv = meta:get_inventory()
		inv:set_size("main", 8*4)	end,
	can_dig = function(pos,player)
		local meta = minetest.env:get_meta(pos);
		local inv = meta:get_inventory()
		return inv:is_empty("main")	end,
	on_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
		minetest.log("action", player:get_player_name()..
				" moves stuff in chest at "..minetest.pos_to_string(pos))	end,
    on_metadata_inventory_put = function(pos, listname, index, stack, player)
		minetest.log("action", player:get_player_name()..
				" moves stuff to chest at "..minetest.pos_to_string(pos))
	end,
    on_metadata_inventory_take = function(pos, listname, index, stack, player)
		minetest.log("action", player:get_player_name()..
				" takes stuff from chest at "..minetest.pos_to_string(pos))
	end,
})







--Secret Chest - Glass
minetest.register_node("secret:chestglass", {
	description = "Secret Chest - Glass",
	drawtype = "glasslike",
	tiles = {"default_glass.png"},
	inventory_image = ("glasssecretchest.png"),
	paramtype = "light",
	sunlight_propagates = true,
	is_ground_content = true,
	sounds = default.node_sound_glass_defaults(),
	groups = {snappy=2,choppy=2,oddly_breakable_by_hand=2},
	on_construct = function(pos)
	local meta = minetest.env:get_meta(pos)
	meta:set_string("formspec",
				"size[8,9]"..
				"list[current_name;main;0,0;8,4;]"..
				"list[current_player;main;0,5;8,4;]")

		local inv = meta:get_inventory()
		inv:set_size("main", 8*4)	end,
	can_dig = function(pos,player)
		local meta = minetest.env:get_meta(pos);
		local inv = meta:get_inventory()
		return inv:is_empty("main")	end,
	on_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
		minetest.log("action", player:get_player_name()..
				" moves stuff in chest at "..minetest.pos_to_string(pos))	end,
    on_metadata_inventory_put = function(pos, listname, index, stack, player)
		minetest.log("action", player:get_player_name()..
				" moves stuff to chest at "..minetest.pos_to_string(pos))
	end,
    on_metadata_inventory_take = function(pos, listname, index, stack, player)
		minetest.log("action", player:get_player_name()..
				" takes stuff from chest at "..minetest.pos_to_string(pos))
	end,
})
minetest.register_craft({
	output = 'secret:chestglass',
	recipe = {
		{'secret:secret', 'default:chest', 'secret:secret'},
		{'default:glass', 'default:glass', 'default:glass'},
		{'', '', ''},}})








minetest.register_craft({
	output = 'secret:chestdirt',
	recipe = {
		{'secret:secret', 'default:chest', 'secret:secret'},
		{'default:dirt', 'default:dirt', 'default:dirt'},
		{'', '', ''},}})
minetest.register_node("secret:chestdirt", {		description = "Secret Chest - Dirt",
	tiles = {"default_dirt.png"},
	inventory_image = ("dirtsecretchest.png"),
	groups = {snappy=2,choppy=2,oddly_breakable_by_hand=2},
	on_construct = function(pos)
	local meta = minetest.env:get_meta(pos)
	meta:set_string("formspec",
				"size[8,9]"..
				"list[current_name;main;0,0;8,4;]"..
				"list[current_player;main;0,5;8,4;]")
	
		local inv = meta:get_inventory()
		inv:set_size("main", 8*4)	end,
	can_dig = function(pos,player)
		local meta = minetest.env:get_meta(pos);
		local inv = meta:get_inventory()
		return inv:is_empty("main")	end,
	on_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
		minetest.log("action", player:get_player_name()..
				" moves stuff in chest at "..minetest.pos_to_string(pos))	end,
    on_metadata_inventory_put = function(pos, listname, index, stack, player)
		minetest.log("action", player:get_player_name()..
				" moves stuff to chest at "..minetest.pos_to_string(pos))
	end,
    on_metadata_inventory_take = function(pos, listname, index, stack, player)
		minetest.log("action", player:get_player_name()..
				" takes stuff from chest at "..minetest.pos_to_string(pos))
	end,
})











minetest.register_craft({
	output = 'secret:chestbrick',
	recipe = {
		{'secret:secret', 'default:chest', 'secret:secret'},
		{'default:brick', 'default:brick', 'default:brick'},
		{'', '', ''},}})
minetest.register_node("secret:chestbrick", {		description = "Secret Chest - Brick",
	tiles = {"default_brick.png"},
	inventory_image = ("bricksecretchest.png"),
	groups = {snappy=2,choppy=2,oddly_breakable_by_hand=2},
	on_construct = function(pos)
	local meta = minetest.env:get_meta(pos)
	meta:set_string("formspec",
				"size[8,9]"..
				"list[current_name;main;0,0;8,4;]"..
				"list[current_player;main;0,5;8,4;]")
	
		local inv = meta:get_inventory()
		inv:set_size("main", 8*4)	end,
	can_dig = function(pos,player)
		local meta = minetest.env:get_meta(pos);
		local inv = meta:get_inventory()
		return inv:is_empty("main")	end,
	on_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
		minetest.log("action", player:get_player_name()..
				" moves stuff in chest at "..minetest.pos_to_string(pos))	end,
    on_metadata_inventory_put = function(pos, listname, index, stack, player)
		minetest.log("action", player:get_player_name()..
				" moves stuff to chest at "..minetest.pos_to_string(pos))
	end,
    on_metadata_inventory_take = function(pos, listname, index, stack, player)
		minetest.log("action", player:get_player_name()..
				" takes stuff from chest at "..minetest.pos_to_string(pos))
	end,
})






--/////////////////////////////////////////////////////
--/////////////////////////////////////////////////////
--/////////////////////////////////////////////////////
--/////////////////////////////////////////////////////
--END OF FIRST PART////////////////////////////////////
--END OF SECRET CHESTS/////////////////////////////////






minetest.register_craft({
	output = 'secret:safedepositbox',
	recipe = {
		{'secret:secret', 'secret:secret', 'secret:secret'},
		{'secret:secret', 'default:chest', 'secret:secret'},
		{'secret:secret', 'secret:secret', 'secret:secret'},
}})

minetest.register_node("secret:safedepositbox", {
	description = "Safe Deposit Box",
	tiles = {"sdb.png", "sdb.png", "sdb.png",
		"sdb.png", "sdb.png", "sdbface.png"},
	inventory_image = minetest.inventorycube("sdb.png", "sdbface.png", "sdb.png",
		"sdb.png", "sdb.png", "sdb.png"),


	paramtype2 = "facedir",
	legacy_facedir_simple = true,
	groups = {snappy=2,choppy=2,oddly_breakable_by_hand=2},
	sounds = default.node_sound_wood_defaults(),
	after_place_node = function(pos, placer)
		local meta = minetest.env:get_meta(pos)
		meta:set_string("owner", placer:get_player_name() or "")
		meta:set_string("infotext", "Safe Deposit Box (owned by "..
				meta:get_string("owner")..")")
	end,
	on_construct = function(pos)
		local meta = minetest.env:get_meta(pos)
		meta:set_string("formspec",
				"size[8,9]"..
				"list[current_name;main;0,0;8,4;]"..
				"list[current_player;main;0,5;8,4;]")
		meta:set_string("infotext", "Locked Chest")
		meta:set_string("owner", "")
		local inv = meta:get_inventory()
		inv:set_size("main", 8*4)
	end,
	can_dig = function(pos,player)
		local meta = minetest.env:get_meta(pos);
		local inv = meta:get_inventory()
		return inv:is_empty("main")
	end,
	allow_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
		local meta = minetest.env:get_meta(pos)
		if not has_locked_chest_privilege(meta, player) then
			minetest.log("action", player:get_player_name()..
					" tried to access a locked chest belonging to "..
					meta:get_string("owner").." at "..
					minetest.pos_to_string(pos))
			return 0
		end
		return count
	end,
    allow_metadata_inventory_put = function(pos, listname, index, stack, player)
		local meta = minetest.env:get_meta(pos)
		if not has_locked_chest_privilege(meta, player) then
			minetest.log("action", player:get_player_name()..
					" tried to access a locked chest belonging to "..
					meta:get_string("owner").." at "..
					minetest.pos_to_string(pos))
			return 0
		end
		return stack:get_count()
	end,
    allow_metadata_inventory_take = function(pos, listname, index, stack, player)
		local meta = minetest.env:get_meta(pos)
		if not has_locked_chest_privilege(meta, player) then
			minetest.log("action", player:get_player_name()..
					" tried to access a locked chest belonging to "..
					meta:get_string("owner").." at "..
					minetest.pos_to_string(pos))
			return 0
		end
		return stack:get_count()
	end,
	on_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
		minetest.log("action", player:get_player_name()..
				" moves stuff in locked chest at "..minetest.pos_to_string(pos))
	end,
    on_metadata_inventory_put = function(pos, listname, index, stack, player)
		minetest.log("action", player:get_player_name()..
				" moves stuff to locked chest at "..minetest.pos_to_string(pos))
	end,
    on_metadata_inventory_take = function(pos, listname, index, stack, player)
		minetest.log("action", player:get_player_name()..
				" takes stuff from locked chest at "..minetest.pos_to_string(pos))
	end,
})








--/////////////////////////////////////////////////////
--/////////////////////////////////////////////////////
--/////////////////////////////////////////////////////
--/////////////////////////////////////////////////////
--END OF SECOND PART///////////////////////////////////
--END OF SAFE DEPOSIT BOX//////////////////////////////








minetest.register_craft({
	output = "secret:secretdoordirt 2",
	recipe = {
		{"secret:secret", "default:dirt", "secret:secret"},
		{"secret:secret", "default:dirt", "secret:secret"},
		{"secret:secret", "secret:secret", "secret:secret"},
	}
})

minetest.register_node("secret:secretdoordirt", {
	description = "Secret Door - Dirt",
	tiles = {"default_dirt.png"},
	inventory_image = ("dirtsecretdoor.png"),
	walkable = false,
	groups = {snappy=2,choppy=2,oddly_breakable_by_hand=2},
})
minetest.register_craft({
	output = "secret:secretdoorcobble 2",
	recipe = {
		{"secret:secret", "default:cobble", "secret:secret"},
		{"secret:secret", "default:cobble", "secret:secret"},
		{"secret:secret", "secret:secret", "secret:secret"},
	}
})

minetest.register_node("secret:secretdoorcobble", {
	description = "Secret Door - Cobblestone",
	tiles = {"default_cobble.png"},
	inventory_image = ("cobblesecretdoor.png"),
	walkable = false,
	groups = {snappy=2,choppy=2,oddly_breakable_by_hand=2},
})
minetest.register_craft({
	output = "secret:secretdoorgrass 2",
	recipe = {
		{"secret:secret", "default:leaves", "secret:secret"},
		{"secret:secret", "default:dirt", "secret:secret"},
		{"secret:secret", "secret:secret", "secret:secret"},
	}
})

minetest.register_node("secret:secretdoorgrass", {
	description = "Secret Door - Dirt with Grass",
	tiles = {"default_grass.png", "default_dirt.png", "default_dirt.png","default_dirt.png","default_dirt.png","default_dirt.png",},
	inventory_image = ("grasssecretdoor.png"),
	walkable = false,
	groups = {snappy=2,choppy=2,oddly_breakable_by_hand=2},
})
minetest.register_craft({
	output = "secret:secretdoorsand 2",
	recipe = {
		{"secret:secret", "default:sand", "secret:secret"},
		{"secret:secret", "default:sand", "secret:secret"},
		{"secret:secret", "secret:secret", "secret:secret"},
	}
})

minetest.register_node("secret:secretdoorsand", {
	description = "Secret Door - Sand",
	tiles = {"default_sand.png", "default_sand.png", "default_sand.png","default_sand.png","default_sand.png","default_sand.png",},
	inventory_image = ("sandsecretdoor.png"),
	walkable = false,
	groups = {snappy=2,choppy=2,oddly_breakable_by_hand=2},
})

minetest.register_craft({
	output = "secret:secretdoorglass 2",
	recipe = {
		{"secret:secret", "default:glass", "secret:secret"},
		{"secret:secret", "default:glass", "secret:secret"},
		{"secret:secret", "secret:secret", "secret:secret"},
	}
})

minetest.register_node("secret:secretdoorglass", {
	description = "Secret Door - Glass",
	tiles = {"default_glass.png", "default_glass.png", "default_glass.png","default_glass.png","default_glass.png","default_glass.png",},
	inventory_image = ("glasssecertdoor.png"),
	walkable = false,
	groups = {snappy=2,choppy=2,oddly_breakable_by_hand=2},
	paramtype = "light",
	sunlight_propagates = true,
	drawtype = "glasslike",

})

minetest.register_craft({
	output = "secret:secretdoorstone 2",
	recipe = {
		{"secret:secret", "default:stone", "secret:secret"},
		{"secret:secret", "default:stone", "secret:secret"},
		{"secret:secret", "secret:secret", "secret:secret"},
	}
})

minetest.register_node("secret:secretdoorstone", {
	description = "Secret Door - Stone",
	tiles = {"default_stone.png", "default_stone.png", "default_stone.png","default_stone.png","default_stone.png","default_stone.png",},
	inventory_image = ("stonesecretdoor.png"),
	walkable = false,
	groups = {snappy=2,choppy=2,oddly_breakable_by_hand=2},
})

minetest.register_craft({
	output = "secret:secretdoorwood 2",
	recipe = {
		{"secret:secret", "default:wood", "secret:secret"},
		{"secret:secret", "default:wood", "secret:secret"},
		{"secret:secret", "secret:secret", "secret:secret"},
	}
})

minetest.register_node("secret:secretdoorwood", {
	description = "Secret Door - Wood",
	tiles = {"default_wood.png", "default_wood.png", "default_wood.png","default_wood.png","default_wood.png","default_wood.png",},
	inventory_image = ("woodsecretdoor.png"),
	walkable = false,
	groups = {snappy=2,choppy=2,oddly_breakable_by_hand=2},
})



minetest.register_craft({
	output = "secret:secretdoorbrick 2",
	recipe = {
		{"secret:secret", "default:brick", "secret:secret"},
		{"secret:secret", "default:brick", "secret:secret"},
		{"secret:secret", "secret:secret", "secret:secret"},
	}
})

minetest.register_node("secret:secretdoorbrick", {
	description = "Secret Door - Brick",
	tiles = {"default_brick.png"},
	inventory_image = ("bricksecretdoor.png"),
	walkable = false,
	groups = {snappy=2,choppy=2,oddly_breakable_by_hand=2},
})


minetest.register_craft({
	output = "secret:secretdoortrunk 2",
	recipe = {
		{"secret:secret", "default:tree", "secret:secret"},
		{"secret:secret", "default:tree", "secret:secret"},
		{"secret:secret", "secret:secret", "secret:secret"},
	}
})



minetest.register_node("secret:secretdoortrunk", {
	description = "Secret Door - Tree Trunk",
	tiles = {"default_tree_top.png", "default_tree_top.png", "default_tree.png"},
	inventory_image = ("trunksecretdoor.png"),
	walkable = false,
	groups = {snappy=2,choppy=2,oddly_breakable_by_hand=2},
})


--/////////////////////////////////////////////////////
--/////////////////////////////////////////////////////
--/////////////////////////////////////////////////////
--/////////////////////////////////////////////////////
--END OF THIRD PART///////////////////////////////////
--END OF THE SECRET DOORS//////////////////////////////


minetest.register_craft({
	output = 'secret:OneWayMirror',
	recipe = {
		{'default:glass', '', 'default:glass'},
		{'', 'default:glass', ''},
		{'default:glass', 'secret:secret', 'default:glass'},
	}
})

minetest.register_node("secret:OneWayMirror", {		description = "One Way Mirror",
	tiles = {"def.png"},
	inventory_image = ("inv.png"),
	groups = {snappy=2,choppy=2,oddly_breakable_by_hand=3},
	paramtype2 = "facedir",
	legacy_facedir_simple = true,
}
)






minetest.register_craft({
	output = 'secret:OneWayMirrorwood',
	recipe = {
		{'secret:OneWayMirror', 'default:wood', 'secret:OneWayMirror'},
	}
})


minetest.register_craft({
	output = 'secret:OneWayMirrorstone',
	recipe = {
		{'secret:OneWayMirror', 'default:stone', 'secret:OneWayMirror'},
	}
})

minetest.register_craft({
	output = 'secret:OneWayMirrorcobble',
	recipe = {
		{'secret:OneWayMirror', 'default:cobble', 'secret:OneWayMirror'},
	}
})
minetest.register_craft({
	output = 'secret:OneWayMirrorbrick',
	recipe = {
		{'secret:OneWayMirror', 'default:brick', 'secret:OneWayMirror'},
	}
})




minetest.register_node("secret:OneWayMirrorwood", {		description = "One Way Mirror Wood",
	tiles = {"default_wood.png","default_wood.png","default_wood.png","default_wood.png","default_wood.png", "def.png"},

	inventory_image = ("inv5.png"),
	groups = {snappy=2,choppy=2,oddly_breakable_by_hand=3},
	paramtype2 = "facedir",
	legacy_facedir_simple = true,

})


minetest.register_node("secret:OneWayMirrorstone", {		description = "One Way Mirror Stone",
	tiles = {"default_stone.png","default_stone.png","default_stone.png","default_stone.png","default_stone.png", "def.png"},

	inventory_image = ("inv4.png"),
	groups = {snappy=2,choppy=2,oddly_breakable_by_hand=3},
	paramtype2 = "facedir",
	legacy_facedir_simple = true,

})



minetest.register_node("secret:OneWayMirrorcobble", {		description = "One Way Mirror Cobble",
	tiles = {"default_cobble.png","default_cobble.png","default_cobble.png","default_cobble.png","default_cobble.png", "def.png"},

	inventory_image = ("inv3.png"),
	groups = {snappy=2,choppy=2,oddly_breakable_by_hand=3},
	paramtype2 = "facedir",
	legacy_facedir_simple = true,

})




minetest.register_node("secret:OneWayMirrorbrick", {		description = "One Way Mirror Brick",
	tiles = {"default_brick.png","default_brick.png","default_brick.png","default_brick.png","default_brick.png", "def.png"},

	inventory_image = ("inv2.png"),
	groups = {snappy=2,choppy=2,oddly_breakable_by_hand=3},
	paramtype2 = "facedir",
	legacy_facedir_simple = true,
})




--/////////////////////////////////////////////////////
--/////////////////////////////////////////////////////
--/////////////////////////////////////////////////////
--/////////////////////////////////////////////////////
--END OF FOURTH PART///////////////////////////////////
--END OF ONE WAY MIRROR////////////////////////////////









minetest.register_craft({
	output = 'secret:OneWayMirrordoorwood',
	recipe = {
	{'secret:OneWayMirror', 'secret:secretdoorwood', ''},
	}
})

minetest.register_craft({
	output = 'secret:OneWayMirrordoorcobble',
	recipe = {
	{'secret:OneWayMirror', 'secret:secretdoorcobble', ''},
	}
})

minetest.register_craft({
	output = 'secret:OneWayMirrordoorstone',
	recipe = {
	{'secret:OneWayMirror', 'secret:secretdoorstone', ''},
	}
})
minetest.register_craft({
	output = 'secret:OneWayMirrordoorbrick',
	recipe = {
	{'secret:OneWayMirror', 'secret:secretdoorbrick', ''},
	}
})





minetest.register_node("secret:OneWayMirrordoorwood", {		description = "One Way Mirror Door - Wood",
	tiles = {"default_wood.png","default_wood.png","default_wood.png","default_wood.png","default_wood.png", "def.png"},
      walkable = false,
	inventory_image = ("woodOWMD.png"),
	groups = {snappy=2,choppy=2,oddly_breakable_by_hand=3},
	paramtype2 = "facedir",
	legacy_facedir_simple = true,

})


minetest.register_node("secret:OneWayMirrordoorstone", {		description = "One Way Mirror Door - Stone",
	tiles = {"default_stone.png","default_stone.png","default_stone.png","default_stone.png","default_stone.png", "def.png"},
walkable = false,
	inventory_image = ("stoneOWMD.png"),
	groups = {snappy=2,choppy=2,},
	paramtype2 = "facedir",
	legacy_facedir_simple = true,

})



minetest.register_node("secret:OneWayMirrordoorcobble", {		description = "One Way Mirror Door - Cobble",
	tiles = {"default_cobble.png","default_cobble.png","default_cobble.png","default_cobble.png","default_cobble.png", "def.png"},
walkable = false,
	inventory_image = ("cobbleOWMD.png"),
	groups = {snappy=2,choppy=2,},
	paramtype2 = "facedir",
	legacy_facedir_simple = true,

})




minetest.register_node("secret:OneWayMirrordoorbrick", {		description = "One Way Mirror Door - Brick",
	tiles = {"default_brick.png","default_brick.png","default_brick.png","default_brick.png","default_brick.png", "def.png"},
walkable = false,
	inventory_image = ("brickOWMD.png"),
	groups = {snappy=2,choppy=2,oddly_breakable_by_hand=1},
	paramtype2 = "facedir",
	legacy_facedir_simple = true,

})



--/////////////////////////////////////////////////////
--/////////////////////////////////////////////////////
--/////////////////////////////////////////////////////
--END OF FIVETH PART///////////////////////////////////
--END OF ONE WAY MIRROR DOOR///////////////////////////

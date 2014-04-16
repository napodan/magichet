minetest.register_node("less_trees:birtch", {
	description = "BirtchTree",
	tiles = {"tree_top.png", "tree_top.png", "birtch_trunk.png"},
	paramtype2 = "facedir",
	groups = {tree=1,choppy=2,oddly_breakable_by_hand=1,flammable=2},
	on_place = minetest.rotate_node
})

minetest.register_node("less_trees:oak", {
	description = "OakTree",
	tiles = {"tree_top.png", "tree_top.png", "oak_trunk.png"},
	paramtype2 = "facedir",
	groups = {tree=1,choppy=2,oddly_breakable_by_hand=1,flammable=2},
	on_place = minetest.rotate_node
})

minetest.register_node("less_trees:pine", {
	description = "PineTree",
	tiles = {"tree_top.png", "tree_top.png", "pine_trunk.png"},
	paramtype2 = "facedir",
	groups = {tree=1,choppy=2,oddly_breakable_by_hand=1,flammable=2},
	on_place = minetest.rotate_node
})

minetest.register_node("less_trees:jungle", {
	description = "JungleTree",
	tiles = {"tree_top.png", "tree_top.png", "jungle_trunk.png"},
	paramtype2 = "facedir",
	groups = {tree=1,choppy=2,oddly_breakable_by_hand=1,flammable=2},
	on_place = minetest.rotate_node
})

minetest.register_node("less_trees:jungle_wood", {
	description = "JungleWood",
	tiles = {"jungle_wood.png"},
	paramtype2 = "facedir",
	groups = {tree=1,choppy=2,oddly_breakable_by_hand=1,flammable=3},
	on_place = minetest.rotate_node
})

minetest.register_node("less_trees:oak_wood", {
	description = "OakWood",
	tiles = {"oak_wood.png"},
	paramtype2 = "facedir",
	groups = {tree=1,choppy=2,oddly_breakable_by_hand=1,flammable=3},
	on_place = minetest.rotate_node
})

minetest.register_node("less_trees:birtch_wood", {
	description = "BirtchWood",
	tiles = {"birtch_wood.png"},
	paramtype2 = "facedir",
	groups = {tree=1,choppy=2,oddly_breakable_by_hand=1,flammable=2},
	on_place = minetest.rotate_node
})

minetest.register_node("less_trees:pine_wood", {
	description = "PineWood",
	tiles = {"pine_wood.png"},
	paramtype2 = "facedir",
	groups = {tree=1,choppy=2,oddly_breakable_by_hand=1,flammable=3},
	on_place = minetest.rotate_node
})

minetest.register_node("less_trees:oakleaves", {
	description = "OakLeaves",
	drawtype = "allfaces_optional",
	visual_scale = 1.3,
	tiles = {"oak_leaves.png"},
	paramtype = "light",
	groups = {snappy=3, leafdecay=3, flammable=2, leaves=1},
	drop = {
		max_items = 1,
		items = {
			{
				-- player will get sapling with 1/20 chance
				items = {'less_trees:oaksapling'},
				rarity = 20,
			},
			{
				-- player will get leaves only if he get no saplings,
				-- this is because max_items is 1
				items = {'less_trees:oakleaves'},
			}
		}
	},
})

minetest.register_node("less_trees:birtchleaves", {
	description = "BirtchLeaves",
	drawtype = "allfaces_optional",
	visual_scale = 1.3,
	tiles = {"birtch_leaves.png"},
	paramtype = "light",
	groups = {snappy=3, leafdecay=3, flammable=2, leaves=1},
	drop = {
		max_items = 1,
		items = {
			{
				-- player will get sapling with 1/20 chance
				items = {'less_trees:birtchsapling'},
				rarity = 20,
			},
			{
				-- player will get leaves only if he get no saplings,
				-- this is because max_items is 1
				items = {'less_trees:birtchleaves'},
			}
		}
	},
})

minetest.register_node("less_trees:jungleleaves", {
	description = "Jungle Leaves",
	drawtype = "allfaces_optional",
	visual_scale = 1.3,
	tiles = {"junglea_leaves.png"},
	paramtype = "light",
	groups = {snappy=3, leafdecay=3, flammable=2, leaves=1},
	drop = {
		max_items = 1,
		items = {
			{
				-- player will get sapling with 1/20 chance
				items = {'less_trees:junglesapling'},
				rarity = 20,
			},
			{
				-- player will get leaves only if he get no saplings,
				-- this is because max_items is 1
				items = {'less_trees:jungleleaves'},
			}
		}
	},
})

minetest.register_node("less_trees:pineleaves", {
	description = "PineLeaves",
	drawtype = "allfaces_optional",
	visual_scale = 1.3,
	tiles = {"pine_leaves.png"},
	paramtype = "light",
	groups = {snappy=3, leafdecay=3, flammable=2, leaves=1},
	drop = {
		max_items = 1,
		items = {
			{
				-- player will get sapling with 1/20 chance
				items = {'less_trees:pinesapling'},
				rarity = 20,
			},
			{
				-- player will get leaves only if he get no saplings,
				-- this is because max_items is 1
				items = {'less_trees:pineleaves'},
			}
		}
	},
})

minetest.register_node("less_trees:junglesapling", {
	description = "JungleSapling",
	drawtype = "plantlike",
	visual_scale = 1.0,
	tiles = {"jungle_sapling.png"},
	inventory_image = "jungle_sapling.png",
	wield_image = "jungle_sapling.png",
	paramtype = "light",
	walkable = false,
	selection_box = {
		type = "fixed",
		fixed = {-0.3, -0.5, -0.3, 0.3, 0.35, 0.3}
	},
	groups = {snappy=2,dig_immediate=3,flammable=2,attached_node=1},
})

minetest.register_node("less_trees:birtchsapling", {
	description = "BirtchSapling",
	drawtype = "plantlike",
	visual_scale = 1.0,
	tiles = {"birtch_sapling.png"},
	inventory_image = "birtch_sapling.png",
	wield_image = "birtch_sapling.png",
	paramtype = "light",
	walkable = false,
	selection_box = {
		type = "fixed",
		fixed = {-0.3, -0.5, -0.3, 0.3, 0.35, 0.3}
	},
	groups = {snappy=2,dig_immediate=3,flammable=2,attached_node=1},
})

minetest.register_node("less_trees:oaksapling", {
	description = "OakSapling",
	drawtype = "plantlike",
	visual_scale = 1.0,
	tiles = {"oak_sapling.png"},
	inventory_image = "oak_sapling.png",
	wield_image = "oak_sapling.png",
	paramtype = "light",
	walkable = false,
	selection_box = {
		type = "fixed",
		fixed = {-0.3, -0.5, -0.3, 0.3, 0.35, 0.3}
	},
	groups = {snappy=2,dig_immediate=3,flammable=2,attached_node=1},
})

minetest.register_node("less_trees:pinesapling", {
	description = "PineSapling",
	drawtype = "plantlike",
	visual_scale = 1.0,
	tiles = {"pine_sapling.png"},
	inventory_image = "pine_sapling.png",
	wield_image = "pine_sapling.png",
	paramtype = "light",
	walkable = false,
	selection_box = {
		type = "fixed",
		fixed = {-0.3, -0.5, -0.3, 0.3, 0.35, 0.3}
	},
	groups = {snappy=2,dig_immediate=3,flammable=2,attached_node=1},
})

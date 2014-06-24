-- Copyright 2012 Donald Robertson
-- This file is licensed under the WTFPL.

-- it is included automatically by init.lua

----------------------------------

-- item and craft definitions:
----------------------------------

minetest.register_craftitem("xp:experium", {
	description = "Experium",
	inventory_image = "xp_experium.png",
})

minetest.register_tool("xp:pick_experium", {
	description = "Experium Pickaxe",
	inventory_image = "xp_experiumpick.png",
	tool_capabilities = {
		full_punch_interval = 0.9,
		max_drop_level=4,
		groupcaps={
			cracky={times={[1]=1.2, [2]=0.6, [3]=0.3}, uses=40, maxlevel=4},
			crumbly={times={[1]=1.2, [2]=0.6, [3]=0.3}, uses=40, maxlevel=4},
			snappy={times={[1]=1.2, [2]=0.6, [3]=0.3}, uses=40, maxlevel=4}
		},
		damage_groups = {fleshy=10},
	},
})

minetest.register_craft({
	output = 'xp:pick_experium',
	recipe = {
		{'xp:experium', 'xp:experium', 'xp:experium'},
		{'', 'default:pick_mese', ''},
		{'', '', ''},
	}
})


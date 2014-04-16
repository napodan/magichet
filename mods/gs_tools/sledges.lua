-- tool mods, by gsmanners
-- license: WTFPL

--------------------------------------------------

-- sledges: sledges are basically like pickaxes that do additional digging
-- (when you break a block, it instantly mines out the 8 blocks perpendicular
-- to the direction the tool is used)
--
-- there are 3 types of sledges: stone, bronze and obsidian
-- stone is cheap, but is slow, brittle and cannot break very hard blocks
-- bronze is extremely fast but wears out relatively quickly
-- obsidian is not as fast as bronze, but it is very durable

--------------------------------------------------

function gs_tools.after_sledge(pos, oldnode, digger)
	if digger then
		local wielded = digger:get_wielded_item()
		local rank = minetest.get_item_group(wielded:get_name(), "sledge")
		if rank > 0 then
			for _,k in ipairs(gs_tools.get_3x3s(pos, digger)) do
				gs_tools.drop_node(k, digger, wielded, rank)
			end
		end
	end
end

-- register_on_dignode is used here because after_use does not provide position
-- which is somewhat annoying

minetest.register_on_dignode(gs_tools.after_sledge)

minetest.register_node("gs_tools:cobble_b", {
	description = "Condensed Cobblestone",
	tiles = {"gs_condensed_cobble.png"},
	is_ground_content = true,
	groups = {cracky=2},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_craft({
	output = "gs_tools:cobble_b 3",
	recipe = {
		{"default:cobble", "default:cobble", "default:cobble"},
		{"default:cobble", "default:cobble", "default:cobble"},
		{"default:cobble", "default:cobble", "default:cobble"}
	}
})

minetest.register_craftitem("gs_tools:steel_rod", {
	description = "Steel Rod",
	inventory_image = "gs_steel_rod.png",
})

minetest.register_craft({
	type = "shapeless",
	output = "gs_tools:steel_rod 4",
	recipe = { "default:steel_ingot", "default:steel_ingot"}
})

minetest.register_tool("gs_tools:stone_sledge", {
	description = "Stone Sledgehammer",
	groups = {sledge=1},
	inventory_image = "gs_stone_sledge.png",
	tool_capabilities = {
		full_punch_interval = 2.5,
		max_drop_level=0,
		groupcaps={
			cracky = {times={[2]=3.0, [3]=2.5}, uses=20, maxlevel=1},
		},
		damage_groups = {fleshy=7},
	},
})

minetest.register_tool("gs_tools:bronze_sledge", {
	description = "Bronze Sledgehammer",
	groups = {sledge=2},
	inventory_image = "gs_bronze_sledge.png",
	tool_capabilities = {
		full_punch_interval = 1.0,
		max_drop_level=1,
		groupcaps={
			cracky = {times={[1]=1.25, [2]=1.0, [3]=0.75}, uses=20, maxlevel=2},
		},
		damage_groups = {fleshy=7},
	},
})

minetest.register_tool("gs_tools:obsidian_sledge", {
	description = "Obsidian Sledgehammer",
	groups = {sledge=3},
	inventory_image = "gs_obsidian_sledge.png",
	tool_capabilities = {
		full_punch_interval = 1.5,
		max_drop_level=1,
		groupcaps={
			cracky = {times={[1]=2.5, [2]=2.0, [3]=1.5}, uses=30, maxlevel=3},
		},
		damage_groups = {fleshy=8},
	},
})

minetest.register_craft({
	output = "gs_tools:stone_sledge",
	recipe = {
		{"gs_tools:cobble_b","gs_tools:cobble_b","gs_tools:cobble_b"},
		{"", "gs_tools:steel_rod",""},
		{"", "gs_tools:steel_rod",""}
	}
})

minetest.register_craft({
	output = "gs_tools:bronze_sledge",
	recipe = {
		{"default:bronze_ingot", "default:bronze_ingot", "default:bronze_ingot"},
		{"default:bronze_ingot", "default:bronze_ingot", "default:bronze_ingot"},
		{"", "gs_tools:stone_sledge", ""}
	}
})

minetest.register_craft({
	output = "gs_tools:obsidian_sledge",
	recipe = {
		{"default:obsidian", "default:obsidian", "default:obsidian"},
		{"default:obsidian", "default:obsidian", "default:obsidian"},
		{"", "gs_tools:stone_sledge", ""}
	}
})

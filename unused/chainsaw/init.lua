minetest.register_tool("chainsaw:35cc", {
	description = "chainsaw 35cc",
	inventory_image = "chainsaw_35cc.png",
	tool_capabilities = {
		max_drop_level=0,
		groupcaps={
			choppy={times={[2]=1.40, [3]=0.80}, uses=5, maxlevel=1},
			fleshy={times={[2]=1.50, [3]=0.80}, uses=5, maxlevel=1}
		}
	},
})
minetest.register_tool("chainsaw:40cc", {
	description = "chainsaw 40cc",
	inventory_image = "chainsaw_40cc.png",
	tool_capabilities = {
		max_drop_level=0,
		groupcaps={
			choppy={times={[2]=1.00, [3]=0.40}, uses=30, maxlevel=2},
			fleshy={times={[2]=1.00, [3]=0.30}, uses=30, maxlevel=1},
		}
	},
})
minetest.register_tool("chainsaw:100cc", {
	description = "chainsaw 100cc",
	inventory_image = "chainsaw_100cc.png",
	tool_capabilities = {
		max_drop_level=0,
		groupcaps={
			choppy={times={[2]=0.00, [3]=0.00}, uses=20000, maxlevel=3},
			fleshy={times={[2]=0.00, [3]=0.00}, uses=20000, maxlevel=3},
		}
	},
})
minetest.register_tool("chainsaw:chain", {
	description = "chainsaw chain",
	inventory_image = "chainsaw_chain.png",
	tool_capabilities = {
		max_drop_level=0,
		groupcaps={
			choppy={times={[2]=5, [3]=7}, uses=5, maxlevel=1},
			fleshy={times={[2]=4, [3]=3}, uses=5, maxlevel=1}
		}
	},
})
minetest.register_tool("chainsaw:powerhead3", {
	description = "chainsaw power head 100cc",
	inventory_image = "chainsaw_power.png",
	tool_capabilities = {
		max_drop_level=0,
		groupcaps={
			choppy={times={[2]=50, [3]=70}, uses=1, maxlevel=1},
			fleshy={times={[2]=50, [3]=50}, uses=1, maxlevel=1}
		}
	},
})
minetest.register_tool("chainsaw:bar", {
	description = "chainsaw bar",
	inventory_image = "chainsaw_bar.png",
	tool_capabilities = {
		max_drop_level=0,
		groupcaps={
			choppy={times={[2]=50, [3]=70}, uses=1, maxlevel=1},
			fleshy={times={[2]=50, [3]=50}, uses=1, maxlevel=1}
		}
	},
})
minetest.register_tool("chainsaw:barandchain", {
	description = "chainsaw bar and chain",
	inventory_image = "chainsaw_barchain.png",
	tool_capabilities = {
		max_drop_level=0,
		groupcaps={
			choppy={times={[2]=50, [3]=70}, uses=1, maxlevel=1},
			fleshy={times={[2]=50, [3]=50}, uses=1, maxlevel=1}
		}
	},
})
minetest.register_tool("chainsaw:powerhead2", {
	description = "chainsaw power head 40cc",
	inventory_image = "chainsaw_power.png",
	tool_capabilities = {
		max_drop_level=0,
		groupcaps={
			choppy={times={[2]=50, [3]=70}, uses=1, maxlevel=1},
			fleshy={times={[2]=50, [3]=50}, uses=1, maxlevel=1}
		}
	},
})
minetest.register_tool("chainsaw:powerhead1", {
	description = "chainsaw power head 35cc",
	inventory_image = "chainsaw_power.png",
	tool_capabilities = {
		max_drop_level=0,
		groupcaps={
			choppy={times={[2]=50, [3]=70}, uses=1, maxlevel=1},
			fleshy={times={[2]=50, [3]=50}, uses=1, maxlevel=1}
		}
	},
})

minetest.register_craft({
	output = 'chainsaw:35cc',
	recipe = {
		{'chainsaw:barandchain', 'chainsaw:barandchain', 'chainsaw:barandchain'},
		{'', 'chainsaw:powerhead1', ''},
		{'', 'chainsaw:powerhead1', ''},
	}
})
minetest.register_craft({
	output = 'chainsaw:40cc',
	recipe = {
		{'chainsaw:barandchain', 'chainsaw:barandchain', 'chainsaw:barandchain'},
		{'', 'chainsaw:powerhead2', ''},
		{'', 'chainsaw:powerhead2', ''},
	}
})
minetest.register_craft({
	output = 'chainsaw:100cc',
	recipe = {
		{'chainsaw:barandchain', 'chainsaw:barandchain', 'chainsaw:barandchain'},
		{'', 'chainsaw:powerhead3', ''},
		{'', 'chainsaw:powerhead3', ''},
	}
})
minetest.register_craft({
	output = 'chainsaw:chain',
	recipe = {
		{'default:steel_ingot', 'default:steel_ingot', 'default:steel_ingot'},
			}
})
minetest.register_craft({
	output = 'chainsaw:bar',
	recipe = {
		{'default:mese', 'default:mese', 'default:mese'},
			}
})
minetest.register_craft({
	output = 'chainsaw:barandchain',
	recipe = {
		{'chainsaw:chain', 'chainsaw:bar', 'chainsaw:chain'},
			}
})
minetest.register_craft({
	output = 'chainsaw:powerhead3',
	recipe = {
		{'default:steel_ingot', 'default:steel_ingot', 'default:steel_ingot'},
		{'', 'default:mese', ''},
		{'', 'default:mese', ''},
	}
})
minetest.register_craft({
	output = 'chainsaw:powerhead2',
	recipe = {
		{'default:steel_ingot', 'default:steel_ingot', 'default:steel_ingot'},
		{'', 'default:stone', ''},
		{'', 'default:mese', ''},
	}
})
minetest.register_craft({
	output = 'chainsaw:powerhead1',
	recipe = {
		{'default:steel_ingot', 'default:steel_ingot', 'default:steel_ingot'},
		{'', 'default:cobble', ''},
		{'', 'default:mese', ''},
	}
})



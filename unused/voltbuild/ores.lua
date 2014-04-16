minetest.register_node( "voltbuild:stone_with_uranium", {
	description = "Uranium Ore",
	tiles = { "default_stone.png^itest_mineral_uranium.png" },
	is_ground_content = true,
	groups = {cracky=3},
	sounds = default.node_sound_stone_defaults(),
	drop = 'voltbuild:uranium_lump',
}) 

local sand_with_alunra = {
	description = "Alunra ore",
	tiles = { "default_sand.png^voltbuild_alunra_gem_ore.png" },
	groups = {crumbly=0,choppy=0,fleshy=0,cracky=2,oddly_breakable_by_hand=0},
	drop = "voltbuild:alunra_gem",
}
local sand_properties = minetest.registered_nodes["default:sand"]
sand_with_alunra = voltbuild.deep_copy(sand_properties,sand_with_alunra)
minetest.register_node( "voltbuild:sand_with_alunra", sand_with_alunra)

local water_properties = minetest.registered_nodes["default:water_source"]
local water_with_ignis = {
	description = "Ignis ore",
	tiles = { "default_water.png^voltbuild_ignis_gem_ore.png" },
	drawtype = "allfaces_optional",
	groups = {oddly_breakable_by_hand=3},
	drop = "voltbuild:ignis_dust",
	buildable_to = false,
	pointable = true,
	liquid_alternative_source = "voltbuild:water_source_with_ignis",
	liquid_alternative_flowing = "voltbuild:water_flowing_with_ignis",
	liquid_renewable = false,
	freezemelt = "voltbuild:ice_with_ignis",
	after_dig_node = function (pos, oldnode, oldmetadata, digger)
		minetest.env:set_node(pos,{name="default:water_source"})
	end,
}
water_with_ignis = voltbuild.deep_copy(water_properties,water_with_ignis)
minetest.register_node( "voltbuild:water_source_with_ignis",water_with_ignis)

local flowing_water = minetest.registered_nodes["default:water_flowing"]
local ignis_flowing_water = voltbuild.deep_copy(flowing_water,{liquid_alternative_source = "voltbuild:water_source_with_ignis",liquid_alternaitve_flowing="voltbuild:water_flowing_with_ignis"})
minetest.register_node( "voltbuild:water_flowing_with_ignis",ignis_flowing_water)

local ice_properties = minetest.registered_nodes["default:ice"]
local ignis_ice = {
	description = "Ice with Ignis",
	tiles = {"default_ice.png^voltbuild_ignis_gem_ore.png"},
	freezemelt = "voltbuild:water_source_with_ignis",
}
ignis_ice = voltbuild.deep_copy(ice_properties,ignis_ice)
minetest.register_node( "voltbuild:ice_with_ignis",ignis_ice)

--use moreores tin instead if moreores is loaded
if not moreores_path then
	minetest.register_node( "voltbuild:stone_with_tin", {
		description = "Tin Ore",
		tiles = { "default_stone.png^itest_mineral_tin.png" },
		is_ground_content = true,
		groups = {cracky=3},
		sounds = default.node_sound_stone_defaults(),
		drop = 'voltbuild:tin_lump',
	}) 
	
	minetest.register_craftitem( "voltbuild:tin_lump", {
		description = "Tin lump",
		inventory_image = "itest_tin_lump.png",
	})
end

minetest.register_craftitem( "voltbuild:uranium_lump", {
	description = "Uranium lump",
	inventory_image = "itest_uranium_lump.png",
})

minetest.register_craftitem( "voltbuild:alunra_gem", {
	description = "Alunra gem",
	inventory_image = "voltbuild_alunra_gem.png",
	wield_image = "voltbuild_alunra_gem_wield.png",
	voltbuild = {single_use = 1,
		singleuse_energy = 60,
		charge_tier = 1},
})

minetest.register_craftitem( "voltbuild:ignis_gem", {
	description = "Ignis gem",
	inventory_image = "voltbuild_ignis_gem.png",
})

minetest.register_craftitem( "voltbuild:ignis_dust", {
	description = "Ignis dust",
	inventory_image = "voltbuild_ignis_gem_dust.png",
})

if not moreores_path then
	minetest.register_craftitem( "voltbuild:tin_ingot", {
		description = "Tin ingot",
		inventory_image = "itest_tin_ingot.png",
	})

	minetest.register_node( "voltbuild:tin_block", {
		description = "Tin block",
		groups={cracky=2},
		tiles={"itest_tin_block.png"},
	})
	
	minetest.register_craft({
		output = "voltbuild:tin_block",
		recipe = {{"voltbuild:tin_ingot","voltbuild:tin_ingot","voltbuild:tin_ingot"},
			{"voltbuild:tin_ingot","voltbuild:tin_ingot","voltbuild:tin_ingot"},
			{"voltbuild:tin_ingot","voltbuild:tin_ingot","voltbuild:tin_ingot"}}
	})
	
	minetest.register_craft({
		output = "voltbuild:tin_ingot 9",
		recipe = {{"voltbuild:tin_block"}}
	})
	
	minetest.register_craft({
		type = "cooking",
		output = "voltbuild:tin_ingot",
		recipe = "voltbuild:tin_lump"
	})

--rely on moreores mapgeneration if it's used
	minetest.register_ore({
		ore_type       = "scatter",
		ore            = "voltbuild:stone_with_tin",
		wherein        = "default:stone",
		clust_scarcity = 12*12*12,
		clust_num_ores = 4,
		clust_size     = 3,
		height_min     = -63,
		height_max     = -16,
	})

	minetest.register_ore({
		ore_type       = "scatter",
		ore            = "voltbuild:stone_with_tin",
		wherein        = "default:stone",
		clust_scarcity = 9*9*9,
		clust_num_ores = 5,
		clust_size     = 3,
		height_min     = -31000,
		height_max     = -64,
		flags          = "absheight",
	})
	
	minetest.register_ore({
		ore_type       = "scatter",
		ore            = "voltbuild:stone_with_tin",
		wherein        = "default:stone",
		clust_scarcity = 8*8*8,
		clust_num_ores = 5,
		clust_size     = 3,
		height_min     = -31000,
		height_max     = -64,
		flags          = "absheight",
	})
end

minetest.register_ore({
	ore_type       = "scatter",
	ore            = "default:stone_with_copper",
	wherein        = "default:stone",
	clust_scarcity = 8*8*8,
	clust_num_ores = 5,
	clust_size     = 3,
	height_min     = -31000,
	height_max     = -64,
	flags          = "absheight",
})

minetest.register_ore({
	ore_type       = "scatter",
	ore            = "voltbuild:stone_with_uranium",
	wherein        = "default:stone",
	clust_scarcity = 9*9*9,
	clust_num_ores = 1,
	clust_size     = 1,
	height_min     = -31000,
	height_max     = -64,
	flags          = "absheight",
})

minetest.register_ore({
	ore_type       = "scatter",
	ore            = "voltbuild:sand_with_alunra",
	wherein        = "default:sand",
	clust_scarcity = 16*1*32,
	clust_num_ores = 1,
	clust_size     = 1,
	height_min     = -12,
	height_max     = -10,
})

minetest.register_ore({
	ore_type       = "scatter",
	ore            = "voltbuild:sand_with_alunra",
	wherein        = "default:sand",
	clust_scarcity = 16*1*16,
	clust_num_ores = 2,
	clust_size     = 3,
	height_min     = -14,
	height_max     = -13,
})


minetest.register_ore({
	ore_type       = "scatter",
	ore            = "voltbuild:sand_with_alunra",
	wherein        = "default:sand",
	clust_scarcity = 49*1*7,
	clust_num_ores = 3,
	clust_size     = 5,
	height_min     = -40,
	height_max     = -15,
})

minetest.register_ore({
	ore_type       = "scatter",
	ore            = "voltbuild:water_source_with_ignis",
	wherein        = {"default:water_source","default:water_flowing"},
	clust_scarcity = 20*10*20,
	clust_num_ores = 1,
	clust_size     = 1,
	height_min     = -31000,
	height_max     = -13,
})

if moreores_path then
	minetest.register_alias("voltbuild:stone_with_tin","moreores:mineral_tin")
	minetest.register_alias("voltbuild:tin_lump","moreores:tin_lump")
	minetest.register_alias("voltbuild:tin_ingot","moreores:tin_ingot")
	minetest.register_alias("voltbuild:tin_block","moreores:tin_block")
else
	minetest.register_alias("moreores:mineral_tin","voltbuild:stone_with_tin")
	minetest.register_alias("moreores:tin_lump","voltbuild:tin_lump")
	minetest.register_alias("moreores:tin_ingot","voltbuild:tin_ingot")
	minetest.register_alias("moreores:tin_block","voltbuild:tin_block")
end

if minetest.get_modpath("bucket") then
	bucket.register_liquid("voltbuild:water_source_with_ignis",
		"voltbuild:water_flowing_with_ignis",
		"voltbuild:bucket_water_with_ignis",
		"bucket_water.png",
		"Water with Ignis Bucket")
end

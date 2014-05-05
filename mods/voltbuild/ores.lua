minetest.register_node( "voltbuild:stone_with_uranium", {
	description = "Uranium Ore",
	tiles = { "default_stone.png^itest_mineral_uranium.png" },
	is_ground_content = true,
	groups = {cracky=default.dig.obsidian},
	sounds = default.node_sound_stone_defaults(),
	drop = 'voltbuild:uranium_lump',
}) 

local sand_with_alunra = {
	description = "Alunra ore",
	tiles = { "default_sand.png" },
	groups = {crumbly=default.dig.sand,},
        drop = {
                max_items = 1,
                items = {
                         {items={"voltbuild:alunra_gem"},rarity=20},
                         {items={"default:sand"}},
                        },
               },        
}

local sand_properties = minetest.registered_nodes["default:sand"]
sand_with_alunra = voltbuild.deep_copy(sand_properties,sand_with_alunra)
minetest.register_node( "voltbuild:sand_with_alunra", sand_with_alunra)
-- removed ignis water liquid
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

minetest.register_ore({
	ore_type       = "scatter",
	ore            = "voltbuild:stone_with_uranium",
	wherein        = "default:stone",
	clust_scarcity = 9*9*9,
	clust_num_ores = 1,
	clust_size     = 1,
	height_min     = -5000,
	height_max     = -2000,
	flags          = "absheight",
})

minetest.register_ore({
	ore_type       = "scatter",
	ore            = "voltbuild:stone_with_uranium",
	wherein        = "default:stone",
	clust_scarcity = 4*4*4,
	clust_num_ores = 1,
	clust_size     = 1,
	height_min     = -32000,
	height_max     = -8000,
	flags          = "absheight",
})


minetest.register_ore({
	ore_type       = "scatter",
	ore            = "voltbuild:sand_with_alunra",
	wherein        = "default:sand",
	clust_scarcity = 8*8*8,
	clust_num_ores = 1,
	clust_size     = 1,
	height_min     = -32,
	height_max     = -10,
})

minetest.register_ore({
	ore_type       = "scatter",
	ore            = "voltbuild:sand_with_alunra",
	wherein        = "default:sand",
	clust_scarcity = 8*4*8,
	clust_num_ores = 2,
	clust_size     = 3,
	height_min     = -9,
	height_max     = 13,
})


minetest.register_ore({
	ore_type       = "scatter",
	ore            = "voltbuild:sand_with_alunra",
	wherein        = "default:sand",
	clust_scarcity = 49*1*7,
	clust_num_ores = 3,
	clust_size     = 5,
	height_min     = -14,
	height_max     = 40,
})

-- removed ignis ore (now in water)
-- removed moreores "if" clause - "moreores" is a dependency now

	minetest.register_alias("voltbuild:stone_with_tin","moreores:mineral_tin")
	minetest.register_alias("voltbuild:tin_lump","moreores:tin_lump")
	minetest.register_alias("voltbuild:tin_ingot","moreores:tin_ingot")
	minetest.register_alias("voltbuild:tin_block","moreores:tin_block")

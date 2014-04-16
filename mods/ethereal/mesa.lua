
-- Register Mapgen Biome for Mesa

minetest.register_biome({
	name           = "mesa",
	node_top       = "bakedclay:red",
	depth_top      = 1,
	node_filler    = "bakedclay:orange",
	depth_filler   = 5,
	height_min     = 1,
	height_max     = 71,
	heat_point     = 25.0,
	humidity_point = 28.0,
})

-- Register Biome Decoration

-- Grass for filler
minetest.register_decoration({
	deco_type = "simple",
	place_on = "bakedclay:red",
	sidelen = 16,
	fill_ratio = 0.015,
	biomes = {"mesa"},
	decoration = "default:dry_shrub",
})
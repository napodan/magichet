less_trees.oak_biome = {
	surface = "default:dirt_with_grass",
	avoid_nodes = less_trees.avoidnodes,
	avoid_radius = 8,
	seed_diff = 2,
	rarity = 50,
	max_count = 20,
}

less_trees.pine_biome = {
	surface = "default:dirt_with_grass",
	avoid_nodes = less_trees.avoidnodes,
	avoid_radius = 15,
	seed_diff = 332,
	min_elevation = 0,
	max_elevation = 10,
	temp_min = 0.4,
	temp_max = 0.2,
	rarity = 50,
	max_count = 5,
}

less_trees.birch_biome = {
	surface = "default:dirt_with_grass",
	avoid_nodes = less_trees.avoidnodes,
	avoid_radius = 5,
	seed_diff = 334,
	min_elevation = 10,
	max_elevation = 15,
	temp_min = 0.9,
	temp_max = 0.3,
	rarity = 50,
	max_count = 10,
}

less_trees.jungle_biome = {
	surface = "default:dirt_with_grass",
	avoid_nodes = less_trees.avoidnodes,
	avoid_radius = 5,
	seed_diff = 329,
	min_elevation = -5,
	max_elevation = 10,
	temp_min = 0.25,
	near_nodes = {"default:water_source"},
	near_nodes_size = 20,
	near_nodes_count = 7,
	rarity = 10,
	max_count = 10,
}

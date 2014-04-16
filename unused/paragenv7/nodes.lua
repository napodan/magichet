minetest.register_node("paragenv7:permafrost", {
	description = "PGV7 Permafrost",
	tiles = {"paragenv7_permafrost.png"},
	groups = {crumbly=1},
	drop = "default:dirt",
	sounds = default.node_sound_dirt_defaults(),
})

minetest.register_node("paragenv7:drygrass", {
	description = "PGV7 Dirt With Dry Grass",
	tiles = {"paragenv7_drygrass.png", "default_dirt.png", "paragenv7_drygrass.png"},
	groups = {crumbly=3,soil=1},
	drop = "default:dirt",
	sounds = default.node_sound_dirt_defaults({
		footstep = {name="default_grass_footstep", gain=0.4},
	}),
})

minetest.register_node("paragenv7:pleaf", {
	description = "PGV7 Pine Needles",
	drawtype = "allfaces_optional",
	visual_scale = 1.3,
	tiles = {"paragenv7_pleaf.png"},
	paramtype = "light",
	groups = {snappy=3, leafdecay=3, flammable=2, leaves=1},
	drop = {
		max_items = 1,
		items = {
			{items = {"paragenv7:psapling"}, rarity = 20},
			{items = {"paragenv7:pleaf"}}
		}
	},
	sounds = default.node_sound_leaves_defaults(),
})

minetest.register_node("paragenv7:psapling", {
	description = "PGV7 Pine Sapling",
	drawtype = "plantlike",
	visual_scale = 1.0,
	tiles = {"paragenv7_psapling.png"},
	inventory_image = "paragenv7_psapling.png",
	wield_image = "paragenv7_psapling.png",
	paramtype = "light",
	walkable = false,
	groups = {snappy=2,dig_immediate=3,flammable=2},
	sounds = default.node_sound_defaults(),
})

minetest.register_node("paragenv7:sleaf", {
	description = "PGV7 Savanna Tree Leaves",
	drawtype = "allfaces_optional",
	visual_scale = 1.3,
	tiles = {"paragenv7_sleaf.png"},
	paramtype = "light",
	groups = {snappy=3, leafdecay=4, flammable=2, leaves=1},
	drop = {
		max_items = 1,
		items = {
			{items = {"paragenv7:ssapling"}, rarity = 20},
			{items = {"paragenv7:sleaf"}}
		}
	},
	sounds = default.node_sound_leaves_defaults(),
})

minetest.register_node("paragenv7:ssapling", {
	description = "PGV7 Savanna Tree Sapling",
	drawtype = "plantlike",
	visual_scale = 1.0,
	tiles = {"paragenv7_ssapling.png"},
	inventory_image = "paragenv7_ssapling.png",
	wield_image = "paragenv7_ssapling.png",
	paramtype = "light",
	walkable = false,
	groups = {snappy=2,dig_immediate=3,flammable=2},
	sounds = default.node_sound_defaults(),
})

minetest.register_node("paragenv7:jleaf", {
	description = "PGV7 Jungletree Leaves",
	drawtype = "allfaces_optional",
	visual_scale = 1.3,
	tiles = {"default_jungleleaves.png"},
	paramtype = "light",
	groups = {snappy=3, leafdecay=4, flammable=2, leaves=1},
	drop = {
		max_items = 1,
		items = {
			{items = {"paragenv7:jsapling"}, rarity = 20},
			{items = {"paragenv7:jleaf"}}
		}
	},
	sounds = default.node_sound_leaves_defaults(),
})

minetest.register_node("paragenv7:jsapling", {
	description = "PGV7 Jungletree Sapling",
	drawtype = "plantlike",
	visual_scale = 1.0,
	tiles = {"default_junglesapling.png"},
	inventory_image = "default_junglesapling.png",
	wield_image = "default_junglesapling.png",
	paramtype = "light",
	walkable = false,
	groups = {snappy=2,dig_immediate=3,flammable=2},
	sounds = default.node_sound_defaults(),
})

minetest.register_node("paragenv7:swampsource", {
	description = "PGV7 Swamp Water Source",
	inventory_image = minetest.inventorycube("paragenv7_swampwater.png"),
	-- drawtype = "liquid",
	tiles = {"paragenv7_swampwatertop.png", "paragenv7_swampwater.png"},
	paramtype = "light",
	walkable = false,
	pointable = false,
	diggable = false,
	buildable_to = true,
	liquidtype = "source",
	liquid_alternative_flowing = "paragenv7:swampflowing",
	liquid_alternative_source = "paragenv7:swampsource",
	liquid_viscosity = 1,
	post_effect_color = {a=224, r=31, g=56, b=8},
	groups = {water=3, liquid=3, puts_out_fire=1},
})

minetest.register_node("paragenv7:swampflowing", {
	description = "PGV7 Flowing Swamp Water",
	inventory_image = minetest.inventorycube("paragenv7_swampwater.png"),
	drawtype = "flowingliquid",
	tiles = {"paragenv7_swampwater.png"},
	special_tiles = {
		{
			image="paragenv7_swampwaterflowanim.png",
			backface_culling=false,
			animation={type="vertical_frames", aspect_w=16, aspect_h=16, length=1}
		},
		{
			image="paragenv7_swampwaterflowanim.png",
			backface_culling=true,
			animation={type="vertical_frames", aspect_w=16, aspect_h=16, length=1}
		},
	},
	-- alpha = 224,
	paramtype = "light",
	walkable = false,
	pointable = false,
	diggable = false,
	buildable_to = true,
	liquidtype = "flowing",
	liquid_alternative_flowing = "paragenv7:swampflowing",
	liquid_alternative_source = "paragenv7:swampsource",
	liquid_viscosity = 1,
	post_effect_color = {a=224, r=31, g=56, b=8},
	groups = {water=3, liquid=3, puts_out_fire=1, not_in_creative_inventory=1},
})

-- Bamboo Dirt

minetest.register_node("ethereal:bamboo_dirt", {
    description = "Bamboo Dirt",
    tiles = {"ethereal_grass_bamboo_top.png",
    "default_dirt.png","default_dirt.png^ethereal_grass_bamboo_side.png"},
    is_ground_content = true,
    groups = {crumbly=default.dig.dirt_with_grass, soil=1,ethereal_grass=1},
    drop = 'default:dirt',
    sounds = default.node_sound_dirt_defaults()
})

-- Bamboo (thanks to Nelo-slay on DeviantArt for the free Bamboo base image)

minetest.register_node("ethereal:bamboo", {
    description = "bamboo",
    drawtype = "plantlike",
    tiles = {"bamboo.png"},
    inventory_image = "bamboo.png",
    wield_image = "bamboo.png",
    paramtype = "light",
    is_ground_content = true,
    selection_box = {
        type = "fixed",
        fixed = {-0.3, -0.5, -0.3, 0.3, 0.5, 0.3}
    },
    groups = {choppy=default.dig.fence, oddly_breakable_by_hand=1, flammable=2},
    sounds = default.node_sound_leaves_defaults(),
})

-- Bamboo Sprout

minetest.register_node("ethereal:bamboo_sprout", {
        description = "Bamboo Sprout",
        drawtype = "plantlike",
        visual_scale = 0.8,
        tiles = {"bamboo_sprout.png"},
        inventory_image = "bamboo_sprout.png",
        wield_image = "bamboo_sprout.png",
        paramtype = "light",
        walkable = false,
        is_ground_content = true,
        buildable_to = true,
        groups = {snappy=default.dig.wool,flora=1,attached_node=1},
        sounds = default.node_sound_leaves_defaults(),
        selection_box = {
                type = "fixed",
                fixed = {-0.5, -0.5, -0.5, 0.5, -5/16, 0.5},
        },
    -- sprouts are edible, heal half a heart
    on_use = minetest.item_eat(1),
})

-- Register Mapgen Biome for Bamboo

minetest.register_biome({
    name           = "bamboo",
    node_top       = "ethereal:bamboo_dirt",
    depth_top      = 1,
    node_filler    = "farming:soil",
    depth_filler   = 7,
    height_min     = -20,
    height_max     = 51,
    heat_point     = 45.0,
    humidity_point = 75.0,
})

-- Register Biome Decoration

--[[ Bamboo Stalks
minetest.register_decoration({
    deco_type = "schematic",
    place_on = "ethereal:bamboo_dirt",
    sidelen = 16,
    fill_ratio = 0.055,
    biomes = {"bamboo"},
    schematic = minetest.get_modpath("ethereal").."/schematics/bamboo.mts",
    flags = "place_center_x, place_center_z",
})]]

-- Bamboo Sprouts
minetest.register_decoration({
    deco_type = "simple",
    place_on = "ethereal:bamboo_dirt",
    sidelen = 16,
    fill_ratio = 0.125,
    biomes = {"bamboo"},
    decoration = "ethereal:bamboo_sprout",
})

-- Grass for filler
minetest.register_decoration({
    deco_type = "simple",
    place_on = "ethereal:bamboo_dirt",
    sidelen = 16,
    fill_ratio = 0.10,
    biomes = {"bamboo"},
    decoration = "default:grass_1",
})

-- Bamboo Flooring

minetest.register_node('ethereal:bamboo_floor', {
    description = ("Bamboo Floor"),
    drawtype = 'signlike',
    tiles = { 'bamboo_floor.png' },
    wield_image = 'bamboo_floor.png',
    inventory_image = 'bamboo_floor.png',
    sunlight_propagates = true,
    paramtype = 'light',
    paramtype2 = "wallmounted",
    is_ground_content = true,
    walkable = false,
    groups = { snappy = 3, choppy = 3 },
    sounds = default.node_sound_wood_defaults(),
        selection_box = {
            type = "wallmounted",
                         --wall_top = <default>
                         --wall_bottom = <default>
                         --wall_side = <default>
                        },
})

-- Turn Bamboo into Bamboo Flooring

minetest.register_craft({
    output = 'ethereal:bamboo_floor 2',
    recipe = {
        {'ethereal:bamboo', 'ethereal:bamboo', 'ethereal:bamboo'},
        {'ethereal:bamboo', 'ethereal:bamboo', 'ethereal:bamboo'},
        {'ethereal:bamboo', 'ethereal:bamboo', 'ethereal:bamboo'},
    }
})

-- Turn Bamboo into Paper

minetest.register_craft({
    output = 'default:paper 4',
    recipe = {
        {'ethereal:bamboo', 'ethereal:bamboo'},
        {'ethereal:bamboo', 'ethereal:bamboo'},
        {'ethereal:bamboo', 'ethereal:bamboo'},
    }
})

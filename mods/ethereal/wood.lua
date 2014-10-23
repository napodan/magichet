
--= Define Tree and Mushroom Trunks

-- Frost Tree Trunk
minetest.register_node("ethereal:frost_tree", {
    description = "Frost Tree",
    tiles = {"ethereal_frost_tree_top.png", "ethereal_frost_tree_top.png", "ethereal_frost_tree.png"},
    groups = {tree=1,choppy=default.dig.ice,oddly_breakable_by_hand=1,put_out_fire=1},
    sounds = default.node_sound_wood_defaults(),
    paramtype2 = "facedir",
})

-- Mushroom Trunk
minetest.register_node("ethereal:mushroom_trunk", {
    description = "Mushroom",
    tiles = {"mushroom_trunk_top.png", "mushroom_trunk_top.png", "mushroom_trunk.png"},
    groups = {tree=1,choppy=default.dig.wood,oddly_breakable_by_hand=1,flammable=2},
    sounds = default.node_sound_wood_defaults(),
    paramtype2 = "facedir",
})

-- Healing Tree Trunk
minetest.register_node("ethereal:yellow_trunk", {
    description = "Healing Tree Trunk",
    tiles = {"yellow_tree_top.png", "yellow_tree_top.png", "yellow_tree.png"},
    groups = {tree=1,choppy=default.dig.tree,oddly_breakable_by_hand=1,put_out_fire=1},
    sounds = default.node_sound_wood_defaults(),
    paramtype2 = "facedir",
})

-- Palm Tree Trunk
minetest.register_node("ethereal:palm_trunk", {
    description = "Palm Trunk",
    tiles = {"moretrees_palm_trunk_top.png", "moretrees_palm_trunk_top.png", "moretrees_palm_trunk.png"},
    groups = {tree=1,choppy=default.dig.tree,oddly_breakable_by_hand=1,flammable=2},
    sounds = default.node_sound_wood_defaults(),
    paramtype2 = "facedir",
})

-- Banana Tree Trunk
minetest.register_node("ethereal:banana_trunk", {
    description = "Banana Trunk",
    tiles = {"banana_trunk_top.png", "banana_trunk_top.png", "banana_trunk.png"},
    groups = {tree=1,choppy=default.dig.tree,oddly_breakable_by_hand=1,flammable=2},
    sounds = default.node_sound_wood_defaults(),
    paramtype2 = "facedir",
})

--= Define Tree Wood

-- Healing Tree Wood
minetest.register_node("ethereal:yellow_wood", {
    description = "Healing Tree Wood",
    tiles = {"yellow_wood.png"},
    is_ground_content = true,
    groups = {wood=1,choppy=default.dig.wood,oddly_breakable_by_hand=1,put_out_fire=1},
    sounds = default.node_sound_wood_defaults(),
})

-- Palm Tree Wood
minetest.register_node("ethereal:palm_wood", {
    description = "Palm Wood",
    tiles = {"moretrees_palm_wood.png"},
    is_ground_content = true,
    groups = {wood=1,choppy=default.dig.wood,oddly_breakable_by_hand=1,flammable=3},
    sounds = default.node_sound_wood_defaults(),
})

-- Banana Tree Wood
minetest.register_node("ethereal:banana_wood", {
    description = "Banana Wood",
    tiles = {"banana_wood.png"},
    is_ground_content = true,
    groups = {wood=1,choppy=default.dig.wood,oddly_breakable_by_hand=1,flammable=3},
    sounds = default.node_sound_wood_defaults(),
})

-- Frost Tree Wood
minetest.register_node("ethereal:frost_wood", {
    description = "Frost Wood",
    tiles = {"frost_wood.png"},
    is_ground_content = true,
    groups = {wood=1,choppy=default.dig.wood,oddly_breakable_by_hand=1,put_out_fire=1},
    sounds = default.node_sound_wood_defaults(),
})

-- Turn Healing Tree Trunk into Wood
minetest.register_craft({
    output = 'ethereal:yellow_wood 4',
    type = shapeless,
    recipe = {
        {'ethereal:yellow_trunk', ''},
        {'', ''},
        {'', ''},
    }
})

-- Turn Palm Tree Trunk into Wood
minetest.register_craft({
    output = 'ethereal:palm_wood 4',
    type = shapeless,
    recipe = {
        {'ethereal:palm_trunk', ''},
        {'', ''},
        {'', ''},
    }
})

-- Turn Banana Tree Trunk into Wood
minetest.register_craft({
    output = 'ethereal:banana_wood 4',
    type = shapeless,
    recipe = {
        {'ethereal:banana_trunk', ''},
        {'', ''},
        {'', ''},
    }
})

-- Turn Frost Tree Trunk into Wood
minetest.register_craft({
    output = 'ethereal:frost_wood 4',
    type = shapeless,
    recipe = {
        {'ethereal:frost_tree', ''},
        {'', ''},
        {'', ''},
    }
})

--= NOTE: Minetest 0.4.9 turns any registered wood into sticks, no recipe needed

-- Change j to 1 for 3D style leaves, otherwise 0 is 2D

local j = 1

if j == 0 then
    leaftype = "plantlike"
else
    leaftype = "allfaces_optional"
end

--= Define leaves for ALL trees (and Mushroom Tops)

-- Default Apple Tree Leaves
minetest.register_node(":default:leaves", {
    description = "Leaves",
    drawtype = leaftype,
    visual_scale = 1.1,
    tiles = {"default_leaves.png"},
    paramtype = "light",
    waving = 1,
    groups = {snappy=default.dig.leaves, leafdecay=3, leaves=1},
    drop = {
        max_items = 1,
        items = {
            {   items = {'ethereal:tree_sapling'},
                rarity = 20,
            },
            {   items = {'default:leaves'},
            }
        }
    },
    sounds = default.node_sound_leaves_defaults(),
})

-- Default Jungle Tree Leaves
minetest.register_node(":default:jungleleaves", {
    description = "Jungle Leaves",
    drawtype = leaftype,
    visual_scale = 1.1,
    tiles = {"default_jungleleaves.png"},
    paramtype = "light",
    waving = 1,
    groups = {snappy=default.dig.leaves, leafdecay=3, leaves=1},
    drop = {
        max_items = 1,
        items = {
            {   items = {'ethereal:jungle_tree_sapling'},
                rarity = 20,
            },
            {   items = {'default:jungleleaves'},
            }
        }
    },
    sounds = default.node_sound_leaves_defaults(),
})

-- Default Banana Tree Leaves
minetest.register_node("ethereal:bananaleaves", {
    description = "Banana Leaves",
    drawtype = leaftype,
    visual_scale = 1.1,
    tiles = {"banana_leaf.png"},
    paramtype = "light",
    waving = 1,
    groups = {snappy=default.dig.leaves, leafdecay=3, leaves=1},
    drop = {
        max_items = 1,
        items = {
            {   items = {'ethereal:banana_tree_sapling'},
                rarity = 20,
            },
            {   items = {'ethereal:bananaleaves'},
            }
        }
    },
    sounds = default.node_sound_leaves_defaults(),
})

-- Healing Tree Leaves
minetest.register_node("ethereal:yellowleaves", {
    description = "Healing Tree Leaves",
    drawtype = leaftype,
    visual_scale = 1.1,
    tiles = {"yellow_leaves.png"},
    paramtype = "light",
    waving = 1,
    groups = {snappy=default.dig.wood, leafdecay=3, leaves=1},
    drop = {
        max_items = 1,
        items = {
            {   items = {'ethereal:yellow_tree_sapling'},
                rarity = 50,
            },
            {   items = {'ethereal:yellowleaves'},
            }
        }
    },
    -- Leaves are edible, heal half a heart
    on_use = minetest.item_eat(1),
    sounds = default.node_sound_leaves_defaults(),
    light_source = 6,
})

-- Palm Tree Leaves
minetest.register_node("ethereal:palmleaves", {
    description = "Palm Leaves",
    drawtype = leaftype,
    visual_scale = 1.1,
    tiles = {"moretrees_palm_leaves.png"},
    paramtype = "light",
    waving = 1,
    groups = {snappy=default.dig.leaves, leafdecay=3, leaves=1},
    drop = {
        max_items = 1,
        items = {
            {   items = {'ethereal:palm_sapling'},
                rarity = 20,
            },
            {   items = {'ethereal:palmleaves'},
            }
        }
    },
    sounds = default.node_sound_leaves_defaults(),
})

-- Pine Tree Leaves
minetest.register_node("ethereal:pineleaves", {
    description = "Pine Needles",
    drawtype = leaftype,
    visual_scale = 1.1,
    tiles = {"pine_leaves.png"},
    paramtype = "light",
    waving = 1,
    groups = {snappy=default.dig.leaves, leafdecay=3, leaves=1},
    drop = {
        max_items = 1,
        items = {
            {   items = {'ethereal:pine_tree_sapling'},
                rarity = 20,
            },
            {   items = {'ethereal:pine_nuts'},
                rarity = 5,
            },
            {   items = {'ethereal:pineleaves'},
            }
        }
    },
    sounds = default.node_sound_leaves_defaults(),
})

-- Frost Tree Leaves
minetest.register_node("ethereal:frost_leaves", {
    description = "Frost Leaves",
    drawtype = leaftype,
    visual_scale = 1.1,
    tiles = {"ethereal_frost_leaves.png"},
    paramtype = "light",
    waving = 1,
    groups = {snappy=default.dig.ice, leafdecay=3, puts_out_fire=1},
    drop = {
        max_items = 1,
        items = {
            {   items = {'ethereal:frost_tree_sapling'},
                rarity = 20,
            },
            {   items = {'ethereal:frost_leaves'},
            }
        }
    },
    light_source = 9,
    sounds = default.node_sound_leaves_defaults(),
})

-- Mushroom Tops
minetest.register_node("ethereal:mushroom", {
    description = "Mushroom Cap",
    tiles = {"mushroom_block.png"},
    groups = {tree=1,choppy=default.dig.leaves,oddly_breakable_by_hand=1},
    drop = {
        max_items = 1,
        items = {
            {   items = {'ethereal:mushroom_sapling'},
                rarity = 20,
            },
            {   items = {'ethereal:mushroom'},
            }
        }
    },
    sounds = default.node_sound_wood_defaults(),
})

-- Mushroom Pore (Spongelike block inside mushrooms that has special properties)
minetest.register_node("ethereal:mushroom_pore", {
    description = "Mushroom Pore",
    tiles = {"mushroom_block2.png"},
    groups = {snappy=default.dig.leaves,cracky=default.dig.leaves,choppy=default.dig.leaves,oddly_breakable_by_hand=3,disable_jump=1, fall_damage_add_percent=-100},
    sounds = default.node_sound_dirt_defaults(),
})

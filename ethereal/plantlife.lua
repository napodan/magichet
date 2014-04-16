
--= Define Fern & Shrubs

-- Fern (boston)
minetest.register_node("ethereal:fern", {
        description = "Fern",
        drawtype = "plantlike",
        visual_scale = 1.2,
        tiles = {"fern.png"},
        inventory_image = "fern.png",
        wield_image = "fern.png",
        paramtype = "light",
        waving = 1,
        walkable = false,
        is_ground_content = true,
        buildable_to = true,
    drop = {
        max_items = 1,
        items = {
            {items = {'ethereal:fern_tubers'},rarity = 6},
            {items = {'ethereal:fern'}},
        }
    },
        groups = {snappy=default.dig.leaves,flora=1,attached_node=1},
        sounds = default.node_sound_leaves_defaults(),
        selection_box = {
                type = "fixed",
                fixed = {-0.5, -0.5, -0.5, 0.5, -5/16, 0.5},
        },
})

-- Boston Ferns sometimes drop edible Tubers (heals 1/2 heart when eaten)
minetest.register_craftitem("ethereal:fern_tubers", {
    description = "Fern Tubers",
    inventory_image = "fern_tubers.png",
    on_use = minetest.item_eat(1),
})

-- Red Shrub (not flammable)
minetest.register_node("ethereal:dry_shrub", {
        description = "Fiery Dry Shrub",
        drawtype = "plantlike",
        visual_scale = 1.0,
        tiles = {"ethereal_dry_shrub.png"},
        inventory_image = "ethereal_dry_shrub.png",
        wield_image = "ethereal_dry_shrub.png",
        paramtype = "light",
        waving = 1,
        walkable = false,
        is_ground_content = true,
        buildable_to = true,
        groups = {snappy=default.dig.leaves,flora=1,attached_node=1},
        sounds = default.node_sound_leaves_defaults(),
        selection_box = {
                type = "fixed",
                fixed = {-0.5, -0.5, -0.5, 0.5, -5/16, 0.5},
        },
})

-- Grey Shrub (not Flammable - too cold to burn)
minetest.register_node("ethereal:snowygrass", {
        description = "Snowy Grass",
        drawtype = "plantlike",
        visual_scale = 0.9,
        tiles = {"ethereal_snowygrass.png"},
        inventory_image = "ethereal_snowygrass.png",
        wield_image = "ethereal_snowygrass.png",
        paramtype = "light",
    waving = 1,
        walkable = false,
        buildable_to = true,
        is_ground_content = true,
        groups = {snappy=default.dig.leaves,flora=1,attached_node=1},
        sounds = default.node_sound_leaves_defaults(),
        selection_box = {
                type = "fixed",
                fixed = {-0.5, -0.5, -0.5, 0.5, -5/16, 0.5},
        },
})

--= Define Moss Types (Has grass textures on all sides)

function ethereal.add_moss(typ, descr, texture, receipe_item)
    minetest.register_node('ethereal:'..typ..'_moss', {
        description = descr..' Moss',
        tiles = { texture },
        is_ground_content = true,
        groups = {crumbly=default.dig.gravel},
        sounds = default.node_sound_dirt_defaults
    })

    minetest.register_craft({
        output = 'ethereal:'..typ..'_moss',
        recipe = {{'default:dirt', receipe_item }}
    });
end

ethereal.add_moss( 'crystal',  'Crystal',  'ethereal_frost_grass.png',  'ethereal:frost_leaves');
ethereal.add_moss( 'mushroom', 'Mushroom', 'mushroom_dirt_top.png',     'ethereal:mushroom' );
ethereal.add_moss( 'fiery',    'Fiery',    'ethereal_fiery_grass.png',  'ethereal:dry_shrub' );
ethereal.add_moss( 'gray',     'Gray',     'ethereal_gray_grass.png',   'ethereal:snowygrass' );
ethereal.add_moss( 'green',    'Green',    'default_grass.png',         'default:jungleleaves' );

--= Saplings and Leaves Can Be Used as Fuel

minetest.register_craft({
    type = "fuel",
    recipe = "ethereal:frost_leaves",
    burntime = 1.5,
})

minetest.register_craft({
    type = "fuel",
    recipe = "ethereal:frost_tree_sapling",
    burntime = 12.5,
})

--= Define Food Items

-- Banana (Heals one heart when eaten)
minetest.register_node("ethereal:banana", {
    description = "Banana",
    drawtype = "torchlike", -- was plantlike
    visual_scale = 1.0,
    tiles = {"banana_single.png"},
    inventory_image = "banana_single.png",
    paramtype = "light",
    walkable = false,
    is_ground_content = true,
    selection_box = {
        type = "fixed",
        fixed = {-0.2, -0.5, -0.2, 0.2, 0, 0.2}
    },
    groups = {fleshy=3,dig_immediate=3,flammable=2,leafdecay=3,leafdecay_drop=1},
    on_use = minetest.item_eat(2),
    sounds = default.node_sound_leaves_defaults(),
    after_place_node = function(pos, placer, itemstack)
        if placer:is_player() then
            minetest.set_node(pos, {name="ethereal:banana", param2=1})
        end
    end,
})

-- Banana Dough
minetest.register_craftitem("ethereal:banana_dough", {
    description = "Banana Dough",
    inventory_image = "banana_dough.png",
})

minetest.register_craft({
    type = "shapeless",
    output = "ethereal:banana_dough",
    recipe = {"farming:flour", "ethereal:banana"}
})

minetest.register_craft({
    type = "cooking",
    cooktime = 14,
    output = "ethereal:banana_bread",
    recipe = "ethereal:banana_dough"
})

-- Pine Nuts (Heals 1/2 heart when eaten)
minetest.register_craftitem("ethereal:pine_nuts", {
    description = "Pine Nuts",
    inventory_image = "pine_nuts.png",
    on_use = minetest.item_eat(1),
})

-- Banana Loaf (Heals 3 hearts when eaten)
minetest.register_craftitem("ethereal:banana_bread", {
    description = "Banana Loaf",
    inventory_image = "banana_bread.png",
    on_use = minetest.item_eat(6),
})

-- Strawberry Bush (Gives 3 Strawberries, each heal 1/2 heart)
minetest.register_node("ethereal:strawberry_bush", {
    drawtype = "plantlike",
    walkable = false,
    paramtype = "light",
    visual_scale = 0.8,
    selection_box = {
        type = "fixed",
        fixed = {-0.2, -0.5, -0.2, 0.2, 0, 0.2}
    },
    description = "Strawberry Bush",
    tiles = {"strawberry_bush.png"},
    is_ground_content = true,
    groups = {snappy=default.dig.leaves,flammable=1},
    drop = 'ethereal:strawberry 3',
    sounds = default.node_sound_defaults(),
})

-- Strawberry (Heals half heart when eaten)
minetest.register_craftitem("ethereal:strawberry", {
    description = "Strawberry",
    inventory_image = "strawberry.png",
    on_use = minetest.item_eat(1),
})


-- Mushroom Plant (Must be farmed to become edible)
minetest.register_node("ethereal:mushroom_plant", {
    description = "Mushroom (edible)",
    drawtype = "plantlike",
    tiles = {"mushroom.png"},
    inventory_image = "mushroom.png",
    drop = 'ethereal:mushroom_craftingitem',
    wield_image = "mushroom.png",
    paramtype = "light",
    walkable = false,
    groups = {snappy=default.dig.leaves,dig_immediate=3,flammable=2},
    sounds = default.node_sound_defaults(),
    on_use = minetest.item_eat(1),
})

-- Coconut (Gives 4 coconut slices, each heal 1/2 heart)
minetest.register_node("ethereal:coconut", {
    drawtype = "plantlike",
    walkable = false,
    paramtype = "light",
    description = "Coconut",
    tiles = {"moretrees_coconut.png"},
    is_ground_content = true,
    groups = {cracky=default.dig.cobble,snappy=default.dig.wool,choppy=default.dig.wood,flammable=1,leafdecay=3,leafdecay_drop=1},
    drop = 'ethereal:coconut_slice 4',
    sounds = default.node_sound_wood_defaults(),
})

-- Coconut Slice (Heals half heart when eaten)
minetest.register_craftitem("ethereal:coconut_slice", {
    description = "Coconut Slice",
    inventory_image = "moretrees_coconut_slice.png",
    on_use = minetest.item_eat(1),
})

-- Golden Apple (Found on Healing Tree, heals all 10 hearts)
minetest.register_node("ethereal:golden_apple", {
    description = "Golden Apple",
    drawtype = "plantlike",
    visual_scale = 1.0,
    tiles = {"default_apple_gold.png"},
    inventory_image = "default_apple_gold.png",
    paramtype = "light",
    walkable = false,
    is_ground_content = true,
    selection_box = {
        type = "fixed",
        fixed = {-0.2, -0.5, -0.2, 0.2, 0, 0.2}
    },
    groups = {fleshy=3,dig_immediate=3,flammable=2,leafdecay=3,leafdecay_drop=1},
    on_use = minetest.item_eat(20),
    sounds = default.node_sound_leaves_defaults(),
    after_place_node = function(pos, placer, itemstack)
        if placer:is_player() then
            minetest.set_node(pos, {name="ethereal:golden_apple", param2=1})
        end
    end,
})

-- Wild Onion
minetest.register_craftitem("ethereal:wild_onion_plant", {
    description = "Wild Onion",
    inventory_image = "wild_onion.png",
    wield_image = "wild_onion.png",
    sounds = default.node_sound_defaults(),
})

-- Mushroom Soup (Heals 1 heart)
minetest.register_craftitem("ethereal:mushroom_soup", {
    description = "Mushroom Soup",
    inventory_image = "mushroom_soup.png",
    on_use = minetest.item_eat(2),
})

-- Cooked Mushroom Soup (Heals 1 and half heart)
minetest.register_craftitem("ethereal:mushroom_soup_cooked", {
    description = "Mushroom Soup Cooked",
    inventory_image = "mushroom_soup_cooked.png",
    on_use = minetest.item_eat(3),
})

--= Crafting Recipes

-- Wooden Bowl (for Mushroom Soup)
minetest.register_craftitem("ethereal:bowl", {
    description = "Bowl",
    inventory_image = "bowl.png",
})

minetest.register_craft({
    output = 'ethereal:bowl',
    recipe = {
        {'group:wood', '', 'group:wood'},
        {'', 'group:wood', ''},
        {'', '', ''},
    }
})

-- Hearty Stew (Heals 4 hearts - thanks to ZonerDarkRevention for his DokuCraft DeviantArt bowl texture)
minetest.register_craftitem("ethereal:hearty_stew", {
    description = "Hearty Stew",
    inventory_image = "hearty_stew.png",
    on_use = minetest.item_eat(8),
})

-- Cooked Hearty Stew (Heals 5 hearts)
minetest.register_craftitem("ethereal:hearty_stew_cooked", {
    description = "Hearty Stew Cooked",
    inventory_image = "hearty_stew_cooked.png",
    on_use = minetest.item_eat(10),
})

-- Hearty Stew
minetest.register_craft({
    output = 'ethereal:hearty_stew',
    recipe = {
        {'ethereal:wild_onion_plant','ethereal:mushroom_plant', 'ethereal:bamboo_sprout'},
        {'','ethereal:mushroom_plant', ''},
        {'','ethereal:bowl', ''},
    }
})

minetest.register_craft({
    output = 'ethereal:hearty_stew',
    recipe = {
        {'ethereal:wild_onion_plant','ethereal:mushroom_plant', 'ethereal:fern_tubers'},
        {'','ethereal:mushroom_plant', ''},
        {'','ethereal:bowl', ''},
    }
})

-- Cooked Hearty Stew
minetest.register_craft({
    type = "cooking",
    cooktime = 10,
    output = "ethereal:hearty_stew_cooked",
    recipe = "ethereal:hearty_stew"
})

-- Mushroom Soup
minetest.register_craft({
    output = 'ethereal:mushroom_soup',
    recipe = {
        {'ethereal:mushroom_plant', ''},
        {'ethereal:mushroom_plant', ''},
        {'ethereal:bowl', ''},
    }
})

-- Cooked Mushroom Soup
minetest.register_craft({
    type = "cooking",
    cooktime = 10,
    output = "ethereal:mushroom_soup_cooked",
    recipe = "ethereal:mushroom_soup"
})

-- Mushroom Tops give 4x Mushrooms for Planting
minetest.register_craft({
    output = 'ethereal:mushroom_craftingitem 4',
    type = shapeless,
    recipe = {
        {'ethereal:mushroom', ''},
        {'', ''},
        {'', ''},
    }
})

--= Additional Crafting Recipes were removed


-- Bucket of Cactus Pulp
minetest.register_craftitem("ethereal:bucket_cactus", {
    description = "Bucket of Cactus Pulp",
    inventory_image = "bucket_cactus.png",
    stack_max = 1,
    on_use = minetest.item_eat(2, "bucket:bucket_empty"),
})

minetest.register_craft({
    output = "ethereal:bucket_cactus",
    type = shapeless,
    recipe = {
        {'bucket:bucket_empty','default:cactus'},
    }
})

-- Palm Wax
minetest.register_craftitem("ethereal:palm_wax", {
    description = "Palm Wax",
    inventory_image = "palm_wax.png",
})

minetest.register_craft({
    type = "cooking",
    cooktime = 10,
    output = "ethereal:palm_wax",
    recipe = "ethereal:palmleaves"
})

-- Candle from Wax and String
minetest.register_craft({
    output = "ethereal:candle 6",
    recipe = {
        {'','farming:string'},
        {'','ethereal:palm_wax'},
        {'','ethereal:palm_wax'},
    }
})

minetest.register_node("ethereal:candle", {
    description = "Candle",
    drawtype = "plantlike",
    inventory_image = "candle_static.png",
    tiles = {
            {name="candle.png", animation={type="vertical_frames", aspect_w=32, aspect_h=32, length=1.0}},
        },
    paramtype = "light",
    light_source = LIGHT_MAX-3,
    sunlight_propagates = true,
    walkable = false,
    groups = {dig_immediate=3, attached_node=1},
    sounds = default.node_sound_defaults(),
    selection_box = {
            type = "fixed",
            fixed = { -0.15, -0.5, -0.15, 0.15, 0.2, 0.15 },
    },
})

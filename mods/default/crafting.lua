-- mods/default/crafting.lua

minetest.register_craft({
    output = 'default:wood 4',
    recipe = {
        {'default:tree'},
    }
})

minetest.register_craft({
    output = 'default:junglewood 4',
    recipe = {
        {'default:jungletree'},
    }
})

minetest.register_craft({
    output = 'default:stick 4',
    recipe = {
        {'group:wood'},
        {'group:wood'},
    }
})

minetest.register_craft({
    output = 'default:fence 2',
    recipe = {
        {'group:stick', 'group:stick', 'group:stick'},
        {'group:stick', 'group:stick', 'group:stick'},
    }
})

minetest.register_craft({
    output = 'default:sign_wall 2',
    recipe = {
        {'group:wood', 'group:wood', 'group:wood'},
        {'group:wood', 'group:wood', 'group:wood'},
        {'', 'default:stick', ''},
    }
})

minetest.register_craft({
    output = 'default:torch 4',
    recipe = {
        {'group:coal'},
        {'default:stick'},
    }
})

minetest.register_craft({
    output = 'default:pick_wood',
    recipe = {
        {'group:wood', 'group:wood', 'group:wood'},
        {'', 'default:stick', ''},
        {'', 'default:stick', ''},
    }
})

minetest.register_craft({
    output = 'default:pick_stone',
    recipe = {
        {'group:stone', 'group:stone', 'group:stone'},
        {'', 'default:stick', ''},
        {'', 'default:stick', ''},
    }
})

minetest.register_craft({
    output = 'default:pick_iron',
    recipe = {
        {'default:iron_ingot', 'default:iron_ingot', 'default:iron_ingot'},
        {'', 'default:stick', ''},
        {'', 'default:stick', ''},
    }
})

minetest.register_craft({
    output = 'default:pick_gold',
    recipe = {
        {'default:gold_ingot', 'default:gold_ingot', 'default:gold_ingot'},
        {'', 'default:stick', ''},
        {'', 'default:stick', ''},
    }
})

minetest.register_craft({
    output = 'default:pick_bronze',
    recipe = {
        {'default:bronze_ingot', 'default:bronze_ingot', 'default:bronze_ingot'},
        {'', 'group:stick', ''},
        {'', 'group:stick', ''},
    }
})

minetest.register_craft({
    output = 'default:pick_mese',
    recipe = {
        {'default:mese_crystal', 'default:mese_crystal', 'default:mese_crystal'},
        {'', 'group:stick', ''},
        {'', 'group:stick', ''},
    }
})

minetest.register_craft({
    output = 'default:pick_diamond',
    recipe = {
        {'default:diamond', 'default:diamond', 'default:diamond'},
        {'', 'default:stick', ''},
        {'', 'default:stick', ''},
    }
})

minetest.register_craft({
    output = 'default:shovel_wood',
    recipe = {
        {'group:wood'},
        {'default:stick'},
        {'default:stick'},
    }
})

minetest.register_craft({
    output = 'default:shovel_stone',
    recipe = {
        {'group:stone'},
        {'default:stick'},
        {'default:stick'},
    }
})

minetest.register_craft({
    output = 'default:shovel_iron',
    recipe = {
        {'default:iron_ingot'},
        {'default:stick'},
        {'default:stick'},
    }
})

minetest.register_craft({
    output = 'default:shovel_gold',
    recipe = {
        {'default:gold_ingot'},
        {'default:stick'},
        {'default:stick'},
    }
})

minetest.register_craft({
    output = 'default:shovel_bronze',
    recipe = {
        {'default:bronze_ingot'},
        {'group:stick'},
        {'group:stick'},
    }
})

minetest.register_craft({
    output = 'default:shovel_mese',
    recipe = {
        {'default:mese_crystal'},
        {'group:stick'},
        {'group:stick'},
    }
})

minetest.register_craft({
    output = 'default:shovel_diamond',
    recipe = {
        {'default:diamond'},
        {'default:stick'},
        {'default:stick'},
    }
})

minetest.register_craft({
    output = 'default:axe_wood',
    recipe = {
        {'group:wood', 'group:wood'},
        {'group:wood', 'default:stick'},
        {'', 'default:stick'},
    }
})

minetest.register_craft({
    output = 'default:axe_stone',
    recipe = {
        {'group:stone', 'group:stone'},
        {'group:stone', 'default:stick'},
        {'', 'default:stick'},
    }
})

minetest.register_craft({
    output = 'default:axe_iron',
    recipe = {
        {'default:iron_ingot', 'default:iron_ingot'},
        {'default:iron_ingot', 'default:stick'},
        {'', 'default:stick'},
    }
})

minetest.register_craft({
    output = 'default:axe_gold',
    recipe = {
        {'default:gold_ingot', 'default:gold_ingot'},
        {'default:gold_ingot', 'default:stick'},
        {'', 'default:stick'},
    }
})

minetest.register_craft({
    output = 'default:axe_bronze',
    recipe = {
        {'default:bronze_ingot', 'default:bronze_ingot'},
        {'default:bronze_ingot', 'group:stick'},
        {'', 'group:stick'},
    }
})

minetest.register_craft({
    output = 'default:axe_mese',
    recipe = {
        {'default:mese_crystal', 'default:mese_crystal'},
        {'default:mese_crystal', 'group:stick'},
        {'', 'group:stick'},
    }
})

minetest.register_craft({
    output = 'default:axe_diamond',
    recipe = {
        {'default:diamond', 'default:diamond'},
        {'default:diamond', 'default:stick'},
        {'', 'default:stick'},
    }
})

minetest.register_craft({
    output = 'default:sword_wood',
    recipe = {
        {'group:wood'},
        {'group:wood'},
        {'default:stick'},
    }
})

minetest.register_craft({
    output = 'default:sword_stone',
    recipe = {
        {'group:stone'},
        {'group:stone'},
        {'default:stick'},
    }
})

minetest.register_craft({
    output = 'default:sword_iron',
    recipe = {
        {'default:iron_ingot'},
        {'default:iron_ingot'},
        {'default:stick'},
    }
})

minetest.register_craft({
    output = 'default:sword_gold',
    recipe = {
        {'default:gold_ingot'},
        {'default:gold_ingot'},
        {'default:stick'},
    }
})


minetest.register_craft({
    output = 'default:sword_bronze',
    recipe = {
        {'default:bronze_ingot'},
        {'default:bronze_ingot'},
        {'group:stick'},
    }
})

minetest.register_craft({
    output = 'default:sword_mese',
    recipe = {
        {'default:mese_crystal'},
        {'default:mese_crystal'},
        {'group:stick'},
    }
})

minetest.register_craft({
    output = 'default:sword_diamond',
    recipe = {
        {'default:diamond'},
        {'default:diamond'},
        {'default:stick'},
    }
})

minetest.register_craft({
    type = "shapeless",
    output = "default:bronze_ingot",
    recipe = {"moreores:tin_ingot", "default:copper_ingot","default:copper_ingot","default:copper_ingot"},
})


minetest.register_craft({
    output = 'default:shears',
    recipe = {
        {'', 'default:iron_ingot'},
        {'default:iron_ingot', ''},
    }
})

minetest.register_craft({
    output = 'default:rail 16',
    recipe = {
        {'default:iron_ingot', '', 'default:iron_ingot'},
        {'default:iron_ingot', 'default:stick', 'default:iron_ingot'},
        {'default:iron_ingot', '', 'default:iron_ingot'},
    }
})

minetest.register_craft({
    output = 'default:chest',
    recipe = {
        {'group:wood', 'group:wood', 'group:wood'},
        {'group:wood', '', 'group:wood'},
        {'group:wood', 'group:wood', 'group:wood'},
    }
})

minetest.register_craft({
    output = 'default:furnace',
    recipe = {
        {'group:stone', 'group:stone', 'group:stone'},
        {'group:stone', '', 'group:stone'},
        {'group:stone', 'group:stone', 'group:stone'},
    }
})

minetest.register_craft({
    output = 'default:ironblock',
    recipe = {
        {'default:iron_ingot', 'default:iron_ingot', 'default:iron_ingot'},
        {'default:iron_ingot', 'default:iron_ingot', 'default:iron_ingot'},
        {'default:iron_ingot', 'default:iron_ingot', 'default:iron_ingot'},
    }
})

minetest.register_craft({
    output = 'default:iron_ingot 9',
    recipe = {
        {'default:ironblock'},
    }
})


minetest.register_craft({
    output = 'default:copperblock',
    recipe = {
        {'default:copper_ingot', 'default:copper_ingot', 'default:copper_ingot'},
        {'default:copper_ingot', 'default:copper_ingot', 'default:copper_ingot'},
        {'default:copper_ingot', 'default:copper_ingot', 'default:copper_ingot'},
    }
})

minetest.register_craft({
    output = 'default:copper_ingot 9',
    recipe = {
        {'default:copperblock'},
    }
})

minetest.register_craft({
    output = 'default:goldblock',
    recipe = {
        {'default:gold_ingot', 'default:gold_ingot', 'default:gold_ingot'},
        {'default:gold_ingot', 'default:gold_ingot', 'default:gold_ingot'},
        {'default:gold_ingot', 'default:gold_ingot', 'default:gold_ingot'},
    }
})

minetest.register_craft({
    output = 'default:bronzeblock',
    recipe = {
        {'default:bronze_ingot', 'default:bronze_ingot', 'default:bronze_ingot'},
        {'default:bronze_ingot', 'default:bronze_ingot', 'default:bronze_ingot'},
        {'default:bronze_ingot', 'default:bronze_ingot', 'default:bronze_ingot'},
    }
})

minetest.register_craft({
    output = 'default:bronze_ingot 9',
    recipe = {
        {'default:bronzeblock'},
    }
})

minetest.register_craft({
    output = 'default:gold_ingot 9',
    recipe = {
        {'default:goldblock'},
    }
})

minetest.register_craft({
    type = 'shapeless',
    output = 'default:gold_nugget 9',
    recipe = {'default:gold_ingot'},
})

minetest.register_craft({
    output = 'default:gold_ingot',
    recipe = {
        {'default:gold_nugget', 'default:gold_nugget', 'default:gold_nugget'},
        {'default:gold_nugget', 'default:gold_nugget', 'default:gold_nugget'},
        {'default:gold_nugget', 'default:gold_nugget', 'default:gold_nugget'},
    },
})

minetest.register_craft({
    output = 'default:apple_gold',
    recipe = {
        {'default:gold_nugget', 'default:gold_nugget', 'default:gold_nugget'},
        {'default:gold_nugget', 'default:apple', 'default:gold_nugget'},
        {'default:gold_nugget', 'default:gold_nugget', 'default:gold_nugget'},
    },
})

minetest.register_craft({
    output = 'default:apple_gold2',
    recipe = {
        {'default:goldblock', 'default:goldblock', 'default:goldblock'},
        {'default:goldblock', 'default:apple', 'default:goldblock'},
        {'default:goldblock', 'default:goldblock', 'default:goldblock'},
    },
})

minetest.register_craft({
    output = 'default:diamondblock',
    recipe = {
        {'default:diamond', 'default:diamond', 'default:diamond'},
        {'default:diamond', 'default:diamond', 'default:diamond'},
        {'default:diamond', 'default:diamond', 'default:diamond'},
    }
})

minetest.register_craft({
    output = 'default:diamond 9',
    recipe = {
        {'default:diamondblock'},
    }
})

minetest.register_craft({
    output = 'default:sandstone',
    recipe = {
        {'group:sand', 'group:sand'},
        {'group:sand', 'group:sand'},
    }
})

minetest.register_craft({
    output = 'default:sand 4',
    recipe = {
        {'default:sandstone'},
    }
})

minetest.register_craft({
    output = 'default:clay',
    recipe = {
        {'default:clay_lump', 'default:clay_lump'},
        {'default:clay_lump', 'default:clay_lump'},
    }
})

minetest.register_craft({
    output = 'default:brick',
    recipe = {
        {'default:clay_brick', 'default:clay_brick'},
        {'default:clay_brick', 'default:clay_brick'},
    }
})

minetest.register_craft({
    output = 'default:clay_brick 4',
    recipe = {
        {'default:brick'},
    }
})

minetest.register_craft({
    output = 'default:paper 3',
    recipe = {
        {'default:sugar_cane', 'default:sugar_cane', 'default:sugar_cane'},
    }
})

minetest.register_craft({
    output = "default:sugar",
    recipe = {
    {"default:sugar_cane"},
    },
})

minetest.register_craft({
    output = 'default:book',
    recipe = {
        {'default:paper'},
        {'default:paper'},
        {'default:paper'},
    }
})

minetest.register_craft({
    output = 'default:bookshelf',
    recipe = {
        {'group:wood', 'group:wood', 'group:wood'},
        {'default:book', 'default:book', 'default:book'},
        {'group:wood', 'group:wood', 'group:wood'},
    }
})

minetest.register_craft({
    output = 'default:ladder 2',
    recipe = {
        {'default:stick', '', 'default:stick'},
        {'default:stick', 'default:stick', 'default:stick'},
        {'default:stick', '', 'default:stick'},
    }
})

minetest.register_craft({
    output = 'default:stonebrick 4',
    recipe = {
        {'default:stone', 'default:stone'},
        {'default:stone', 'default:stone'},
    }
})

minetest.register_craft({
    output = 'default:snowblock',
    recipe = {
        {'default:snow', 'default:snow'},
        {'default:snow', 'default:snow'},
    }
})

minetest.register_craft({
    output = 'default:snow 9',
    recipe = {
        {'default:snowblock'},
    }
})


minetest.register_craft({
    output = 'default:mese',
    recipe = {
        {'default:mese_crystal', 'default:mese_crystal', 'default:mese_crystal'},
        {'default:mese_crystal', 'default:mese_crystal', 'default:mese_crystal'},
        {'default:mese_crystal', 'default:mese_crystal', 'default:mese_crystal'},
    }
})

minetest.register_craft({
    output = 'default:mese_crystal 9',
    recipe = {
        {'default:mese'},
    }
})

minetest.register_craft({
    output = 'default:mese_crystal_fragment 9',
    recipe = {
        {'default:mese_crystal'},
    }
})

minetest.register_craft({
    output = 'default:obsidian_shard 9',
    recipe = {
        {'default:obsidian'}
    }
})

minetest.register_craft({
    output = 'default:desert_stonebrick',
    recipe = {
        {'default:desert_stone', 'default:desert_stone'},
        {'default:desert_stone', 'default:desert_stone'},
    }
})

minetest.register_craft({
    output = 'default:snowblock',
    recipe = {
        {'default:snow', 'default:snow', 'default:snow'},
        {'default:snow', 'default:snow', 'default:snow'},
        {'default:snow', 'default:snow', 'default:snow'},
    }
})

minetest.register_craft({
    output = 'default:snow 9',
    recipe = {
        {'default:snowblock'},
    }
})

minetest.register_craft({
    output = "default:flint_and_steel",
    recipe = {
       {'default:flint',''},
       {'','default:default:iron_ingot'},
       }
})

minetest.register_craft({
    output = "default:flint_and_steel",
    recipe = {
       {'','default:flint'},
       {'default:default:iron_ingot',''},
       }
})

minetest.register_craft({
    output = 'snow:snow_brick',
    recipe = {
        {'default:snowblock', 'default:snowblock'},
        {'default:snowblock', 'default:snowblock'},
    },
})

minetest.register_craft({
    output = "default:wormhole_chest",
    recipe = {
        {"default:obsidian", "default:obsidian", "default:obsidian"},
        {"default:obsidian", "4items:antimatter", "default:obsidian"},
        {"default:obsidian", "default:obsidian", "default:obsidian"},
    },
})

minetest.register_craft({
    output = "default:workbench",
    recipe = {
        {"group:wood", "group:wood"},
        {"group:wood", "group:wood"},
    },
})

--
-- Crafting (tool repair)
--
minetest.register_craft({
    type = "toolrepair",
    additional_wear = -0.02,
})

--
-- Cooking recipes
--

minetest.register_craft({
    type = "cooking",
    output = "default:glass",
    recipe = "group:sand",
})

minetest.register_craft({
    type = "cooking",
    output = "default:copper_ingot",
    recipe = "default:copper_lump",
})

minetest.register_craft({
    type = "cooking",
    output = "default:stone",
    recipe = "default:cobble",
})

minetest.register_craft({
    type = "cooking",
    output = "default:steel_ingot",
    recipe = "default:iron_lump",
})

minetest.register_craft({
    type = "cooking",
    output = "default:gold_ingot",
    recipe = "default:gold_lump",
})

minetest.register_craft({
    type = "cooking",
    output = "default:clay_brick",
    recipe = "default:clay_lump",
})

minetest.register_craft({
    type = "cooking",
    output = "default:charcoal",
    recipe = "group:tree",
})

--
-- Fuels
--

minetest.register_craft({
    type = "fuel",
    recipe = "group:tree",
    burntime = 30,
})

minetest.register_craft({
    type = "fuel",
    recipe = "default:junglegrass",
    burntime = 2,
})

minetest.register_craft({
    type = "fuel",
    recipe = "group:leaves",
    burntime = 1,
})

minetest.register_craft({
    type = "fuel",
    recipe = "default:cactus",
    burntime = 15,
})

minetest.register_craft({
    type = "fuel",
    recipe = "default:sugar_cane",
    burntime = 1,
})

minetest.register_craft({
    type = "fuel",
    recipe = "default:bookshelf",
    burntime = 30,
})

minetest.register_craft({
    type = "fuel",
    recipe = "default:fence",
    burntime = 15,
})

minetest.register_craft({
    type = "fuel",
    recipe = "default:ladder",
    burntime = 5,
})

minetest.register_craft({
    type = "fuel",
    recipe = "group:wood",
    burntime = 7,
})

minetest.register_craft({
    type = "fuel",
    recipe = "default:lava_source",
    burntime = 60,
})

minetest.register_craft({
    type = "fuel",
    recipe = "default:torch",
    burntime = 4,
})

minetest.register_craft({
    type = "fuel",
    recipe = "default:sign",
    burntime = 10,
})

minetest.register_craft({
    type = "fuel",
    recipe = "default:chest",
    burntime = 30,
})

minetest.register_craft({
    type = "fuel",
    recipe = "default:sapling",
    burntime = 10,
})

minetest.register_craft({
    type = "fuel",
    recipe = "default:apple",
    burntime = 3,
})

minetest.register_craft({
    type = "fuel",
    recipe = "group:coal",
    burntime = 40,
})

minetest.register_craft({
    type = "fuel",
    recipe = "default:junglesapling",
    burntime = 10,
})

minetest.register_craft({
    type = "fuel",
    recipe = "default:grass_1",
    burntime = 2,
})


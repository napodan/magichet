-- mods/default/craftitems.lua
minetest.register_craftitem("default:flint", {
    description = "Flint",
    inventory_image = "default_flint.png",
})


minetest.register_craftitem("default:stick", {
    description = "Stick",
    inventory_image = "default_stick.png",
        groups = {stick=1},
})

minetest.register_craftitem("default:sugar", {
    description = "Sugar",
    inventory_image = "default_sugar.png",
})

minetest.register_craftitem("default:paper", {
    description = "Paper",
    inventory_image = "default_paper.png",
})

minetest.register_craftitem("default:book", {
    description = "Book",
    inventory_image = "default_book.png",
})

minetest.register_craftitem("default:coal", {
    description = "Coal",
    inventory_image = "default_coal.png",
    groups = {coal=1},
})

minetest.register_craftitem("default:copper_lump", {
    description = "Copper Lump",
    inventory_image = "default_copper_lump.png",
})


minetest.register_craftitem("default:gold_lump", {
    description = "Gold Lump",
    inventory_image = "default_gold_lump.png",
})

minetest.register_craftitem("default:copper_ingot", {
    description = "Copper Ingot",
    inventory_image = "default_copper_ingot.png",
})

minetest.register_craftitem("default:charcoal", {
    description = "Charcoal",
    inventory_image = "default_coal.png",
    groups = {coal=1},
})

minetest.register_craftitem("default:mese_crystal_fragment", {
    description = "Mese Crystal Fragment",
    inventory_image = "default_mese_crystal_fragment.png",
})

minetest.register_craftitem("default:mese_crystal", {
    description = "Mese Crystal",
    inventory_image = "default_mese_crystal.png",
})

minetest.register_craftitem("default:diamond", {
    description = "Diamond",
    inventory_image = "default_diamond.png",
})

minetest.register_craftitem("default:clay_lump", {
    description = "Clay Lump",
    inventory_image = "default_clay_lump.png",
})

minetest.register_craftitem("default:iron_ingot", {
    description = "Iron Ingot",
    inventory_image = "default_iron_ingot.png",
})

minetest.register_craftitem("default:iron_lump", {
    description = "Iron Lump",
    inventory_image = "default_iron_lump.png",
})

minetest.register_craftitem("default:bronze_ingot", {
    description = "Bronze Ingot",
    inventory_image = "default_bronze_ingot.png",
})

minetest.register_craftitem("default:gold_ingot", {
    description = "Gold Ingot",
    inventory_image = "default_gold_ingot.png",
})

minetest.register_craftitem("default:gold_nugget", {
    description = "Gold Nugget",
    inventory_image = "default_gold_nugget.png",
})

minetest.register_craftitem("default:clay_brick", {
    description = "Brick",
    inventory_image = "default_clay_brick.png",
})

minetest.register_craftitem("default:apple_gold", {
    description = "Golden Apple",
    inventory_image = "default_apple_gold.png",
    on_use = minetest.item_eat(),
})

minetest.register_craftitem("default:apple_gold2", {
    description = "Golden Apple",
    inventory_image = "default_apple_gold.png",
    on_use = minetest.item_eat(),
})

minetest.register_craftitem("default:obsidian_shard", {
    description = "Obsidian Shard",
    inventory_image = "default_obsidian_shard.png",
})

-- mods/default/nodes.lua
-- edited by 4aiman to bring back bronze & MESE & apples, add workbenches,
-- meshed chests etc

global_timer=0
minetest.after(15,function(dtime)
   global_timer=20
   print('15 sec has passed, be ready for the lags')
end)

minetest.register_node("default:apple", {
    description = "Apple",
    drawtype = "plantlike",
    visual_scale = 1.0,
    tiles = {"default_apple.png"},
    inventory_image = "default_apple.png",
    paramtype = "light",
    sunlight_propagates = true,
    walkable = false,
    is_ground_content = false,
    selection_box = {
        type = "fixed",
        fixed = {-0.2, -0.5, -0.2, 0.2, 0, 0.2}
    },
    groups = {dig_immediate=2,flammable=2,leafdecay=3,leafdecay_drop=1},
    on_use = minetest.item_eat(1),
    sounds = default.node_sound_leaves_defaults(),
    after_place_node = function(pos, placer, itemstack)
        if placer:is_player() then
            minetest.set_node(pos, {name="default:apple", param2=1})
        end
    end,
})

minetest.register_node("default:stone", {
    description = "Stone",
    tiles = {"default_stone.png"},
    is_ground_content = true,
    groups = {cracky=default.dig.stone, stone=1},
    drop = 'default:cobble',
    legacy_mineral = true,
    sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("default:desert_stone", {
    description = "Desert Stone",
    tiles = {"default_desert_stone.png"},
    is_ground_content = true,
    groups = {cracky=default.dig.stone, stone=1},
    drop = 'default:desert_stone',
    legacy_mineral = true,
    sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("default:desert_stonebrick", {
    description = "Desert Stone Brick",
    tiles = {"default_desert_stone_brick.png"},
    groups = {cracky=default.dig.stone, stone=1},
    sounds = default.node_sound_stone_defaults(),
})

--Snow brick.
minetest.register_node("default:snow_brick", {
    description = "Snow Brick",
    tiles = {"default_snow_brick.png"},
    groups = {crumbly=default.dig.gravel,melts=2},
    drop = 'default:snow_brick',
    sounds = default.node_sound_dirt_defaults({
        footstep = {name="default_grass_footstep", gain=0.4},
    }),
})

minetest.register_craft({
    output = 'snow:snow_brick',
    recipe = {
        {'default:snowblock', 'default:snowblock'},
        {'default:snowblock', 'default:snowblock'},
    },
})

minetest.register_node("default:desert_sand", {
    description = "Desert Sand",
    tiles = {"default_desert_sand.png"},
    groups = {crumbly=default.dig.sand, falling_node=1, sand=1},
    sounds = default.node_sound_sand_defaults(),
})

minetest.register_node("default:stone_with_coal", {
    description = "Coal Ore",
    tiles = {"default_stone.png^default_mineral_coal.png"},
    is_ground_content = true,
    groups = {cracky=default.dig.coal},
    drop = 'default:coal',
    sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("default:stone_with_copper", {
    description = "Copper Ore",
    tiles = {"default_stone.png^default_mineral_copper.png"},
    is_ground_content = true,
    groups = {cracky=default.dig.iron},
    drop = 'default:copper_lump',
    sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("default:copperblock", {
    description = "Copper Block",
    tiles = {"default_copper_block.png"},
    groups = {cracky=default.dig.iron},
    sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("default:stone_with_mese", {
    description = "Mese Ore",
    tiles = {"default_stone.png^default_mineral_mese.png"},
    is_ground_content = true,
    groups = {cracky=default.dig.ironblock},
    drop = "default:mese_crystal",
    sounds = default.node_sound_stone_defaults(),
})


minetest.register_node("default:bronzeblock", {
    description = "Bronze Block",
    tiles = {"default_bronze_block.png"},
    groups = {cracky=default.dig.ironblock},
    sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("default:mese", {
    description = "Mese Block",
    tiles = {"default_mese_block.png"},
    is_ground_content = true,
    groups = {cracky=default.dig.diamondblock},
    sounds = default.node_sound_stone_defaults(),
})
minetest.register_alias("default:mese_block", "default:mese")


minetest.register_node("default:iron", {
    description = "Iron Ore",
    tiles = {"default_stone.png^default_mineral_iron.png"},
    is_ground_content = true,
    groups = {cracky=default.dig.iron},
    sounds = default.node_sound_stone_defaults(),
        drop = 'default:iron_lump',
})

minetest.register_node("default:gold", {
    description = "Gold Ore",
    tiles = {"default_stone.png^default_mineral_gold.png"},
    is_ground_content = true,
    groups = {cracky=default.dig.gold},
    sounds = default.node_sound_stone_defaults(),
        drop = 'default:gold_lump',
})

minetest.register_node("default:stone_with_diamond", {
    description = "Diamonds in Stone",
    tiles = {"default_stone.png^default_mineral_diamond.png"},
    is_ground_content = true,
    groups = {cracky=default.dig.diamond},
    drop = "default:diamond",
    sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("default:stonebrick", {
    description = "Stone Brick",
    tiles = {"default_stone_brick.png"},
    groups = {cracky=default.dig.stone, stone=1},
    sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("default:dirt_with_grass", {
    description = "Dirt with Grass",
    tiles = {"default_grass.png", "default_dirt.png", "default_dirt.png^default_grass_side.png"},
    groups = {crumbly=default.dig.dirt_with_grass,soil=1},
    drop = 'default:dirt',
    sounds = default.node_sound_dirt_defaults({
        footstep = {name="default_grass_footstep", gain=0.4},
    }),
})

minetest.register_node("default:dirt_with_snow", {
    description = "Dirt with Snow",
    tiles = {"default_snow.png", "default_dirt.png", "default_dirt.png^default_snow_side.png"},
    is_ground_content = true,
    groups = {crumbly=default.dig.dirt_with_grass},
    drop = 'default:dirt',
    sounds = default.node_sound_dirt_defaults({
        footstep = {name="default_grass_footstep", gain=0.4},
    }),
})
minetest.register_alias("dirt_with_snow", "default:dirt_with_snow")

minetest.register_node("default:dirt", {
    description = "Dirt",
    tiles = {"default_dirt.png"},
    groups = {crumbly=default.dig.dirt,soil=1},
    sounds = default.node_sound_dirt_defaults(),
    drop = 'default:dirt 2',
})

minetest.register_node("default:sand", {
    description = "Sand",
    tiles = {"default_sand.png"},
    groups = {crumbly=default.dig.sand, falling_node=1, sand=1},
    sounds = default.node_sound_sand_defaults(),
})

minetest.register_node("default:gravel", {
    description = "Gravel",
    tiles = {"default_gravel.png"},
    drop = {
        max_items = 1,
        items = {
            {items={"default:flint"},rarity=10},
            {items={"default:gravel"}},
        },
    },
    groups = {crumbly=default.dig.gravel, falling_node=1},
    sounds = default.node_sound_dirt_defaults({
        footstep = {name="default_gravel_footstep", gain=0.45},
    }),
})

minetest.register_node("default:sandstone", {
    description = "Sandstone",
    tiles = {"default_sandstone_top.png","default_sandstone_bottom.png","default_sandstone_side.png"},
    groups = {cracky=default.dig.sandstone},
    sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("default:sandstonebrick", {
    description = "Sandstone Brick",
    tiles = {"default_sandstone_brick.png"},
    groups = {cracky=2},
    sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("default:clay", {
    description = "Clay",
    tiles = {"default_clay.png"},
    is_ground_content = true,

    groups = {crumbly=default.dig.clay},
    drop = 'default:clay_lump 4',
    sounds = default.node_sound_dirt_defaults({
        footstep = "",
    }),
})

minetest.register_node("default:brick", {
    description = "Bricks",
    tiles = {"default_brick.png"},

    groups = {cracky=default.dig.brick},
    sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("default:tree", {
    description = "Tree",
    tiles = {"default_tree_top.png", "default_tree_top.png", "default_tree.png"},
    is_ground_content = true,

    groups = {tree=1,choppy=default.dig.tree,flammable=2},
    sounds = default.node_sound_wood_defaults(),
})

minetest.register_node("default:jungletree", {
    description = "Jungle Tree",
    tiles = {"default_jungletree_top.png", "default_jungletree_top.png", "default_jungletree.png"},
    is_ground_content = true,

    groups = {tree=1,choppy=default.dig.tree,flammable=2},
    sounds = default.node_sound_wood_defaults(),
})

minetest.register_node("default:junglewood", {
    description = "Junglewood Planks",
    tiles = {"default_junglewood.png"},
    is_ground_content = true,

    groups = {choppy=default.dig.wood,flammable=3,wood=1},
    sounds = default.node_sound_wood_defaults(),
})

minetest.register_node("default:jungleleaves", {
    description = "Jungle Leaves",
    drawtype = "allfaces_optional",
    visual_scale = 1.3,
    tiles = {"default_jungleleaves.png"},
    paramtype = "light",
    groups = {snappy=default.dig.leaves, leafdecay=3, flammable=2, leaves=1},
    drop = "",

    sounds = default.node_sound_leaves_defaults(),
    after_dig_node = function(pos, oldnode, oldmetadata, digger)
        local nn = "default:jungleleaves"
        if math.random(1, 20) == 1 then
            nn = "default:junglesapling"
        end
        if minetest.setting_getbool("creative_mode") then
            local inv = digger:get_inventory()
            if not inv:contains_item("main", ItemStack(nn)) then
                inv:add_item("main", ItemStack(nn))
            end
        else
            if digger:get_wielded_item():get_name() == "default:shears" or nn ~= "default:jungleleaves" then
                local obj = minetest.add_item(pos, nn)
                if obj ~= nil then
                    obj:get_luaentity().collect = true
                    local x = math.random(1, 5)
                    if math.random(1,2) == 1 then
                        x = -x
                    end
                    local z = math.random(1, 5)
                    if math.random(1,2) == 1 then
                        z = -z
                    end
                    obj:setvelocity({x=1/x, y=obj:getvelocity().y, z=1/z})
                end
            end
        end
    end,
    after_place_node = function(pos, placer, itemstack)
        minetest.set_node(pos, {name="default:jungleleaves", param2=1})
    end,
})

minetest.register_node("default:junglesapling", {
    description = "Jungle Sapling",
    drawtype = "plantlike",
    visual_scale = 1.0,
    tiles = {"default_junglesapling.png"},
    inventory_image = "default_junglesapling.png",
    wield_image = "default_junglesapling.png",
    paramtype = "light",
    walkable = false,
    selection_box = {
        type = "fixed",
        fixed = {-0.3, -0.5, -0.3, 0.3, 0.35, 0.3}
    },

    groups = {dig_immediate=3,flammable=2,attached_node=1},
    sounds = default.node_sound_defaults(),
})
-- aliases for tree growing abm in content_abm.cpp
minetest.register_alias("sapling", "default:sapling")
minetest.register_alias("junglesapling", "default:junglesapling")

minetest.register_node("default:junglegrass", {
    description = "Jungle Grass",
    drawtype = "plantlike",
    visual_scale = 1.3,
    tiles = {"default_junglegrass.png"},
    inventory_image = "default_junglegrass.png",
    wield_image = "default_junglegrass.png",
    paramtype = "light",
    walkable = false,
    buildable_to = true,
    is_ground_content = true,
    drop = "",

    groups = {snappy = default.dig.grass, dig_immediate=3,flammable=2,flora=1,attached_node=1},
    sounds = default.node_sound_leaves_defaults(),
    selection_box = {
        type = "fixed",
        fixed = {-0.5, -0.5, -0.5, 0.5, -5/16, 0.5},
    },
})

minetest.register_node("default:leaves", {
    description = "Leaves",
    drawtype = "allfaces_optional",
    visual_scale = 1.3,
    tiles = {"default_leaves.png"},
    paramtype = "light",
    groups = {snappy=default.dig.leaves, leafdecay=3, flammable=2, leaves=1},
    drop = "",

    sounds = default.node_sound_leaves_defaults(),
    after_dig_node = function(pos, oldnode, oldmetadata, digger)
        local nn = "default:leaves"
        if math.random(1, 30) == 1 then
            nn = "default:appleapple"
        end
        if math.random(1, 20) == 1 then
            nn = "default:sapling"
        end
        if minetest.setting_getbool("creative_mode") then
            local inv = digger:get_inventory()
            if not inv:contains_item("main", ItemStack(nn)) then
                inv:add_item("main", ItemStack(nn))
            end
        else
            if digger:get_wielded_item():get_name() == "default:shears" or nn ~= "default:leaves" then
                local obj = minetest.add_item(pos, nn)
                if obj ~= nil then
                    obj:get_luaentity().collect = true
                    local x = math.random(1, 5)
                    if math.random(1,2) == 1 then
                        x = -x
                    end
                    local z = math.random(1, 5)
                    if math.random(1,2) == 1 then
                        z = -z
                    end
                    obj:setvelocity({x=1/x, y=obj:getvelocity().y, z=1/z})
                end
            end
        end
    end,
    after_place_node = function(pos, placer, itemstack)
        minetest.set_node(pos, {name="default:leaves", param2=1})
    end,
})

minetest.register_node("default:cactus", {
    description = "Cactus",
    tiles = {"default_cactus_top.png", "default_cactus_top.png", "default_cactus_side.png"},
    is_ground_content = true,
    groups = {snappy=1,choppy=3,flammable=2,oddly_breakable_by_hand=2},
    sounds = default.node_sound_wood_defaults(),
    drawtype = "nodebox",
    paramtype = "light",
    damage_per_second = 1,
    node_box = {
        type = "fixed",
        fixed = {{-7/16, -0.5, -7/16, 7/16, 0.5, 7/16}, {-8/16, -0.5, -7/16, -7/16, 0.5, -7/16},
             {7/16, -0.5, -7/16, 7/16, 0.5, -8/16},{-7/16, -0.5, 7/16, -7/16, 0.5, 8/16},{7/16, -0.5, 7/16, 8/16, 0.5, 7/16}}--
    },
    selection_box = {
        type = "fixed",
        fixed = {-7/16, -0.5, -7/16, 7/16, 0.5, 7/16},

    },
    on_punch = function(pos, node, puncher)
        if not puncher then return end

        if puncher:get_wielded_item():get_name() == "" then
            minetest.sound_play("player_damage", {pos = pos, gain = 0.3, max_hear_distance = 10})
        end
    end,
    on_place = minetest.rotate_node

})

minetest.register_node("default:sugar_cane", {
    description = "Sugar Cane",
    drawtype = "plantlike",
    tiles = {"default_sugar_cane.png"},
    inventory_image = "default_sugar_cane.png",
    wield_image = "default_sugar_cane.png",
    paramtype = "light",
    walkable = false,
    is_ground_content = true,
    selection_box = {
        type = "fixed",
        fixed = {-0.3, -0.5, -0.3, 0.3, 0.5, 0.3}
    },

    groups = {dig_immediate=3,flammable=2},
    sounds = default.node_sound_leaves_defaults(),
})

minetest.register_node("default:bookshelf", {
    description = "Bookshelf",
    tiles = {"default_wood.png", "default_wood.png", "default_bookshelf.png"},
    groups = {choppy=default.dig.bookshelf,flammable=3},
    sounds = default.node_sound_wood_defaults(),
})

minetest.register_node("default:glass", {
    description = "Glass",
    drawtype = "glasslike",
    tiles = {"default_glass.png"},
    inventory_image = minetest.inventorycube("default_glass.png"),
    sunlight_propagates = true,
    paramtype = "light",
    use_texture_alpha = true,
    drop = "",   -- no glass for ya!
    groups = {dig=default.dig.glass},
    sounds = default.node_sound_glass_defaults(),
})

minetest.register_node("default:fence", {
    description = "Wooden Fence",
    drawtype = "fencelike",
    tiles = {"default_wood.png"},
    inventory_image = "default_fence.png",
    wield_image = "default_fence.png",
    paramtype = "light",
    selection_box = {
        type = "fixed",
        fixed = {-1/7, -1/2, -1/7, 1/7, 1/2, 1/7},
    },
    node_box = {
        type = "fixed",
        fixed = {
            {-0.2, -0.5, -0.2, 0.2, 1.0, 0.2},
        },
    },
    groups = {choppy=default.dig.fence,flammable=2},
    sounds = default.node_sound_wood_defaults(),
})

minetest.register_node("default:rail", {
    description = "Rail",
    drawtype = "raillike",
    tiles = {"default_rail.png", "default_rail_curved.png", "default_rail_t_junction.png", "default_rail_crossing.png"},
    inventory_image = "default_rail.png",
    wield_image = "default_rail.png",
    paramtype = "light",
    walkable = false,

    selection_box = {
        type = "fixed",
                -- but how to specify the dimensions for curved and sideways rails?
                fixed = {-1/2, -1/2, -1/2, 1/2, -1/2+1/16, 1/2},
    },
    groups = {cracky=default.dig.rail,attached_node=1},
})

minetest.register_node("default:ladder", {
    description = "Ladder",
    drawtype = "signlike",
    tiles = {"default_ladder.png"},
    inventory_image = "default_ladder.png",
    wield_image = "default_ladder.png",
    paramtype = "light",
    paramtype2 = "wallmounted",
    walkable = false,
    climbable = true,
    selection_box = {
        type = "wallmounted",
        --wall_top = = <default>
        --wall_bottom = = <default>
        --wall_side = = <default>
    },
    groups = {dig=default.dig.ladder,flammable=2,attached_node=1},
    legacy_wallmounted = true,

    sounds = default.node_sound_wood_defaults(),
})

minetest.register_node("default:wood", {
    description = "Wooden Planks",
    tiles = {"default_wood.png"},
    groups = {choppy=default.dig.wood,flammable=3,wood=1},
    sounds = default.node_sound_wood_defaults(),
})

minetest.register_node("default:cloud", {
    description = "Cloud",
    tiles = {"default_cloud.png"},
    sounds = default.node_sound_defaults(),

    groups = {not_in_creative_inventory=1},
})

minetest.register_node("default:water_flowing", {
    description = "Flowing Water",
    inventory_image = minetest.inventorycube("default_water.png"),
    drawtype = "flowingliquid",
    tiles = {"default_water.png"},
    special_tiles = {
        {
            image="default_water_flowing_animated.png",
            backface_culling=false,
            animation={type="vertical_frames", aspect_w=32, aspect_h=32, length=0.8}
        },
        {
            image="default_water_flowing_animated.png",
            backface_culling=true,
            animation={type="vertical_frames", aspect_w=32, aspect_h=32, length=0.8}
        },
    },
    alpha = WATER_ALPHA,
    paramtype = "light",
    walkable = false,
    pointable = false,
    diggable = false,
    drowning = 2,
    buildable_to = true,
    drop = "",
    liquidtype = "flowing",
    liquid_alternative_flowing = "default:water_flowing",
    liquid_alternative_source = "default:water_source",
    liquid_viscosity = WATER_VISC,
    post_effect_color = {a=64, r=100, g=100, b=200},
    groups = {water=3, liquid=3, puts_out_fire=1, not_in_creative_inventory=1},
})

minetest.register_node("default:water_source", {
    description = "Water Source",
    inventory_image = minetest.inventorycube("default_water.png"),
    drawtype = "liquid",
    tiles = {
        {name="default_water_source_animated.png", animation={type="vertical_frames", aspect_w=32, aspect_h=32, length=2.0}}
    },
    special_tiles = {
        -- New-style water source material (mostly unused)
        {
            name="default_water_source_animated.png",
            animation={type="vertical_frames", aspect_w=32, aspect_h=32, length=2.0},
            backface_culling = false,
        }
    },
    alpha = WATER_ALPHA,
    paramtype = "light",
    walkable = false,
    pointable = false,
    diggable = false,
    buildable_to = true,
    drop = "",
    drowning = 1,
    liquidtype = "source",
    liquid_alternative_flowing = "default:water_flowing",
    liquid_alternative_source = "default:water_source",
    liquid_viscosity = WATER_VISC,
    post_effect_color = {a=64, r=100, g=100, b=200},
    groups = {water=3, liquid=3, puts_out_fire=1},
})

minetest.register_node("default:lava_flowing", {
    description = "Flowing Lava",
    inventory_image = minetest.inventorycube("default_lava.png"),
    drawtype = "flowingliquid",
    tiles = {"default_lava.png"},
    special_tiles = {
        {
            image="default_lava_flowing_animated.png",
            backface_culling=false,
            animation={type="vertical_frames", aspect_w=16, aspect_h=16, length=3.3}
        },
        {
            image="default_lava_flowing_animated.png",
            backface_culling=true,
            animation={type="vertical_frames", aspect_w=16, aspect_h=16, length=3.3}
        },
    },
    paramtype = "light",
    light_source = 15,
    walkable = false,
    pointable = false,
    diggable = false,
    buildable_to = true,
    drop = "",
    liquidtype = "flowing",
    liquid_alternative_flowing = "default:lava_flowing",
    liquid_alternative_source = "default:lava_source",
    liquid_viscosity = LAVA_VISC,
    liquid_renewable = false,
    damage_per_second = 4,
    post_effect_color = {a=192, r=255, g=64, b=0},
    groups = {lava=3, liquid=2, hot=3, igniter=1, not_in_creative_inventory=1},
})

minetest.register_node("default:lava_source", {
    description = "Lava Source",
    inventory_image = minetest.inventorycube("default_lava.png"),
    drawtype = "liquid",
    tiles = {
        {name="default_lava_source_animated.png", animation={type="vertical_frames", aspect_w=16, aspect_h=16, length=3.0}}
    },
    special_tiles = {
        -- New-style lava source material (mostly unused)
        {
            name="default_lava_source_animated.png",
            animation={type="vertical_frames", aspect_w=16, aspect_h=16, length=3.0},
            backface_culling = false,
        }
    },
    paramtype = "light",
    light_source = 15,
    walkable = false,
    pointable = false,
    diggable = false,
    buildable_to = true,
    drop = "",
    liquidtype = "source",
    liquid_alternative_flowing = "default:lava_flowing",
    liquid_alternative_source = "default:lava_source",
    liquid_viscosity = LAVA_VISC,
    liquid_renewable = false,
    damage_per_second = 3,
    post_effect_color = {a=192, r=255, g=64, b=0},
    groups = {lava=3, liquid=2, hot=3, igniter=1},
    is_ground_content = true,
})

minetest.register_node("default:torch", {
    description = "Torch",
    drawtype = "torchlike",
    tiles = {
        {name="default_torch_on_floor_animated.png", animation={type="vertical_frames", aspect_w=16, aspect_h=16, length=3.0}},
        {name="default_torch_animated.png", animation={type="vertical_frames", aspect_w=16, aspect_h=16, length=3.0}}
    },
    inventory_image = "default_torch_on_floor.png",
    wield_image = "default_torch_on_floor.png",
    paramtype = "light",
    paramtype2 = "wallmounted",
    sunlight_propagates = true,
    walkable = false,
    wield_light = 12,
    light_source = 12,
    selection_box = {
        type = "wallmounted",
        wall_bottom = {-0.1, -0.5, -0.1, 0.1, -0.5+0.6, 0.1},
        wall_side = {-0.5, -0.3, -0.1, -0.5+0.3, 0.3, 0.1},
    },
    groups = {dig_immediate=3,flammable=1,attached_node=1},
    legacy_wallmounted = true,

    sounds = default.node_sound_defaults(),
    on_place = function(itemstack, placer, pointed_thing)
        if pointed_thing.type ~= "node" then
            return itemstack
        end

        local p0 = pointed_thing.under
        local p1 = pointed_thing.above
        if p0.y-1 == p1.y then
            return itemstack
        end

        return minetest.item_place(itemstack, placer, pointed_thing)
    end,
})

minetest.register_node("default:sign_wall", {
    description = "Sign",
    drawtype = "signlike",
    tiles = {"default_sign_wall.png"},
    inventory_image = "default_sign_wall.png",
    wield_image = "default_sign_wall.png",
    paramtype = "light",
    paramtype2 = "wallmounted",
    sunlight_propagates = true,
    walkable = false,
    selection_box = {
        type = "wallmounted",
        --wall_top = <default>
        --wall_bottom = <default>
        --wall_side = <default>
    },
    groups = {choppy=default.dig.sign,attached_node=1},
    legacy_wallmounted = true,
    sounds = default.node_sound_defaults(),
    on_construct = function(pos)
        --local n = minetest.get_node(pos)
        local meta = minetest.get_meta(pos)
        meta:set_string("formspec", "field[text;;${text}]")
        meta:set_string("infotext", "\"\"")
    end,
    on_receive_fields = function(pos, formname, fields, sender)
        --print("Sign at "..minetest.pos_to_string(pos).." got "..dump(fields))
        local meta = minetest.get_meta(pos)
        fields.text = fields.text or ""
        print((sender:get_player_name() or "").." wrote \""..fields.text..
                "\" to sign at "..minetest.pos_to_string(pos))
        meta:set_string("text", fields.text)
        meta:set_string("infotext", '"'..fields.text..'"')
    end,
})

local function get_chest_neighborpos(pos, param2, side)
    if side == "right" then
        if param2 == 0 then
            return {x=pos.x-1, y=pos.y, z=pos.z}
        elseif param2 == 1 then
            return {x=pos.x, y=pos.y, z=pos.z+1}
        elseif param2 == 2 then
            return {x=pos.x+1, y=pos.y, z=pos.z}
        elseif param2 == 3 then
            return {x=pos.x, y=pos.y, z=pos.z-1}
        end
    else
        if param2 == 0 then
            return {x=pos.x+1, y=pos.y, z=pos.z}
        elseif param2 == 1 then
            return {x=pos.x, y=pos.y, z=pos.z-1}
        elseif param2 == 2 then
            return {x=pos.x-1, y=pos.y, z=pos.z}
        elseif param2 == 3 then
            return {x=pos.x, y=pos.y, z=pos.z+1}
        end
    end
end

-- 3d chest!
local tdc = {
    --hp =1,
    physical = true,
    collisionbox = {-0.5,-0.5,-0.5, 0.5,0.5,0.5},
    visual = "mesh",
    visual_size = {x=5, y=5, z=5},
    mesh = "chest_proto.x",
    --mesh = "character.x",
    textures = {"default_chest3d.png"},
    makes_footstep_sound = true,
    groups = {choppy=default.dig.wood},
    on_punch = function(self, hitter)
       if self.object:get_hp()<=0 then
          local pos = self.object:getpos()
          local node = minetest.get_node(pos)
          local digger = hitter

            local meta = minetest.get_meta(pos)
            local meta2 = meta
            local inv = meta:get_inventory()
                for i=1,inv:get_size("main") do
                    local stack = inv:get_stack("main", i)
                    if not stack:is_empty() then
                        local p = {x=pos.x+math.random(0, 10)/10-0.5, y=pos.y, z=pos.z+math.random(0, 10)/10-0.5}
                        minetest.add_item(p, stack)
                    end
                end
            minetest.remove_node(pos)
       end
    end,
    on_activate = function(self, staticdata, dtime_s)
        if staticdata then
            local tmp = minetest.deserialize(staticdata)
            if tmp and tmp.textures then
                self.textures = tmp.textures
                self.object:set_properties({textures=self.textures})
            end
            if tmp and tmp.visual then
                self.visual = tmp.visual
                self.object:set_properties({visual=self.visual})
            end
            if tmp and tmp.mesh then
                self.mesh = tmp.mesh
                self.object:set_properties({mesh=self.mesh})
            end
        end
    end,

    get_staticdata = function(self)
        local tmp = {
            textures = self.textures,
            visual = self.visual,
            mesh = self.mesh,
        }
        return minetest.serialize(tmp)
    end,
    on_step = function(self, dtime)
       local pos = self.object:getpos()
       if minetest.get_node(pos).name ~='default:chest' then
          self.object:remove()
          return
       end
    end,
    on_rightclick = function (self, clicker)
       local pos = self.object:getpos()
       local meta = minetest.get_meta(pos)
       local name = 'default:3dchest'
       local pll = clicker:get_player_name()


       local formspec = meta:get_string('formspec')
      -- print(formspec)
      -- print(minetest.get_node(pos).name .. ' at ' .. minetest.pos_to_string(pos))
       self.object:set_animation({x=10,y=25}, 60, 0)
       minetest.after(0.1,function(dtime)
           self.object:set_animation({x=25,y=25}, 20, 0)
       end)
       minetest.sound_play('chestopen', {pos = pos, gain = 0.3, max_hear_distance = 5})
       minetest.show_formspec(pll, name..'_'..minetest.serialize(pos), formspec)
    end,
}

minetest.register_entity('default:3dchest', tdc)

minetest.register_node("default:chest", {
    description = "Chest",
    tiles = {"default_chest_top.png", "default_chest_top.png", "default_chest_side.png",
        "default_chest_side.png", "default_chest_side.png", "default_chest_front.png"},
    paramtype2 = "facedir",
    -- temporary workover
    wield_image = minetest.inventorycube("default_chest_top.png", "default_chest_side.png", "default_chest_front.png"),
    drawtype = "normal",
    visual_scale = 0.05,
    paramtype = "light",
    walkable = true,
    groups = {choppy=default.dig.chest},
    legacy_facedir_simple = true,
    sounds = default.node_sound_wood_defaults(),
    on_construct = function(pos)
        local param2 = minetest.get_node(pos).param2
        local meta = minetest.get_meta(pos)
      --[[  if minetest.get_node(get_chest_neighborpos(pos, param2, "right")).name == "default:chest" then
            minetest.set_node(pos, {name="default:chest_right",param2=param2})
            local p = get_chest_neighborpos(pos, param2, "right")
            meta:set_string("formspec",
            "size[9,10.2]"..
            "bgcolor[#bbbbbb;false]"..
            "listcolors[#777777;#cccccc;#333333;#555555;#dddddd]"..

            "image_button[9.0,-0.3;0.80,1.7;b_bg2.png;just_bg;Z;true;false]"..
            "image_button[9.2,-0.2;0.5,0.5;b_bg.png;sort_horz;=;true;true]"..
            "image_button[9.2,0.3;0.5,0.5;b_bg.png;sort_vert;||;true;true]"..
            "image_button[9.2,0.8;0.5,0.5;b_bg.png;sort_norm;z;true;true]"..

            "list[nodemeta:"..p.x..","..p.y..","..p.z..";main;0,3;9,3;]"..
            "list[context;main;0,0;9,3;]"..

            "list[current_player;main;0,6.2;9,3;9]"..
            "list[current_player;main;0,9.4;9,1;]")            meta:set_string("infotext", "Large Chest")
            minetest.swap_node(p, {name="default:chest_left", param2=param2})
            local m = minetest.get_meta(p)
            m:set_string("formspec",
            "size[9,10.2]"..
            "bgcolor[#bbbbbb;false]"..
            "listcolors[#777777;#cccccc;#333333;#555555;#dddddd]"..

            "image_button[9.0,-0.3;0.80,1.7;b_bg2.png;just_bg;Z;true;false]"..
            "image_button[9.2,-0.2;0.5,0.5;b_bg.png;sort_horz;=;true;true]"..
            "image_button[9.2,0.3;0.5,0.5;b_bg.png;sort_vert;||;true;true]"..
            "image_button[9.2,0.8;0.5,0.5;b_bg.png;sort_norm;Z;true;true]"..

            "list[nodemeta:"..pos.x..","..pos.y..","..pos.z..";main;0,0;9,3;]"..
            "list[context;main;0,3;9,3;]"..

            "list[current_player;main;0,6.2;9,3;9]"..
            "list[current_player;main;0,9.4;9,1;]")
            m:set_string("infotext", "Large Chest")
        elseif minetest.get_node(get_chest_neighborpos(pos, param2, "left")).name == "default:chest" then
            minetest.set_node(pos, {name="default:chest_left",param2=param2})
            local p = get_chest_neighborpos(pos, param2, "left")
            meta:set_string("formspec",
            "size[9,10.2]"..
            "bgcolor[#bbbbbb;false]"..
            "listcolors[#777777;#cccccc;#333333;#555555;#dddddd]"..

            "image_button[9.0,-0.3;0.80,1.7;b_bg2.png;just_bg;Z;true;false]"..
            "image_button[9.2,-0.2;0.5,0.5;b_bg.png;sort_horz;=;true;true]"..
            "image_button[9.2,0.3;0.5,0.5;b_bg.png;sort_vert;||;true;true]"..
            "image_button[9.2,0.8;0.5,0.5;b_bg.png;sort_norm;Z;true;true]"..

            "list[nodemeta:"..p.x..","..p.y..","..p.z..";main;0,3;9,3;]"..
            "list[context;main;0,0;9,3;]"..

            "list[current_player;main;0,6.2;9,3;9]"..
            "list[current_player;main;0,9.4;9,1;]")
            meta:set_string("infotext", "Large Chest")
            minetest.swap_node(p, {name="default:chest_right", param2=param2})
            local m = minetest.get_meta(p)
            m:set_string("formspec",
            "size[9,10.2]"..
            "bgcolor[#bbbbbb;false]"..
            "listcolors[#777777;#cccccc;#333333;#555555;#dddddd]"..

            "image_button[9.0,-0.3;0.80,1.7;b_bg2.png;just_bg;Z;true;false]"..
            "image_button[9.2,-0.2;0.5,0.5;b_bg.png;sort_horz;=;true;true]"..
            "image_button[9.2,0.3;0.5,0.5;b_bg.png;sort_vert;||;true;true]"..
            "image_button[9.2,0.8;0.5,0.5;b_bg.png;sort_norm;Z;true;true]"..

            "list[nodemeta:"..pos.x..","..pos.y..","..pos.z..";main;0,0;9,3;]"..
            "list[context;main;0,3;9,3;]"..

            "list[current_player;main;0,6.2;9,3;9]"..
            "list[current_player;main;0,9.4;9,1;]")
            m:set_string("infotext", "Large Chest")
        else]]--
            meta:set_string("formspec",
            "size[9,7.2]"..
            "bgcolor[#bbbbbb;false]"..
            "listcolors[#777777;#cccccc;#333333;#555555;#dddddd]"..

            "image_button[9.0,-0.3;0.80,1.7;b_bg2.png;just_bg;Z;true;false]"..
            "image_button[9.2,-0.2;0.5,0.5;b_bg.png;sort_horz;=;true;true]"..
            "image_button[9.2,0.3;0.5,0.5;b_bg.png;sort_vert;||;true;true]"..
            "image_button[9.2,0.8;0.5,0.5;b_bg.png;sort_norm;Z;true;true]"..
            "list[nodemeta:"..pos.x..","..pos.y..","..pos.z..";main;0,0;9,3;]"..
--            "list[context;main;0,0;9,3;]"..
            "list[current_player;main;0,3.2;9,3;9]"..
            "list[current_player;main;0,6.4;9,1;]")
            meta:set_string("infotext", "Chest")
       -- end
        local inv = meta:get_inventory()
        inv:set_size("main", 9*3)
    end,
    after_place_node = function(pos, placer, itemstack, pointed_thing)
            local m = minetest.get_meta(pos)
            local ent = minetest.env:add_entity(pos,'default:3dchest')
            if ent then
                local ent2 = ent:get_luaentity()
                ent:set_animation({x=1,y=1}, 20, 0)
                local dir = placer:get_look_dir()
                local absx, absy, absz = math.abs(dir.x), math.abs(dir.y), math.abs(dir.z)
                local maxd = math.max(math.max(absx,absy),absz)
                if maxd == absx then
                   if dir.x>0 then
                      ent:setyaw(math.pi/2)
                      m:set_int('dir',1)
                   else
                      ent:setyaw(3*math.pi/2)
                      m:set_int('dir',3)
                   end
                elseif maxd == absy then
                   if dir.x>dir.z then
                      ent:setyaw(math.pi)
                      m:set_int('dir',2)
                   else
                      ent:setyaw(3*math.pi/2)
                      m:set_int('dir',3)
                   end
                elseif maxd == absz then
                   if dir.z>0 then
                      ent:setyaw(math.pi)
                      m:set_int('dir',2)
                   else
                      ent:setyaw(0)
                      m:set_int('dir',0)
                   end
                end
                m:set_int('3d',1)
            end
        local timer = minetest.get_node_timer(pos)
        timer:start(1)
    end,
    on_timer = function(pos,el)
       if global_timer<15 then return end
       local meta = minetest.get_meta(pos)
       local cover = false
       local node = minetest.get_node(pos)
       local objs = minetest.get_objects_inside_radius(pos, 0.1)
             for i,obj in ipairs(objs) do
                 if not obj:is_player() then
                    local self = obj:get_luaentity()
                    if self.name == 'default:3dchest' and node.name == 'default:chest' then
                       cover = true
                       break
                    else
                       self.object:remove()
                    end
                 end
             end
      if not cover then
         if node.name == 'default:chest' then
            local ent = minetest.env:add_entity(pos,'default:3dchest')
            if ent then
                ent:set_animation({x=1,y=1}, 20, 0)
                local dir = meta:get_int('dir')
                ent:setyaw(dir*(math.pi/2))
            end
         end
      end
       return true
    end,
    after_dig_node = function(pos, oldnode, oldmetadata, digger)
        local meta = minetest.get_meta(pos)
        local meta2 = meta
        meta:from_table(oldmetadata)
        local inv = meta:get_inventory()
        for i=1,inv:get_size("main") do
            local stack = inv:get_stack("main", i)
            if not stack:is_empty() then
                local p = {x=pos.x+math.random(0, 10)/10-0.5, y=pos.y, z=pos.z+math.random(0, 10)/10-0.5}
                minetest.add_item(p, stack)
            end
        end
        meta:from_table(meta2:to_table())
    end,
    on_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
        minetest.log("action", player:get_player_name()..
                " moves stuff in chest at "..minetest.pos_to_string(pos))
    end,
    on_metadata_inventory_put = function(pos, listname, index, stack, player)
        minetest.log("action", player:get_player_name()..
                " moves stuff to chest at "..minetest.pos_to_string(pos))
    end,
    on_metadata_inventory_take = function(pos, listname, index, stack, player)
        minetest.log("action", player:get_player_name()..
                " takes stuff from chest at "..minetest.pos_to_string(pos))
    end,
        on_receive_fields = function(pos, formname, fields, sender)
           if sender and sender:is_player() then
              default.sort_inv(sender,formname,fields)
           end
        end,
})
--[[
minetest.register_node("default:chest_left", {
    tiles = {"default_chest_top_big.png", "default_chest_top_big.png", "default_chest_side.png",
        "default_chest_side.png", "default_chest_side_big.png^[transformFX", "default_chest_front_big.png"},
    paramtype2 = "facedir",
    groups = {choppy=default.dig.chest,not_in_creative_inventory=1},
    drop = "default:chest",
    sounds = default.node_sound_wood_defaults(),
    on_destruct = function(pos)
        local m = minetest.get_meta(pos)
        if m:get_string("infotext") == "Chest" then
            return
        end
        local param2 = minetest.get_node(pos).param2
        local p = get_chest_neighborpos(pos, param2, "left")
        if not p or minetest.get_node(p).name ~= "default:chest_right" then
            return
        end
        local meta = minetest.get_meta(p)
        meta:set_string("formspec",
            "size[9,7.2]"..
            "bgcolor[#bbbbbb;false]"..
            "listcolors[#777777;#cccccc;#333333;#555555;#dddddd]"..

            "image_button[9.0,-0.3;0.80,1.7;b_bg2.png;just_bg;Z;true;false]"..
            "image_button[9.2,-0.2;0.5,0.5;b_bg.png;sort_horz;=;true;true]"..
            "image_button[9.2,0.3;0.5,0.5;b_bg.png;sort_vert;||;true;true]"..
            "image_button[9.2,0.8;0.5,0.5;b_bg.png;sort_norm;Z;true;true]"..

            "list[context;main;0,0;9,3;]"..
            "list[current_player;main;0,3.2;9,3;9]"..
            "list[current_player;main;0,6.4;9,1;]")
        meta:set_string("infotext", "Chest")
        minetest.swap_node(p, {name="default:chest"})
    end,
    after_dig_node = function(pos, oldnode, oldmetadata, digger)
        local meta = minetest.get_meta(pos)
        local meta2 = meta
        meta:from_table(oldmetadata)
        local inv = meta:get_inventory()
        for i=1,inv:get_size("main") do
            local stack = inv:get_stack("main", i)
            if not stack:is_empty() then
                local p = {x=pos.x+math.random(0, 10)/10-0.5, y=pos.y, z=pos.z+math.random(0, 10)/10-0.5}
                minetest.add_item(p, stack)
            end
        end
        meta:from_table(meta2:to_table())
        local placer=digger
                   local m = minetest.get_meta(pos)
            local ent = minetest.env:add_entity(pos,'default:3dchest')
            if ent then
                local ent2 = ent:get_luaentity()
                ent:set_animation({x=1,y=1}, 20, 0)
                local dir = placer:get_look_dir()
                local absx, absy, absz = math.abs(dir.x), math.abs(dir.y), math.abs(dir.z)
                local maxd = math.max(math.max(absx,absy),absz)
                if maxd == absx then
                   if dir.x>0 then
                      ent:setyaw(math.pi/2)
                      m:set_int('dir',1)
                   else
                      ent:setyaw(3*math.pi/2)
                      m:set_int('dir',3)
                   end
                elseif maxd == absy then
                   if dir.x>dir.z then
                      ent:setyaw(math.pi)
                      m:set_int('dir',2)
                   else
                      ent:setyaw(3*math.pi/2)
                      m:set_int('dir',3)
                   end
                elseif maxd == absz then
                   if dir.z>0 then
                      ent:setyaw(math.pi)
                      m:set_int('dir',2)
                   else
                      ent:setyaw(0)
                      m:set_int('dir',0)
                   end
                end
                m:set_int('3d',1)
            end
        local timer = minetest.get_node_timer(pos)
        timer:start(1)
    end,
    on_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
        minetest.log("action", player:get_player_name()..
                " moves stuff in chest at "..minetest.pos_to_string(pos))
    end,
    on_metadata_inventory_put = function(pos, listname, index, stack, player)
        minetest.log("action", player:get_player_name()..
                " moves stuff to chest at "..minetest.pos_to_string(pos))
    end,
    on_metadata_inventory_take = function(pos, listname, index, stack, player)
        minetest.log("action", player:get_player_name()..
                " takes stuff from chest at "..minetest.pos_to_string(pos))
    end,
        on_receive_fields = function(pos, formname, fields, sender)
           if sender and sender:is_player() then
              default.sort_inv(sender,formname,fields)
           end
        end,

})]]
--[[
minetest.register_node("default:chest_right", {
    tiles = {"default_chest_top_big.png^[transformFX", "default_chest_top_big.png^[transformFX", "default_chest_side.png",
        "default_chest_side.png", "default_chest_side_big.png", "default_chest_front_big.png^[transformFX"},
    paramtype2 = "facedir",
    groups = {choppy=default.dig.chest,not_in_creative_inventory=1},
    drop = "default:chest",
    sounds = default.node_sound_wood_defaults(),
    on_destruct = function(pos)
        local m = minetest.get_meta(pos)
        if m:get_string("infotext") == "Chest" then
            return
        end
        local param2 = minetest.get_node(pos).param2
        local p = get_chest_neighborpos(pos, param2, "right")
        if not p or minetest.get_node(p).name ~= "default:chest_left" then
            return
        end
        local meta = minetest.get_meta(p)
        meta:set_string("formspec",
            "size[9,7.2]"..
            "bgcolor[#bbbbbb;false]"..
            "listcolors[#777777;#cccccc;#333333;#555555;#dddddd]"..

            "image_button[9.0,-0.3;0.80,1.7;b_bg2.png;just_bg;Z;true;false]"..
            "image_button[9.2,-0.2;0.5,0.5;b_bg.png;sort_horz;=;true;true]"..
            "image_button[9.2,0.3;0.5,0.5;b_bg.png;sort_vert;||;true;true]"..
            "image_button[9.2,0.8;0.5,0.5;b_bg.png;sort_norm;Z;true;true]"..

            "list[context;main;0,0;9,3;]"..
            "list[current_player;main;0,3.2;9,3;9]"..
            "list[current_player;main;0,6.4;9,1;]")
        meta:set_string("infotext", "Chest")
        minetest.swap_node(p, {name="default:chest"})
    end,
    after_dig_node = function(pos, oldnode, oldmetadata, digger)
        local meta = minetest.get_meta(pos)
        local meta2 = meta
        meta:from_table(oldmetadata)
        local inv = meta:get_inventory()
        for i=1,inv:get_size("main") do
            local stack = inv:get_stack("main", i)
            if not stack:is_empty() then
                local p = {x=pos.x+math.random(0, 10)/10-0.5, y=pos.y, z=pos.z+math.random(0, 10)/10-0.5}
                minetest.add_item(p, stack)
            end
        end
        meta:from_table(meta2:to_table())
        local placer=digger
                   local m = minetest.get_meta(pos)
            local ent = minetest.env:add_entity(pos,'default:3dchest')
            if ent then
                local ent2 = ent:get_luaentity()
                ent:set_animation({x=1,y=1}, 20, 0)
                local dir = placer:get_look_dir()
                local absx, absy, absz = math.abs(dir.x), math.abs(dir.y), math.abs(dir.z)
                local maxd = math.max(math.max(absx,absy),absz)
                if maxd == absx then
                   if dir.x>0 then
                      ent:setyaw(math.pi/2)
                      m:set_int('dir',1)
                   else
                      ent:setyaw(3*math.pi/2)
                      m:set_int('dir',3)
                   end
                elseif maxd == absy then
                   if dir.x>dir.z then
                      ent:setyaw(math.pi)
                      m:set_int('dir',2)
                   else
                      ent:setyaw(3*math.pi/2)
                      m:set_int('dir',3)
                   end
                elseif maxd == absz then
                   if dir.z>0 then
                      ent:setyaw(math.pi)
                      m:set_int('dir',2)
                   else
                      ent:setyaw(0)
                      m:set_int('dir',0)
                   end
                end
                m:set_int('3d',1)
            end
        local timer = minetest.get_node_timer(pos)
        timer:start(1)
    end,
    on_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
        minetest.log("action", player:get_player_name()..
                " moves stuff in chest at "..minetest.pos_to_string(pos))
    end,
    on_metadata_inventory_put = function(pos, listname, index, stack, player)
        minetest.log("action", player:get_player_name()..
                " moves stuff to chest at "..minetest.pos_to_string(pos))
    end,
    on_metadata_inventory_take = function(pos, listname, index, stack, player)
        minetest.log("action", player:get_player_name()..
                " takes stuff from chest at "..minetest.pos_to_string(pos))
    end,
        on_receive_fields = function(pos, formname, fields, sender)
           if sender and sender:is_player() then
              default.sort_inv(sender,formname,fields)
           end
        end,


})]]--

local function has_locked_chest_privilege(meta, player)
    if player:get_player_name() ~= meta:get_string("owner") then
        return false
    end
    return true
end

function default.get_locked_chest_formspec(pos)
    local spos = pos.x .. "," .. pos.y .. "," ..pos.z
    local formspec =
            "size[9,7.2]"..
            "bgcolor[#bbbbbb;false]"..
            "listcolors[#777777;#cccccc;#333333;#555555;#dddddd]"..

            "image_button[9.0,-0.3;0.80,1.7;b_bg2.png;just_bg;Z;true;false]"..
            "image_button[9.2,-0.2;0.5,0.5;b_bg.png;sort_horz;=;true;true]"..
            "image_button[9.2,0.3;0.5,0.5;b_bg.png;sort_vert;||;true;true]"..
            "image_button[9.2,0.8;0.5,0.5;b_bg.png;sort_norm;Z;true;true]"..

            "list[nodemeta:".. spos .. ";main;0,0;9,3;]"..
            "list[current_player;main;0,3.2;9,3;9]"..
            "list[current_player;main;0,6.4;9,1;]"
    return formspec
end

minetest.register_node("default:chest_locked", {
    description = "Locked Chest",
    tiles = {"default_chest_top.png", "default_chest_top.png", "default_chest_side.png",
        "default_chest_side.png", "default_chest_side.png", "default_chest_lock.png"},
    paramtype2 = "facedir",
    groups = {choppy=2,oddly_breakable_by_hand=2},
    legacy_facedir_simple = true,
    sounds = default.node_sound_wood_defaults(),
    after_place_node = function(pos, placer)
        local meta = minetest.get_meta(pos)
        meta:set_string("owner", placer:get_player_name() or "")
        meta:set_string("infotext", "Locked chest (owned by "..
                meta:get_string("owner")..")")
            meta:set_string("formspec",
            "size[9,7.2]"..
            "bgcolor[#bbbbbb;false]"..
            "listcolors[#777777;#cccccc;#333333;#555555;#dddddd]"..

            "image_button[9.0,-0.3;0.80,1.7;b_bg2.png;just_bg;Z;true;false]"..
            "image_button[9.2,-0.2;0.5,0.5;b_bg.png;sort_horz;=;true;true]"..
            "image_button[9.2,0.3;0.5,0.5;b_bg.png;sort_vert;||;true;true]"..
            "image_button[9.2,0.8;0.5,0.5;b_bg.png;sort_norm;Z;true;true]"..

            "list[context;main;0,0;9,3;]"..
            "list[current_player;main;0,3.2;9,3;9]"..
            "list[current_player;main;0,6.4;9,1;]")
    end,
    on_construct = function(pos)
        local meta = minetest.get_meta(pos)
        meta:set_string("infotext", "Locked chest")
        meta:set_string("owner", "")
        local inv = meta:get_inventory()
        inv:set_size("main", 9*3)
    end,
    can_dig = function(pos,player)
        local meta = minetest.get_meta(pos);
        local inv = meta:get_inventory()
        return inv:is_empty("main") and has_locked_chest_privilege(meta, player)
    end,
    allow_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
        local meta = minetest.get_meta(pos)
        if not has_locked_chest_privilege(meta, player) then
            return 0
        end
        return count
    end,
    allow_metadata_inventory_put = function(pos, listname, index, stack, player)
        local meta = minetest.get_meta(pos)
        if not has_locked_chest_privilege(meta, player) then
            return 0
        end
        return stack:get_count()
    end,
    allow_metadata_inventory_take = function(pos, listname, index, stack, player)
        local meta = minetest.get_meta(pos)
        if not has_locked_chest_privilege(meta, player) then
            return 0
        end
        return stack:get_count()
    end,
    on_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
        minetest.log("action", player:get_player_name()..
                " rearranged stuff in a chest at "..minetest.pos_to_string(pos))
    end,
    on_metadata_inventory_put = function(pos, listname, index, stack, player)
        local inam = stack:get_name()
        minetest.log("action", player:get_player_name().. " put " .. inam .. " in a chest at "..minetest.pos_to_string(pos))
    end,
    on_metadata_inventory_take = function(pos, listname, index, stack, player)
        local inam = stack:get_name()
        minetest.log("action", player:get_player_name().. " took " .. inam .. " from a chest at "..minetest.pos_to_string(pos))
    end,
    on_rightclick = function(pos, node, clicker)
        local meta = minetest.get_meta(pos)
        if has_locked_chest_privilege(meta, clicker) then
            minetest.show_formspec(
                clicker:get_player_name(),
                "default:chest_locked",
                default.get_locked_chest_formspec(pos)
            )
        end
    end,
        on_receive_fields = function(pos, formname, fields, sender)
           if sender and sender:is_player() then
              default.sort_inv(sender,formname,fields)
           end
        end,


})


default.furnace_inactive_formspec =
            "size[9,8.2]"..
            "bgcolor[#bbbbbb;false]"..
            "listcolors[#777777;#cccccc;#333333;#555555;#dddddd]"..

            "list[current_player;helm;0,0;1,1;]"..
            "list[current_player;torso;0,1;1,1;]"..
            "list[current_player;pants;0,2;1,1;]"..
            "list[current_player;boots;0,3;1,1;]"..

            "image_button[9.0,-0.3;0.80,1.7;b_bg2.png;just_bg;Z;true;false]"..
            "image_button[9.2,-0.2;0.5,0.5;b_bg.png;sort_horz;=;true;true]"..
            "image_button[9.2,0.3;0.5,0.5;b_bg.png;sort_vert;||;true;true]"..
            "image_button[9.2,0.8;0.5,0.5;b_bg.png;sort_norm;Z;true;true]"..

            "image[2,1.5;1,1;default_furnace_fire_bg.png]"..
            "image[3,1.5;2,1;default_arrow_bg.png^[transformR270]"..

            "list[current_player;main;0,4.2;9,3;9]"..
            "list[current_player;main;0,7.4;9,1;]"

minetest.register_node("default:furnace", {
    description = "Furnace",
    tiles = {"default_furnace_top.png", "default_furnace_bottom.png", "default_furnace_side.png",
        "default_furnace_side.png", "default_furnace_side.png", "default_furnace_front.png"},
    paramtype2 = "facedir",
    groups = {cracky=default.dig.furnace},
    legacy_facedir_simple = true,
    sounds = default.node_sound_stone_defaults(),
    on_construct = function(pos)
        local meta = minetest.get_meta(pos)
        meta:set_string("formspect", default.furnace_inactive_formspec)
        meta:set_string("infotext", "Furnace")
                meta:set_string("percent", "0")
        local inv = meta:get_inventory()
        inv:set_size("fuel", 1)
        inv:set_size("src", 1)
        inv:set_size("dst", 4)
        inv:set_size("gfuel", 1)
        inv:set_size("gsrc", 1)
        inv:set_size("gdst", 4)
    end,
    on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
       if clicker and clicker:is_player() then
          local pll = clicker:get_player_name()
          local meta = minetest.get_meta(pos)
          local formspec = meta:get_string("formspect")
          if not isghost[pll] then
             formspec = formspec ..
             "list[nodemeta:"..pos.x..","..pos.y..","..pos.z..";fuel;2,2.5;1,1;]"..
             "list[nodemeta:"..pos.x..","..pos.y..","..pos.z..";src;2,0.5;1,1;]"..
             "list[nodemeta:"..pos.x..","..pos.y..","..pos.z..";dst;5,1;2,2;]"
          else
            -- ghostly slots >:D
             formspec = formspec ..
             "list[nodemeta:"..pos.x..","..pos.y..","..pos.z..";gfuel;2,2.5;1,1;]"..
             "list[nodemeta:"..pos.x..","..pos.y..","..pos.z..";gsrc;2,0.5;1,1;]"..
             "list[nodemeta:"..pos.x..","..pos.y..","..pos.z..";gdst;5,1;2,2;]"
          end
          -- add current user to a list of users
          local old_meta=meta:get_string("pll")
          local plls  = string.split(old_meta,';')
          local exists = false
          for _,name in ipairs(plls) do
              if name==pll then
                 exists = true
                 break
              end
          end
          if not exists then
             if #old_meta>0 then
                meta:set_string("pll",old_meta..';'..pll)
             else
                meta:set_string("pll",pll)
             end
          end
          -- since inactive furnace is NOT updated, we need to show formspec manually
          minetest.show_formspec(pll, 'default:furnace_'..minetest.serialize(pos), formspec)
       end
    end,
    after_dig_node = function(pos, oldnode, oldmetadata, digger)
        local meta = minetest.get_meta(pos)
        local meta2 = meta
        meta:from_table(oldmetadata)
        local inv = meta:get_inventory()
        for _,list in ipairs({"fuel", "src", "dst","gfuel", "gsrc", "gdst"}) do
            for i=1,inv:get_size(list) do
                local stack = inv:get_stack(list, i)
                if not stack:is_empty() then
                    local p = {x=pos.x+math.random(0, 10)/10-0.5, y=pos.y, z=pos.z+math.random(0, 10)/10-0.5}
                    minetest.add_item(p, stack)
                end
            end
        end
        meta:from_table(meta2:to_table())
    end,
    allow_metadata_inventory_put = function(pos, listname, index, stack, player)
        local meta = minetest.get_meta(pos)
        local inv = meta:get_inventory()
        if listname == "fuel" then
            if stack:get_name()=='ghosts:ghostly_block' and not isghost[pll] then return 0 end
            if minetest.get_craft_result({method="fuel",width=1,items={stack}}).time ~= 0 then
                if inv:is_empty("src") then
                    meta:set_string("infotext","Furnace is empty")
                end
                return stack:get_count()
            else
                return 0
            end
        elseif listname == "gfuel" then
            if minetest.get_craft_result({method="fuel",width=1,items={stack}}).time ~= 0 then
                if inv:is_empty("gsrc") then
                    meta:set_string("infotext","Furnace is empty")
                end
                return stack:get_count()
            else
                return 0
            end
        elseif listname == "src" or listname == "gsrc" then
            return stack:get_count()
        elseif listname == "dst" or listname == "gdst" then
            return 0
        end
    end,
    allow_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
        local meta = minetest.get_meta(pos)
        local inv = meta:get_inventory()
        local stack = inv:get_stack(from_list, from_index)
        if to_list == "fuel" then
            -- prohibit gb usage as a fuel if you're alive
            if minetest.get_craft_result({method="fuel",width=1,items={stack}}).time ~= 0 then
                if inv:is_empty("src") then
                    meta:set_string("infotext","Furnace is empty")
                end
                return count
            else
                return 0
            end
        elseif to_list == "gfuel" then
            if minetest.get_craft_result({method="fuel",width=1,items={stack}}).time ~= 0 then
                if inv:is_empty("gsrc") then
                    meta:set_string("infotext","Furnace is empty")
                end
                return count
            else
                return 0
            end
        elseif to_list == "src" or to_list == "gsrc" then
            return count
        elseif to_list == "dst" or to_list == "gdst" then
            return 0
        end
    end,
        on_receive_fields = function(pos, formname, fields, sender)
           if sender and sender:is_player() then
              default.sort_inv(sender,formname,fields,pos)
           end
        end,


})

minetest.register_node("default:furnace_active", {
    description = "Furnace",
    tiles = {"default_furnace_top.png", "default_furnace_bottom.png", "default_furnace_side.png",
        "default_furnace_side.png", "default_furnace_side.png",                 {
                        image="default_furnace_front_active.png",
            backface_culling=true,
            animation={type="vertical_frames", aspect_w=32, aspect_h=32, length=0.8}
        },},
    paramtype2 = "facedir",
    light_source = 13,
    drop = "default:furnace",
    groups = {cracky=default.dig.furnace, not_in_creative_inventory=1},
    legacy_facedir_simple = true,
    sounds = default.node_sound_stone_defaults(),
    after_dig_node = function(pos, oldnode, oldmetadata, digger)
        local meta = minetest.get_meta(pos)
        local meta2 = meta
        meta:from_table(oldmetadata)
        local inv = meta:get_inventory()
         -- make it possible to cheat on ghosts :)
        for _,list in ipairs({"fuel", "src", "dst","gfuel", "gsrc", "gdst"}) do
            for i=1,inv:get_size(list) do
                local stack = inv:get_stack(list, i)
                if not stack:is_empty() then
                    local p = {x=pos.x+math.random(0, 10)/10-0.5, y=pos.y, z=pos.z+math.random(0, 10)/10-0.5}
                    minetest.add_item(p, stack)
                end
            end
        end
        meta:from_table(meta2:to_table())
    end,
    on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
       if clicker and clicker:is_player() then
          local pll = clicker:get_player_name()
          local meta = minetest.get_meta(pos)
          local formspec = meta:get_string("formspect")
          if not isghost[pll] then
             formspec = formspec ..
             "list[nodemeta:"..pos.x..","..pos.y..","..pos.z..";fuel;2,2.5;1,1;]"..
             "list[nodemeta:"..pos.x..","..pos.y..","..pos.z..";src;2,0.5;1,1;]"..
             "list[nodemeta:"..pos.x..","..pos.y..","..pos.z..";dst;5,1;2,2;]"
          else
            -- ghostly slots >:D
             formspec = formspec ..
             "list[nodemeta:"..pos.x..","..pos.y..","..pos.z..";gfuel;2,2.5;1,1;]"..
             "list[nodemeta:"..pos.x..","..pos.y..","..pos.z..";gsrc;2,0.5;1,1;]"..
             "list[nodemeta:"..pos.x..","..pos.y..","..pos.z..";gdst;5,1;2,2;]"
          --   print('showing GHOSTS formspec')
          end
          -- iterate through players and add current one if needed
          -- add current user to a list of users
          local old_meta=meta:get_string("pll")
          local plls  = string.split(old_meta,';')
          local exists = false
          for _,name in ipairs(plls) do
              if name==pll then
                 exists = true
                 break
              end
          end
          if not exists then
             if #old_meta>0 then
                meta:set_string("pll",old_meta..';'..pll)
             else
                meta:set_string("pll",pll)
             end
          end
          -- well done! on_timer will show a formspec now
          minetest.get_node_timer(pos):start(1)
       end
    end,
    on_timer = function(pos,el)
          local meta = minetest.get_meta(pos)
          local pll = meta:get_string("pll")
          if not minetest.get_player_by_name(pll) then return true end
          local formspec = meta:get_string("formspect")
          if not isghost[pll] then
             formspec = formspec ..
             "list[nodemeta:"..pos.x..","..pos.y..","..pos.z..";fuel;2,2.5;1,1;]"..
             "list[nodemeta:"..pos.x..","..pos.y..","..pos.z..";src;2,0.5;1,1;]"..
             "list[nodemeta:"..pos.x..","..pos.y..","..pos.z..";dst;5,1;2,2;]"
          else
            -- ghostly slots >:D
             formspec = formspec ..
             "list[nodemeta:"..pos.x..","..pos.y..","..pos.z..";gfuel;2,2.5;1,1;]"..
             "list[nodemeta:"..pos.x..","..pos.y..","..pos.z..";gsrc;2,0.5;1,1;]"..
             "list[nodemeta:"..pos.x..","..pos.y..","..pos.z..";gdst;5,1;2,2;]"
          end
          local plls  = string.split(meta:get_string("pll"),';')
          for _,name in ipairs(plls) do
              minetest.show_formspec(name, 'default:furnace_'..minetest.serialize(pos), formspec)
          end
         return true
    end,
    allow_metadata_inventory_put = function(pos, listname, index, stack, player)
        local meta = minetest.get_meta(pos)
        local inv = meta:get_inventory()
        if listname == "fuel" then
            -- prohibit gb usage as a fuel if you're alive
            if stack:get_name()=='ghosts:ghostly_block' and not isghost[pll] then return 0 end
            if minetest.get_craft_result({method="fuel",width=1,items={stack}}).time ~= 0 then
                if inv:is_empty("src") then
                    meta:set_string("infotext","Furnace is empty")
                end
                return stack:get_count()
            else
                return 0
            end
        elseif listname == "gfuel" then
            if minetest.get_craft_result({method="fuel",width=1,items={stack}}).time ~= 0 then
                if inv:is_empty("gsrc") then
                    meta:set_string("infotext","Furnace is empty")
                end
                return stack:get_count()
            else
                return 0
            end
        elseif listname == "src" or listname == "gsrc" then
            return stack:get_count()
        elseif listname == "dst" or listname == "gdst" then
            return 0
        end
    end,
    allow_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
        local meta = minetest.get_meta(pos)
        local inv = meta:get_inventory()
        local stack = inv:get_stack(from_list, from_index)
        if to_list == "fuel" then
            if minetest.get_craft_result({method="fuel",width=1,items={stack}}).time ~= 0 then
                if inv:is_empty("src") then
                    meta:set_string("infotext","Furnace is empty")
                end
                return count
            else
                return 0
            end
        elseif to_list == "gfuel" then
            if minetest.get_craft_result({method="fuel",width=1,items={stack}}).time ~= 0 then
                if inv:is_empty("gsrc") then
                    meta:set_string("infotext","Furnace is empty")
                end
                return count
            else
                return 0
            end
        elseif to_list == "src" or to_list == "gsrc" then
            return count
        elseif to_list == "dst" or to_list == "gdst" then
            return 0
        end
    end,
        on_receive_fields = function(pos, formname, fields, sender)

           if sender and sender:is_player() then
              default.sort_inv(sender,formname,fields,pos)
           end
        end,


})

minetest.register_abm({
    nodenames = {"default:furnace","default:furnace_active"},
    interval = 1,
    chance = 1,
    action = function(pos, node, active_object_count, active_object_count_wider)
     -- normal
        local meta = minetest.get_meta(pos)
        for i, name in ipairs({
                "fuel_totaltime",
                "fuel_time",
                "src_totaltime",
                "src_time"
        }) do
            if meta:get_string(name) == "" then
                meta:set_float(name, 0.0)
            end
        end
     -- ghosts
        for i, name in ipairs({
                "gfuel_totaltime",
                "gfuel_time",
                "gsrc_totaltime",
                "gsrc_time"
        }) do
            if meta:get_string(name) == "" then
                meta:set_float(name, 0.0)
            end
        end

      -- normal
        local inv = meta:get_inventory()

        local srclist = inv:get_list("src")
        local cooked = nil
        local aftercooked

        if srclist then
            cooked, aftercooked = minetest.get_craft_result({method = "cooking", width = 1, items = srclist})
        end

        local was_active = false

        if meta:get_float("fuel_time") < meta:get_float("fuel_totaltime") then
            was_active = true
            meta:set_float("fuel_time", meta:get_float("fuel_time") + 1)
            meta:set_float("src_time", meta:get_float("src_time") + 1)
            meta:set_float("src_totaltime", cooked.time)

            if cooked and cooked.item and meta:get_float("src_time") >= cooked.time then
                -- check if there's room for output in "dst" list
                if inv:room_for_item("dst",cooked.item) then
                    -- Put result in "dst" list
                    inv:add_item("dst", cooked.item)
                    -- take stuff from "src" list
                    inv:set_stack("src", 1, aftercooked.items[1])
                else
                    print("There's no place in furnace output for '"..cooked.item:to_string().."'")
                end
                meta:set_string("src_time", 0)
            end
        end

      -- ghosts
        local gsrclist = inv:get_list("gsrc")
        local gcooked = nil
        local gaftercooked

        if gsrclist then
            gcooked, gaftercooked = minetest.get_craft_result({method = "cooking", width = 1, items = gsrclist})
        end

        local gwas_active = false

        if meta:get_float("gfuel_time") < meta:get_float("gfuel_totaltime") then
            gwas_active = true
            meta:set_float("gfuel_time", meta:get_float("gfuel_time") + 1)
            meta:set_float("gsrc_time", meta:get_float("gsrc_time") + 1)
            meta:set_float("gsrc_totaltime", gcooked.time)

            if gcooked and gcooked.item and meta:get_float("gsrc_time") >= gcooked.time then
                if inv:room_for_item("gdst", gcooked.item) then
                    inv:add_item("gdst", gcooked.item)
                    -- add 1 ecto to a dst slots if a ghost is cooking smth
                    inv:add_item("gdst", "ghosts:ectoplasm")
                    inv:set_stack("gsrc", 1, gaftercooked.items[1])
                else
                    print("There's no place in furnace output for '"..cooked.item:to_string().."' (ghostly)")
                end
                meta:set_string("gsrc_time", 0)
            end
        end

     -- normal
        if meta:get_float("fuel_time") < meta:get_float("fuel_totaltime") then
            local percent = math.floor(meta:get_float("fuel_time") / meta:get_float("fuel_totaltime") * 100)
            local percent2 = math.floor(meta:get_float("src_time") / meta:get_float("src_totaltime") * 100)
            meta:set_string("infotext","Furnace active: "..percent2.."%")
            meta:set_string("percent", percent)
            local node = minetest.get_node(pos)
            node.name = "default:furnace_active"
            minetest.swap_node(pos,node,2)
            meta:set_string("formspect",
            "size[9,8.2]"..
            "bgcolor[#bbbbbb;false]"..
            "listcolors[#777777;#cccccc;#333333;#555555;#dddddd]"..

            "list[current_player;helm;0,0;1,1;]"..
            "list[current_player;torso;0,1;1,1;]"..
            "list[current_player;pants;0,2;1,1;]"..
            "list[current_player;boots;0,3;1,1;]"..

            "image_button[9.0,-0.3;0.80,1.7;b_bg2.png;just_bg;Z;true;false]"..
            "image_button[9.2,-0.2;0.5,0.5;b_bg.png;sort_horz;=;true;true]"..
            "image_button[9.2,0.3;0.5,0.5;b_bg.png;sort_vert;||;true;true]"..
            "image_button[9.2,0.8;0.5,0.5;b_bg.png;sort_norm;Z;true;true]"..

            "image[2,1.5;1,1;default_furnace_fire_bg.png^[lowpart:"..(100-percent)..":default_furnace_fire_fg.png]"..
            "image[3.2,1.5;1.8,1;default_arrow_bg.png^[lowpart:"..(percent2)..":default_arrow_fg.png^[transformR270]"..

            "list[current_player;main;0,4.2;9,3;9]"..
            "list[current_player;main;0,7.4;9,1;]")
            minetest.get_node_timer(pos):start(1,0.99)
        end
        if meta:get_float("gfuel_time") < meta:get_float("gfuel_totaltime") then
            local gpercent = math.floor(meta:get_float("gfuel_time") / meta:get_float("gfuel_totaltime") * 100)
            local gpercent2 = math.floor(meta:get_float("gsrc_time") / meta:get_float("gsrc_totaltime") * 100)
            meta:set_string("infotext","Furnace active: "..gpercent2.."%")
            meta:set_string("percent", gpercent)
            local gnode = minetest.get_node(pos)
            gnode.name = "default:furnace_active"
            minetest.swap_node(pos,gnode,2)
            meta:set_string("formspect",
            "size[9,8.2]"..
            "bgcolor[#bbbbbb;false]"..
            "listcolors[#777777;#cccccc;#333333;#555555;#dddddd]"..

            "list[current_player;helm;0,0;1,1;]"..
            "list[current_player;torso;0,1;1,1;]"..
            "list[current_player;pants;0,2;1,1;]"..
            "list[current_player;boots;0,3;1,1;]"..

            "image_button[9.0,-0.3;0.80,1.7;b_bg2.png;just_bg;Z;true;false]"..
            "image_button[9.2,-0.2;0.5,0.5;b_bg.png;sort_horz;=;true;true]"..
            "image_button[9.2,0.3;0.5,0.5;b_bg.png;sort_vert;||;true;true]"..
            "image_button[9.2,0.8;0.5,0.5;b_bg.png;sort_norm;Z;true;true]"..

            "image[2,1.5;1,1;default_furnace_fire_bg.png^[lowpart:"..(100-gpercent)..":default_furnace_fire_fg.png]"..
            "image[3.2,1.5;1.8,1;default_arrow_bg.png^[lowpart:"..(gpercent2)..":default_arrow_fg.png^[transformR270]"..

            "list[current_player;main;0,4.2;9,3;9]"..
            "list[current_player;main;0,7.4;9,1;]")
            minetest.get_node_timer(pos):start(1,0.99)
        end
        if meta:get_float("fuel_time") < meta:get_float("fuel_totaltime")
        or meta:get_float("gfuel_time") < meta:get_float("gfuel_totaltime")
        then return end


     -- normal
        local fuel = nil
        local afterfuel
        local cooked = nil
        local fuellist = inv:get_list("fuel")
        local srclist = inv:get_list("src")

        if srclist then
            cooked = minetest.get_craft_result({method = "cooking", width = 1, items = srclist})
        end
        if fuellist then
            fuel, afterfuel = minetest.get_craft_result({method = "fuel", width = 1, items = fuellist})
        end

     -- ghosts
        local gfuel = nil
        local gafterfuel
        local gcooked = nil
        local gfuellist = inv:get_list("gfuel")
        local gsrclist = inv:get_list("gsrc")

        if gsrclist then
            gcooked = minetest.get_craft_result({method = "cooking", width = 1, items = gsrclist})
        end
        if gfuellist then
            gfuel, gafterfuel = minetest.get_craft_result({method = "fuel", width = 1, items = gfuellist})
        end
        -- try to fix furnace
        if (not fuel) or (not gfuel)
        or (not cooked) or (not gcooked)
        then return end

        if fuel.time <= 0 then
            meta:set_string("infotext","Furnace out of fuel")
            meta:set_string("formspect", default.furnace_inactive_formspec)
            local node = minetest.get_node(pos)
            node.name = "default:furnace"
            minetest.swap_node(pos,node,2)
        end
        if gfuel.time <= 0 then
            meta:set_string("infotext","Furnace out of fuel")
            meta:set_string("formspect", default.furnace_inactive_formspec)
            local gnode = minetest.get_node(pos)
            gnode.name = "default:furnace"
            minetest.swap_node(pos,gnode,2)
        end
       if (fuel.time <= 0 and gfuel.time <= 0 ) then return end

        if cooked.item:is_empty() then
            if was_active then
                meta:set_string("infotext","Furnace is empty")
                meta:set_string("formspect", default.furnace_inactive_formspec)
                local node = minetest.get_node(pos)
                node.name = "default:furnace"
                minetest.swap_node(pos,node,2)
            end
        end
        if gcooked.item:is_empty() then
            if gwas_active then
                meta:set_string("infotext","Furnace is empty")
                meta:set_string("formspect", default.furnace_inactive_formspec)
                local gnode = minetest.get_node(pos)
                gnode.name = "default:furnace"
                minetest.swap_node(pos,gnode,2)
            end
        end
        if cooked.item:is_empty() and gcooked.item:is_empty() then return end

     -- normal
        if not cooked.item:is_empty() and not (fuel.time <= 0) then
            meta:set_string("fuel_totaltime", fuel.time)
            meta:set_string("fuel_time", 0)

            inv:set_stack("fuel", 1, afterfuel.items[1])
        end

     -- ghosts
        if not gcooked.item:is_empty() and not (gfuel.time <= 0) then
            meta:set_string("gfuel_totaltime", gfuel.time)
            meta:set_string("gfuel_time", 0)

            inv:set_stack("gfuel", 1, gafterfuel.items[1])
        end
    end,

})

minetest.register_node("default:cobble", {
    description = "Cobblestone",
    tiles = {"default_cobble.png"},
    groups = {cracky=default.dig.cobble, stone=2},
    sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("default:mossycobble", {
    description = "Mossy Cobblestone",
    tiles = {"default_mossycobble.png"},
    drop = 'default:cobble',
    groups = {cracky=default.dig.cobble},
    sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("default:ironblock", {
    description = "Iron Block",
    tiles = {"default_iron_block.png"},
    is_ground_content = true,

    groups = {cracky=default.dig.ironblock},
    sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("default:goldblock", {
    description = "Gold Block",
    tiles = {"default_gold_block.png"},
    is_ground_content = true,

    groups = {cracky=default.dig.goldblock},
    sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("default:diamondblock", {
    description = "Diamond Block",
    tiles = {"default_diamond_block.png"},
    is_ground_content = true,

    groups = {cracky=default.dig.diamondblock},
    sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("default:obsidian", {
    description = "Obsidian",
    tiles = {"default_obsidian.png"},
    sounds = default.node_sound_stone_defaults(),
    groups = {cracky=default.dig.obsidian},
})

minetest.register_node("default:sapling", {
    description = "Sapling",
    drawtype = "plantlike",
    visual_scale = 1.0,
    tiles = {"default_sapling.png"},
    inventory_image = "default_sapling.png",
    wield_image = "default_sapling.png",
    paramtype = "light",
    walkable = false,
    selection_box = {
        type = "fixed",
        fixed = {-0.3, -0.5, -0.3, 0.3, 0.35, 0.3}
    },

    groups = {dig_immediate=3,flammable=2,attached_node=1},
    sounds = default.node_sound_defaults(),
})

minetest.register_node("default:dry_shrub", {
    description = "Dry Shrub",
    drawtype = "plantlike",
    visual_scale = 1.0,
    tiles = {"default_dry_shrub.png"},
    inventory_image = "default_dry_shrub.png",
    wield_image = "default_dry_shrub.png",
    paramtype = "light",
    walkable = false,

    groups = {dig_immediate=3,flammable=3,attached_node=1},
    sounds = default.node_sound_leaves_defaults(),
    selection_box = {
        type = "fixed",
        fixed = {-0.5, -0.5, -0.5, 0.5, -5/16, 0.5},
    },
})

minetest.register_node(":default:grass_1", {
    description = "Grass",
    drawtype = "plantlike",
    tiles = {"default_grass_1.png"},
    -- use a bigger inventory image
    inventory_image = "default_grass_3.png",
    wield_image = "default_grass_3.png",
    paramtype = "light",
    walkable = false,
    buildable_to = true,
    drop = "",
    groups = {snappy=default.dig.grass,flammable=3,flora=1,attached_node=1},
    sounds = default.node_sound_leaves_defaults({
        dug = {name="default_dig_crumbly", gain=0.4}
    }),
    selection_box = {
        type = "fixed",
        fixed = {-0.5, -0.5, -0.5, 0.5, -5/16, 0.5},
    },

    on_place = function(itemstack, placer, pointed_thing)
        -- place a random grass node
        local stack = ItemStack("default:grass_"..math.random(1,5))
        local ret = minetest.item_place(stack, placer, pointed_thing)
        return ItemStack("default:grass_1 "..itemstack:get_count()-(1-ret:get_count()))
    end,
})

for i=2,5 do
    minetest.register_node(":default:grass_"..i, {
        description = "Grass",
        drawtype = "plantlike",
        tiles = {"default_grass_"..i..".png"},
        inventory_image = "default_grass_"..i..".png",
        wield_image = "default_grass_"..i..".png",
        paramtype = "light",
        walkable = false,
        buildable_to = true,
        is_ground_content = true,
        drop = "",
        groups = {dig_immediate=3,flammable=3,flora=1,attached_node=1,not_in_creative_inventory=1},
        sounds = default.node_sound_leaves_defaults({
            dug = {name="default_dig_crumbly", gain=0.4}
        }),

        selection_box = {
            type = "fixed",
            fixed = {-0.5, -0.5, -0.5, 0.5, -5/16, 0.5},
        },
    })
end

minetest.register_node("default:ice", {
    description = "Ice",
    tiles = {"default_ice.png"},
    is_ground_content = true,
    drawtype = "glasslike",
    node_box = {
        type = "fixed",
        fixed = {
            {-0.4999, -0.4999, -0.4999,  0.4999, 0.4999, 0.4999},
        },
    },

    paramtype = "light",
    drop='',
    use_texture_alpha=true,
    on_dig = function(pos, oldnode, oldmetadata, digger)
       minetest.set_node(pos, {name="default:water_source", param1=0,param2=0}, 2)
    end,
    groups = {cracky=default.dig.ice, slippery=90},
    sounds = default.node_sound_glass_defaults(),
})

minetest.register_node("default:snow", {
    description = "Snow",
    tiles = {"default_snow.png"},
    inventory_image = "default_snowball.png",
    wield_image = "default_snowball.png",
    is_ground_content = true,
    paramtype = "light",
    buildable_to = true,
    drawtype = "nodebox",
    node_box = {
        type = "fixed",
        fixed = {
            {-0.5, -0.5, -0.5,  0.5, -0.5+2/16, 0.5},
        },
    },
    drop = '',
    on_dig = function(pos, node, digger)
                 if not digger then return minetest.node_dig(pos,node,digger) end
                 local tool = digger:get_wielded_item():get_name()
                 if tool:find('shovel') or tool:find('spade') then
                    minetest.item_drop(ItemStack('default:snow'), digger, pos)
                 end
                 minetest.node_dig(pos,node,digger)
              end,
    groups = {crumbly=default.dig.sand,cracky=default.dig.sandstone,snappy=default.dig.wool, oddly_breakable_by_hand=3},
    sounds = default.node_sound_dirt_defaults({
        footstep = {name="default_grass_footstep", gain=0.4},
    }),
    on_construct = function(pos)
        pos.y = pos.y - 1
        if minetest.get_node(pos).name == "default:dirt_with_grass" then
            minetest.set_node(pos, {name="default:dirt_with_snow"})
        end
    end,
})
minetest.register_alias("snow", "default:snow")

minetest.register_node("default:snowblock", {
    description = "Snow Block",
    tiles = {"default_snow.png"},
    is_ground_content = true,
    groups = {crumbly=default.dig.sand,cracky=default.dig.sandstone,snappy=default.dig.wool, oddly_breakable_by_hand=3},
    sounds = default.node_sound_dirt_defaults({
        footstep = {name="default_grass_footstep", gain=0.4},
    }),
})

minetest.register_node("default:bedrock", {
    description = "Bedrock",
    tiles = {"default_bedrock.png"},

    sounds = default.node_sound_stone_defaults(),
})


minetest.register_node("default:workbench", {
    description = "Workbench",
    tiles = {"workbench_top.png", "workbench_side.png"},
    groups = {choppy=default.dig.wood,flammable=3},
    sounds = default.node_sound_wood_defaults(),
    on_construct = function(pos)
       local meta = minetest.get_meta(pos)
       meta:set_string("formspec",

            "size[9,8.2]"..
            "bgcolor[#bbbbbb;false]"..
            "listcolors[#777777;#cccccc;#333333;#555555;#dddddd]"..

            "list[current_player;helm;0,0;1,1;]"..
            "list[current_player;torso;0,1;1,1;]"..
            "list[current_player;pants;0,2;1,1;]"..
            "list[current_player;boots;0,3;1,1;]"..

            "image_button[9.0,-0.3;0.80,1.7;b_bg2.png;just_bg;Z;true;false]"..
            "image_button[9.2,-0.2;0.5,0.5;b_bg.png;sort_horz;=;true;true]"..
            "image_button[9.2,0.3;0.5,0.5;b_bg.png;sort_vert;||;true;true]"..
            "image_button[9.2,0.8;0.5,0.5;b_bg.png;sort_norm;Z;true;true]"..

            "list[current_player;craft;3,0.5;3,3;]"..
            "list[current_player;craftpreview;7,1.5;1,1;]"..

            "list[current_player;main;0,4.2;9,3;9]"..
            "list[current_player;main;0,7.4;9,1;]")
    end,
    on_receive_fields = function(pos, formname, fields, sender)
         default.sort_inv(sender,formname,fields, pos)
    end,

})

minetest.register_craft({
    output = "default:workbench",
    recipe = {
        {"group:wood", "group:wood"},
        {"group:wood", "group:wood"},
    },
})


minetest.register_alias("default:axe_steel","default:iron")
minetest.register_alias("default:axe_steel", "default:axe_iron")
minetest.register_alias("default:shovel_steel", "default:shovel_iron")
minetest.register_alias("default:pick_steel", "default:pick_iron")
minetest.register_alias("default:sword_steel", "default:sword_iron")
minetest.register_alias("default:stone_with_iron", "default:iron")
minetest.register_alias("default:stone_with_gold", "default:gold")

minetest.register_alias("default:steelblock","default:ironblock")
minetest.register_alias("default:steel_ingot","default:iron_ingot")
minetest.register_alias("default:sign_wall","default:sign")
minetest.register_alias("default:papyrus","default:sugar_cane")
minetest.register_alias("default:coal_lump","default:coal")
minetest.register_alias("default:fence_wood","default:fence")
minetest.register_alias("default:sign_wall","default:sign")

-- make all nodes w/o is_ground_content unaffected by mapgen
minetest.after(0,function(dtime)
    for cou,def in pairs(minetest.registered_nodes) do
        if not def.is_ground_content then
           minetest.override_item(def.name, {is_ground_content=false,})
        end
    end
end)

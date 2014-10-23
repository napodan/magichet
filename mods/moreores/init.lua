-- Load translation library if intllib is installed

local S
if (minetest.get_modpath("intllib")) then
    dofile(minetest.get_modpath("intllib").."/intllib.lua")
    S = intllib.Getter(minetest.get_current_modname())
    else
    S = function ( s ) return s end
end

moreores_modpath = minetest.get_modpath("moreores")
dofile(moreores_modpath.."/_config.txt")

--[[
****
More Ores
by Calinou
with the help of Nore/Novatux
Licensed under the CC0
****
Changes by 4aiman:
- usage of on_place instead of on_use for hoes
- usage of get_groupcaps from "default" mod of Minitest game
- tweaked Mithril tools to be of VERY high durability but made them REALLY slow (magic~=speed)
--]]

-- Utility functions

local default_stone_sounds = default.node_sound_stone_defaults()

local function hoe_on_use(itemstack, user, pointed_thing, uses)
    local pt = pointed_thing
    -- check if pointing at a node
    if not pt then
        return
    end
    if pt.type ~= "node" then
        return
    end

    local under = minetest.get_node(pt.under)
    local p = {x=pt.under.x, y=pt.under.y+1, z=pt.under.z}
    local above = minetest.get_node(p)

    -- return if any of the nodes is not registered
    if not minetest.registered_nodes[under.name] then
        return
    end
    if not minetest.registered_nodes[above.name] then
        return
    end

    -- check if the node above the pointed thing is air
    if above.name ~= "air" then
        return
    end

    -- check if pointing at dirt
    if minetest.get_item_group(under.name, "soil") ~= 1 then
        return
    end

    -- turn the node into soil, wear out item and play sound
    minetest.set_node(pt.under, {name="farming:soil"})
    minetest.sound_play("default_dig_crumbly", {
        pos = pt.under,
        gain = 0.5,
    })
    itemstack:add_wear(65535/(uses-1))
    return itemstack
end

local function get_recipe(c, name)
    if name == "sword" then
        return {{c},{c},{"default:stick"}}
    end
    if name == "shovel" then
        return {{c},{"default:stick"},{"default:stick"}}
    end
    if name == "axe" then
        return {{c,c},{c,"default:stick"},{"","default:stick"}}
    end
    if name == "pick" then
        return {{c,c,c},{"","default:stick",""},{"","default:stick",""}}
    end
    if name == "hoe" then
        return {{c,c},{"","default:stick"},{"","default:stick"}}
    end
    if name == "block" then
        return {{c,c,c},{c,c,c},{c,c,c}}
    end
    if name == "lockedchest" then
        return {{"default:wood","default:wood","default:wood"},{"default:wood",c,"default:wood"},{"default:wood","default:wood","default:wood"}}
    end
end

local function add_ore(modname, description, mineral_name, oredef)
    local img_base = modname .. "_" .. mineral_name
    local toolimg_base = modname .. "_tool_"..mineral_name
    local tool_base = modname .. ":"
    local tool_post = "_" .. mineral_name
    local item_base = tool_base .. mineral_name
    local ingot = item_base .. "_ingot"
    local lumpitem = item_base .. "_lump"
    local ingotcraft = ingot

    if oredef.makes.ore then
        minetest.register_node(modname .. ":mineral_"..mineral_name, {
            description = S("%s Ore"):format(S(description)),
            tiles = {"default_stone.png^"..modname.."_mineral_"..mineral_name..".png"},
            groups = {cracky=default.dig.gold},
            sounds = default_stone_sounds,
            drop = lumpitem
        })
    end

    if oredef.makes.block then
        local blockitem = item_base .. "_block"
        minetest.register_node(blockitem, {
            description = S("%s Block"):format(S(description)),
            tiles = { img_base .. "_block.png" },
            groups = {cracky=default.dig.ironblock},
            sounds = default_stone_sounds
        })
        minetest.register_alias(mineral_name.."_block", blockitem)
        if oredef.makes.ingot then
            minetest.register_craft( {
                output = blockitem,
                recipe = get_recipe(ingot, "block")
            })
            minetest.register_craft( {
                output = ingot .. " 9",
                recipe = {
                    { blockitem }
                }
            })
        end
    end

    if oredef.makes.lump then
        minetest.register_craftitem(lumpitem, {
            description = S("%s Lump"):format(S(description)),
            inventory_image = img_base .. "_lump.png",
        })
        minetest.register_alias(mineral_name .. "_lump", lumpitem)
        if oredef.makes.ingot then
            minetest.register_craft({
                type = "cooking",
                output = ingot,
                recipe = lumpitem
            })
        end
    end

    if oredef.makes.ingot then
        minetest.register_craftitem(ingot, {
            description = S("%s Ingot"):format(S(description)),
            inventory_image = img_base .. "_ingot.png",
        })
        minetest.register_alias(mineral_name .. "_ingot", ingot)
    end

    if oredef.makes.chest then
        minetest.register_craft( {
            output = "default:chest_locked 1",
            recipe = {
                { ingot },
                { "default:chest" }
            }
        })
        minetest.register_craft( {
            output = "default:chest_locked 1",
            recipe = get_recipe(ingot, "lockedchest")
        })
    end

    oredef.oredef.ore_type = "scatter"
    oredef.oredef.ore = modname..":mineral_"..mineral_name
    oredef.oredef.wherein = "default:stone"

    minetest.register_ore(oredef.oredef)

    for toolname, tooldef in pairs(oredef.tools) do
        local tdef = {
            description = "",
            inventory_image = toolimg_base .. toolname .. ".png",
            tool_capabilities = {
                --max_drop_level=3,
                groupcaps=tooldef
            }
        }

        -- Sets enchantability, based on material
        if mineral_name == 'mithril' then tdef.tool_capabilities["enchantability"] = 24 end
        if mineral_name == 'silver' then tdef.tool_capabilities["enchantability"] = 14 end


        if toolname == "sword" then
            tdef.full_punch_interval = oredef.punchint
            tdef.description = S("%s Sword"):format(S(description))
            tdef.damage_groups = {fleshy=7}
        end

        if toolname == "pick" then
            tdef.description = S("%s Pickaxe"):format(S(description))
            tdef.damage_groups = {fleshy=5}
        end

        if toolname == "axe" then
            tdef.description = S("%s Axe"):format(S(description))
            tdef.damage_groups = {fleshy=5}
        end

        if toolname == "shovel" then
            tdef.description = S("%s Shovel"):format(S(description))
            tdef.damage_groups = {fleshy=3}
        end

        if toolname == "hoe" then
            tdef.description = S("%s Hoe"):format(S(description))
            local uses = tooldef.uses
            tooldef.uses = nil
            tdef.on_place = function(itemstack, user, pointed_thing)
                return hoe_on_use(itemstack, user, pointed_thing, uses)
            end
            tdef.damage_groups = {fleshy=2}
        end

        local fulltoolname = tool_base .. toolname .. tool_post
        minetest.register_tool(fulltoolname, tdef)
        minetest.register_alias(toolname .. tool_post, fulltoolname)
        if oredef.makes.ingot then
            minetest.register_craft({
                output = fulltoolname,
                recipe = get_recipe(ingot, toolname)
            })
        end
    end
end

-- Add everything (compact(ish)!)

local modname = "moreores"

local oredefs = {
    silver = {
        desc = "Silver",
        makes = {ore=true, block=true, lump=true, ingot=true, chest=true},
        oredef = {clust_scarcity = moreores_silver_chunk_size * moreores_silver_chunk_size * moreores_silver_chunk_size,
            clust_num_ores = moreores_silver_ore_per_chunk,
            clust_size     = moreores_silver_chunk_size,
            height_min     = moreores_silver_min_depth,
            height_max     = moreores_silver_max_depth
            },
        tools = {
            pick = get_groupcaps(832, "cracky",
                                    {times={
                                        [default.dig.stone] = 0.6,
                                        [default.dig.cobble] = 0.75,
                                        [default.dig.coal] = 1.15,
                                        [default.dig.iron] = 1.15,
                                        [default.dig.gold] = 0.75,
                                        [default.dig.sandstone] = 0.3,
                                        [default.dig.furnace] = 1.35,
                                        [default.dig.ice] = 0.2,
                                        [default.dig.rail] = 0.3,
                                        [default.dig.netherrack] = 0.15,
                                        [default.dig.netherbrick] = 0.75,
                                        [default.dig.brick] = 0.75,
                                        [default.dig.pressure_plate_stone] = 0.2,
                                    }, uses=832}
            ),
            hoe = {
                uses = 300
            },
            shovel = get_groupcaps(651, "crumbly",
                                    {times={
                                        [default.dig.dirt_with_grass] = 0.15,
                                        [default.dig.dirt] = 0.15,
                                        [default.dig.sand] = 0.15,
                                        [default.dig.gravel] = 0.15,
                                        [default.dig.clay] = 0.15,
                                        [default.dig.snow] = 0.05,
                                        [default.dig.snowblock] = 0.05,
                                        [default.dig.nethersand] = 0.15,
                                    }, uses=651}
            ),
            axe = get_groupcaps(551, "choppy",
                                    {times={
                                        [default.dig.tree] = 0.5,
                                        [default.dig.wood] = 0.5,
                                        [default.dig.bookshelf] = 0.4,
                                        [default.dig.fence] = 0.5,
                                        [default.dig.sign] = 0.25,
                                        [default.dig.chest] = 0.65,
                                        [default.dig.wooden_door] = 0.75,
                                        [default.dig.workbench] = 0.65,
                                        [default.dig.pressure_plate_wood] = 0.15,
                                    }, uses=551}
            ),
            sword = get_groupcaps(216, "snappy",
                                    {times={
                                        [default.dig.leaves] = 0.2,
                                        [default.dig.wool] = 1.2,
                                    }, uses=216}
            ),
        },
        punchint = 1.0
    },
    tin = {
        desc = "Tin",
        makes = {ore=true, block=true, lump=true, ingot=true, chest=false},
        oredef = {clust_scarcity = moreores_tin_chunk_size * moreores_tin_chunk_size * moreores_tin_chunk_size,
            clust_num_ores = moreores_tin_ore_per_chunk,
            clust_size     = moreores_tin_chunk_size,
            height_min     = moreores_tin_min_depth,
            height_max     = moreores_tin_max_depth
            },
        tools = {}
    },
    mithril = {
        desc = "Mithril",  -- magic material, all-capable, but extremely slow: there's only magic that helps to dig this
        makes = {ore=true, block=true, lump=true, ingot=true, chest=false},
        oredef = {clust_scarcity = moreores_mithril_chunk_size * moreores_mithril_chunk_size * moreores_mithril_chunk_size,
            clust_num_ores = moreores_mithril_ore_per_chunk,
            clust_size     = moreores_mithril_chunk_size,
            height_min     = moreores_mithril_min_depth,
            height_max     = moreores_mithril_max_depth
            },
        tools = {
            pick = get_groupcaps(3000, "cracky",
                                    {times={
                                        [default.dig.stone] = 1.35,
                                        [default.dig.cobble] = 1.65,
                                        [default.dig.coal] = 2.65,
                                        [default.dig.iron] = 1.65,
                                        [default.dig.gold] = 1.85,
                                        [default.dig.diamond] = 4.65,
                                        [default.dig.sandstone] = 1.2,
                                        [default.dig.furnace] = 1.75,
                                        [default.dig.ironblock] = 10,
                                        [default.dig.goldblock] = 4.65,
                                        [default.dig.diamondblock] = 40,
                                        [default.dig.obsidian] = 100,
                                        [default.dig.ice] = 2.15,
                                        [default.dig.rail] = 1.2,
                                        [default.dig.iron_door] = 4,
                                        [default.dig.netherrack] = 4.15,
                                        [default.dig.netherbrick] = 5.45,
                                        [default.dig.redstone_ore] = 2.65,
                                        [default.dig.brick] = 4.45,
                                        [default.dig.pressure_plate_stone] = 1.15,
                                    }, uses=3000}
            ),
            hoe = {
                uses = 300
            },
            shovel = get_groupcaps(1651, "crumbly",
                                    {times={
                                        [default.dig.dirt_with_grass] = 01.15,
                                        [default.dig.dirt] = 01.15,
                                        [default.dig.sand] = 01.15,
                                        [default.dig.gravel] = 01.15,
                                        [default.dig.clay] = 01.15,
                                        [default.dig.snow] = 01.05,
                                        [default.dig.snowblock] = 01.05,
                                        [default.dig.nethersand] = 01.15,
                                    }, uses=1651}
            ),
            axe = get_groupcaps(1551, "choppy",
                                    {times={
                                        [default.dig.tree] = 01.5,
                                        [default.dig.wood] = 01.5,
                                        [default.dig.bookshelf] = 01.4,
                                        [default.dig.fence] = 01.5,
                                        [default.dig.sign] = 1.25,
                                        [default.dig.chest] = 1.65,
                                        [default.dig.wooden_door] = 1.75,
                                        [default.dig.workbench] = 1.65,
                                        [default.dig.pressure_plate_wood] = 1.15,
                                    }, uses=1551}
            ),
            sword = get_groupcaps(1216, "snappy",
                                    {times={
                                        [default.dig.leaves] = 1.2,
                                        [default.dig.wool] = 2.2,
                                    }, uses=1216}
            ),
        },
        punchint = 0.45
    }
}

for orename,def in pairs(oredefs) do
    add_ore(modname, def.desc, orename, def)
end

-- Copper rail (special node)

minetest.register_craft({
    output = "moreores:copper_rail 16",
    recipe = {
        {"default:copper_ingot", "", "default:copper_ingot"},
        {"default:copper_ingot", "default:stick", "default:copper_ingot"},
        {"default:copper_ingot", "", "default:copper_ingot"}
    }
})

-- Bronze has some special cases, because it is made from copper and tin

minetest.register_craft( {
    type = "shapeless",
    output = "default:bronze_ingot 4",
    recipe = {
        "moreores:tin_ingot",
        "default:copper_ingot",
        "default:copper_ingot",
        "default:copper_ingot",
    }
})

-- Unique node

minetest.register_node("moreores:copper_rail", {
    description = S("Copper Rail"),
    drawtype = "raillike",
    tiles = {"moreores_copper_rail.png", "moreores_copper_rail_curved.png", "moreores_copper_rail_t_junction.png", "moreores_copper_rail_crossing.png"},
    inventory_image = "moreores_copper_rail.png",
    wield_image = "moreores_copper_rail.png",
    paramtype = "light",
    sunlight_propagates = true,
    walkable = false,
    selection_box = {
        type = "fixed",
        fixed = {-1/2, -1/2, -1/2, 1/2, -1/2+1/16, 1/2},
    },
    groups = {bendy=2,snappy=1,dig_immediate=2,rail=1,connect_to_raillike=1},
    mesecons = {
        effector = {
            action_on = function(pos, node)
                minetest.get_meta(pos):set_string("cart_acceleration", "0.5")
            end,

            action_off = function(pos, node)
                minetest.get_meta(pos):set_string("cart_acceleration", "0")
            end,
        },
    },
})

print('[OK] Moreores (4aiman\'s version) loaded')

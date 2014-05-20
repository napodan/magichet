-- Desert Uses (desert_uses) mod by Menche
-- Makes deserts more useful
-- License: LGPL

-- Node definitions --------------------
-- Desert Cobble
minetest.register_node("desert_uses:desert_cobble", {
        description = "Desert Cobblestone",
        tiles = {"desert_uses_desert_cobble.png"},
        is_ground_content = true,
        groups = {cracky=default.dig.stone},
        sounds = default.node_sound_stone_defaults(),
})

-- Make desert stone drop desert cobble
minetest.register_node(":default:desert_stone", {
        description = "Desert Stone",
        tiles = {"default_desert_stone.png"},
        is_ground_content = true,
        groups = {cracky=default.dig.stone},
        drop = "desert_uses:desert_cobble",
        sounds = default.node_sound_stone_defaults(),
})

-- Desert Sandstone
minetest.register_node("desert_uses:desert_sandstone", {
        description = "Desert Sandstone",
        tiles = {"desert_uses_desert_sandstone.png"},
        is_ground_content = true,
        groups = {cracky=default.dig.wood},
        sounds = default.node_sound_stone_defaults(),
})

-- Stairs -----------------------------
-- Desert Cobble
stairs.register_stair_and_slab("desert_cobble", "desert_uses:desert_cobble",
        {cracky=3},
        {"desert_uses_desert_cobble.png"},
        "Desert Cobble stair",
        "Desert Cobble slab")

-- Desert Stone
stairs.register_stair_and_slab("desert_stone", "default:desert_stone",
        {cracky=3},
        {"default_desert_stone.png"},
        "Desert Stone stair",
        "Desert Stone slab")

-- Desert Sandstone
stairs.register_stair_and_slab("desert_sandstone", "desert_uses:desert_sandstone",
        {cracky=2, crumbly=2},
        {"desert_uses_desert_sandstone.png"},
        "Desert Sandstone stair",
        "Desert Sandstone slab")

-- Tool definitions -------------------
-- Desert stone pickaxe
minetest.register_tool("desert_uses:pick_desert_stone", {
        description = "Desert Stone Pickaxe",
        inventory_image = "desert_uses_tool_desert_stonepick.png",
        tool_capabilities = {
                max_drop_level=0,
                groupcaps={
                        cracky={times={[1]=3.00, [2]=1.20, [3]=0.80}, uses=20, maxlevel=1}
                }
        },
})

-- Desert stone shovel
minetest.register_tool("desert_uses:shovel_desert_stone", {
        description = "Desert Stone Shovel",
        inventory_image = "desert_uses_tool_desert_stoneshovel.png",
        tool_capabilities = {
                max_drop_level=0,
                groupcaps={
                        crumbly={times={[1]=1.50, [2]=0.50, [3]=0.30}, uses=20, maxlevel=1}
                }
        },
})

-- Desert stone axe
minetest.register_tool("desert_uses:axe_desert_stone", {
        description = "Desert Stone Axe",
        inventory_image = "desert_uses_tool_desert_stoneaxe.png",
        tool_capabilities = {
                max_drop_level=0,
                groupcaps={
                        choppy={times={[1]=3.00, [2]=1.00, [3]=0.60}, uses=20, maxlevel=1},
                        fleshy={times={[2]=1.30, [3]=0.70}, uses=20, maxlevel=1},
                }
        }
})

-- Desert stone sword
minetest.register_tool("desert_uses:sword_desert_stone", {
        description = "Desert Stone Sword",
        inventory_image = "desert_uses_tool_desert_stonesword.png",
        tool_capabilities = {
                full_punch_interval = 1.0,
                max_drop_level=0,
                groupcaps={
                        fleshy={times={[2]=0.80, [3]=0.40}, uses=20, maxlevel=1},
                        snappy={times={[2]=0.80, [3]=0.40}, uses=20, maxlevel=1},
                        choppy={times={[3]=0.90}, uses=20, maxlevel=0}
                }
        }
})

-- Craft definitions -------------------
-- Desert sandstone
minetest.register_craft({
        output = "desert_uses:desert_sandstone",
        recipe = {
                {"default:desert_sand", "default:desert_sand"},
                {"default:desert_sand", "default:desert_sand"},
        },
})

minetest.register_craft({
        output = "default:desert_sand 4",
        recipe = {
                {"desert_uses:desert_sandstone"},
        }
})

-- Desert stone pickaxe
minetest.register_craft({
        output = "desert_uses:pick_desert_stone",
        recipe = {
                {"desert_uses:desert_cobble", "desert_uses:desert_cobble", "desert_uses:desert_cobble"},
                {"", "default:stick", ""},
                {"", "default:stick", ""},
        }
})

-- Desert stone shovel
minetest.register_craft({
        output = "desert_uses:shovel_desert_stone",
        recipe = {
                {"desert_uses:desert_cobble"},
                {"default:stick"},
                {"default:stick"},
        }
})

-- Desert stone axe
minetest.register_craft({
        output = "desert_uses:axe_desert_stone",
        recipe = {
                {"desert_uses:desert_cobble", "desert_uses:desert_cobble"},
                {"desert_uses:desert_cobble", "default:stick"},
                {"", "default:stick"},
        }
})

-- Desert stone axe (flipped recipe)
minetest.register_craft({
        output = "desert_uses:axe_desert_stone",
        recipe = {
                {"desert_uses:desert_cobble", "desert_uses:desert_cobble"},
                {"default:stick", "desert_uses:desert_cobble"},
                {"default:stick", ""},
        }
})

-- Desert stone sword
minetest.register_craft({
        output = "desert_uses:sword_desert_stone",
        recipe = {
                {"desert_uses:desert_cobble"},
                {"desert_uses:desert_cobble"},
                {"default:stick"},
        }
})

-- Stick from dry shrub
minetest.register_craft({
        output = "default:stick 4",
        recipe = {
                {"default:dry_shrub"},
        }
})

-- Desert Cobble -> Desert Stone
minetest.register_craft({
        type = "cooking",
        output = "default:desert_stone",
        recipe = "desert_uses:desert_cobble",
})

-- Furnace
minetest.register_craft({
        output = "desert_uses:desert_furnace",
        recipe = {
                {"desert_uses:desert_cobble", "desert_uses:desert_cobble", "desert_uses:desert_cobble"},
                {"desert_uses:desert_cobble", "", "desert_uses:desert_cobble"},
                {"desert_uses:desert_cobble", "desert_uses:desert_cobble", "desert_uses:desert_cobble"},
        }
})


-- This fits me perfectly (taken from http://lua-users.org/wiki/CopyTable)
function deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[deepcopy(orig_key)] = deepcopy(orig_value)
        end
        setmetatable(copy, deepcopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

-- copy furnace and change the textures ))
local furnace_inactive_def = deepcopy(minetest.registered_nodes['default:furnace'])
furnace_inactive_def.tiles ={"desert_uses_furnace_top.png", "desert_uses_furnace_bottom.png", "desert_uses_furnace_side.png",
                "desert_uses_furnace_side.png", "desert_uses_furnace_side.png", "desert_uses_furnace_front.png"}
furnace_inactive_def.description = "Desert Furnace"
minetest.register_node("desert_uses:desert_furnace", furnace_inactive_def)


local furnace_active_def = deepcopy(minetest.registered_nodes['default:furnace_active'])
furnace_active_def.tiles = {"desert_uses_furnace_top.png", "desert_uses_furnace_bottom.png", "desert_uses_furnace_side.png",
                "desert_uses_furnace_side.png", "desert_uses_furnace_side.png",
                {
                        image="desert_uses_furnace_front_active.png",
                        backface_culling=true,
                        animation={type="vertical_frames", aspect_w=32, aspect_h=32, length=0.8}
                },
                }
furnace_inactive_def.description = "Desert Furnace"
minetest.register_node("desert_uses:desert_furnace_active",furnace_active_def)

minetest.register_abm({
    nodenames = {"desert_uses:desert_furnace","desert_uses:desert_furnace_active"},
    interval = 1,
    chance = 1,
    action = function(pos, node, active_object_count, active_object_count_wider)
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
                    print("Could not insert '"..cooked.item:to_string().."'")
                end
                meta:set_string("src_time", 0)
            end
        end

        if meta:get_float("fuel_time") < meta:get_float("fuel_totaltime") then
            local percent = math.floor(meta:get_float("fuel_time") / meta:get_float("fuel_totaltime") * 100)
            local percent2 = math.floor(meta:get_float("src_time") / meta:get_float("src_totaltime") * 100)
            meta:set_string("infotext","Desert Furnace active: "..percent2.."%")
            meta:set_string("percent", percent)
            local node = minetest.get_node(pos)
            node.name = "desert_uses:desert_furnace_active"
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
            return
        end

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

        if fuel.time <= 0 then
            meta:set_string("infotext","Desert Furnace out of fuel")
            meta:set_string("formspect", default.furnace_inactive_formspec)
            local node = minetest.get_node(pos)
            node.name = "desert_uses:desert_furnace"
            minetest.swap_node(pos,node,2)
            return
        end

        if cooked.item:is_empty() then
            if was_active then
                meta:set_string("infotext","Desert Furnace is empty")
                meta:set_string("formspect", default.furnace_inactive_formspec)
                local node = minetest.get_node(pos)
                node.name = "desert_uses:desert_furnace"
                minetest.swap_node(pos,node,2)
            end
            return
        end

        meta:set_string("fuel_totaltime", fuel.time)
        meta:set_string("fuel_time", 0)

        inv:set_stack("fuel", 1, afterfuel.items[1])
    end,
})

print("[OK] Desert uses 4 loaded")


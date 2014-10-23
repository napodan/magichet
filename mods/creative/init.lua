-- minetest/creative/init.lua
-- modified by 4aiman to support MC-like inventories

creative_inventory = {}
creative_inventory.creative_inventory_size = 0

-- Create detached creative inventory after loading all mods
minetest.after(0, function()
    local inv = minetest.create_detached_inventory("creative", {
        allow_move = function(inv, from_list, from_index, to_list, to_index, count, player)
            if minetest.setting_getbool("creative_mode") then
                return count
            else
                return 0
            end
        end,
        allow_put = function(inv, listname, index, stack, player)
            return 0
        end,
        allow_take = function(inv, listname, index, stack, player)
            if minetest.setting_getbool("creative_mode") then
                return -1
            else
                return 0
            end
        end,
        on_move = function(inv, from_list, from_index, to_list, to_index, count, player)
        end,
        on_put = function(inv, listname, index, stack, player)
        end,
        on_take = function(inv, listname, index, stack, player)
            --print(player:get_player_name().." takes item from creative inventory; listname="..dump(listname)..", index="..dump(index)..", stack="..dump(stack))
            if stack then
                minetest.log("action", player:get_player_name().." считерил "..dump(stack:get_name()).." с помощью меню креатива")
                --print("stack:get_name()="..dump(stack:get_name())..", stack:get_count()="..dump(stack:get_count()))
            end
        end,
    })
    local creative_list = {}
    for name,def in pairs(minetest.registered_items) do
        if (not def.groups.not_in_creative_inventory or def.groups.not_in_creative_inventory == 0) and not name:find('enchantment:')
                and def.description and def.description ~= "" then
            table.insert(creative_list, name)
        end
    end
    table.sort(creative_list)
    inv:set_size("main", #creative_list)
    for _,itemstring in ipairs(creative_list) do
        inv:add_item("main", ItemStack(itemstring))
    end
    creative_inventory.creative_inventory_size = #creative_list
    --print("creative inventory size: "..dump(creative_inventory.creative_inventory_size))
end)

-- Create the trash field
local trash = minetest.create_detached_inventory("creative_trash", {
    -- Allow the stack to be placed and remove it in on_put()
    -- This allows the creative inventory to restore the stack
    allow_put = function(inv, listname, index, stack, player)
        if minetest.setting_getbool("creative_mode") then
            return stack:get_count()
        else
            return 0
        end
    end,
    on_put = function(inv, listname, index, stack, player)
        inv:set_stack(listname, index, "")
    end,
})
trash:set_size("main", 1)


creative_inventory.set_creative_formspec = function(player, start_i, pagenum)
    pagenum = math.floor(pagenum)
    local pagemax = math.floor((creative_inventory.creative_inventory_size-1) / (7*4) + 1)
    player:set_inventory_formspec("size[13.5,8]"..
            "bgcolor[#bbbbbb;false]"..
            "listcolors[#777777;#cccccc;#333333;#555555;#dddddd]"..

            "button[11.1,-0.0;0.8,0.5;sort_horz;=]"..
            "button[11.9,-0.0;0.8,0.5;sort_vert;||]"..
            "button[12.7,-0.0;0.8,0.5;sort_norm;Z]"..
            --"image[6,0.6;1,2;player.png]"..
            "list[current_player;helm;4.5,0;1,1;]"..
            "list[current_player;torso;4.5,1;1,1;]"..
            "list[current_player;pants;4.5,2;1,1;]"..
            "list[current_player;boots;4.5,3;1,1;]"..

            "list[current_player;main;4.5,4;9,3;9]"..
            "list[current_player;main;4.5,7.2;9,1;]"..
            "list[current_player;craft;7.4,0.5;3,3;]"..
            "list[current_player;craftpreview;11.5,1.5;1,1;]"..
            "list[detached:creative;main;0,0;4,7;"..tostring(start_i).."]"..
            "label[1.6,7.1;"..tostring(pagenum).."/"..tostring(pagemax).."]"..
            "button[0,7;1.6,1;creative_prev;<<]"..
            "button[2.4,7;1.6,1;creative_next;>>]"..
            "label[5.5,1.5;Trash:]"..
            "list[detached:creative_trash;main;5.5,2;1,1;]")
end
minetest.register_on_joinplayer(function(player)
    -- If in creative mode, modify player's inventory forms
    if not minetest.setting_getbool("creative_mode") then
        return
    end
    creative_inventory.set_creative_formspec(player, 0, 1)

player:get_inventory():set_width("craft", 3)
player:get_inventory():set_size("craft",  9)
player:get_inventory():set_size("main",   9*4)

end)
minetest.register_on_player_receive_fields(function(player, formname, fields)
    if not minetest.setting_getbool("creative_mode") then
        return
    end
    -- Figure out current page from formspec
    local current_page = 0
    local formspec = player:get_inventory_formspec()
    local start_i = string.match(formspec, "list%[detached:creative;main;[%d.]+,[%d.]+;[%d.]+,[%d.]+;(%d+)%]")
    start_i = tonumber(start_i) or 0

    if fields.creative_prev then
        start_i = start_i - 4*7
    end
    if fields.creative_next then
        start_i = start_i + 4*7
    end

    if start_i < 0 then
        start_i = start_i + 4*7
    end
    if start_i >= creative_inventory.creative_inventory_size then
        start_i = start_i - 4*7
    end

    if start_i < 0 or start_i >= creative_inventory.creative_inventory_size then
        start_i = 0
    end

    creative_inventory.set_creative_formspec(player, start_i, start_i / (7*4) + 1)
end)

minetest.register_tool(":", {
    type = "none",
    wield_image = "wieldhand.png",
    wield_scale = {x=1,y=1,z=2.5},
    tool_capabilities = {
        groupcaps = {
        cracky = {times={
            [1] = 0.2,
            [2] = 0.2,
            [3] = 0.2,
            [4] = 0.2,
            [5] = 0.2,
            [6] = 0.2,
            [7] = 0.2,
            [8] = 0.2,
            [9] = 0.2,
            [10] = 0.2,
            [11] = 0.2,
            [12] = 0.2,
            [13] = 0.2,
            [14] = 0.2,
            [15] = 0.2,
            [16] = 0.2,
            [17] = 0.2,
            [18] = 0.2,
            [19] = 0.2,
            [20] = 0.2,            
        }, uses=0},
        crumbly = {times={
            [1] = 0.2,
            [2] = 0.2,
            [3] = 0.2,
            [4] = 0.2,
            [5] = 0.2,
            [6] = 0.2,
            [7] = 0.2,
            [8] = 0.2,
            [9] = 0.2,
            [10] = 0.2,
            [11] = 0.2,
            [12] = 0.2,
            [13] = 0.2,
            [14] = 0.2,
            [15] = 0.2,
            [16] = 0.2,
            [17] = 0.2,
            [18] = 0.2,
            [19] = 0.2,
            [20] = 0.2,            
        }, uses=0},
        choppy = {times={
            [1] = 0.2,
            [2] = 0.2,
            [3] = 0.2,
            [4] = 0.2,
            [5] = 0.2,
            [6] = 0.2,
            [7] = 0.2,
            [8] = 0.2,
            [9] = 0.2,
            [10] = 0.2,
            [11] = 0.2,
            [12] = 0.2,
            [13] = 0.2,
            [14] = 0.2,
            [15] = 0.2,
            [16] = 0.2,
            [17] = 0.2,
            [18] = 0.2,
            [19] = 0.2,
            [20] = 0.2,            
        }, uses=0},
        snappy = {times={
            [1] = 0.2,
            [2] = 0.2,
            [3] = 0.2,
            [4] = 0.2,
            [5] = 0.2,
            [6] = 0.2,
            [7] = 0.2,
            [8] = 0.2,
            [9] = 0.2,
            [10] = 0.2,
            [11] = 0.2,
            [12] = 0.2,
            [13] = 0.2,
            [14] = 0.2,
            [15] = 0.2,
            [16] = 0.2,
            [17] = 0.2,
            [18] = 0.2,
            [19] = 0.2,
            [20] = 0.2,            
        }, uses=0},
        dig = {times={
            [1] = 0.2,
            [2] = 0.2,
            [3] = 0.2,
            [4] = 0.2,
            [5] = 0.2,
            [6] = 0.2,
            [7] = 0.2,
            [8] = 0.2,
            [9] = 0.2,
            [10] = 0.2,
            [11] = 0.2,
            [12] = 0.2,
            [13] = 0.2,
            [14] = 0.2,
            [15] = 0.2,
            [16] = 0.2,
            [17] = 0.2,
            [18] = 0.2,
            [19] = 0.2,
            [20] = 0.2,            
        }, uses=0},
        fleshy = {times={
            [1] = 0.2,
            [2] = 0.2,
            [3] = 0.2,
            [4] = 0.2,
            [5] = 0.2,
            [6] = 0.2,
            [7] = 0.2,
            [8] = 0.2,
            [9] = 0.2,
            [10] = 0.2,
            [11] = 0.2,
            [12] = 0.2,
            [13] = 0.2,
            [14] = 0.2,
            [15] = 0.2,
            [16] = 0.2,
            [17] = 0.2,
            [18] = 0.2,
            [19] = 0.2,
            [20] = 0.2,            
        }, uses=0},
    }},
        full_punch_interval = 1,
        enchantability = -1,
        damage_groups = {fleshy=1},
})



print('[OK] Creative (deprecated) loaded')


-----------------------------
--- 4vision mod by 4aiman ---
---   based on ZGC mod    ---
---        by Zeg9        ---
-----------------------------
--- license: CC BY-NC 3.0 ---
-----------------------------

vision = {}

vision.users = {}
vision.crafts = {}
vision.itemlist = {}
vision.huds = {}
vision.huds2 = {}
vision.huds3 = {}
local wield={}
local dtimes={}
local dlimit=3  -- hud will be hidden after this much seconds

vision.items_in_group = function(group)
    local items = {}
    local ok = true
    for name, item in pairs(minetest.registered_items) do
        -- the node should be in all groups
        ok = true
        for _, g in ipairs(group:split(',')) do
            if not item.groups[g] then
                ok = false
            end
        end
        if ok then table.insert(items,name) end
    end
    return items
end

local table_copy = function(table)
    out = {}
    for k,v in pairs(table) do
        out[k] = v
    end
    return out
end

vision.add_craft = function(input, output, groups)
    if minetest.get_item_group(output, "not_in_craft_guide") > 0 then
        return
    end
    if not groups then groups = {} end
    local c = {}
    c.width = input.width
    c.type = input.type
    c.items = input.items
    if c.items == nil then return end
    for i, item in pairs(c.items) do
        if item:sub(0,6) == "group:" then
            local groupname = item:sub(7)
            if groups[groupname] ~= nil then
                c.items[i] = groups[groupname]
            else
                for _, gi in ipairs(vision.items_in_group(groupname)) do
                    local g2 = groups
                    g2[groupname] = gi
                    vision.add_craft({
                        width = c.width,
                        type = c.type,
                        items = table_copy(c.items)
                    }, output, g2) -- it is needed to copy the table, else groups won't work right
                end
                return
            end
        end
    end
    if c.width == 0 then c.width = 3 end
    table.insert(vision.crafts[output],c)
end

vision.load_crafts = function(name)
    vision.crafts[name] = {}
            local _recipes = minetest.get_craft_recipe(name)
    if _recipes then
            if (_recipes.items and _recipes.type) then
                           minetest.debug(minetest.serialize(_recipes))
                vision.add_craft(_recipes, name)
            end
    end
    if vision.crafts[name] == nil or #vision.crafts[name] == 0 then
        vision.crafts[name] = nil
    else
        table.insert(vision.itemlist,name)
    end
end

vision.need_load_all = true

vision.load_all = function()
    print("4vision is loading crafts, this may take some time...")
    local i = 0
    for name, item in pairs(minetest.registered_items) do
        if (name and name ~= "") then
            vision.load_crafts(name)
        end
        i = i+1
    end
    table.sort(vision.itemlist)
    vision.need_load_all = false
    print("4vision has loaded needed stuff!")
end

if vision.need_load_all then vision.load_all() end

minetest.register_on_joinplayer(function(pl)
  local pll = pl:get_player_name()
  vision.huds[pll]={} --tl,tc,tr,ml,mc,mr,bl,bc,br,bg'
  vision.huds2[pll]={}
  vision.huds3[pll]={}
end)


local function get_texture_name(item)
    if minetest.registered_nodes[item] then
       local tiles = minetest.registered_nodes[item]["tiles"]
       if type(tiles)=='table' then return tiles[1]
       else return tiles
       end
    end
    return ""
end

minetest.register_craftitem('4vision:engineer_goggles', {
    description = "Engineer goggles",
    inventory_image = "e_g.png",
    on_use = function(itemstack, user, pointed_thing)
               if not pointed_thing or not pointed_thing.under then print('pt is nil') return end
               if not user then  print('no user') return end
               local pos = pointed_thing.under
               local node = minetest.get_node(pos)
               if not node then  print('node is nil') return end
               local current_item = node.name
               local player = user
               local pll = player:get_player_name()
--               local wstack = player:get_wielded_item():get_name()
--               if wstack~='4vision:engineer_goggles' then -- show crafts only if goggles "equipped"


                for i=1,9 do
                if vision.huds2[pll][i] then player:hud_remove(vision.huds2[pll][i]) end
                if vision.huds3[pll][i] then player:hud_remove(vision.huds3[pll][i]) end
                print(vision.huds[pll][i])
                      local xoff = ((i-1)%3+3)*40
                      local yoff = (math.floor((i-1)/3+0))*40
                      vision.huds2[pll][i] = player:hud_add({
                        hud_elem_type = "image",
                        position = {x=0.7, y=0.45},
                        offset = {x=xoff, y=yoff},
                        alignment = {x=-1, y=0},
                        scale = {x=1, y=1},
                        number = 0xFFFFFF ,
                        name = "grid_cell_" .. i,
                        text = '4vision_grid.png',
                      })
                end
               local tile, tp
                if vision.crafts[current_item] then
                   local cn = #vision.crafts[current_item]
                   local c = vision.crafts[current_item][cn]
                    if c then
                        local x = 3
                        local y = 0
        --                local tl,tc,tr,ml,mc,mr,bl,bc,br,bg,tp
                        vision.huds[pll]={}
                        for i, item in pairs(c.items) do
                            tile=get_texture_name(item)
                     local xoff = ((i-1)%c.width+3)*40
                      local yoff = (math.floor((i-1)/c.width+0))*40
        --                print(tile ..' at [' .. xoff .. ',' .. yoff .. ']')

                    vision.huds3[pll][i] = player:hud_add({
                        hud_elem_type = "image",
                        position = {x=0.7, y=0.45},
                        offset = {x=xoff, y=yoff},
                        alignment = {x=-1, y=0},
                        scale = {x=1, y=1},
                        number = 0xFFFFFF ,
                        name = "grid_item_" .. i,
                        text = tile,
                      })

                        end
                        if c.type == "normal" then tp = 'Normal'
                        elseif c.type == "cooking" then tp = 'Cooking'
                        end
                    end
                end


    end,
})

print('[OK] 4vision loaded')

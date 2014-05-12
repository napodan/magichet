-- Minetest 0.4 mod: farming
-- Original mod: Copyright (C) 2012-2013 PilzAdam
-- Edited & expanded by 4aiman, 2013-2014
-- Credit goes to all authors of the original textures,
-- athough they were replaced

-- some vars
local cheat_chance = 70 -- % of fertilizer's chance to speed up the growth

-- USEFULL FUNCTIONS --

-- gets any field of nodedef; MT has it's own
local function get_field(nodename, fieldname)
    if not minetest.registered_nodes[nodename] then
        return nil
    end
    return minetest.registered_nodes[nodename][fieldname]
end

-- regular growth func; subject to be changed to support MC-like cond detection
function try_to_grow(pos,node)
        -- return if already full grown
        if not node or not node.name then return false end
        local plantname = get_field(node.name, "plantname")             -- name of the plant
        local mature = minetest.get_item_group(node.name, plantname)    -- phases till grow
        local light_req = get_field(node.name, "light_req")             -- light level needed
        local state_count = get_field(node.name, "state_count")
       -- print(tostring(plantname).. " - " .. tostring(mature) .. " - " .. tostring(light_req))

        if not plantname or not mature or not light_req
        then
            return false
        end
        if mature == state_count then
            return false
        end

        -- check if on wet soil
       -- print(minetest.pos_to_string(pos))
        pos.y = pos.y-1
        --print(minetest.pos_to_string(pos))
        local n = minetest.get_node(pos)
        local nn = n.name
        if minetest.get_item_group(n.name, "soil") < 3 then
            --print(nn .. ' is soil? And the "soil" group is '.. tostring(minetest.get_item_group(n.name, "soil")) .. " instead of 3" )
            return false
        end
        pos.y = pos.y+1

        -- check light
        if not minetest.get_node_light(pos) then
            return false
        end
        if minetest.get_node_light(pos) < light_req then
           print('light is '.. tostring(minetest.get_node_light(pos)) .. " instead of " .. tostring(light_req) )
            return false
        end

        -- grow
        local height = mature + 1
        minetest.set_node(pos, {name="farming:"..plantname.."_"..height})
        return true
    end

-- cheating func like that of bonemeal
function try_to_grow_cheating(pos,node)
   local rnd = math.random(1,100/cheat_chance) -- 20% chances
   if rnd == 1 then
      local grown = try_to_grow(pos,node)
      if not grown then return false end
      local pos1 = {x=pos.x-0.3, y=pos.y-0.3, z=pos.z-0.3}
      local pos2 = {x=pos.x+0.3, y=pos.y+0.3, z=pos.z+0.3}
      local sdd = minetest.add_particlespawner(
                                                15,
                                                0,
                                                pos1,
                                                pos2,
                                                {x=-0.1, y=0.1, z=-0.1},
                                                {x=0.1, y=0.2, z=0.1},
                                                {x=-0.1, y=0.05, z=-0.1},
                                                {x=0.1, y=0.2, z=0.1},
                                                1,
                                                1,
                                                0.5,
                                                3,
                                                false,
                                                "farming_part.png"
                                            )
    minetest.after(1,function()
    minetest.delete_particlespawner(sdd)
    end)
   end
   return true
end

----

--
-- Soil
--
minetest.register_node("farming:soil", {
    description = "Soil",
    tiles = {"farming_soil.png", "default_dirt.png"},
    drop = "default:dirt",
    is_ground_content = true,
    groups = {crumbly=default.dig.dirt_with_grass, not_in_creative_inventory=1, soil=2},
    sounds = default.node_sound_dirt_defaults(),
})

minetest.register_node("farming:soil_wet", {
    description = "Wet Soil",
    tiles = {"farming_soil_wet.png", "farming_soil_wet_side.png"},
    drop = "default:dirt",
    is_ground_content = true,
    groups = {crumbly=default.dig.dirt_with_grass, not_in_creative_inventory=0, soil=3},
    sounds = default.node_sound_dirt_defaults(),
})

minetest.register_abm({
    nodenames = {"farming:soil", "farming:soil_wet"},
    interval = 15,
    chance = 4,
    action = function(pos, node)
        pos.y = pos.y+1
        local nn = minetest.get_node(pos).name
        pos.y = pos.y-1
        if minetest.registered_nodes[nn] and minetest.registered_nodes[nn].walkable then
            minetest.set_node(pos, {name="default:dirt"})
        end
        -- check if there is water nearby
        if minetest.find_node_near(pos, 4, {"group:water"}) then
            -- if it is dry soil turn it into wet soil
            if node.name == "farming:soil" then
                minetest.set_node(pos, {name="farming:soil_wet"})
            end
        else
            -- turn it back into dirt if it is already dry
            if node.name == "farming:soil" then
                -- only turn it back if there is no plant on top of it
                if minetest.get_item_group(nn, "plant") == 0 then
                    minetest.set_node(pos, {name="default:dirt"})
                end

            -- if its wet turn it back into dry soil
            elseif node.name == "farming:soil_wet" then
                minetest.set_node(pos, {name="farming:soil"})
            end
        end
    end,
})

--
-- Hoes
--
-- turns nodes with group soil=1 into soil
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

    if minetest.registered_nodes[under.name].on_rightclick then
        return minetest.registered_nodes[under.name].on_rightclick(pt.under, under, user, itemstack)
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

minetest.register_tool("farming:hoe_wood", {
    description = "Wooden Hoe",
    inventory_image = "farming_tool_woodhoe.png",

    on_place = function(itemstack, user, pointed_thing)
        return hoe_on_use(itemstack, user, pointed_thing, 60)
    end,
})

minetest.register_tool("farming:hoe_stone", {
    description = "Stone Hoe",
    inventory_image = "farming_tool_stonehoe.png",

    on_place = function(itemstack, user, pointed_thing)
        return hoe_on_use(itemstack, user, pointed_thing, 132)
    end,
})

minetest.register_tool("farming:hoe_iron", {
    description = "Iron Hoe",
    inventory_image = "farming_tool_ironhoe.png",

    on_place = function(itemstack, user, pointed_thing)
        return hoe_on_use(itemstack, user, pointed_thing, 251)
    end,
})

minetest.register_tool("farming:hoe_bronze", {
    description = "Bronze Hoe",
    inventory_image = "farming_tool_bronzehoe.png",

    on_place = function(itemstack, user, pointed_thing)
        return hoe_on_use(itemstack, user, pointed_thing, 451)
    end,
})

minetest.register_tool("farming:hoe_gold", {
    description = "Gold Hoe",
    inventory_image = "farming_tool_goldhoe.png",

    on_place = function(itemstack, user, pointed_thing)
        return hoe_on_use(itemstack, user, pointed_thing, 33)
    end,
})

minetest.register_tool("farming:hoe_mese", {
    description = "Mese Hoe",
    inventory_image = "farming_tool_mesehoe.png",

    on_place = function(itemstack, user, pointed_thing)
        return hoe_on_use(itemstack, user, pointed_thing, 1200)
    end,
})

minetest.register_tool("farming:hoe_diamond", {
    description = "Diamond Hoe",
    inventory_image = "farming_tool_diamondhoe.png",

    on_place = function(itemstack, user, pointed_thing)
        return hoe_on_use(itemstack, user, pointed_thing, 1562)
    end,
})

minetest.register_craft({
    output = "farming:hoe_wood",
    recipe = {
        {"group:wood", "group:wood"},
        {"", "default:stick"},
        {"", "default:stick"},
    }
})

minetest.register_craft({
    output = "farming:hoe_stone",
    recipe = {
        {"group:stone", "group:stone"},
        {"", "default:stick"},
        {"", "default:stick"},
    }
})

minetest.register_craft({
    output = "farming:hoe_iron",
    recipe = {
        {"default:iron_ingot", "default:iron_ingot"},
        {"", "default:stick"},
        {"", "default:stick"},
    }
})

minetest.register_craft({
    output = "farming:hoe_bronze",
    recipe = {
        {"default:bronze_ingot", "default:bronze_ingot"},
        {"", "default:stick"},
        {"", "default:stick"},
    }
})

minetest.register_craft({
    output = "farming:hoe_gold",
    recipe = {
        {"default:gold_ingot", "default:gold_ingot"},
        {"", "default:stick"},
        {"", "default:stick"},
    }
})

minetest.register_craft({
    output = "farming:hoe_mese",
    recipe = {
        {"default:mese_crystal", "default:mese_crystal"},
        {"", "default:stick"},
        {"", "default:stick"},
    }
})

minetest.register_craft({
    output = "farming:hoe_diamond",
    recipe = {
        {"default:diamond", "default:diamond"},
        {"", "default:stick"},
        {"", "default:stick"},
    }
})

--
-- Override grass for drops
--
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
    drop = {
        max_items = 1,
        items = {
            {items = {'farming:seed_wheat'},rarity = 5},
        }
    },
    groups = {dig_immediate=3,flammable=3,flora=1,attached_node=1},
    sounds = default.node_sound_leaves_defaults({
        dug = {name="default_dig_crumbly", gain=0.4}
    }),

    selection_box = {
        type = "fixed",
        fixed = {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
    },
    after_dig_node = function(pos, oldnode, oldmetadata, digger)
        local nn = "default:grass_1"
        if math.random(1, 5) == 1 then
            nn = "farming:seed_wheat"
        end
        if minetest.setting_getbool("creative_mode") then
            local inv = digger:get_inventory()
            if not inv:contains_item("main", ItemStack(nn)) then
                inv:add_item("main", ItemStack(nn))
            end
        else
            if digger:get_wielded_item():get_name() == "default:shears"  or nn ~= "default:grass_1" then
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
    after_dig_node = function(pos, oldnode, oldmetadata, digger)
        local nn = "default:grass_1"
        if math.random(1, 5) == 1 then
            nn = "farming:seed_wheat"
        end
        if minetest.setting_getbool("creative_mode") then
            local inv = digger:get_inventory()
            if not inv:contains_item("main", ItemStack(nn)) then
                inv:add_item("main", ItemStack(nn))
            end
        else
            if digger:get_wielded_item():get_name() == "default:shears" or nn ~= "default:grass_1" then
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
        groups = {dig_immediate=3,flammable=3,flora=1,attached_node=1,not_in_creative_inventory=1},
        sounds = default.node_sound_leaves_defaults({
            dug = {name="default_dig_crumbly", gain=0.4}
        }),

        selection_box = {
            type = "fixed",
            fixed = {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
        },
    })
end

minetest.register_node(":default:junglegrass", {
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
    drop = {
        max_items = 1,
        items = {
            {items = {'farming:seed_cotton'},rarity = 8},
        }
    },
    after_dig_node = function(pos, oldnode, oldmetadata, digger)
        local nn = "default:junglegrass"
        if math.random(1, 8) == 1 then
            nn = "farming:seed_cotton"
        end
        if minetest.setting_getbool("creative_mode") then
            local inv = digger:get_inventory()
            if not inv:contains_item("main", ItemStack(nn)) then
                inv:add_item("main", ItemStack(nn))
            end
        else
            if digger:get_wielded_item():get_name() == "default:shears"  or nn ~= "default:junglegrass" then
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

    groups = {dig_immediate=3,flammable=2,flora=1,attached_node=1},
    sounds = default.node_sound_leaves_defaults(),
    selection_box = {
        type = "fixed",
        fixed = {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
    },
})

--
-- Place seeds
--
local function place_seed(itemstack, placer, pointed_thing, plantname)
    local pt = pointed_thing
    -- check if pointing at a node
    if not pt then
        return
    end
    if pt.type ~= "node" then
        return
    end

    local under = minetest.get_node(pt.under)
    local above = minetest.get_node(pt.above)

    -- return if any of the nodes is not registered
    if not minetest.registered_nodes[under.name] then
        return
    end
    if not minetest.registered_nodes[above.name] then
        return
    end

    -- check if pointing at the top of the node
    if pt.above.y ~= pt.under.y+1 then
        return
    end

    -- check if you can replace the node above the pointed node
    if not minetest.registered_nodes[above.name].buildable_to then
        return
    end

    -- check if pointing at soil
    if minetest.get_item_group(under.name, "soil") <= 1 then
        return
    end

    -- add the node and remove 1 item from the itemstack
    minetest.add_node(pt.above, {name=plantname})
    if not minetest.setting_getbool("creative_mode") then
        itemstack:take_item()
    end
    return itemstack
end

--
-- Wheat
--
minetest.register_craftitem("farming:seed_wheat", {
    description = "Wheat Seed",
    inventory_image = "farming_wheat_seed.png",

    on_place = function(itemstack, placer, pointed_thing)
        return place_seed(itemstack, placer, pointed_thing, "farming:wheat_1")
    end,
})

minetest.register_craftitem("farming:wheat", {
    description = "Wheat",
    inventory_image = "farming_wheat.png",

})

for i=1,8 do
    local drop = {
        items = {
            {items = {'farming:wheat'},rarity=9-i},
            {items = {'farming:wheat'},rarity=18-i*2},
            {items = {'farming:seed_wheat'},rarity=9-i},
            {items = {'farming:seed_wheat'},rarity=18-i*2},
        }
    }
    minetest.register_node("farming:wheat_"..i, {
        drawtype = "plantlike",
        tiles = {"farming_wheat_"..i..".png"},
        paramtype = "light",
        walkable = false,
        buildable_to = true,
        plantname="wheat",
        light_req = 9,
        state_count = 8,
        is_ground_content = true,
        drop = drop,
        selection_box = {
            type = "fixed",
            fixed = {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
        },
        groups = {dig_immediate=3,flammable=2,plant=1,wheat=i,not_in_creative_inventory=1,attached_node=1,plantname=1},
        sounds = default.node_sound_leaves_defaults(),
    })
end

minetest.register_abm({
    nodenames = {"group:wheat"},
    neighbors = {"group:soil"},
    interval = 82,
    chance = 3.5,
    action = function(pos,node)
    try_to_grow(pos,node)
    end,
})



--
-- Cotton
--
minetest.register_craftitem("farming:seed_cotton", {
    description = "Cotton Seed",
    inventory_image = "farming_cotton_seed.png",

    on_place = function(itemstack, placer, pointed_thing)
        return place_seed(itemstack, placer, pointed_thing, "farming:cotton_1")
    end,
})

minetest.register_craftitem("farming:string", {
    description = "String",
    inventory_image = "farming_string.png",

})

minetest.register_craft({
    output = "wool:white",
    recipe = {
        {"farming:string", "farming:string"},
        {"farming:string", "farming:string"},
    }
})

for i=1,8 do
    local drop = {
        items = {
           -- {items = {'farming:string'},rarity=9-i},
            {items = {'farming:string'},rarity=18-i*2},
            {items = {'farming:string'},rarity=27-i*3},
            {items = {'farming:seed_cotton'},rarity=9-i},
            {items = {'farming:seed_cotton'},rarity=18-i*2},
            {items = {'farming:seed_cotton'},rarity=27-i*3},
        }
    }
    minetest.register_node("farming:cotton_"..i, {
        drawtype = "plantlike",
        tiles = {"farming_cotton_"..i..".png"},
        paramtype = "light",
        walkable = false,
        buildable_to = true,
        is_ground_content = true,
        drop = drop,
        selection_box = {
            type = "fixed",
            fixed = {-0.5, -0.5, -0.5, 0.5, -5/16, 0.5},
        },
        groups = {dig_immediate=3,flammable=2,plant=1,cotton=i,not_in_creative_inventory=1,attached_node=1},
        sounds = default.node_sound_leaves_defaults(),
    })
end

minetest.register_abm({
    nodenames = {"group:cotton"},
    neighbors = {"group:soil"},
    interval = 80,
    chance = 2,
    action = function(pos, node)
        -- return if already full grown
        if minetest.get_item_group(node.name, "cotton") == 8 then
            return
        end

        -- check if on wet soil
        pos.y = pos.y-1
        local n = minetest.get_node(pos)
        if minetest.get_item_group(n.name, "soil") < 3 then
            return
        end
        pos.y = pos.y+1

        -- check light
        if not minetest.get_node_light(pos) then
            return
        end
        if minetest.get_node_light(pos) < 12 then
            return
        end

        -- grow
        local height = minetest.get_item_group(node.name, "cotton") + 1
        minetest.set_node(pos, {name="farming:cotton_"..height})
    end
})


--
-- Carrot
--
minetest.register_craftitem("farming:carrot", {
    description = "Carrot",
    inventory_image = "farming_carrot.png",
    on_use = minetest.item_eat(),
    on_place = function(itemstack, placer, pointed_thing)
        return place_seed(itemstack, placer, pointed_thing, "farming:carrot_1")
    end,
})

for i=1,8 do
    local drop = {
        items = {
            {items = {'farming:carrot'},rarity=5-i},
            {items = {'farming:carrot'},rarity=10-i*2},
            {items = {'farming:carrot'},rarity=5-i},
            {items = {'farming:carrot'},rarity=10-i*2},
        }
    }
    local ii = 1
    local one,two = math.modf(i/2)
    if one>0 then ii=one end
    minetest.register_node("farming:carrot_"..i, {
        drawtype = "plantlike",
        tiles = {"farming_carrot_"..ii..".png"},
        paramtype = "light",
        walkable = false,
        buildable_to = true,
        is_ground_content = true,
        drop = drop,
        plantname = "carrot",
        light_req = 9,
        state_count = 8,
        selection_box = {
            type = "fixed",
            fixed = {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
        },
        groups = {dig_immediate=3,flammable=2,plant=1,carrot=i,not_in_creative_inventory=1,attached_node=1},
        sounds = default.node_sound_leaves_defaults(),
    })
end


minetest.register_abm({
    nodenames = {"group:carrot"},
    neighbors = {"group:soil"},
    interval = 90,
    chance = 4,
    action = function(pos,node)
    try_to_grow(pos,node)
    end,
})

minetest.register_craftitem('farming:carrot_gold', {
    description = "Gold carrot",
    inventory_image = "farming_gold_carrot.png",
    on_use = minetest.item_eat(1),
})

minetest.register_craft({
    output = 'farming:gold_carrot',
    recipe = {
        {'default:gold_nugget', 'default:gold_nugget', 'default:gold_nugget'},
        {'default:gold_nugget', 'farming:carrot', 'default:gold_nugget'},
        {'default:gold_nugget', 'default:gold_nugget', 'default:gold_nugget'},
    },
})


--
-- Potatto
--

minetest.register_craftitem("farming:potato", {
    description = "Potato",
    inventory_image = "farming_potato.png",
    on_use = minetest.item_eat(),
    on_place = function(itemstack, placer, pointed_thing)
        return place_seed(itemstack, placer, pointed_thing, "farming:potato_1")
    end,
})

for i=1,8 do
    local drop = {
        items = {
            {items = {'farming:potato'},rarity=5-i},
            {items = {'farming:potato'},rarity=10-i*2},
            {items = {'farming:potato'},rarity=5-i},
            {items = {'farming:potato'},rarity=10-i*2},
        }
    }
    local ii = 1
    local one,two = math.modf(i/2)
    if one>0 then ii=one end
    minetest.register_node("farming:potato_"..i, {
        drawtype = "plantlike",
        tiles = {"farming_potato_"..ii..".png"},
        paramtype = "light",
        walkable = false,
        buildable_to = true,
        is_ground_content = true,
        drop = drop,
        plantname = "potato",
        light_req = 9,
        state_count = 8,
        selection_box = {
            type = "fixed",
            fixed = {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
        },
        groups = {dig_immediate=3,flammable=2,plant=1,potato=i,not_in_creative_inventory=1,attached_node=1},
        sounds = default.node_sound_leaves_defaults(),
    })
end

minetest.register_abm({
    nodenames = {"group:potato"},
    neighbors = {"group:soil"},
    interval = 90,
    chance = 4,
    action = function(pos,node)
    try_to_grow(pos,node)
    end,
})

minetest.register_craftitem("farming:potato_baked", {
    description = "Baked potato",
    inventory_image = "farming_potato_baked.png",
    on_use = minetest.item_eat(),
})

minetest.register_craftitem("farming:potato_poisonous", {
    description = "Poisonous potato",
    inventory_image = "farming_potato_poisonous.png",
    on_use = minetest.item_eat(),
})

minetest.register_craft({
    type = "cooking",
    output = "farming:potato_baked",
    recipe = "farming:potato"
})

--
-- Fertilizer
--
minetest.register_craftitem("farming:fertilizer", {
    description = "Fertilizer",
    inventory_image = "heart.png",

    on_place = function(itemstack, placer, pointed_thing)
        local node = minetest.get_node(pointed_thing.under)
        local pos  = pointed_thing.under
        itemstack:take_item()
        try_to_grow_cheating(pos,node)
        return itemstack
    end,
})
--[[
minetest.handle_node_drops(pos, drops, digger)
^ drops: list of itemstrings
^ Handles drops from nodes after digging: Default action is to put them into
  digger's inventory
^ Can be overridden to get different functionality (eg. dropping items on
  ground)]]--


--
-- Craftitems
--

minetest.register_craftitem("farming:flour", {
    description = "Flour",
    inventory_image = "dye_white.png",
    on_use = minetest.item_eat(1),
})

minetest.register_craftitem("farming:dough", {
    description = "Dough",
    inventory_image = "dye_white.png",
    on_use = minetest.item_eat(1),
})

minetest.register_craftitem("farming:bread", {
    description = "Bread",
    inventory_image = "farming_bread.png",
    on_use = minetest.item_eat(1),
})

minetest.register_craft({
    output = "farming:flour",
    type = "shapeless",
    recipe = { "farming:wheat", "farming:wheat" }
})

minetest.register_craft({
    output = "farming:dough",
    type = "shapeless",
    recipe = { "farming:flour", "bucket:bucket_water" },
    replacements = {{"bucket:bucket_water", "bucket:bucket_empty"}},
})

minetest.register_craft({
    type = "cooking",
    output = "farming:bread",
    recipe = "farming:dough"
})

print('[OK] Farming (4aiman\'s version) loaded')

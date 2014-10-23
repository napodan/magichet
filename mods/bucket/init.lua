-- Minetest 0.4 mod: bucket
-- See README.txt for licensing and other information.

local LIQUID_MAX = 8  --The number of water levels when liquid_finite is enabled

minetest.register_alias("bucket", "bucket:bucket_empty")
minetest.register_alias("bucket_water", "bucket:bucket_water")
minetest.register_alias("bucket_lava", "bucket:bucket_lava")
minetest.register_alias("bucket_ignis", "bucket:bucket_ignis")
minetest.register_alias("bucket_CO2", "bucket:bucket_CO2")

minetest.register_craft({
    output = 'bucket:bucket_empty 1',
    recipe = {
        {'default:steel_ingot', '', 'default:steel_ingot'},
        {'', 'default:steel_ingot', ''},
    }
})

bucket = {}
bucket.liquids = {}

-- Register a new liquid
--   source = name of the source node
--   flowing = name of the flowing node
--   itemname = name of the new bucket item (or nil if liquid is not takeable)
--   inventory_image = texture of the new bucket item (ignored if itemname == nil)
-- This function can be called from any mod (that depends on bucket).
function bucket.register_liquid(source, flowing, itemname, inventory_image, name)
    bucket.liquids[source] = {
        source = source,
        flowing = flowing,
        itemname = itemname,
    }
    bucket.liquids[flowing] = bucket.liquids[source]

    if itemname ~= nil then
        minetest.register_craftitem(itemname, {
            description = name,
            inventory_image = inventory_image,
            stack_max = 1,
            liquids_pointable = true,
            --groups = {not_in_creative_inventory=1},
            on_place = function(itemstack, user, pointed_thing)
                -- Must be pointing to node
                if pointed_thing.type ~= "node" then
                    return
                end

                -- Call on_rightclick if the pointed node defines it
                if user and not user:get_player_control().sneak then

                local place_liquid = function(pos, node, source, flowing, fullness)
                    if math.floor(fullness/128) == 1 or (not minetest.setting_getbool("liquid_finite")) then
                        minetest.add_node(pos, {name=source, param2=fullness})
                        return
                    elseif node.name == flowing then
                        fullness = fullness + node.param2
                    elseif node.name == source then
                        fullness = LIQUID_MAX
                    end

                    if fullness >= LIQUID_MAX then
                        minetest.add_node(pos, {name=source, param2=LIQUID_MAX})
                    else
                        minetest.add_node(pos, {name=flowing, param2=fullness})
                    end
                end

                -- Check if pointing to a buildable node
                local node = minetest.get_node(pointed_thing.under)
                local fullness = tonumber(itemstack:get_metadata())
                if not fullness then fullness = LIQUID_MAX end

                if minetest.registered_nodes[node.name].buildable_to then
                    -- buildable; replace the node
                    place_liquid(pointed_thing.under, node, source, flowing, fullness)
                else
                    -- not buildable to; place the liquid above
                    -- check if the node above can be replaced
                    local node = minetest.get_node(pointed_thing.above)
                    if minetest.registered_nodes[node.name].buildable_to then
                        place_liquid(pointed_thing.above, node, source, flowing, fullness)
                    else
                        -- do not remove the bucket with the liquid
                        return
                    end
                end
                return {name="bucket:bucket_empty"}
            end
                end
        })
    end
end

minetest.register_craftitem("bucket:bucket_empty", {
    description = "Empty Bucket",
    inventory_image = "bucket.png",
    stack_max = 1,
    liquids_pointable = true,
    on_place = function(itemstack, user, pointed_thing)
        -- Must be pointing to node
        if pointed_thing.type ~= "node" then
            return
        end
        -- Check if pointing to a liquid source
        node = minetest.get_node(pointed_thing.under)
        local nname=node.name
        local water = false
        local pll = user:get_player_name()
        if nname:find("lava") and awards.players[pll].bucket then awards.players[pll].lava=1 end
        if nname:find("water") and awards.players[pll].bucket then awards.players[pll].water=1 end
        liquiddef = bucket.liquids[node.name]
        if liquiddef ~= nil and liquiddef.itemname ~= nil and (node.name == liquiddef.source or
            (node.name == liquiddef.flowing and minetest.setting_getbool("liquid_finite"))) then
            minetest.add_node(pointed_thing.under, {name="air"})
            if node.name == liquiddef.source then node.param2 = LIQUID_MAX end
        
        local nn
        if nname:find("water") then           
           nn = "bucket:bucket_water"
           -- ~5% chance to get ignis
           local rnd = math.random(1, 20)
           --print(rnd)
           if rnd == 1 then
              nn = "bucket:bucket_ignis"              
           end
           return ItemStack({name = nn, metadata = tostring(node.param2)})
        else
            return ItemStack({name = liquiddef.itemname, metadata = tostring(node.param2)})
        end
        end
    end,
})

-- CO(2) definition
-- flowing CO2 (Remember, that O(2) is lighter than CO(2) ;))
minetest.register_node("bucket:CO2_flowing", {
    description = "Flowing CO(2)",
    inventory_image = minetest.inventorycube("bucket_CO2.png"),
    tiles =  {
        {
            image="bucket_CO2_flowing_animated.png",
            backface_culling=false,
            animation={type="vertical_frames", aspect_w=32, aspect_h=32, length=0.8}
        }
    },
   -- alpha = 60,
    drawtype = "nodebox",
   -- drawtype = "flowingliquid",
    sunlight_propagates = true,
    paramtype = "light",
    use_texture_alpha = true,
    buildable_to = true,
    walkable = false,
    diggable = false,
    pointable = false,
    node_box = {
        type = "fixed",
        fixed = {
            {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5}
        },
    },
    selection_box = {
        type = "fixed",
        fixed = {
            {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5}
        },
    },
    drop = "",
    liquidtype = "flowing",
    liquid_alternative_flowing = "bucket:CO2_flowing",
    liquid_alternative_source = "bucket:CO2_source",
    liquid_viscosity = 2,
    post_effect_color = {a=54, r=200, g=200, b=200},
    groups = {liquid=4, puts_out_fire=2, not_in_creative_inventory=1},
})


minetest.register_node("bucket:CO2_source", {
    description = "CO2 Source",
    inventory_image = minetest.inventorycube("bucket_CO2.png"),
    tiles = {
        {name="bucket_CO2_source_animated.png", animation={type="vertical_frames", aspect_w=32, aspect_h=32, length=2.0}}
    },
    special_tiles = {
        -- New-style water source material (mostly unused)
        {
            name="bucket_CO2_source_animated.png",
            animation={type="vertical_frames", aspect_w=32, aspect_h=32, length=2.0},
            backface_culling = false,
        }
    },
   -- alpha = 60,
    drawtype = "nodebox",
    --drawtype = "liquid",
    sunlight_propagates = true,
    paramtype = "light",
    use_texture_alpha = true,
    buildable_to = true,
    walkable = false,
    diggable = false,
    pointable = false,
    node_box = {
        type = "fixed",
        fixed = {
            {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5}
        },
    },
    selection_box = {
        type = "fixed",
        fixed = {
            {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5}
        },
    },
    drop = "",
    drowning = 3,
    liquidtype = "source",
    liquid_alternative_flowing = "bucket:CO2_flowing",
    liquid_alternative_source = "bucket:CO2_source",
    liquid_viscosity = 2,
    post_effect_color = {a=54, r=200, g=200, b=200},
    groups = {liquid=4, puts_out_fire=2},    
})

-- Ignis first, 'cause water will override all but bucket.
-- Yeah, I'm too lazy to define this separately
bucket.register_liquid(
    "default:water_source",
    "default:water_flowing",
    "bucket:bucket_ignis",
    "bucket_ignis.png",
    "Bucket with ignis water"
)

bucket.register_liquid(
    "default:water_source",
    "default:water_flowing",
    "bucket:bucket_water",
    "bucket_water.png",
    "Bucket with water"
)

bucket.register_liquid(
    "default:lava_source",
    "default:lava_flowing",
    "bucket:bucket_lava",
    "bucket_lava.png",
    "Bucket with lava"
)

-- CO(2) Bucket )))
bucket.register_liquid(
    "bucket:CO2_source",
    "bucket:CO2_flowing",
    "bucket:bucket_CO2",
    "bucket.png",
    "Bucket with CO(2)"
)
minetest.register_craft({
    type = "fuel",
    recipe = "bucket:bucket_lava",
    burntime = 60,
    replacements = {{"bucket:bucket_lava", "bucket:bucket_empty"}},
})

-- ignis make water ignite and produce CO(2)
minetest.register_craft({
    type = "fuel",
    recipe = "bucket:bucket_ignis",
    burntime = 1,
    replacements = {{"bucket:bucket_ignis", "bucket:bucket_CO2"}},
})

print('[OK] Bucket (4aiman\'s version) loaded')

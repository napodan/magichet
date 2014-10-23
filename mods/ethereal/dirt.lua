
--= Define Dirt Types

-- Airlike
minetest.register_node("ethereal:airlike", {
    description = "Airlike node #1",
    tiles = {"ethereal_empty_1px.png"},
    groups = {},
    drop = '',
    drawtype = "plantlike",
    use_texture_alpha = true,
    paramtype = "light",
    buildable_to=true,
    walkable = false,
    pointable = false,
    sounds = default.node_sound_dirt_defaults()
})

-- Dry Dirt
minetest.register_node("ethereal:dry_dirt", {
    description = "Dried Dirt",
    tiles = {"ethereal_dry_dirt.png"},
    is_ground_content = true,
    groups = {crumbly=default.dig.drythings},
    drop = 'ethereal:dry_dirt',
    sounds = default.node_sound_dirt_defaults()
})

minetest.register_craft({
    type = "cooking",
    output = "ethereal:dry_dirt",
    recipe = "default:dirt",
    cooktime = 3,
})

-- Jungle Dirt
minetest.register_node("ethereal:jungle_dirt", {
    description = "Jungle Dirt",
    tiles = {"ethereal_grass_jungle_top.png",
    "default_dirt.png","default_dirt.png^ethereal_grass_jungle_side.png"},
    is_ground_content = true,
    groups = {crumbly=default.dig.dirt, soil=1,ethereal_grass=1},
    drop = 'default:dirt',
    sounds = default.node_sound_dirt_defaults()
})

-- Grove Dirt
minetest.register_node("ethereal:grove_dirt", {
    description = "Grove Dirt",
    tiles = {"ethereal_grass_grove_top.png",
    "default_dirt.png","default_dirt.png^ethereal_grass_grove_side.png"},
    is_ground_content = true,
    groups = {crumbly=default.dig.dirt, soil=1,ethereal_grass=1},
    drop = 'default:dirt',
    sounds = default.node_sound_dirt_defaults()
})

-- Prairie Dirt
minetest.register_node("ethereal:prairie_dirt", {
    description = "Prairie Dirt",
    tiles = {"ethereal_grass_prairie_top.png",
    "default_dirt.png","default_dirt.png^ethereal_grass_prairie_side.png"},
    is_ground_content = true,
    groups = {crumbly=default.dig.dirt, soil=1,ethereal_grass=1},
    drop = 'default:dirt',
    sounds = default.node_sound_dirt_defaults()
})

-- Cold Dirt
minetest.register_node("ethereal:cold_dirt", {
    description = "Cold Dirt",
    tiles = {"ethereal_grass_snowy_top.png",
    "default_dirt.png","default_dirt.png^ethereal_grass_snowy_side.png"},
    is_ground_content = true,
    groups = {crumbly=default.dig.dirt_with_grass, soil=1,ethereal_grass=1},
    drop = 'default:dirt',
    sounds = default.node_sound_dirt_defaults()
})

-- Blue Crystal Dirt
minetest.register_node("ethereal:crystal_topped_dirt", {
    description = "Crystal Dirt",
    tiles = {"ethereal_frost_grass.png",
    "default_dirt.png","default_dirt.png^ethereal_frost_dirt_with_grass.png"},
    is_ground_content = true,
    groups = {crumbly=default.dig.drythings, soil=1,ethereal_grass=1},
    drop = 'default:dirt',
    sounds = default.node_sound_dirt_defaults()
})

-- Purple Mushroom Dirt
minetest.register_node("ethereal:mushroom_dirt", {
    description = "Mushroom Dirt",
    tiles = {"mushroom_dirt_top.png^mushroom_dirt_top.png",
    "default_dirt.png","default_dirt.png^mushroom_dirt_with_grass.png"},
    is_ground_content = true,
    groups = {crumbly=default.dig.dirt_with_grass, soil=1,ethereal_grass=1},
    drop = 'default:dirt',
    sounds = default.node_sound_dirt_defaults()
})

-- Red Fiery Dirt
minetest.register_node("ethereal:fiery_dirt_top", {
    description = "Fiery Dirt",
    tiles = {"ethereal_fiery_grass.png", "ethereal_dry_dirt.png",
    "ethereal_dry_dirt.png^ethereal_fiery_dirt_with_grass.png"},
    is_ground_content = true,
    groups = {crumbly=default.dig.gravel, soil=1,ethereal_grass=1},
    drop = 'ethereal:dry_dirt',
    sounds = default.node_sound_dirt_defaults()
})

-- Gr[a|e]y Dirt
minetest.register_node("ethereal:gray_dirt_top", {
    description = "Gray Dirt",
    tiles = {"ethereal_gray_grass.png", "default_dirt.png",
    "default_dirt.png^ethereal_gray_dirt_with_grass.png"},
    is_ground_content = true,
    groups = {crumbly=default.dig.sand, soil=1,ethereal_grass=1},
    drop = 'default:dirt',
    sounds = default.node_sound_dirt_defaults()
})

-- Green Dirt
minetest.register_node("ethereal:green_dirt_top", {
    description = "Green Dirt",
    tiles = {"default_grass.png", "default_dirt.png", "default_dirt.png^default_grass_side.png"},
    is_ground_content = true,
    groups = {crumbly=default.dig.dirt, soil=1,ethereal_grass=1},
    drop = 'default:dirt',
    sounds = default.node_sound_dirt_defaults()
})

--= Check surrounding Coloured Grass and Change Dirt to Same Colour

minetest.register_abm({
    nodenames = {"default:dirt_with_grass"},
    interval = 2,
    chance = 1,
    action = function(pos, node)
        local count_grasses = {};
        local curr_max  = 0;
        local curr_type = "ethereal:green_dirt_top"; -- Fallback Colour

        local positions = minetest.find_nodes_in_area( {x=(pos.x-2), y=(pos.y-2), z=(pos.z-2)},
                                   {x=(pos.x+2), y=(pos.y+2), z=(pos.z+2)},
                               "group:ethereal_grass" );
        for _,p in ipairs(positions) do
            -- count the new grass node
            local n = minetest.get_node( p );
            if( n and n.name ) then
                if( not( count_grasses[ n.name ] )) then
                    count_grasses[ n.name ] = 1;
                else
                    count_grasses[ n.name ] = count_grasses[ n.name ] + 1;
                end
                -- we found a grass type of which there's more than the current max
                if( count_grasses[ n.name ] > curr_max ) then
                    curr_max  = count_grasses[ n.name ];
                    curr_type = n.name;
                end
            end
        end
        minetest.set_node(pos, {name = curr_type })
        end
})

--= If Grass Devoid of Light, Change to Dirt

minetest.register_abm({
    nodenames = {"group:ethereal_grass"},
    interval = 2,
    chance = 20,
    action = function(pos, node)
        local above = {x=pos.x, y=pos.y+1, z=pos.z}
        local name = minetest.get_node(above).name
        local nodedef = minetest.registered_nodes[name]
        if name ~= "ignore" and nodedef
                and not ((nodedef.sunlight_propagates or nodedef.paramtype == "light")
                and nodedef.liquidtype == "none") then
            minetest.set_node(pos, {name = "default:dirt"})
        end
    end
})

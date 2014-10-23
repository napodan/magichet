-- mods/default/mapgen.lua

--
-- Aliases for map generator outputs
--

minetest.register_alias("mapgen_stone", "default:stone")
minetest.register_alias("mapgen_tree", "default:tree")
minetest.register_alias("mapgen_leaves", "default:leaves")
minetest.register_alias("mapgen_jungletree", "default:jungletree")
minetest.register_alias("mapgen_jungleleaves", "default:jungleleaves")
minetest.register_alias("mapgen_apple", "default:apple")
minetest.register_alias("mapgen_water_source", "default:water_source")
minetest.register_alias("mapgen_dirt", "default:dirt")
minetest.register_alias("mapgen_sand", "default:sand")
minetest.register_alias("mapgen_gravel", "default:gravel")
minetest.register_alias("mapgen_clay", "default:clay")
minetest.register_alias("mapgen_lava_source", "default:lava_source")
minetest.register_alias("mapgen_cobble", "default:cobble")
minetest.register_alias("mapgen_mossycobble", "default:mossycobble")
minetest.register_alias("mapgen_dirt_with_grass", "default:dirt_with_grass")
minetest.register_alias("mapgen_dirt_with_snow", "default:dirt_with_snow")
minetest.register_alias("mapgen_junglegrass", "default:junglegrass")
minetest.register_alias("mapgen_stone_with_coal", "default:stone_with_coal")
minetest.register_alias("mapgen_stone_with_iron", "default:stone_with_iron")
minetest.register_alias("mapgen_mese", "default:mese")
minetest.register_alias("mapgen_desert_sand", "default:desert_sand")
minetest.register_alias("mapgen_desert_stone", "default:desert_stone")
minetest.register_alias("mapgen_stair_cobble", "stairs:stair_cobble")
minetest.register_alias("mapgen_ice", "default:ice")

--
-- Ore generation
--

-- sheets of ore above the ground
minetest.register_ore({
    ore_type       = "scatter",
    ore            = "default:stone_with_coal",
    wherein        = "default:stone",
    clust_scarcity = 38*38*38,
    clust_num_ores = 30,
    clust_size     = 16,
    height_min     = 1,
    height_max     = 512,
})

-- from -1000 to 0 coal is rather rare
minetest.register_ore({
    ore_type       = "scatter",
    ore            = "default:stone_with_coal",
    wherein        = "default:stone",
    clust_scarcity = 24*24*24,
    clust_num_ores = 10,
    clust_size     = 10,
    height_min     = -1000,
    height_max     = 0,
})

-- from -2000 to -1001 coal is 2x easier to find(same amount, 2x less V)
minetest.register_ore({
    ore_type       = "scatter",
    ore            = "default:stone_with_coal",
    wherein        = "default:stone",
    clust_scarcity = 20*20*20,
    clust_num_ores = 10,
    clust_size     = 8,
    height_min     = -2000,
    height_max     = -1001,
})

-- from -3000 to -2001 coal is even more easier to find (x6)
minetest.register_ore({
    ore_type       = "scatter",
    ore            = "default:stone_with_coal",
    wherein        = "default:stone",
    clust_scarcity = 10*10*10,
    clust_num_ores = 10,
    clust_size     = 5,
    height_min     = -3000,
    height_max     = -2001,
})

-- from -4000 to -3001 there are sheets of coal (x18)
minetest.register_ore({
    ore_type       = "scatter",
    ore            = "default:stone_with_coal",
    wherein        = "default:stone",
    clust_scarcity = 5*8*5,
    clust_num_ores = 12,
    clust_size     = 4,
    height_min     = -4000,
    height_max     = -3001,
})
-- there's no coal deeper than -4000... Now that's strange...

-- some ores up there in the floatlands (very rare)
minetest.register_ore({
    ore_type       = "scatter",
    ore            = "default:stone_with_coal",
    wherein        = "default:stone",
    clust_scarcity = 24*24*24,
    clust_num_ores = 24,
    clust_size     = 20,
    height_min     = 0,
    height_max     = 1200,
})

-- now iron. Some of it can be found earlier than coal
minetest.register_ore({
    ore_type       = "scatter",
    ore            = "default:iron",
    wherein        = "default:stone",
    clust_scarcity = 20*20*20,
    clust_num_ores = 3,
    clust_size     = 3,
    height_min     = -15,
    height_max     = 2,
})

-- but I want it to be available below ~-20 (~50 nodes to dig)
minetest.register_ore({
    ore_type       = "scatter",
    ore            = "default:iron",
    wherein        = "default:stone",
    clust_scarcity = 19*19*19,
    clust_num_ores = 5,
    clust_size     = 3,
    height_min     = -33,
    height_max     = -16,
})

-- wide spread below -34 till unbreakable nodes. LOVE this :)
minetest.register_ore({
    ore_type       = "scatter",
    ore            = "default:iron",
    wherein        = "default:stone",
    clust_scarcity = 12*12*12,
    clust_num_ores = 10,
    clust_size     = 20,
    height_min     = -63,
    height_max     = -34,
})

-- more iron below -64
minetest.register_ore({
    ore_type       = "scatter",
    ore            = "default:iron",
    wherein        = "default:stone",
    clust_scarcity = 24*24*24,
    clust_num_ores = 27,
    clust_size     = 7,
    height_min     = -5005,
    height_max     = -65,
})


-- regular mese is to be found at extra nodes - very few at 1st
minetest.register_ore({
    ore_type       = "scatter",
    ore            = "default:stone_with_mese",
    wherein        = "default:stone",
    clust_scarcity = 28*28*28,
    clust_num_ores = 26,
    clust_size     = 18,
    height_min     = -200,
    height_max     = -65,
})

-- then a bit more
minetest.register_ore({
    ore_type       = "scatter",
    ore            = "default:stone_with_mese",
    wherein        = "default:stone",
    clust_scarcity = 18*18*18,
    clust_num_ores = 3,
    clust_size     = 15,
    height_min     = -300,
    height_max     = -201,
})

-- then even more... a bit?..
minetest.register_ore({
    ore_type       = "scatter",
    ore            = "default:stone_with_mese",
    wherein        = "default:stone",
    clust_scarcity = 18*18*18,
    clust_num_ores = 4,
    clust_size     = 10,
    height_min     = -301,
    height_max     = -1000,
})

-- then even more... a bit?..
minetest.register_ore({
    ore_type       = "scatter",
    ore            = "default:stone_with_mese",
    wherein        = "default:stone",
    clust_scarcity = 18*18*18,
    clust_num_ores = 6,
    clust_size     = 10,
    height_min     = -1001,
    height_max     = -2000,
})
-- and even more deeper, at aliens
minetest.register_ore({
    ore_type       = "scatter",
    ore            = "default:stone_with_mese",
    wherein        = "default:stone",
    clust_scarcity = 11*11*11,
    clust_num_ores = 80,
    clust_size     = 20,
    height_min     = -16000,
    height_max     = -8001,
})

-- mese block should be with aliens, so deep below
minetest.register_ore({
    ore_type       = "scatter",
    ore            = "default:mese",
    wherein        = "default:stone",
    clust_scarcity = 36*36*36,
    clust_num_ores = 20,
    clust_size     = 15,
    height_min     = -33000,
    height_max     = -8500,
})

-- gold above the ground level
minetest.register_ore({
    ore_type       = "scatter",
    ore            = "default:gold",
    wherein        = "default:stone",
    clust_scarcity = 35*35*35,
    clust_num_ores = 15,
    clust_size     = 20,
    height_min     = -60,
    height_max     = -30,
})

-- gold shouldn't be scattered, but "veined" deeper
minetest.register_ore({
    ore_type       = "scatter",
    ore            = "default:gold",
    wherein        = "default:stone",
    clust_scarcity = 15*15*15,
    clust_num_ores = 3,
    clust_size     = 2,
    height_min     = -255,
    height_max     = -65,
})

-- gold isn't too rare. Also, some circuits can be crafted from it
minetest.register_ore({
    ore_type       = "scatter",
    ore            = "default:gold",
    wherein        = "default:stone",
    clust_scarcity = 13*13*13,
    clust_num_ores = 5,
    clust_size     = 3,
    height_min     = -5000,
    height_max     = -256,
})

-- some diamonds deep below the 1st level
minetest.register_ore({
    ore_type       = "scatter",
    ore            = "default:stone_with_diamond",
    wherein        = "default:stone",
    clust_scarcity = 57*57*57,
    clust_num_ores = 2,
    clust_size     = 20,
    height_min     = -48,
    height_max     = -60,
})

-- diamonds still in extra ores, 'cause "smth strange" is for machinery
minetest.register_ore({
    ore_type       = "scatter",
    ore            = "default:stone_with_diamond",
    wherein        = "default:stone",
    clust_scarcity = 57*57*57,
    clust_num_ores = 4,
    clust_size     = 4,
    height_min     = -1000,
    height_max     = -800,
})

-- from -4000 to -3001 diaminds inside the sheets of coal (1/125)
minetest.register_ore({
    ore_type       = "scatter",
    ore            = "default:stone_with_diamond",
    wherein        = "default:stone_with_coal",
    clust_scarcity = 2*5*5,
    clust_num_ores = 1,
    clust_size     = 5,
    height_min     = -4000,
    height_max     = -3001,
})

-- from -4000 to -3001 diamonds inside the sheets of coal (1/125)
minetest.register_ore({
    ore_type       = "scatter",
    ore            = "default:stone_with_diamond",
    wherein        = "default:lava_source",
    clust_scarcity = 14*15*15,
    clust_num_ores = 1,
    clust_size     = 5,
    height_min     = -34000,
    height_max     = 34000,
})

minetest.register_ore({
    ore_type       = "scatter",
    ore            = "default:stone_with_diamond",
    wherein        = "default:stone",
    clust_scarcity = 45*45*45,
    clust_num_ores = 6,
    clust_size     = 20,
    height_min     = -5000,
    height_max     = -4001,
})


minetest.register_ore({
    ore_type       = "scatter",
    ore            = "default:stone_with_copper",
    wherein        = "default:stone",
    clust_scarcity = 12*12*12,
    clust_num_ores = 16,
    clust_size     = 20,
    height_min     = -630,
    height_max     = -160,
})

minetest.register_ore({
    ore_type       = "scatter",
    ore            = "default:stone_with_copper",
    wherein        = "default:stone",
    clust_scarcity = 9*9*9,
    clust_num_ores = 5,
    clust_size     = 7,
    height_min     = -5000,
    height_max     = -631,
    flags          = "absheight",
})

--if minetest.setting_get("mg_name") == "indev" then
    -- Floatlands and high mountains springs
    minetest.register_ore({
        ore_type       = "scatter",
        ore            = "default:water_source",
        ore_param2     = 128,
        wherein        = "default:stone",
        clust_scarcity = 40*40*40,
        clust_num_ores = 8,
        clust_size     = 3,
        height_min     = 100,
        height_max     = 31000,
    })

    minetest.register_ore({
        ore_type       = "scatter",
        ore            = "default:lava_source",
        ore_param2     = 128,
        wherein        = "default:stone",
        clust_scarcity = 50*50*50,
        clust_num_ores = 5,
        clust_size     = 2,
        height_min     = 10000,
        height_max     = 31000,
    })

    minetest.register_ore({
        ore_type       = "scatter",
        ore            = "default:sand",
        wherein        = "default:gravel",
        clust_scarcity = 20*20*20,
        clust_num_ores = 5*5*3,
        clust_size     = 5,
        height_min     = 500,
        height_max     = 31000,
    })

    minetest.register_ore({
        ore_type       = "scatter",
        ore            = "default:gravel",
        wherein        = "default:stone",
        clust_scarcity = 20*20*20,
        clust_num_ores = 5*5*3,
        clust_size     = 5,
        height_min     = 500,
        height_max     = 31000,
    })

    -- Underground springs
    minetest.register_ore({
        ore_type       = "scatter",
        ore            = "default:water_source",
        ore_param2     = 128,
        wherein        = "default:stone",
        clust_scarcity = 25*25*25,
        clust_num_ores = 8,
        clust_size     = 3,
        height_min     = -10000,
        height_max     = -10,
    })

    minetest.register_ore({
        ore_type       = "scatter",
        ore            = "default:lava_source",
        ore_param2     = 128,
        wherein        = "default:stone",
        clust_scarcity = 35*35*35,
        clust_num_ores = 5,
        clust_size     = 2,
        height_min     = -31000,
        height_max     = -300,
    })
--end

minetest.register_ore({
    ore_type       = "scatter",
    ore            = "default:clay",
    wherein        = "default:sand",
    clust_scarcity = 15*15*15,
    clust_num_ores = 64,
    clust_size     = 5,
    height_max     = 0,
    height_min     = -20,
})


function default.make_papyrus(pos, size)
    for y=0,size-1 do
        local p = {x=pos.x, y=pos.y+y, z=pos.z}
        local nn = minetest.get_node(p).name
        if minetest.registered_nodes[nn] and
            minetest.registered_nodes[nn].buildable_to then
            minetest.set_node(p, {name="default:papyrus"})
        else
            return
        end
    end
end

function default.make_cactus(pos, size)
    for y=0,size-1 do
        local p = {x=pos.x, y=pos.y+y, z=pos.z}
        local nn = minetest.get_node(p).name
        if minetest.registered_nodes[nn] and
            minetest.registered_nodes[nn].buildable_to then
            minetest.set_node(p, {name="default:cactus"})
        else
            return
        end
    end
end

-- facedir: 0/1/2/3 (head node facedir value)
-- length: length of rainbow tail
function default.make_nyancat(pos, facedir, length)
    local tailvec = {x=0, y=0, z=0}
    if facedir == 0 then
        tailvec.z = 1
    elseif facedir == 1 then
        tailvec.x = 1
    elseif facedir == 2 then
        tailvec.z = -1
    elseif facedir == 3 then
        tailvec.x = -1
    else
        --print("default.make_nyancat(): Invalid facedir: "+dump(facedir))
        facedir = 0
        tailvec.z = 1
    end
    local p = {x=pos.x, y=pos.y, z=pos.z}
    minetest.set_node(p, {name="default:nyancat", param2=facedir})
    for i=1,length do
        p.x = p.x + tailvec.x
        p.z = p.z + tailvec.z
        minetest.set_node(p, {name="default:nyancat_rainbow", param2=facedir})
    end
end

function generate_nyancats(seed, minp, maxp)
    local height_min = -31000
    local height_max = -32
    if maxp.y < height_min or minp.y > height_max then
        return
    end
    local y_min = math.max(minp.y, height_min)
    local y_max = math.min(maxp.y, height_max)
    local volume = (maxp.x-minp.x+1)*(y_max-y_min+1)*(maxp.z-minp.z+1)
    local pr = PseudoRandom(seed + 9324342)
    local max_num_nyancats = math.floor(volume / (16*16*16))
    for i=1,max_num_nyancats do
        if pr:next(0, 1000) == 0 then
            local x0 = pr:next(minp.x, maxp.x)
            local y0 = pr:next(minp.y, maxp.y)
            local z0 = pr:next(minp.z, maxp.z)
            local p0 = {x=x0, y=y0, z=z0}
            default.make_nyancat(p0, pr:next(0,3), pr:next(3,15))
        end
    end
end

minetest.register_on_generated(function(minp, maxp, seed)
    -- Generate nyan cats
   -- generate_nyancats(seed, minp, maxp)
end)


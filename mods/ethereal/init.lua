--[[

    Minetest Ethereal Mod 0.9g

    Created by ChinChow

    Updated by TenPlus1, Sokomine

    Changed by 4aiman to fit Magichet game

]]
------------------------------------------------------------------------
function place_seed(itemstack, placer, pointed_thing, plantname)
  if placer and not placer:get_player_control().sneak then
        local n = minetest.get_node(pointed_thing.under)
        local nn = n.name
        if minetest.registered_nodes[nn] and minetest.registered_nodes[nn].on_rightclick then
          return minetest.registered_nodes[nn].on_rightclick(pointed_thing.under, n, placer, itemstack) or itemstack
        end
  end
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

minetest.add_node(pt.above, {name=plantname})
    itemstack:take_item()
    return itemstack
end
------------------------------------------------------------------------

dofile(minetest.get_modpath("ethereal").."/mapgen_v7.lua")

dofile(minetest.get_modpath("ethereal").."/plantlife.lua")
dofile(minetest.get_modpath("ethereal").."/mushroom.lua")
dofile(minetest.get_modpath("ethereal").."/onion.lua")
dofile(minetest.get_modpath("ethereal").."/crystal.lua")
dofile(minetest.get_modpath("ethereal").."/papyrus.lua")
dofile(minetest.get_modpath("ethereal").."/flowers.lua")
dofile(minetest.get_modpath("ethereal").."/water.lua")
dofile(minetest.get_modpath("ethereal").."/dirt.lua")
dofile(minetest.get_modpath("ethereal").."/leaves.lua")
dofile(minetest.get_modpath("ethereal").."/wood.lua")
dofile(minetest.get_modpath("ethereal").."/sapling.lua")
dofile(minetest.get_modpath("ethereal").."/bamboo.lua")
dofile(minetest.get_modpath("ethereal").."/strawberry.lua")

dofile(minetest.get_modpath("ethereal").."/fishing.lua")


if minetest.get_modpath("bakedclay") ~= nil then
    dofile(minetest.get_modpath("ethereal").."/mesa.lua")
end






-- added by 4aiman
dofile(minetest.get_modpath("ethereal").."/farming.lua")

print('[OK] Ethereal (4aiman\'s version) loaded')

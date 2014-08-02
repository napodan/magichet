-- Copyright 2012 Andrew Engelbrecht.
-- This file is licensed under the WTFPL.

-- it is included automatically by init.lua

----------------------------------

-- function definitions:
----------------------------------

-- just an alias for math.floor()
local function round(num)
    return math.floor(num)
end

-- randomly returns whether a player is lucky, based on a player's level.
-- this is used for determining whether that player has earned a drop.
-- if level_max is set to the default of 32, then:
-- at level 0, the probability is about 1/min_scarcity/136.
-- at level_max or above, it's about 1/min_scarcity.
function xp_playerislucky(level, min_scarcity)
    local prob, randn

    if level > xp_max_level then
        level = xp_max_level
    end

    prob = (level + 3)^2 / (xp_max_level + 3)^2 / min_scarcity
    randn = xp_prand:next(0, 32767) / 32767

    if randn < prob then
        return true
    else
        return false
    end
end

-- gives a mese block to player named 'name'.
-- if thier inventory is full, then it falls on the ground.
function xp_givedrop(name, object)
    local player, pos

    player = minetest.env:get_player_by_name(name)
    inv = player:get_inventory()

    if inv:room_for_item('main', object) then
        inv:add_item('main', object)
        minetest.log("action", "xp mod: "..name.." got a drop of "..object..".")
    else
        pos = player:getpos()
        pos.y = pos.y + 1.5
        minetest.spawn_item(pos, object)
        minetest.log("action", "xp mod: "..name.." earned a drop of "..object..", but their inventory was full, so it fell near ("..round(pos.x)..", "..round(pos.y)..", "..round(pos.z)..").")
    end
end

----------------------------------

-- callback registration:
----------------------------------

-- the player gets experium somewhat randomly, based on level.
minetest.register_on_dignode(function(pos, node, player)
    local name

    if player == nil then
        return
    end

    name = player:get_player_name()
    if xp_playerislucky(xp_xplevels[name].digging.level, 300) then
        xp_givedrop(name, 'xp:experium')
    end
end)

-- the player gets experium somewhat randomly, based on level.
minetest.register_on_placenode(function(pos, newnode, player, oldnode)
    local name

    if player == nil then
        return
    end

    name = player:get_player_name()
    if xp_playerislucky(xp_xplevels[name].building.level, 300) then
        xp_givedrop(name, 'xp:experium')
    end
end)

-- if using the experium pick, the player gets double drops, when the drop
-- is different than the node it came from, and if it isn't a common drop.
minetest.register_on_dignode(function(pos, node, player)
    local name, tool, drops, i, drop, drop_name

    if player == nil then
        return
    end

    tool = player:get_wielded_item():get_name()
    if tool == "xp:pick_experium" then
        name = player:get_player_name()
        drops = minetest.get_node_drops(node.name)

        for i,drop_name in ipairs(drops) do
            if drop_name ~= node.name and drop_name ~= "default:cobble" and drop_name ~= "default:dirt" then

                -- give a duplicate drop from the dug node
                inv = player:get_inventory()
                if inv:room_for_item('main', object) then
                    inv:add_item('main', drop_name)
                    minetest.log("action", "xp mod: "..name.." got an extra drop of "..drop_name.." using their experium pick.")
                end

            end
        end
    end
end)


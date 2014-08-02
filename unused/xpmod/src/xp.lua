-- Copyright 2012 Andrew Engelbrecht.
-- This file is licensed under the WTFPL.

-- it is included automatically by init.lua

----------------------------------

-- function definitions:
----------------------------------

-- returns true if player has ever logged into the server
-- it's different than minetest.is_player() since it accepts the name as a string,
-- and because you don't need to run a function that returns a player obj only for *online* players.
function xp_is_player(name)
    local file

    if xp_playert[name] == nil then
        file = io.open(minetest.get_worldpath().."/players/"..name, "r")
        if file ~= nil then
            xp_playert[name] = true
            io.close(file)
        else
            xp_playert[name] = false
        end
    end

    return xp_playert[name]
end

-- returns the number of xp required to gain the next level.
-- pass it the player's current level.
function xp_lastpoint(level)
    local i

    if xp_lptable == nil then
        xp_lptable = {}
        for i = 0,xp_max_level - 1 do
            xp_lptable[i] = (i + 1)^2 * 10
        end
    end
    return xp_lptable[level]
end

-- initializes a player's experience points and level for a given skill
function xp_initpxp(name, skill)
    if xp_xplevels[name] == nil then
        xp_xplevels[name] = {}
    end
    if xp_xplevels[name][skill] == nil then
        xp_xplevels[name][skill] = {xp = 0, level = 0}
    end
end

-- returns true if the skill is known by this mod.
function xp_is_valid_skill(skill)
    local i, v

    for i,v in ipairs(xp_valid_skills) do
        if v == skill then
            return true
        end
    end

    return false
end

-- adds skill to the list of valid skills.
function xp_register_skill(skill)
    if type(skill) == "string" then
        table.insert(xp_valid_skills, skill)
        minetest.log("action", "xp mod: skill has been registered: "..skill)
    else
        minetest.log("error", "xp mod: someone tried to register a malformed skill.")
        minetest.log("error", "xp mod: invalid skill: "..skill)
        os.exit()
    end
end

-- gives npoints additional xp points for the player in the specified skillset
function xp_gainxp(name, skill, npoints)
    local stat, appnd, gainedlevel

    if npoints < 0 then
        return "negative"
    end

    if xp_is_player(name) == false then
        return "non-player"
    end

    if xp_is_valid_skill(skill) == false then
        return "invalid-skill"
    end

    xp_initpxp(name, skill)
    stat = xp_xplevels[name][skill]

    if stat.level >= xp_max_level then
        return "level-max"
    end

    -- the file needs to be updated in the future:
    xp_changed = true

    gainedlevel = false
    while npoints > 0 do

        if stat.xp + npoints < xp_lastpoint(stat.level) then
            stat.xp = stat.xp + npoints
            if gainedlevel == true then
                break
            else
                return "gained-xp"
            end
        else
            npoints = npoints - (xp_lastpoint(stat.level) - stat.xp)

            stat.level = stat.level + 1
            stat.xp = 0

            if stat.level >= xp_max_level then
                appnd = " (max)"
                break
            else
                appnd = ""
            end

            gainedlevel = true
        end
    end
    minetest.chat_send_player(name, "Welcome to level "..stat.level.." in "..skill.."!"..appnd)
    minetest.log("action", "xp mod: "..name.." gained level "..stat.level.." in "..skill..appnd..".")

    return "gained-level"
end

-- prints the level and xp for a player in the specified skillset.
-- if no skillset is selected, then stats for every skillset are printed.
-- output goes to the player's chat console.
function xp_printxp(name, skill)
    local i,v,stat,appnd

    if xp_xplevels[name] == nil then
        minetest.chat_send_player(name, "You have no experience in anything.")
        return
    end

    if skill == "" then
        for i,v in pairs(xp_xplevels[name]) do
            if i ~= "" then
                xp_printxp(name, i)
            end
        end
    else
        stat = xp_xplevels[name][skill]
        if stat == nil then
            minetest.chat_send_player(name, "You don't have experience in '"..skill.."'. (check your spelling.)")
        else
            xp_initpxp(name, skill)

            if stat.level >= xp_max_level then
                appnd = ". (max)"
            else
                appnd = ", plus "..stat.xp.."/"..xp_lastpoint(stat.level).." experience points."
            end
            minetest.chat_send_player(name, "You are level "..stat.level.." in "..skill..appnd)
        end
    end
end

----------------------------------

-- callback registration:
----------------------------------

-- every time a player places an object, they get one extra xp for this skill
minetest.register_on_placenode(function(pos, newnode, placer, oldnode)

    if player == nil then
        return
    end

    local name = placer:get_player_name()
    xp_gainxp(name, "building", 1)
end)

-- every time a player digs an object, they get one extra xp for this skill
minetest.register_on_dignode(function(pos, node, player)

    if player == nil then
        return
    end

    local name = player:get_player_name()
    xp_gainxp(name, "digging", 1)
end)

-- every time a player joins the game, add their name to the list of existing players.
-- if their player file wasn't readable, this works around the issue. also, if this is a new player,
-- then they will be added to the table even if they were previously marked as non-existent.
minetest.register_on_joinplayer(function(player)
    local name = player:get_player_name()
    xp_playert[name] = true
end)


-- Copyright 2012 Andrew Engelbrecht.
-- This file is licensed under the WTFPL.

-- it is included automatically by init.lua

----------------------------------

-- priviledge registration:
----------------------------------

minetest.register_privilege("givexp", {"Can give xp to others with /givexp", give_to_singleplayer = false})

----------------------------------

-- callback registration:
----------------------------------

-- it raises the xp of a player by the specified number of points.
minetest.register_chatcommand("givexp", {
    params = "<username> <skill> <num-xp>",
    description = "Give a player experience points",
    privs = {givexp=true},
    func = function(caller, param)
        local ign, name, skill, numxp, result

        -- matches three 'words': the name, the skill and the number of xp to give
        ign,ign,name,skill,numxp = string.find(param, "^([^%s]+)%s+([^%s]+)%s+(%d+)%s*$")

        if numxp == nil then
            minetest.chat_send_player(caller, "Incorrect usage. See: /help givexp")
        else
            result = xp_gainxp(name,skill,tonumber(numxp))
            if result == "non-player" then
                minetest.chat_send_player(caller, name.." isn't a player.")
            elseif result == "invalid-skill" then
                minetest.chat_send_player(caller, skill.." isn't a valid skill.")
            elseif result == "level-max" then
                minetest.chat_send_player(caller, name.."'s "..skill.." level is already maxed-out.")
            elseif result == "gained-xp" or result == "gained-level" then
                minetest.chat_send_player(caller, name.." is now level "..xp_xplevels[name][skill].level.." plus "..xp_xplevels[name][skill].xp.." xp in "..skill..".")
                minetest.log("action", "xp mod: ("..caller.." gave "..name.." "..numxp.." xp in "..skill..".)")
            else
                minetest.chat_send_player(caller, "something unexpected happened. check the server log.")
                minetest.log("action", "xp mod: invalid return value from xp_gainxp(): "..result)
            end
        end
    end,
})

-- shows the xp for the calling player, for a given skill, or if none is listed, then all of them.
minetest.register_chatcommand("showxp", {
    params = "<skill (opt)>",
    description = "Show your experience points",
    privs = {},
    func = xp_printxp,
})


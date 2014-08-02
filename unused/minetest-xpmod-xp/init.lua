-- Copyright 2012 Andrew Engelbrecht.
-- This file is licensed under the WTFPL.

----------------------------------

-- Some variables you can change:
----------------------------------

-- How often (in seconds) xplevels file saves
xp_save_delta = 10
-- Max level a player can become; 0 means max level of 0.
xp_max_level = 32

----------------------------------

-- some mod variables:
----------------------------------

xp_modver = "0.1.1"
xp_ffver = 1
xp_ffversupport = {1}
xp_file_name = "xplevels"

xp_xplevels_file = minetest.get_worldpath() .. "/" .. xp_file_name
xp_xplevels = {}
xp_playert = {}
xp_valid_skills = {"digging", "building"}
-- dynamically updated to note changes since last save to file:
xp_changed = false
-- automatically populated with list of xp needed to gain next level
xp_lptable = nil
-- create a global random seed
xp_prand = PseudoRandom(os.time())

----------------------------------

-- include files:
----------------------------------

dofile(minetest.get_modpath('xp').."/src/filerw.lua")
dofile(minetest.get_modpath('xp').."/src/xp.lua")
dofile(minetest.get_modpath('xp').."/src/craft.lua")
dofile(minetest.get_modpath('xp').."/src/drops.lua")
dofile(minetest.get_modpath('xp').."/src/chatcmds.lua")

----------------------------------

-- execute at the start of the game:
----------------------------------

-- before this file is done being read, this function must be called
-- to load player xp and levels for each skill
xp_loadxp()


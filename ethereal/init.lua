--[[

    Minetest Ethereal Mod 0.9g

    Created by ChinChow

    Updated by TenPlus1, Sokomine

    Changed by 4aiman to fit Magichet game

]]

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

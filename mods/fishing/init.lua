-----------------------------------------------------------------------------------------------
local title     = "Fishing - Mossmanikin's version"
local version   = "0.2.2"
local mname     = "fishing"
-----------------------------------------------------------------------------------------------
-- original by wulfsdad (http://forum.minetest.net/viewtopic.php?id=4375)
-- this version by Mossmanikin (https://forum.minetest.net/viewtopic.php?id=6480)
-- License (code & textures):   WTFPL
-- Contains code from:      animal_clownfish, animal_fish_blue_white, fishing (original), stoneage
-- Looked at code from:     default, farming
-- Dependencies:            default
-- Supports:                animal_clownfish, animal_fish_blue_white, animal_rat, mobs
-----------------------------------------------------------------------------------------------

-- todo:    item wear                                           done
--          automatic re-baiting option                         done (but not optional)
--          different types of fish,                            done, but not finished
--          add sound                                           done
--          bobber                                              done
--          change rainworms filling inv & make 'em disappear   done

--          placable fishing rod for decoration                 done
--          make bobber move slowly while fish on hook          done
--          catch bigger fish with smaller                      done, but not finished
--          change color of bobber when fish on hook            done

-----------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- some additions made by 4aiman to make a pole be usable w/o clicking on a bobbler,
-- to make bobblers "dissapear" other bobblers only of their "owner"
-- also 1 man = 1 bobbler... or so it would seem ;)
-- Moreover, I've fixed node_drops to be compatible with enchantments.
--------------------------------------------------------------------------------
dofile(minetest.get_modpath("fishing").."/settings.txt")
dofile(minetest.get_modpath("fishing").."/bobber.lua")
dofile(minetest.get_modpath("fishing").."/bobber_shark.lua")
dofile(minetest.get_modpath("fishing").."/crafting.lua")
dofile(minetest.get_modpath("fishing").."/fishes.lua")
dofile(minetest.get_modpath("fishing").."/worm.lua")
dofile(minetest.get_modpath("fishing").."/trophies.lua")

-----------------------------------------------------------------------------------------------
-- Fishing Pole
-----------------------------------------------------------------------------------------------

local function rod_wear(itemstack, user, pointed_thing, uses)
    itemstack:add_wear(65535/(uses-1))
    return itemstack
end

pused = {}
placed_bobbler = {}

minetest.register_tool("fishing:pole", {

    description = "Fishing Pole",
    groups = {},
    inventory_image = "fishing_pole.png",
    wield_image = "fishing_pole.png^[transformFXR270",
    stack_max = 1,
    liquids_pointable = true,
    on_place = function (itemstack, user, pointed_thing)
        if placed_bobbler[player]==true then return itemstack end
        if pointed_thing and pointed_thing.under then
            local pt = pointed_thing
            local node = minetest.get_node(pt.under)
            if string.find(node.name, "default:water") then
                local player = user:get_player_name()
                pused[player]=true
                local inv = user:get_inventory()
                if inv:get_stack("main", user:get_wield_index()+1):get_name() == "fishing:bait_worm" then
                    if not minetest.setting_getbool("creative_mode") then
                        inv:remove_item("main", "fishing:bait_worm")
                    end
                    minetest.sound_play("fishing_bobber2", {
                        pos = pt.under,
                        gain = 0.5,
                    })
                    local ent = minetest.add_entity({interval = 1,x=pt.under.x, y=pt.under.y+(45/64), z=pt.under.z}, "fishing:bobber_entity")
                    ent:get_luaentity().owner=player
placed_bobbler[player] = true
                    if WEAR_OUT == true
                    and not minetest.setting_getbool("creative_mode") then
                        return rod_wear(itemstack, user, pointed_thing, 30)
                    else
                        return {name="fishing:pole", count=1, wear=0, metadata=""}
                    end
                end
                if inv:get_stack("main", user:get_wield_index()+1):get_name() == "fishing:fish_raw" then
                    if not minetest.setting_getbool("creative_mode") then
                        inv:remove_item("main", "fishing:fish_raw")
                    end
                    minetest.sound_play("fishing_bobber2", {
                        pos = pt.under,
                        gain = 0.5,
                    })
                    minetest.add_entity({interval = 1,x=pt.under.x, y=pt.under.y+(45/64), z=pt.under.z}, "fishing:bobber_entity_shark")
placed_bobbler[player] = true
                    if WEAR_OUT == true
                    and not minetest.setting_getbool("creative_mode") then
                        return rod_wear(itemstack, user, pointed_thing, 30)
                    else
                        return {name="fishing:pole", count=1, wear=0, metadata=""}
                    end
                end
            end
        end
        return nil
    end,
    on_use = function(itemstack, placer, pointed_thing)
        local pt = pointed_thing
        if not pt.under then return end
        if minetest.get_node(pt.under) and minetest.get_node(pt.under).name~="default:water_source" and minetest.get_node(pt.under).name~="default:water_flowing" then
            local wear = itemstack:get_wear()
            --print (wear)
            local direction = minetest.dir_to_facedir(placer:get_look_dir())
            --local meta1 = minetest.get_meta(pt.under)
            local meta = minetest.get_meta(pt.above)
            minetest.set_node(pt.above, {name="fishing:pole_deco", param2=direction})
            --meta1:set_int("wear", wear)
            meta:set_int("wear", wear)
            if not minetest.setting_getbool("creative_mode") then
                itemstack:take_item()
            end
        end
        return itemstack
    end,
})

if SIMPLE_DECO_FISHING_POLE == true then
minetest.register_node("fishing:pole_deco", {
    description = "Fishing Pole",
    inventory_image = "fishing_pole.png",
    wield_image = "fishing_pole.png^[transformFXR270",
    drawtype = "nodebox",
    paramtype = "light",
    paramtype2 = "facedir",
    tiles = {
        "fishing_pole_simple.png",
        "fishing_pole_simple.png",
        "fishing_pole_simple.png",
        "fishing_pole_simple.png^[transformFX",
    },
    groups = {
        snappy=3,
        flammable=2,
        not_in_creative_inventory=1,
        attached_node = 1,
    },
    node_box = {
        type = "fixed",
        fixed = {
            { 0     , -1/2   ,  0     , 0      ,  1/2   ,  1   },
        }
    },
    selection_box = {
        type = "fixed",
        fixed = {
            {-1/16  , -1/2   ,  0     , 1/16   ,  1/2   ,  1   },
        }
    },
    sounds = default.node_sound_wood_defaults(),
    on_dig = function(pos, node, digger)
        if digger:is_player() and digger:get_inventory() then
            local meta = minetest.env:get_meta(pos)
            local wear_out = meta:get_int("wear")
            digger:get_inventory():add_item("main", {name="fishing:pole", count=1, wear=wear_out, metadata=""})
        end
        minetest.remove_node(pos)
    end,
})

else
minetest.register_node("fishing:pole_deco", {
    description = "Fishing Pole",
    inventory_image = "fishing_pole.png",
    wield_image = "fishing_pole.png^[transformFXR270",
    drawtype = "nodebox",
    paramtype = "light",
    paramtype2 = "facedir",
    tiles = {
        "fishing_pole_top.png",
        "fishing_pole_bottom.png",
        "fishing_pole_deco.png", -- right
        "fishing_pole_deco.png^[transformFX", -- left
        "fishing_pole_back.png",
        "fishing_pole_front.png"
    },
    node_box = {
        type = "fixed",
--          { left  , bottom , front  ,  right ,  top   ,  back  }
        fixed = {
            {-1/32  , -1/16  , 14/16  , 1/32   ,  6/16  , 15/16},
            {-1/32  , -3/16  , 13/16  , 1/32   , -1/16  , 14/16},
            {-1/32  , -4/16  , 12/16  , 1/32   , -3/16  , 13/16},
            {-1/32  , -5/16  , 11/16  , 1/32   , -4/16  , 12/16},
            {-1/32  , -6/16  ,  9/16  , 1/32   , -5/16  , 11/16},
            {-1/32  , -5/16  ,  9/16  , 1/32   , -4/16  , 10/16},
            -- stick
            {-1/32  ,  6/16  , 12/16  , 1/32   ,  7/16  , 15/16}, -- top
            {-1/32  ,  5/16  , 11/16  , 1/32   ,  7/16  , 12/16},
            {-1/32  ,  5/16  , 10/16  , 1/32   ,  6/16  , 11/16},
            {-1/32  ,  4/16  ,  9/16  , 1/32   ,  6/16  , 10/16},
            {-1/32  ,  3/16  ,  8/16  , 1/32   ,  5/16  ,  9/16},
            {-1/32  ,  2/16  ,  7/16  , 1/32   ,  4/16  ,  8/16},
            {-1/32  ,  1/16  ,  6/16  , 1/32   ,  3/16  ,  7/16},
            {-1/32  ,  0     ,  5/16  , 1/32   ,  2/16  ,  6/16},
            {-1/32  , -2/16  ,  4/16  , 1/32   ,  1/16  ,  5/16},
            {-1/32  , -3/16  ,  3/16  , 1/32   ,  0     ,  4/16},
            {-1/32  , -5/16  ,  2/16  , 1/32   , -1/16  ,  3/16},
            {-1/32  , -7/16  ,  1/16  , 1/32   , -3/16  ,  2/16},
            {-1/32  , -1/2   ,  0     , 1/32   , -5/16  ,  1/16}, -- bottom
        }
    },
    selection_box = {
        type = "fixed",
        fixed = {
            {-1/16  , -1/2   ,  0     , 1/16   ,  1/2   ,  1   },
        }
    },
    groups = {
        snappy=3,
        flammable=2,
        not_in_creative_inventory=1,
        attached_node = 1,
    },
    sounds = default.node_sound_wood_defaults(),
    on_dig = function(pos, node, digger)
        if digger:is_player() and digger:get_inventory() then
            local meta = minetest.get_meta(pos)
            local wear_out = meta:get_int("wear")
            digger:get_inventory():add_item("main", {name="fishing:pole", count=1, wear=wear_out, metadata=""})
        end
        minetest.remove_node(pos)
    end,
})

end
-----------------------------------------------------------------------------------------------
-- GETTING WORMS
-----------------------------------------------------------------------------------------------
-- get worms from digging in dirt:
if NEW_WORM_SOURCE == false then

local dirts = {['default:dirt']=2,['ethereal:green_dirt_top']=1}

minetest.register_on_dignode(function(pos, oldnode, digger)
if not digger or not digger:get_inventory() then return end

        if not dirts[oldnode.name] then return end
        if math.random(1, 100) < WORM_CHANCE then
            local tool_in_use = digger:get_wielded_item():get_name()
            if tool_in_use == "" or tool_in_use == "default:dirt" then
            local poss = {x = pos.x+math.random(-0.5,0.5), y = pos.y+0.5, z = pos.z+math.random(-0.5,0.5)}
                if WORM_IS_MOB == true then
                    for i=1, dirts[oldnode.name] do
                        local poss = {x = pos.x+math.random(-0.5,0.5), y = pos.y+0.5, z = pos.z+math.random(-0.5,0.5)}
                        minetest.add_entity(poss, "fishing:bait_worm_entity")
                    end
                else
                    -- drop worms instead of automatically ading to the pl:inv
                    for i=1, dirts[oldnode.name] do
                        local poss = {x = pos.x+math.random(-0.5,0.5), y = pos.y+0.5, z = pos.z+math.random(-0.5,0.5)}
                        minetest.item_drop("fishing:bait_worm", digger, poss)
                    end
                end
            end
        end
    end)
end

minetest.register_globalstep(function(dtime)
   local players = minetest.get_connected_players()
   for i,player in ipairs(players) do
       local pll = player:get_player_name()
       local control = player:get_player_control()
       if not control.RMB then pused[pll]=nil end
   end
end)

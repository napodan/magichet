arrows = {
    {"throwing:arrow", "throwing:arrow_entity"},
--  {"throwing:arrow_fire", "throwing:arrow_fire_entity"},
--  {"throwing:arrow_teleport", "throwing:arrow_teleport_entity"},
--  {"throwing:arrow_dig", "throwing:arrow_dig_entity"},
--  {"throwing:arrow_build", "throwing:arrow_build_entity"}
}

local throwing_shoot_arrow = function(itemstack, player)
    for _,arrow in ipairs(arrows) do
        if player:get_inventory():get_stack("main", player:get_wield_index()+1):get_name() == arrow[1] then
            if not minetest.setting_getbool("creative_mode") then
                player:get_inventory():remove_item("main", arrow[1])
            end
            local playerpos = player:getpos()
            local obj = minetest.env:add_entity({x=playerpos.x,y=playerpos.y+1.5,z=playerpos.z}, arrow[2])
            local dir = player:get_look_dir()
            obj:setvelocity({x=dir.x*19, y=dir.y*19, z=dir.z*19})
            obj:setacceleration({x=dir.x*-3, y=-10, z=dir.z*-3})
            obj:setyaw(player:get_look_yaw()+math.pi)
            minetest.sound_play("throwing_sound", {pos=playerpos})
            if obj:get_luaentity().player == "" then
                obj:get_luaentity().player = player
            end
            obj:get_luaentity().node = player:get_inventory():get_stack("main", 1):get_name()
            return true
        end
    end
    return false
end

minetest.register_tool("throwing:bow_wood0", {
    description = "Wood Bow",
    inventory_image = "throwing_bow_wood0.png",
    stack_max = 1,
    on_use = function(itemstack, user, pointed_thing)
        if throwing_shoot_arrow(itemstack, user, pointed_thing) then
            if not minetest.setting_getbool("creative_mode") then
                itemstack:add_wear(65535/50)
            end
        end
        return itemstack
    end,
})
minetest.register_tool("throwing:bow_wood1", {
    description = "Wood Bow",
    inventory_image = "throwing_bow_wood1.png",
    stack_max = 1,
    on_use = function(itemstack, user, pointed_thing)
        if throwing_shoot_arrow(itemstack, user, pointed_thing) then
            if not minetest.setting_getbool("creative_mode") then
                itemstack:add_wear(65535/50)
            end
        end
        return itemstack
    end,
})
minetest.register_tool("throwing:bow_wood2", {
    description = "Wood Bow",
    inventory_image = "throwing_bow_wood2.png",
    stack_max = 1,
    on_use = function(itemstack, user, pointed_thing)
        if throwing_shoot_arrow(itemstack, user, pointed_thing) then
            if not minetest.setting_getbool("creative_mode") then
                itemstack:add_wear(65535/50)
            end
        end
        return itemstack
    end,
})
minetest.register_tool("throwing:bow_wood3", {
    description = "Wood Bow",
    inventory_image = "throwing_bow_wood3.png",
    stack_max = 1,
    on_use = function(itemstack, user, pointed_thing)
        if throwing_shoot_arrow(itemstack, user, pointed_thing) then
            if not minetest.setting_getbool("creative_mode") then
                itemstack:add_wear(65535/50)
            end
        end
        return itemstack
    end,
})

minetest.register_craft({
    output = 'throwing:bow_wood',
    recipe = {
        {'farming:string', 'default:wood', ''},
        {'farming:string', '', 'default:wood'},
        {'farming:string', 'default:wood', ''},
    }
})

minetest.register_tool("throwing:bow_stone", {
    description = "Stone Bow",
    inventory_image = "throwing_bow_stone.png",
    stack_max = 1,
    on_use = function(itemstack, user, pointed_thing)
        if throwing_shoot_arrow(item, user, pointed_thing) then
            if not minetest.setting_getbool("creative_mode") then
                itemstack:add_wear(65535/100)
            end
        end
        return itemstack
    end,
})

minetest.register_craft({
    output = 'throwing:bow_stone',
    recipe = {
        {'farming:string', 'default:cobble', ''},
        {'farming:string', '', 'default:cobble'},
        {'farming:string', 'default:cobble', ''},
    }
})

minetest.register_tool("throwing:bow_steel", {
    description = "Steel Bow",
    inventory_image = "throwing_bow_steel.png",
    stack_max = 1,
    on_use = function(itemstack, user, pointed_thing)
        if throwing_shoot_arrow(item, user, pointed_thing) then
            if not minetest.setting_getbool("creative_mode") then
                itemstack:add_wear(65535/200)
            end
        end
        return itemstack
    end,
})

minetest.register_craft({
    output = 'throwing:bow_steel',
    recipe = {
        {'farming:string', 'default:steel_ingot', ''},
        {'farming:string', '', 'default:steel_ingot'},
        {'farming:string', 'default:steel_ingot', ''},
    }
})

dofile(minetest.get_modpath("throwing").."/arrow.lua")
dofile(minetest.get_modpath("throwing").."/fire_arrow.lua")
dofile(minetest.get_modpath("throwing").."/teleport_arrow.lua")
dofile(minetest.get_modpath("throwing").."/dig_arrow.lua")
dofile(minetest.get_modpath("throwing").."/build_arrow.lua")

if minetest.setting_get("log_mods") then
    minetest.log("action", "throwing loaded")
end


local gbus = true
local bows = {}
local bows1 = {}
 minetest.register_globalstep(function(dtime)
   local players  = minetest.get_connected_players()
   if #players == 0 then return end
   for i,player in ipairs(players) do
       local pll=player:get_player_name()
       ------


        local inv  = player:get_inventory()
        local i    = player:get_wield_index()
        local list = player:get_wield_list()
        local tll = inv:get_stack(list, i):to_table()

        --local tool = player:get_wielded_item()
        --tool = tool:get_name()
      local ui = inv:get_stack(list, i):to_string()
      --minetest.debug("------ui------------")
      --minetest.debug(ui)
      --minetest.debug("--------ttl----------")
      --minetest.debug(minetest.serialize(player:get_wield_list()))
      --minetest.debug("------------------")
--      minetest.debug("------------------")

        local rrr = player:get_player_control()
        if gbus and rrr.RMB == true then

if not bows then bows = {} end
if bows[pll] and bows[pll]>-1 then
--local ttt
      --if bows1 and bows1[pll] then ttt = bows1[pll] end
      if bows1 and bows1[pll] then
      player:hud_change(bows1[pll], "text", "throwing_bow_wood".. bows[pll] ..".png")
     minetest.debug("hud changed! ".. bows[pll])

      else
      bows1[pll] =  player:hud_add({
                    hud_elem_type = "text",
                    position = {x=0.75, y=0.75},
                    offset = {x=-0, y=0},
                    alignment = {x=-1, y=-1},
                    number = 0xFFFFFF ,
                    --scale = {x=4, y=4},
                    text = "throwing_bow_wood0.png",
                })
      minetest.debug("hud added! ".. bows[pll])
      end
     --if ttt then player:hud_remove(ttt) end
end



        if ui and type(ui)=="string" and ui~="" then

            if ui:find("throwing:bow_wood0") then
               inv:set_stack(list, i ,ItemStack("throwing:bow_wood1"))
               gbus = false
               bows[pll] = 0
               minetest.after(01.05,function() gbus = true end)

            elseif ui:find("throwing:bow_wood1") then
               inv:set_stack(list, i ,ItemStack("throwing:bow_wood2"))
               gbus = false
               bows[pll] = 1
               minetest.after(01.1,function() gbus = true end)
              -- return
            elseif ui:find("throwing:bow_wood2") then
               inv:set_stack(list, i ,ItemStack("throwing:bow_wood3"))
               gbus = false
               bows[pll] = 2
               minetest.after(01.15,function() gbus = true end)
              -- return
            elseif ui:find("throwing:bow_wood3") then
               inv:set_stack(list, i ,ItemStack("throwing:bow_wood0"))
               gbus = false
               bows[pll] = 3
               minetest.after(01.2,function() gbus = true end)
              -- return
            else
            bows[pll]=nil
            end
       end
       else
       if bows1 and bows1[pll] then player:hud_remove(bows1[pll]) end
       end

       --[[
        if tll then
        if tll["name"]=="throwing:bow_wood" -- and rrr.RMB==true
        then
           tll["name"]="throwing:bow_wood1"
           inv:set_stack(list, i ,ItemStack(tll))
end
          -- minetest.after(0.5,function()
              if tll["name"]=="throwing:bow_wood1" --  and rrr.RMB==true
              then
           tll["name"]="throwing:bow_wood2"
           inv:set_stack(list, i ,ItemStack(tll))

               --player:set_wielded_item("throwing:bow_wood2")
              end
            --   minetest.after(0.5,function()
                  if tll["name"]=="throwing:bow_wood2" --  and rrr.RMB==true
                  then
           tll["name"]="throwing:bow_wood3"
           inv:set_stack(list, i ,ItemStack(tll))

                  --player:set_wielded_item("throwing:bow_wood3")
                  end
              -- end)
           --end)
                  if tll["name"]=="throwing:bow_wood3" --  and rrr.RMB==true
                  then
           tll["name"]="throwing:bow_wood1"
           inv:set_stack(list, i ,ItemStack(tll))

--                  player:set_wielded_item("throwing:bow_wood")
                  end
end]]

      end
end)

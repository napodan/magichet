--run Files
local modpath = minetest.get_modpath("specialties")
dofile(modpath.."/config.lua")
dofile(modpath.."/tables.lua")
dofile(modpath.."/externalmodify.lua")
dofile(modpath.."/nodes.lua")
dofile(modpath.."/items.lua")
dofile(modpath.."/xp.lua")

local iplus = minetest.get_modpath("inventory_plus")

--variable used for time keeping for updating xp
local time = 0

local get_specialInfo = function(name, specialty)
    local formspec = "size[9,8]"..
    "button[2,0;2,0.5;miner;Miner]"..
    "button[2,.65;2,0.5;lumberjack;Lumberjack]"..
    "button[2,1.3;2,0.5;digger;Digger]"..
    "button[2,1.95;2,0.5;farmer;Farmer]"..
    "button[2,2.6;2,0.5;builder;Builder]"..
    "list[current_player;main;0,3.5;9,3;9]"..
    "list[current_player;main;0,7;9,1;]"

    if iplus then
        formspec = formspec.."button[0,0;2,0.5;main;Back]"
    else
        formspec = formspec.."button_exit[0,0;0.75,0.5;close;X]"
    end
    if specialty ~= "" then
        formspec = formspec.."label[4,0;XP: "..specialties.players[name].skills[specialty].."]"..specialties.skills[specialty].menu
    end
    return formspec
end

minetest.register_on_leaveplayer(function(player)--Called if on a server, if single player than it isn't called
    specialties.writeXP(player:get_player_name())
end)

--Initial XP Extraction
--optimizes the amount of calls to files
minetest.register_chatcommand("spec", {
    description = "Show a list of available professions",
    func = function(name, param)
        minetest.show_formspec(name, "specialties:spec", get_specialInfo(name, ""))
    end,
})
minetest.register_on_joinplayer(function(player)
    minetest.after(0,function(dtime)
    player:get_inventory():set_size("pick", 1)
    player:get_inventory():set_size("axe", 1)
    player:get_inventory():set_size("shovel", 1)
    player:get_inventory():set_size("hoe", 1)
    player:get_inventory():set_size("transferslotleft", 1)
    player:get_inventory():set_size("transferslotright", 1)
    player:get_inventory():set_size("transfergrid", 9)
    if iplus then
        inventory_plus.register_button(player,"specialties","Specialties")
    end
    name = player:get_player_name()
    specialties.players[name] = {}
    specialties.players[name].skills = {}
    specialties.players[name].skills = specialties.readXP(name)
    specialties.players[name].hud = {}
    minetest.after(0.5, function(name)
        local Yoffset = 0.02
        local y = 0
        for skill,num in pairs(specialties.players[name].skills) do
            if not specialties.players[name].hud[skill] then specialties.players[name].hud[skill]={} end
            specialties.players[name].hud[skill][1] = player:hud_add({
                hud_elem_type = "text",
                position = {x=0, y=0.85+y},
                offset = {x=100, y=0},
                alignment = {x=1, y=0},
                number = 0xFFFFFF ,
                text = tostring(num),
            })
--[[
            if skill=='miner' then skill_rus='Miner' end
            if skill=='lumberjack' then skill_rus='Lumberjack' end
            if skill=='digger' then skill_rus='Digger' end
            if skill=='farmer' then skill_rus='Farmer' end
            if skill=='builder' then skill_rus='Builder' end ]]
            specialties.players[name].hud[skill][2] = player:hud_add({
                hud_elem_type = "text",
                position = {x=0, y=0.85+y},
                offset = {x=10, y=0},
                alignment = {x=1, y=0},
                scale = {x=100, y=50},
                number = 0xFFFFFF ,
                text = skill,
            })
            y = y+Yoffset
        end
    end,
    name)
   end)
end)
local function show_formspec(name, specialty)
    minetest.show_formspec(name, "specialties:spec", get_specialInfo(name, specialty))
end

--Skill Events
local function healTool(player, list, specialty, cost)
    local tool = player:get_inventory():get_list(list)[1]
    if tool:get_name():find(":"..list) == nil then return end
    local name = player:get_player_name()
    if tool:get_wear() ~= 0 and specialties.healAmount[tool:get_name()] ~= nil then
        if specialties.changeXP(name, specialty, -cost) then
            tool:add_wear(-specialties.healAmount[tool:get_name()])
            player:get_inventory():set_stack(list, 1, tool)
        end
    end
    show_formspec(name, specialty)
end
local function upgradeTool(player, list, specialty, cost)
    local tool = player:get_inventory():get_list(list)[1]
    if tool:get_name():find(":"..list) == nil then return end
    if specialties.upgradeTree[tool:get_name()] ~= nil then
        if specialties.changeXP(player:get_player_name(), specialty, -cost) then
            player:get_inventory():set_stack(list, 1, specialties.upgradeTree[tool:get_name()])
        end
    end
    show_formspec(player:get_player_name(), specialty)
end
local function addSpecial2Tool(player, skill, list, specialty, cost)
    local tool = player:get_inventory():get_list(list)[1]
    local toolname = tool:get_name()
    if toolname:find(":"..list) == nil then return end
    if toolname:find("_"..skill) ~= nil then return end
    local name = player:get_player_name()
    if specialties.changeXP(name, specialty, -cost) then
        local def = tool:get_definition()
        local colonpos = toolname:find(":")
        local modname = toolname:sub(0,colonpos-1)
        if(modname ~= "specialties") then toolname = "specialties"..toolname:sub(colonpos) end
        local name = toolname.."_"..skill
        player:get_inventory():set_stack(list, 1, name)
    end
    show_formspec(name, specialty)
end

--GUI Events
minetest.register_on_player_receive_fields(function(player, formname, fields)
    local name = player:get_player_name()

    --Inventory Plus support
    if fields.specialties then
        show_formspec(name, "")
        return
    end

    --MINER
    if fields.miner then
        show_formspec(name, "miner")
        return
    end
    if fields.healpick then healTool(player, "pick", "miner", 100) return end
    if fields.upgradepick then upgradeTool(player, "pick", "miner", 200) return end
    if fields.superheatpick then addSpecial2Tool(player, "superheat", "pick", "miner", 500) return end

    --LUMBERJACK
    if fields.lumberjack then
        show_formspec(name, "lumberjack")
        return
    end
    if fields.healaxe then healTool(player, "axe", "lumberjack", 100) return end
    if fields.upgradeaxe then upgradeTool(player, "axe", "lumberjack", 200) return end
    if fields.superheataxe then addSpecial2Tool(player, "superheat", "axe", "lumberjack", 500) return end
    if fields.felleraxe then addSpecial2Tool(player, "feller", "axe", "lumberjack", 750) return end

    --DIGGER
    if fields.digger then
        show_formspec(name, "digger")
        return
    end
    if fields.healshovel then healTool(player, "shovel", "digger", 100) return end
    if fields.upgradeshovel then upgradeTool(player, "shovel", "digger", 200) return end
    if fields.superheatshovel then addSpecial2Tool(player, "superheat", "shovel", "digger", 500) return end

    --FARMER
    if fields.farmer then
        show_formspec(name, "farmer")
        return
    end
    if fields.healhoe then healTool(player, "hoe", "farmer", 100) return end
    if fields.upgradehoe then upgradeTool(player, "hoe", "farmer", 200) return end
    if fields.greenthumb then addSpecial2Tool(player, "greenthumb", "hoe", "farmer", 500) return end

    --BUILDER
    if fields.builder then
        show_formspec(name, "builder")
        return
    end
    if fields.grantfast then
        if specialties.changeXP(name, "builder", -600) then
            local privs = minetest.get_player_privs(name)
            if privs.fast == false or privs.fast == nil then
                privs.fast = true
            end
            minetest.set_player_privs(name, privs)
            show_formspec(name, "builder")
        end
        return
    end
    if fields.grantfly then
        if specialties.changeXP(name, "builder", -800) then
            local privs = minetest.get_player_privs(name)
            if privs.fly == false or privs.fly == nil then
                privs.fly = true
            end
            -- it wad too foolish to grant "fly" permanently
            minetest.after(80,function()
                privs.fly = false
            end)
            minetest.set_player_privs(name, privs)
            show_formspec(name, "builder")
        end
        return
    end
end)

minetest.register_craftitem('specialties:xp_ball', {
    description = "XP points",
    inventory_image = "specialties_xp.png",
    groups = {xp=1},
})


--XP Events
local function drop_xp(pos,skill,amount)
      local obj = minetest.add_item(pos, "specialties:xp_ball")
      if obj ~= nil then
        prop = {
            is_visible = true,
            visual = "sprite",
            textures = {"specialties_xp.png"},
            automatic_rotate = 0,
               }
         obj:set_properties(prop)
         obj:get_luaentity().itemstring = ""
         obj:get_luaentity().collect = true
         obj:get_luaentity().xp.skill = skill
         obj:get_luaentity().xp.amount = amount
         local x = math.random(1, 5)
         if math.random(1,2) == 1 then
            x = -x
         end
         local z = math.random(1, 5)
         if math.random(1,2) == 1 then
            z = -z
         end
         obj:setvelocity({x=1/x, y=obj:getvelocity().y, z=1/z})
      end
end


local node_dig = minetest.node_dig

function minetest.node_dig(pos, oldnode, digger)

    node_dig(pos, oldnode, digger)

    local meta = minetest.get_meta(pos)
    local builder = meta:get_string('builder')
    local tool = digger:get_wielded_item():get_name()

    if not digger then
        return pos, oldnode, digger
    end

    local pll = digger:get_player_name()
    if pll == builder then
        specialties.changeXP(pll, "builder", -1)
        return pos, oldnode, digger
    end

    if isghost[pll] then return pos, oldnode, digger end -- falloff if is ghost..
    if digger:get_wielded_item():is_empty() then
        return pos, oldnode, digger
    end


    local name = digger:get_player_name()
    if tool:find("pick") ~= nil then
        drop_xp(pos,"miner",1)
        --specialties.changeXP(name, "miner", 1)
    end

    if tool:find("axe") ~= nil then
        specialties.changeXP(name, "lumberjack", 1)
        if tool:find("feller") ~= nil and minetest.get_item_group(oldnode.name, "tree") ~= 0 then
            local y = 1
            local abovepos = {x=pos.x,y=pos.y+y,z=pos.z}
            while minetest.get_node(abovepos).name == oldnode.name do
                minetest.dig_node(abovepos)
                y = y+1
                abovepos = {x=pos.x,y=pos.y+y,z=pos.z}
            end
            drop_xp(pos,"lumberjack", y-1)
            --specialties.changeXP(name, "lumberjack", y-1)
        end
    end
    if tool:find("shovel") ~= nil then
        drop_xp(pos,"digger", 1)
        --specialties.changeXP(name, "digger", 1)
    end
    if oldnode.name:find("farming") ~= nil then
        drop_xp(pos,"farmer", 5)
        specialties.changeXP(name, "farmer", 5)
    end

    return pos, oldnode, digger
end

local place_node = minetest.item_place_node
function minetest.item_place_node(itemstack, placer, pointed_thing)
    place_node(itemstack, placer, pointed_thing)
    if not placer then return itemstack, placer, pointed_thing end
    local pll = placer:get_player_name()
    if isghost[pll] then return itemstack, placer, pointed_thing end -- falloff if is ghost..

    specialties.changeXP(placer:get_player_name(), "builder", 1)
    local meta = minetest.get_meta(pos)
    meta:set_string('builder',pll)
    return itemstack, placer, pointed_thing
end
minetest.register_globalstep(function(dtime)
    if time+dtime < 10 then
        time = time+dtime
    else
        time = 0
        for player in pairs(specialties.players)do
            specialties.writeXP(player)
        end
    end
end)

print('[OK] Specialties (4aiman\'s version) loaded')

local time = 0
local update_time = tonumber(minetest.setting_get("3d_armor_update_time"))
if not update_time then
    update_time = 1
    minetest.setting_set("3d_armor_update_time", tostring(update_time))
end

armor = {
    player_hp = {},
    elements = {"helm", "torso", "pants", "boots"},
    textures = {},
    default_skin = "character.png",
}

armor.pll_inv = {}

armor.update_player_visuals = function(self, player)
    if not player then
        return
    end
    local name = player:get_player_name()
    if self.textures[name] then
        default.player_set_textures(player, {
            self.textures[name].skin,
            self.textures[name].armor,
            self.textures[name].wielditem,
        })
    end
end

armor.set_player_armor = function(self, player)
    if not player then
        return
    end
    local name = player:get_player_name()
    local player_inv = player:get_inventory()
    local armor_texture = "3d_armor_trans.png"
    local fleshy_level = 0
    local metal_level = 0
    local blast_level = 0
    local state = 0
    local textures = {}
    local elements = {}
    for i, v in ipairs(self.elements) do
        local stack = player_inv:get_stack(v, 1)
        local fleshy = stack:get_definition().groups["fleshy"]
        local metal  = stack:get_definition().groups["metal"]
        local blast  = stack:get_definition().groups["blast"]
        local item = stack:get_name()
        elements[i] = string.match(item, "%:.+_(.+)$")
        if fleshy or metal or blast then
            table.insert(textures, item:gsub("%:", "_")..".png")
            fleshy_level = fleshy_level + fleshy
            metal_level  = metal_level  + metal
            blast_level  = blast_level  + blast
            -- state in %
            state = state + (65535-stack:get_wear()/65535) -- * fleshy_level
        end
    end

    if #textures > 0 then
        armor_texture = table.concat(textures, "^")
    end
    local armor_groups = {fleshy=100, metal=100, blast=100}

    if fleshy_level > 0 then
        --armor_groups.level = math.floor(armor_level / 20)
        -- damage can be consumed by 80%
        fleshy_level= math.min(fleshy_level*state, 80)
        armor_groups.fleshy = 100 - fleshy_level
    end
    if metal_level > 0 then
        metal_level= math.min(metal_level*state, 80)
        armor_groups.metal = 100 - metal_level
    end
    if blast_level > 0 then
        blast_level= math.min(blast_level*state, 80)
        armor_groups.blast = 100 - blast_level
    end

    -- here's the protection!
    player:set_armor_groups(armor_groups)
    self.textures[name].armor = armor_texture
    self:update_player_visuals(player)
end

armor.update_armor = function(self, player)
    if not player then
        return
    end
    local name = player:get_player_name()
    local hp = player:get_hp() or 0
    if hp == 0 or hp == self.player_hp[name] then
        return
    end
    if self.player_hp[name] > hp then
        local inv = player:get_inventory()
        local state = 0
        local items = 0
        print(minetest.serialize(self.elements))
        for _,v in ipairs(self.elements) do
            local stack = inv:get_stack(v, 1)
            if stack:get_count() > 0 then
                local use = stack:get_definition().groups["armor_use"] or 0
                local item = stack:get_name()
                stack:add_wear(use)
                inv:set_stack(v, 1, stack)
                state = state + stack:get_wear()
                items = items + 1
                if stack:get_count() == 0 then
                    local desc = minetest.registered_items[item].description
                    if desc then
                        minetest.chat_send_player(name, "Your "..desc.." got destroyed!")
                    end
                    self:set_player_armor(player)
                end
            end
        end
    end
    self.player_hp[name] = hp
end

-- Register Player Model

default.player_register_model("3d_armor_character.x", {
    animation_speed = 30,
    textures = {
        armor.default_skin,
        "3d_armor_trans.png",
        "3d_armor_trans.png",
    },
    animations = {
        stand = {x=0, y=79},
        lay = {x=162, y=166},
        walk = {x=168, y=187},
        mine = {x=189, y=198},
        walk_mine = {x=200, y=219},
        sit = {x=81, y=160},
    },
})

-- Register Callbacks

minetest.register_on_player_receive_fields(function(player, formname, fields)
    if fields.quit then
    local inv = player:get_inventory()
    local pll = player:get_player_name()
       if armor.pll_inv[pll][1] ~= inv:get_stack('helm',1):get_name()
       or armor.pll_inv[pll][2] ~= inv:get_stack('torso',1):get_name()
       or armor.pll_inv[pll][3] ~= inv:get_stack('pants',1):get_name()
       or armor.pll_inv[pll][4] ~= inv:get_stack('boots',1):get_name()
       then
           armor:set_player_armor(player)
           armor.pll_inv[name] = {[1]=inv:get_stack('helm',1):get_name(),
                                  [2]=inv:get_stack('torso',1):get_name(),
                                  [3]=inv:get_stack('pants',1):get_name(),
                                  [4]=inv:get_stack('boots',1):get_name()}
       end
    end
    for field, _ in pairs(fields) do
        if string.find(field, "^skins_set_") then
            minetest.after(0, function(player)
                armor.textures[name].skin = skins.skins[name]..".png"
                armor:update_player_visuals(player)
            end, player)
        end
    end
end)

minetest.register_on_joinplayer(function(player)
    default.player_set_model(player, "3d_armor_character.x")
    local inv = player:get_inventory()
    local name = player:get_player_name()
    armor.pll_inv[name] = {[1]=inv:get_stack('helm',1):get_name(),
                           [2]=inv:get_stack('torso',1):get_name(),
                           [3]=inv:get_stack('pants',1):get_name(),
                           [4]=inv:get_stack('boots',1):get_name()}
    armor.player_hp[name] = 0
    armor.textures[name] = {
        skin = armor.default_skin,
        armor = "3d_armor_trans.png",
        wielditem = "3d_armor_trans.png",
    }
    if minetest.get_modpath("skins") then
        local skin = skins.skins[name]
        if skin and skins.get_type(skin) == skins.type.MODEL then
            armor.textures[name].skin = skin..".png"
        end
    end
    if minetest.get_modpath("player_textures") then
        local filename = minetest.get_modpath("player_textures").."/textures/player_"..name
        local f = io.open(filename..".png")
        if f then
            f:close()
            armor.textures[name].skin = "player_"..name..".png"
        end
    end
    minetest.after(0, function(player)
        armor:set_player_armor(player)
    end, player)
end)

minetest.register_globalstep(function(dtime)
    time = time + dtime
    if time > update_time then
        for _,player in ipairs(minetest.get_connected_players()) do
            armor:update_armor(player)
        end
        time = 0
    end
end)


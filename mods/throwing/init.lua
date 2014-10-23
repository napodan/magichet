arrows = {
    {"throwing:arrow", "throwing:arrow_entity"},
--  {"throwing:arrow_fire", "throwing:arrow_fire_entity"},
--  {"throwing:arrow_teleport", "throwing:arrow_teleport_entity"},
--  {"throwing:arrow_dig", "throwing:arrow_dig_entity"},
--  {"throwing:arrow_build", "throwing:arrow_build_entity"}
}

local throwing_shoot_arrow = function(itemstack, player)
        if player:get_inventory():get_stack("main", player:get_wield_index()+1):get_name() == "throwing:arrow" then
            player:get_inventory():remove_item("main", "throwing:arrow")
            local pos = player:getpos()
            local obj = minetest.add_entity({x=pos.x,y=pos.y+1.5,z=pos.z}, "adbs:arrow")
            local dir = player:get_look_dir()
            obj:get_luaentity().master = player
            obj:get_luaentity().target = nil
            obj:setvelocity({x=dir.x*19, y=dir.y*19, z=dir.z*19})
            obj:setacceleration({x=dir.x*-2, y=-9.8, z=dir.z*-2})
            minetest.sound_play("throwing_sound", pos)
            if obj:get_luaentity().player == "" then
               obj:get_luaentity().player = player
            end
            --obj:get_luaentity().node = player:get_inventory():get_stack("main", 1):get_name() -- building arrow
            return true
        end
    return false
end

minetest.register_tool("throwing:bow_wood", {
    description = "Wood Bow",
    inventory_image = "throwing_bow_wood0.png",
    stack_max = 1,
    on_use = function(itemstack, user, pointed_thing)
        if throwing_shoot_arrow(itemstack, user, pointed_thing) then
           itemstack:add_wear(65535/50)
        end
        return itemstack
    end,
})

minetest.register_craft({
    output = 'throwing:bow_wood',
    recipe = {
        {'group:string', 'default:wood', ''},
        {'group:string', '', 'default:wood'},
        {'group:string', 'default:wood', ''},
    }
})

minetest.register_tool("throwing:bow_stone", {
    description = "Stone Bow",
    inventory_image = "throwing_bow_stone.png",
    stack_max = 1,
    on_use = function(itemstack, user, pointed_thing)
        if throwing_shoot_arrow(item, user, pointed_thing) then
           itemstack:add_wear(65535/100)
        end
        return itemstack
    end,
})

minetest.register_craft({
    output = 'throwing:bow_stone',
    recipe = {
        {'group:string', 'default:cobble', ''},
        {'group:string', '', 'default:cobble'},
        {'group:string', 'default:cobble', ''},
    }
})

minetest.register_tool("throwing:bow_steel", {
    description = "Steel Bow",
    inventory_image = "throwing_bow_steel.png",
    stack_max = 1,
    on_use = function(itemstack, user, pointed_thing)
        if throwing_shoot_arrow(item, user, pointed_thing) then
           itemstack:add_wear(65535/200)
        end
        return itemstack
    end,
})

minetest.register_craft({
    output = 'throwing:bow_steel',
    recipe = {
        {'group:string', 'default:steel_ingot', ''},
        {'group:string', '', 'default:steel_ingot'},
        {'group:string', 'default:steel_ingot', ''},
    }
})

dofile(minetest.get_modpath("throwing").."/arrow.lua")
--dofile(minetest.get_modpath("throwing").."/fire_arrow.lua")
--dofile(minetest.get_modpath("throwing").."/teleport_arrow.lua")
--dofile(minetest.get_modpath("throwing").."/dig_arrow.lua")
--dofile(minetest.get_modpath("throwing").."/build_arrow.lua")

print('[OK] Throwing loaded')

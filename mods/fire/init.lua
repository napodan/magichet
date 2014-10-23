local shared_autoban = minetest.get_modpath("shared_autoban")
fire = {}
fire.D = 6
-- key: position hash of low corner of area
-- value: {handle=sound handle, name=sound name}
fire.sounds = {}

local nodebox = {type="fixed",fixed={-0.3,-0.3,-0.3,0.3,0.3,0.3}}

-- check for nearby nodes and make a replacement ;)
function fire.onnodetimer(pos,elapsed)
       local po = {}
       po.x = pos.x
       po.y = pos.y
       po.z = pos.z

       local env = minetest.env
       po.x = po.x+1
       local nxp = env:get_node(po).name
       po.x = po.x-2
       local nxm = env:get_node(po).name
       po.x = po.x+1

       po.z = po.z+1
       local nzp = env:get_node(po).name
       po.z = po.z-2
       local nzm = env:get_node(po).name
       po.z = po.z+1

       po.y = po.y+1
       local nyp = env:get_node(po).name
       po.y = po.y-2
       local nym = env:get_node(po).name
       po.y = po.y+1
     --[[
       minetest.chat_send_all("xp: " .. nxp .. "; "..
                              "xm: " .. nxm .. "; "..
                              "yp: " .. nyp .. "; "..
                              "ym: " .. nym .. "; "..
                              "zp: " .. nzp .. "; "..
                              "zm: " .. nzm .. "; "..
                              minetest.pos_to_string(po))
       ]]
       local nxpg = minetest.get_item_group(nxp, "fire")
       local nxmg = minetest.get_item_group(nxm, "fire")
       local nzpg = minetest.get_item_group(nzp, "fire")
       local nzmg = minetest.get_item_group(nzm, "fire")

       if (nxp ~= "air" and nxm ~= "air" and nzp ~= "air" and nzm ~= "air")
       and (nxpg ~= 1 and nxmg ~= 1 and nzpg ~= 1 and nzmg ~= 1)
       then
            minetest.add_node(pos, {name="fire:flame_normal"})
            fire.on_flame_add_at(pos)

       elseif (nxm ~= "air" and nzp ~= "air" and nzm ~= "air" )
       and (nxmg ~= 1 and nzpg ~= 1 and nzmg ~= 1)
       then
            minetest.add_node(pos, {name="fire:flame_xp_missing"})
            fire.on_flame_add_at(pos)
       elseif (nxp ~= "air" and nzp ~= "air" and nzm ~= "air")
       and (nxpg ~= 1 and nzpg ~= 1 and nzmg ~= 1)
       then
            minetest.add_node(pos, {name="fire:flame_xm_missing"})
            fire.on_flame_add_at(pos)

       elseif (nxp ~= "air" and nxm ~= "air" and nzm ~= "air")
       and (nxpg ~= 1 and nxmg ~= 1 and nzmg ~= 1)
       then
            minetest.add_node(pos, {name="fire:flame_zp_missing"})
            fire.on_flame_add_at(pos)

       elseif (nxp ~= "air" and nxm ~= "air" and nzp ~= "air")
       and (nxpg ~= 1 and nxmg ~= 1 and nzpg ~= 1)
       then
            minetest.add_node(pos, {name="fire:flame_zm_missing"})
            fire.on_flame_add_at(pos)

       elseif (nzp ~= "air" and nzm ~= "air")
       and (nzpg ~= 1 and nzmg ~= 1)
       then
            minetest.add_node(pos, {name="fire:flame_xpxm_missing"})
            fire.on_flame_add_at(pos)

       elseif (nxp ~= "air" and nzm ~= "air")
       and (nxpg ~= 1 and nzmg ~= 1)
       then
            minetest.add_node(pos, {name="fire:flame_xmzp_missing"})
            fire.on_flame_add_at(pos)

       elseif (nxp ~= "air" and nxm ~= "air")
       and (nxpg ~= 1 and nxmg ~= 1)
       then
            minetest.add_node(pos, {name="fire:flame_zpzm_missing"})
            fire.on_flame_add_at(pos)

       elseif (nxm ~= "air" and nzp ~= "air")
       and (nxmg ~= 1 and nzpg ~= 1)
       then
            minetest.add_node(pos, {name="fire:flame_xpzm_missing"})
            fire.on_flame_add_at(pos)

       elseif (nxp ~= "air" and nzp ~= "air")
       and (nxpg ~= 1 and nzpg ~= 1)
       then
            minetest.add_node(pos, {name="fire:flame_xmzm_missing"})
            fire.on_flame_add_at(pos)

       elseif (nxm ~= "air" and nzm ~= "air")
       and (nxmg ~= 1 and nzmg ~= 1)
       then
            minetest.add_node(pos, {name="fire:flame_xpzp_missing"})
            fire.on_flame_add_at(pos)

       elseif nxp ~= "air"
       and nxpg ~= 1
       then
            minetest.add_node(pos, {name="fire:flame_xp_only"})
            fire.on_flame_add_at(pos)

       elseif nxm ~= "air"
       and nxmg ~= 1
       then
            minetest.add_node(pos, {name="fire:flame_xm_only"})
            fire.on_flame_add_at(pos)

       elseif nzp ~= "air"
       and nzpg ~= 1
       then
            minetest.add_node(pos, {name="fire:flame_zp_only"})
            fire.on_flame_add_at(pos)

       elseif nzm ~= "air"
       and  nzmg ~= 1
       then
            minetest.add_node(pos, {name="fire:flame_zm_only"})
            fire.on_flame_add_at(pos)
       elseif nym == "air" and nyp == air then
            minetest.remove_node(pos)
            fire.on_flame_remove_at(pos)
       end

       for _,obj in pairs(minetest.get_objects_inside_radius(pos,1)) do
          if obj:is_player() then
             obj:set_hp(obj:get_hp()- default.statuses[obj:get_player_name()].lava_damage-2)
             -- env. damage for entities is calculated @adbs:init.lua
          end
       end

       return true

end

-- minetest/fire/init.lua

minetest.register_node("fire:flame_xp_missing", {
    description = "Fire",
    drawtype = "nodebox",
    tiles = {{
        name="fire_basic_flame_animated.png",
        animation={type="vertical_frames", aspect_w=16, aspect_h=16, length=1},
    }},
    inventory_image = "fire_basic_flame.png",
    light_source = 14,
    groups = {igniter=2,dig_immediate=3,fire=1 ,hot=2},
    drop = '',
    walkable = false,
    buildable_to = false,
    damage_per_second = 2,
    after_place_node = function(pos, placer)
        fire.on_flame_add_at(pos)
    end,

    after_dig_node = function(pos, oldnode, oldmetadata, digger)
        fire.on_flame_remove_at(pos)
    end,
    on_timer = fire.onnodetimer,
    node_box = {
    type = "fixed",
    fixed = {
           {-0.5,  -0.5, -0.5, -0.45, 0.5,   0.5},  -- left
           {-0.45, -0.5, 0.45,   0.5, 0.5,   0.5},  -- upper
           {-0.45, -0.5, -0.5,   0.5, 0.5, -0.45},  -- bottom
            }
    },
})


minetest.register_node("fire:flame_xm_missing", {
    description = "Fire",
    drawtype = "nodebox",
    tiles = {{
        name="fire_basic_flame_animated.png",
        animation={type="vertical_frames", aspect_w=16, aspect_h=16, length=1},
    }},
    inventory_image = "fire_basic_flame.png",
    light_source = 14,
    groups = {igniter=2,dig_immediate=3,fire=1 ,hot=2},
    drop = '',
    walkable = false,
    buildable_to = false,
    damage_per_second = 4,
    after_place_node = function(pos, placer)
        fire.on_flame_add_at(pos)
    end,

    after_dig_node = function(pos, oldnode, oldmetadata, digger)
        fire.on_flame_remove_at(pos)
    end,
    on_timer = fire.onnodetimer,
    node_box = {
    type = "fixed",
    fixed = {
           { 0.45,  -0.5, -0.5,   0.5, 0.5,   0.5},  -- right
           { -0.5, -0.5, 0.45,   0.45, 0.5,   0.5},  -- upper
           { -0.5, -0.5, -0.5,   0.45, 0.5, -0.45},  -- bottom
            }
    },
})


minetest.register_node("fire:flame_zp_missing", {
    description = "Fire",
    drawtype = "nodebox",
    tiles = {{
        name="fire_basic_flame_animated.png",
        animation={type="vertical_frames", aspect_w=16, aspect_h=16, length=1},
    }},
    inventory_image = "fire_basic_flame.png",
    light_source = 14,
    groups = {igniter=2,dig_immediate=3,fire=1 ,hot=2},
    drop = '',
    walkable = false,
    buildable_to = false,
    damage_per_second = 4,
    after_place_node = function(pos, placer)
        fire.on_flame_add_at(pos)
    end,

    after_dig_node = function(pos, oldnode, oldmetadata, digger)
        fire.on_flame_remove_at(pos)
    end,
    on_timer = fire.onnodetimer,
    node_box = {
    type = "fixed",
    fixed = {
           { 0.45,  -0.5, -0.5,   0.5, 0.5,   0.5},  -- right
           { -0.5,  -0.5, -0.5, -0.45, 0.5,   0.5},  -- left
           {-0.45, -0.5, -0.5,   0.45, 0.5, -0.45},  -- bottom
            }
    },
})


minetest.register_node("fire:flame_zm_missing", {
    description = "Fire",
    drawtype = "nodebox",
    tiles = {{
        name="fire_basic_flame_animated.png",
        animation={type="vertical_frames", aspect_w=16, aspect_h=16, length=1},
    }},
    inventory_image = "fire_basic_flame.png",
    light_source = 14,
    groups = {igniter=2,dig_immediate=3,fire=1 ,hot=2},
    drop = '',
    walkable = false,
    buildable_to = false,
    damage_per_second = 4,
    after_place_node = function(pos, placer)
        fire.on_flame_add_at(pos)
    end,

    after_dig_node = function(pos, oldnode, oldmetadata, digger)
        fire.on_flame_remove_at(pos)
    end,
    on_timer = fire.onnodetimer,
    node_box = {
    type = "fixed",
    fixed = {
           { 0.45,  -0.5, -0.5,   0.5, 0.5,   0.5},  -- right
           { -0.5,  -0.5, -0.5, -0.45, 0.5,   0.5},  -- left
           {-0.45,  -0.5, 0.45,  0.45, 0.5,   0.5},  -- upper
            }
    },
})


minetest.register_node("fire:flame_xpxm_missing", {
    description = "Fire",
    drawtype = "nodebox",
    tiles = {{
        name="fire_basic_flame_animated.png",
        animation={type="vertical_frames", aspect_w=16, aspect_h=16, length=1},
    }},
    inventory_image = "fire_basic_flame.png",
    light_source = 14,
    groups = {igniter=2,dig_immediate=3,fire=1 ,hot=2},
    drop = '',
    walkable = false,
    buildable_to = false,
    damage_per_second = 4,
    after_place_node = function(pos, placer)
        fire.on_flame_add_at(pos)
    end,

    after_dig_node = function(pos, oldnode, oldmetadata, digger)
        fire.on_flame_remove_at(pos)
    end,
    on_timer = fire.onnodetimer,
    node_box = {
    type = "fixed",
    fixed = {
           {-0.5, -0.5, 0.45,   0.5, 0.5,   0.5},  -- upper
           {-0.5, -0.5, -0.5,   0.5, 0.5, -0.45},  -- bottom
            }
    },
})

minetest.register_node("fire:flame_xmzp_missing", {
    description = "Fire",
    drawtype = "nodebox",
    tiles = {{
        name="fire_basic_flame_animated.png",
        animation={type="vertical_frames", aspect_w=16, aspect_h=16, length=1},
    }},
    inventory_image = "fire_basic_flame.png",
    light_source = 14,
    groups = {igniter=2,dig_immediate=3,fire=1 ,hot=2},
    drop = '',
    walkable = false,
    buildable_to = false,
    damage_per_second = 4,
    after_place_node = function(pos, placer)
        fire.on_flame_add_at(pos)
    end,

    after_dig_node = function(pos, oldnode, oldmetadata, digger)
        fire.on_flame_remove_at(pos)
    end,
    on_timer = fire.onnodetimer,
    node_box = {
    type = "fixed",
    fixed = {
           { 0.45,  -0.5, -0.5,   0.5, 0.5,   0.5},  -- right
           { -0.5,  -0.5, -0.5,  0.45, 0.5, -0.45},  -- bottom
            }
    },
})

minetest.register_node("fire:flame_zpzm_missing", {
    description = "Fire",
    drawtype = "nodebox",
    tiles = {{
        name="fire_basic_flame_animated.png",
        animation={type="vertical_frames", aspect_w=16, aspect_h=16, length=1},
    }},
    inventory_image = "fire_basic_flame.png",
    light_source = 14,
    groups = {igniter=2,dig_immediate=3,fire=1 ,hot=2},
    drop = '',
    walkable = false,
    buildable_to = false,
    damage_per_second = 4,
    after_place_node = function(pos, placer)
        fire.on_flame_add_at(pos)
    end,

    after_dig_node = function(pos, oldnode, oldmetadata, digger)
        fire.on_flame_remove_at(pos)
    end,
    on_timer = fire.onnodetimer,
    node_box = {
    type = "fixed",
    fixed = {
           {  0.5,  -0.5, -0.5,   0.5, 0.5,   0.5},  -- right
           { -0.5,  -0.5, -0.5,  -0.5, 0.5,   0.5},  -- left
            }
    },
})


minetest.register_node("fire:flame_xpzm_missing", {
    description = "Fire",
    drawtype = "nodebox",
    tiles = {{
        name="fire_basic_flame_animated.png",
        animation={type="vertical_frames", aspect_w=16, aspect_h=16, length=1},
    }},
    inventory_image = "fire_basic_flame.png",
    light_source = 14,
    groups = {igniter=2,dig_immediate=3,fire=1 ,hot=2},
    drop = '',
    walkable = false,
    buildable_to = false,
    damage_per_second = 4,
    after_place_node = function(pos, placer)
        fire.on_flame_add_at(pos)
    end,

    after_dig_node = function(pos, oldnode, oldmetadata, digger)
        fire.on_flame_remove_at(pos)
    end,
    on_timer = fire.onnodetimer,
    node_box = {
    type = "fixed",
    fixed = {
           { -0.5,  -0.5, -0.5, -0.45, 0.5,   0.5},  -- left
           { -0.45,  -0.5, 0.45,  0.5, 0.5,   0.5},  -- upper
            }
    },

})


minetest.register_node("fire:flame_xmzm_missing", {
    description = "Fire",
    drawtype = "nodebox",
    tiles = {{
        name="fire_basic_flame_animated.png",
        animation={type="vertical_frames", aspect_w=16, aspect_h=16, length=1},
    }},
    inventory_image = "fire_basic_flame.png",
    light_source = 14,
    groups = {igniter=2,dig_immediate=3,fire=1 ,hot=2},
    drop = '',
    walkable = false,
    buildable_to = false,
    damage_per_second = 4,
    after_place_node = function(pos, placer)
        fire.on_flame_add_at(pos)
    end,

    after_dig_node = function(pos, oldnode, oldmetadata, digger)
        fire.on_flame_remove_at(pos)
    end,
    on_timer = fire.onnodetimer,
    node_box = {
    type = "fixed",
    fixed = {
           { 0.45,  -0.5, -0.5,   0.5, 0.5,   0.5},  -- right
           { -0.5,  -0.5, 0.45,  0.45, 0.5,   0.5},  -- upper
            }
    },

})


minetest.register_node("fire:flame_xpzp_missing", {
    description = "Fire",
    drawtype = "nodebox",
    tiles = {{
        name="fire_basic_flame_animated.png",
        animation={type="vertical_frames", aspect_w=16, aspect_h=16, length=1},
    }},
    inventory_image = "fire_basic_flame.png",
    light_source = 14,
    groups = {igniter=2,dig_immediate=3,fire=1 ,hot=2},
    drop = '',
    walkable = false,
    buildable_to = false,
    damage_per_second = 4,
    after_place_node = function(pos, placer)
        fire.on_flame_add_at(pos)
    end,

    after_dig_node = function(pos, oldnode, oldmetadata, digger)
        fire.on_flame_remove_at(pos)
    end,
    on_timer = fire.onnodetimer,
    node_box = {
    type = "fixed",
    fixed = {
           { -0.5,  -0.5, -0.5, -0.45, 0.5,   0.5},  -- left
           { -0.45, -0.5, -0.5,   0.5, 0.5, -0.45},  -- bottom
            }
    },

})


minetest.register_node("fire:flame_xp_only", {
    description = "Fire",
    drawtype = "nodebox",
    tiles = {{
        name="fire_basic_flame_animated.png",
        animation={type="vertical_frames", aspect_w=16, aspect_h=16, length=1},
    }},
    inventory_image = "fire_basic_flame.png",
    light_source = 14,
    groups = {igniter=2,dig_immediate=3,fire=1 ,hot=2},
    drop = '',
    walkable = false,
    buildable_to = false,
    damage_per_second = 4,
    after_place_node = function(pos, placer)
        fire.on_flame_add_at(pos)
    end,

    after_dig_node = function(pos, oldnode, oldmetadata, digger)
        fire.on_flame_remove_at(pos)
    end,
    on_timer = fire.onnodetimer,
    node_box = {
    type = "fixed",
    fixed = {
             { 0.45,  -0.5, -0.5,   0.5, 0.5,   0.5},  -- right
            }
    },

})


minetest.register_node("fire:flame_xm_only", {
    description = "Fire",
    drawtype = "nodebox",
    tiles = {{
        name="fire_basic_flame_animated.png",
        animation={type="vertical_frames", aspect_w=16, aspect_h=16, length=1},
    }},
    inventory_image = "fire_basic_flame.png",
    light_source = 14,
    groups = {igniter=2,dig_immediate=3,fire=1 ,hot=2},
    drop = '',
    walkable = false,
    buildable_to = false,
    damage_per_second = 4,
    after_place_node = function(pos, placer)
        fire.on_flame_add_at(pos)
    end,

    after_dig_node = function(pos, oldnode, oldmetadata, digger)
        fire.on_flame_remove_at(pos)
    end,
    on_timer = fire.onnodetimer,
    node_box = {
    type = "fixed",
    fixed = {
             { -0.5,  -0.5, -0.5, -0.45, 0.5,   0.5},  -- left
            }
    },
})


minetest.register_node("fire:flame_zp_only", {
    description = "Fire",
    drawtype = "nodebox",
    tiles = {{
        name="fire_basic_flame_animated.png",
        animation={type="vertical_frames", aspect_w=16, aspect_h=16, length=1},
    }},
    inventory_image = "fire_basic_flame.png",
    light_source = 14,
    groups = {igniter=2,dig_immediate=3,fire=1 ,hot=2},
    drop = '',
    walkable = false,
    buildable_to = false,
    damage_per_second = 4,
    after_place_node = function(pos, placer)
        fire.on_flame_add_at(pos)
    end,

    after_dig_node = function(pos, oldnode, oldmetadata, digger)
        fire.on_flame_remove_at(pos)
    end,
    on_timer = fire.onnodetimer,
    node_box = {
    type = "fixed",
    fixed = {
             { -0.5,  -0.5, 0.45,   0.5, 0.5,   0.5},  -- upper
            }
    },
})


minetest.register_node("fire:flame_zm_only", {
    description = "Fire",
    drawtype = "nodebox",
    tiles = {{
        name="fire_basic_flame_animated.png",
        animation={type="vertical_frames", aspect_w=16, aspect_h=16, length=1},
    }},
    inventory_image = "fire_basic_flame.png",
    light_source = 14,
    groups = {igniter=2,dig_immediate=3,fire=1 ,hot=2},
    drop = '',
    walkable = false,
    buildable_to = false,
    damage_per_second = 4,
    after_place_node = function(pos, placer)
        fire.on_flame_add_at(pos)
    end,

    after_dig_node = function(pos, oldnode, oldmetadata, digger)
        fire.on_flame_remove_at(pos)
    end,
    on_timer = fire.onnodetimer,
    node_box = {
    type = "fixed",
    fixed = {
             { -0.5,  -0.5, -0.5,   0.5, 0.5, -0.45},  -- bottom
            }
    },
})


minetest.register_node("fire:flame_normal", {
    description = "Fire",
    drawtype = "firelike",
    tiles = {{
        name="fire_basic_flame_animated.png",
        animation={type="vertical_frames", aspect_w=16, aspect_h=16, length=1},
    }},
    inventory_image = "fire_basic_flame.png",
    light_source = 14,
    groups = {igniter=2,dig_immediate=3,fire=1 ,hot=2},
    drop = '',
    walkable = false,
    buildable_to = false,
    damage_per_second = 4,
    after_place_node = function(pos, placer)
        fire.on_flame_add_at(pos)
        minetest.get_node_timer(pos):start(0)
    end,

    after_dig_node = function(pos, oldnode, oldmetadata, digger)
        fire.on_flame_remove_at(pos)
    end,

    on_timer = fire.onnodetimer,
})

function fire.get_area_p0p1(pos)
    local p0 = {
        x=math.floor(pos.x/fire.D)*fire.D,
        y=math.floor(pos.y/fire.D)*fire.D,
        z=math.floor(pos.z/fire.D)*fire.D,
    }
    local p1 = {
        x=p0.x+fire.D-1,
        y=p0.y+fire.D-1,
        z=p0.z+fire.D-1
    }
    return p0, p1
end

function fire.update_sounds_around(pos)
    local p0, p1 = fire.get_area_p0p1(pos)
    local cp = {x=(p0.x+p1.x)/2, y=(p0.y+p1.y)/2, z=(p0.z+p1.z)/2}
    local flames_p = minetest.find_nodes_in_area(p0, p1, {"group:fire"})
    --print("number of flames at "..minetest.pos_to_string(p0).."/"
    --      ..minetest.pos_to_string(p1)..": "..#flames_p)
    local should_have_sound = (#flames_p > 0)
    local wanted_sound = nil
    if #flames_p >= 9 then
        wanted_sound = {name="fire_large", gain=1.5}
    elseif #flames_p > 0 then
        wanted_sound = {name="fire_small", gain=1.5}
    end
    local p0_hash = minetest.hash_node_position(p0)
    local sound = fire.sounds[p0_hash]
    if not sound then
        if should_have_sound then
            fire.sounds[p0_hash] = {
                handle = minetest.sound_play(wanted_sound, {pos=cp, loop=true}),
                name = wanted_sound.name,
            }
        end
    else
        if not wanted_sound then
            minetest.sound_stop(sound.handle)
            fire.sounds[p0_hash] = nil
        elseif sound.name ~= wanted_sound.name then
            minetest.sound_stop(sound.handle)
            fire.sounds[p0_hash] = {
                handle = minetest.sound_play(wanted_sound, {pos=cp, loop=true}),
                name = wanted_sound.name,
            }
        end
    end
end

function fire.on_flame_add_at(pos)
    --print("flame added at "..minetest.pos_to_string(pos))
    fire.update_sounds_around(pos)
end

function fire.on_flame_remove_at(pos)
    --print("flame removed at "..minetest.pos_to_string(pos))
    fire.update_sounds_around(pos)
end

function fire.find_pos_for_flame_around(pos)
    return minetest.find_node_near(pos, 1, {"air"})
end

function fire.flame_should_extinguish(pos)
    --return minetest.find_node_near(pos, 1, {"group:puts_out_fire"})
    local po = {x=pos.x, y=pos.y-1, z=pos.z}
    local nether = minetest.get_node(po).name

    if nether:find('nether:rack') then return false end
    local p0 = {x=pos.x-2, y=pos.y, z=pos.z-2}
    local p1 = {x=pos.x+2, y=pos.y, z=pos.z+2}
    local ps = minetest.find_nodes_in_area(p0, p1, {"group:puts_out_fire"})
  --  print('fuck!')
    return (#ps ~= 0)
end

-- Ignite neighboring nodes
minetest.register_abm({
    nodenames = {"group:flammable"},
    neighbors = {"group:igniter"},
    interval = 1,
    chance = 3,
    action = function(p0, node, _, _)
        -- If there is water or stuff like that around flame, don't ignite
        if fire.flame_should_extinguish(p0) then
            return
        end
        local p = fire.find_pos_for_flame_around(p0)
        if p then
            fire.onnodetimer(p,0)
        end
    end,
})

-- Rarely ignite things from far
minetest.register_abm({
    nodenames = {"group:igniter"},
    neighbors = {"air"},
    interval = 4,
    chance = 10,
    action = function(p0, node, _, _)
        local reg = minetest.registered_nodes[node.name]
        if not reg or not reg.groups.igniter or reg.groups.igniter < 2 then
            return
        end
        local d = reg.groups.igniter
        local p = minetest.find_node_near(p0, d, {"group:flammable"})
        if p then
            -- If there is water or stuff like that around flame, don't ignite
            if fire.flame_should_extinguish(p) then
                return
            end
            local p2 = fire.find_pos_for_flame_around(p)
            if p2 then
                minetest.set_node(p2, {name="fire:flame_normal"})
                fire.on_flame_add_at(p2)
            end
        end
    end,
})

-- Remove flammable nodes and flame
minetest.register_abm({
    nodenames = {"group:fire"},
    interval = 1,
    chance = 2,
    action = function(p0, node, _, _)        -- If there is water or stuff like that around flame, remove flame
        local po={x=p0.x, y=p0.y-1, z=p0.z}
        local uzel=minetest.get_node(po)
        if uzel and uzel.name and uzel.name:find('nether:rack') then
           return
        end
        if fire.flame_should_extinguish(p0) then
            minetest.remove_node(p0)
            fire.on_flame_remove_at(p0)
            return
        end
        -- Make the following things rarer
        if math.random(1,3) == 1 then
            return
        end
        -- If there are no flammable nodes around flame, remove flame
        if not minetest.find_node_near(p0, 1, {"group:flammable"}) then
            minetest.remove_node(p0)
            fire.on_flame_remove_at(p0)
            return
        end
        if math.random(1,4) == 1 then
            -- remove a flammable node around flame
            local p = minetest.find_node_near(p0, 1, {"group:flammable"})
            if p then
                -- If there is water or stuff like that around flame, don't remove
                if fire.flame_should_extinguish(p0) then
                    return
                end
                minetest.remove_node(p)
                nodeupdate(p)
            end
        else
            -- remove flame
            minetest.remove_node(p0)
            fire.on_flame_remove_at(p0)
        end
    end,
})

print('[OK] Fire (4aiman\'s version) loaded')

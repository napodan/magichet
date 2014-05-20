-- Minetest 0.4 mod: player
-- See README.txt for licensing and other information.

--[[

API
---

default.player_register_model(name, def)
^ Register a new model to be used by players.
^ <name> is the model filename such as "character.x", "foo.b3d", etc.
^ See Model Definition below for format of <def>.

default.registered_player_models[name]
^ See Model Definition below for format.

default.player_set_model(player, model_name)
^ <player> is a PlayerRef.
^ <model_name> is a model registered with player_register_model.

default.player_set_animation(player, anim_name [, speed])
^ <player> is a PlayerRef.
^ <anim_name> is the name of the animation.
^ <speed> is in frames per second. If nil, default from the model is used

default.player_set_textures(player, textures)
^ <player> is a PlayerRef.
^ <textures> is an array of textures
^ If <textures> is nil, the default textures from the model def are used

default.player_get_animation(player)
^ <player> is a PlayerRef.
^ Returns a table containing fields "model", "textures" and "animation".
^ Any of the fields of the returned table may be nil.

Model Definition
----------------

model_def = {
    animation_speed = 30, -- Default animation speed, in FPS.
    textures = {"character.png", }, -- Default array of textures.
    visual_size = {x=1, y=1,}, -- Used to scale the model.
    animations = {
        -- <anim_name> = { x=<start_frame>, y=<end_frame>, },
        foo = { x= 0, y=19, },
        bar = { x=20, y=39, },
        -- ...
    },
}

]]

-- Player animation blending
-- Note: This is currently broken due to a bug in Irrlicht, leave at 0
local animation_blend = 0

default.registered_player_models = { }

-- Local for speed.
local models = default.registered_player_models

function default.player_register_model(name, def)
    models[name] = def
end

-- Default player appearance
default.player_register_model("character.x", {
    animation_speed = 30,
    textures = {
        "character.png",
        "3d_armor_trans.png",
        "3d_armor_trans.png",
    },
    animations = {
        stand =     {x=0,   y=79},
        lay =       {x=162, y=166},
        walk =      {x=168, y=187},
        mine =      {x=189, y=198},
        walk_mine = {x=200, y=219},
        sit =       {x=81,  y=160},
    },
})


-- Player stats and animations
local player_model = {}
local player_textures = {}
local player_anim = {}
local player_sneak = {}

function default.player_get_animation(player)
    local name = player:get_player_name()
    return {
        model = player_model[name],
        textures = player_textures[name],
        animation = player_anim[name],
    }
end

-- Called when a player's appearance needs to be updated
function default.player_set_model(player, model_name)
    local name = player:get_player_name()
    local model = models[model_name]
    if model then
        if player_model[name] == model_name then
            return
        end
        player:set_properties({
            mesh = model_name,
            textures = player_textures[name] or model.textures,
            visual = "mesh",
            visual_size = model.visual_size or {x=1, y=1},
        })
        default.player_set_animation(player, "stand")
    else
        player:set_properties({
            textures = { "player.png", "player_back.png", },
            visual = "upright_sprite",
        })
    end
    player_model[name] = model_name
end

function default.player_set_textures(player, textures)
    local name = player:get_player_name()
    player_textures[name] = textures
    player:set_properties({textures = textures,})
end

function default.player_set_animation(player, anim_name, speed)
    local name = player:get_player_name()
    if player_anim[name] == anim_name then
        return
    end
    local model = player_model[name] and models[player_model[name]]
    if not (model and model.animations[anim_name]) then
        return
    end
    local anim = model.animations[anim_name]
    player_anim[name] = anim_name
    player:set_animation(anim, speed or model.animation_speed, animation_blend)
end


default.player_inv_widths = {}

-- workaround till get_width gets fixed
function default.player_get_inv_width(pll)
   if not default.player_inv_widths[pll] then default.player_inv_widths[pll] = 9 end
   return default.player_inv_widths[pll]
end
function default.player_set_inv_width(pll,width)
   default.player_inv_widths[pll] = width
end



-- Update appearance when the player joins
minetest.register_on_joinplayer(function(player)
    local inv = player:get_inventory()
    local pll = player:get_player_name()

    default.player_set_model(player, "character.x")
    default.player_set_inv_width(pll,9)


    -- MC-like inventory:
        player:set_inventory_formspec(
            "size[9,8.5;true]"..
            "bgcolor[#bbbbbb;false]"..
            "listcolors[#777777;#cccccc;#333333;#555555;#dddddd]"..
            --"size[9,12.5;]"..
            --"list[detached:"..pll.."_sort;main;0,9.0;9,4]"..

            --"bgcolor[#aa000000;true]"..
            --"background[0,0;9.5,8.5;workbench_bg2.png;autoclip]"..
            "list[current_player;craft;5,1.0;2,1;1]"..
            "list[current_player;craft;5,2.0;2,1;4]"..

            "list[current_player;craftpreview;8,1.5;1,1;]"..

            "list[current_player;helm;0,0;1,1;]"..
            "list[current_player;torso;0,1;1,1;]"..
            "list[current_player;pants;0,2;1,1;]"..
            "list[current_player;boots;0,3;1,1;]"..

            "list[current_player;main;0,4.5;9,3;9]"..
            "list[current_player;main;0,7.7;9,1;]"..

            "button[6.6,-0.0;0.8,0.5;sort_horz;=]"..
            "button[7.4,-0.0;0.8,0.5;sort_vert;||]"..
            "button[8.2,-0.0;0.8,0.5;sort_norm;Z]"..
            -- craft guide
            "image_button[1,0;1,1;inventory_plus_zcg.png;zgc;]"            
        )

        -- common lists
        inv:set_width("craft", 3)
        inv:set_size("craft", 9)
        inv:set_size("main", 9*4)
        -- armour lists
        inv:set_size("helm", 1)
        inv:set_size("torso", 1)
        inv:set_size("pants", 1)
        inv:set_size("boots", 1)

    player:hud_set_hotbar_itemcount(9)

    -- sort inventory:
    local sinv=minetest.create_detached_inventory(pll..'_sort')
    -- do this EVERY time the size changes!!!
    sinv:set_size("main", inv:get_size("main"))
end)

-- Inv. tweak buttons
default.sort_inv = function(player, formname, fields, pos)
    -- sort horizontally
    if fields.sort_horz then
       print(pll..' sorts inventory =')
       local inv = player:get_inventory()
       local pll = player:get_player_name()
       local sinv = minetest.get_inventory({type="detached", name=pll..'_sort'})
       if inv and sinv then
          local width = default.player_get_inv_width(pll)
          local height = math.ceil(inv:get_size("main")/width)
          for i=1,height do
              local sbinv=minetest.create_detached_inventory(pll..'_sort_')
              sbinv:set_size("n",width)
              for j=1, width do
                  local stack = inv:get_stack("main", (i-1)*width+j)
                  sbinv:add_item("n",stack)
              end
              for j=1, width do
                  local stack = sbinv:get_stack("n", j)
                  inv:set_stack("main", (i-1)*width+j,stack)
              end
              sbinv=nil
          end
       end
   -- sort vertically
    elseif fields.sort_vert then
       print(pll..' sorts inventory ||')
       local inv = player:get_inventory()
       local pll = player:get_player_name()
       local sinv = minetest.get_inventory({type="detached", name=pll..'_sort'})
       if inv and sinv then
          local width = default.player_get_inv_width(pll)
          local height = math.ceil(inv:get_size("main")/width)
          for j=1,width do
              local sbinv=minetest.create_detached_inventory(pll..'_sort_')
              sbinv:set_size("n",height)
              for i=2, height do
                  local stack = inv:get_stack("main", (i-1)*width+j)
                  sbinv:add_item("n",stack)
              end
              for i=2, height do
                  local stack = sbinv:get_stack("n", i-1)
                  inv:set_stack("main", (i-1)*width+j,stack)
              end
              sbinv=nil
          end
       end
    -- sort in "Z" shape
    elseif fields.sort_norm then
       print(pll..' sorts inventory Z')
       local inv = player:get_inventory()
       local pll = player:get_player_name()
       local sinv = minetest.get_inventory({type="detached", name=pll..'_sort'})
       if inv and sinv then
          local width = default.player_get_inv_width(pll)
          local height = math.ceil(inv:get_size("main")/width)
              for i=1,height do
                  for j=1,width do
                      local stack = sinv:get_stack("main",(i-1)*width+j)
                      stack:clear()
                      sinv:set_stack("main",(i-1)*width+j,stack)
                  end
              end
              for i=2,height do
                  for j=1,width do
                      local stack = inv:get_stack("main",(i-1)*width+j)
                      sinv:add_item("main",stack)
                  end
               end
              for i=1,height do
                  for j=1,width do
                      local stack = sinv:get_stack("main",(i-1)*width+j)
                      inv:set_stack("main",(i)*width+j,stack)
                  end
              end
        end
    elseif fields.quit then
       if pos then
          -- drop down a workbench's inventory
           if minetest.get_node(pos).name=='default:workbench' then
              local inv = player:get_inventory()
              local pll = player:get_player_name()
              pos.y=pos.y+1
              if not minetest.get_node(pos).name=='air' then
                 pos = minetest.find_node_near(pos, 1, {'air','default:water_source','default:water_flowing','bucket:CO2_source','bucket:CO2_flowing','oil:oil_source','oil:oil_flowing','group:liquid'})
              end
              for i=1,inv:get_size("craft") do
                  local stack = inv:get_stack("craft",i)
                  if pos and stack and not stack:is_empty() then
                      local itm = minetest.add_item(pos, stack)
                      math.randomseed(os.time())
                      itm:setvelocity({x=math.random()*math.random(-1,1),y=math.random()*math.random(0,2),z=math.random()*math.random(-1,1)})
                      stack:clear()
                      inv:set_stack("craft",i,stack)
                  end
              end
           end
       end

      -- disable furnace interface if player has quitted
       if formname:find('default:furnace') then
          local pos = minetest.deserialize(string.split(formname,'_')[2])
          print(minetest.pos_to_string(pos))
          meta = minetest.get_meta(pos)
          meta:set_string("pll","")
          minetest.get_node_timer(pos):stop()
       end

      -- close 3dchests at pos
           if formname:find('default:3dchest') then
              local pos = minetest.deserialize(string.split(formname,'_')[2])
              local objs = minetest.get_objects_inside_radius(pos, 0.1)
              for i,obj in ipairs(objs) do
                  if not obj:is_player() then
                     local self = obj:get_luaentity()
                     if self.name == 'default:3dchest' then
                        self.object:set_animation({x=25,y=40}, 60, 0)
                        minetest.sound_play('chestclosed', {pos = pos, gain = 0.3, max_hear_distance = 5})
                        minetest.after(0.1, function(dtime)
                           self.object:set_animation({x=1,y=1}, 1, 0)
                        end)

                     end
                  end
              end
           end

    end
end

minetest.register_on_player_receive_fields(function(player, formname, fields,pos)
  if player and player:is_player() then     
     if fields.zgc then 
        local pll = player:get_player_name()
        minetest.show_formspec(pll, 'zgc_'..pll, zcg.formspec(pll)) 
        return true 
     end
     default.sort_inv(player,formname,fields,pos)
     return true
  end  
end)

minetest.register_on_leaveplayer(function(player)
    local name = player:get_player_name()
    player_model[name] = nil
    player_anim[name] = nil
    player_textures[name] = nil
end)

-- Localize for better performance.
local player_set_animation = default.player_set_animation

-- Check each player and apply animations
minetest.register_globalstep(function(dtime)
    for _, player in pairs(minetest.get_connected_players()) do
        local name = player:get_player_name()
        local model_name = player_model[name]
        local model = model_name and models[model_name]
        if model then
            local controls = player:get_player_control()
            local walking = false
            local animation_speed_mod = model.animation_speed or 30

                        if isghost and isghost[name] then animation_speed_mod = animation_speed_mod / 2 end

            -- Determine if the player is walking
            if controls.up or controls.down or controls.left or controls.right then

                walking = true
            end

            -- Determine if the player is sneaking, and reduce animation speed if so
            if controls.sneak then
                                if isghost and isghost[name] then animation_speed_mod = animation_speed_mod / 3
                                else
                animation_speed_mod = animation_speed_mod / 2
                                end
            end

            -- Apply animations based on what the player is doing
            if player:get_hp() == 0 then
                player_set_animation(player, "lay")
            elseif walking then
                if player_sneak[name] ~= controls.sneak then
                    player_anim[name] = nil
                    player_sneak[name] = controls.sneak
                end
                if controls.LMB then
                                        if isghost and isghost[name] then player_set_animation(player, "mine")
                                        else
                    player_set_animation(player, "walk_mine", animation_speed_mod)
                                        end
                else
                                        if isghost and isghost[name] then player_set_animation(player, "stand")
                                        else
                    player_set_animation(player, "walk", animation_speed_mod)
                                        end
                end
            elseif controls.LMB then
                player_set_animation(player, "mine")
            else
                player_set_animation(player, "stand", animation_speed_mod)
            end
        end
    end
end)

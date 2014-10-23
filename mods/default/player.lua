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
default.player_model = {}
default.player_textures = {}
default.player_anim = {}
default.player_sneak = {}
default.player_sleep = {}
-- contains only multipliers for default 1 1 1
default.player_physics = {}
-- would add speed, grav & jump
default.player_status = {}
default.player_vw = {}
default.player_lpos = {}
default.everyhud = {} -- keeps track of ALL huds

-- overrides physics of a player and STORES the values
function default.ph_override(player, ph)
   local pll = player:get_player_name()
   for k,v in pairs(ph) do
       default.player_physics[pll][k] = v
   end
   player:set_physics_override(default.player_physics[pll])
--   print(minetest.serialize(default.player_physics[pll]))
end

function default.player_get_animation(player)
    local name = player:get_player_name()
    return {
        model = default.player_model[name],
        textures = default.player_textures[name],
        animation = default.player_anim[name],
    }
end

-- Called when a player's appearance needs to be updated
function default.player_set_model(player, model_name)
    local name = player:get_player_name()
    local model = models[model_name]
    if model then
        if default.player_model[name] == model_name then
            return
        end
        player:set_properties({
            mesh = model_name,
            textures = default.player_textures[name] or model.textures,
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
    default.player_model[name] = model_name
end

function default.player_set_textures(player, textures)
    local name = player:get_player_name()
    default.player_textures[name] = textures
    player:set_properties({textures = textures,})
end

function default.player_set_animation(player, anim_name, speed)
    local name = player:get_player_name()
    if default.player_anim[name] == anim_name then
        return
    end
    local model = default.player_model[name] and models[default.player_model[name]]
    if not (model and model.animations[anim_name]) then
        return
    end
    local anim = model.animations[anim_name]
    default.player_anim[name] = anim_name
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


default.default_pl_fs = "size[9,8.5;true]"..
            "bgcolor[#bbbbbb;false]"..
            "listcolors[#777777;#cccccc;#333333;#555555;#dddddd]"..

            "list[current_player;craft;5,1.0;2,1;1]"..
            "list[current_player;craft;5,2.0;2,1;4]"..
            "list[current_player;craftpreview;8,1.5;1,1;]"..

            "list[current_player;helm;0,0;1,1;]"..
            "list[current_player;torso;0,1;1,1;]"..
            "list[current_player;pants;0,2;1,1;]"..
            "list[current_player;boots;0,3;1,1;]"..

            "list[current_player;main;0,4.5;9,3;9]"..
            "list[current_player;main;0,7.7;9,1;]"..


            "image_button[9.0,-0.3;0.80,1.7;b_bg2.png;just_bg;Z;true;false]"..
            "image_button[9.2,-0.2;0.5,0.5;b_bg.png;sort_horz;=;true;true]"..
            "image_button[9.2,0.3;0.5,0.5;b_bg.png;sort_vert;||;true;true]"..
            "image_button[9.2,0.8;0.5,0.5;b_bg.png;sort_norm;Z;true;true]"..
            -- craft guide
            "image_button[1,0;1,1;inventory_plus_zcg.png;zgc;]"


default.statuses = {}

function default.load_statuses()
local input = io.open(minetest.get_worldpath().."/player_statuses.lua", "r")
   if input then
      io.close(input)
      dofile(minetest.get_worldpath().."/player_statuses.lua")
   end
end

-- load statuses
default.load_statuses()

function default.save_statuses()
    local output = io.open(minetest.get_worldpath().."/player_statuses.lua", "w")
    if output then
       o  = minetest.serialize(default.statuses)
       i  = string.find(o, "return")
       o1 = string.sub(o, 1, i-1)
       o2 = string.sub(o, i-1, -1)
       output:write(o1 .. "\n")
       output:write("default.statuses = minetest.deserialize('" .. o2 .. "')\n")
       io.close(output)
    end
end

function default.init_status(pll)
    default.statuses[pll] = {}
    default.statuses[pll].speed = 0 -- +20%\15% per level
    default.statuses[pll].add_damage = 0 -- x1.3\x0.75 per level
    default.statuses[pll].heal = 0 -- adds\subs 3 hp per level
    default.statuses[pll].jump = 0 -- +0.5\-0.1 node per level, fall tolerance +1
    default.statuses[pll].wobble = false -- is wobble hud enabled?
    default.statuses[pll].regen = 0 -- 1 hp per level per sec
    default.statuses[pll].proof = 0 -- reduce\increase taken damage by 20%\15% per level
    default.statuses[pll].diggin = 0 -- de\in~crease digging times by 20%\15% per level
    default.statuses[pll].lava_damage = 0 -- +X damage by lava\fire
    default.statuses[pll].aqualung = 0 -- + 5 secs per level underwater
    default.statuses[pll].nv = 0 -- +\- 0.3 light per level
    default.statuses[pll].hunger = 0 -- +\-0.0025 food_exaustion\food_points per tick per level
    default.statuses[pll].poison = 0 -- X*1hp per 25 ticks, can't kill
    default.statuses[pll].wither = 0 -- X*1hp per 40 ticks, CAN kill
    default.statuses[pll].health_boost = 0 -- +X hearts max
    default.statuses[pll].atack = false
end

-- Update appearance when the player joins
minetest.register_on_joinplayer(function(player)

    local inv = player:get_inventory()
    local pll = player:get_player_name()

    if not default.statuses[pll] then
       default.init_status(pll)
    end

    default.player_physics[pll] = {}
    default.ph_override(player,{speed = 1, gravity = 1, jump = 1, sneak = true, sneak_glitch = false})

    default.player_vw[pll] = 0
    default.player_lpos[pll] = player:getpos()
    default.player_lpos[pll].y = default.player_lpos[pll].y -1

    default.player_status[pll] = {fall = 0,}
    -- default status is NO statuses at all
    default.player_status[pll] = {}

    default.player_set_model(player, "character.x")
    default.player_set_inv_width(pll,9)


    -- MC-like inventory:
        player:set_inventory_formspec(default.default_pl_fs)

        -- common lists
        inv:set_width("craft", 3)
        inv:set_size("craft", 9)
        inv:set_size("main", 9*4)
        inv:set_size("wormhole", 9*3)
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

-- Inv. tweak buttons & events
default.sort_inv = function(player, formname, fields, pos)
    -- sort horizontally
    if fields.sort_horz then
       local inv = player:get_inventory()
       local pll = player:get_player_name()
       --print(pll..' sorts inventory =')
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
       local inv = player:get_inventory()
       local pll = player:get_player_name()
       --print(pll..' sorts inventory ||')
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
       local inv = player:get_inventory()
       local pll = player:get_player_name()
       --print(pll..' sorts inventory Z')
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
       if formname == '' then
          pos = player:getpos()
       end
       if pos then
          -- drop down a workbench's inventory
           if minetest.get_node(pos).name=='default:workbench' or formname=='' then
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
          meta = minetest.get_meta(pos)
          local new_meta=''
          local old_meta=string.split(meta:get_string('pll'),';')
          local pll = player:get_player_name()
          for _,name in ipairs(old_meta) do
             if name~=pll then
                -- add a separator if needed
                if #new_meta>0 then new_meta=new_meta..';' end
                --add name
                new_meta=new_meta+name
             end
          end
          meta:set_string("pll",new_meta)
          minetest.get_node_timer(pos):stop()
       end

      -- close 3dchests at pos
           if formname:find('default:3dchest') then
              local pos = minetest.deserialize(string.split(formname,'_')[2])
              if not pos then return end
              local objs = minetest.get_objects_inside_radius(pos, 0.1)
              for i,obj in ipairs(objs) do
                  if not obj:is_player() then
                     local self = obj:get_luaentity()
                     if self.name == 'default:3dchest'
                     or self.name == 'default:3dchest2'
                     or self.name == 'default:3dchest3'
                     or self.name == 'default:3dchest4' then
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

    if formname:find('default:3dchest2') then
           if fields.open then
              local pll = player:get_player_name()
              local pos = minetest.deserialize(string.split(formname,'_')[2])
              local meta = minetest.env:get_meta(pos)
              local locked = meta:get_int('locked')
              if default.has_locked_chest_privilege(meta,player) then
                    if   locked == 0
                    then locked = 1
                    else locked = 0
                    end
                    meta:set_int('locked',locked)
                    local fs = default.get_locked_chest_formspec(pos)
                    meta:set_string("formspect", fs)
                    minetest.show_formspec(pll, formname, fs)
              else
                  if locked == 1 then
                     minetest.chat_send_player(player:get_player_name(),'Don\'t you try to get other people\'s stuff!')
                  end
              end
           end
    elseif formname:find('default:3dchest3') then
           local pll = player:get_player_name()
           local pos = minetest.deserialize(string.split(formname,'_')[2])
           local meta = minetest.env:get_meta(pos)
           if default.has_shared_chest_privilege(meta, player) then
              local locked = meta:get_int('locked')
              if fields.open then
                 if   locked == 0
                 then locked = 1
                 else locked = 0
                 end
                 meta:set_int('locked',locked)
                 local fs =  default.get_shared_chest_formspec(pos)
                 meta:set_string("formspect", fs)
                 minetest.show_formspec(pll, formname, fs)
              end
           else
               if locked == 1 then
                  minetest.chat_send_player(player:get_player_name(),'Don\'t you try to get other people\'s stuff!')
               end
           end
           if default.has_locked_chest_privilege(meta,player) then
              if fields.add then
                 local shared = minetest.deserialize(meta:get_string('shared'))
                 if shared and not shared.user and fields.user~='' then
                    table.insert(shared,fields.user)
                    meta:set_string('shared', minetest.serialize(shared))
                    local fs =  default.get_shared_chest_formspec(pos)
                    meta:set_string("formspect", fs)
                    minetest.show_formspec(pll, formname, fs)
                 end
              end
              if fields.rem then
                 local list = fields.list
                 local shared = minetest.deserialize(meta:get_string('shared'))
                 if shared and not shared.user then
                    table.remove(shared,list)
                    meta:set_string('shared', minetest.serialize(shared))
                    local fs =  default.get_shared_chest_formspec(pos)
                    meta:set_string("formspect", fs)
                    minetest.show_formspec(pll, formname, fs)
                 end
                 minetest.show_formspec(pll, 'chest', meta:get_string("formspect"))
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
    default.player_model[name] = nil
    default.player_anim[name] = nil
    default.player_textures[name] = nil
end)

-- Localize for better performance.
local player_set_animation = default.player_set_animation

-- distance finder
function default.distance(pos1,pos2)
    if not pos1 or not pos2 then
       return 0
    end
    return math.abs(pos1.y - pos2.y)
end

-- Check each player and apply animations
minetest.register_globalstep(function(dtime)
    for _, player in pairs(minetest.get_connected_players()) do
        local pll = player:get_player_name()
        local posn = player:getpos()
        local poso = default.player_lpos[pll]
        posn.y = posn.y-0.5
        local node1,node2 = minetest.get_node(poso).name, minetest.get_node(posn).name

        if node1 == 'air' then
            if node2 == 'air' then
               if poso.y>posn.y
               then
                  default.player_vw[pll] = default.player_vw[pll]+default.distance(poso, posn)
               else
                  default.player_vw[pll] = 0
               end
            else
               local wn = 0
               local below = {x=posn.x, y=posn.y, z=posn.z}
               while minetest.get_node(below).name:find('water') do
                     below.y=below.y-1
                     wn = wn+1
               end
               local gr
               local ph = default.player_physics[pll]
               if ph then
                  gr = 1/default.player_physics[pll].gravity
               end
               local fall_tolerance = 3+wn*10+(default.player_status[pll].fall or gr or 0)
                  -- if not a ghost and fell from some high place..
                  if default.player_vw[pll]>fall_tolerance and not isghost[pll] then
                     player:set_hp(player:get_hp()- math.floor(default.player_vw[pll])+3)
                  end
                  --print('felt down from ' .. default.player_vw[pll] .. ' nodes.')
                  -- ToDo: need to disable fall damage in the engine
                  default.player_vw[pll] = 0

            end
        else
            default.player_vw[pll] = 0
        end
        default.player_lpos[pll] = posn

        local model_name = default.player_model[pll]
        local model = model_name and models[model_name]
        if model then
            local controls = player:get_player_control()
            local walking = false
            local animation_speed_mod = model.animation_speed or 30

            if default.player_sleep[pll] then
               if controls.jump and not controls.RMB then
                  beds.remove_from_bed(player)
                  player_set_animation(player, "walk", 30)
                  local ph = default.player_physics[pll]
                  default.ph_override(player,{speed = 1, jump = 1})
                  default.player_sleep[pll] = nil
                  --print('walk')
               else
                  player_set_animation(player, "lay", 0)
                  local ph = default.player_physics[pll]
                  default.ph_override(player,{speed = 0, jump = 0})
                  --print('sleep')
                  controls = nil
               end
            end

            if controls then
               -- slow down if pll is a ghost
               if isghost and isghost[pll] then animation_speed_mod = animation_speed_mod / 2 end

               -- Determine if the player is walking
               if controls.up or controls.down or controls.left or controls.right then
                  walking = true
               end

                -- Determine if the player is sneaking, and reduce animation speed if so
                if controls.sneak then
                   if isghost and isghost[pll]
                   then animation_speed_mod = animation_speed_mod / 3
                   else animation_speed_mod = animation_speed_mod / 2
                   end
                end

                -- Apply animations based on what the player is doing
                if player:get_hp() == 0 then
                    player_set_animation(player, "lay")
                elseif walking then
                    if default.player_sneak[pll] ~= controls.sneak then
                        default.player_anim[pll] = nil
                        default.player_sneak[pll] = controls.sneak
                    end
                    if controls.LMB then
                       if isghost and isghost[pll] then
                            player_set_animation(player, "mine")
                       else
                            player_set_animation(player, "walk_mine", animation_speed_mod)
                       end
                    else
                        if isghost and isghost[pll] then
                             player_set_animation(player, "stand")
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
    end
end)

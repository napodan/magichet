------------------------
-- adbs mod by 4aiman --
------------------------
--
--   Licence: GPLv3   --
--                    --
------------------------

--[[
This mod adds mobs. Yep, "adbs" stands for "ADvanced moBS".
This implementation is heavily influenced by PilzAdam's "simple mobs"
(a.k.a. "mobs") mod, but was re-coded from scratch.

Most notable changes are:
+ flyings mobs
+ jumping mobs
+ punches throws back mobs
+ faster choices thanks to change of type of state-holding variables
+ faster on_step thanks to deletion of unnecessary checks
+ even more CPU-time saving thanks to "busy" status
+ ease of adding new mobs
+ ID for every mob
+ environmental damage make mobs run forward in agony
+ breeding
+ childish ties
+ following algo
+ colorful sheep
+ spawn-rate control
+ more settings for spawn abm (tepm, humidity, etc)

]]

math.randomseed(os.time())
math.random(1,100)

local adbs = {}

adbs.ids = {[0] = 'dummy'}                                                           -- helps counting mobs, {[id1] =  obj, [id2] =  obj, ... [idn] =  obj}}

adbs.spawning_mobs = {}                                                 -- list of names that can be spawned (NOT used ATM)
adbs.registered_mobs = {}
adbs.max_count = {}                                                     -- max. amount of spawned mobs; set this to -1 to disable the limit

-- to be filled when register a mob!
adbs.max_count.test = 20

adbs.max_count.cow=20
adbs.max_count.cattle=20
adbs.max_count.sheep=20
adbs.max_count.lamb=20
adbs.max_count.pig=20
adbs.max_count.pigglet=20
adbs.max_count.chicken=20
adbs.max_count.chick=20

adbs.max_count.wormhole=20
adbs.max_count.batman=20
adbs.max_count.birdie=20
adbs.max_count.flame=20                                                 -- nether
adbs.max_count.oxy=20                                                   -- nether
adbs.max_count.wolf=20
adbs.max_count.werewolf=20                                              -- can be tamed, but will go berserk at night; looks just like normal wolf ~_~
adbs.max_count.spirit=20
adbs.max_count.villain=20                                               -- some history of English language for ya
adbs.max_count.test2=20
adbs.max_count.test=20

adbs.spawn_control = false                                             -- set this to false to disable spawn control


function adbs.can_spawn(name)                                                -- counts existing mobs of a kind and tell if there's still "space" for more
    if not adbs.spawn_control then return true end                      -- force it return "true" if spawn control was disabled
    if adbs.spawn_locked then return false end                          -- do not spawn when need to delete some mob
    local nm =name:sub(name:find(':')+1)  -- extract mob's name
    if adbs.max_count[nm] == -1 then return true end
    local cnt = 0
    for i=1,#adbs.ids do
        if adbs.ids[i] and adbs.ids[i]:get_luaentity().name == name then
           cnt = cnt + 1
        end
    end
    return cnt < adbs.max_count[nm] -- FIX DELETED!!!!
end


adbs.children={sheep='lamb',cow='cattle',chicken='chick',pig='piglet',test='test2'}
adbs.parents={lamb='sheep',cattle='cow',chick='chicken',piglet='pig',test2='test'}

adbs.colors = { [0] = 'black',
                [1] = 'blue',
                [2] = 'brown',
                [3] = 'cyan',
                [4] = 'dark_green',
                [5] = 'dark_grey',
                [6] = 'green',
                [7] = 'grey',
                [8] = 'magenta',
                [9] = 'orange',
               [10] = 'pink',
               [11] = 'red',
               [12] = 'violet',
               [13] = 'white',
               [14] = 'yellow',
               [15] = 'light_blue',
}

function adbs.color_by_name(color)
   for i,col in ipairs(adbs.colors) do
       if col == color then return i end
   end
   return 13 -- fallback to white if no matches found!
end

adbs.dd = {
         id = 0,                                                        -- ID of a mob
         hp = 10,                                                       -- default HP
         mp = 0,                                                        -- not a magic user
         st = 20,                                                       -- stamina, won't fly or run if this is <= 0
         xp = 3,                                                        -- drops 3 XP points by default
         alive = true,                                                  -- internal var to control whom to calculate
         armor = {fleshy=100},                                          -- numbers are percents of damage taken
         attack_power = 2,                                               -- attack power of a mob
         cloth = {},                                                    -- armour set
         weapon = nil,                                                  -- wisual item
         target = nil,                                                  -- attack target
         visual = "cube",                                               -- visual appearance: sprite, cube, mesh
         visual_size = {x=1,y=1,z=1},                                   -- for *.x models should be at ~5
         mesh = nil,                                                    -- name of the file with model ^
         collisionbox = {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},              -- default cube collision box
         physical = true,                                               -- non physical will pass through anything
         textures = {'default_dirt.png','default_dirt.png','default_dirt.png','default_dirt.png','default_dirt.png','default_dirt.png'},
         makes_footstep_sound = nil,                                    -- does it produce sounds when walking?
         view_range = 10,                                               -- max distance to a player to notice one
         walk_velocity = 0.8,                                           -- speed when walking/flying
         run_velocity = 1.5,                                            -- speed when running away/chasing
         light_damage = 0,                                              -- damage dealt by the sun
         water_damage = 0,                                              -- damage dealt by water
         lava_damage = 0,                                               -- damage dealt by lava
         natural_damage_timer = 0,                                      -- timer for dealing above 3 only every second (the very first hit may come anytime soon between 0..1 sec); -1 disables it
         disable_fall_damage = false,                                   -- subject to suffer from falls
         fall_tolerance = 5,                                            -- will tolerate falls off this altitude w/o getting damaged
         drop = {},                                                     -- {{name="",chance=X},{name="",chance=X},{name="",chance=X},...,{name="",chance=X}}
         mob_type = 2,                                                  -- 0 villager, 1 friendly, 2 passive, 3 hostile, 4 defender of ...
         arrow = nil,                                                   -- name of an "arrow" entity; will attack afar if set
         arrow_dist = 0,                                                -- max distance for long-shot attack; should be set if ^ was set
         shoot_interval = 0,                                            -- 0 means NOT it gonna shoot; set this up or a mob will be stupid...
         shoot_timer = 0,                                               -- 0 means NOT it gonna shoot; set this up or a mob will be stupid...
         sounds = {},                                                   -- no sounds
         animation = {},                                                -- no animations
         follow = nil,                                                  -- not following anyone
         destination = nil,                                             -- pos to go to
         attractor = nil,                                               -- an item that attracts mob (ItemString)
         horny = false,                                                 -- wanna breed?
         hornytimer = 0,                                                -- for how long?
         colouring = nil,
         color = nil,                                                   -- 0 means black ... 15 means white
         oldcolor = nil,                                                -- 0 means black ... 15 means white
         timer = 0,                                                     -- timer for delaying hungry procs execution
         damage_timer = 0,                                              -- attack timer
         hostile_timer = 0,                                             -- time before it will calm down...
         state = 1,                                                     -- -1=idle, 0=stand, 1=walk, 2=run, 3=attack, 4=jump, 5=mine, 6=mine&walk, 7 = sit
         old_pos = nil,                                                 -- old pos
         lifetimer = -1,                                               -- count no age
         tamed = false,                                                 -- was it tamed?
         path = nil,                                                    -- pathfinder!
         mother = nil,                                                  -- "mother" mob (if applicable)
         child = 0,                                                     -- time before it grows up; 0 for mature animals
         busy = false,                                                  -- business flag
         walk_time = 0,                                                 -- for how long it tries to get to dest. point?
         --walk_time_max = 1.6,                                           -- max amount it can wander
         lover_dist_max = 6,                                            -- max distance to seach for a lover
         attractor_dist_max = 5,                                        -- max distance to seach for an attractor
         horny_timer_max = 85,                                          -- time in server ticks (!); 85*dtime = ~12.5 sec
         statuses = {},                                                 -- array of applied statuses
         produce = nil,                                                 -- what does a mob produce if right-clicked?
         produce_num = 0,                                               -- how much does a mob produce?
         produce_item = nil,                                            -- what tool should one hold to make a mob produce "produce" if right-clicked? Leave nil to produce with anything.
         can_produce = true,
         produce_cooldown = 85,
         produce_textures = nil,
         produce_mesh = nil,
         auto_produce = nil,
         auto_produce_chance = 0,
         food = 8,
         food_max = 8,
         can_mount = nil,
         mounted = nil,
         status = { speed = 0, -- +20%\15% per level
                    add_damage = 0, -- x1.3\x0.75 per level
                    heal = 0, -- adds\subs 3 hp per level
                    jump = 0, -- +0.5\-0.1 node per level, fall tolerance +1
                    wobble = false, -- is wobble hud enabled?
                    regen = 0, -- 1 hp per level per sec
                    proof = 0, -- reduce\increase taken damage by 20%\15% per level
                    diggin = 0, -- de\in~crease digging times by 20%\15% per level
                    lava_damage = 0, -- +X damage by lava\fire
                    aqualung = 0, -- + 5 secs per level underwater
                    nv = 0, -- +\- 0.3 light per level
                    hunger = 0, -- +\-0.0025 food_exaustion\food_points per tick per level
                    poison = 0, -- X*1hp per 25 ticks, can't kill
                    wither = 0, -- X*1hp per 40 ticks, CAN kill
                    health_boost = 0, -- +X hearts max
                    attack = false},

         jump = function (self, height)                                 -- jump proc
                if self.state == 4 then return end
                local pos = self.object:getpos()
                pos.y=pos.y-1.5
                if minetest.get_node(pos).name == 'air' then --[[('tried to multi-jump')]] return end
                local v = self.object:getvelocity()
                if not height then height = 5 end
                   local vy = v.y
                   v.y = height
                   self.object:setvelocity(v)
                   local prev_state = self.state
                   self.state = 4
                   self:set_animation(4)
                   self.busy = true
                   minetest.after(0.5,function()
                       v.y = vy
                       self.object:setvelocity(v)
                       self.busy = false
                       self.state = prev_state                          -- prev state number EQUALS
                       self:set_animation(prev_state)                   -- to a prev_animation number
                   end)
                end,

         set_velocity = function(self, v)                               -- sets velocity w/o changing yaw
            local yaw = self.object:getyaw()
            local x = math.sin(yaw) * -v
            local z = math.cos(yaw) * v
            self.object:setvelocity({x=x, y=self.object:getvelocity().y, z=z})
         end,

         hit = function(self, obj)                                      -- pushes mob away in the direction of attacker's line of sight
             if self and obj then
                local y
                if not obj.is_player or not obj:is_player() then
                   if self.id == obj.id then                             -- if no one hits it, then it hits itself
                      y = self.object:getyaw()
                   else
                      obj = obj.object
                      y = obj:getyaw()
                   end
                else
                   y = obj:get_look_yaw()
                end
                   local x = math.cos(y) * 3  -- revert
                   local z = math.sin(y) * 3  -- values
                local vel = self.object:getvelocity()
                self.busy = true
                self.object:setvelocity({x=x, y=3, z=z})
                minetest.after(0.3,function()
                   self.object:setvelocity(vel)
                   self.busy = false
               end)
            end
         end,

         get_velocity = function(self)                                  -- gets current velocity of a mob
             local v = self.object:getvelocity()
             return (v.x^2 + v.z^2)^(0.5)
         end,

         set_animation = function(self, at)                             -- sets animation
            if not self.animation then
               return
            end
            if not self.animation.current then
               self.animation.current = -1
            end
               local ac = self.animation.current
            if at == 0 and ac ~= 0 then                                 -- stand
               if  self.animation.stand_start
               and self.animation.stand_end
               and self.animation.speed_normal
               then
                  --print('stay')
                  self.object:set_animation({x=self.animation.stand_start,y=self.animation.stand_end},self.animation.speed_normal, 0)
                  self.animation.current = 0
               end
            elseif at == 1 and ac ~= 1  then                            -- walk
               if  self.animation.walk_start
                   and self.animation.walk_end
               and self.animation.speed_normal
               then
                  --print('walk')
                  self.object:set_animation({x=self.animation.walk_start,y=self.animation.walk_end},self.animation.speed_normal, 0)
                  self.animation.current = 1
               end
            elseif at == 2 and ac ~= 2  then                            -- run
               if   self.animation.run_start
               and self.animation.run_end
               and self.animation.speed_run
               then
                  --print('run')
                  self.object:set_animation({x=self.animation.run_start,y=self.animation.run_end},self.animation.speed_run, 0)
                  self.animation.current = 2
               end
            elseif at == 3 and ac ~= 3  then                            -- attack
               if   self.animation.punch_start
               and self.animation.punch_end
               and self.animation.speed_normal
               then
                  --print('punch')
                  self.object:set_animation({x=self.animation.punch_start,y=self.animation.punch_end},self.animation.speed_normal, 0)
                  self.animation.current = 3
               end
            elseif at == 4 and ac ~= 4  then                            -- jump
                   if  self.animation.jump_start
                   and self.animation.jump_end
                   and self.animation.speed_normal
                   then
                  --print('jump')
                       self.object:set_animation({x=self.animation.jump_start,y=self.animation.jump_end},self.animation.speed_normal, 0)
                       self.animation.current = 4
                       minetest.after(0.2, function()
                           self.object:set_animation({x=self.animation.walk_start,y=self.animation.walk_end},self.animation.speed_normal, 0)
                           self.animation.current = 1
                       end)
                   else                                                    -- walk if there's no jump animation
                  --print('grounded')
                       self.object:set_animation({x=self.animation.walk_start,y=self.animation.walk_end},self.animation.speed_normal, 0)
                       self.animation.current = 1
                   end
            elseif at == 5 and ac ~= 5  then                            -- mine
               if   self.animation.mine_start
               and self.animation.mine_end
               and self.animation.speed_normal
               then
                  --print('mine')
                  self.object:set_animation({x=self.animation.mine_start,y=self.animation.mine_end},self.animation.speed_normal, 0)
                  self.animation.current = 5
               end
            elseif at == 6 and ac ~= 6  then                            -- mine & walk
               if   self.animation.mine_walk_start
               and self.animation.mine_walk_end
               and self.animation.speed_normal
               then
                  --print('mine & walk')
                  self.object:set_animation({x=self.animation.mine_walk_start,y=self.animation.mine_walk_end},self.animation.speed_normal, 0)
                  self.animation.current = 5
               end
            elseif at == 7 and ac ~= 7  then                            -- sit
               if   self.animation.sit_start
               and self.animation.sit_end
               and self.animation.speed_normal
               then
                  --print('sit')
                  self.object:set_animation({x=self.animation.sit_start,y=self.animation.sit_end},self.animation.speed_normal, 0)
                  self.animation.current = 7
               end
            end
           end,

         get_staticdata = function(self)                                -- static data, tries to save everything
            local tmp = {}
            for _,stat in pairs(self) do
               local t = type(stat)
               if  t ~= 'function'
               and t ~= 'nil'
               and t ~= 'userdata'
               then
                   tmp[_] = self[_]
               end
            end
            return minetest.serialize(tmp)
         end,

         on_activate = function(self, staticdata, dtime_s)              -- restores all saved stuff :)
            self.object:set_armor_groups(self.armour)
            self.walk_time_max = self.walk_velocity *2                  -- twice the speed is how long we wanna wait :)
            if self.mob_type == 3 and minetest.setting_getbool("only_peaceful_mobs") then
                self.alive = false
                self.object:remove()
                return
            end

            if staticdata then
                local tmp = minetest.deserialize(staticdata)
                if tmp then
                   for _,stat in pairs(tmp) do
                       self[_] = stat
                   end
                end
            end
            -- remove only if self.timer was defined
            if self.lifetimer > -1 and self.lifetimer <= 1 and not self.tamed then
               self.object:remove()
            end
         end,

         on_punch = function(self, hitter)                              -- deals damage, wears out tools
            if not hitter then return end                               -- no hitter no gain
            if hitter:is_player() then
               local pll = hitter:get_player_name()
               state[pll] = 4                                        -- food_exaustion caused by attack
               default.statuses[pll].attack = true
            end
            self:hit(hitter)                                            -- fall back
            if self.mob_type == 2 then
               self.destination = nil
               if not hitter:is_player() then                              -- if hitter is an entity
                  if hitter.is_arrow then                                  -- and if it's also an arrow
                     self.target = hitter.master                           -- then follow the one who's launched it
                  else
                     self.target = hitter                                  -- else hitter is to become target
                  end
               else
                  self.target = hitter                                     -- even if it's a player :)
               end
               self.mob_type = 3
            elseif self.mob_type <2 then
               self.state = 2
               self.aggressor = hitter
            end
            if self.object:get_hp() <= 0 then                           -- it's dead now
                  if self.alive then
                     local pos =  self.object:getpos()
                     for _,drop in ipairs(self.drop) do
                    if math.random(1, drop.chance) == 1 then
                            local itm = minetest.add_item(pos, ItemStack(drop.name.." "..math.random(drop.min, drop.max)))
                            itm:setvelocity({x=math.random()*math.random(-1,1),y=math.random()*math.random(0,2),z=math.random()*math.random(-1,1)})
                     end
                     end
                 if self.sounds and self.sounds.die then
                   minetest.sound_play(self.sounds.die, {object = self.object})
                 end
                     self.alive = false
                     self.object:remove()
                  end
            else                                                        -- it's still alive
               if self.sounds and self.sounds.damage then
                  minetest.sound_play(self.sounds.damage, {object = self.object})
               end
            end

            local digger = hitter                                       -- add tool wear is NOT automated within default.tools
            if digger and digger:is_player() then
               local wstack = digger:get_wielded_item()
               local wear = wstack:get_wear()
               local uses = minetest.registered_items[wstack:get_name()].uses or 1562 -- diamond
               if wear + 65535/uses >= 65535 then
                  wstack:clear()
                  minetest.sound_play("default_break_tool",{pos = digger:getpos(),gain = 0.5, max_hear_distance = 10,})
               else
                   wstack:set_wear(wear + 65535/uses)
               end
               digger:set_wielded_item(wstack)
            end
         end,

         natural_damage = function(self)                                -- procedure to deal environmental damage
            local pos = self.object:getpos()
            local node = minetest.get_node(pos)
            local light = minetest.get_node_light(pos)
            local nodedef = minetest.registered_nodes[node.name]

            if  self.light_damage >0                                    -- only daylight counts ^_^
            and light == 15 then
                self.object:set_hp(self.object:get_hp()-self.light_damage)
                self:hit(self)
            end

            if  self.water_damage
            and self.water_damage > 0
            and nodedef.groups.water then
                self.object:set_hp(self.object:get_hp()-self.water_damage)
                self:hit(self)
            end

            if  self.lava_damage
            and self.lava_damage > 0
            and nodedef.groups.lava then
                self.object:set_hp(self.object:get_hp()-self.lava_damage)
                self:hit(self)
            end
         end,

         on_step = function(self, dtime)                                -- AI
            if not self.alive then return end                           -- do not calculate anything, if this mob is dead already

            self.timer=self.timer+dtime                                 -- increase timer even if it's busy
            self.shoot_timer = self.shoot_timer + dtime
            if self.produce_timer then
               self.produce_timer = self.produce_timer - dtime
               if self.produce_timer <=0 then
                  self.produce_timer = nil
                  self.can_produce = true
               end
            end

            if busy then                                                -- don't do anyting if a mob needs time
               if self.timer<1 then
                  return
               end
            end

            if self.object:get_hp() <= 0 then                           -- or kill it if we should, and do not calculate anything else
               self.alive = nil
               self.object:remove()
               return
            end

            local pos = self.object:getpos()                            -- get current pos (just once instead of multiple times)

            if not self.follow and self.timer>0.7 then
                if self.state == 0 then                                     -- some general walking AI
                    if math.random(1, 400) == 1 then
                        self.object:setyaw(self.object:getyaw()+((math.random(0,360)-180)/180*math.pi))
                    end
                    self.object:setvelocity({x=0,y=0,z=0})
                    if math.random() <= 0.05 then
                        self:set_velocity(self.walk_velocity)
                        self.state = 1
                    end
                elseif self.state == 1 then
                    if math.random(1, 1000) <= 30 then
                        self.object:setyaw(self.object:getyaw()+((math.random(0,360)-180)/180*math.pi))
                    end
                    self.set_velocity(self, self.walk_velocity)
                    if math.random(1, 1000) <= 10 then
                        self.object:setvelocity({x=0,y=0,z=0})
                        self.object:setacceleration({x=0,y=0,z=0})
                        self.state = 0
                    end
                elseif self.state == 2 then
                    if math.random(1, 1000) <= 60 then
                        self.object:setyaw(self.object:getyaw()+((math.random(0,360)-180)/180*math.pi))
                    end
                end

                local yaw = self.object:getyaw()
                local x = -math.sin(yaw)
                local z = math.cos(yaw)
                local nm = minetest.get_node({x=pos.x+x, y=pos.y, z=pos.z+z}).name
                if  nm~='air'
                and nm~='ignore'
                and self.jump
                and self.state~=4 then
                    self:jump()
                    --print('jumps over an obstacle while idling')
                end

            end

            if self.timer>0.5 then                                      -- AI changes only twice per second for hostile mobs!
               if self.mob_type > 2 then                                -- some very angry mobs AI statements

                  if minetest.setting_getbool("only_peaceful_mobs") then   -- remove itself if no hostile mobs are allowed
                    self.alive = nil
                    self.object:remove()
                  end
                  if self.hostile_timer > 0 then                           -- revert hostile to passive once the time is nigh
                    self.hostile_timer = self.hostile_timer - dtime
                    if self.hostile_timer <= 0 then
                      self.hostile_timer = 0
                      self.mob_type = 2                                  -- once hit mob can never be friendly 100%, but passive
                      self.state = 1
                    end
                  end

                  if minetest.get_node(pos).name:find('water')
                  then self.in_water = true
                  else self.in_water = nil
                  end

                  if self.follow then                                      -- friendly mobs are stupid; if it's following, then there is a player
                    if not self.in_water then
                       if not self.destination then
                          if self.target then                               -- or is it? Maybe he/she has lost connection
                            local pos1 = pos
                            local pos2
                            if self.target.is_player and self.target:is_player() then
                               pos2 = self.target:getpos()
                            else
                               pos2 = self.target.object:getpos()
                            end
                            local path = minetest.find_path(pos1,pos2,self.view_range,3 ,4,"A*_noprefetch")
                            if path then
                               local pos2
                               if path[2] then pos2 = path[2] end
                               self.destination = pos2
                               local dir = {x=pos2.x-pos1.x, y=pos2.y-pos1.y, z=pos2.z-pos1.z}
                               local yaw = math.atan(dir.z/dir.x)+math.pi/2
                                  if pos2.x > pos1.x then
                                    yaw = yaw+math.pi
                                  end
                               self.object:setyaw(yaw)
                               self:set_velocity(self.run_velocity)
                               if self.destination.y > pos.y then -- jump
                                 self:jump()
                               end
                               self.state = 2
                               --print('running to target')
                            else
                               self.destination = nil
                               self.follow = nil
                               self.target = nil
                               self.state = 1
                               --print('no path')
                            end
                          else
                             self.follow = nil
                             self.destination = nil
                             self.state = 1
                             --print('no target - lost destination')
                          end
                        else
                           if self.destination.y > pos.y then -- jump        -- jump if it needs to
                             self:jump()
                           end

                           local node = minetest.get_node(self.destination).name
                           if node~="air" and minetest.registered_nodes[node].drawtype ~= "plantlike"  then
                             self:jump()
                             self.destination = nil
                           else
                              local distance = ((pos.x-self.destination.x)^2 + (pos.y-self.destination.y)^2 + (pos.z-self.destination.z)^2)^0.5
                              if distance<=0.15 or distance>=1.5 then
                                self.follow = nil
                                self.target = nil
                                self.destination = nil
                                self.state = 1
                              else -- wanna GO there!!!
                                 local pos1 = pos
                                 local pos2 = self.destination
                                 local dir = {x=pos2.x-pos1.x, y=pos2.y-pos1.y, z=pos2.z-pos1.z}
                                 local yaw = math.atan(dir.z/dir.x)+math.pi/2
                                     if pos2.x > pos1.x then
                                        yaw = yaw+math.pi
                                     end
                                 self.object:setyaw(yaw)
                                 self:set_velocity(self.run_velocity)
                                 self.state = 2
                              end
                           end

                           self.walk_time = self.walk_time+dtime             -- count time spent on travel
                           if self.walk_time > self.walk_time_max then       -- reach the MAX and STOP tryig to get there
                             self.walk_time = 0
                             self.destination = nil                         -- drop the destination, but not the target ^_^
                             --print('dropped dest - walking for too long')
                           end
                        end
                    else
                        --print('hostile in water')
                        if self.target then
                           local s = pos
                           local p
                           if     self.target.is_player                             -- what we're following?
                           and    self.target:is_player() then
                                  p=self.target:getpos()                            -- a player?
                           elseif self.target.object then
                                  p=self.target.object:getpos()                     -- or an entity?
                           end

                           if p then
                              local vec = {x=p.x-s.x, y=p.y-s.y, z=p.z-s.z}   --||||||||||||||X||
                              local yaw = math.atan(vec.z/vec.x)+math.pi/2    --|---------------|
                              if p.x > s.x then                               --|               |
                                 yaw = yaw+math.pi                            --| turn towards  |
                              end                                             --| the attractor |
                              self.object:setyaw(yaw)                         --|_______________|
                              self.set_velocity(self, self.walk_velocity)
                              self.state = 2
                              --print('start to run in water')
                          end
                        else

                           for _,player in pairs(minetest.get_connected_players()) do
                               local s = self.object:getpos()
                               local p = player:getpos()
                               local dist = ((p.x-s.x)^2 + (p.y-s.y)^2 + (p.z-s.z)^2)^0.5
                               if self.view_range and dist < self.view_range then
                                   self.target = player
                                   self.state = 2
                                   --print('new target in water!')
                                   break
                               end
                           end
                           if not self.target then self:set_velocity(self.walk_velocity) self.state = 1 end
                       end
                    end
                  end
                  if not self.follow then                                  -- separate check, for we may lost a target...
                    if minetest.setting_getbool("enable_damage") then       -- if damage is enabled, then
                      local players = minetest.get_connected_players()
                            self.state = 1                                -- then leave it be...
                            self.follow = nil
                            self.target = nil
                      for _,player in pairs(players) do                     -- find a player within sight
                         local op = pos
                         local pp = player:getpos()
                         local distance = ((op.x-pp.x)^2 + (op.y-pp.y)^2 + (op.z-pp.z)^2)^0.5
                         if distance < self.view_range then
                           if (self.arrow_dist>0 and distance<self.arrow_dist)
                           or (distance<1.2)                              -- and if we can attack, then
                           then                                           -- change state to "attacking" and set player as a target
                              self.target = player
                              self.state = 3
                              --print('shoot it')
                              break
                           else                                           -- else chase he player down ^~^
                              self.follow = true
                              self.target = player
                              self.destination = nil
                              self.state = 2
                              --print('run for it')
                              break
                           end
                                                                   -- no need to search someone else, it already has someone to be teared apart
                         end
                      end
                    end
                  end                                                      -- the END of follow/drop target piece

                    if self.state == 3 then
                        if self.arrow then
                           self.destination = nil
                           if not self.target then
                              self.state = 2  -- run again
                              --print('state=3 but no target!')
                           else
                               --print('attacking!')
                               local s = pos
                               local s1 = {x=pos.x, y=pos.y+1, z=pos.z}
                               local p = self.target:getpos()
                               local vec = {x=p.x-s.x, y=p.y-s.y, z=p.z-s.z}
                               local distance = ((p.x-s.x)^2 + (p.z-s.z)^2 )^0.5
                               local yaw = math.atan(vec.z/vec.x)+math.pi/2
                               if p.x > s.x then
                                  yaw = yaw+math.pi
                               end
                               self.object:setyaw(yaw)

                               if minetest.line_of_sight(s1, p, 0.9) then
                                   self.set_velocity(self, 0)

                                   if self.shoot_timer > self.shoot_interval and math.random(1, 100) <= 10 then
                                      self.shoot_timer = 0
                                      if self.sounds and self.sounds.attack then
                                     minetest.sound_play(self.sounds.attack, {object = self.object})
                                      end

                                     -- p.y = p.y + (self.collisionbox[2]+self.collisionbox[5])/2
                                      local obj = minetest.env:add_entity(s, self.arrow)
                                      obj:get_luaentity().master = self.object
                                      obj:get_luaentity().target = self.target
                                      --local amount = (vec.x^2+vec.y^2+vec.z^2)^0.5
                                      if obj:get_luaentity().path then
                                          obj:get_luaentity():path(pos, p)           -- use predefined projectile
                                      else                                          -- or fall back to a stupid one
                                          local dist = ((p.x-s.x)^2 + (p.y-s.y)^2 + (p.z-s.z)^2)^0.5
                                          local vec = {x=(p.x-s.x)/dist, y=(p.y-s.y)/dist, z=(p.z-s.z)/dist}
                                          local v = 19
                                          vec.y = vec.y+0.25
                                          vec.x = vec.x*v
                                          vec.y = vec.y*v
                                          vec.z = vec.z*v
                                          obj:setvelocity(vec)
                                          obj:get_luaentity().object:setacceleration({x=-2, y=-9.8, z = -2})
                                          if math.random()<0.05 then
                                             obj:get_luaentity().collected = nil
                                          else
                                             obj:get_luaentity().collected = true
                                          end
                                      end
                                   end
                                   --print('really shoot!')
                               else
                                  self.follow = true
                                  self.destination = nil
                                  self.state = 2
                                   --print('run for it, \'cause no line of sight')
                               end
                           end

                        else
                           if self.target then
                               local s = pos
                               local obj
                               if     self.target.is_player                             -- what we're following?
                               and    self.target:is_player() then
                                      obj=self.target                                   -- a player?
                               elseif self.target.object then
                                      obj=self.target.object                     -- or an entity?
                               end
                               local p = obj:getpos()

                               if obj then
                                  if self.attack_proc then  -- use attack function if defined (blasts, setting fire - almost anything )
                                     self:attack_proc(p)
                                  else  -- or cause damage directly
                                  local tool_capabilities = { full_punch_interval=1,
                                                              max_drop_level=1,
                                                              uses = 0,
                                                              groupcaps={fleshy = {uses=0, times={[1]=1, [2]=1, [3]=1}}},
                                                              damage_groups = {fleshy=self.attack_power or 1},
                                                            },
                                  object:punch(self.object, 1.1, tool_capabilities)
                                  end
                               end
                            else
                                self.state = 2
                                self.destination = nil
                                self.follow = nil
                            end
                        end
                    end
               end                                                         -- the END of hostile mobs AI
            end
            -------------- hostile AI ^^^^

            if self.lifetimer then                                      -- events that take place if mob is a mortal being ("default" on is IMmortal)
               self.lifetimer = self.lifetimer - dtime                  -- count how much time is left
               if self.lifetimer >= -1 and self.lifetimer <= 0 and not self.tamed then           -- if it wasn't tamed
                  local player_count = 0
                  for _,obj in ipairs(minetest.get_objects_inside_radius(pos, 20)) do
                      if obj:is_player() then
                          player_count = player_count+1
                      end
                  end                                                   -- and there's no players around
                  if player_count == 0 and self.state ~= 3 then         -- and it isn't fighting anyone ATM
                      self.alive = false                                -- mark it dead
                      self.object:remove()                              -- and plan to remove it
                      return
                  end
               end
            end

            if self.object:getvelocity().y > 0.1 then                   -- gravity & acceleration to continue moving
                local yaw = self.object:getyaw()
                local x = math.sin(yaw) * -2
                local z = math.cos(yaw) * 2
                if not self.flying then
                   self.object:setacceleration({x=x, y=-10, z=z})
                else
                   local basepos = pos
                   basepos.y = basepos.y - 10
                   local y = minetest.get_surface(basepos,10,false)
                   if y then
                      self.object:setacceleration({x=x, y=math.random(), z=z})
                   else
                      self.object:setacceleration({x=x, y=-1, z=z})
                   end
                end
            else                                                        -- gravity if standing/walking/running
                if not self.flying then
                   self.object:setacceleration({x=0, y=-10, z=0})
                else
                   local basepos = pos
                   basepos.y = basepos.y - 10
                   local y = minetest.get_surface(basepos,10,false)
                   if y then
                      self.object:setacceleration({x=0, y=math.random(), z=0})
                   else
                      self.object:setacceleration({x=0, y=-1, z=0})
                   end
                end
            end


            local n = minetest.get_node(pos)
            local p1 = {x=pos.x,y=pos.y-1,z=pos.z}
            local p2 = {x=pos.x,y=pos.y-2,z=pos.z}

            local n2 = minetest.get_node(p2)

            if minetest.get_item_group(n.name, "water") ~= 0 then       -- if it's a liquid, then check for underneath one...
               local n1 = minetest.get_node(p1)
               if  minetest.get_item_group(n1.name, "water") == 0       --if it's IN water but there IS walkable node below it then jump
               and self.jump then
                   self:jump()
               else                                                     -- else simulate swimming
                   if not self.state == 1 then self.state=1 end
                   local v = self.object:getvelocity()
                   v.y = 2
                   self.object:setvelocity(v)
               end
             end

            if not self.flying then                                     -- if it can't fly (at least ATM)
                if not self.disable_fall_damage                         -- fall damage calculation (if it's not disabled)
                and self.object:getvelocity().y == 0 then               -- is performed only if vertical speed == 0 (e.g. it is on the ground)
                    if not self.old_pos then
                        self.old_pos = pos                              -- remember current position, if there's none
                    else                                                -- if we have smth to compare, then
                        local d = self.old_pos.y - pos.y                -- get the vert. distance
                        if d > self.fall_tolerance then                 -- and if that is more than it can tolerate
                            local damage = d-self.fall_tolerance
                            self.object:set_hp(self.object:get_hp()-damage)
                        end
                        self.old_pos = pos
                    end
                end
            end

            if self.natural_damage_timer>-1 then                        -- timer for natural_damage
               self.natural_damage_timer = self.natural_damage_timer + dtime
               if self.natural_damage_timer > 1 then                    -- if it hits 1 then inflict damage
                  self.natural_damage_timer = 0
                  self:natural_damage()
               end
            end

            if self.child > 0 then                                      -- children follow their mothers
               if self.mother then
                  self.target=self.mother
                  self.child=self.child-dtime
                  if self.child and self.child<0 then                   -- and grow up eventually
                     local nm =self.name:sub(self.name:find(':')+1)
                     local name = adbs.parents[nm]
                     local mob
                     if name then
                        if adbs.can_spawn(name) then
                           mob = adbs.spawn_mob(pos, 'adbs:'..name)
                           if mob then
                               local ent=mob:get_luaentity()
                               ent.id=self.id -- inherit ID
                               ent.object:setyaw(self.object:getyaw())
                               ent.color=self.color
                               self.alive = nil
                               self.object:remove()
                           end
                        end
                     end
                  end
               end
            end

            -- following algo for stupid friendly mobs ^_^
            -- self.attractor in an itemstring (farming:wheat)
            -- self.follow is a true-false/nil var showing whether it's following someone
            if self.timer > 1 then                                      -- update stupid mobs movement once per second
               if self.mob_type<=2 then
                  if not self.follow then                               -- set a target for a stupid mob
                     if self.attractor ~= "" then
                         for _,object in pairs(minetest.get_objects_inside_radius(pos, self.attractor_dist_max)) do
                            if object:get_wielded_item():get_name() == self.attractor then
                               self.target = object
                               self.follow = true
                               break
                            end
                         end
                     end
                  elseif self.target then
                     local object
                     local s = pos
                     local p
                     if     self.target.is_player                             -- what we're following?
                     and    self.target:is_player() then
                            p=self.target:getpos()                            -- a player?
                            object = self.target
                     elseif self.target.object then
                            p=self.target.object:getpos()                     -- or an entity?
                            object = self.target.object
                     end
                     if object:get_wielded_item():get_name() ~= self.attractor then
                        self.target = nil
                        self.follow = nil
                     elseif p then
                        local vec = {x=p.x-s.x, y=p.y-s.y, z=p.z-s.z}
                        local distance = ((p.x-s.x)^2 + (p.z-s.z)^2 )^0.5
                        local yaw = math.atan(vec.z/vec.x)+math.pi/2
                        if p.x > s.x then
                           yaw = yaw+math.pi
                        end
                        self.object:setyaw(yaw)
                        self.set_velocity(self, self.walk_velocity)
                        local x = -math.sin(yaw)
                        local z = math.cos(yaw)

                        local nm = minetest.get_node({x=pos.x+x, y=pos.y, z=pos.z+z}).name
                        if (nm~='air' and nm~='ignore'
                        and  self.jump
                        and self.state~=4 )
                        or (p.y>s.y and distance <2 ) then  -- jump only if player is higher than a mob
                           self:jump()
                        end
                     end
                  else
                      self.follow = nil
                  end

                  if self.aggressor then
                     self.state = 2
                     local object
                     local s = pos
                     local p
                     if     self.aggressor.is_player                             -- what we're following?
                     and    self.aggressor:is_player() then
                            p=self.aggressor:getpos()                            -- a player?
                            object = self.aggressor
                     elseif self.target.object then
                            p=self.aggressor.object:getpos()                     -- or an entity?
                            object = self.aggressor.object
                     end
                     local weapon = object:get_wielded_item():get_name()
                     if p then
                        local vec = {x=p.x-s.x, y=p.y-s.y, z=p.z-s.z}
                        local distance = ((p.x-s.x)^2 + (p.z-s.z)^2 )^0.5
                        local yaw
                        if self.aggressor:is_player() then
                           yaw = self.aggressor:get_look_yaw()-math.pi/2
                        else
                           yaw = self.aggressor.object:getyaw()
                        end

                        self.object:setyaw(yaw)
                        self.set_velocity(self, self.run_velocity)
                        local x = -math.sin(yaw)
                        local z = math.cos(yaw)

                        local nm = minetest.get_node({x=pos.x+x, y=pos.y, z=pos.z+z}).name
                        if (nm~='air' and nm~='ignore'
                        and  self.jump
                        and self.state~=4 )
                        then
                           self:jump()
                        end
                     end
                     minetest.after(10, function() self.aggressor = nil self.state=1 end)
                  end

               end
            end
               -- End of stupid mobs' AI ^^^

            -- velocity limit, based on state and def.STATE_velocity
            if self.state <= 1 and self:get_velocity() ~= self.walk_velocity then self:set_velocity(self.walk_velocity) end
            if self.state >= 2 and self.state~=3 and self:get_velocity() ~= self.run_velocity  then self:set_velocity(self.run_velocity) end

            if self.sounds                                              -- produce random sounds occasionally
            and self.sounds.random
            and math.random(1, 100) <= 1 then
                minetest.sound_play(self.sounds.random, {object = self.object})
            end

            if self.colouring                                           -- colouring!
            and self.color
            and self.color~=self.oldcolor then
                self.oldcolor=self.color
                        self.object:set_properties({
                     textures = {string.gsub(self.name, ":", "_") ..'.png^colour_overlay_'..self.color..".png^" .. string.gsub(self.name, ":", "_")..'_undyed.png'},
                     mesh = self.mesh,
                })
             end

            if self.horny==true then                                    -- search for lover timer
               if self.hornytimer then
                  self.hornytimer = self.hornytimer +1
                  if self.hornytimer>self.horny_timer_max then
                     self.hornytimer=0
                     self.horny=false
                  end
               else
                   self.hornytimer = 0
               end
            end

            -- find a "lover" and make a new mob!
            if self.horny and not self.lover then
              -- minetest.chat_send_all('horny')
               local ents = minetest.get_objects_inside_radius(pos, self.lover_dist_max)
               --minetest.chat_send_all(#ents)
               for i,obj in ipairs(ents) do
                   local ent = obj:get_luaentity()
                  -- if ent and ent.name then minetest.chat_send_all(minetest.serialize(ent.name)) end
                   if ent
                   and ent.id~=self.id
                   and ent.name == self.name
                   and ent.horny==true
                   and (not ent.lover or self.id==ent.lover)
                   then
                     -- minetest.chat_send_all('lover')
                      self.target = ent
                      self.follow = ent
                      ent.target = self
                      self.lover = ent.id
                      ent.lover = self.id
                      minetest.after(7,function(dtime)                  -- new mob after 7 seconds (ToDo:)
                            local mob
                            local nm =self.name:sub(self.name:find(':')+1)
                            local name = adbs.children[nm]
                            if  name
                            and adbs.can_spawn("adbs:"..name) then
                                mob = adbs.spawn_mob(self.object:getpos(), 'adbs:' .. name) -- 'cause after 10 secs a pos can change
                                if mob then
                                    local ent2=mob:get_luaentity()
                                    ent2.mother=self                        -- we need mother to follow her
                                    ent.horny=false
                                    ent.lover=nil
                                    ent.follow=nil
                                    self.horny=false
                                    self.lover=nil
                                    self.follow=nil
                                    self.target=nil
                                end
                            end

                      end)
                    --  minetest.chat_send_all(tostring(self.id)..' loves ' .. tostring(self.lover).." AND "..tostring(ent.id).." loves "..tostring(ent.lover))
                      break
                   end
               end
            end

            if self.in_water and self.state>0 then                      -- water slows down mobs (ToDo: viscosity based)
               if self.state == 2
               then self:set_velocity(self.walk_velocity*0.7)
               else self:set_velocity(self.run_velocity*0.7)
               end
            end

            if self.timer>1 then
               --[[
               ------------per level!--------
               speed + 20%
               speed - 15%
               block breaks 20% faster
               block breaks 20% slower
               melee attacks *1.3
               heal/damage undead
               damage/heal undead
               jump+0.5 node, fall tolerance + 1
               wobble screen
               regeneraton (1 HP per 50*dtime)
               reduce damage by 20%
               fire affinity (no fire/lava damage)
               aqualung 5+ (жабры)
               blindness (dark HUD + no sprinting + no crit.)
               night vision (day/night at 1)
               hunger (0.0025 food exaustion per tick, yellow-ish bar)
               weakness (-0.25 damage)
               poison (1HP per 25 ticks, yellowish hearts, CAN'T kill)
               wither (1HP per 40 ticks, black hearts, CAN kill)
               health boost (24 hearts in total)
               saturation (food meter+1 per tick)

               ]]

            end

           if self.can_produce and self.auto_produce then
              if self.textures_produced and self.mesh_produced then -- change the mesh and textures if available !
                       self.object:set_properties({
                           textures = self.textures_produced,
                           mesh = self.mesh_produced,
                 })
              end
              local produce = ''
              if self.produce == 'wool' then                                             -- if produced item is just "wool", e.g. no colour was specified
                 if minetest.registered_items["wool:".. adbs.colors[self.color]] then     -- then wool should be of the self.color colour
                    produce = "wool:".. adbs.colors[self.color]
                 end
              else
                  produce = self.produce                               -- otherwise we can use self.produce as-is
              end
              self.can_produce = false
              self.produce_timer = self.produce_cooldown
              local ppp = self.object:getpos()
              local rnd
              if self.produce_num>0 then
                 rnd = math.random(0,self.produce_num)
              else
                 rnd = self.produce_num
              end
              if rnd~=0 then
                  local start_i = 1
                  if rnd<0 then rnd = -rnd  start_i = rnd end
                  for i=start_i,rnd do
                      local it = minetest.add_item(ppp, produce)
                      if it then
                         it:get_luaentity().collect = true
                         local v={}
                         v.x = math.random(-5, 5)
                         v.y = 5
                         v.z = math.random(-5, 5)
                         it:setvelocity(v)
                      end
                  end
              end
           end

            if self.timer>1 then self.timer = 0 end
           -- print(self.state)
            self:set_animation(self.state)                              -- sets corresponding animation for every state... 't's good those are identical

        end,

         on_rightclick = function(self, clicker)
            local item = clicker:get_wielded_item()
            if item:get_name() == self.attractor then
               item:take_item()
               clicker:set_wielded_item(item)
               if self.can_produce then
                  if not self.horny then                                      -- make it want to breed+ particles spawner activasion
                     self.horny = true
                     self.hornytimer=0
                     local ppp = self.object:getpos()
                     local sdd = minetest.add_particlespawner(
                                                              10,
                                                              0,
                                                              {x=ppp.x-0.3,y=ppp.y-0.3,z=ppp.z-0.3},
                                                              {x=ppp.x+0.3,y=ppp.y+0.3,z=ppp.z+0.3},
                                                              {x=-1, y=1, z=-1},
                                                              {x=1, y=2, z=1},
                                                              {x=-1, y=0.5, z=-1},
                                                              {x=1, y=2, z=1},
                                                              1,
                                                              1,
                                                              0.5,
                                                              3,
                                                              false,
                                                              "heart.png"
                                                             )
                     minetest.after(1,function() minetest.delete_particlespawner(sdd) end)
                  end
               else
                  self.food = (self.food or 0) + 1
                  if self.food >= self.food_max then
                     self.food = 0
                     self.can_produce = true
                     self.produce_timer = nil
                     self.object:set_properties({
                          textures = {string.gsub(self.name, ":", "_") ..'.png^colour_overlay_'..self.color..".png^" .. string.gsub(self.name, ":", "_")..'_undyed.png'},
                          mesh = self.mesh,
                     })
                  end
               end
            elseif item:get_name() == self.produce_item then
                   if self.can_produce then
                      if self.textures_produced and self.mesh_produced then -- change the mesh and textures if available !
                               self.object:set_properties({
                                   textures = self.textures_produced,
                                   mesh = self.mesh_produced,
                         })
                      end
                      local produce = ''
                      if self.produce == 'wool' then                                             -- if produced item is just "wool", e.g. no colour was specified
                         if minetest.registered_items["wool:".. adbs.colors[self.color]] then     -- then wool should be of the self.color colour
                            produce = "wool:".. adbs.colors[self.color]
                         end
                      else
                          produce = self.produce                               -- otherwise we can use self.produce as-is
                      end
                      self.can_produce = false
                      self.produce_timer = self.produce_cooldown
                      local ppp = self.object:getpos()
                      local rnd
                      if self.produce_num>0 then
                         rnd = math.random(0,self.produce_num)
                      else
                         rnd = self.produce_num
                      end
                      if rnd~=0 then
                         local start_i = 1
                         if rnd<0 then rnd = -rnd  start_i = rnd end
                         if not self.produce_replace then
                              for i=start_i,rnd do
                                  local it = minetest.add_item(ppp, produce)
                                  if it then
                                     it:get_luaentity().collect = true
                                     local v={}
                                     v.x = math.random(-5, 5)
                                     v.y = 5
                                     v.z = math.random(-5, 5)
                                     it:setvelocity(v)
                                  end
                              end
                         else
                            if rnd > 1 then produce = produce .. " " .. rnd end
                            clicker:set_wielded_item(ItemStack(produce))
                         end
                      end
                   end
            elseif item:get_name():find('dye') then
                   local ienm = item:get_name()
                   if self.can_produce then
                      local color=ienm:sub(ienm:find(':')+1)
                      local item1 = "dye:"..adbs.colors[self.color]
                      local item2 = "dye:"..color
                      local input = {method = 'normal', items = {item1,item2},}
                      local output = minetest.get_craft_result(input)
                      local otnm
                      if output then otnm = output.item:get_name() end
                      if otnm and otnm:find(':') then color=otnm:sub(otnm:find(':')+1) end
                      self.color=adbs.color_by_name(color)
                   end
            end
        end,

     __index = function(table,key)                                  -- prototyping insurance ^_^
        return adbs.dd[key]
     end,
}

adbs.add = {
     master = nil,                                                      -- an entity which "threw" this ammo
     path = nil,                                                        -- func to control ammo path (whirl, straight, bumerang etc)
     physical = false,                                                  -- shouldn't be physical to be able to hit nodes/entities, struck etc
     visual = 'sprite',                                                   -- mesh/cube/sprite
     visual_size = {x=5,y=5,z=5},
     textures = {"default_wood.png"},
     velocity = {x=0,y=0,z=0},
     capabilities = { full_punch_interval=1,
                      max_drop_level=1,
                      uses = 1,
                      groupcaps={fleshy = {uses=0, times={[1]=1, [2]=1, [3]=1}}},
                      damage_groups = {fleshy=1},
                    },
     --hit_object = nil,                                                  -- func that is called when an object is hit
     --hit_node = nil,                                                    -- func that is called when node is hit
   --  one_only = true,                                                   -- hits only once

        on_step = function(self, dtime)
            if not self.lifetimer then self.lifetimer = 0 end
            self.lifetimer = self.lifetimer + dtime
            if self.lifetimer > 60 then self.object:remove() return end

            if self.dead then
               local pos = self.object:getpos()
               pos.y = pos.y-0.2
               local node = minetest.get_node(pos)
               if node.name == 'air' then  -- in air
                  --if not self.total_dead then
                     self.object:setacceleration({x=0, y=-9.8, z=0})
                  --end
               else -- in node
                   self.object:setvelocity({x=0, y=0, z=0})
                   self.object:setacceleration({x=0, y=0, z=0})
                  -- pos.y=pos.y+0.1
                  -- self.total_dead = true
                  -- self.object:setpos(pos)
               end
               return
            end

            local pos = self.object:getpos()
            local node = minetest.get_node(pos)

            if node.name ~= "air" and node.name ~= "ignore" then
               if     node.name:find("water") then
                      local vel = self.object:getvelocity()
                      self.object:setvelocity({x=vel.x/3, y = -4, z = vel.z/3})
               elseif node.name:find("lava") then
                      self.on_fire = true
               elseif self.hit_node then
                      self:hit_node(pos, node)
                      return
               end
                -- self.object:remove()
                -- removal is controled by the func above!
            end

            if self.fly and self.master then
               local s = self.object:getpos()
               local p = self.target:getpos()
               self:fly(s,p)
            end

            for _,object in pairs(minetest.get_objects_inside_radius(pos, 1)) do
                local name
                if object.is_player and object:is_player() then
                   name = object:get_player_name()
                else
                    name = object:get_luaentity().name
                end
                if  name~=self.name
                and name~='__builtin:item'
                and name~='ghosts:ghostly_block'
                then
                   if self.master then
                      local mname
                      if self.master.is_player and self.master:is_player() then
                         mname = self.master:get_player_name()
                      else
                          mname = self.master:get_luaentity().name
                      end
                       if name ~= mname then
                          if self.hit_object then self:hit_object(object,name) end
                          if self.one_only then self.dead = true self.object:remove() return end
                       end
                        -- removal is controled by the func above!
                   end
                end
            end
            pos.y = pos.y-1
        end,

     __index = function(table,key)                                  -- prototyping insurance ^_^
        return adbs.add[key]
     end,
 }

function adbs.register_mob(name, def)                                        -- helps us to register new mobs
    setmetatable (def,adbs.dd)
    minetest.register_entity(name, def)
    if def.child==0 then
       adbs.registered_mobs[#(adbs.registered_mobs)+1] = name         -- add mob to the list of registered ones
    end
end

function adbs.register_ammo(name, def)                                        -- helps us to register new mobs
    setmetatable (def,adbs.add)
    minetest.register_entity(name, def)
end

function adbs.spawn_mob(pos, name)                                           -- spawns specified mob, gives it an ID and counts it
   if not adbs.can_spawn(name) then return end                          -- can't spawn over MAX
   local ent = minetest.add_entity(pos, name)
   if ent and ent:get_luaentity() then
      ent:get_luaentity().id = #adbs.ids+1
      adbs.ids[#adbs.ids+1] = ent
      return ent
   else
       ent:remove()
       print('Smth has failed, but what? An entity should\'ve been spawned...')
       return nil
   end
end

function adbs.register_spawn(name,
                        nodes,                                          -- nodes to spawn on
                        near,                                           -- neighbors [optional]
                        room,                                           -- # of air/water nodes
                        light,                                          -- max light amount needed to spawn a mob
                        light_min,
                        chance,                                         -- 1/chance possibility of spawning a mob
                        aocnt,                                          -- do not spawn if there's more than this # of entities in the chunk
                        height,                                         -- max height @ which a mob will spawn
                        height_min,
                        heat,                                           -- max temperature @ which a mob will spawn
                        heat_min,
                        humidity,                                       -- max humidity @ which a mob will spawn
                        humidity_min,
                        max_count,                                      -- maximum amount of mobs of this type
                        spawn_func
                        )

    local nm = name:sub(name:find(':')+1)
    if minetest.setting_getbool(nm.."_spawn") ~= false then
       adbs.spawning_mobs[nm] = true
       if not light_min    then light_min    = 0 end
       if not height_min   then height_min   = 0 end
       if not humidity_min then humidity_min = 0 end
       if not heat_min     then heat_min     = 0 end

       if not aocnt then aocnt = 20 end

       if not near then near = {"air"} end -- water?

       adbs.max_count[nm] = aocnt
       minetest.after(1,function(dtime)
           minetest.register_abm({
                nodenames = nodes,
                neighbors = near,
                interval = 30,
                chance = chance,
                action = function(pos, node, aoc, aocw)
                    if aocw > aocnt then return end
                    if not adbs.spawning_mobs[nm] then return end

                    pos.y = pos.y+1

                    local l = minetest.get_node_light(pos)

                    if not l              then return end
                    if     l > light      then return end
                    if     l < light_min  then return end
                    if     pos.y > height then return end

                    local minp={x=pos.x-2, y=pos.y-2, z=pos.z-2}
                    local maxp={x=pos.x+2, y=pos.y+2, z=pos.z+2}
                    local num = #(minetest.find_nodes_in_area(minp, maxp, near))
                    if num< room then return end

                    if  spawn_func and not spawn_func(pos, node) then return end
                    adbs.spawn_mob(pos,name)

    --                chmobs_save()
                     --local sha = minetest.add_entity(pos, "4aimobs:shadow")
                    --sha:set_attach(mob) --, nil, position, rotation)
                end
            })
        end)
    end
end

adbs.register_ammo("adbs:arrow", {
 name = "adbs:arrow",
 item_type = 'ammo',
 drop={},
 visual = "mesh",
 mesh = "arrow.x",
 one_only = true,
 itemname = "throwing:arrow",
 physical = false,
 visual_size = {x=10,y=10,z=10},
 collisionbox = {-0.01, -0.01, -0.01, 0.01, 0.01, 0.01},
 textures = {"adbs_arrowt.png"},
 --weight = 1,
 --physical = true,
 automatic_face_movement_dir = 0.0,
 on_activate = function (self, staticdata)
      if self.master and not self.master:is_player() then
         self.capabilities = { full_punch_interval=1,
                               max_drop_level=1,
                               uses = 1,
                               groupcaps={fleshy = {uses=0, times={[1]=1, [2]=1, [3]=1}}},
                               damage_groups = {fleshy=self.master:get_luaentity().attack_power},
                              }  -- let attack_power of a master control the damage if there is one
         else
         self.capabilities = { full_punch_interval=1,
                               max_drop_level=1,
                               uses = 1,
                               groupcaps={fleshy = {uses=0, times={[1]=1, [2]=1, [3]=1}}},
                               damage_groups = {fleshy=3},
                              }  -- otherwise assume a player has launched it
         end
 end,
 hit_object = function(self, obj, name) --self.master
    obj.punch(obj,self.master, 1 , self.capabilities, nil)
 end,
 hit_node = function(self, pos, node)
    self.dead = true
    self.object:setvelocity({x=0, y=0, z=0})
    self.object:setacceleration({x=0, y=0, z=0})
     --minetest.add_item(pos, self.name.."_item")
     --self.object:remove()
 end,
 --[[
 path = function(self, org_pos, dst_pos)
    -- get the distance
    local distance = ((dst_pos.x-org_pos.x)^2 + (dst_pos.z-org_pos.z)^2 )^0.5
    -- calc the vector to leave 2 instead of 3: y and x+z ones
    local vxz = {x=dst_pos.x-org_pos.x, z=dst_pos.z-org_pos.z}
    local phi = 0.5*math.asin((9.8*distance)/15^2)  -- 15 is the speed of an arrow
    local y = math.tan(phi)*distance
    local velocity = {x=vxz.x, y=y, z=vxz.z}
    print(minetest.serialize(velocity))
    self.object:setvelocity(velocity)
    self.object:setacceleration({x=-2, y=-9.8, z=-3})
 end]]
--[[
 fly = function(self, org_pos, dst_pos)
    local distance = ((dst_pos.x-org_pos.x)^2 + (dst_pos.z-org_pos.z)^2 )^0.5
    local vel = self.object:getvelocity()
    vel.y = math.sin(distance)*5
    self.object:setvelocity(vel)
 end ]]
})

minetest.register_chatcommand("mob", {
    func = function(name, param)
        if not param or param =='' then param = "test" end
        local mob = adbs.spawn_mob(minetest.get_player_by_name(name):getpos(), 'adbs:'..param)
        if mob then
           if param == 'skeleton' then
              local weaponize = mob:set_wielded_item(ItemStack("throwing:bow_wood"))
              if not weaponize then print ('didn\'t give a weapon...') end
           end
        end
    end
})

minetest.register_chatcommand("nv", {
    func = function(name, param)
           if param =='' then param = nil end
           local player = minetest.get_player_by_name(name)
           player:override_day_night_ratio(param)
    end
})

local biomemap = {}

minetest.register_on_generated(function(minp, maxp, blockseed)
     local biomes = minetest.get_mapgen_object('biomemap')

     local chunksize = {x = maxp.x-minp.x,
                        y = maxp.y-minp.y,
                        z = maxp.z-minp.z,}
     biomemap[#biomemap+1] = {x1=minp.x,
                              x2=maxp.x,
                              z1=minp.z,
                              z2=maxp.z,
                              biome = biomes[(minp.x+math.floor(chunksize.x/2)) + (minp.z+math.floor(chunksize.z/2))*chunksize.z]
                             }
end)

minetest.register_chatcommand("biome", {
    func = function(name, param)
         local pos = minetest.get_player_by_name(name):getpos()
         local pp = {x = pos.x, z = pos.z}
         local bm = 'nope'
         for _,biome in ipairs(biomemap) do
            if  pp.x>=biome.x1
            and pp.x<=biome.x2
            and pp.z>=biome.z1
            and pp.z<=biome.z2
            then
                bm = biome.biome or 'nope'
                break
            end
         end
         minetest.chat_send_player(name,bm)
      --   local output = io.open(minetest.get_worldpath().."/biomes.lua", "w")
      --   output:write(minetest.serialize(biomemap))
      --   io.close(output)
    end
})


--===================== Actual mobs definitions! =======================

-- --------------------- Friendly ones ---------------------------

-- Sheep
adbs.register_mob("adbs:sheep", {
    mob_type = 1,
    hp_max = 8,
    collisionbox = {-0.47, -0.0, -0.5, 0.47, 0.49, 0.49},
    textures = {"adbs_sheep.png"},
    textures_normal = {"adbs_sheep.png"},
    textures_produced = {"adbs_sheep_produced.png"},
    visual = "mesh",
    mesh = "adbs_sheep.x",
    mesh_normal = "adbs_sheep.x",
    mesh_produced = "adbs_sheep_produced.x",
    visual_size = {x=1,y=1,z=1},
    makes_footstep_sound = true,
    walk_velocity = 0.7,
    run_velocity = 1.5,
    armour = {fleshy=100},
    drops = {
        {name = "wool:white",
        chance = 1,
        min = 0,
        max = 1,},
    },
    water_damage = 0,
    lava_damage = 5,
    light_damage = 0,
--    sounds = {
--        random = "mobs_sheep",
--    },
    animation = {
        speed_normal = 15,
        stand_start = 0,
        stand_end = 80,
        walk_start = 81,
        walk_end = 100,
    },
    attractor = "farming:wheat",
    view_range = 5,
    colouring = true,
    color = 13,
    produce = 'wool',
    produce_num = 3,
    produce_item = 'default:shears',
    can_produce = true,
    produce_cooldown = 85,

})

-- Lamb
adbs.register_mob("adbs:lamb", {
    mob_type = 1,
    hp_max = 4,
    collisionbox = {-0.37, -0.0, -0.37, 0.37, 0.9, 0.37},
    textures = {"adbs_sheep.png"},
    visual = "mesh",
    mesh = "a_lamb.b3d",
    visual_size = {x=5,y=5,z=5},
    makes_footstep_sound = true,
    walk_velocity = 0.8,
    run_velocity = 1.6,
    armour = {fleshy=100},
    drops = {
        {name = "wool:white",
        chance = 1,
        min = 0,
        max = 1,},
    },
    water_damage = 0,
    lava_damage = 5,
    light_damage = 0,
--    sounds = {
--        random = "adbs_lamb",
--    },
    animation = {
        speed_normal = 25,
        stand_start = 0,
        stand_end = 20,
        walk_start = 30,
        walk_end = 60,
    },
    view_range = 16,
    colouring = true,
    color = 13,
    oldcolor=13,
    mother = nil,
    child = 800,

})

-- Cow
adbs.register_mob("adbs:cow", {
    mob_type = 1,
    name = 'cow',
    hp_max = 10,
    collisionbox = {-0.47, -0.4, -0.5, 0.47, 0.8, 0.5},
    textures = {"a_cow2.png","a_cow2.png","a_cow2.png","a_cow2.png","a_cow2.png","a_cow2.png","a_cow2.png","a_cow2.png","a_cow2.png","a_cow2.png"},
    visual = "mesh",
    mesh = "a_cow.b3d",
    visual_size = {x=9,y=9,z=9},
    makes_footstep_sound = true,
    walk_velocity = 0.5,
    run_velocity = 1,
    armour = {fleshy=100},
    drops = {
        {name = "4items:leather",
        chance = 1,
        min = 0,
        max = 2,},
        {name = "4items:beef_raw",
        chance = 1,
        min = 1,
        max = 3,},
    },
    water_damage = 0,
    lava_damage = 4,
    light_damage = 0,
--    sounds = {
--        random = "adbs_cow",
--    },
    animation = {
        speed_normal = 20,
        stand_start = 0,
        stand_end = 20,
        walk_start = 30,
        walk_end = 60,
    },
    attractor = "farming:wheat",
    view_range = 5,
    produce = '4items:milk',
    produce_num = -1,
    produce_item = 'bucket:bucket_empty',
    produce_replace = true,
    can_produce = true,
    produce_cooldown = 85,

})

-- Pig
adbs.register_mob("adbs:pig", {
    mob_type = 1,
    name = 'pig',
    hp_max = 8,
    collisionbox = {-0.47, -0.4, -0.5, 0.47, 0.49, 0.49},
    textures = {"a_pig.png","a_pig.png","a_pig.png","a_pig.png","a_pig.png","a_pig.png","a_pig.png",},
    visual = "mesh",
    mesh = "a_pig.b3d",
    visual_size = {x=3.5,y=3,z=3.5},
    makes_footstep_sound = true,
    walk_velocity = 1,
    run_velocity = 1.5,
    armour = {fleshy=100},
    drops = {
        {name = "farming:carrot",
        chance = 0.5,
        min = 0,
        max = 1,},
        {name = "4items:porkchop_raw",
        chance = 1,
        min = 1,
        max = 3,},
    },
    water_damage = 0,
    lava_damage = 4,
    light_damage = 0,
--    sounds = {
--        random = "adbs_pig",
--    },
    animation = {
        speed_normal = 40,
        stand_start = 0,
        stand_end = 20,
        walk_start = 30,
        walk_end = 60,
    },
    attractor = "farming:carrot",
    view_range = 5,

    on_rightclick = function(self, clicker)
        adbs.dd.on_rightclick(self,clicker)
        local item = clicker:get_wielded_item()
        if item:get_name() == "4items:saddle" then
           print('put a saddle on a pig!') -- self.extra_overlay; self.saddled
        end
    end,
})

-- Chicken
adbs.register_mob("adbs:chicken", {
    mob_type = 1,
    name = 'chicken',
    hp_max = 6,
    collisionbox = {-0.3, -0.3, -0.3, 0.3, 0.3, 0.3},
    textures = {"a_chicken.png"},
    visual = "mesh",
    mesh = "a_chicken.b3d",
    visual_size = {x=3.5,y=3,z=3.5},
    makes_footstep_sound = true,
    walk_velocity = 0.8,
    run_velocity = 2,
    armour = {fleshy=100},
    drops = {
        {name = "4items:chicken_raw",
        chance = 1,
        min = 1,
        max = 3,},
    },
    water_damage = 0,
    lava_damage = 5,
    light_damage = 0,
--    sounds = {
--        random = "adbs_chicken",
--    },
    animation = {
        speed_normal = 40,
        stand_start = 0,
        stand_end = 20,
        walk_start = 30,
        walk_end = 60,
        jump_start = 70,
        jump_end = 100,
    },
    attractor = "farming:seed_wheat",
    view_range = 5,
    produce = "4items:egg",
    can_produce = true,
    auto_produce = true,
    auto_produce_chance = 1/3,
    produce_num = -1,
})

-- Cattle
adbs.register_mob("adbs:cattle", {
    mob_type = "animal",
  --  name = 'lamb',
    hp_max = 4,
    collisionbox = {-0.47, -0.2, -0.5, 0.47, 0.8, 0.49},
    textures = {"a_cattle.png"},
    visual = "mesh",
    mesh = "a_cattle.b3d",
    visual_size = {x=5,y=5,z=5},
    makes_footstep_sound = true,
    walk_velocity = 0.8,
    run_velocity = 1.5,
    armour = {fleshy=100},
    drops = {
        {name = "4items:beef_raw",
        chance = 2,
        min = 0,
        max = 1,},
    },
    water_damage = 0,
    lava_damage = 4,
    light_damage = 0,
--    sounds = {
--        random = "adbs_cattle",
--    },
    animation = {
        speed_normal = 25,
        stand_start = 0,
        stand_end = 20,
        walk_start = 30,
        walk_end = 60,
    },
    view_range = 8,

    attractor = "farming:wheat",
    mother = nil,
    child = 800,
})

-- Piglet
adbs.register_mob("adbs:piglet", {
    mob_type = "animal",
  --  name = 'lamb',
    hp_max = 4,
    collisionbox = {-0.47, -0.2, -0.5, 0.47, 0.8, 0.49},
    textures = {"a_piglet.png"},
    visual = "mesh",
    mesh = "a_piglet.b3d",
    visual_size = {x=5,y=5,z=5},
    makes_footstep_sound = true,
    walk_velocity = 1,
    run_velocity = 1.7,
    armour = {fleshy=100},
    drops = {
        {name = "4items:porkchop_raw",
        chance = 1,
        min = 0,
        max = 1,},
    },
    water_damage = 0,
    lava_damage = 5,
    light_damage = 0,
--    sounds = {
--        random = "adbs_piglet",
--    },
    animation = {
        speed_normal = 25,
        stand_start = 0,
        stand_end = 20,
        walk_start = 30,
        walk_end = 60,
    },
    view_range = 8,

    attractor = "farming:carrot",
    mother = nil,
    child = 800,
})

-- Chick
adbs.register_mob("adbs:chick", {
    mob_type = "animal",
    name = 'chick',
    hp_max = 3,
    collisionbox = {-0.3, -0.2, -0.3, 0.3, 0.2, 0.3},
    textures = {"a_chicken.png"},
    visual = "mesh",
    mesh = "a_chick.b3d",
    visual_size = {x=3.5,y=3,z=3.5},
    makes_footstep_sound = true,
    walk_velocity = 0.6,
    run_velocity = 1,
    armour = {fleshy=100},
    drops = {
        {name = "4items:chicken_raw",
        chance = 1,
        min = 0,
        max = 1,},
    },
    water_damage = 0,
    lava_damage = 4,
    light_damage = 0,
--    sounds = {
--        random = "mobs_sheep",
--    },
    animation = {
        speed_normal = 30,
        stand_start = 0,
        stand_end = 20,
        walk_start = 30,
        walk_end = 60,
        jump_start = 70,
        jump_end = 100,
    },
    attractor = "farming:seed_wheat",
    view_range = 5,
    mother = nil,
    child = 400,
})

-- ----------------- passive ones --------------------------------

-- Wormhole
adbs.register_mob("adbs:wormhole", {
    mob_type = 2,
    hp_max = 15,
    collisionbox = {-0.47, -1, -0.5, 0.47, 1, 0.49},
    textures = {"adbs_wormhole.png"},
    visual = "mesh",
    mesh = "wormhole.x",
    visual_size = {x=5,y=5,z=5},
    makes_footstep_sound = false,
    walk_velocity = 1,
    xp = 8,
    run_velocity = 1.8,
    armour = {fleshy=60},
    flying = false,
    view_range = 16,
    attack_power = 0,
    natural_damage_timer = 0,
    disable_fall_damage = false,
    fall_tolerance = 4,
    drops = {
        {name = '4items:antimatter',
         chance = 2,
         min = 0,
         max = 1},
            },
    water_damage = 0,
    lava_damage = 5,
    light_damage = 0,
--    sounds = {
--        random = "adbs_wormhole",
--    },

    animation = {
        speed_normal    = 30,
        -- stand == 0
        stand_start     =  70,
        stand_end       = 120,
        -- walk == 1
        walk_start      =  80,
        walk_end        = 120,
        -- run == 2
        run_start       =  35,
        run_end         =  64,
        -- punch == 3
        punch_start     =   0,
        punch_end       =  29,
        -- jump = 4
        jump_start      =  30,
        jump_end        =  35,
        -- mine = 5
--        mine_start      = 189,
--        mine_end        = 198,
        -- walk_mine = 6
--        walk_mine_start = 200,
--        walk_mine_end   = 219,
        -- sit = 7
--        sit_start       =  81,
--        sit_end         = 160,
    },
    attack_proc = function(self,pot) -- pot stands for "position of a target"
        if not self.target:is_player() then self.state = 1 return end  -- attacks only players
        local the_other_one
        local pos = self.object:getpos()
        for _,ent in ipairs(minetest.get_objects_inside_radius(pos, 20)) do
           if ent.name == 'abs:wormhole' then
              the_other_one = ent
           end
        end
        if the_other_one then -- if there's another one, then teleport to it damaging
           self.target:setpos(the_other_one.object:getpos())
           local tool_capabilities = { full_punch_interval=1,
                                      max_drop_level=1,
                                      uses = 0,
                                      groupcaps={fleshy = {uses=0, times={[1]=1, [2]=1, [3]=1}}},
                                      damage_groups = {fleshy=self.attack_power or 1},
                                    },
            object:punch(the_other_one.object, 1.1, tool_capabilities) -- it's actually the other one, who punches

        else -- otherwise teleport somewhere within the "radius" of 100 blocks leaving only 25% HP
           local x,y,z = math.random(-100,100), math.random(-20,20), math.random(-100,100)
           self.target:setpos({x=x+pot.x, y=y+pot.y, z=y+pot.z})
           for i=-1,1 do
               for j=-1,1 do
                   for k=-1,1 do
                       minetest.remove_node({x=x+pot.x+i, y=y+pot.y+j, k=z+pot.z+k},1)
                   end
               end
           end
           self.target:set_hp(math.ceil(self.target:get_hp()*0.25))
        end
    end
})


-- ----------------- hostile ones --------------------------------

-- Skeleton
adbs.register_mob("adbs:skeleton", {
    mob_type = 3,
    hp_max = 20,
    collisionbox = {-0.47, -1, -0.5, 0.47, 1, 0.49},
    textures = {"adbs_skeleton.png", "3d_armor_trans.png", "3d_armor_trans.png"},
    visual = "mesh",
    mesh = "adbs_skeleton.x",
    visual_size = {x=1,y=1,z=1},
    makes_footstep_sound = true,
    walk_velocity = 1,
    xp = 5,
    run_velocity = 1.8,
    armour = {fleshy=100},
    weapon= "throwing:bow_wood",
    flying = false,
    view_range = 16,
    attack_power = 3,
    natural_damage_timer = 0,
    disable_fall_damage = false,
    fall_tolerance = 4,
    arrow = 'adbs:arrow',
    arrow_dist = 8,
    shoot_interval = 1.5,
    drops = {
        {name = '4items:white_bone',
         chance = 1,
         min = 0,
         max = 3},
        {name = 'throwing:arrow',
         chance = 1,
         min = 0,
         max = 2}},
    water_damage = 0,
    lava_damage = 5,
    light_damage = 0,
--    sounds = {
--        random = "adbs_skeleton",
--    },

    animation = {
        speed_normal    = 30,
        -- stand == 0
        stand_start     =  0,
        stand_end       = 79,
        -- walk == 1
        walk_start      = 168,
        walk_end        = 187,
        -- run == 2
        run_start       = 230,
        run_end         = 245,
        -- punch == 3
        punch_start     = 230,
        punch_end       = 230,
        -- jump = 4
        jump_start      = 235,
        jump_end        = 235,
        -- mine = 5
        mine_start      = 189,
        mine_end        = 198,
        -- walk_mine = 6
        walk_mine_start = 200,
        walk_mine_end   = 219,
        -- sit = 7
        sit_start       =  81,
        sit_end         = 160,
    },
})

-- ----------- spawn eggs registration ---------------------------------
for i, mob in ipairs(adbs.registered_mobs) do
    local name = mob:sub(mob:find(':')+1)
    minetest.register_craftitem(mob, {
        description = name:gsub("%a",string.upper,1) .. " spawn egg",
        inventory_image = "adbs_"..name.."_spawn_egg.png",

        on_place = function(itemstack, placer, pointed_thing)
            if pointed_thing.above then
               adbs.spawn_mob(pointed_thing.above, mob)
               itemstack:take_item()
            end
            return itemstack
        end,
    })
end

-- ------------- spawn registration ------------------------------------

-- nodes, near nodes, space, max/min light, chance, ent limit, max/min altitude, max/min heat, max/min humidity, mob limit, func
adbs.register_spawn("adbs:sheep", "group:cracky", _,
                    3, 15, 5, 50, 10, 100, _, 100, _, 100, _, 10, _)

adbs.register_spawn("adbs:pig", {"ethereal:mushroom_dirt","ethereal:grove_dirt_top"}, "default:water",
                    3, 15, 5, 50, 10, 100, _, 100, _, 100, _, 10, _)

adbs.register_spawn("adbs:chicken", {"ethereal:jungle_dirt","ethereal:green_dirt_top","ethereal:gray_dirt_top"}, "default:water",
                    3, 15, 5, 50, 10, 100, _, 100, _, 100, _, 10, _)

adbs.register_spawn("adbs:cow", {"ethereal:prairie_dirt","ethereal:green_dirt_top"}, "default:water",
                    3, 15, 5, 50, 10, 100, _, 100, _, 100, _, 10, _)

adbs.register_spawn("adbs:skeleton", {"group:cracky"}, "default:water",
                    3, 15, 5, 50, 10, 100, -5000, 100, _, 100, _, 10, _)
adbs.register_spawn("adbs:skeleton", {"group:cracky"}, "default:water",
                    3, 15, 5, 50, 10, -8000, -35000, 100, _, 100, _, 10, _)

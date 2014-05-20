
-----------------------------
--- 4aimobs mod by 4aiman ---
-----------------------------
--- license: CC BY-NC 3.0 ---
-----------------------------

-- This version is based upon PilzAdam's ' simple mobs'
-- with additions (ideas) from BlockMen's 'pyramids' mod.
-- 4aiman has added new animals, textures, meshes, breeding,
-- per animal spawning limit. Items dropped are from 4items mod
-- as well as cooking recipes.

walk_limit = 1
chillaxin_speed = 1
animation_speed = 40
animation_blend = 0


   local input = io.open(minetest.get_worldpath().."/chmobs.lua", "r")
   if input then
      io.close(input)
      dofile(minetest.get_worldpath().."/chmobs.lua")
   end

if not chmobs then
chmobs={}
chmobs.spawning_mobs = {}
chmobs.counters={}
chmobs.counters.cow=0
chmobs.counters.cattle=0
chmobs.counters.sheep=0
chmobs.counters.lamb=0
chmobs.counters.pig=0
chmobs.counters.pigglet=0
chmobs.counters.chicken=0
chmobs.counters.chick=0
chmobs.counters.cow_max=20
chmobs.counters.cattle_max=10
chmobs.counters.sheep_max=20
chmobs.counters.lamb_max=10
chmobs.counters.pig_max=20
chmobs.counters.pigglet_max=10
chmobs.counters.chicken_max=20
chmobs.counters.chick_max=10
chmobs.children={sheep='lamb',cow='cattle',chicken='chick',pig='piglet'}
chmobs.parents={lamb='sheep',cattle='cow',chick='chicken',piglet='pig'}
end

function get_id()
local ret = chmobs.counters.cow+
      chmobs.counters.cattle+
      chmobs.counters.sheep+
      chmobs.counters.lamb+
      chmobs.counters.pig+
      chmobs.counters.pigglet+
      chmobs.counters.chicken+
      chmobs.counters.chick
   return ret or 0
end

function decount(name)
    local nm =name:sub(name:find(':')+1)  -- extract mob's name
    chmobs.counters[nm]=chmobs.counters[nm]-1   -- decrease counter
end

function chmobs_save()
    local output = io.open(minetest.get_worldpath().."/chmobs.lua", "w")
    if output then
       local list = {
                    [1]='chmobs',
                    --[2]='chmobs.counters',
                    }
         -- global vars like max_save_time were left here to make it possible
         -- to define things per world without editing this file.
         -- It wasn't necessary - prior to the first run or inbetween
         -- the runs one can write in chmobs.lua just about anything,
         -- but it isn't obvious for everyone by just looking at chmobs.save()
         for i,var in ipairs(list) do
           o  = minetest.serialize(_G[var])
           i  = string.find(o, "return")
           o1 = string.sub(o, 1, i-1)
           o2 = string.sub(o, i-1, -1)
           output:write(o1 .. "\n")
           output:write(var .." = minetest.deserialize('" .. o2 .. "')\n")
         end

       io.close(output)
    end
end


-- not used
--[[]local shadow="4aimobs_shadow.png"
minetest.register_entity("4aimobs:shadow",{
    physical=true,
    collisionbox = {-0.5, -0.49, -0.5, 0.5, -0.48, 0.5},
    collide_with_objects = false,
    textures = {shadow,shadow,shadow,shadow,shadow,shadow},
    visual = "mesh",
    mesh = "shadow.x",
    --visual_size = {x=5,y=4.9},
    --makes_footstep_sound = true,
    --walk_velocity = 0.7,
    --armor = 200,
    is_visible = true,
})]]--



function get_animations_def()
    return {
        stand_START = 1,
        stand_END = 20,
        --sit_START = 81,
        --sit_END = 160,
        --lay_START = 162,
        --lay_END = 166,
        walk_START = 30,
        walk_END = 60,
        --mine_START = 74,
        --mine_END = 105,
        --walk_mine_START = 74,
        --walk_mine_END = 105
    }
end

function register_mob(name, def)
    setmetatable (def,default_definition)
    minetest.register_entity(name, def)
end

default_definition = {
    physical = true,
    jump = function (self, height)  -- jumping
        local v = self.object:getvelocity()
        if not height then height = 5 end
        v.y = height
        self.object:setvelocity(v)

           self.state = "jump"
           self:set_animation("jump")

    end,

    shadow=-1,
    timer = 0,
    env_damage_timer = 0, -- only if state = "attack"
    attack = {player=nil, dist=nil},
    state = "stand",
    v_start = false,
    old_y = nil,
    lifetimer = 600,  -- not used, mobs ARE immortal
    tamed = false,
    horny = false,
    hornytimer = 0,
    id = 0,

    set_velocity = function(self, v)
        local yaw = self.object:getyaw()
        if self.drawtype == "side" then
            yaw = yaw+(math.pi/2)
        end
        local x = math.sin(yaw) * -v
        local z = math.cos(yaw) * v
        self.object:setvelocity({x=x, y=self.object:getvelocity().y, z=z})
    end,

    get_velocity = function(self)
        local v = self.object:getvelocity()
        return (v.x^2 + v.z^2)^(0.5)
    end,

    set_animation = function(self, type)
        if not self.animation then
            return
        end
        if not self.animation.current then
            self.animation.current = ""
        end
        if type == "stand" and self.animation.current ~= "stand" then
            if
                self.animation.stand_start
                and self.animation.stand_end
                and self.animation.speed_normal
            then
                self.object:set_animation(
                    {x=self.animation.stand_start,y=self.animation.stand_end},
                    self.animation.speed_normal, 0
                )
                self.animation.current = "stand"
            end
        elseif type == "jump" and self.animation.current ~= "jump" then
            if
                self.animation.jump_start
                and self.animation.jump_end
                and self.animation.speed_normal
            then
                self.object:set_animation(
                    {x=self.animation.jump_start,y=self.animation.jump_end},
                    self.animation.speed_normal, 0
                )
                self.animation.current = "jump"
            end
        elseif type == "walk" and self.animation.current ~= "walk"  then
            if
                self.animation.walk_start
                and self.animation.walk_end
                and self.animation.speed_normal
            then
                self.object:set_animation(
                    {x=self.animation.walk_start,y=self.animation.walk_end},
                    self.animation.speed_normal, 0
                )
                self.animation.current = "walk"
            end
        elseif type == "run" and self.animation.current ~= "run"  then
            if
                self.animation.run_start
                and self.animation.run_end
                and self.animation.speed_run
            then
                self.object:set_animation(
                    {x=self.animation.run_start,y=self.animation.run_end},
                    self.animation.speed_run, 0
                )
                self.animation.current = "run"
            end
        elseif type == "punch" and self.animation.current ~= "punch"  then
            if
                self.animation.punch_start
                and self.animation.punch_end
                and self.animation.speed_normal
            then
                self.object:set_animation(
                    {x=self.animation.punch_start,y=self.animation.punch_end},
                    self.animation.speed_normal, 0
                )
                self.animation.current = "punch"
            end
        end
    end,

    on_step = function(self, dtime)
        if self.type == "monster" and minetest.setting_getbool("only_peaceful_mobs") then
            self.object:remove()
            -- remove itself if no hostile mobs are allowed
        end
        -- follow your mother!
        if self.mother then
           self.following=self.mother  -- follow her!!!
           self.child=self.child-dtime
           if self.child and self.child<=0 then
              local nm =self.name:sub(self.name:find(':')+1)
              local name = chmobs.parents[nm]
              local mob
              if name then
                 if chmobs.counters[name]<chmobs.counters[name..'_max'] then

                        local pos = self.object:getpos()
                        mob = minetest.add_entity(pos, '4aimobs:'..name)
                        chmobs.counters[name] = chmobs.counters[name] + 1
                        local ent=mob:get_luaentity()
                        ent.id=self.id -- inherit ID
                      --  ent.object:setyaw(self.object:getyaw())
                        ent.color=self.color
                        self.object:remove()
                 end

              end

           end
        end



        local pos = self.object:getpos()
        local n = minetest.get_node(pos)

        local pos1 = {x=pos.x,y=pos.y-1,z=pos.z}
        local pos2 = {x=pos.x,y=pos.y-2,z=pos.z}
        local n1 = minetest.get_node(pos1)
        local n2 = minetest.get_node(pos2)

        if n1.name=='air' and n2.name=='air' then
           self.state = 'jump'
           self:set_animation('jump')
        else
           self.state = 'walk'
           self:set_animation('walk')
        end

        -- "floating"
        if minetest.get_item_group(n.name, "water") ~= 0 then
           -- if it's a liquid, then check for underneath one...
           
           n = minetest.get_node(pos)
           if minetest.get_item_group(n.name, "water") == 0 and self.jump then
              --if it's IN water but there IS walkable node below it then jump
              self:jump()
           else
               -- else simulate swimming
               if not self.state == 'walk' then self.state='walk' end
               local v = self.object:getvelocity()
               v.y = 2
               self.object:setvelocity(v)
           end
           -- of course that wouldn't work if it's not a liquid that surrounds a mob
         end

        -- fall damage
        if self.object:getvelocity().y > 0.1 then
            local yaw = self.object:getyaw()
            if self.drawtype == "side" then
                yaw = yaw+(math.pi/2)
            end
            local x = math.sin(yaw) * -2
            local z = math.cos(yaw) * 2
            self.object:setacceleration({x=x, y=-10, z=z})
        else
            self.object:setacceleration({x=0, y=-10, z=0})
        end

        if self.disable_fall_damage and self.object:getvelocity().y == 0 then
            if not self.old_y then
                self.old_y = self.object:getpos().y
            else
                local d = self.old_y - self.object:getpos().y
                if d > 4 then  -- changed this to deal damages for 4-nodes-falls
                    -- make fall damage based on speed?
                    local damage = d-4
                    self.object:set_hp(self.object:get_hp()-damage)
                    if self.object:get_hp() == 0 then
                        self.object:remove()
                        if self.name then
                           local name=self.name
                           decount(name)
                        end
                    end
                end
                self.old_y = self.object:getpos().y
            end
        end

        self.timer = self.timer+dtime
        if self.state ~= "attack" then
            if self.timer < 1 then
                return
            end
            self.timer = 0
        end

        -- SFX
        if self.sounds and self.sounds.random and math.random(1, 100) <= 1 then
            minetest.sound_play(self.sounds.random, {object = self.object})
        end
        -- sheep colouring
        if self.name and self.name:find('sheep')
        and self.color
        and self.color~=self.oldcolor then
            self.oldcolor=self.color
                    self.object:set_properties({
                 textures = {"mobs_sheep_"..self.color..".png"},
                 mesh = "mobs_sheep.x",
            })
         end
        -- lamb colouring
        if self.name and self.name:find('lamb')
        and self.color
        and self.color~=self.oldcolor then
            self.oldcolor=self.color
                    self.object:set_properties({
                 textures = {"mobs_sheep_"..self.color..".png"},
                 mesh = "a_lamb.b3d",
            })
         end
        -- environmental damage
        local do_env_damage = function(self)
            local pos = self.object:getpos()
            local n = minetest.get_node(pos)

            if self.light_damage and self.light_damage ~= 0
                -- and pos.y>0
                and minetest.get_node_light(pos)
                and minetest.get_node_light(pos) > 14  -- MC like?
                and minetest.get_timeofday() > 0.2
                and minetest.get_timeofday() < 0.8
            then
                self.object:set_hp(self.object:get_hp()-self.light_damage)
                if self.object:get_hp() == 0 then
                    self.object:remove()
                        if self.name then
                           local name=self.name
                           decount(name)
                        end
                end
            end

            if self.water_damage and self.water_damage ~= 0 and
                minetest.get_item_group(n.name, "water") ~= 0
            then
                self.object:set_hp(self.object:get_hp()-self.water_damage)
                if self.object:get_hp() == 0 then
                    self.object:remove()
                        if self.name then
                           local name=self.name
                           decount(name)
                        end
                end
            end

            if self.lava_damage and self.lava_damage ~= 0 and
                minetest.get_item_group(n.name, "lava") ~= 0
            then
                self.object:set_hp(self.object:get_hp()-self.lava_damage)
                if self.object:get_hp() == 0 then
                    self.object:remove()
                        if self.name then
                           local name=self.name
                           decount(name)
                        end
                end
            end
        end

        self.env_damage_timer = self.env_damage_timer + dtime

        if self.state == "attack" and self.env_damage_timer > 1 then
            self.env_damage_timer = 0
            do_env_damage(self)
        elseif self.state ~= "attack" then
            do_env_damage(self)
        end

        -- monsters...
        if self.type == "monster" and minetest.setting_getbool("enable_damage") then
            for _,player in pairs(minetest.get_connected_players()) do
                local s = self.object:getpos()
                local p = player:getpos()
                local dist = ((p.x-s.x)^2 + (p.y-s.y)^2 + (p.z-s.z)^2)^0.5
                if dist < self.view_range then
                    if self.attack.dist then
                        if dist < self.attack.dist then
                            self.attack.player = player
                            self.attack.dist = dist
                        end
                    else
                        self.state = "attack"
                        self.attack.player = player
                        self.attack.dist = dist
                    end
                end
            end
        end

        -- following algo
        -- self.follow in an itemstring (farming:wheat)
        if self.follow and self.follow ~= "" and not self.following then
            for _,player in pairs(minetest.get_connected_players()) do
                local s = self.object:getpos()
                local p = player:getpos()
                local dist = ((p.x-s.x)^2 + (p.y-s.y)^2 + (p.z-s.z)^2)^0.5
                if self.view_range and dist < self.view_range then
                    self.following = player
                end
            end
        end


          --  if self.following then minetest.serialize(self.following:is_player()) end
            if self.following and self.following.is_player and self.following:is_player() and self.following:get_wielded_item():get_name() ~= self.follow then
                self.following = nil
                self.v_start = false
            end
               -- minetest.chat_send_all("following...")
              --  self.object:set_bone_position("Bone.001", {x=1.3796,y=2.7306,z=-0.6423}, {x=20,y=0,z=0})
      --[[  if self.following --and self.following:is_player()
        then
            minetest.chat_send_all('following!')
            local pos = self.following:getpos()
            local pos1= self.object:getpos()
            local pll = self.following:get_player_name()
           minetest.chat_send_all(minetest.serialize(pos1).. ' ' .. minetest.serialize(pos).. ' ' .. pll)
             if pos and pos1 then
            local path = minetest.find_path(pos1,pos,5,1,2,'A*_noprefetch')
            if path then
            --   minetest.chat_send_all(minetest.serialize(path))
               --self.object:moveto(path[2],true)
            end
            end
        end
]]--
            if self.following then
                local s = self.object:getpos()
                local p
                if self.following.is_player and self.following:is_player()
                then
                 p=self.following:getpos()
                elseif self.following.object then p=self.following.object:getpos()
                end
                if p then
                    local dist = ((p.x-s.x)^2 + (p.y-s.y)^2 + (p.z-s.z)^2)^0.5
                    if dist > self.view_range then
                        self.following = nil
                        self.v_start = false
                    else
                        local vec = {x=p.x-s.x, y=p.y-s.y, z=p.z-s.z}
                        local yaw = math.atan(vec.z/vec.x)+math.pi/2
                        if self.drawtype == "side" then
                            yaw = yaw+(math.pi/2)
                        end
                        if p.x > s.x then
                            yaw = yaw+math.pi
                        end
                        self.object:setyaw(yaw)
                        if dist > 2 then
                            if not self.v_start then
                                self.v_start = true
                                self.set_velocity(self, self.walk_velocity)
                            else
                                if self.jump and self.get_velocity(self) <= 0.5 and self.object:getvelocity().y == 0 then
                                    if p.y>s.y then self:jump() end
                                    -- jump only if player is higher than a mob
                                end
                                self.set_velocity(self, self.walk_velocity)
                            end
                            self:set_animation("walk")
                        else
                            self.v_start = false
                            self.set_velocity(self, 0)
                            self:set_animation("stand")
                        end
                        return
                    end
                end

        end



        if self.horny==true and self.hornytimer then
            self.hornytimer = self.hornytimer +1
            if self.hornytimer>85 then
               self.hornytimer=0
               self.horny=false
            end
        elseif self.horny==true and not self.hornytimer then
            self.hornytimer = 0
        end

        if self.horny==true and self.hornytimer>84 then self.horny=false self.lover=false end
        -- find a "lover" and make a new mob!
        if self.horny and not self.lover then
          -- minetest.chat_send_all('horny')
           local pos = self.object:getpos()
           local ents = minetest.get_objects_inside_radius(pos, 6)
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
                  self.following = ent
                  ent.following = self
                  self.lover = ent.id
                  ent.lover = self.id
                  minetest.after(7,function(dtime)
                        local mob
                        local nm =self.name:sub(self.name:find(':')+1)
                        local name = chmobs.children[nm]
                        if name and chmobs.counters[name]
                        and chmobs.counters[name..'_max'] and
                        chmobs.counters[name] < chmobs.counters[name..'_max'] then

                             mob = minetest.add_entity(pos, '4aimobs:' .. name)
                          --  if mob then print('spawned!') end
                            chmobs.counters.lamb = chmobs.counters.lamb + 1
                            local ent2=mob:get_luaentity()
                            ent2.id=get_id()

                            ent2.mother=self  -- we need mother to follow her
                            ent.horny=false
                            ent.lover=nil
                            ent.following=nil
                            ent.hornytimer=85
                            self.horny=false
                            self.hornytimer=85
                            self.lover=nil
                            self.following=nil

                            print('Spawned a '.. name ..' with id = '..tostring(ent.id))
                        end

                  end)
                --  minetest.chat_send_all(tostring(self.id)..' loves ' .. tostring(self.lover).." AND "..tostring(ent.id).." loves "..tostring(ent.lover))
                  break
               end
           end
        end

        if self.state == "stand" then
            if math.random(1, 4) == 1 then
                self.object:setyaw(self.object:getyaw()+((math.random(0,360)-180)/180*math.pi))
            end
            self.set_velocity(self, 0)
            self.set_animation(self, "stand")
            -- utilize walk_probability
            if not self.walk_prob then self.walk_prob = 1 end
            if math.random(1, 100) <= 50*self.walk_prob then
                self.set_velocity(self, self.walk_velocity)
                self.state = "walk"
                self.set_animation(self, "walk")
            end
        elseif self.state == "jump" then            
            self:set_animation("walk")
            self.set_velocity(self, self.walk_velocity)
            -- utilize walk_probability
            if not self.walk_prob then self.walk_prob = 1 end            
            if math.random(1, 100) <= 9/self.walk_prob then
                self.set_velocity(self, 0)
                self.state = "stand"
                self:set_animation("stand")
            end
        elseif self.state == "walk" then
            if math.random(1, 100) <= 30 then
                self.object:setyaw(self.object:getyaw()+((math.random(0,360)-180)/180*math.pi))
            end
            --if self.jump and self.get_velocity(self) <= 0.5 and self.object:getvelocity().y == 0 then
            --    self:jump()
            --end
            self:set_animation("walk")
            self.set_velocity(self, self.walk_velocity)
            -- utilize walk_probability
            if not self.walk_prob then self.walk_prob = 1 end
            
            if math.random(1, 100) <= 9/self.walk_prob then
                self.set_velocity(self, 0)
                self.state = "stand"
                self:set_animation("stand")
            end
        elseif self.state == "attack" and self.attack_type == "dogfight" then
            if not self.attack.player or not self.attack.player:is_player() then
                self.state = "stand"
                self:set_animation("stand")
                self.attack = {player=nil, dist=nil}
                return
            end
            local s = self.object:getpos()
            local p = self.attack.player:getpos()
            local dist = ((p.x-s.x)^2 + (p.y-s.y)^2 + (p.z-s.z)^2)^0.5
            if dist > self.view_range or self.attack.player:get_hp() <= 0 then
                self.state = "stand"
                self.v_start = false
                self.set_velocity(self, 0)
                self.attack = {player=nil, dist=nil}
                self:set_animation("stand")
                return
            else
                self.attack.dist = dist
            end

            local vec = {x=p.x-s.x, y=p.y-s.y, z=p.z-s.z}
            local yaw = math.atan(vec.z/vec.x)+math.pi/2
            if self.drawtype == "side" then
                yaw = yaw+(math.pi/2)
            end
            if p.x > s.x then
                yaw = yaw+math.pi
            end
            self.object:setyaw(yaw)
            if self.attack.dist > 2 then
                if not self.v_start then
                    self.v_start = true
                    self.set_velocity(self, self.run_velocity)
                else
                    if self.jump and self.get_velocity(self) <= 0.5 and self.object:getvelocity().y == 0 then
                        self:jump()
                    end
                    self.set_velocity(self, self.run_velocity)
                end
                self:set_animation("run")
            else
                self.set_velocity(self, 0)
                self:set_animation("punch")
                self.v_start = false
                if self.timer > 1 then
                    self.timer = 0
                    if self.sounds and self.sounds.attack then
                        minetest.sound_play(self.sounds.attack, {object = self.object})
                    end
                    self.attack.player:punch(self.object, 1.0,  {
                        full_punch_interval=1.0,
                        damage_groups = {fleshy=self.damage}
                    }, vec)
                end
            end
        elseif self.state == "attack" and self.attack_type == "shoot" then
            if not self.attack.player or not self.attack.player:is_player() then
                self.state = "stand"
                self:set_animation("stand")
                self.attack = {player=nil, dist=nil}
                return
            end
            local s = self.object:getpos()
            local p = self.attack.player:getpos()
            local dist = ((p.x-s.x)^2 + (p.y-s.y)^2 + (p.z-s.z)^2)^0.5
            if dist > self.view_range or self.attack.player:get_hp() <= 0 then
                self.state = "stand"
                self.v_start = false
                self.set_velocity(self, 0)
                self.attack = {player=nil, dist=nil}
                self:set_animation("stand")
                return
            else
                self.attack.dist = dist
            end

            local vec = {x=p.x-s.x, y=p.y-s.y, z=p.z-s.z}
            local yaw = math.atan(vec.z/vec.x)+math.pi/2
            if self.drawtype == "side" then
                yaw = yaw+(math.pi/2)
            end
            if p.x > s.x then
                yaw = yaw+math.pi
            end
            self.object:setyaw(yaw)
            self.set_velocity(self, 0)

            if self.timer > self.shoot_interval and math.random(1, 100) <= 60 then
                self.timer = 0

                self:set_animation("punch")

                if self.sounds and self.sounds.attack then
                    minetest.sound_play(self.sounds.attack, {object = self.object})
                end

                local p = self.object:getpos()
                p.y = p.y + (self.collisionbox[2]+self.collisionbox[5])/2
                local obj = minetest.add_entity(p, self.arrow)
                local amount = (vec.x^2+vec.y^2+vec.z^2)^0.5
                local v = obj:get_luaentity().velocity
                vec.y = vec.y+1
                vec.x = vec.x*v/amount
                vec.y = vec.y*v/amount
                vec.z = vec.z*v/amount
                obj:setvelocity(vec)
            end
        end
    end,


    on_activate = function(self, staticdata, dtime_s)
        self.object:set_armor_groups({fleshy=self.armor})
        self.object:setacceleration({x=0, y=-10, z=0})
        self.state = "stand"
        self.attack = {player = nil, dist = nil}
        self.object:setvelocity({x=0, y=self.object:getvelocity().y, z=0})
        self.object:setyaw(math.random(1, 360)/180*math.pi)
        if self.type == "monster" and minetest.setting_getbool("only_peaceful_mobs") then
            self.object:remove()
        end
      --  self.lifetimer = 600 - dtime_s
        if staticdata then
            local tmp = minetest.deserialize(staticdata)
            if tmp and tmp.lifetimer then
                self.lifetimer = tmp.lifetimer - dtime_s
            end
            if tmp and tmp.tamed then
                self.tamed = tmp.tamed
            end
            if tmp and tmp.color then
                self.color = tmp.color
            end
            if tmp and tmp.oldcolor then
                self.oldcolor = tmp.oldcolor
            end
            if tmp and tmp.horny then
                self.horny = tmp.horny
            end
            if tmp and tmp.hornytimer then
                self.hornytimer = tmp.hornytimer
            end
            if tmp and tmp.name then
               self.name = tmp.name
            end
            if tmp and tmp.id then
               self.id = tmp.id
            end
            if tmp and tmp.mother then
                self.mother = tmp.mother
            end
            if tmp and tmp.child then
                self.child = tmp.child
            end

        end

    end,

    get_staticdata = function(self)
        local tmp = {
            lifetimer = self.lifetimer,
            tamed = self.tamed,
            color=self.color,
            oldcolor=self.oldcolor,
            horny=self.horny,
            hornytimer=self.hornytimer,
            name=self.name,
            id=self.id,
            mother=self.mother,
            child=self.child,
        }
        return minetest.serialize(tmp)
    end,

    on_punch = function(self, hitter, time_from_last_punch, tool_capabilities, dir)
               if hitter ~= nil and hitter:is_player() then

                  local dir = hitter:get_look_dir()
                  minetest.chat_send_all(minetest.pos_to_string(dir))
                  if dir then
                        local v = self.object:getvelocity()
                        v.x = dir.x
                        v.z = dir.z
                        v.y = v.y --* dir.y
                        local dir2 = vector.multiply(dir,5)
                        self.object:setvelocity(dir2)
                        minetest.after(0.2, function(dtime)
                        self.object:setvelocity(v)
                        end)
                        --self.direction=dir
                  end
               end

        if self.object:get_hp() <= 0 then
            if hitter and hitter:is_player() and hitter:get_inventory() then
               if self.type == 'animal' then  -- butcher award
                  if awards then awards.players[hitter:get_player_name()].kill_passive = 1 end
               end
               if self.type == 'monster' then -- hunter award
                  if awards then awards.players[hitter:get_player_name()].kill_hostile = 1 end
               end
                for _,drop in ipairs(self.drops) do
                    if math.random(1, drop.chance) == 1 then
                       local obj = minetest.add_item(self.object:getpos(), drop.name.." "..math.random(drop.min, drop.max))
                    end
                end

            end
            self.object:remove()
            decount(self.name)
        end
    end,

    __index = function(table,key)
        return default_definition[key]
    end,}

function register_spawn(name, nodes, max_light, min_light, chance, active_object_count, max_height, spawn_func)
    if minetest.setting_getbool(string.gsub(name,":","_").."_spawn") ~= false then
        chmobs.spawning_mobs[name] = true
        minetest.register_abm({
            nodenames = nodes,
            neighbors = {"air"},
            interval = 30,
            chance = chance,
            action = function(pos, node, _, active_object_count_wider)
                if active_object_count_wider > active_object_count then
                    return
                end
                if not chmobs.spawning_mobs[name] then
                    return
                end
                pos.y = pos.y+1
                if not minetest.get_node_light(pos) then
                    return
                end
                if minetest.get_node_light(pos) > max_light then
                    return
                end
                if minetest.get_node_light(pos) < min_light then
                    return
                end
                if pos.y > max_height then
                    return
                end
                if minetest.get_node(pos).name ~= "air" then
                    return
                end
                pos.y = pos.y+1
                if minetest.get_node(pos).name ~= "air" then
                    return
                end
                if spawn_func and not spawn_func(pos, node) then
                    return
                end

                if minetest.setting_getbool("display_mob_spawn") then
                    minetest.chat_send_all("[4aimobs] Add "..name.." at "..minetest.pos_to_string(pos))
                end

                local mob
                if name:find('sheep')
                and chmobs.counters.sheep < chmobs.counters.sheep_max then
                    chmobs.counters.sheep = chmobs.counters.sheep + 1
                    mob = minetest.add_entity(pos, name):get_luaentity()
                    mob.id=get_id()
                elseif name:find('cow')
                and chmobs.counters.cow < chmobs.counters.cow_max then
                    chmobs.counters.cow = chmobs.counters.cow + 1
                    mob = minetest.add_entity(pos, name):get_luaentity()
                    mob.id=get_id()
                elseif name:find('pig')
                and chmobs.counters.pig < chmobs.counters.pig_max then
                    chmobs.counters.pig = chmobs.counters.pig + 1
                    mob = minetest.add_entity(pos, name):get_luaentity()
                    mob.id=get_id()
                elseif name:find('chicken')
                and chmobs.counters.chicken < chmobs.counters.chicken_max then
                    chmobs.counters.chicken = chmobs.counters.chicken + 1
                    mob = minetest.add_entity(pos, name):get_luaentity()
                    mob.id=get_id()
                end
                chmobs_save()
                 --local sha = minetest.add_entity(pos, "4aimobs:shadow")
                --sha:set_attach(mob) --, nil, position, rotation)
            end
        })
    end
end

--
-- Cow
--
register_mob("4aimobs:cow", {
    type = "animal",
    name = 'cow',
    hp_max = 10,
    collisionbox = {-0.47, -0.4, -0.5, 0.47, 0.8, 0.5},
    textures = {"a_cow2.png","a_cow2.png","a_cow2.png","a_cow2.png","a_cow2.png","a_cow2.png","a_cow2.png","a_cow2.png","a_cow2.png","a_cow2.png"},
    visual = "mesh",
    mesh = "a_cow.b3d",
    visual_size = {x=9,y=9,z=9},
    makes_footstep_sound = true,
    walk_velocity = 0.5,
    armor = 200,
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
    drawtype = "front",
    water_damage = 0,
    lava_damage = 5,
    light_damage = 0,
--    sounds = {
--        random = "mobs_sheep",
--    },
    animation = {
        speed_normal = 20,
        stand_start = 0,
        stand_end = 20,
        walk_start = 30,
        walk_end = 60,
    },
    follow = "farming:wheat",
    view_range = 5,

    on_rightclick = function(self, clicker)
        local item = clicker:get_wielded_item()
        if item:get_name() == "farming:wheat" then

                if not minetest.setting_getbool("creative_mode") then
                    item:take_item()
                    clicker:set_wielded_item(item)
                end
           if not self.horny then  -- make it want to breed+ particles spawner activation
            self.horny = true
            self.hornytimer=0
                local ppp = self.object:getpos()
                --minetest.chat_send_all(minetest.serialize(ppp))
                local sdd = minetest.add_particlespawner(
                                                        15,
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

                                                        minetest.after(1.5,function()
                                                        minetest.delete_particlespawner(sdd)
                                                        end)
            end
        end
    end,
})

minetest.register_craftitem("4aimobs:cow", {
    description = "Cow",
    inventory_image = "a_cow2.png",

    on_place = function(itemstack, placer, pointed_thing)
        if pointed_thing.above then
            local mob = minetest.add_entity(pointed_thing.above, "4aimobs:cow")
                    chmobs.counters.cow = chmobs.counters.cow + 1
                    local ent=mob:get_luaentity()
                    ent.id=get_id()
            --local sha = minetest.add_entity(pointed_thing.above, "4aimobs:shadow")
           -- sha:set_attach(mob,"Bone",{x=0,y=0,z=0},{x=0,y=0,z=0}) --, nil, position, rotation)
            itemstack:take_item()
        end
        return itemstack
    end,
})

 register_spawn("4aimobs:cow", {"default:dirt_with_grass", "group:water"}, 20, 8, 9000, 1, 200)


--
-- Pig
--
register_mob("4aimobs:pig", {
    type = "animal",
    name = 'pig',
    hp_max = 8,
    collisionbox = {-0.47, -0.4, -0.5, 0.47, 0.49, 0.49},
    textures = {"a_pig.png","a_pig.png","a_pig.png","a_pig.png","a_pig.png","a_pig.png","a_pig.png",},
    visual = "mesh",
    mesh = "a_pig.b3d",
    visual_size = {x=3.5,y=3,z=3.5},
    makes_footstep_sound = true,
    walk_velocity = 1,
    armor = 200,
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
    drawtype = "front",
    water_damage = 0,
    lava_damage = 5,
    light_damage = 0,
--    sounds = {
--        random = "mobs_sheep",
--    },
    animation = {
        speed_normal = 40,
        stand_start = 0,
        stand_end = 20,
        walk_start = 30,
        walk_end = 60,
    },
    follow = "farming:carrot",
    view_range = 5,

    on_rightclick = function(self, clicker)
        local item = clicker:get_wielded_item()
        if item:get_name() == "farming:carrot" then

                if not minetest.setting_getbool("creative_mode") then
                    item:take_item()
                    clicker:set_wielded_item(item)
                end
           if not self.horny then  -- make it want to breed+ particles spawner activasion
            self.horny = true
            self.hornytimer=0
                local ppp = self.object:getpos()
                --minetest.chat_send_all(minetest.serialize(ppp))
                local sdd = minetest.add_particlespawner(
                                                        15,
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

                                                        minetest.after(1.5,function()
                                                        minetest.delete_particlespawner(sdd)
                                                        end)
           end
        end
    end,
})

minetest.register_craftitem("4aimobs:pig", {
    description = "Pig",
    inventory_image = "a_pig.png",

    on_place = function(itemstack, placer, pointed_thing)
        if pointed_thing.above then
            local mob = minetest.add_entity(pointed_thing.above, "4aimobs:pig")
                    chmobs.counters.pig = chmobs.counters.pig + 1
                    local ent=mob:get_luaentity()
                    ent.id=get_id()
            itemstack:take_item()
        end
        return itemstack
    end,
})

-- register_spawn("4aimobs:pig", {"default:dirt_with_grass", "default:tree"}, 20, 8, 9000, 1, 200)


--
-- Sheep
--
register_mob("4aimobs:sheep", {
    type = "animal",
    hp_max = 8,
    collisionbox = {-0.47, -0.0, -0.5, 0.47, 0.49, 0.49},
    textures = {"mobs_sheep_white.png"},
    visual = "mesh",
    mesh = "mobs_sheep.x",
    visual_size = {x=1,y=1,z=1},
    makes_footstep_sound = true,
    walk_velocity = 0.7,
    armor = 200,
    drops = {
        {name = "wool:white",
        chance = 1,
        min = 0,
        max = 1,},
    },
    drawtype = "front",
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
    follow = "farming:wheat",
    view_range = 5,
    color = 'white',
    oldcolor='white',

    on_rightclick = function(self, clicker)
        local item = clicker:get_wielded_item()
        local ienm = item:get_name()
        if (not self.naked) and ienm:find('dye:') then
           local color=ienm:sub(ienm:find(':')+1)
           --if color then minetest.chat_send_all(color) end
           -- colorize the sheep's wool :)
           local item1 = "dye:"..self.color
           local item2 = "dye:"..color
           local input = {
                          method = 'normal',
                          items = {item1,item2},
                         }
           local output = minetest.get_craft_result(input)
           local otnm
           if output then otnm = output.item:get_name() end
           if otnm and otnm:find(':') then color=otnm:sub(otnm:find(':')+1) end
           self.color=color
                if not minetest.setting_getbool("creative_mode") then
                    item:take_item()
                    clicker:set_wielded_item(item)
                end
        end
        if ienm == "farming:wheat" then
                if not minetest.setting_getbool("creative_mode") then
                    item:take_item()
                    clicker:set_wielded_item(item)
                end
            if not self.horny then  -- make it want to breed+ particles spawner activation
            self.horny = true
            self.hornytimer=0
                local ppp = self.object:getpos()
                --minetest.chat_send_all(minetest.serialize(ppp))
                local sdd = minetest.add_particlespawner(
                                                        15,
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

                                                        minetest.after(1.5,function()
                                                        minetest.delete_particlespawner(sdd)
                                                        end)
             end

            if self.naked then  -- feedin 'em
                if not minetest.setting_getbool("creative_mode") then
                    item:take_item()
                    clicker:set_wielded_item(item)
                end
                self.food = (self.food or 0) + 1
                if self.food >= 8 then
                    self.food = 0
                    self.naked = false
                    self.object:set_properties({
                        textures = {"mobs_sheep_"..self.color..".png"},
                        mesh = "mobs_sheep.x",
                    })
                end
            end
            return
        end
        if ienm == 'default:shears' and not self.naked then
            self.naked = true
            local ppp = self.object:getpos()
            if minetest.registered_items["wool:".. self.color] then
                local rnd = math.random(1,3.1)
                rnd = math.modf(rnd)
                --minetest.chat_send_all("wool:".. self.color .. " " .. tostring(rnd))
                for i=1,rnd do
                local it = minetest.add_item(ppp, "wool:".. self.color)
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
            self.object:set_properties({
                textures = {"mobs_sheep_shaved.png"},
                mesh = "mobs_sheep_shaved.x",
            })
        end
    end,
})

minetest.register_craftitem("4aimobs:sheep", {
    description = "Sheep",
    inventory_image = "mobs_sheep.png",

    on_place = function(itemstack, placer, pointed_thing)
        if pointed_thing.above then
                local mob
                local name = "4aimobs:sheep"
                if chmobs.counters.sheep < chmobs.counters.sheep_max then
                    mob = minetest.add_entity(pointed_thing.above, name)
                    chmobs.counters.sheep = chmobs.counters.sheep + 1
                    local ent=mob:get_luaentity()
                    ent.id=get_id()
                -- print('Spawned a sheep with id = '..tostring(ent.id))
                end

--            local mob = minetest.add_entity(pointed_thing.above, "4aimobs:sheep")
            --local sha = minetest.add_entity(pointed_thing.above, "4aimobs:shadow")
           -- sha:set_attach(mob,"Bone",{x=0,y=0,z=0},{x=0,y=0,z=0}) --, nil, position, rotation)
            itemstack:take_item()
        end
        return itemstack
    end,
})

 -- register_spawn("4aimobs:sheep", {"default:dirt_with_grass"}, 20, 8, 9000, 1, 200)


--
-- Chicken
--
register_mob("4aimobs:chicken", {
    type = "animal",
    name = 'chicken',
    hp_max = 6,
    collisionbox = {-0.25, -0.25, -0.25, 0.25, 0.25, 0.25},
    textures = {"a_chicken.png"},
    visual = "mesh",
    mesh = "a_chicken.b3d",
    visual_size = {x=3.5,y=3,z=3.5},
    makes_footstep_sound = true,
    walk_velocity = 0.8,
    walk_prob = 0.2,
    armor = 200,
    drops = {
        {name = "4items:chicken_raw",
        chance = 1,
        min = 1,
        max = 3,},
    },
    drawtype = "front",
    water_damage = 0,
    lava_damage = 5,
    light_damage = 0,
--    sounds = {
--        random = "mobs_sheep",
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
    follow = "farming:seed_wheat",
    view_range = 5,

    on_rightclick = function(self, clicker)
        local item = clicker:get_wielded_item()
        if item:get_name() == "farming:seed_wheat" then

                if not minetest.setting_getbool("creative_mode") then
                    item:take_item()
                    clicker:set_wielded_item(item)
                end
           if not self.horny then  -- make it want to breed+ particles spawner activasion
            self.horny = true
            self.hornytimer=0
                local ppp = self.object:getpos()
                --minetest.chat_send_all(minetest.serialize(ppp))
                local sdd = minetest.add_particlespawner(
                                                        15,
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

                                                        minetest.after(1.5,function()
                                                        minetest.delete_particlespawner(sdd)
                                                        end)
           end
        end
    end,
})

minetest.register_craftitem("4aimobs:chicken", {
    description = "Chicken",
    inventory_image = "a_chicken.png",

    on_place = function(itemstack, placer, pointed_thing)
        if pointed_thing.above then
                local mob
                local name = "4aimobs:chicken"
                if chmobs.counters.chicken < chmobs.counters.chicken_max then
                    mob = minetest.add_entity(pointed_thing.above, name)
                    chmobs.counters.chicken = chmobs.counters.chicken + 1
                    local ent=mob:get_luaentity()
                    ent.id=get_id()

                   -- minetest.chat_send_all('Spawned a sheep with id = '..tostring(ent.id))
                end

--            local mob = minetest.add_entity(pointed_thing.above, "4aimobs:sheep")
            --local sha = minetest.add_entity(pointed_thing.above, "4aimobs:shadow")
           -- sha:set_attach(mob,"Bone",{x=0,y=0,z=0},{x=0,y=0,z=0}) --, nil, position, rotation)
            itemstack:take_item()
        end
        return itemstack
    end,
})



--
-- Lamb
--
register_mob("4aimobs:lamb", {
    type = "animal",
  --  name = 'lamb',
    hp_max = 4,
    collisionbox = {-0.37, -0.0, -0.37, 0.37, 0.9, 0.37},
    textures = {"mobs_sheep_white.png"},
    visual = "mesh",
    mesh = "a_lamb.b3d",
    visual_size = {x=5,y=5,z=5},
    makes_footstep_sound = true,
    walk_velocity = 0.8,
    armor = 200,
    drops = {
        {name = "wool:white",
        chance = 1,
        min = 0,
        max = 1,},
    },
    drawtype = "front",
    water_damage = 0,
    lava_damage = 5,
    light_damage = 0,
--    sounds = {
--        random = "mobs_sheep",
--    },
    animation = {
        speed_normal = 25,
        stand_start = 0,
        stand_end = 20,
        walk_start = 30,
        walk_end = 60,
    },
    view_range = 8,
    color = 'white',
    oldcolor='white',

    mother = nil,
    child = 800,

    on_rightclick = function(self, clicker)
        local item = clicker:get_wielded_item()
        local ienm = item:get_name()
        if (not self.naked) and ienm:find('dye:') then
           local color=ienm:sub(ienm:find(':')+1)
           --if color then minetest.chat_send_all(color) end
           -- colorize the sheep's wool :)
           local item1 = "dye:"..self.color
           local item2 = "dye:"..color
           local input = {
                          method = 'normal',
                          items = {item1,item2},
                         }
           local output = minetest.get_craft_result(input)
           local otnm
           if output then otnm = output.item:get_name() end
           if otnm and otnm:find(':') then color=otnm:sub(otnm:find(':')+1) end
           self.color=color
                if not minetest.setting_getbool("creative_mode") then
                    item:take_item()
                    clicker:set_wielded_item(item)
                end
        end
    end,
})

--
-- cattle
--
register_mob("4aimobs:cattle", {
    type = "animal",
  --  name = 'lamb',
    hp_max = 4,
    collisionbox = {-0.47, -0.2, -0.5, 0.47, 0.8, 0.49},
    textures = {"a_cattle.png"},
    visual = "mesh",
    mesh = "a_cattle.b3d",
    visual_size = {x=5,y=5,z=5},
    makes_footstep_sound = true,
    walk_velocity = 0.8,
    armor = 200,
    drops = {
        {name = "4items:beef_raw",
        chance = 1,
        min = 0,
        max = 1,},
    },
    drawtype = "front",
    water_damage = 0,
    lava_damage = 5,
    light_damage = 0,
--    sounds = {
--        random = "mobs_sheep",
--    },
    animation = {
        speed_normal = 25,
        stand_start = 0,
        stand_end = 20,
        walk_start = 30,
        walk_end = 60,
    },
    view_range = 8,

    follow = "farming:wheat",
    mother = nil,
    child = 800,
})

--
-- piglet
--
register_mob("4aimobs:piglet", {
    type = "animal",
  --  name = 'lamb',
    hp_max = 4,
    collisionbox = {-0.47, -0.2, -0.5, 0.47, 0.8, 0.49},
    textures = {"a_piglet.png"},
    visual = "mesh",
    mesh = "a_piglet.b3d",
    visual_size = {x=5,y=5,z=5},
    makes_footstep_sound = true,
    walk_velocity = 0.8,
    armor = 200,
    drops = {
        {name = "4items:porkchop_raw",
        chance = 1,
        min = 0,
        max = 1,},
    },
    drawtype = "front",
    water_damage = 0,
    lava_damage = 5,
    light_damage = 0,
--    sounds = {
--        random = "mobs_sheep",
--    },
    animation = {
        speed_normal = 25,
        stand_start = 0,
        stand_end = 20,
        walk_start = 30,
        walk_end = 60,
    },
    view_range = 8,

    follow = "farming:carrot",
    mother = nil,
    child = 800,
})


--
-- Chick
--
register_mob("4aimobs:chick", {
    type = "animal",
    name = 'chick',
    hp_max = 6,
    collisionbox = {-0.3, -0.2, -0.3, 0.3, 0.2, 0.3},
    textures = {"a_chicken.png"},
    visual = "mesh",
    mesh = "a_chick.b3d",
    visual_size = {x=3.5,y=3,z=3.5},
    makes_footstep_sound = true,
    walk_velocity = 0.6,
    armor = 200,
    drops = {
        {name = "4items:chicken_raw",
        chance = 1,
        min = 0,
        max = 1,},
    },
    drawtype = "front",
    water_damage = 0,
    lava_damage = 5,
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
    follow = "farming:seed_wheat",
    view_range = 5,
    mother = nil,
    child = 400,
})

print('[OK] Pieceful mobs loaded')

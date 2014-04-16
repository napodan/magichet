
-----------------------------
--- 4hunger mod by 4aiman ---
---    with the help of   ---
---       fairiestoy      ---
-----------------------------
--- license: CC BY-NC 3.0 ---
-----------------------------

----
---- Disclaimer 1 ----
----
-- This mod TRIES too copy MC hunger mechanics as described at wiki
-- here: http://minecraft.gamepedia.com/Hunger#Mechanics and FAILS to do do:
-- several things aren't covered due to internal differences of MT and MC.
-- Those are subject to get added by some other mod(s), creation of which
-- has began allready.
----

----
---- Disclaimer 2 ----
----
-- Modified "sprint" mod's code was used.
-- The original mod had NO info about it's author whatsoever and it was
-- really hard to recollect where did I get it. So, if you ARE the one -
-- tell me and I'll gladly add your name here. Be sure to provide
-- decisive evidences that you're REALLY the one, though.
----

----
---- Disclaimer 3 ----
----
-- Since lua_api documentation sucks (it's of GREAT use nevertheless),
-- I got inspired AND "guided" by some other mods that this one:
--  1. "Farming" from the "Minitest" game by PilzAdam. What hunger if
--     there's nothing to eat?
--  2. "HUD & hunger" by BlockMen. Hope, he realizes, there should be "a",
--     and "custom" is spelled as provided here. (Unless he's all like
--     Nikolai the II, The Emperor.) I make mistakes too. Stupid ones too.
--     But those two were repeated over and over, despite some community
--     members' notions, and they were pissing me off so much, that I
--     decided to edit Blockmen's HUD mod to fix those errors...
--     And then I saw that his hunger do NOT depend on taken by a player
--     actions...
--     Then I got my lazy butt up and wrote this hunger mod.
--  3. Once again, the "Sprint" mod by I-don't-know-who. Very usefull.
--
-- But "inspired" do NOT mean that I copied smth directly. I used the
-- ideas - just like any designer does. I needed examples and got them
-- from the mods above. The only exception is the "sprint" mod, but
-- that's the reason of having the 2nd disclaimer.
----

--
-- Feel free and welcomed to ask me to fix my grammar. But do not expect
-- me to fix any mistake without telling me where it is. I'm not THAT good.
--

--
-- Update: added ethereal food. Fixed unsupported food crashes.
--

--
-- Update: added poison effects
--

max_save_time    = 30  -- seconds between saving
save_time        = 0   -- seconds from the last save
max_drumsticks   = 20  -- maximum hunger points (seconds)
foodTickTimerMAX = 5   -- default time for hunger events (seconds)
max_exhaustion   = 4   -- maximum food_exhaustion level
foodTickTimerMax = {}  -- actual time for hunger events (can be reduced or extended per pll)
food_level       = {}  -- current hunger points
food_saturation  = {}  -- food saturation levels, can't be higher than food_level
food_exhaustion  = {}  -- food exhaustion levels
foodTickTimer    = {}  -- the time with food_level>17 or food_level<0
death_timer      = {}  -- keeps track of the time you had no hunger points left
walked_distance  = {}  -- keeps track of walked distance
oldHPs           = {}  -- keeps track of last known HPs (used for damage exaustion)
oldpos           = {}  -- keeps track of last known pos; in case of lags would "fix'em"
timers           = {}  -- keeps track of personal timer (used for different statuses)
sprinting        = {}  -- keeps track of sprinting physics override
state            = {}  -- -1=being idle, 0=walking, 1=sprinting, 2=swimming, 3=jumping,
                       -- attacking=4, receiving damage=5,
                       -- jumping while sprinting=6, effects of food poisoning=7 & 8
                       -- breaking a block=9, regenerating the last 2 HPs=10
hungerhud        = {}  -- hunger huds IDs
hungerhudb       = {}  -- hunger huds' bgs IDs
--eating           = {}  -- are you chewing?
--eat_timer        = {}  -- and... for how long you have been doing this?

-- food exaustion,caused by:
local ews = 0.01      -- walking or sheaking            +
local esw = 0.015     -- swimming                       +
local ebr = 0.025     -- digging anything               +
local ejp = 0.2       -- jumping                        +
local eat = 0.3       -- attacking                      -
local edm = 0.3       -- getting hurt                   +
local ef1 = 0.5       -- food poison                    -
local ef2 = 1.5       -- food poison                    -
local esj = 0.8       -- jumping while sprinting        +
local erg = 3.0       -- regenerating the last 2 HP     +
local eid = 0.001     -- idle hunger, ~1 point/100 sec  +

local max_being_hungry_time = 120 -- seconds till someone would die of hunger

local rus
local locale = os.setlocale(nil, 'collate')
if (locale:find('Russian') ~= nil) or (locale:find('ru_RU') ~= nil) then rus=true else rus = false end
rus=false

local death_message = 'No one had fed him anything... Poor '
if rus then
   death_message = 'Никто так и не покормил бедняжку '
end


local function save_4hunger()
    local output = io.open(minetest.get_worldpath().."/4hunger.lua", "w")
    if output then
       local list = {
                    [1]='foodTickTimerMax',
                    [2]='food_level',
                    [3]='food_saturation',
                    [4]='food_exhaustion',
                    [5]='foodTickTimer',
                    [6]='walked_distance',
                    [7]='oldHPs',
                    [8]='oldpos',
                    [9]='timers',
                    [10]='sprinting',
                    [11]='state',
                  --  [12]='hungerhud',   -- don't think that's a good idea to save this
                  --  [13]='hungerhudb',  -- don't think that's a good idea to save this
                    [14]='eating',        -- don't think that's a good idea to save this
                    [15]='eat_timer',     -- don't think that's a good idea to save this
                    [16]='max_save_time',
                    [17]='save_time',
                    [18]='max_drumsticks',
                    [19]='foodTickTimerMAX',
                    [20]='max_exhaustion',
                    }
         -- global vars like max_save_time were left here to make it possible
         -- to define things per world without editing this file.
         -- It wasn't necessary - prior to the first run or inbetween
         -- the runs one can write in 4hunger.lua just about anything,
         -- but it isn't obvious for everyone by just looking at save_4hunger()
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

local function load_4hunger()
   local input = io.open(minetest.get_worldpath().."/4hunger.lua", "r")
   if input then
      io.close(input)
      dofile(minetest.get_worldpath().."/4hunger.lua")
   end
end

load_4hunger()

-- the function to define food_points for un~/supported mods
-- values for 4items are from MC wiki. Haven't checked if those are adequate
-- "ps" can be 1 or 2 for different kinds of poison
local function get_points(item)
   local fp,sp,ps,stack = 0,0,0, false
    if item:find("4hunger:apple2")   then fp,sp = 02.0, 06.4 end
    if item:find('apple')            then fp,sp = 05.0, 06.0 end
    if item:find('gold_apple')       then fp,sp = 04.0, 09.6 end
    if item:find('golden_apple')     then fp,sp = 06.0, 09.6 end
    if item:find('gold_apple_2')     then fp,sp = 04.0, 09.6 end
    if item:find('banana')           then fp,sp = 01.0, 00.0 end
    if item:find('banana_bread')     then fp,sp = 06.0, 01.0 end
    if item:find('bread')            then fp,sp = 05.0, 06.0 end
    if item:find('beef_raw')         then fp,sp = 03.0, 01.8 end
    if item:find('steak')            then fp,sp = 08.0, 12.8 end
    if item:find('cake')             then fp,sp = 02.0, 00.4 end
    if item:find('carrot')           then fp,sp = 04.0, 04.8 end
    if item:find('carrot_gold')      then fp,sp = 06.0, 14.4 end
    if item:find('clownfish')        then fp,sp = 00.2, 01.2 end
    if item:find('chicken_raw')      then fp,sp = 02.0, 01.2 end
    if item:find('chicken_cooked')   then fp,sp = 06.0, 07.2 end
    if item:find('coconut_slice')    then fp,sp = 01.0, 01.0 end
    if item:find('fish_raw')         then fp,sp = 02.0, 00.4 end
    if item:find('fish_cooked')      then fp,sp = 05.0, 06.0 end
    if item:find('pine_nuts')        then fp,sp = 00.1, 01.0 end
    if item:find('porkchop_raw')     then fp,sp = 03.0, 01.8 end
    if item:find('porkchop_cooked')  then fp,sp = 08.0, 12.8 end
    if item:find('potato')           then fp,sp = 01.0, 00.6 end
    if item:find('potato_baked')     then fp,sp = 02.0, 00.4 end
    if item:find('potato_poisonous') then fp,sp = 02.0, 01.2 end
    if item:find('salmon_raw')       then fp,sp = 02.0, 00.4 end
    if item:find('salmon_cooked')    then fp,sp = 06.0, 09.6 end
    if item:find('cookie')           then fp,sp = 02.0, 00.4 end
    if item:find('melon')            then fp,sp = 02.0, 01.2 end
    if item:find('mushroom_stew')    then fp,sp = 05.0, 00.2 end
    if item:find('hearty_stew')      then fp,sp = 08.0, 04.2 end
    if item:find('hearty_stew_co')   then fp,sp = 10.0, 06.2 end
    if item:find('mushroom_soup')    then fp,sp = 04.0, 00.2 end
    if item:find('mushroom_soup_co') then fp,sp = 06.0, 07.2 end
    if item:find('pufferfish')       then fp,sp = 01.0, 00.2 end
    if item:find('pumpkin_pie')      then fp,sp = 08.0, 04.8 end
    if item:find('rotten_flesh')     then fp,sp = 04.0, 00.8 end
    if item:find('spider_eye')       then fp,sp = 02.0, 03.2 end
    if item:find('strawberry')       then fp,sp = 01.0, 01.2 end
    if item:find('wild_onion')       then fp,sp = 00.2, 01.6 end
    -- set the poisonous flag!
    if item:find('poisonous')        then ps    = 1          end
    if item:find('bucket_cactus')    then fp,sp,ps,stack = 2,0,nil,"bucket:bucket_empty" end

    if fp~=0 and sp~=0
    then return fp,sp,ps,stack
    else return false
    end
end

local old_eat=minetest.item_eat

-- the function used to substitute the real function
function minetest.item_eat(food_points, saturation_points, replace_with_item)
    return function(itemstack, user, pointed_thing)  -- closure
        if itemstack --[[ and pointed_thing and pointed_thing.type~='node' ]] then
           local f = food_points
           if not user or not user:is_player() then return itemstack end
           local pll = user:get_player_name()
           local wstack = itemstack:get_name()
           -- if there's nothing to fill then do NOT use the item
           if food_level[pll]>=max_drumsticks then return itemstack end
           itemstack:take_item()
           if (not food_points)
           or (not saturation_points)
           then
               food_points,saturation_points,poisoned,restack = get_points(wstack)
           end
           if not food_points then old_eat(f) return end

            if food_level[pll] then
               if food_level[pll]+food_points<=max_drumsticks then
                  food_level[pll]=food_level[pll]+food_points
               else
                  food_level[pll]=max_drumsticks
               end
            else
               food_level[pll]=max_drumsticks
            end

            if food_saturation[pll] then  -- if fs is defined

               if food_saturation[pll]+saturation_points<=food_level[pll]
               then                       -- if fs IS defined and is less than fl+sp
                  food_saturation[pll]=food_saturation[pll]+saturation_points
               else                       -- if fs IS defined and is MORE than fl+sp
                  food_saturation[pll]=food_level[pll]
               end
            else -- if fs is NOT defined
               food_saturation[pll]=food_points
            end

            if poisoned then
                if poisoned==1 then state[pll] = 7 end
                if poisoned==2 then state[pll] = 8 end
                --print(poisoned)
            end

            itemstack:add_item(replace_with_item) -- note: replace_with_item is optional
        end
        if restack then return restack end
        return itemstack
    end
end

-- distance finder
function distance(pos1,pos2)
    if not pos1 or not pos2 then
       return 0
    end
    return math.sqrt( (pos1.x - pos2.x)^2 + (pos1.y - pos2.y)^2 + (pos1.z - pos2.z)^2 )
end

-- load stuff & set defaults on_join
minetest.register_on_joinplayer(function(player)
  if player then
     local pll = player:get_player_name()
     -- by default food_level->hp influence is caused per foodTickTimerMAX seconds
     if not foodTickTimerMax[pll] then foodTickTimerMax[pll]=foodTickTimerMAX end
     -- if the "hunger" value wasn't saved then "grant" him maximum of it
     if not food_level[pll] then food_level[pll] = max_drumsticks end
     -- if death_timer wasn't saved then zero it
     if not death_timer[pll] then death_timer[pll] = 0 end
     -- if food_saturation also doesn't exist then make it equal to the food_level
     if not food_saturation[pll] then food_saturation[pll]=food_level[pll] end
     --
     if not timers[pll] then timers[pll] = -1 end

     minetest.after(0.5, function()
     -- add hunger hud background
     hungerhudb[pll]=player:hud_add({
        hud_elem_type = "statbar",
        position = {x=0.5,y=0.9},
        direction=1,
        text = "hunger_tile_b.png",
        number = max_drumsticks,
        alignment = {x=-1,y=-1},
        offset = {x=12, y=0},
     })
     -- add hungerhud
     hungerhud[pll]=player:hud_add({
        hud_elem_type = "statbar",
        position = {x=0.5,y=0.9},
        direction=1,
        text = "hunger_tile.png",
        number = max_drumsticks,
        alignment = {x=-1,y=-1},
        offset = {x=12, y=0},
     })
    end)
  end
end)

-- test item
minetest.register_craftitem("4hunger:apple2", {
    description = "Strange ApPlE",
    inventory_image = "default_apple.png",
    on_use= minetest.item_eat(1),
    on_eat= true,
})

local function get_field(item,field)
    if minetest.registered_nodes[item] then return minetest.registered_nodes[item][field] end
    if minetest.registered_items[item] then return minetest.registered_items[item][field] end
    if minetest.registered_craftitems[item] then return minetest.registered_craftitems[item][field] end
    if minetest.registered_tools[item] then return minetest.registered_tools[item][field] end
    return ""
end

local function get_on_eat(item)
    return get_field(item,"on_eat")
end

local function eatbar(item)
    local texture = get_field(item,"inventory_image")
    local res = nil
    if texture then
       res={hud_elem_type = "image",
            position = {x=0.5, y=1},
            offset = {x=0, y=-70},
            alignment = {x=0, y=0},
            number = 0xFFFFFF ,
            text = texture,
            scale = {x=8,y=8}
            }
    end
    return res
end

-- time based events like: status changes, damage & distance calculation & applying damage
minetest.register_globalstep(function(dtime)
   if save_time > max_save_time then
      save_time=0
      save_4hunger()
   else
      save_time=save_time+dtime
   end
   local players = minetest.get_connected_players()
   for i,player in ipairs(players) do
       local pll = player:get_player_name()
       local pos = player:getpos()
       local hp  = player:get_hp()
       local control = player:get_player_control()
       local wstack = player:get_wielded_item():get_name()
       local bar
       local addex = 0

     if hp==1 then
        death_timer[pll] = death_timer[pll] + dtime
      --  print(death_timer[pll])
     end

     if death_timer[pll] > max_being_hungry_time then
        death_timer[pll] = 0
        minetest.chat_send_all(death_message .. pll)
        food_level[pll] = max_drumsticks
        food_saturation[pll] = food_level[pll]
        player:set_hp(0)
     end

     if state[pll] == 7 or state[pll] == 8 then
        if not timers[pll] then
           timers[pll] = 15
           player:hud_change(hungerhudb[pll],"text",'hunger_tile_d.png')
           player:hud_change(hungerhud[pll] ,"text",'hunger_tile_c.png')
           sprinting[pll] = true
            if hp>1 then
               player:set_hp(hp-1)
               hp=hp-1
            end
        end
     end

     if timers[pll] then
        timers[pll] = timers[pll] - dtime
         if timers[pll]<0 then
            timers[pll]=nil
              player:hud_change(hungerhudb[pll],"text",'hunger_tile_b.png')
              player:hud_change(hungerhud[pll] ,"text",'hunger_tile.png')
         else
            if hp>1 and math.random()<0.1 then
               player:set_hp(hp-1)
               hp=hp-1
            end
         end
     end
       -- get HP vs oldHP difference --
       local hp_diff = 0
       if oldHPs[pll] and hp then   -- assume that player took damage
          hp_diff = oldHPs[pll]-hp  -- but if hp_diff<0 then the "player"
       end                          -- got healed and should take food
                                    -- exaustion damage if hp>18
       if hp_diff>0 then            -- if HPs ammount really has decreased
          state[pll] = 5            -- then set "state" to "receiving dmg"
       end

       oldHPs[pll] = hp             -- after that we can save hp to oldHPs

       -- if oldpos[pll] and pos exist then get the distance
       local dist = distance(oldpos[pll],pos) -- walked distance;

       -- "sprint" mod's code below
        if player:get_player_control().up == true and sprinting[pll] == nil then
            minetest.after(0.10, function()
                if player:get_player_control().up == false then
                    minetest.after(0.10, function()
                        if player:get_player_control().up == true then
                            if not isghost or not isghost[pll] then  -- support for my ghosts mod
                                player:set_physics_override({
                                                speed = 1.7, -- multiplier to default value
                                                jump = 1.0, -- multiplier to default value
                                                gravity = 1.0, -- multiplier to default value
                                                sneak = true, -- whether player can sneak
                                                sneak_glitch = false, -- whether player can use the sneak glitch
                                               })
                            else
                                player:set_physics_override({
                                                speed = 1, -- multiplier to default value
                                                jump = 1.1, -- multiplier to default value
                                                gravity = 0.2, -- multiplier to default value
                                                sneak = false, -- whether player can sneak
                                                sneak_glitch = true, -- whether player can use the sneak glitch
                                               })
                            end
                            sprinting[pll] = true
                        end
                    end)
                end
            end)
        elseif player:get_player_control().up == false and sprinting[pll] == true then
            minetest.after(0.1, function()
                if player:get_player_control().up == false then
                    sprinting[pll] = nil
                    if not isghost or not isghost[pll] then
                        player:set_physics_override({
                                        speed = 1.0, -- multiplier to default value
                                        jump = 1.0, -- multiplier to default value
                                        gravity = 1.0, -- multiplier to default value
                                        sneak = true, -- whether player can sneak
                                        sneak_glitch = false, -- whether player can use the sneak glitch
                                       })
                    else
                        player:set_physics_override({
                                        speed = 0.5, -- multiplier to default value
                                        jump = 1.05, -- multiplier to default value
                                        gravity = 0.1, -- multiplier to default value
                                        sneak = false, -- whether player can sneak
                                        sneak_glitch = true, -- whether player can use the sneak glitch
                                       })
                    end
                end
            end)
        end
       -- "sprint" mod's code above

       -- flags --
       pos.y=pos.y-1
       local node = minetest.get_node(pos)
       name = node.name

       if sprinting[pll] then state[pll]=1 end -- sprinting

       if name:find("air") then
          if state[pll] == 1 then
             state[pll] = 6 -- jumping while sprinting
          else
             state[pll] = 3 -- jumping
          end
       else
           if dist and dist>0 then
              state[pll] = 0   -- walking or steady
           else
              state[pll] = -1  -- idle
           end
       end

       pos.y=pos.y+1
       local node = minetest.get_node(pos)
       local name = node.name
       if minetest.get_item_group(name, "water") ~= 0 then
           state[pll] = 2 -- swimming
       end

       -- foodTickTImer increment (if hunger=0 of above 17) --
       if food_level[pll]==0 or (food_level[pll]>17 and food_level[pll]<=max_drumsticks)
       then
           if foodTickTimer[pll]
           then foodTickTimer[pll] = foodTickTimer[pll] + dtime
           else foodTickTimer[pll] = dtime
           end
       end

       if foodTickTimer[pll]>foodTickTimerMax[pll] then
          -- foodTickTimer functioncall (dmg or regen)
         if food_level[pll]>17 and food_level[pll]<=max_drumsticks then if hp>0 then player:set_hp(hp+1) end
         elseif food_level[pll]==0 then
             if hp>1 then
                player:set_hp(hp-1)
                hp = hp-1
             end
         end
          foodTickTimer[pll] = 0
       end

       -- wallked distance --
       if not walked_distance[pll] then walked_distance[pll] = 0 end  -- if there's record for a player then
       oldpos[pll]=pos
       walked_distance[pll] = walked_distance[pll] + dist          -- accumulate total distance

       -- regenerating last 2 hp, set "state" to an appr. value
       if hp_diff<0 and hp>18 then state[pll]=10 end

       if not state[pll] then state[pll]=-1 end      -- idle
       if     state[pll]==-1 then addex=eid          -- staying still
       elseif state[pll]==00 then addex=ews*dist     -- walking or sneaking
       elseif state[pll]==01 then addex=esp*dist     -- sprinting
       elseif state[pll]==02 then addex=esw*dist     -- swimming
       elseif state[pll]==03 then addex=ejp*dist     -- jumping or falling
       --elseif state[pll]==04 then addex=eat*dist     -- attacking
       elseif state[pll]==05 then addex=edm*hp_diff  -- taking damage
       elseif state[pll]==06 then addex=esj*dist     -- jump/fall while sprinting
       elseif state[pll]==07 then addex=ef1*dist     -- food poison per sec 1
       elseif state[pll]==08 then addex=ef2*dist     -- food poison per sec 2
       --elseif state[pll]==09 then addex=ebr*dist     -- digging smth
       elseif state[pll]==10 then addex=erg*-hp_diff  -- healing the last 2 HPs
       end
       -- applying exaustion
       if food_exhaustion[pll] then
          food_exhaustion[pll]=food_exhaustion[pll]+addex
       else
           food_exhaustion[pll]=addex
       end

       -- at this point "food_exaustion[pll]" just can't be undefined
       if food_exhaustion[pll]>max_exhaustion then
          if food_saturation[pll] then
             food_saturation[pll] = food_saturation[pll]-1
             if food_saturation[pll]<0 then food_saturation[pll]=0 end
          else
             food_saturation[pll] = food_level[pll]-1
          end
          if food_saturation[pll]==0 then food_level[pll]=food_level[pll]-1 end
          if food_level[pll]<0 then food_level[pll]=0 end
          food_exhaustion[pll] = 0
       end

       -- change hungerhud's number
       if hungerhud[pll] and food_level[pll] then
          player:hud_change(hungerhud[pll],"number",food_level[pll])
       end
   end
end)


minetest.register_on_dignode(function(pos, oldnode, digger)
  if not digger then return end
  local pll = digger:get_player_name()
  state[pll]=9
  if food_exhaustion[pll] then
     food_exhaustion[pll]=food_exhaustion[pll]+ebr
  else
      food_exhaustion[pll]=ebr
  end
end)

minetest.after(1,function(dtime)
    for cou,def in pairs(minetest.registered_craftitems) do
        if get_points(def['name']) ~= false then
          def['on_use'] = minetest.item_eat(1)
          minetest.register_item(':' .. def['name'], def)
        end
    end
end )


------------------------------------
---- enchantment mod by 4aiman -----
----        prerelease         -----
------------------------------------
----- license: CC BY-NC-SA 3.0 -----
------------------------------------

--------------------------------------------------------------------------------
-- This mod adds enchantment! Yep, similar to that of Minecraft :)
-- Yet, there are differences. This mod is dependent on either specialties or
-- ghosts mod. The latter is prefered and it is ghosts that'll be used if both
-- are installed.
--
-- So, basics are the same - three enchantements with weird names and (pseudo)
-- random cost. If there's only specialties - XP would be taken from the
-- enchanter. If there's ghosts mod - you'll need to lay your hands on some
-- ectoplazm.
--
-- To get some descent enchantements you'll need to be lucky.
-- Mechanics are well explained here: http://minecraft.gamepedia.com/Enchanting
--
-- Note:
--------
-- While enchantment is MC feature I'd like to have different names for stuff ;)
--------------------------------------------------------------------------------

-- Stop the engine if there's neither specialties nor ghosts...
if not (specialties or ghosts) then
  error('\nThe "enchatnment" mod needs "specialties" or "ghosts".\nThe latter is prefered if both are being used.\n')
end

local gsm = ghost_speed_modifier or 0.5
local gjm = ghost_jump_modifier or 1.05
local ggm = ghost_gravity_modifier or 0.1
local gsv = ghosts_sneak_value or false
local gsg = ghosts_sneak_glitch or true

-- First things first: I'll need random numbers!
math.randomseed(os.time())
math.random()

-- Then I'll need a table with effects applied to a player. Really hacky.
pchants = {}

-- Then a thing to track current wielded item
wielded_chant = {}

-- Add some basic colors
local dcolor = '#aaaaaa'
local ecolor = '#cccccc'
local scolor = '#ffffcc'

-- Level modifier:
-- This is used to calculate the 'base level' of available enchantment.
-- Minecraft has "player level", Minetest and Freeminer have no such feature.
-- So I'm using either ectoplasm or total XP from specialities.
-- In MC one can gain 30 LV with only 1 enchanted with "Durability III" diamond
-- pickaxe. That enchantment increase durability by 3-4 times.
-- The diamond pick have roughly 1500 uses. 1500x4 = roughly 6000 nodes.
-- But in MC one can't gain XP by building or by digging any kind of a node.
-- So I assumed that leveling in MT and FM is a lot easier.
-- To balance that I've increased the number from 6000 to 10000.
-- And here's when "magic" comes. MC have only 30 levels of enchantments.
-- And I don't see a reason to change that. So 10000 XP should be equal to LV30.
-- Simple arithmetics tells us that we should use the divider of ~333.[3], but
-- I hate such a number so, let it be 330 instead. Close enough if you ask me.

-- But "specialties" mod is only a fallback. The true "fuel" to enchantments is
-- the ectoplasm. It's a little harder to get, since you must cook some ghostly
-- blocks in order to obtain ectoplasm, you'll need some coal or other fuel.
-- That means you not only are to dig, but to become a ghost and to collect some
-- ghostly blocks. Besides, all your XP from specialties would be lost if you
-- reincarnate w/o using the reincarnator.
-- To balance that I've decided to introduce another way to get some ectoplasm:
-- You may pick it where ghosts have been frequently.
-- While this way XP can be farmed, you still need to be a ghost or to follow
-- one to cause ectoplasm appear.
-- So I've also decreased ammount of ectoplasm that's equal to 30 LV.
-- That number is only 3000 ATM! It's the subject to change, though. (Balancing
-- etc...)

-- the level_modifier for specialties:
local lm = 330

-- and the level_modifier for ghosts:
local glm = 100

-- List of words used to create names of spells (55 total):
local words = {'ain ', 'young ', 'sprites ', 'unatas ', 'kafuzi ', 'cropi ', 'yaicy ', 'damen ', 'curen ', 'dimen ', 'shineish ', 'wata ', 'gas ', 'terra ', 'oilus ', 'cod ', 'wot ', 'thir ', 'per ', 'offput ', 'sniff ', 'lessened ', 'strat ', 'longing ', 'pressur ', 'miggle ', 'createn ', 'anuet ', 'chrispene ', 'secrait ', 'lgpl ', 'freedom ', 'areal ', 'on ', 'backing ', 'outers ', 'circle ', 'node ', 'miss ', 'misty ', 'boxy ', 'psycho ', 'strength ', 'begg ', 'paying ', 'holys ', 'simpliest ', 'fleshy ', 'humani ', 'kindofth ', 'monts ', 'alienoid ', 'unlive ', 'olden ', 'letus '}

local words_rus = {'айн ', 'ломод ', 'спрайтус ', 'юнатус ', 'кафузи ', 'кропи ', 'июйси ', 'дамен ', 'кюрэн ', 'димэн ', 'блестич ', 'оата ', 'гас ', 'терра ', 'ойлус ', 'код ', 'вот ', 'фир ', 'пер ', 'внеклад ', 'хлюп ', 'деменцен ', 'страт ', 'долген ', 'давит ', 'миггл ', 'вогранен ', 'анует ', 'криспене ', 'секрайт ', 'мплг ', 'свобода ', 'место ', 'вкл ', 'спином ', 'внешки ', 'круг ', 'узел ', 'мимо ', 'дымно ', 'квадратно ', 'псюхо ', 'сила ', 'просить ', 'плата ', 'свято ', 'просто ', 'мясо ', 'чело ', 'типато ', 'мсяцы ', 'ксеном ', 'нежить ', 'старче ', 'годус '}

-- List of magick textures. Add yours to have shelves spawn them. x16 prefered.
local glyphs = {'enchantment_glyph1.png','enchantment_glyph2.png','enchantment_glyph3.png','enchantment_glyph4.png','enchantment_glyph5.png'}

local leech_timers = {}
local enplhuds = {}
local hudtime = 0
local hudtimemax = 0.1

-- Func to get random element from a table
local function random_elem(array)
   return array[math.random(#array)]
end

-- Func to create a spell out of 3-4 words
-- ";" used to divide the spell into two lines
function generate_spell()
   local str = {}
   for i=1,math.random(4,5) do
       table.insert(str,random_elem(words))
   end
   str[3] = ';'
   return table.concat(str)
end

-- This creates a string to be added to a formspec to create a button with a spell
local function ench_item(y,line1,line2,cost,bg,disabled)
if not bg then bg = ecolor end
if not line1 then line1="Line 1" end
if not line2 then line2="Line 2" end
local fl =     "box[3,".. y*1.1 ..";5.8,1;".. bg .."]"..
               "image_button[3,".. y*1.1 ..";3.2,0.6;enchantment_bg.png;ench".. y .."l1;".. line1 ..";false;false]"..
               "image_button[3,".. y*1.1+0.5 ..";3.2,0.6;enchantment_bg.png;ench".. y .."l2;".. line2 ..";false;false]"..
               "image_button[7.8,".. y*1.1-0.1 ..";1,1;enchantment_bg.png;ench".. y .."l3;".. cost ..";false;false]"
if disabled then
   fl = fl .. "image_button[3,".. y*1.1 ..";6,1.2;enchantment_bg2.png;ench".. y ..";;false;false]"
else
   fl = fl .. "image_button[3,".. y*1.1 ..";6,1.2;enchantment_bg.png;ench".. y ..";;false;false]"
end

return fl
end

-- Func used for searching the bookshelves
-- Unlike MC's one this doesnt care if there's anything between the shelf and
-- the table, only 'bout the gap itself
local function shelves_near(pos)
    local minp = {x=pos.x-1, y=pos.y-1, z=pos.z-1}
    local maxp = {x=pos.x+1, y=pos.y+1, z=pos.z+1}
    local rad1 = minetest.find_nodes_in_area(minp, maxp, 'default:bookshelf')
          minp = {x=pos.x-2, y=pos.y-2, z=pos.z-2}
          maxp = {x=pos.x+2, y=pos.y+2, z=pos.z+2}
    local rad2 = minetest.find_nodes_in_area(minp, maxp, 'default:bookshelf')
    local cou = 0
    if #rad1 and #rad2 then cou = #rad2-#rad1 end
    return math.min(cou, 15)
end

-- Enchantment table formspec
local  tform = "size[9,9.5]"..   -- funny, considering I'm a Pascal programmer ))
            "bgcolor[#bbbbbb;false]"..
            "listcolors[#777777;#cccccc;#333333;#555555;#dddddd]"..

            "image_button[9.0,-0.3;0.80,1.7;b_bg2.png;just_bg;Z;true;false]"..
            "image_button[9.2,-0.2;0.5,0.5;b_bg.png;sort_horz;=;true;true]"..
            "image_button[9.2,0.3;0.5,0.5;b_bg.png;sort_vert;||;true;true]"..
            "image_button[9.2,0.8;0.5,0.5;b_bg.png;sort_norm;Z;true;true]"..

               "image_button[1,2;1,1;enchantment_reload.png;refresh;;false;false;enchantment_reload2.png]"..
               "label[0.25,0;Item to enchant]"..
               "label[3.25,0;List of available enchantements:]"..
               "list[context;itm;1,1;1,1;]"..
            "list[current_player;helm;0,0;1,1;]"..
            "list[current_player;torso;0,1;1,1;]"..
            "list[current_player;pants;0,2;1,1;]"..
            "list[current_player;boots;0,3;1,1;]"..

            "list[current_player;main;0,4.5;9,3;9]"..
            "list[current_player;main;0,7.7;9,1;]"


-- Func to draw empty list
local function empty_formspec()
return tform..
       ench_item(1,"","","","#aaaaaa") ..
       ench_item(2,"","","","#aaaaaa") ..
       ench_item(3,"","","","#aaaaaa")
end

-- Func to draw enchantments table with 0-3 enabled elements
-- Turned out to be useless, as the formspec didn't update
-- after meta had been changed (until another receive_fields
-- which changes the formspec once again...)
local function enable_items(arg,form)
    if not arg or type(arg)~='table' then return false end
    for _,i in ipairs(arg) do
       local str1 = "3,".. i*1.1 ..";5.8,1;#aaaaaa"
       local str2 = "3,".. i*1.1 ..";5.8,1;#ffffcc"
       form = string.gsub(form, str1, str2)
    end
    return form
end

-- Func to get total amount of the "ectoplasm" item a player has
local function get_gb_count(player)
   if not player then return 0 end
   local inv = player:get_inventory()
   local cou = 0
   for i,stack in ipairs(inv:get_list("main")) do
       if stack:get_name():find('ghosts:ectoplasm') then
          cou = cou + stack:get_count()
       end
   end
   return cou
end

-- Func used to calculate summary level for al specialties
local function get_sp_count(player)
  if not player then return 0 end
  local pll = player:get_player_name()
  local res = 0
  for skill,num in pairs(specialties.players[pll].skills) do
      res = res+num
  end
  return res
end

-- Func to determine the max level of enabled enchantments
local function get_player_level(player)
   if not player then return 0 end
   local pll = player:get_player_name()
   local res
   if ghosts then
      if math.floor(get_gb_count(player)/glm) == 0 then
         -- if there isn't enough ectoplasm then use XP
         res = math.floor(get_sp_count(player)/lm)
      else
         res = math.floor(get_gb_count(player)/glm)
      end
   else
      res = math.floor(get_sp_count(player)/lm)
   end
   return res
end

-- Func to get base level of enchantments listed
local function get_base_level(pos)
  local shelves = shelves_near(pos)
  local base = math.random(1,8)+(shelves/2)+math.random(0,shelves)
  return base
end

-- Func imitating trianlgular dispersion. r0uGhLy.
local function trirandom(a,b)
   return (math.random(a,b)+math.random(a,b))/2
end

-- Func to get material of which an item was made
function get_enchantment_points(item,level)
   local modifier = -1
   if not item or not level then return modifier end
   local def = minetest.registered_items[item]
   -- if item is unknown/unsupported then it won't get even lvl 1 enchantment
   -- EVERY time with NO regard to material >:)
   if not def then return modifier end
   if def.tool_capabilities and def.tool_capabilities["enchantability"] then
      local modifier = def.tool_capabilities["enchantability"]
   elseif minetest.get_item_group(def.name, 'armor_use') then
      modifier = def.enchantability
   end
   -- again, w/o proper registration a tool would be more or less useless
   if not modifier then return -1 end
   -- MC-way to find out enchantment points.
   modifier = (level + trirandom(0,modifier/4*2)+1) * trirandom(0.85, 1.15)
   return modifier
end

-- Func to make up all 3 enchantemenst (formspec)
local function make_ench_list(player,pos,item)
  if not (player or pos) then return empty_formspec() end
  local pll_lv = get_player_level(player)
  --print(pll_lv)
  if pll_lv<=0 then return empty_formspec() end
  -- no points - no enchantments
  local ep = get_enchantment_points(item,pll_lv)
  if ep < 0
  then
     return empty_formspec()
  end
  -- find out levels we need to enchant
  local base = get_base_level(pos)
  local levels = {}
  local shelves = shelves_near(pos)
  levels[1] = math.ceil(math.max(base/3,1))
  levels[2] = math.ceil((base*2/3)+1)
  levels[3] = math.ceil(math.max(base,shelves*2))

  local meta = minetest.get_meta(pos)
  meta:set_string('lvl1',levels[1])
  meta:set_string('lvl2',levels[2])
  meta:set_string('lvl3',levels[3])
  -- decide which items should be disabled
  local lvl = get_player_level(player)
  local list = {}
  -- The same amount of space would've been used if I've chosen to use "for"
  if lvl<levels[1] then table.insert(list,'#aaaaaa') else table.insert(list,'#ffffcc')  end
  if lvl<levels[2] then table.insert(list,'#aaaaaa') else table.insert(list,'#ffffcc')  end
  if lvl<levels[3] then table.insert(list,'#aaaaaa') else table.insert(list,'#ffffcc')  end
  local tab = string.split(generate_spell(),';')
  local one,one_ = tab[1], tab[2]
  local tab = string.split(generate_spell(),';')
  local two,two_ = tab[1], tab[2]
  local tab = string.split(generate_spell(),';')
  local thr,thr_ = tab[1], tab[2]

  local res = tform..
              ench_item(1,one,one_,levels[1],list[1],lvl<levels[1]) ..
              ench_item(2,two,two_,levels[2],list[2],lvl<levels[2]) ..
              ench_item(3,thr,thr_,levels[3],list[3],lvl<levels[3])
  return res
end

-- The main table with enchantents
-- I took the advantage of the 0th element and used it to store the "weight"
-- of a spell. "Weight" is a probability of this enchantment to be applied.
-- The names are my associations with MC enchantments' names.
--
-- NOTE:
-- Magic has NO limits. I can't see why one shouldn't be able to enchant his/her
-- sword with defence or some other passive effect.
-- What I see, is that enchantment can act like effects gained by whielding
-- items in Sacred and other Diablo-like games.
-- Basically this means that any player would be able to change his stats by
-- switching armor and/OR wielded tool/weapon. Neat ;)
-- But MC does have a point, though. We shouldn't be able to get the same effect
-- of different levels or to stack them.
-- That's the work for a professional blacksmith. (yep, a todo)
--
-- However, MT engine DOES have it's limits. So I can't make an armor piece that
-- would change ATK or dig_times...

local mte = {
                ['Rampart'] = { -- break the armour faster
                           [0] = 10,
                           [1] = {  1,  21},
                           [2] = { 12,  32},
                           [3] = { 23,  43},
                           [4] = { 34,  54},
                           [5] = { 45,  65},
                      },
                ['Fire affinity'] = { -- with a probability of lv/50 gives +1 hp
                           [0] = 5,   -- per dtime (if your legs are in lava)
                           [1] = { 10,  22},
                           [2] = { 18,  30},
                           [3] = { 26,  38},
                           [4] = { 34,  46},
                           [5] = { 42,  56},
                      },
                ['Antigravity'] = { -- decreases gravity by 0.1 per level
                           [0] = 5,
                           [1] = {  5,  15},
                           [2] = { 11,  21},
                           [3] = { 17,  27},
                           [4] = { 23,  33},
                           [5] = { 29,  65},
                      },
                ['Unexplode'] = { -- extra protection from explosions
                           [0] = 2,
                           [1] = {  5,  17},
                           [2] = { 13,  25},
                           [3] = { 21,  33},
                           [4] = { 29,  41},
                           [5] = { 37,  49},
                      },
                ['Sniperbane'] = { -- extra protection against projectiles
                           [0] = 5,
                           [1] = {  3,  18},
                           [2] = {  9,  24},
                           [3] = { 15,  30},
                           [4] = { 21,  36},
                           [5] = { 27,  42},
                      },
                ['Aqualung'] = {-- with a probability of lv/50 give +1 air/dtime
                           [0] = 2,
                           [1] = { 10,  40},
                           [2] = { 20,  50},
                           [3] = { 30,  60},
                           [4] = { 40,  70},
                           [5] = { 50,  80},
                      },
--[[                ['Diving'] = {
                           [0] = 2,
                            -- only 1 level to normalize digging time
                           [1] = {  1,  41},
                      },]]
                ['Spikes'] = { -- theoretically should damege and knockback the attacker
                           [0] = 1,
                           [1] = { 10,  60},
                           [2] = { 30,  80},
                           [3] = { 50, 100},
                           [4] = { 70, 120},
                           [5] = { 90, 140},
                      },
                -- from here on go enchantments for tools
                ['Casualty'] = { -- extra damage to peaceful mobs
                           [0] = 10,
                           [1] = {  1,  21},
                           [2] = { 12,  32},
                           [3] = { 23,  43},
                           [4] = { 34,  54},
                           [5] = { 45,  65},
                      },
                ['Undertaker'] = { -- extra damage to the undead
                           [0] = 5,
                           [1] = {  5,  25},
                           [2] = { 13,  33},
                           [3] = { 21,  41},
                           [4] = { 29,  49},
                           [5] = { 37,  57},
                      },
                ['Bane of monsters'] = { -- extra damage to dirt/sand/rock/whatever monsters
                           [0] = 5,
                           [1] = {  5,  25},
                           [2] = { 13,  33},
                           [3] = { 21,  41},
                           [4] = { 29,  49},
                           [5] = { 37,  57},
                      },
                ['The Push'] = {
                           [0] = 5, -- knockback
                           [1] = { 10,  60},
                           [2] = { 30,  80},
                      },
                ['Gut'] = {
                           [0] = 2, -- looting
                           [1] = { 15,  65},
                           [2] = { 24,  74},
                           [3] = { 33,  83},
                      },
                ['Arson'] = {
                           [0] = 2, -- set on fire
                           [1] = { 20,  50},
                           [2] = { 30,  80},
                           [3] = { 40,  90},
                      },
                ['Everlast'] = {
                           [0] = 3, -- unbreakable+infinity
                           [1] = {  5,  55},
                           [2] = { 13,  63},
                           [3] = { 21,  71},
                           [4] = { 29,  79},
                      },
                ['Speed up'] = {
                           [0] = 10, -- efficiency
                           [1] = {  5,  25},
                           [2] = { 13,  33},
                           [3] = { 21,  41},
                           [4] = { 29,  49},
                           [5] = { 37,  57},
                      },
                ['Tenderness'] = { -- lvl*20% is a prob of dig the node itself
                           [0] = 1, -- silk touch
                           [1] = {  5,  25},
                           [2] = { 13,  33},
                           [3] = { 21,  41},
                           [4] = { 29,  49},
                           [5] = { 37,  57},
                      },
                ['Treasurer'] = {
                           [0] = 2, -- luck
                           [1] = { 15,  65},
                           [2] = { 24,  74},
                           [3] = { 33,  83},
                           [4] = { 41,  92},
                      },

--[[
Casualty ostrota (power, sharpness)
Holy anger nebesnaya kara
Bane of monsters bich monstrov
Push otbrasyvanie (punch)
Gut maroderstvo (looting)
Quickness effektivnost
Tenderness shelkovoe kosanie
Infinity nerazrushimoist
Arson podjeg (flame, fire aspect)
Aiming
Treasurer (luck of the sea, luck) ]]--
            }

-- Creates weighted enchantments list with only the names of those
local function mte_list()
    local list = {}
    for en,chant in ipairs(mte) do
    for i=1, chant[0] do table.insert(list,en) end
    end
    return list
end

-- Func to select enchantements
local function select_enchantment(item, level, points)
   -- finallist is empty = no boons
    local finallist = {}
    
   -- if there's no points, there will be no enchantement
    if not points then return finallist end
    
   -- get the names of all possible chants 
    local list2 = {}
    for en,chant in pairs(mte) do
        for i,levels in ipairs(chant) do
            if points >= levels[1] and points <=levels[2] then
               for j=1, chant[0] do table.insert(list2,en .. ' ' .. i) end
            end
        end
    end
    
   -- the number of chants
    local eeeee = 1
    
   -- get random chant from the full list         
    local ch = random_elem(list2) 
   -- and insert it in the final list of chants 
    table.insert(finallist, ch)
   -- calculate the chances of continuation
    local chance = math.random() <= ((points+1)/50)
   -- if we're lucky, then...
    while chance==true do
       eeeee = eeeee +1
       local y = finallist[#finallist]
       if not y then return finallist end
       local nm = y:sub(1,-3)
       for e=#list2, 1, -1 do
           if list2[e]:find(nm) then
              table.remove(list2,e)
           end
       end
       points = points/2
      -- get random chant from the full list         
       ch = random_elem(list2) 
      -- and insert it in the final list of chants 
       table.insert(finallist, ch)
      -- calculate the chances of continuation
       chance = math.random() <= ((points+1)/50)       
      -- if we're lucky, then repeat
    end  
    
    return finallist
end

local allchants={}
local ee=1
for i,chant in pairs(mte) do
        allchants[ee] = {}
    for j=1,#chant do
        table.insert(allchants[ee],i..' '..j)
       -- table.insert(pchants,i..' '..j)
        pchants[i..' '..j] = {}
    end
    ee = ee+1
end
ee = nil

 --print(minetest.serialize(pchants))

-- The below one is used to create a list of items which can be enchanted.
-- This means, that anything not registered up to this point won't get into
-- the list. I have some back thoughts about this
local chanted_items = {}
for j,def in pairs(minetest.registered_items) do
    if def and def.tool_capabilities and def.tool_capabilities["enchantability"] and def.tool_capabilities["enchantability"]>0 then
       --print(def.name..' can be enchanted!')
       table.insert(chanted_items,def)
    end
end
-- The list of enchantable-tools is not so long. Check for yourself.
-- print(minetest.serialize(chanted_items))


-- This one below is the "thing" to create table with different combinations
local hhh = {
             {'Speed up 1'},
             {'Speed up 2'},
             {'Speed up 3'},
             {'Speed up 4'},
             {'Speed up 5'},
             {'Casualty 1'},
             {'Casualty 2'},
             {'Casualty 3'},
             {'Casualty 4'},
             {'Casualty 5'},
             {'Speed up 1', 'Casualty 1'},
             {'Speed up 2', 'Casualty 1'},
             {'Speed up 3', 'Casualty 1'},
             {'Speed up 4', 'Casualty 1'},
             {'Speed up 5', 'Casualty 1'},
             {'Speed up 1', 'Casualty 2'},
             {'Speed up 2', 'Casualty 2'},
             {'Speed up 3', 'Casualty 2'},
             {'Speed up 4', 'Casualty 2'},
             {'Speed up 5', 'Casualty 2'},
             {'Speed up 1', 'Casualty 3'},
             {'Speed up 2', 'Casualty 3'},
             {'Speed up 3', 'Casualty 3'},
             {'Speed up 4', 'Casualty 3'},
             {'Speed up 5', 'Casualty 3'},
             {'Speed up 1', 'Casualty 4'},
             {'Speed up 2', 'Casualty 4'},
             {'Speed up 3', 'Casualty 4'},
             {'Speed up 4', 'Casualty 4'},
             {'Speed up 5', 'Casualty 4'},
             {'Speed up 1', 'Casualty 5'},
             {'Speed up 2', 'Casualty 5'},
             {'Speed up 3', 'Casualty 5'},
             {'Speed up 4', 'Casualty 5'},
             {'Speed up 5', 'Casualty 5'},
            }

-- This fits me perfectly (taken from http://lua-users.org/wiki/CopyTable)
function deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[deepcopy(orig_key)] = deepcopy(orig_value)
        end
        setmetatable(copy, deepcopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

-- The below one tries to register enchanted tools.
-- Sadly, there's no way to show "workarounded" chants.
-- Check my 4itemnames mod to have a way to distinguish differently enchanted
-- things here: https://github.com/4aiman/4itemnames (meta)
--
-- Needs a description feature, like +++++. ToDo. #chants=#(+).
--
for j,def in ipairs(chanted_items) do
    -- I don't want to enchant an already buffed tool
    if not def.name:find('specialties') then
     --  print('[Mod] Enchantments - Registering chants for '..def.name)

       for i,ii in ipairs(hhh) do
           local ddd = deepcopy(def)
           ddd.groups = {not_in_creative_inventory=1,not_in_craft_guide=1}
           local dsc = string.sub(ddd.description,1)
           local dnm = string.sub(ddd.name,1)
           local speedup, casualty, slvl, clvl
           for k,kk in ipairs(ii) do
               speedup, casualty, slvl, clvl = false, false, false, false
               if kk:find('Speed up') then speedup = true slvl = kk:sub(-1) end
               if kk:find('Casualty') then casualty = true clvl = kk:sub(-1) end

               if speedup then
                  for m,mm in pairs(ddd.tool_capabilities.groupcaps) do
                      for n,nn in pairs(mm.times) do
                          -- every lvl speeds up digging by 25% of previous lvl
                          for ll=1, slvl do
                              nn=nn*0.75
                          end
                          ddd.tool_capabilities.groupcaps[m].times[n]=nn
                      end
                  end
                  ddd.name=dnm .. 's' .. slvl
               end

               if casualty then
                  if ddd.tool_capabilities.damage_groups then
                  for h,hh in pairs(ddd.tool_capabilities.damage_groups) do
                      hh = hh + tonumber(clvl)
                  end
                  ddd.name=ddd.name .. 'c' .. clvl
                --  print(ddd.name)
                  end
               end

               if casualty or speedup then
                  ddd.tool_capabilities["enchantability"] = -1
                  minetest.register_tool('enchantment:'..string.split(ddd.name,':')[2],ddd)
               end
            end

       end
       local ddd = deepcopy(def)
       ddd.groups = {not_in_creative_inventory=1,not_in_craft_guide=1}
       ddd.tool_capabilities["enchantability"] = -1
       minetest.register_tool('enchantment:'..string.split(ddd.name,':')[2],ddd)
      -- print('not in CI:   enchantment:'..string.split(ddd.name,':')[2])
    end
end

-- Func that returns the name and description of a new, enchanted tool
-- it NEITHER register NOR enchant anything! The table swaps items itself.
local function enchant_item(item,enchlist)
     if not item then return 'default:cobble' end
     local def = deepcopy(minetest.registered_items[item])
     if not def then return item end -- return the same item, if not defined...

     def.name = 'enchantment:'..string.split(def.name,':')[2]
     --def.name = name
     for i,nm in ipairs(enchlist) do
         --print(i..'\'th chant is '..nm)
         if nm:find('Speed up') then
            lv = tonumber(nm:sub(-1))
            def.name = def.name..'s'.. lv
         end
         if nm:find('Casualty') then
            lv = tonumber(nm:sub(-1))
            def.name = def.name..'c'.. lv
         end
     end
      --  if name == def.name then def.name = name .. 'e0z' end
      --  print('Chanted name: ' .. def.name)

     local meta = table.concat(enchlist, ';')
     return def.name,meta --ddd.name, ddd.description
end

local function grab_payment(sender,lvl)--xp,inv)  -- sender = objectref
   local inv = sender:get_inventory()
   if ghosts then
      local xps = lvl*glm
      local size = inv:get_size('main')
      --print('ghosts on, xp=' .. xps .. ';\ninv_size=' .. size )

      for i=1,size do
           --  print(i)
          local stack = inv:get_stack('main',i)
          local item = stack:get_name()
          if item == 'ghosts:ectoplasm' then
              local count = stack:get_count()
             --  print('ecto '.. count .. ' of ' .. lvl)
              xps=xps-count
             -- print('new xp '..xps)
              if xps>0 then
             --    print('still need payment')
                 stack:set_count(0)
                 inv:set_stack('main',i,stack)
              else -- if we've took too much then return the leftovers
              --   print('Overrun! xp=' .. xps .. '. Inverting!')
                 stack:set_count(-1*xps)
                 inv:set_stack('main',i,stack)
                 break
              end
          end
      end
      lvl = math.floor(xps/glm)
   end -- I've checked for specialties beforehand, so if no ghosts, then specs.
       -- ToDo
   local xpd = lvl*lm
   if xpd>0 then
--       print('still need payment sp')
 --      print(lvl ..' '..lm .. ' ' .. xpd)
       local points = get_sp_count(sender)
  --     print(points)
       points = points - xpd
       local pll = sender:get_player_name()
       for skill,num in pairs(specialties.players[pll].skills) do
           local numm = math.floor(points/5)
           specialties.changeXP(pll, skill, numm-num)
--           print(num)
       end
   end
end


-- Enchantment table
minetest.register_node("enchantment:table", {
    description = "Enchantment table",
    tiles = {"enchantment_table_top.png","default_obsidian.png","enchantment_table_side.png"},
    is_ground_content = true,
    groups = {cracky=default.dig.stone, stone=1},
    drop = 'enchantment:table',
    sounds = default.node_sound_stone_defaults(),
    drawtype = 'nodebox',
    paramtype = "light",
    selection_box = {
        type = "fixed",
        fixed = {-0.5, -0.5, -0.5, 0.5, 0.0, 0.5},
    },
    node_box = {
        type = "fixed",
        fixed = {-0.5, -0.5, -0.5, 0.5, 0.0, 0.5},
    },
    collisionbox = {-0.5,-0.5,-0.5, 0.5,0.2,0.5},
    on_construct = function(pos)
        local meta=minetest.get_meta(pos)
        local inv = meta:get_inventory()
        inv:set_size("itm", 1*1)
        meta:set_string("formspec", empty_formspec())
        --minetest.get_node_timer(pos):start(0)
    end,

    on_receive_fields = function(pos, formname, fields, sender)
       if sender and sender:is_player() then
          default.sort_inv(sender,formname,fields)
       end
       local meta=minetest.get_meta(pos)
       local inv = meta:get_inventory()
       local stack = inv:get_stack('itm', 1)
       local item = stack:get_name()
       if not item then return end --<------------------------------------+
       if fields.refresh then  --                                         |
           if not item then return end -- somehow this was nil after this ^ O_o
           if item:find('specialties:') then return end
           if not minetest.registered_items[item].tool_capabilities
           then
              meta:set_string("formspec", empty_formspec())
              return
           end
           local level = get_player_level(sender)
           local points = minetest.registered_items[item].tool_capabilities["enchantability"]

           if points and points>=0 then
              meta:set_string("formspec", make_ench_list(sender,pos,item))
           end
       elseif fields.ench1 or fields.ench2 or fields.ench3 then
          -- if one of the enchantment buttons was pressed, then...

          local lvl
          if     fields.ench1 then lvl = meta:get_string('lvl1')
          elseif fields.ench2 then lvl = meta:get_string('lvl2')
          elseif fields.ench3 then lvl = meta:get_string('lvl3')
          end

          local level = get_player_level(sender)
          if level<tonumber(lvl) then return end
          local points = get_enchantment_points(item,lvl)
          local list = select_enchantment(item, level, points)
          -- Now I get the name and the description for a new item
          local nm,metaench = enchant_item(item,list)
          local wear = stack:get_wear()
          -- replace supplied item
   --       print(nm)
          stack:replace(nm)
          -- restore wear dealt to it beforehand
          stack:set_wear(wear)
          -- add chants to meta to make those accessible on_event
          stack:set_metadata(metaench)
          -- swap items (finally!)
          inv:set_stack("itm", 1, stack)
          -- collect enchantment payment
          grab_payment(sender,lvl)
          meta:set_string("formspec", empty_formspec())
       end
    end,

    allow_metadata_inventory_put = function(pos, listname, index, stack, player)
       local meta=minetest.get_meta(pos)
       local inv = meta:get_inventory()
       local item = inv:get_stack('itm', 1):get_name()
       meta:set_string("formspec", make_ench_list(sender,pos,item))
       -- we don't want to enchant some random number of anything. Ok, I don't.
       return 1
    end,

    on_metadata_inventory_put = function(pos, listname, index, stack, player)
       local meta=minetest.get_meta(pos)
       local inv = meta:get_inventory()
       local item = inv:get_stack('itm', 1):get_name()
       meta:set_string("formspec", make_ench_list(sender,pos,item))
    end,

    after_place_node  = function(pos, placer, itemstack, pointed_thing) 
       for i=-2,2 do
           for j=-2,2 do
               for k=-2,2 do
                   local pp = {x=i+pos.x, y=j+pos.y, z=k+pos.z}
                   local nn = minetest.get_node(pp).name
                   if nn=='default:bookshelf'                    
                   and (i%2==0 or j%2==0 or k%2==0) then
                      minetest.get_node_timer(pp):start(1)
                   end
               end
            end
       end
       minetest.get_node_timer(pos):start(5)
    end,

    after_dig_node = function(pos, oldnode, oldmetadata, digger)
       for i=-2,2 do
           for j=-2,2 do
               for k=-2,2 do
                   local pp = {x=i+pos.x, y=j+pos.y, z=k+pos.z}
                   local nn = minetest.get_node(pp).name
                   if nn=='default:bookshelf' 
                   and not minetest.find_node_near(pp, 2, 'enchantment:table')
                   and (i%2==0 or j%2==0 or k%2==0) then
                      minetest.get_node_timer(pp):stop()
                   end
               end
            end
       end
    end,
    
    on_timer = function(pos, elapsed)
       for i=-2,2 do
           for j=-2,2 do
               for k=-2,2 do
                   local pp = {x=i+pos.x, y=j+pos.y, z=k+pos.z}
                   local nn = minetest.get_node(pp).name
                   if nn=='default:bookshelf'                    
                   and (i%2==0 or j%2==0 or k%2==0) then
                       local timer = minetest.get_node_timer(pp)
                       if not timer:is_started()
                       then timer:start(1)
                       end
                   end
               end
            end
       end       
       return true
    end,
        
})
-- Enchantment table's craft
if ghosts then
    -- Enchantment table's craft: ectoplasm needed if used with ghosts :)
    minetest.register_craft({
        output = 'enchantment:table',
        recipe = {
            {'ghosts:ectoplasm',  'default:book',     'ghosts:ectoplasm'},
            {'default:diamond',   'default:obsidian', 'default:diamond'},
            {'default:obsidian',  'default:obsidian', 'default:obsidian'},
        },
    })

    -- Redefine table's formspec if "ghosts" is used
    local def=minetest.registered_nodes['enchantment:table']


else
    minetest.register_craft({
        output = 'enchantment:table',
        recipe = {
            {'',                  'default:book',     ''},
            {'default:diamond',   'default:obsidian', 'default:diamond'},
            {'default:obsidian',  'default:obsidian', 'default:obsidian'},
        },
    })
end

-- Bookshelf redefinition
minetest.register_node(":default:bookshelf", {
    description = "Bookshelf",
    tiles = {"default_wood.png", "default_wood.png", "default_bookshelf.png"},

    groups = {choppy=default.dig.bookshelf or 1,flammable=3},
    sounds = default.node_sound_wood_defaults(),

    on_timer = function(pos,elapsed)
       local meta=minetest.get_meta(pos)
       local spid = meta:get_int("spawner")
      if spid~=0 then minetest.delete_particlespawner(spid) end
           local en = minetest.find_node_near(pos,2, "enchantment:table") and (not minetest.find_node_near(pos,1, "enchantment:table"))
           if en then
               local dir = vector.direction(pos, minetest.find_node_near(pos,2, "enchantment:table"))
               spid = minetest.add_particlespawner(
                                                            5,
                                                            2,
                                                            {x=pos.x-1.3, y=pos.y-1.3, z=pos.z-1.3},
                                                            {x=pos.x+1.3, y=pos.y+1.3, z=pos.z+1.3},
                                                            {x=-0.1, y=-0.1, z=-0.1},
                                                            {x= 0.1, y= 0.1, z= 0.1},
                                                            {x=-0.1, y=-0.1, z=-0.1},
                                                            dir,
                                                            1,
                                                            1,
                                                            0.5,
                                                            1,
                                                            false,
                                                            random_elem(glyphs)
                                                        )
                meta:set_int("spawner",spid)
           end
       return true
    end,

    after_dig_node = function(pos, oldnode, oldmetadata, digger)
       --local meta=minetest.get_meta(pos)
       --print(minetest.serialize(oldmetadata))
       local spid = oldmetadata.fields["spawner"]
       if spid then minetest.delete_particlespawner(spid) end
       return true
    end,
       --removed after_place & timer:start() to save CPU time     

})

minetest.register_chatcommand("gbxp", {
    func = function(name, param)
        local player = minetest.get_player_by_name(name)
        minetest.chat_send_player(name,'You have ' .. get_gb_count(player) .. ' of "ectoplasm".')
        return get_gb_count(player)
    end
})

minetest.register_chatcommand("spxp", {
    func = function(name, param)
        local player = minetest.get_player_by_name(name)
        minetest.chat_send_player(name,'Your specialties total XP is ' .. get_sxp(name))
        return
    end
})

minetest.register_chatcommand("enchant", {
    func = function(name, param)
        local player = minetest.get_player_by_name(name)
        local wstack = player:get_wielded_item()
        wstack:set_metadata(param)
        player:set_wielded_item(wstack)
        wielded_chant[name] = nil
--        minetest.chat_send_player(name,'Your specialties total XP is ' .. get_sxp(name))
        return
    end
})

minetest.register_on_joinplayer(function(player)
--hud with boons
   -- if not pchants then pchants = {} end
    pll = player:get_player_name()
    enplhuds[pll] = {}
        for i,chant in pairs(pchants) do
           pchants[i][pll] = false
        end -- to turn on/off effects
end)


-- Here's the performance killer...
-- Actually, my fps has dropped only by 1 on a netbook ;)
--
-- Anyway, this thing keeps track of applied chants. So every moment ingame we
-- are able to check pchants[pll] and act accordinggly

local last_gravity = {}

minetest.register_globalstep(function(dtime)
    local players = minetest.get_connected_players()
    for j,player in ipairs(players) do
        local pll = player:get_player_name()
        local wstack = player:get_wielded_item()
        local itemname = wstack:get_name()
        -- We don't want to continue if it's not an armor piece or a tool

        local meta = wstack:get_metadata()
        local boons = string.split(meta,';')


        if wielded_chant[pll] ~= itemname then
            for i,chant in pairs(pchants) do
                pchants[i][pll] = false
            end -- to turn on/off effects
            -- set this to nill when need to update chants!
        end

        if last_gravity[pll]
        and not pchants["Antigravity 1"][pll]
        and not pchants["Antigravity 2"][pll]
        and not pchants["Antigravity 3"][pll]
        and not pchants["Antigravity 4"][pll]
        and not pchants["Antigravity 5"][pll]
        then
            local ph = default.player_physics[pll]
            default.ph_override(player, {jump = ph.jump - last_gravity[pll]})
            last_gravity[pll] = nil
        end

        local real_leechers = 0
        for j,boon in ipairs(boons) do
            -- update boons only if there was a change!
            if pchants[boon] and not pchants[boon][pll] then
               if boon:find('Antigravity') then
                  if not last_gravity[pll] then
                    local lv = string.match(boon,"%d+")
                    local ph = default.player_physics[pll]
                    default.ph_override(player, {jump = ph.jump + 0.25*tonumber(lv)})
                    last_gravity[pll] = 0.25*tonumber(lv)
                  end
               elseif boon:find('Aqualung') then
                  local air = player:get_breath()
                  if air <10 then
                     local lv = string.match(boon,"%d+")
                     local do_breath = ((lv/10) > math.random())
                     if do_breath then player:set_breath(air+1) end
                  end

               elseif boon:find('Fire affinity') then
                  local pos = player:getpos()
                  if minetest.find_node_near(pos, 2, 'default:lava_source')
                  or minetest.find_node_near(pos, 2, 'default:lava_flowing')
                  or minetest.find_node_near(pos, 2, 'group:fire')
                  or minetest.find_node_near(pos, 2, 'group:hot')
                  then
                     node = true
                  else
                     node = false
                  end

                  local hp = player:get_hp()
                  if hp <20 then
                     local lv = string.match(boon,"%d+")
                     local do_heal = ((lv/20) > math.random())
                     if do_heal then player:set_hp(hp+1) end
                  end
               end
               -- only after enabling the effect we can store this fact
                  pchants[boon][pll] = true
            end

               -- leeching on statuses!
               local boontp = string.sub(boon,1,-3)
               local boonlv = tonumber(string.sub(boon,-1))
               if boonlv>2 then
                  local pos = player:getpos()
                  local controls = player:get_player_control()
                  -- if player holds down right mouse button and aux1 then distribute the effect
                  if pos and controls.RMB and controls.aux1 then
                     local leechers = minetest.get_objects_inside_radius(pos, boonlv+2)
                     -- track seeding time!
                     if not leech_timers[pll]
                     then leech_timers[pll] = dtime
                     else leech_timers[pll] = leech_timers[pll] + dtime
                     end
                     -- update leechers count once per second
                     if leech_timers[pll]>1 then
                        leech_timers[pll] = 0
                        for num,leecher in pairs(leechers) do
                            if leecher:is_player() then
                               local lname = leecher:get_player_name()
                               if lname ~= pll then
                                  real_leechers = real_leechers +1
                                  -- grant leecher the very same effect but 2 levels lower
                                  pchants[boontp..' '..tostring(boonlv-2)][lname] = true
                               end
                            end
                           -- add wear
                        end
                        minetest.chat_send_all(real_leechers)
                        -- regardless of material wear the tool
                        wstack:add_wear(400*real_leechers)
                        player:set_wielded_item(wstack)--player:inv:set_stack("itm", 1, stack)
                     end
                  end
               end
        end

-- remove boons
        for j,boon in pairs(pchants) do
            local boontp = string.sub(j,1,-3)
            local boonlv = tonumber(string.sub(j,-1))
            if (enplhuds[pll][boontp] and not pchants[j][pll])then
            player:hud_remove(enplhuds[pll][boontp])
            enplhuds[pll][boontp]=nil
            end
        end

-- add them
        local numhud = 0
        for j,boon in ipairs(boons) do
            local boontp = string.sub(boon,1,-3)
            local boonlv = tonumber(string.sub(boon,-1))
            if pchants[boon] and pchants[boon][pll] and not enplhuds[pll][boontp] then
               numhud = numhud +1
               -- if not enplhuds[pll] then enplhuds[pll]={} end
               yy = numhud
               while yy>7 do yy = yy-7 end
               enplhuds[pll][boontp] = player:hud_add({
                                                       hud_elem_type = "image",
                                                       position = {x=0, y=0.20},
                                                       offset = {x=10+40*math.floor((numhud-1)/7), y=yy*40},
                                                       alignment = {x=1, y=1},
                                                       scale = {x=1, y=1},
                                                       text = "enchantment_".. string.gsub(boontp, ' ', '_') ..".png^enchantment_".. boonlv ..".png^",
                                                      })
           end
        end
        wielded_chant[pll] = itemname
    end
end)

minetest.register_on_dignode(function(pos, oldnode, digger)
-- for effects like treasurer or tenderness, infinity etc
     if not digger then return true end
     local pll = digger:get_player_name()
     local nowear = false
   --  Everlast enchantment - will "heal" your tool occasionaly
     if      pchants['Everlast 1'][pll] then nowear = 1
     elseif  pchants['Everlast 2'][pll] then nowear = 2
     elseif  pchants['Everlast 3'][pll] then nowear = 3
     elseif  pchants['Everlast 4'][pll] then nowear = 4
     end
     if nowear then
        --print('Nowear level = ' .. nowear)
        local itemstack = digger:get_wielded_item()
        local tool = itemstack:get_name()
        local wear = itemstack:get_wear()
        local nn = oldnode.name

        local group = 'dig'
        if     minetest.get_item_group(nn, 'cracky') then group = 'cracky'
        elseif minetest.get_item_group(nn, 'crumbly') then group = 'crumbly'
        elseif minetest.get_item_group(nn, 'choppy') then group = 'choppy'
        elseif minetest.get_item_group(nn, 'snappy') then mult = 'snappy'
        end
        -- not interested if there's no such a tool. Client's probably "hacked"
        if not minetest.registered_tools[tool] then return end
        -- also won't do anything if a tool wasn't supposed to dug a group
        if not minetest.registered_tools[tool].tool_capabilities.groupcaps[group] then return end
        -- with two above met, we can proceed and get uses count
        local uses = minetest.registered_tools[tool].tool_capabilities.groupcaps[group].uses
--        print(minetest.serialize(minetest.registered_tools[tool].tool_capabilities.groupcaps[group].uses))
        if wear>0 and uses then
--            nowear = 1/nowear+1.5
            if math.random() < ((nowear+1)/20) then

               itemstack:add_wear(-65535/(uses-1))
              -- print('additional wear = ' .. tostring(-65535/(uses-1)) .. ' --- '.. tostring((nowear+1)/10))
            end
        end
        digger:set_wielded_item(itemstack)
     end
end)

minetest.register_on_placenode(function(pos, newnode, placer, oldnode, itemstack, pointed_thing)
-- what for? idk...
end)

-- Test func to squash/macerate nodes on_dig
local get_guts = function(item)
   if item:find('dirt')      then return 'default:sand'   end
   if item:find('sandstone') then return 'default:sand'   end
   if item:find('cobble')    then return 'default:gravel' end
   if item:find('tree')      then return 'default:wood'   end
   if item:find('wood')      then return 'default:stick'  end
   return item
end

-- Func to drop items. Minetest.item_drop doesn't work :(
-- got from specialties
local function drop_items(pos, itemcount, itemname)
    for i=1,itemcount do
        local obj = minetest.add_item(pos, itemname)
        if obj ~= nil then
            obj:get_luaentity().collect = true
            local x = math.random(1, 5)
            if math.random(1,2) == 1 then
                x = -x
            end
            local z = math.random(1, 5)
            if math.random(1,2) == 1 then
                z = -z
            end
            obj:setvelocity({x=1/x, y=obj:getvelocity().y, z=1/z})

            -- FIXME this doesnt work for deactivated objects
            if minetest.setting_get("remove_items") and tonumber(minetest.setting_get("remove_items")) then
                minetest.after(tonumber(minetest.setting_get("remove_items")), function(obj)
                    obj:remove()
                end, obj)
            end
        end
    end
end


local ndig = minetest.node_dig

-- I couldn't override node drops anywhere else
function minetest.node_dig(pos, oldnode, digger)
  -- ndig(pos, oldnode, digger)

   if not digger then return pos, oldnode, digger end
   -- because of the previous register.globalstep we do NOT need to check
   -- what tool is being used - #pchants[CHANT_NAME][pll] is what's important
   local pll = digger:get_player_name()
   local tool = digger:get_wielded_item()
   local toolname = tool:get_name()
   local nodename = oldnode.name
   local call_original = true
   local drops = minetest.get_node_drops(nodename, toolname)
   --   minetest.chat_send_all(minetest.serialize(drops))

   if type(drops)=='table' then
      if #drops>1 then
         print('[Enchantment] ToDo: enchant multidrop')
         ndig(pos, oldnode, digger)
         return pos, oldnode, digger
      elseif #drops==1 then
         drops=drops[1]
      elseif #drops<=0 then
         ndig(pos, oldnode, digger)
         return pos, oldnode, digger
      end
   end


   local count = string.split(drops,' ')[2] or 1
   -- no infinite resources
   -- ToDo forbid tenderness with other chants
   local tenderness = false

   for chant,pl in pairs(pchants) do

       -- cycle through the chants and if there's pll name...
       if pchants[chant][pll] then

           -- assign some vars
           if chant:find('Tenderness') then
              local lvl = tonumber(string.sub(chant,-1))
              -- 20%, 40%, 60%, 80% or 100% of dropping what's digged
              if math.random()<(lvl/5) then
                 tenderness=true
                 call_original = false
                 drops = nodename
              end

                 -- no infinite resources for ya!
           elseif not tenderness and chant:find('Treasurer')  then
              local lvl = tonumber(string.sub(chant,-1))
              --print(lvl)
              -- 20%, 40%, 60% or 80% of multiplying drop (lvl affected)
              if math.random()<(lvl/5) then
                  call_original = false
                  count = math.random(1,count * lvl+1)
              end

           -- allow to squash tenderly picked nodes
           elseif --[[not tenderness and]] chant:find('Gut') then --squashes
              call_original = false
              local lvl = tonumber(string.sub(chant,-1))
              if math.random()<(lvl/3) then
                    call_original=false
                    drops = get_guts(drops)
              end

            -- allow to cook tenderly picked nodes
           elseif --[[not tenderness and]] chant:find('Arson') then
              local lvl = tonumber(string.sub(chant,-1))

              if math.random()<(lvl/3) then
                 call_original = false
                 local input  = {method='cooking', items = {drops}}
                 local output = minetest.get_craft_result(input)
                 if not output.item:is_empty() then
                    drops = output.item:get_name()
                 end
              end
           end
       end
   end

   -- if not enchanted then dig normally
   if call_original then
        ndig(pos,oldnode,digger)
   else
        minetest.remove_node(pos,true)
        drop_items(pos,count,drops)

    if (toolname:find("shovel") ~= nil) or (toolname:find("spade") ~= nil) then
      specialties.changeXP(pll, "digger", 1)
    end
    if oldnode.name:find("farming") ~= nil then
      specialties.changeXP(pll, "farmer", 5)
    end
    if toolname:find("pick") ~= nil then
      specialties.changeXP(pll, "miner", 1)
    end
    if toolname:find("axe") ~= nil then
      specialties.changeXP(pll, "lumberjack", 1)
    end
   end

   return pos, oldnode, digger
end

print('[OK] Enchantment (beta) loaded')

--[[

local function select_enchantment(item, level, points)
--print(level)
--print(points)
    local finallist = {}
    if not points then return finallist end
    local list2 = {}
    for en,chant in pairs(mte) do
        for i,levels in ipairs(chant) do
        -- i contains pos in the table
        -- levels contains a table of min and max level
            if points >= levels[1] and points <=levels[2] then
               for j=1, chant[0] do table.insert(list2,en .. ' ' .. i) end
            end
        end
    end
    local eeeee = 1
    ::new_spell::                 -- I LOVE labels!!!
    local ch = random_elem(list2) -- delete last 2 chars
    table.insert(finallist, ch)
    local chance = math.random() <= ((points+1)/50)

    if chance then
       eeeee = eeeee +1
       local y = finallist[#finallist]
       if not y then return finallist end
       local nm = y:sub(1,-3)
       for e=#list2, 1, -1 do
           if list2[e]:find(nm) then
              table.remove(list2,e)
           end
       end
       points = points/2
       goto new_spell
    else
        return finallist
    end
    return finallist
end
]]--

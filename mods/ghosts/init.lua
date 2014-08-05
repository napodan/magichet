
-----------------------------
--- ghosts mod by 4aiman ----
---        BETA!!!       ----
-----------------------------
------ license: GPLv3 -------
-----------------------------

-- After MT devs refused to support ghosts idea (not mine) I made this mod.
-- It adds some afterlife features like ghostly blocks which are visible only
-- for those who's dead. You wanna live - you gonna craft a reincarnator,
-- create a structure of valuable materials (steel, gold, dimonds, mese)
-- charge it with collected ghostly blocks and reincarnate.
-- As a ghost you're almoust invisible and can jump very high.
--
-- Being beta, contains bugs and is incomplete.
--

--
-- ToDo: travel as soul at the night time - can see gb and collect them
--

ghosts_skin={}
g_blocks_count={}
bdeathpos = {}
isghost={}
local g_changed = false
local save_delta = 10
ghosts={}   -- dead?
ghosts2={}  -- hud activated?
ghosts3={}  -- ID of a hud
ghosts4={}  -- Warned about beeing ghost!
upd_physics = {}
local deaths_count = {}  -- count of deaths
ghosts_maxhp={}
ginvs={}
ghost_speed_modifier = 0.5
ghost_jump_modifier = 1.05
ghost_gravity_modifier = 0.1
ghost_sneak_value = false
ghost_sneak_glitch = true

local poses = {} -- keeps track of players' pos

local locale = os.setlocale(nil, 'collate')

-- load my stuff! :)
local input = io.open(minetest.get_worldpath().."/ghosts.lua", "r")
   if input then
      io.close(input)
      dofile(minetest.get_worldpath().."/ghosts.lua")
   end


local rus
-- future would be far more dangerous and mysterious... but for now :)
local announce_not_rus = 'You\'re still dead!\n'..
                         'As a ghost you can do something you previously can\'t.\n'..
                         'Flying is just an example.\n'..
                         'On the other hand now you must do some semi-difficult\n'..
                         'tasks to restore your previous state as it was.\n'..
                         'Actually, you can press the \'Reincarnation\' button,\n'..
                         'but are you ready to lose everything you have?\n'..
                         'If you are NOT concerned about it then bravely\n'..
                         'reincarnate. Otherwise you should undergo the ritual\n'..
                         'of rebirth.\n'..
                         'But how are you supposed to warn others about your death?'
local close_not_rus = '"Okay"'
local reinc_not_rus = 'Reincarnation'
local remin_not_rus = 'Do NOT remind me every time'
local welcome_not_rus = 'Welcome to the GHOSTS realm!'

local announce_rus = 'Вы всё ещё мертвы!\n\n'..
                     'В качестве призрака вы cможете делать кое-что,\n'..
                     'недоступное вам ранее. Например - летать.\n'..
                     'С другой стороны, вам придётся сильно потрудиться,\n' ..
                     'чтобы вернуться в прежнее состояние и реинкарнироваться.\n'..
                     'Конечно, вы можете нажать на кнопку \'Реинкарнация\',\n'..
                     'Но готовы ли потерять абсолютно всё, что имели?\n'..
                     'Если вас такие мелочи НЕ волнуют - смело\n'..
                     'реинкарнируйтесь. Те же, кто хочет сохранить нажитое\n' ..
                     'должны будут пройти ритуал возрождения.\n'..
                     'Но для этого надо как-то дать знать другим игрокам\n' ..
                     'о своём присутствии.'
local close_rus = '"Ясненько"'
local reinc_rus = 'Реинкарнация'
local remin_rus = 'НЕ напоминать мне каждый раз'
local welcome_rus = 'Приветствуем в ином мире!'

if (locale:find('Russian') ~= nil) or (locale:find('ru_RU') ~= nil) then rus=1 else rus = 0 end
rus = 0
function g_save_stuff()
    local output = io.open(minetest.get_worldpath().."/ghosts.lua", "w")
    if output then
       o  = minetest.serialize(isghost)
       i  = string.find(o, "return")
       o1 = string.sub(o, 1, i-1)
       o2 = string.sub(o, i-1, -1)
       output:write(o1 .. "\n")
       output:write("isghost = minetest.deserialize('" .. o2 .. "')\n")

       o  = minetest.serialize(ghosts)
       i  = string.find(o, "return")
       o1 = string.sub(o, 1, i-1)
       o2 = string.sub(o, i-1, -1)
       output:write(o1 .. "\n")
       output:write("ghosts = minetest.deserialize('" ..  o2 .. "')\n" )

       o  = minetest.serialize(ghosts4)
       i  = string.find(o, "return")
       o1 = string.sub(o, 1, i-1)
       o2 = string.sub(o, i, -1)
       output:write(o1 .. "\n")
       output:write("ghosts4 = minetest.deserialize('" .. o2 .. "')\n")

       o  = minetest.serialize(g_blocks_count)
       i  = string.find(o, "return")
       o1 = string.sub(o, 1, i-1)
       o2 = string.sub(o, i, -1)
       output:write(o1 .. "\n")
       output:write("g_blocks_count = minetest.deserialize('" .. o2 .. "')\n")

       o  = minetest.serialize(ginvs)
       i  = string.find(o, "return")
       o1 = string.sub(o, 1, i-1)
       o2 = string.sub(o, i, -1)
       output:write(o1 .. "\n")
       output:write("ginvs = minetest.deserialize('" .. o2 .. "')\n")

       o  = minetest.serialize(ghosts_skin)
       i  = string.find(o, "return")
       o1 = string.sub(o, 1, i-1)
       o2 = string.sub(o, i-1, -1)
       output:write(o1 .. "\n")
       output:write("ghosts_skin = minetest.deserialize('" .. o2 .. "')\n")

       o  = minetest.serialize(deaths_count)
       i  = string.find(o, "return")
       o1 = string.sub(o, 1, i-1)
       o2 = string.sub(o, i-1, -1)
       output:write(o1 .. "\n")
       output:write("deaths_count = minetest.deserialize('" .. o2 .. "')\n")

       o  = minetest.serialize(ghosts_maxhp)
       i  = string.find(o, "return")
       o1 = string.sub(o, 1, i-1)
       o2 = string.sub(o, i-1, -1)
       output:write(o1 .. "\n")
       output:write("ghosts_maxhp = minetest.deserialize('" .. o2 .. "')\n")

       io.close(output)
    end
end

function check_for_revival_struct(pos)
   local res = false
   local count = 0
   local nodes={stone=0,steel=0,gold=0,mese=0,diamond=0}
   for i=-2,2 do
       for j=-2,2 do
           local p={x = pos.x+i, y = pos.y-1, z = pos.z+j}
           local node = minetest.get_node(p)
           --minetest.debug(minetest.pos_to_string(p) .. ' : ' .. minetest.serialize(node))
           if node and node.name then
              local mat
              mat = string.find(node.name, "stone")
              if mat then nodes.stone=nodes.stone+1
              else
                  mat  = string.find(node.name, "steel")
                  if mat then nodes.steel=nodes.steel+1
                  else
                      mat  = string.find(node.name, "gold")
                      if mat then nodes.gold=nodes.gold+1
                      else
                          mat  = string.find(node.name, ":mese")
                          if mat and not string.find(node.name, "mesecon") then nodes.mese=nodes.mese+1
                          else
                              mat  = string.find(node.name, "diamond")
                              if mat then nodes.diamond=nodes.diamond+1  end
                          end
                      end
                  end
              end
           if (not string.find(node.name,"air")) and (not string.find(node.name,"ignore")) then
              count=count+1
           end
           end
       end
   end

   for i=0,1 do
   local p={x = pos.x-2, y = pos.y+i, z = pos.z-2}
   local node = minetest.get_node(p)
           if node and node.name then
              local mat
              mat = string.find(node.name, "stone")
              if mat then nodes.stone=nodes.stone+1
              else
                  mat  = string.find(node.name, "steel")
                  if mat then nodes.steel=nodes.steel+1
                  else
                      mat  = string.find(node.name, "gold")
                      if mat then nodes.gold=nodes.gold+1
                      else
                          mat  = string.find(node.name, ":mese")
                          if mat and not string.find(node.name, "mesecon") then nodes.mese=nodes.mese+1
                          else
                              mat  = string.find(node.name, "diamond")
                              if mat then nodes.diamond=nodes.diamond+1  end
                          end
                      end
                  end
              end
           if (not string.find(node.name,"air")) and (not string.find(node.name,"ignore")) then
              count=count+1
           end
           end

   local p={x = pos.x+2, y = pos.y+i, z = pos.z-2}
   local node = minetest.get_node(p)
           if node and node.name then
              local mat
              mat = string.find(node.name, "stone")
              if mat then nodes.stone=nodes.stone+1
              else
                  mat  = string.find(node.name, "steel")
                  if mat then nodes.steel=nodes.steel+1
                  else
                      mat  = string.find(node.name, "gold")
                      if mat then nodes.gold=nodes.gold+1
                      else
                          mat  = string.find(node.name, ":mese")
                          if mat and not string.find(node.name, "mesecon") then nodes.mese=nodes.mese+1
                          else
                              mat  = string.find(node.name, "diamond")
                              if mat then nodes.diamond=nodes.diamond+1  end
                          end
                      end
                  end
              end
           if (not string.find(node.name,"air")) and (not string.find(node.name,"ignore")) then
              count=count+1
           end
           end

   local p={x = pos.x-2, y = pos.y+i, z = pos.z+2}
   local node = minetest.get_node(p)
           if node and node.name then
              local mat
              mat = string.find(node.name, "stone")
              if mat then nodes.stone=nodes.stone+1
              else
                  mat  = string.find(node.name, "steel")
                  if mat then nodes.steel=nodes.steel+1
                  else
                      mat  = string.find(node.name, "gold")
                      if mat then nodes.gold=nodes.gold+1
                      else
                          mat  = string.find(node.name, ":mese")
                          if mat and not string.find(node.name, "mesecon") then nodes.mese=nodes.mese+1
                          else
                              mat  = string.find(node.name, "diamond")
                              if mat then nodes.diamond=nodes.diamond+1  end
                          end
                      end
                  end
              end
           if (not string.find(node.name,"air")) and (not string.find(node.name,"ignore")) then
              count=count+1
           end
           end

   local p={x = pos.x+2, y = pos.y+i, z = pos.z+2}
   local node = minetest.get_node(p)
           if node and node.name then
              local mat
              mat = string.find(node.name, "stone")
              if mat then nodes.stone=nodes.stone+1
              else
                  mat  = string.find(node.name, "steel")
                  if mat then nodes.steel=nodes.steel+1
                  else
                      mat  = string.find(node.name, "gold")
                      if mat then nodes.gold=nodes.gold+1
                      else
                          mat  = string.find(node.name, ":mese")
                          if mat and not string.find(node.name, "mesecon") then nodes.mese=nodes.mese+1
                          else
                              mat  = string.find(node.name, "diamond")
                              if mat then nodes.diamond=nodes.diamond+1  end
                          end
                      end
                  end
              end
           if (not string.find(node.name,"air")) and (not string.find(node.name,"ignore")) then
              count=count+1
           end
           end
   end

  --[[
   33*5 =
   15
  15
  ----
  165 which is 100%
  ]]--
   -- stone=1,steel=2,gold=3,mese=4,diamond=5
   if count == 33
   then res = true end

   local value = nodes.stone*1+nodes.steel*2+nodes.gold*3+nodes.mese*4+nodes.diamond*5
   local cmplt = math.ceil((value/165)*100)


   --nodes.stone+nodes.steel+nodes.gold+nodes.mese+nodes.diamond
  -- minetest.debug(minetest.serialize(nodes) ..'\ntotal: '.. count ..'\nvalue: '.. tostring(value)  ..' of 165\nwhich is '..tostring(cmplt) ..'%')
   return res, count, value, cmplt
end

function save_ginv(pll)
local ginv = minetest.get_inventory({type="detached", name="ghosts_".. pll})
       if not ginv then return end
       if not ginvs then return end
       if not ginvs[pll] then ginvs[pll]={} end
       for i,stack in ipairs(ginv:get_list("copy")) do
           ginvs[pll][i] = stack:to_string()
       end
      g_changed = true
end

function load_ginv(pll)
    if not ginvs then return end
    if not ginvs[pll] then return end
       local ginv = minetest.get_inventory({type="detached", name="ghosts_".. pll})
       if not ginv then return end
       for i,stack in ipairs(ginv:get_list("copy")) do
           ginv:set_stack("copy", i, ItemStack(ginvs[pll][i]))
       end
    --   g_changed = true
end


minetest.register_node("ghosts:reincarnator", {
    description = "Reincarnator",
    inventory_image = "default_furnace_front.png",
    wield_image = "default_furnace_front.png",
    tiles = {'default_furnace_top.png','default_furnace_bottom.png','default_furnace_side.png','default_furnace_side.png','default_furnace_front.png','default_furnace_front.png'},
    wield_scale = {x=1, y=1, z=1},
    groups = {cracky=default.dig.cobble},
   -- on_punch = function(pos, node, puncher)
   --     check_for_revival_struct(pos)
   -- end,
    on_construct = function(pos)
       local res, count, value, cmplt = check_for_revival_struct(pos)
       local meta = minetest.get_meta(pos)
       local inv = meta:get_inventory()
       inv:set_size("gb_place", 1*1)
       local txt = 'Structure is finished by '.. tostring(math.ceil((count/33)*100)) ..'%'
       local txt2= 'Efficienty: '..tostring(cmplt) ..'%'
       local txt3= 'Ghost blocks'
       local txt4= 'Reincarnate'
       local txt5= 'Charge'
       meta:set_string("txt",txt)
       meta:set_string("txt2",txt2)
       meta:set_string("txt3",txt3)
       meta:set_string("txt4",txt4)
       meta:set_string("txt4",txt5)
       local formspec = "size[9,8.2]" ..
            "bgcolor[#bbbbbb;false]"..
            "listcolors[#777777;#cccccc;#333333;#555555;#dddddd]"..

            "image_button[9.0,-0.3;0.80,1.7;b_bg2.png;just_bg;Z;true;false]"..
            "image_button[9.2,-0.2;0.5,0.5;b_bg.png;sort_horz;=;true;true]"..
            "image_button[9.2,0.3;0.5,0.5;b_bg.png;sort_vert;||;true;true]"..
            "image_button[9.2,0.8;0.5,0.5;b_bg.png;sort_norm;Z;true;true]"..
            "label[1.2,1;".. txt .."]"..
            "label[1.2,1.5;".. txt2 .."]"..
            "label[1.2,2;".. txt3 .."]"..
            "list[context;gb_place;6,1;1,1;]"..
            "label[7,1; +".. meta:get_string("stored") .."]"..
            "button[5,2;3,1;g_chk;"..txt5.."]"..
            "button_exit[5,3;3,1;g_rei;".. txt4 .."]"..
            "list[current_player;helm;0,0;1,1;]"..
            "list[current_player;torso;0,1;1,1;]"..
            "list[current_player;pants;0,2;1,1;]"..
            "list[current_player;boots;0,3;1,1;]"..

            "list[current_player;main;0,4.2;9,3;9]"..
            "list[current_player;main;0,7.4;9,1;]"

        meta:set_string("formspec", formspec)
        meta:set_string("stored","0")
        minetest.get_node_timer(pos):start(5)
    end,

    on_timer = function(pos,elapsed)
       local res, count, value, cmplt = check_for_revival_struct(pos)
       local meta = minetest.get_meta(pos)
       local inv = meta:get_inventory()
       inv:set_size("gb_place", 1*1)
       local txt = 'Structure is finished by '.. tostring(math.ceil((count/33)*100)) ..'%'
       local txt2= 'Efficienty: '..tostring(cmplt) ..'%'
       local txt3= 'Ghost blocks'
       local txt4= 'Reincarnate'
       local txt5= 'Charge'
       meta:set_string("txt",txt)
       meta:set_string("txt2",txt2)
       meta:set_string("txt3",txt3)
       meta:set_string("txt4",txt4)
       meta:set_string("txt4",txt5)
       local formspec = "size[9,8.2]" ..
            "bgcolor[#bbbbbb;false]"..
            "listcolors[#777777;#cccccc;#333333;#555555;#dddddd]"..

            "image_button[9.0,-0.3;0.80,1.7;b_bg2.png;just_bg;Z;true;false]"..
            "image_button[9.2,-0.2;0.5,0.5;b_bg.png;sort_horz;=;true;true]"..
            "image_button[9.2,0.3;0.5,0.5;b_bg.png;sort_vert;||;true;true]"..
            "image_button[9.2,0.8;0.5,0.5;b_bg.png;sort_norm;Z;true;true]"..
            "label[1.2,1;".. txt .."]"..
            "label[1.2,1.5;".. txt2 .."]"..
            "label[1.2,2;".. txt3 .."]"..
            "list[context;gb_place;6,1;1,1;]"..
            "label[7,1; +".. meta:get_string("stored") .."]"..
            "button[5,2;3,1;g_chk;"..txt5.."]"..
            "button_exit[5,3;3,1;g_rei;".. txt4 .."]"..
            "list[current_player;helm;0,0;1,1;]"..
            "list[current_player;torso;0,1;1,1;]"..
            "list[current_player;pants;0,2;1,1;]"..
            "list[current_player;boots;0,3;1,1;]"..

            "list[current_player;main;0,4.2;9,3;9]"..
            "list[current_player;main;0,7.4;9,1;]"



        meta:set_string("formspec", formspec)
       return true
    end,

    on_receive_fields = function(pos, formname, fields, sender)
    --  print(dump(fields))
        --print("Sign at "..minetest.pos_to_string(pos).." got "..dump(fields))
       local meta = minetest.get_meta(pos)
       if fields.g_chk then --charge it!
          local player=sender
          if player and sender:is_player() then
               local pll = player:get_player_name()
               local inv = meta:get_inventory()
               local place= inv:get_stack("gb_place", 1)
               local count = place:get_count()
               local cname=place:get_name()
               if cname == "ghosts:ghostly_block" then
                 local cnt = meta:get_string("stored")
                  if tonumber(cnt)>0 then
                  meta:set_string("stored",tostring(tonumber(cnt)+count))
                  else
                  meta:set_string("stored",tostring(count))
                  end
                  inv:set_stack("gb_place", 1, ItemStack(""))
              end
          end
        end
       if fields.g_rei then

          -- reincarnate!
          local player=sender
          if player and player:is_player() then

               local pll = player:get_player_name()
               if not isghost[pll] then
                  minetest.show_formspec(pll, pll..'_is_not_a_ghost', 'size[3,6]bgcolor[#bbbbbb;false]label[0.5,1;You\'re not a ghost!]"button_exit[4.5,2;2,1;g_rei;Proceed]')
                  return
               end
               local inv = meta:get_inventory()
               local place= inv:get_stack("gb_place", 1)
               local count = tonumber(meta:get_string("stored")) --place:get_count()
               local cname=place:get_name()
               if not g_blocks_count[pll] then g_blocks_count[pll]=0 end
               local gb = math.ceil(g_blocks_count[pll]/10)
               if count >= gb then
                  count = count-gb
                  meta:set_string("stored",tostring(count))
                  g_blocks_count[pll] = nil
                  minetest.debug(pll .. ' used reincarnator...')
                  ghosts[pll]=nil
                  isghost[pll]=nil
                  if upd_physics[pll] then
                  ph=default.player_physics[pll]
                  default.ph_override(player,{ speed = ph.speed / ghost_speed_modifier,
                                                jump = ph.jump / ghost_jump_modifier,
                                                gravity = ph.gravity / ghost_gravity_modifier,
                                             })
                  upd_physics[pll]=false
                --  print('ghosts on use reincarnator')
                  end
                  --skins back!!!
                  if skins then
                  skins.skins[pll]=ghosts_skin[pll]
                  skins.update_player_skin(player)
                  end

                    local inv2 = player:get_inventory()
                    local ginv = minetest.get_inventory({type="detached", name="ghosts_".. pll})
                    --minetest.debug("REINCARNATION!")
                    local res2, count2, value2, cmplt2 = check_for_revival_struct(pos)
                    local success_probability = math.ceil((count2/33))
                    local recover_percentage = tonumber(cmplt2/100)
                    local rnd = math.random()
                    local success =  (rnd <= success_probability)
                    if not success then return end
                    if inv2 and ginv then
                        for i,stack in ipairs(ginv:get_list("copy")) do
                            --inv2:add_item("main", stack)
                            local cnt2 = stack:get_count()
                            if cnt2*recover_percentage <1
                            then -- if item count <1
                               local wear = stack:get_wear()
                               stack:set_count(1)
                               stack:add_wear(wear*cnt2*recover_percentage)
                            else
                               stack:set_count(math.ceil(cnt2*recover_percentage))
                               --minetest.debug(wear)
                            end
                            inv2:set_stack("main", i, stack)
                            --minetest.debug("item #"..tostring(i).." is " .. stack:get_name() .. " x" .. stack:get_count() .. "!")
                            stack:clear()
                            ginv:set_stack("copy", i, stack)
                            --inv2:set_stack("main", i, stack)
                        end
                    end
                g_changed = true
               else
                   -- ask if a player wants to lose ANYTHING
                   -- g_blocks_count[pll]
               end
--
          end

        end
        -- quit fields
           if sender and sender:is_player() then
              default.sort_inv(sender,formname,fields,pos)
           end
    end,


})

local gbus = true

minetest.after(0, function()
 minetest.register_globalstep(function(dtime)
   local players  = minetest.get_connected_players()
   if #players == 0 then return end
   for i,player in ipairs(players) do
       local pll=player:get_player_name()

       -- heal a ghost anytime! (a ghost cannot be killed with /kill)
       if isghost[pll] then
       if ghosts_maxhp[pll] then
        ghosts_maxhp[pll]['time_before_diminish']=ghosts_maxhp[pll]['time_before_diminish']-dtime
        if ghosts_maxhp[pll]['time_before_diminish']<0 then
         ghosts_maxhp[pll]['time_before_diminish']=60+5*ghosts_maxhp[pll]['max_hp']
         if ghosts_maxhp[pll]['max_hp']>0 then
            ghosts_maxhp[pll]['max_hp']=ghosts_maxhp[pll]['max_hp']-1
         end
        end
       else
        ghosts_maxhp[pll]={['time_before_diminish']=1, ['max_hp']=20, ['enabled']=true}
       end
       if ghosts_maxhp[pll]['enabled'] then
          if ghosts_maxhp[pll]['max_hp']==0 then
             ghosts_maxhp[pll]={['time_before_diminish']=1, ['max_hp']=20, ['enabled']=false}
             player:set_hp(0)
          else
              player:set_hp(ghosts_maxhp[pll]['max_hp'])
          end
       end
       end

       -- ectoplasm generation:
       if isghost[pll] then
          local pos = player:getpos()
          local pos_changed
          if poses[pll] then
             if math.floor(poses[pll].x) ~= math.floor(pos.x)
             or math.floor(poses[pll].y) ~= math.floor(pos.y)
             or math.floor(poses[pll].z) ~= math.floor(pos.z)
             then
                 pos_changed = true
                 poses[pll] = {x=pos.x, y=pos.y, z=pos.z}
             end
          end
          if pos_changed then
              local bel = {x=pos.x, y=pos.y-1, z=pos.z}
              local bb = minetest.get_node(bel)
              -- no mid-air generation
                local meta = minetest.get_meta(bel)
                local ecto = meta:get_int("ecto")+1
                if ecto>20 and bb and bb.name~='air' then
                   minetest.set_node(pos,{name = "ghosts:ectoplasm"})
                elseif ecto<2100 then
                   -- restrict MAXecto to 2100. Maybe later there would be a use for it
                   meta:set_int("ecto",ecto)
                end

          end
       end


       if isghost[pll] and g_blocks_count[pll]~=nil and ghosts3[pll] and ghosts3[pll][1]~=nil then
          player:hud_remove(ghosts3[pll][1])
          ghosts3[pll][1] = player:hud_add({
                    hud_elem_type = "text",
                    position = {x=0.80, y=0.95},
                    offset = {x=-0, y=0},
                    alignment = {x=1, y=-1},
                    number = 0xFFFFFF ,
                    text = "GM: ".. tostring(math.ceil(g_blocks_count[pll]/10)),
                })
       end

       if (ghosts[pll]) and (not ghosts2[pll]) then
          local hud=player:hud_add({hud_elem_type = "image",
                       scale = {x=-100, y=-100},
                       position = {x=0, y=0},
                       name = "ghostly_vision",
                       text = "gv.png",
                       alignment = {x=1, y=1},
                       offset = {x=0, y=0},
                       })
           if (not ghosts3[pll]) then ghosts3[pll]={} end
           ghosts3[pll][0] = hud
           if g_blocks_count[pll]~=nil then
               local hud2 = player:hud_add({
                    hud_elem_type = "text",
                    position = {x=0.90, y=0.95},
                    offset = {x=-0, y=0},
                    alignment = {x=1, y=-1},
                    number = 0xFFFFFF ,
                    text = "GM: ".. tostring(math.ceil(g_blocks_count[pll]/10)),
                })
               ghosts3[pll][1]=hud2
           end
           ghosts2[pll]=1
        end
        if (not ghosts[pll]) and (ghosts2[pll]) and (ghosts3[pll]) then
           player:hud_remove(ghosts3[pll][0])
           player:hud_remove(ghosts3[pll][1])
           ghosts[pll]=nil
           ghosts2[pll]=nil
           ghosts3[pll][0]=nil
           ghosts3[pll][1]=nil
         end
    end
 end)
end)

minetest.register_on_dieplayer(function(player)
        if player then
           local pll=player:get_player_name()
           if not deaths_count[pll] then deaths_count[pll] = 0 end
           if isghost[pll] then
              deaths_count[pll] = deaths_count[pll] + 1
           end
           local pos = player:getpos()
           bdeathpos[pll]=pos
           ghosts[pll]=1
        end
    end)


minetest.register_on_respawnplayer(function(player)
        local pll=player:get_player_name()
        if (ghosts2[pll]) then
           if rus == 1 then       -- russian
              localized_announce = announce_rus
              localized_close = close_rus
              localized_reinc = reinc_rus
              localized_welcome = welcome_rus
              localized_remin = remin_rus
           else                      -- english
              localized_announce = announce_not_rus
              localized_close = close_not_rus
              localized_reinc = reinc_not_rus
              localized_welcome =welcome_not_rus
              localized_remin = remin_not_rus
           end
              local formspec = ''
              if (not ghosts4[pll]) then
              formspec = "size[9,9]"..
                    "bgcolor[#bbbbbb;false]"..
                    "listcolors[#777777;#cccccc;#333333;#555555;#dddddd]"..
                    "label[0.25,0.2;" .. localized_welcome .."]"..
                    "textarea[0.25,0.5;9,7.8;yng; ;"..localized_announce.."]"..
                    "checkbox[0.25,7.2;g_rem;" .. localized_remin .. ";false]"..
                    "button_exit[1.5,8.0;2.5,1;g_close;" .. localized_close .."]"..
                    "button_exit[5,8.0;2.5,1;g_reinc;" .. localized_reinc .."]"
              else
              formspec = "size[9,2]"..
                    "bgcolor[#bbbbbb;false]"..
                    "listcolors[#777777;#cccccc;#333333;#555555;#dddddd]"..
                    "label[0.25,0.2;" .. localized_welcome .."]"..
                    "button_exit[1.5,1.0;2.5,1;g_close;" .. localized_close .."]"..
                    "button_exit[5,1;2.5,1;g_reinc;" .. localized_reinc .."]"
              end
              -- if a player is NOT a ghost
              if pll and formspec and not isghost[pll] then
                 minetest.show_formspec(pll,"ghosts:unlocked",formspec)
              end
        else
        end
      return true
    end)


minetest.register_on_player_receive_fields(function(player, formname, fields)
        if not player then return end
        local pll=player:get_player_name()
        if fields.g_rem then
               ghosts4[pll]=1
               return
           end

        if fields.g_close or (fields.quit and formname == "ghosts:unlocked" and not fields.g_reinc) then
         -- not reincarnated
           -- ghosts are invulnerable to fall damage
           default.player_status[pll].fall = 1000
           ghosts_maxhp[pll]={['time_before_diminish']=80, ['max_hp']=20}
         -- you're allready a ghost, so nothing to do :)

              if not isghost[pll] then
               --------------------------------------
              if skins then
              ghosts_skin[pll] = skins.skins[pll]
            --  minetest.debug("The old skin was " .. minetest.serialize(skins.skins[pll]))
              skins.skins[pll]="player_13"
              skins.update_player_skin(player)
              end

              g_changed = true

               --------------keep inventory... but in ghosts list ------------------------
                  ghosts[pll]=1
                  isghost[pll]=1
                    -- if pll isn't a ghost then...
                    local inv = player:get_inventory()
                      local ginv = minetest.get_inventory({type="detached", name="ghosts_".. pll})
                      if ginv then
                      else
                         ginv = minetest.create_detached_inventory("ghosts_"..pll)
                         if ginv then
                         else
                         end
                      end

                      if inv and ginv then
                          for i,stack in ipairs(inv:get_list("main")) do
                              if not isghost[pll] then
                                 -- if it's your first life, then copy to ginv
                                 ginv:set_stack("copy", i, stack)
                              else
                                 -- else add to ginv beyound your 9*4 inv (up to 5x inventories)
                                 if i+9*4*deaths_count[pll] <=9*4*5 then
                                    ginv:set_stack("copy", i+9*4*deaths_count[pll], stack)
                                 end
                              end
                              stack:clear()
                              inv:set_stack("main", i, stack)
                          end
                      end
                ------------------------------------
                if not upd_physics[pll] then
                  ph=default.player_physics[pll]
                  default.ph_override(player,{ speed = ph.speed * ghost_speed_modifier,
                                                jump = ph.jump * ghost_jump_modifier,
                                                gravity = ph.gravity * ghost_gravity_modifier,
                                             })
                  upd_physics[pll]=true
               --   print('ghosts on become a ghost')
                end
               g_changed = true
               else
                   if not g_blocks_count[pll] or g_blocks_count[pll]<10 then g_blocks_count[pll]=10
                   else
                       g_blocks_count[pll] = g_blocks_count[pll]*2
                   end
               end
               return
        end


        if fields.g_reinc then
           beds.remove_from_bed(player)
           if beds.beds_player_spawns[pll] then
              player:setpos(beds.beds_player_spawns[pll])
           end
          -- print('reincarnation at '..minetest.pos_to_string(player:getpos()) .. '; bed at '.. minetest.pos_to_string(beds.beds_player_spawns[pll]) .. '; deathpos is '.. minetest.pos_to_string(bdeathpos[pll]))

         -- clear up your stuff and onto your reincarnation, Muah-ha-ha-haaaa he-hee hoooo...
                  local pos = bdeathpos[pll]
                  if not bdeathpos[pll] then pos = player:getpos() end
                  player:setpos(findapos())
                  -- emptying one's pockets :)
------------------------------------------------------------
                    local pos = bdeathpos[pll]
                    local objs = minetest.get_objects_inside_radius(pos, 50)
                    local pllc = false
                    for i,obj in ipairs(objs) do
                        if obj:is_player() then
                        pllc = true
                        break
                        end
                    end

                  if pllc and pos then
                    local inv = player:get_inventory()
                    for i,stack in ipairs(inv:get_list("main")) do
                        local x = math.random(0, 9)/3
                        local z = math.random(0, 9)/3
                        pos.x = pos.x + x
                        pos.z = pos.z + z
                        minetest.add_item(pos, stack)
                        stack:clear()
                        inv:set_stack("main", i, stack)
                        pos.x = pos.x - x
                        pos.z = pos.z - z
                    end
                    -- decrease inventory by 1*2^deaths_count
                    inv:set_size(inv:get_size('main') - 1*math.pow(2,deaths_count[pll]))
                  end
------------------------------------------------------------
               g_blocks_count[pll]=nil
               ghosts[pll]=nil
               isghost[pll]=nil
                if upd_physics[pll] then
                  ph=default.player_physics[pll]
                  default.ph_override(player,{ speed = ph.speed / ghost_speed_modifier,
                                                jump = ph.jump / ghost_jump_modifier,
                                                gravity = ph.gravity / ghost_gravity_modifier,
                                             })
                  upd_physics[pll]=false
                 -- print('ghosts on reincarnation set ph')
                end
              if skins then
                 if ghosts_skin[pll]
                 then skins.skins[pll]=ghosts_skin[pll]
                 else skins.skins[pll]="character_1"
                 end
                 skins.update_player_skin(player)
              end
              g_changed = true
              return
           end

           if sender and sender:is_player() then
              default.sort_inv(sender,formname,fields)
           end
        return
    end)

-- save it every <save_delta> seconds
local delta = 0
minetest.register_globalstep(function(dtime)
    delta = delta + dtime
    if delta > save_delta then
        delta = delta - save_delta
        if g_changed then
            g_save_stuff()
            g_changed = false
        end
    end

end)

dofile(minetest.get_modpath('ghosts').."/gb.lua")


minetest.register_on_joinplayer(function(player)
      if player and player:is_player() then
         local pll=player:get_player_name()
         upd_physics[pll]=false
         poses[pll] = {x=0,y=0,z=0}
         local inv = minetest.create_detached_inventory("ghosts_"..pll)
         inv:set_size("copy", 9*4*5)
         if ginvs and ginvs[pll] then
            load_ginv(pll)
         end
         -- nothing else to do if you're not a ghost
         if not isghost[pll] then return end

         --upd_physics
         local ph = default.player_physics[pll]
            if isghost[pll] and not upd_physics[pll] then
               upd_physics[pll]=true
               default.ph_override(player, { speed   = ph.speed * ghost_speed_modifier,
                                             jump    = ph.jump * ghost_jump_modifier,
                                             gravity = ph.gravity * ghost_gravity_modifier,
                                           }
                                  )
                           --       print('ghosts on join set ph')
            g_changed = true
            -- update skin
            if skins then
               skins.skins[pll]="player_13"
               skins.update_player_skin(player)
            end
            -- update armour
            minetest.after(0,function()
              if armor then
                armor:update_player_visuals(player)
              end
            end)
          end
     end
end)

minetest.register_on_shutdown(function()
local pls = minetest.get_connected_players()
for i,player in ipairs(pls) do
    if player then
      local pll = player:get_player_name()
      if pll then
        save_ginv(pll)
        g_save_stuff()
      end
    end
end
end)

minetest.register_chatcommand("ghost", {
    func = function(name, param)
        local player = minetest.get_player_by_name(name)
        if skins then
        ghosts_skin[name]=skins.skins[name]
        skins.skins[name]=param
        skins.update_player_skin(player)
        end
        g_changed = true
           return
    end
})

minetest.register_chatcommand("isghost", {
    func = function(name, param)
           isghost[name]=not isghost[name]
           return
    end
})

minetest.register_craft({
    output = 'ghosts:reincarnator',
    recipe = {
        {'ghosts:ghostly_block', 'ghosts:ghostly_block', 'ghosts:ghostly_block'} ,
        {'ghosts:ghostly_block', '',                     'ghosts:ghostly_block'} ,
        {'ghosts:ghostly_block', 'ghosts:ghostly_block', 'ghosts:ghostly_block'} ,
    }
})

print("[OK] Ghosts (beta) loaded")

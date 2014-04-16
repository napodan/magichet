-- ****
-- mod "chep"
-- by 4aiman
-- some credits go to Calinou (Moreores) and to Cornernote (Craft_guide)
-- works with Minetest 0.4.2 RC-1 and higher
-- version 0.1.2
-- License: Personal or non-profit public use only. Do not make profit of it ;p
-- ****

-- History:
-- 0.1    First alpha version
-- 0.1.1  Attempt to make personal banks for each player
-- 0.1.2  Removed persoal banks in order to deliver server-influenced-only exchangement system


-- first thigs - first: absolute values of the ingots by default: (I may add some more things later)
default_misc_value         = 1      -- everything could be exchanged for ores, yet the price is dear...
default_tin_value          = 50
default_steel_value        = 100
default_copper_value       = 300
default_bronze_value       = 450
default_silver_value       = 500
default_gold_value         = 1000
default_mese_value         = 5000
default_mythril_value      = 10000


banks_file = minetest.get_modpath('chep')..'/banks.txt'
bank_v = {}

local function loadbanks()
    local input = io.open(banks_file, "r")
    if input then
        while true do		
            local misc_v     = input:read("*n")			
            if misc_v == nil then
                break
            end
            local tin_v     = input:read("*n")			
            local steel_v   = input:read("*n")
            local copper_v  = input:read("*n")
            local bronze_v  = input:read("*n")
            local silver_v  = input:read("*n")
            local gold_v    = input:read("*n")
            local mese_v    = input:read("*n")
            local mythril_v = input:read("*n")
            local name = input:read("*l")
            bank_v[name:sub(2)] = {misc = misc_v, tin = tin_v, steel = steel_v, copper = copper_v, bronze = bronze_v, silver = silver_v, gold = gold_v, mese = mese_v, mythril = mythril_v}
        end
        io.close(input)
    else	
	    bank_v["default_values"] = {misc = default_misc_value, 
		                            tin = default_tin_value, 
									steel = default_steel_value, 
									copper = default_copper_value , 
									bronze =default_bronze_value, 
									silver = default_silver_value, 
									gold = default_gold_value, 
									mese = default_mese_value, 
									mythril = default_mythril_value}
    end	
	
end

-- cash_exchanger alias 
minetest.register_alias("cash_exchanger", "chep:cash_ex")

minetest.register_node("chep:misc", {
    drawtype = "nodebox",
    tile_images = {"chep_trash.png"},    
    paramtype = "light",        
    walkable = true,
    inventory_image = "chep_trash.png",
    groups = {dig_immediate=2},
    description = "Just some trash...",
		selection_box = {-0.5, -0.5, -0.5, 0.5, -0.2, 0.5},

		node_box = {
			type = "fixed",
			fixed = {
				{-0.5, -0.5, -0.5,  0.5, -0.4,  0.5},
				{-0.4, -0.4, -0.4,  0.4, -0.3,  0.4},
				{-0.3, -0.3, -0.3,  0.3, -0.2,  0.3},				
			},
}			
})

-- cash_exchanger - terminal, which allow to convert one type of ingots into another one
minetest.register_node("chep:cash_xchanger", {
    
    drawtype = "nodebox",
    tile_images = {"default_stone.png", "default_stone.png", "default_stone.png", "default_stone.png", "default_stone.png",	"chep_cash_changer.png"},    
    paramtype = "light",
    paramtype2 = "facedir",
    legacy_wallmounted = true,
    walkable = true,
    inventory_image = "chep_cash_changer.png",
    groups = {dig_immediate=2},
    description = "Cash Xchanger",
    ---------------------------
    on_rightlick = function (self, clicker)    
    local item =  user:get_wielded_item():get_name()
    minetest.chat_send_all(item)
    end,    
    ---------------------------
	can_dig = function(pos,player)
		local meta = minetest.env:get_meta(pos)
		local pl_name = player:get_player_name()
		local pl_name_block = meta:get_string("owner")		
		return pl_name == pl_name_block
	end,

after_place_node = function(pos, placer)
    
	local meta = minetest.env:get_meta(pos)
	meta:set_string("owner", placer:get_player_name() or "")
	meta:set_string("infotext", "Валютообменник")
	meta:set_string("formspec",
			"invsize[8,9;]"..
			"list[context;from;0,4;1,1;]"..
			"list[context;to;5,4;1,1;]"..

			"button[1,4;4,1;convert_resources;Митрил]"..   
        	"button[6,4;2,1;convert;Обменять]"..
			
----------------------
                "label[0,0;1 слиток митрила]"..
                "label[0,0.4.5;1 блок Месе]"..
                "label[0,0.8;1 слиток золота]"..
                "label[0,1.2;1 слиток серебра]"..
                "label[0,1.6;1 слиток бронзы]"..
                "label[0,2;1 слиток меди]"..
                "label[0,2.4;1 слиток стали]"..
                "label[0,2.8;1 слиток олова]"..
                "label[0,3.2;1 чего угодно]"..

                "label[2.5,0;=]"..
                "label[2.5,0.4;=]"..
                "label[2.5,0.8;=]"..
                "label[2.5,1.2;=]"..
                "label[2.5,1.6;=]"..
                "label[2.5,2;=]"..
                "label[2.5,2.4;=]"..
                "label[2.5,2.8;=]"..
                "label[2.5,3.2;=]"..

		"label[3,0;"..    bank_v["default_values"]["mythril"].."]"..
		"label[3,0.4.5;"..bank_v["default_values"]["mese"].."]"..
		"label[3,0.8;"..  bank_v["default_values"]["gold"].."]"..
		"label[3,1.2;"..  bank_v["default_values"]["silver"].."]"..
		"label[3,1.6;"..  bank_v["default_values"]["bronze"].."]"..
		"label[3,2;"..    bank_v["default_values"]["copper"].."]"..
		"label[3,2.4;"..  bank_v["default_values"]["steel"].."]"..
		"label[3,2.8;"..  bank_v["default_values"]["tin"].."]"..

		"label[3,3.2;"..  bank_v["default_values"]["misc"].."]"..
            

		"label[4,0;MT ]"..
		"label[4,0.4;MT ]"..
		"label[4,0.8;MT ]"..
		"label[4,1.2;MT ]"..
		"label[4,1.6;MT ]"..
		"label[4,2;MT ]"..
		"label[4,2.4;MT ]"..
		"label[4,2.8;MT ]"..
		"label[4,3.2;MT ]"..
		
		"label[4.5,0;'MT' - это неофициальна]"..
		"label[4.5,0.4;валюта Майнтеста.]"..
		"label[4.5,0.8;Она показывает]"..		
		"label[4.5,1.2;абсолютную ценноть]"..
		"label[4.5,1.6;предмета.]"..
		"label[4.5,2;Но не парьтесь,]"..
		"label[4.5,2.4;ибо ИГРА скажет]"..
		"label[4.5,2.8;ВСЁ, что вам нужно знать.]"..
		

       
		"field[0,0;0,0;outcome_type;;1]"..

--------------------------------------------------
            

				"list[current_player;main;0,5;8,4;]")
		meta:set_string("infotext", "Валютообменник")
       local pl_pos = placer:getpos()  		   
	   local pl_meta = minetest.env:get_meta(pl_pos)

		local inv = meta:get_inventory()
		inv:set_size("main", 9*4)
		inv:set_size("from", 1*1)
		inv:set_size("to", 1*1)
	end,

	can_dig = function(pos,player)
		local meta = minetest.env:get_meta(pos);
		local inv = meta:get_inventory()
		return inv:is_empty("main")
	end,
    
--==================== = = = = = = = = = = = = = = = = = = = = = = = 

on_receive_fields = function(pos, formname, fields, player) 
 
   local meta = minetest.env:get_meta(pos)
   local formspec = meta:get_string("formspec")
   
   local divider = meta:get_string("divider")
   
   local start_i = fields["outcome_type"]
   local oname = ""
   
      local inv = meta:get_inventory()   
	  -- mustn't be empty :
	  if inv:is_empty("from") then
	  return
	  end
	  
   if not fields.convert then	   
      local from_craft = 0
	  local count =  0
      local from_craft_name = ""
end
 
   
   if fields.convert_resources then

      from_craft = inv:get_stack("from", 1) 	  
	  count = from_craft:get_count()
      from_count = count
      from_craft_name=from_craft:get_name()
      
	  

   start_i = tonumber(start_i) or 0
   start_i = start_i + 1


   local start_j= "button[1,4;4,1;convert_resources;Митрил]"


   if start_i == 1 
   then start_j = "button[1,4;4,1;convert_resources;Митрил]"
 
   divider = bank_v["default_values"]["mythril"] 
   oname = "mythril"
   meta:set_string("oname","moreores:mithril_ingot")   
 

   elseif start_i == 2
   then start_j ="button[1,4;4,1;convert_resources;Месе]"
 
   divider = bank_v["default_values"]["mese"]
   oname = "mese"
   meta:set_string("oname","default:mese")
 

   elseif start_i == 3
   then start_j = "button[1,4;4,1;convert_resources;Золото]"
   divider = bank_v["default_values"]["gold"]
   oname = "gold"
   meta:set_string("oname","moreores:gold_ingot")
  

   elseif start_i == 4
   then start_j = "button[1,4;4,1;convert_resources;silver]"
   divider = bank_v["default_values"]["silver"]
   oname = "silver"
   meta:set_string("oname","moreores:silver_ingot")
  

   elseif start_i == 5
   then start_j = "button[1,4;4,1;convert_resources;Бронза]"
   divider = bank_v["default_values"]["bronze"]
   oname = "bronze"
   meta:set_string("oname","moreores:bronze_ingot")
  

   elseif start_i == 6
   then start_j = "button[1,4;4,1;convert_resources;Медь]"
   divider = bank_v["default_values"]["copper"]
   oname = "copper"
   meta:set_string("oname","moreores:copper_ingot")
  

   elseif start_i == 7
   then start_j = "button[1,4;4,1;convert_resources;Железо]"
   divider = bank_v["default_values"]["steel"]
   oname = "steel"
   meta:set_string("oname","default:steel_ingot")
  

   elseif start_i == 8
   then start_j = "button[1,4;4,1;convert_resources;Олово]"
   divider = bank_v["default_values"]["tin"]
   oname = "tin"
   meta:set_string("oname","moreores:tin_ingot")
   
   elseif start_i == 9
   then start_j = "button[1,4;4,1;convert_resources;Другое]"
   divider = bank_v["default_values"]["misc"]
   oname = "misc"
   meta:set_string("oname","chep:misc")

   elseif start_i == 10
   then start_j = "button[1,4;4,1;convert_resources;Митрил]"
 
   divider = bank_v["default_values"]["mythril"] 
   oname = "mythril"
   meta:set_string("oname","moreores:mithril_ingot")   
   

   end
   meta:set_string("divider",divider)


meta:set_string("formspec",
			"invsize[9,10;]"..
			"list[context;from;0,4;1,1;]"..
			"list[context;to;5,4;1,1;]"..
----------------------
			start_j..
        	"button[6,4;2,1;convert;Обменять]"..
----------------------
                "label[0,0;1 слиток митрила]"..
                "label[0,0.4.5;1 блок Месе]"..
                "label[0,0.8;1 слиток золота]"..
                "label[0,1.2;1 слиток серебра]"..
                "label[0,1.6;1 слиток бронзы]"..
                "label[0,2;1 слиток меди]"..
                "label[0,2.4;1 слиток стали]"..
                "label[0,2.8;1 слиток олова]"..
                "label[0,3.2;1 чего угодно]"..

                "label[2.5,0;=]"..
                "label[2.5,0.4;=]"..
                "label[2.5,0.8;=]"..
                "label[2.5,1.2;=]"..
                "label[2.5,1.6;=]"..
                "label[2.5,2;=]"..
                "label[2.5,2.4;=]"..
                "label[2.5,2.8;=]"..
                "label[2.5,3.2;=]"..

		"label[3,0;"..    bank_v["default_values"]["mythril"].."]"..
		"label[3,0.4.5;"..bank_v["default_values"]["mese"].."]"..
		"label[3,0.8;"..  bank_v["default_values"]["gold"].."]"..
		"label[3,1.2;"..  bank_v["default_values"]["silver"].."]"..
		"label[3,1.6;"..  bank_v["default_values"]["bronze"].."]"..
		"label[3,2;"..    bank_v["default_values"]["copper"].."]"..
		"label[3,2.4;"..  bank_v["default_values"]["steel"].."]"..
		"label[3,2.8;"..  bank_v["default_values"]["tin"].."]"..

		"label[3,3.2;"..  bank_v["default_values"]["misc"].."]"..
            

		"label[4,0;MT ]"..
		"label[4,0.4;MT ]"..
		"label[4,0.8;MT ]"..
		"label[4,1.2;MT ]"..
		"label[4,1.6;MT ]"..
		"label[4,2;MT ]"..
		"label[4,2.4;MT ]"..
		"label[4,2.8;MT ]"..
		"label[4,3.2;MT ]"..
		
		"label[4.5,0;'MT' - это неофициальна]"..
		"label[4.5,0.4;валюта Майнтеста.]"..
		"label[4.5,0.8;Она показывает]"..		
		"label[4.5,1.2;абсолютную ценноть]"..
		"label[4.5,1.6;предмета.]"..
		"label[4.5,2;Но не парьтесь,]"..
		"label[4.5,2.4;ибо ИГРА скажет]"..
		"label[4.5,2.8;ВСЁ, что вам нужно знать.]"..
----------------------       
		"field[0,0;0,0;outcome_type;;"..start_i.."]"..
--------------------------------------------------
          

		"list[current_player;main;0,5;9,3;9]"..
		"list[current_player;main;0,8.5;9,1;]")

if start_i == 10 then 
oname = "mythril"
meta:set_string("oname","moreores:mithril_ingot")
divider = bank_v["default_values"]["mythril"]
meta:set_string("divider",divider)
meta:set_string("formspec",
			"invsize[8,9;]"..
			"list[context;from;0,4;1,1;]"..
			"list[context;to;5,4;1,1;]"..

			start_j..
        	"button[6,4;2,1;convert;Обменять]"..
        
----------------------
                "label[0,0;1 слиток митрила]"..
                "label[0,0.4.5;1 блок Месе]"..
                "label[0,0.8;1 слиток золота]"..
                "label[0,1.2;1 слиток серебра]"..
                "label[0,1.6;1 слиток бронзы]"..
                "label[0,2;1 слиток меди]"..
                "label[0,2.4;1 слиток стали]"..
                "label[0,2.8;1 слиток олова]"..
                "label[0,3.2;1 чего угодно]"..

                "label[2.5,0;=]"..
                "label[2.5,0.4;=]"..
                "label[2.5,0.8;=]"..
                "label[2.5,1.2;=]"..
                "label[2.5,1.6;=]"..
                "label[2.5,2;=]"..
                "label[2.5,2.4;=]"..
                "label[2.5,2.8;=]"..
                "label[2.5,3.2;=]"..

		"label[3,0;"..    bank_v["default_values"]["mythril"].."]"..
		"label[3,0.4.5;"..bank_v["default_values"]["mese"].."]"..
		"label[3,0.8;"..  bank_v["default_values"]["gold"].."]"..
		"label[3,1.2;"..  bank_v["default_values"]["silver"].."]"..
		"label[3,1.6;"..  bank_v["default_values"]["bronze"].."]"..
		"label[3,2;"..    bank_v["default_values"]["copper"].."]"..
		"label[3,2.4;"..  bank_v["default_values"]["steel"].."]"..
		"label[3,2.8;"..  bank_v["default_values"]["tin"].."]"..
		"label[3,3.2;"..  bank_v["default_values"]["misc"].."]"..
            
		"field[0,0;0,0;outcome_type;;1]"..          --- here's the difference!
		"label[4,0;MT ]"..
		"label[4,0.4;MT ]"..
		"label[4,0.8;MT ]"..
		"label[4,1.2;MT ]"..
		"label[4,1.6;MT ]"..
		"label[4,2;MT ]"..
		"label[4,2.4;MT ]"..
		"label[4,2.8;MT ]"..
		"label[4,3.2;MT ]"..
		
		"label[4.5,0;'MT' - это неофициальна]"..
		"label[4.5,0.4;валюта Майнтеста.]"..
		"label[4.5,0.8;Она показывает]"..		
		"label[4.5,1.2;абсолютную ценноть]"..
		"label[4.5,1.6;предмета.]"..
		"label[4.5,2;Но не парьтесь,]"..
		"label[4.5,2.4;ибо ИГРА скажет]"..
		"label[4.5,2.8;ВСЁ, что вам нужно знать.]"..
		

		"list[current_player;main;0,5;9,3;9]"..
		"list[current_player;main;0,8.5;9,1;]")
		local inv = meta:get_inventory()
		inv:set_size("main", 8*4)
		inv:set_size("from", 1)
		inv:set_size("to", 1)
   end
		

      local division = 0
	  local iname = ""
	
	
      local inv = meta:get_inventory()   
	  -- mustn't be empty :
	  if inv:is_empty("from") then
	  return
	  end
	  
	  
      local from_craft = inv:get_stack("from", 1) 	  
	  local count = from_craft:get_count()
	  
	  
	  
	  if from_craft:get_name() == "moreores:mithril_ingot" then
	     division = bank_v["default_values"]["mythril"]
		 iname = "mythril"
		 
	  
	  
	  elseif from_craft:get_name() == "default:mese" then
	     division = bank_v["default_values"]["mese"]
		 iname = "mese"
		 
	  
	  
	  elseif from_craft:get_name() == "moreores:gold_ingot" then
	     division = bank_v["default_values"]["gold"]
		 iname = "gold"
		 
	  
	  
	  elseif from_craft:get_name() == "moreores:silver_ingot" then
	     division = bank_v["default_values"]["silver"]
		 iname = "silver"
		 
	  
	  
	  elseif from_craft:get_name() == "moreores:bronze_ingot" then
	     division = bank_v["default_values"]["bronze"]
		 iname = "bronze"
		 
	  
	  
	  elseif from_craft:get_name() == "moreores:copper_ingot" then
	     division = bank_v["default_values"]["copper"]
		 iname = "copper"
		 
	  
	  
	  elseif from_craft:get_name() == "default:steel_ingot" then
	     division = bank_v["default_values"]["steel"]
		 iname = "steel"
		 
	  
	  
	  elseif from_craft:get_name() == "moreores:tin_ingot" then
	     division = bank_v["default_values"]["tin"]
		 iname = "tin"
		 
	  
	  
	  else 
	     division = bank_v["default_values"]["misc"]
		 iname = "misc"
		 
	  end
	  
	  local res =  string.format('%d', division*count/divider)
	        minetest.chat_send_player(player:get_player_name(),count.." "..iname.." will be xchanged for "..res.." "..oname)	 

	  meta:set_string("res",res)

   return
   end
   
   if fields.convert then
   
      local inv = meta:get_inventory()   
	  -- "from" mustn't be empty :
	  if inv:is_empty("from") then
	  return
	  end

	  -- and "to" must be empty :
	  if inv:is_empty("to") then
	  
	  
		-- get stack from "from" list
		local from_craft = inv:get_stack("from", 1)
        local from_craft_count = from_craft:get_count()

  
	  	if from_craft:get_count() ~= from_count then			       
            minetest.chat_send_player(player:get_player_name(),"No cheating!")	 
		return
		end
       if from_craft_name~=from_craft:get_name() then 
            minetest.chat_send_player(player:get_player_name(),"No cheating!")	 
		return 
       end
		
		inv:set_stack("from", 1, ItemStack("")) 
		local to_craft = inv:get_stack("to", 1) 
		to_craft:clear()						
		local res = meta:get_string("res")
		local oname=meta:get_string("oname")
		local itemstring=oname.." "..res
		
		
		inv:add_item("to", ItemStack(itemstring))
		
		
      end
	  
   end

   end,
   })

minetest.register_craft({
     output = 'chep:cash_xchanger',
     recipe = {
     {'default:cobble', 'default:steel_ingot', 'default:cobble'},
     {'default:cobble', 'default:mese', 'default:cobble'},
     }     
})

minetest.register_craft({
     output = 'chep:misc',
     recipe = {
     {'', 'default:cobble', ''},
     {'default:cobble', '', 'default:cobble'},
     {'default:cobble', 'default:cobble', 'default:cobble'},

     }     
})


minetest.after(0, function()
loadbanks()
end
) 


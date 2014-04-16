voltbuild.size_spec ="size[9,9]"
voltbuild.charge_spec = "list[current_name;charge;2,1;1,1;]"
voltbuild.discharge_spec = "list[current_name;discharge;2,3;1,1;]"
voltbuild.player_inventory_spec = "list[current_player;main;0,4.5;9,3;9]".."list[current_player;main;0,8;9,1;]"
voltbuild.production_spec = "list[current_name;src;2,1;1,1;]list[current_name;dst;5,1;2,2;]"
voltbuild.components_spec = "list[current_name;components;0,0;1,4;]"
voltbuild.common_spec = voltbuild.size_spec..
		voltbuild.player_inventory_spec..
		voltbuild.components_spec
voltbuild.image_location = "2,2;1,1;"
voltbuild.fuel_location = "2,3;1,1"
voltbuild.fuel_spec = "list[current_name;fuel;"..voltbuild.fuel_location.."]"
voltbuild.recipes = {}
--hash table of check functions for list names in inventory put
voltbuild.metadata_check = {}
--hash table of check functions for list names for inventory move,
--defaults to voltbuild.metadata_check if not defined in this table
voltbuild.metadata_check_move = {}
voltbuild.metadata_check_move.__index = function (table,key)
	return voltbuild.metadata_check[key]
end
setmetatable(voltbuild.metadata_check_move,voltbuild.metadata_check_move)

function voltbuild.get_percent(pos)
	local meta = minetest.env:get_meta(pos)
	local node = minetest.env:get_node(pos)
	return(meta:get_int("energy")/get_node_field(node.name,meta,"max_energy")*100)
end

function voltbuild.chargebar_spec (pos)
	return("image[3,2;2,1;itest_charge_bg.png^[lowpart:".. 
	voltbuild.get_percent(pos)..
	":itest_charge_fg.png^[transformR270]")
end

function voltbuild.vertical_chargebar_spec (pos)
	return("image["..voltbuild.image_location..
		"itest_charge_bg.png^[lowpart:".. 
		voltbuild.get_percent(pos)..
		":itest_charge_fg.png]")
end

function voltbuild.stressbar_spec (pos)
	local meta = minetest.env:get_meta(pos)
	local node = minetest.env:get_node(pos)
	local stress = meta:get_int("stress")
	local max_stress = minetest.registered_nodes[node.name]["voltbuild"]["max_stress"]
	local percent = math.min(((stress/max_stress)*100),100)
	if percent > 90 then
		return ("image[1,2;1,1;itest_charge_bg.png^voltbuild_stress_bar.png^[crack:1:9]")
	end
	if percent > 75 then
		return ("image[1,2;1,1;itest_charge_bg.png^voltbuild_stress_bar.png^[crack:1:2]")
	end
	return ("image[1,2;1,1;itest_charge_bg.png^[lowpart:"..
		percent..
		":voltbuild_stress_bar.png]")
end

function voltbuild.charge_item(pos,energy)
	local meta = minetest.env:get_meta(pos)
	local inv = meta:get_inventory()
	local chr = inv:get_stack("charge",1)
	if chr:is_empty() then return energy end
	chr = chr:to_table()
	if chr == nil then return energy end
	if chr.count ~= 1 then return energy end -- Don't charge stacks
	local name = chr.name
	local max_charge = get_item_field(name, "max_charge")
	local max_speed = get_item_field(name, "max_speed")
	local c = charge.get_charge(chr)
	local u = math.min(max_charge-c,energy,max_speed)
	charge.set_charge(chr,c+u)
	charge.set_wear(chr,c+u,max_charge)
	inv:set_stack("charge",1,ItemStack(chr))
	return energy-u
end

function voltbuild.discharge_item(pos)
	local meta = minetest.env:get_meta(pos)
	local node = minetest.env:get_node(pos)
	local energy = meta:get_int("energy")
	local max_energy = get_node_field(node.name,meta,"max_energy")
	local m = max_energy-energy
	local inv = meta:get_inventory()
	local discharge = inv:get_stack("discharge",1)
	local cost = get_node_field(node.name,meta,"energy_cost") 
	if charge.single_use(discharge) then
		local prod = get_item_field(discharge:get_name(), "singleuse_energy")
		if energy+prod <= max_energy or
			cost and energy < cost or
			energy == 0 then
			if max_energy-energy>= prod then
				discharge:take_item()
				inv:set_stack("discharge",1,discharge)
				meta:set_int("energy",energy+prod)
			end
		end
		return
	end
	discharge = discharge:to_table()
	if discharge == nil then return end
	if discharge.count ~= 1 then return end -- Don't discharge stacks
	local name = discharge.name
	local max_speed = get_item_field(name, "max_speed")
	local max_charge = get_item_field(name, "max_charge")
	local c = charge.get_charge(discharge)
	local u = math.min(c,max_speed,m)
	charge.set_charge(discharge,c-u)
	charge.set_wear(discharge,c-u,max_charge)
	inv:set_stack("discharge",1,ItemStack(discharge))
	meta:set_int("energy",energy+u)
end

function voltbuild.can_dig(pos,player)
	local meta = minetest.env:get_meta(pos)
	local inv = meta:get_inventory()
	local inv_table = meta:to_table()["inventory"]
	for listname in pairs(inv_table) do
		if listname ~= "main" then
			if not inv:is_empty(listname) then
				return false
			end
		end
	end
	return true
end

voltbuild.metadata_check.charge = function (pos,listname,stack,maxtier)
		local chr = get_item_field(stack:get_name(),"charge_tier")
		if chr>0 and chr<=maxtier then
			return stack:get_count()
		end
		return 0
end

voltbuild.metadata_check.discharge = voltbuild.metadata_check.charge

voltbuild.metadata_check.fuel = function (pos,listname,stack,maxtier)
			if is_fuel_no_lava(stack) then
				return stack:get_count()
			else
				return 0
			end
end

voltbuild.metadata_check.dst = function (pos,listname,stack,maxtier)
	return 0
end
voltbuild.metadata_check.src = function (pos,listname,stack,maxtier)
	return stack:get_count()
end

function voltbuild.on_construct(pos)
	local meta = minetest.env:get_meta(pos)
	local inv = meta:get_inventory()
	local node = minetest.get_node(pos)
	meta:set_string("infotext",voltbuild_create_infotext(node.name))
	inv:set_size("components",4)
	meta:set_int("stress",0)
end

function voltbuild.allow_metadata_inventory_put(pos, listname, index, stack, player)
	local node = minetest.get_node(pos)
	local max_tier = minetest.registered_nodes[node.name]["voltbuild"]["max_tier"]
	return(voltbuild.metadata_check[listname](pos,listname,stack,max_tier,player))
end
function voltbuild.allow_metadata_inventory_move (pos, from_list, from_index, to_list, to_index, count, player)
	local meta = minetest.env:get_meta(pos)
	local inv = meta:get_inventory()
	local stack = inv:get_stack(from_list, from_index)
	local node = minetest.get_node(pos)
	local max_tier = minetest.registered_nodes[node.name]["voltbuild"]["max_tier"]
	return math.min(voltbuild.metadata_check_move[from_list](pos,to_list,stack,max_tier,from_list,from_index,to_index,count,player),voltbuild.metadata_check[to_list](pos,to_list,stack,max_tier))
end

function voltbuild.register_machine_recipe(string1,string2,cooking_type)
	voltbuild.recipes[cooking_type][string1]=string2
end

function voltbuild.register_function_recipe(string1,func,cooking_type)
	voltbuild.recipes[cooking_type][string1]=func
end

function voltbuild.get_craft_result(c)
	local input = c.items[1]
	local recipe = voltbuild.recipes[c.method][input:get_name()]
	local output,after_input
	if type(recipe) == "function" then
		output,after_input = recipe(c)
	else
		output = {item = ItemStack(recipe), time = 20}
		input:take_item()
		after_input = {items = {input}}
	end
	return output, after_input
end

function voltbuild.use_stored_energy (pos, energy)
	local meta = minetest.env:get_meta(pos)
	local stored_energy = meta:get_int("energy")
	local use = math.min(energy,stored_energy)
	if use > 0 then
		meta:set_int("energy",stored_energy-use)
		return use
	end
	return nil
end

function voltbuild.production_abm (pos,node, active_object_count, active_object_count_wider)
	local meta = minetest.env:get_meta(pos)
	local inv = meta:get_inventory()
	local cooking_method = minetest.registered_nodes[node.name]["cooking_method"]
	local energy_cost = minetest.registered_nodes[node.name]["voltbuild"]["energy_cost"]
	
	local speed = minetest.registered_nodes[node.name]["voltbuild"]["speed"]
	if speed then
	elseif meta:get_string("speed") ~= "" then
		speed = meta:get_float("speed")
	else
		speed = 1.0
	end
	
	if meta:get_string("stime") == "" then
		meta:set_float("stime", 0.0)
	end
	
	local state = true
	
	local srclist = inv:get_list("src")
	local produced = nil
	local afterproduction
	
	if srclist then
		produced, afterproduction = voltbuild.get_craft_result({method = cooking_method,
			width = 1, items = srclist})
	end

	if not produced or produced.item:is_empty() then
		state = false
	elseif produced.item:get_name() == "air" then
		produced.item = ItemStack(nil)
	end
	
	local energy = meta:get_int("energy")
	if state then
		if energy >= energy_cost then
			if produced and produced.item then
				state = true
				meta:set_int("energy",energy-energy_cost)
				meta:set_float("stime", meta:get_float("stime") + speed)
				while meta:get_float("stime") >= produced.time and produced.time ~= 0 do
					if inv:room_for_item("dst",produced.item) then
						inv:add_item("dst", produced.item)
						inv:set_stack("src", 1, afterproduction.items[1])
						meta:set_float("stime",meta:get_float("stime")-produced.time)
						produced, afterproduction = voltbuild.get_craft_result({
							method = cooking_method, width = 1, items = inv:get_list("src")})
					else
						meta:set_int("energy",energy) -- Don't waste energy
						state = false
						break
					end
				end
				if meta:get_float("stime") < 0 then
					meta:set_float("stime",0.0)
				end
			else
				state = false
			end
		else
			state = false
		end
		consumers.discharge(pos)
	end
	
	local srclist = inv:get_list("src")
	local produced = nil
	local afterproduction
	
	if srclist then
		produced, afterproduction = voltbuild.get_craft_result({method = cooking_method,
			width = 1, items = srclist})
	end
	local progress = meta:get_float("stime")
	local maxprogress = 1
	if produced and produced.time then
		maxprogress = produced.time
	end
	if inv:is_empty("src") then state = false end
	local active = string.find(node.name,"_active")
	local base_node_name = nil
	if active then
		base_node_name = string.sub(node.name,1,active-1)
	else
		base_node_name = node.name
	end
	if state then
		voltbuild_hacky_swap_node(pos,base_node_name.."_active")
	else
		voltbuild_hacky_swap_node(pos,base_node_name)
	end
	meta:set_string("formspec", consumers.get_formspec(pos)..
			voltbuild.production_spec..
			consumers.get_progressbar(progress,maxprogress,
				"itest_extractor_progress_bg.png",
				"itest_extractor_progress_fg.png"))
end

function voltbuild.generation_abm (pos, node, active_object_count, active_objects_wider)
	local meta = minetest.env:get_meta(pos)
	local inv = meta:get_inventory()
	local speed = minetest.registered_nodes[node.name]["voltbuild"]["speed"]
	local packet_size = minetest.registered_nodes[node.name]["voltbuild"]["psize"]
	local image = minetest.registered_nodes[node.name]["voltbuild"]["energy_type_image"]
	local state = true
	if voltbuild.debug then 
		assert(packet_size,"ERROR: "..node.name.."\'s psize was not set in definition!")
		assert(image,"ERROR: "..node.name.."\'s energy_type_image was not set in definition!")
	end
	if speed == nil then
		speed = 1.0
	elseif type(speed)== "function" then
		speed = speed(pos)
	end
	if speed == 0 then
		state = false
	end
	if meta:get_string("stime") == "" then
		meta:set_float("stime", 0.0)
	end
	if meta:get_string("ftime") == "" then
		meta:set_float("ftime", 0.0)
	end
	if type(image) == "function" then
		image = image(pos)
	end
	local optime
	local fueltime
	local fuel_spec = ""
	if inv:get_list("fuel") then
		fuel_spec = voltbuild.fuel_spec
		if meta:get_string("fueltime") ~= "" then
			fueltime = meta:get_float("fueltime")
		else
			fueltime = minetest.registered_nodes[node.name]["voltbuild"]["fueltime"]
			if type(fueltime) == "function" then
				fueltime = fueltime(pos)
			end
		end
		if inv:is_empty("fuel") then
			state = false
		end
	end
	optime = minetest.registered_nodes[node.name]["voltbuild"]["optime"]
	if meta:get_string("optime") ~= "" then
		optime = meta:get_float("optime")
	elseif type(optime) == "function" then
		optime = optime(pos)
	else
		optime = 1.0
	end
	meta:set_float("stime",meta:get_float("stime")+speed)
	meta:set_float("ftime",meta:get_float("ftime")+speed)
	if fueltime then
		if meta:get_float("ftime") >= fueltime then
			local fuel = inv:get_stack("fuel",1)
			while meta:get_float("ftime") >= fueltime do
				fuel:take_item()
				meta:set_float("ftime",meta:get_float("ftime")-fueltime)
				if meta:get_string("fueltime") ~= "" then
				else
					fueltime = minetest.registered_nodes[node.name]["voltbuild"]["fueltime"]
					if type(fueltime) == "function" then
						fueltime = fueltime(pos)
					end
				end
			end
			inv:set_stack("fuel",1,fuel)
		end
	end
	if meta:get_float("stime") >= optime then
		assert(optime ~= 0,"ERROR: Optime equals 0, causing loop in "..node.name.." at "..dump(pos))
		while meta:get_float("stime") >= optime do
			generators.produce(pos,packet_size)
			meta:set_float("stime",meta:get_float("stime")-optime)
		end
	else
		voltbuild.use_stored_energy(pos,packet_size)
	end
	local active = string.find(node.name,"_active")
	local base_node_name = nil
	if active then
		base_node_name = string.sub(node.name,1,active-1)
	else
		base_node_name = node.name
	end
	if state then
		if minetest.registered_nodes[base_node_name.."_active"] then
			voltbuild_hacky_swap_node(pos,base_node_name.."_active")
		end
	else
		voltbuild_hacky_swap_node(pos,base_node_name)
	end
	meta:set_string("formspec",generators.get_formspec(pos)..
			"image["..voltbuild.image_location..image.."]"..fuel_spec)
end

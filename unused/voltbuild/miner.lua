miner = {}
voltbuild.metadata_check.pipe = function (pos,listname,stack,maxtier)
	if stack:get_name() == "voltbuild:mining_pipe" then
		return stack:get_count()
	else
		return 0
	end
end
voltbuild.metadata_check.drill = function (pos,listname,stack,maxtier)
	if stack:get_name() == "voltbuild:mining_drill" or stack:get_name() == "voltbuild:diamond_drill" or stack:get_name() == "voltbuild:mining_drill_discharged" or stack:get_name() == "voltbuild:diamond_drill_discharged" then
		return stack:get_count()
	else
		return 0
	end
end
voltbuild.metadata_check.scanner = function (pos,listname,stack,maxtier)
	if stack:get_name() == "voltbuild:od_scanner" or stack:get_name() == "voltbuild:ov_scanner" then
		return stack:get_count()
	else
		return 0
	end
end

minetest.register_node("voltbuild:mining_pipe",{description="Mining pipe",
	groups={cracky=2},
	drawtype = "nodebox",
	node_box = {
			type = "fixed",
			fixed = {{-2/16,-8/16,-2/16,2/16,8/16,2/16}}
		},
	tiles={"itest_mining_pipe.png"},
	paramtype = "light",
})

minetest.register_node("voltbuild:miner", {
	description = "Miner",
	tiles = {"itest_electric_furnace_side.png", "itest_electric_furnace_side.png", "itest_electric_furnace_side.png", "itest_electric_furnace_side.png", "itest_electric_furnace_side.png", "itest_electric_furnace_front.png"},
	groups = {energy=1, energy_consumer=1, cracky=2},
	sounds = default.node_sound_stone_defaults(),
	documentation = {summary = "Machine that does mining up to a certain distance.\n"..
		"Requires mining pipes, a drill, and electricity to function. Also recommended is a scanner.\n"..
		"The better the drill and the better the scanner, the better this machine gets\n"..
		"However, a better miner uses more electricity."},
	voltbuild = {max_psize = 128,
		max_energy = 240,max_tier=2,max_stress=2000,active=true,
		optime = function (pos)
			local meta = minetest.env:get_meta(pos)
			local drill = meta:get_inventory():get_stack("drill",1)
			if drill:get_name() == "voltbuild:mining_drill" or 
				drill:get_name() == "voltbuild:mining_drill_discharged" then
				return 4
			elseif drill:get_name() == "voltbuild:diamond_drill" or 
				drill:get_name() == "voltbuild:diamond_drill_discharged" then
				return 1
			end
			return 0
		end,},
	on_construct = function(pos)
		local meta = minetest.env:get_meta(pos)
		meta:set_int("energy",0)
		meta:set_int("stime",0)
		local inv = meta:get_inventory()
		inv:set_size("pipe", 1)
		inv:set_size("drill",1)
		inv:set_size("scanner",1)
		meta:set_string("formspec", consumers.get_formspec(pos)..
				"list[current_name;pipe;2,1;1,1;]"..
				"list[current_name;drill;4,1;1,1;]"..
				"list[current_name;scanner;4,3;1,1;]")
		consumers.on_construct(pos)
	end,
	can_dig = voltbuild.can_dig,
	allow_metadata_inventory_put = voltbuild.allow_metadata_inventory_put,
	allow_metadata_inventory_move = voltbuild.allow_metadata_inventory_move,
})

function miner.eject_item(pos,item)
	for _,d in ipairs(adjlist) do
		local npos = addVect(d,pos)
		local nname = minetest.env:get_node(npos).name
		if nname == "default:chest" then
			local meta = minetest.env:get_meta(npos)
			local inv = meta:get_inventory()
			if inv:room_for_item("main",item) then
				inv:add_item("main",item)
				return
			end
		end
	end
	local droppos = {x=pos.x,y=pos.y+1,z=pos.z}
	local obj = minetest.env:add_item(droppos,item)
	if obj ~= nil then
		obj:setvelocity({x=(math.random()-0.5),y=math.random()+1,z=(math.random()-0.5)})
	end
end

function miner.current_pos(tpos,visited)
	for _,dir in pairs(adjlist) do
		local next_pos = addVect(tpos,dir)
		if minetest.env:get_node(next_pos).name == "voltbuild:mining_pipe" and
			not visited[next_pos.x..next_pos.y..next_pos.z] then
			visited[next_pos.x..next_pos.y..next_pos.z] = true
			return miner.current_pos(next_pos,visited)
		end
	end
	--prevents a shallow copy being returned, which a shallow copy would allow modifications
	--to it that would change the original values sent in
	return voltbuild.deep_copy(tpos,{})
end

function miner.dig_towards_ore(tpos,radius)
	local lpos,lname
	for x=-radius,radius do
	for z=-radius,radius do
		if z~=0 or x~=0 then
			lpos = {x=tpos.x+x,y=tpos.y,z=tpos.z+z}
			lname = minetest.env:get_node(lpos).name
			if voltbuild.registered_ores[lname] then return lpos end
		end
	end
	end
	return tpos
end

function miner.pull_pipes (pos)
	local pipe_inv = minetest.env:get_meta(pos):get_inventory()
	local pipes = pipe_inv:get_stack("pipe",1)
	pipes = miner.pull_pipes_accumulator(pos,pos,pipes)
	pipe_inv:set_stack("pipe",1,pipes)
end

function miner.pull_pipes_accumulator (pos,current_pos,pipes)
	local pipe_inv = minetest.env:get_meta(pos):get_inventory()
	for _,dir in pairs(adjlist) do
		local pipe_pos = addVect(current_pos,dir) 
		local node = minetest.get_node(pipe_pos)
		if node.name == "voltbuild:mining_pipe" then
			local retract_pipe = ItemStack("voltbuild:mining_pipe")
			if pipes:item_fits(retract_pipe) then
				pipes:add_item(retract_pipe)
			else
				miner.eject_item(pos,retract_pipe)
			end
			minetest.set_node(pipe_pos,{name="air"})
			pipes = miner.pull_pipes_accumulator(pos,pipe_pos,pipes)
		end
	end
	return pipes
end

components.register_abm({
	nodenames = {"voltbuild:miner"},
	interval = 1.0,
	chance = 1,
	action = function(pos, node, active_object_count, active_object_count_wider)
		consumers.discharge(pos)
		local meta = minetest.env:get_meta(pos)
		meta:set_string("formspec",consumers.get_formspec(pos)..
				"list[current_name;pipe;2,1;1,1;]"..
				"list[current_name;drill;4,1;1,1;]"..
				"list[current_name;scanner;4,3;1,1;]")
		local inv = meta:get_inventory()
		local drill = inv:get_stack("drill",1)
		if drill:is_empty() then
			miner.pull_pipes(pos)
			return
		end
		local pipe = inv:get_stack("pipe",1)
		if pipe:is_empty() then return end
		local e = 0
		local scanner = inv:get_stack("scanner",1)
		local radius
		if scanner:get_name() == "voltbuild:od_scanner" then
			radius = 2
			e = e + 40
		elseif scanner:get_name() == "voltbuild:ov_scanner" then
			radius = 4
			e = e + 60
		else
			radius = 0
		end
		local optime = minetest.registered_nodes["voltbuild:miner"]["voltbuild"]["optime"](pos)
		local stime = meta:get_int("stime")
		meta:set_int("stime",stime+1)
		local energy = meta:get_int("energy")
		if optime and stime >= optime then
			local energy = meta:get_int("energy")
			if optime == 1 then 
				e = e + 60
			else
				e = e + 40
			end
			meta:set_int("stime",0)
			if energy < e then
				meta:set_int("stime",stime)
				return
			end

			local tpos = miner.current_pos(pos,{})
			local name = minetest.env:get_node(tpos).name
			if name == "voltbuild:mining_pipe" then
				if name == "ignore" then
					meta:set_int("stime",stime)
					miner.pull_pipes(pos)
					return
				else
					local groups = minetest.registered_nodes[name]["groups"] 
					if groups and groups.liquid and groups.liquid >= 1 then
						meta:set_int("stime",stime)
						miner.pull_pipes(pos)
						return
					end
				end
				todig=miner.dig_towards_ore(tpos,radius)
				--after todig
				if todig.x ~= pos.x and todig.y ~= pos.y and todig.z ~= pos.z then
					if tpos.x ~= todig.x then
						if tpos.x >todig.x then
							tpos.x = tpos.x-1
						else
							tpos.x = tpos.x+1
						end
					else 
						if tpos.z >todig.z then
							tpos.z = tpos.z-1
						else
							tpos.z = tpos.z+1
						end
					end
					local tname = minetest.env:get_node(tpos).name
					local itemstacks = minetest.get_node_drops(tname,"default:pick_mese")
					for _, item in ipairs(itemstacks) do
						miner.eject_item(pos,item)
					end
					minetest.env:set_node(tpos,{name = "voltbuild:mining_pipe"})
					pipe:take_item()
					inv:set_stack("pipe",1,pipe)
					if tpos.x == todig.x and tpos.y == todig.y and tpos.z == todig.z then
						miner.pull_pipes(pos)
					end
				else
					tpos.y = tpos.y-1
					local tname = minetest.env:get_node(tpos).name
					local itemstacks = minetest.get_node_drops(tname,"default:pick_mese")
					for _, item in ipairs(itemstacks) do
						miner.eject_item(pos,item)
					end
					minetest.env:set_node(tpos,{name = "voltbuild:mining_pipe"})
					pipe:take_item()
					inv:set_stack("pipe",1,pipe)
				end
			else
				tpos.y = tpos.y-1
				local tname = minetest.env:get_node(tpos).name
				local itemstacks = minetest.get_node_drops(tname,"default:pick_mese")
				for _, item in ipairs(itemstacks) do
					miner.eject_item(pos,item)
				end
				minetest.env:set_node(tpos,{name = "voltbuild:mining_pipe"})
				pipe:take_item()
				inv:set_stack("pipe",1,pipe)
			end
			
		end
		meta:set_int("energy",energy-e)
		meta:set_string("formspec",consumers.get_formspec(pos)..
				"list[current_name;pipe;2,1;1,1;]"..
				"list[current_name;drill;4,1;1,1;]"..
				"list[current_name;scanner;4,3;1,1;]")
	end,
})

voltbuild.register_ore("default:stone_with_coal", 1)
voltbuild.register_ore("default:stone_with_iron", 2)
voltbuild.register_ore("default:stone_with_mese", 5)
voltbuild.register_ore("default:stone_with_gold", 4)
voltbuild.register_ore("default:stone_with_diamond", 5)
voltbuild.register_ore("default:mese", 216)
voltbuild.register_ore("default:stone_with_copper", 3)
voltbuild.register_ore("voltbuild:stone_with_tin", 2)
voltbuild.register_ore("voltbuild:stone_with_uranium", 4)

voltbuild.register_ore("voltbuild:sand_with_alunra", 3)
voltbuild.register_ore("voltbuild:water_source_with_ignis", 4)

voltbuild.register_ore("moreores:mineral_tin", 2)
voltbuild.register_ore("moreores:mineral_copper", 3)
voltbuild.register_ore("moreores:mineral_gold", 4)
voltbuild.register_ore("moreores:mineral_mithril", 5)

voltbuild.register_ore("technic:mineral_uranium", 4)
voltbuild.register_ore("technic:mineral_chromium", 4)
voltbuild.register_ore("technic:mineral_zinc", 2)

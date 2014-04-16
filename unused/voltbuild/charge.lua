charge = {}

function charge.set_wear(stack,charge,max_charge)
	local n = 65536 - math.floor(charge/max_charge*65535)
	stack.wear = n
end

function charge.get_charge(stack)
	if tonumber(stack.metadata) == nil then return 0 end
	return tonumber(stack.metadata)
end

function charge.set_charge(stack,charge)
	stack.metadata = tostring(charge)
	if minetest.registered_items[stack.name] and minetest.registered_items[stack.name].voltbuild and minetest.registered_items[stack.name].voltbuild.cnames then
		local cn = minetest.registered_items[stack.name].voltbuild.cnames
		local m = -1
		local n = stack.name
		for _,i in ipairs(cn) do
			if i[1] <= charge and i[1] > m then
				m = i[1]
				n = i[2]
			end
		end
		stack.name = n
	end
end

function charge.single_use(stack)
	return get_item_field(stack:get_name(),"single_use")>0
end

minetest.register_tool("voltbuild:re_battery",{
	description = "RE Battery",
	inventory_image = "itest_re_battery.png",
	voltbuild = {max_charge = 240,
		max_speed = 100,
		charge_tier = 1},
	documentation = {summary="Stores energy and can be placed into a machine to charge the machine."},
	tool_capabilities =
		{max_drop_level=0,
		groupcaps={fleshy={times={}, uses=1, maxlevel=0}}}
})

minetest.register_tool("voltbuild:solar_battery",{
	description = "Solar Battery",
	inventory_image = "voltbuild_solar_battery.png",
	voltbuild = {max_charge = 240,
		max_speed = 60,
		charge_tier = 1},
	documentation = {summary="Solar powered version of RE Battery.\n"..
		" It slowly generates energy in the sun while in your inventory."},
	tool_capabilities =
		{max_drop_level=0,
		groupcaps={fleshy={times={}, uses=1, maxlevel=0}},solar=2}
})

local solar_players = {}
voltbuild.solar_charge = function (player)
	if solar_players[player] then
		local inv = player:get_inventory()
		local i
		local solar_items = {}
		for i=1,inv:get_size("main") do
			local stack = inv:get_stack("main",i)
			local stack_def = minetest.registered_items[stack:get_name()]
			if stack_def and
				stack_def.tool_capabilities and
				stack_def.tool_capabilities.solar and
				stack:get_count() == 1 then
				table.insert(solar_items,i)
			end
		end
		local light = minetest.env:get_node_light(player:getpos())
		if light and light >= 15 then
			for _,i in pairs(solar_items) do
				local stack = inv:get_stack("main",i)
				local stack_data = stack:to_table()
				local max_charge = get_item_field(stack:get_name(), "max_charge")
				local max_speed = get_item_field(stack:get_name(), "max_speed")
				local c = charge.get_charge(stack_data)
				charge.set_charge(stack_data,math.min(c+1,max_charge))
				charge.set_wear(stack_data,math.min(c+1,max_charge),max_charge)
				inv:set_stack("main",i,ItemStack(stack_data))
			end
		end
		minetest.after(2,voltbuild.solar_charge,player)
	end
end

minetest.register_on_joinplayer(function(player)
	minetest.after(2,voltbuild.solar_charge,player)
	solar_players[player] = 0
end)

--to prevent a server crash from the minetest.after loop
minetest.register_on_leaveplayer(function(player)
	solar_players[player] = nil
end)

minetest.register_tool("voltbuild:energy_crystal",{
	description = "Energy crystal",
	inventory_image = "itest_energy_crystal.png",
	voltbuild = {max_charge = 10000,
		max_speed = 250,
		charge_tier = 2},
	documentation = {summary="Medium voltage RE Battery."},
	tool_capabilities =
		{max_drop_level=0,
		groupcaps={fleshy={times={}, uses=1, maxlevel=0}}}
}) 

minetest.register_tool("voltbuild:lapotron_crystal",{
	description = "Lapotron crystal",
	inventory_image = "itest_lapotron_crystal.png",
	voltbuild = {max_charge = 100000,
		max_speed = 600,
		charge_tier = 3},
	documentation = {summary="High voltage RE Battery."},
	tool_capabilities =
		{max_drop_level=0,
		groupcaps={fleshy={times={}, uses=1, maxlevel=0}}}
}) 

minetest.register_craftitem("voltbuild:single_use_battery",{
	description = "Single use battery",
	inventory_image = "itest_single_use_battery.png",
	voltbuild = {single_use = 1,
		singleuse_energy = 12,
		charge_tier = 1},
	documentation = {summary="Single time charge of a machine.\n"..
		"Think of it like coal for a furnace, except it's for electric machines and unneccessary."},
})

local drill_properties = {
	description = "Mining drill",
	inventory_image = "voltbuild_mining_drill.png",
	voltbuild = {max_charge = 180,
		max_speed = 5,
		charge_tier = 1,
		cnames = {{0,"voltbuild:mining_drill_discharged"},
			{1,"voltbuild:mining_drill"}}},
	documentation = {summary="The electric alternative to the pick."},
	tool_capabilities =
		{max_drop_level=0,
		-- Uses are specified, but not used since there is a after_use function
		groupcaps={cracky = {times={[1]=4.00, [2]=1.60, [3]=0.80}, uses=22, maxlevel=2}}},
	after_use = function (itemstack, user, pointed_thing)
		local stack = itemstack:to_table()
		local chr = charge.get_charge(stack)
		local max_charge = get_item_field(stack.name, "max_charge")
		nchr = math.max(0,chr-1)
		charge.set_charge(stack,nchr)
		charge.set_wear(stack,nchr,max_charge)
		return ItemStack(stack)
	end
}
minetest.register_tool("voltbuild:mining_drill",drill_properties)
discharged_drill = voltbuild.deep_copy(drill_properties,{})
discharged_drill.after_use=nil
discharged_drill.tool_capabilities = {max_drop_level=0,groupcaps={}}
minetest.register_tool("voltbuild:mining_drill_discharged",discharged_drill)

local diamond_drill = {
	description = "Diamond drill",
	inventory_image = "voltbuild_diamond_drill.png",
	voltbuild = {max_charge = 240,
		max_speed = 10,
		charge_tier = 1,
		cnames = {{0,"voltbuild:diamond_drill_discharged"},
			{2,"voltbuild:diamond_drill"}}},
	documentation = {summary="A faster mining drill with less durability."},
	tool_capabilities =
		{max_drop_level=0,
		-- Uses are specified, but not used since there is a after_use function
		groupcaps={cracky = {times={[1]=2.0, [2]=1.0, [3]=0.50}, uses=4, maxlevel=3}}},
	after_use = function (itemstack, user, pointed_thing)
		local stack = itemstack:to_table()
		local chr = charge.get_charge(stack)
		local max_charge = get_item_field(stack.name, "max_charge")
		nchr = math.max(0,chr-2)
		charge.set_charge(stack,nchr)
		charge.set_wear(stack,nchr,max_charge)
		return ItemStack(stack)
	end
}
minetest.register_tool("voltbuild:diamond_drill",diamond_drill)
discharged_diamond_drill = voltbuild.deep_copy(diamond_drill,{})
discharged_diamond_drill.after_use=nil
discharged_diamond_drill.tool_capabilities = {max_drop_level=0,groupcaps={}}
minetest.register_tool("voltbuild:diamond_drill_discharged",discharged_diamond_drill)


minetest.register_tool("voltbuild:od_scanner",{
	description = "OD Scanner",
	inventory_image = "voltbuild_od_scanner.png",
	voltbuild = {max_charge = 360,
		max_speed = 10,
		charge_tier = 1},
	documentation = {summary="Notifies the player of the number of ores in an area by right clicking."},
	tool_capabilities =
		{max_drop_level=0,
		groupcaps={}},
	on_place = function(itemstack, user, pointed_thing)
		local stack = itemstack:to_table()
		if charge.get_charge(stack) < 2 then return itemstack end -- Not enough energy
		local chr = charge.get_charge(stack)
		local max_charge = get_item_field(stack.name, "max_charge")
		charge.set_charge(stack, chr - 2)
		charge.set_wear(stack, chr - 2, max_charge)
		local pos = user:getpos()
		local y = 0
		local nnodes = 0
		local total_ores = 0
		local shall_break = false
		while true do
			for x = -2, 2 do
			for z = -2, 2 do
				local npos = {x=pos.x+x, y=pos.y+y, z=pos.z+z}
				local nnode = minetest.env:get_node(npos)
				if nnode.name == "ignore" then
					shall_break = true
				else
					nnodes = nnodes + 1 -- Number of nodes scanned
					if voltbuild.registered_ores[nnode.name] then
						total_ores = total_ores + 1
					end
				end
			end
			end
			if shall_break then break end
			y = y - 1 -- Look the next level down
		end
		minetest.chat_send_player(user:get_player_name(), "Ore density: "..math.floor(total_ores / nnodes * 1000), false)
		return ItemStack(stack)
	end
})

minetest.register_tool("voltbuild:ov_scanner",{
	description = "OV Scanner",
	inventory_image = "voltbuild_ov_scanner.png",
	voltbuild = {max_charge = 480,
		max_speed = 20,
		charge_tier = 1},
	documentation = {summary="Notifies the player of the value of ores in an area by right clicking."},
	tool_capabilities =
		{max_drop_level=0,
		groupcaps={}},
	on_place = function(itemstack, user, pointed_thing)
		local stack = itemstack:to_table()
		if charge.get_charge(stack) < 4 then return itemstack end -- Not enough energy
		local chr = charge.get_charge(stack)
		local max_charge = get_item_field(stack.name, "max_charge")
		charge.set_charge(stack, chr - 4)
		charge.set_wear(stack, chr - 4, max_charge)
		local pos = user:getpos()
		local y = 0
		local nnodes = 0
		local total_value = 0
		local shall_break = false
		while true do
			for x = -4, 4 do
			for z = -4, 4 do
				local npos = {x=pos.x+x, y=pos.y+y, z=pos.z+z}
				local nnode = minetest.env:get_node(npos)
				if nnode.name == "ignore" then
					shall_break = true
				else
					nnodes = nnodes + 1 -- Number of nodes scanned
					if voltbuild.registered_ores[nnode.name] then
						total_value = total_value + voltbuild.registered_ores[nnode.name]
					end
				end
			end
			end
			if shall_break then break end
			y = y - 1 -- Look the next level down
		end
		minetest.chat_send_player(user:get_player_name(), "Ore value: "..math.floor(total_value / nnodes * 1000), false)
		return ItemStack(stack)
	end
})

local teleport_gloves = {
	description = "Teleportation Gloves",
	inventory_image = "voltbuild_teleport_gloves.png",
	voltbuild = {max_charge = 20000,
		max_speed = 100,
		charge_tier = 3,
		cnames = {{0,"voltbuild:teleport_gloves_discharged"},
			{100,"voltbuild:teleport_gloves"}}},
	documentation = {summary="Short range teleportation by right clicking. HV voltage tool.\n"..
		"Requires an MFS Unit to charge it."},
	tool_capabilities =
		{max_drop_level=0,
		groupcaps={}},
	on_place = function(itemstack, user, pointed_thing)
		local cost = 100
		local stack = itemstack:to_table()
		local max_charge = get_item_field(stack.name, "max_charge")
		local chr = charge.get_charge(stack)
		if pointed_thing.type == "node" and chr >= cost then
			local above = vector.add(pointed_thing.under,(vector.new({x=0,y=1,z=0})))
			if minetest.get_node(above).name == "air" then
				user:setpos(above)
				nchr = math.max(0,chr-cost)
				charge.set_charge(stack,nchr)
				charge.set_wear(stack,nchr,max_charge)
				return ItemStack(stack)
			else
				user:moveto(pointed_thing.above)
				nchr = math.max(0,chr-cost)
				charge.set_charge(stack,nchr)
				charge.set_wear(stack,nchr,max_charge)
				return ItemStack(stack)
			end
		end
	end,
}
minetest.register_tool("voltbuild:teleport_gloves",teleport_gloves)
discharged_tgloves = voltbuild.deep_copy(teleport_gloves,{})
discharged_tgloves.after_use=nil
discharged_tgloves.on_place = nil
minetest.register_tool("voltbuild:teleport_gloves_discharged",discharged_tgloves)

-- Add power to mesecons
mcon = clone_node("mesecons:wire_00000000_off")
mcon.voltbuild = {single_use = 1, singleuse_energy = 60}
minetest.register_node(":mesecons:wire_00000000_off",mcon)

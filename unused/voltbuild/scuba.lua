--time in number of ticks
local cell_time = 4

minetest.register_tool("voltbuild:scuba_gear", {
	description = "Scuba Gear",
	inventory_image = "voltbuild_scuba_gear.png",
})
minetest.register_craftitem("voltbuild:air_cell", {
	description = "Air Cell",
	inventory_image = "voltbuild_air_cell.png",
})

local scuba
local cell_ticks = {}
scuba = function (player)
	--to prevent a server crash from the minetest.after loop by making sure it
	--runs only for players actually in the game
	if cell_ticks[player] then
		local inv = player:get_inventory()
		local i, gear_equipped, cells_index
		if player:get_breath() ~= 11 then
			for i=1,inv:get_size("main") do
				local stack = inv:get_stack("main",i)
				if stack:get_name() == "voltbuild:scuba_gear" then
					gear_equipped = true
					if cells_index then
						break
					end
				end
				if stack:get_name() == "voltbuild:air_cell" 
					and not stack:is_empty() then
					cells_index = i
					if gear_equipped then
						break
					end
				end
			end
		end
		if cells_index and gear_equipped then
			cell_ticks[player] = cell_ticks[player]+1
			player:set_breath(10)
			if cell_ticks[player] >=  cell_time then
				local cells = inv:get_stack("main",cells_index)
				cells:take_item()
				inv:set_stack("main",cells_index,cells)
				cell_ticks[player] = cell_ticks[player] - cell_time
			end
		end
		minetest.after(4,scuba,player)
	end
end

minetest.register_on_joinplayer(function(player)
	minetest.after(4,scuba,player)
	cell_ticks[player] = 0
end)

--to prevent a server crash from the minetest.after loop
minetest.register_on_leaveplayer(function(player)
	cell_ticks[player] = nil
end)

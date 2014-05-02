consumers={}
consumers.tube = {
	insert_object=function(pos,node,stack,direction)
		local meta=minetest.env:get_meta(pos)
		local inv=meta:get_inventory()
		return inv:add_item("src",stack)
	end,
	can_insert=function(pos,node,stack,direction)
		local meta=minetest.env:get_meta(pos)
		local inv=meta:get_inventory()
		local cooking_method = minetest.registered_nodes[node.name]["cooking_method"]
		local produced
		if cooking_method then 
			produced = voltbuild.get_craft_result({method = cooking_method,
			width = 1, items = {stack}})
		end
		if produced.items then
			return inv:room_for_item("src",stack)
		end

	end,
	connect_sides={left=1, right=1, back=1, bottom=1, top=1, front=1},
	connects = function (param2)
		return true
	end,
	input_inventory="dst",
}

consumers.discharge = voltbuild.discharge_item


function consumers.get_progressbar(v,mv,bg,fg)
	local percent = v/mv*100
	local bar="image[3,2;2,1;"..bg.."^[lowpart:"..
			percent..":"..fg.."^[transformR270"
	return bar
end

function consumers.on_construct(pos)
	local meta = minetest.env:get_meta(pos)
	local inv = meta:get_inventory()
	inv:set_size("discharge", 1)
	voltbuild.on_construct(pos)
end

consumers.can_dig = voltbuild.can_dig

consumers.inventory = voltbuild.inventory

function consumers.get_formspec(pos)
	formspec = voltbuild.common_spec.. 
	voltbuild.discharge_spec..
	voltbuild.vertical_chargebar_spec(pos)..
	voltbuild.stressbar_spec(pos)
	return formspec
end

dofile(modpath.."/electric_furnace.lua")
dofile(modpath.."/macerator.lua")
dofile(modpath.."/extractor.lua")
dofile(modpath.."/compressor.lua")
dofile(modpath.."/recycler.lua")
dofile(modpath.."/hospital.lua")
dofile(modpath.."/scuba.lua")

dofile(modpath.."/miner.lua")

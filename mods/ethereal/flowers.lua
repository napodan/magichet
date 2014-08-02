
--= Flowers spread over green dirt and prairie dirt

minetest.register_abm({
	nodenames = {"group:flora"},
	neighbors = {"ethereal:green_dirt_top", "ethereal:prairie_dirt"},
	interval = 40,
	chance = 20,
	action = function(pos, node)
		local light = minetest.get_node_light(pos)
		if not light or light < 12 then -- was 13
			return
		end
		
		local pos0 = {x=pos.x-4,y=pos.y-4,z=pos.z-4}
		local pos1 = {x=pos.x+4,y=pos.y+4,z=pos.z+4}
		if #minetest.find_nodes_in_area(pos0, pos1, "group:flora_block") > 0 then
			return
		end
		
		local flowers = minetest.find_nodes_in_area(pos0, pos1, "group:flora")
		if #flowers > 3 then
			return
		end
		
		local seedling = minetest.find_nodes_in_area(pos0, pos1, {"ethereal:green_dirt_top", "ethereal:prairie_dirt"})
		if #seedling > 0 then
			seedling = seedling[math.random(#seedling)]
			seedling.y = seedling.y + 1
			light = minetest.get_node_light(seedling)
			if not light or light < 12 then
				return
			end
			if minetest.get_node(seedling).name == "air" then
				minetest.set_node(seedling, {name=node.name})
			end
		end
	end,
})
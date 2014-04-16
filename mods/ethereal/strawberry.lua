
--= Strawberries

-- Functions to check if soil can sustain seeds

local function place_seed(itemstack, placer, pointed_thing, plantname)
	local pt = pointed_thing
	-- check if pointing at a node
	if not pt then
		return
	end
	if pt.type ~= "node" then
		return
	end
	
	local under = minetest.get_node(pt.under)
	local above = minetest.get_node(pt.above)
	
	-- return if any of the nodes is not registered
	if not minetest.registered_nodes[under.name] then
		return
	end
	if not minetest.registered_nodes[above.name] then
		return
	end
	
	-- check if pointing at the top of the node
	if pt.above.y ~= pt.under.y+1 then
		return
	end
	
	-- check if you can replace the node above the pointed node
	if not minetest.registered_nodes[above.name].buildable_to then
		return
	end

-- check if pointing at soil
	if minetest.get_item_group(under.name, "soil") <= 1 then
		return
	end

minetest.add_node(pt.above, {name=plantname})
	if not minetest.setting_getbool("creative_mode") then
		itemstack:take_item()
	end
	return itemstack
end

-- Strawberry Seeds

minetest.register_craftitem("ethereal:seed_strawberry", {
	description = "Strawberry Seeds",
	inventory_image = "strawberry_seeds.png",
	on_place = function(itemstack, placer, pointed_thing)
		return place_seed(itemstack, placer, pointed_thing, "ethereal:strawberry_1")
	end,
})

-- Picked Strawberry

minetest.register_craftitem("ethereal:strawberry", {
	description = "Strawberry",
	inventory_image = "strawberry.png",
	on_use = minetest.item_eat(1),
})

-- Define growing Strawberries and depending on height, drop different amount of Strawberries and Seeds

for i=1,8 do
	local drop = {
		items = {
			{items = {'ethereal:strawberry 2'},rarity=9-i},
			{items = {'ethereal:strawberry 3'},rarity=27-i*3},
			{items = {'ethereal:seed_strawberry'},rarity=9-i},
			{items = {'ethereal:seed_strawberry 3'},rarity=27-i*3},
		}
	}
	minetest.register_node("ethereal:strawberry_"..i, {
		drawtype = "plantlike",
		tiles = {"strawberry_"..i..".png"},
		paramtype = "light",
		waving = 1,
		walkable = false,
		buildable_to = true,
		is_ground_content = true,
		drop = drop,
		selection_box = {
			type = "fixed",
			fixed = {-0.5, -0.5, -0.5, 0.5, -5/16, 0.5},
		},
		groups = {snappy=3,flammable=2,plant=1,strawberry=i,not_in_creative_inventory=1,attached_node=1},
		sounds = default.node_sound_leaves_defaults(),
	})
end

-- Register Alias for backward compatibility with already generated Ethereal worlds

minetest.register_alias("ethereal:strawberry_bush", "ethereal:strawberry_8")

-- Routine to Grow Strawberry Bush

minetest.register_abm({
	nodenames = {"group:strawberry"},
	neighbors = {"group:soil"},
	interval = 50,
	chance = 3,
	action = function(pos, node)
		-- return if already full grown
		if minetest.get_item_group(node.name, "strawberry") == 8 then
			return
		end
		
		-- check if on wet soil
		pos.y = pos.y-1
		local n = minetest.get_node(pos)
		if minetest.get_item_group(n.name, "soil") < 3 then
			return
		end
		pos.y = pos.y+1
		
		-- check light
		if not minetest.get_node_light(pos) then
			return
		end
		if minetest.get_node_light(pos) < 13 then
			return
		end
		
		-- grow
		local height = minetest.get_item_group(node.name, "strawberry") + 1
		minetest.set_node(pos, {name="ethereal:strawberry_"..height})
	end
})
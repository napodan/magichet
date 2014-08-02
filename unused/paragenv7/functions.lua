-- Functions

-- Jungletree

function paragenv7_jtree(pos)
	local t = 12 + math.random(5) -- trunk height
	for j = -3, t do
		if j == math.floor(t * 0.7) or j == t then
			for i = -2, 2 do
			for k = -2, 2 do
				local absi = math.abs(i)
				local absk = math.abs(k)
				if math.random() > (absi + absk) / 24 then
					minetest.add_node({x=pos.x+i,y=pos.y+j+math.random(0, 1),z=pos.z+k},{name="paragenv7:jleaf"})
				end
			end
			end
		end
		minetest.add_node({x=pos.x,y=pos.y+j,z=pos.z},{name="default:jungletree"})
	end
end

-- Savanna tree

function paragenv7_stree(pos)
	local t = 4 + math.random(3) -- trunk height
	for j = -2, t do
		if j == t then
			for i = -3, 3 do
			for k = -3, 3 do
				local absi = math.abs(i)
				local absk = math.abs(k)
				if math.random() > (absi + absk) / 24 then
					minetest.add_node({x=pos.x+i,y=pos.y+j+math.random(0, 1),z=pos.z+k},{name="paragenv7:sleaf"})
				end
			end
			end
		end
		minetest.add_node({x=pos.x,y=pos.y+j,z=pos.z},{name="default:tree"})
	end
end

-- Pine tree

function paragenv7_ptree(pos)
	local t = 10 + math.random(3) -- trunk height
	for i = -2, 2 do
	for k = -2, 2 do
		local absi = math.abs(i)
		local absk = math.abs(k)
		if absi >= absk then
			j = t - absi
		else
			j = t - absk
		end
		if math.random() > (absi + absk) / 24 then
			minetest.add_node({x=pos.x+i,y=pos.y+j+2,z=pos.z+k},{name="default:snow"})
			minetest.add_node({x=pos.x+i,y=pos.y+j+1,z=pos.z+k},{name="paragenv7:pleaf"})
			minetest.add_node({x=pos.x+i,y=pos.y+j-1,z=pos.z+k},{name="default:snow"})
			minetest.add_node({x=pos.x+i,y=pos.y+j-2,z=pos.z+k},{name="paragenv7:pleaf"})
			minetest.add_node({x=pos.x+i,y=pos.y+j-4,z=pos.z+k},{name="default:snow"})
			minetest.add_node({x=pos.x+i,y=pos.y+j-5,z=pos.z+k},{name="paragenv7:pleaf"})
		end
	end
	end
	for j = -3, t do
		minetest.add_node({x=pos.x,y=pos.y+j,z=pos.z},{name="default:tree"})
	end
end

-- Apple tree

function paragenv7_atree(pos)
	local t = 4 + math.random(2) -- trunk height
	for j = -2, t do
		if j == t or j == t - 2 then
			for i = -2, 2 do
			for k = -2, 2 do
				local absi = math.abs(i)
				local absk = math.abs(k)
				if math.random() > (absi + absk) / 24 then
					minetest.add_node({x=pos.x+i,y=pos.y+j+math.random(0, 1),z=pos.z+k},{name="default:leaves"})
				end
			end
			end
		end
		minetest.add_node({x=pos.x,y=pos.y+j,z=pos.z},{name="default:tree"})
	end
end

-- ABMs

-- Pine sapling

minetest.register_abm({
    nodenames = {"paragenv7:psapling"},
    interval = PININT,
    chance = PINCHA,
    action = function(pos, node, active_object_count, active_object_count_wider)
		paragenv7_ptree(pos)
		print ("[paragenv7] Pine sapling grows")
    end
})

-- Jungletree sapling

minetest.register_abm({
    nodenames = {"paragenv7:jsapling"},
    interval = JUNINT,
    chance = JUNCHA,
    action = function(pos, node, active_object_count, active_object_count_wider)
		paragenv7_jtree(pos)
		print ("[paragenv7] Jungletree sapling grows")
    end,
})

-- Savanna tree sapling

minetest.register_abm({
    nodenames = {"paragenv7:ssapling"},
    interval = SAVINT,
    chance = SAVCHA,
    action = function(pos, node, active_object_count, active_object_count_wider)
		paragenv7_stree(pos)
		print ("[paragenv7] Savanna tree sapling grows")
    end,
})
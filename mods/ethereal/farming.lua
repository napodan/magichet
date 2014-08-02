
math.randomseed(os.time())
math.random()

-- this one was taken from the sapling.lua sapling ABM
local fertilize = function(itemstack, placer, pointed_thing)
            local pos = pointed_thing.under
            local node = minetest.get_node({x=pos.x, y=pos.y, z=pos.z})
            local node_under =  minetest.get_node({x=pos.x, y=pos.y-1, z=pos.z}).name;

            -- Check if Sapling is growing on correct substrate
            if (node.name == "ethereal:yellow_tree_sapling" and node_under == "default:dirt_with_snow") then
                ethereal.centre_place ( pos, {x=4,y=0,z=4}, {x=9,y=19,z=9}, "yellowtree"); return
            elseif (node.name == "ethereal:tree_sapling" and node_under == "ethereal:green_dirt_top") then
                ethereal.centre_place ( pos, {x=2,y=0,z=2}, {x=5,y=7,z=5}, "tree"); return
            elseif (node.name == "ethereal:jungle_tree_sapling" and node_under == "ethereal:jungle_dirt") then
                ethereal.centre_place ( pos, {x=6,y=0,z=3}, {x=13,y=19,z=7}, "jungletree"); return
            elseif (node.name == "ethereal:pine_tree_sapling" and node_under == "ethereal:cold_dirt") then
                ethereal.centre_place ( pos, {x=3,y=1,z=3}, {x=7,y=8,z=7}, "pinetree"); return
            elseif (node.name == "ethereal:big_tree_sapling" and node_under == "ethereal:green_dirt_top") then
                ethereal.centre_place ( pos, {x=4,y=0,z=3}, {x=9,y=8,z=9}, "bigtree"); return
            elseif (node.name == "ethereal:banana_tree_sapling" and node_under == "ethereal:grove_dirt") then
                ethereal.centre_place ( pos, {x=2,y=0,z=2}, {x=7,y=8,z=7}, "bananatree"); return
            elseif (node.name == "ethereal:frost_tree_sapling" and node_under == "ethereal:crystal_topped_dirt") then
                ethereal.centre_place ( pos, {x=3,y=0,z=3}, {x=8,y=20,z=8}, "frosttrees"); return
            elseif (node.name == "ethereal:gray_tree_sapling" and node_under == "ethereal:gray_dirt_top") then
                ethereal.centre_place ( pos, {x=2,y=0,z=2}, {x=5,y=8,z=5}, "graytrees"); return
            elseif (node.name == "ethereal:mushroom_sapling" and node_under == "ethereal:mushroom_dirt") then
                ethereal.centre_place ( pos, {x=3,y=0,z=3}, {x=8,y=12,z=9}, "mushroomone"); return
            elseif (node.name == "ethereal:palm_sapling" and node_under == "default:sand") then
                ethereal.centre_place ( pos, {x=3,y=0,z=4}, {x=7,y=10,z=7}, "palmtree"); return
            end

            itemstack:take_item()
            try_to_grow_cheating(pos,node)
            return itemstack
end


		
if minetest.registered_items['farming:fertilizer'] then
   -- redefine that fertilizer
   local test=minetest.registered_items['farming:fertilizer'].on_place
   minetest.register_craftitem(':farming:fertilizer', {
       description = 'Fertilizer X',
       inventory_image = 'ethereal_fertilizer.png',
       on_place = fertilize,
       }
   )
else
   -- make a new one
   minetest.register_craftitem('ethereal:fertilizer', {
       description = 'Fertilizer X',
       inventory_image = 'ethereal_fertilizer.png',
       on_place = fertilize,       
	   }
   )
end

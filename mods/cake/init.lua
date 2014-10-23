minetest.register_craft({
	output = "cake:cake_full",
	recipe = {
		{'4items:milk', '4items:milk', '4items:milk'},
		{'default:sugar', '4items:egg', 'default:sugar'},
		{'farming:wheat', 'farming:wheat', 'farming:wheat'},
	},
	replacements = {{'4items:milk',"bucket:bucket_empty"},{'4items:milk',"bucket:bucket_empty"},{'4items:milk',"bucket:bucket_empty"}},
})

minetest.register_node("cake:cake_full", {
	description = "Cake",
	tiles = {"cake_top.png","cake_bottom.png","cake_side.png","cake_side.png","cake_side.png","cake_side.png"},
	paramtype = "light",
    inventory_image = "cake_cake.png",
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {-7/16,-0.5,-7/16, 7/16, -1/16, 7/16}
		},
	is_ground_content = false,
	stack_max = 1,
	groups = {dig_immediate=1,falling_node=1},
	drop = "cake:cake_full",
	on_rightclick = function(pos, node, clicker, itemstack)
            local pll = clicker:get_player_name()
            if food_level[pll] then
               if food_level[pll]+2<=max_drumsticks then
                  food_level[pll]=food_level[pll]+2
               else
                  food_level[pll]=max_drumsticks
               end
            else
               food_level[pll]=max_drumsticks
            end

            if food_saturation[pll] then
               if food_saturation[pll]+0.4<=food_level[pll]
               then                     
                  food_saturation[pll]=food_saturation[pll]+0.4
               else                  
                  food_saturation[pll]=food_level[pll]
               end
            else
               food_saturation[pll]=food_points
            end
            minetest.set_node(pos,{name='cake:cake5'},2)
	end,
})

minetest.register_node("cake:cake5", {
	description = "Cake",
	tiles = {"cake_top.png","cake_bottom.png","cake_side.png","cake_side.png","cake_inner.png","cake_side.png"},
	paramtype = "light",
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {-7/16,-0.5,-7/16, 7/16, -1/16, 7/16 - 0.14583}
		},
	is_ground_content = false,
	stack_max = 1,
	groups = {dig_immediate=2,falling_node=1,not_in_creative_inventory=1},
	drop = '',
	on_rightclick = function(pos, node, clicker, itemstack)
            local pll = clicker:get_player_name()
            if food_level[pll] then
               if food_level[pll]+2<=max_drumsticks then
                  food_level[pll]=food_level[pll]+2
               else
                  food_level[pll]=max_drumsticks
               end
            else
               food_level[pll]=max_drumsticks
            end

            if food_saturation[pll] then
               if food_saturation[pll]+0.4<=food_level[pll]
               then                     
                  food_saturation[pll]=food_saturation[pll]+0.4
               else                  
                  food_saturation[pll]=food_level[pll]
               end
            else
               food_saturation[pll]=food_points
            end
            minetest.set_node(pos,{name='cake:cake4'},2)
	end,
})

minetest.register_node("cake:cake4", {
	description = "Cake",
	tiles = {"cake_top.png","cake_bottom.png","cake_side.png","cake_side.png","cake_inner.png","cake_side.png"},
	paramtype = "light",
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {-7/16,-0.5,-7/16, 7/16, -1/16, 7/16 - 0.14583*2}
		},
	is_ground_content = false,
	stack_max = 1,
	groups = {dig_immediate=2,falling_node=1,not_in_creative_inventory=1},
	drop = '',
	on_rightclick = function(pos, node, clicker, itemstack)
            local pll = clicker:get_player_name()
            if food_level[pll] then
               if food_level[pll]+2<=max_drumsticks then
                  food_level[pll]=food_level[pll]+2
               else
                  food_level[pll]=max_drumsticks
               end
            else
               food_level[pll]=max_drumsticks
            end

            if food_saturation[pll] then
               if food_saturation[pll]+0.4<=food_level[pll]
               then                     
                  food_saturation[pll]=food_saturation[pll]+0.4
               else                  
                  food_saturation[pll]=food_level[pll]
               end
            else
               food_saturation[pll]=food_points
            end
            minetest.set_node(pos,{name='cake:cake3'},2)
	end,
})

minetest.register_node("cake:cake3", {
	description = "Cake",
	tiles = {"cake_top.png","cake_bottom.png","cake_side.png","cake_side.png","cake_inner.png","cake_side.png"},
	paramtype = "light",
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {-7/16,-0.5,-7/16, 7/16, -1/16, 0}
		},
	is_ground_content = false,
	stack_max = 1,
	groups = {dig_immediate=2,falling_node=1,not_in_creative_inventory=1},
	drop = '',
	on_rightclick = function(pos, node, clicker, itemstack)
            local pll = clicker:get_player_name()
            if food_level[pll] then
               if food_level[pll]+2<=max_drumsticks then
                  food_level[pll]=food_level[pll]+2
               else
                  food_level[pll]=max_drumsticks
               end
            else
               food_level[pll]=max_drumsticks
            end

            if food_saturation[pll] then
               if food_saturation[pll]+0.4<=food_level[pll]
               then                     
                  food_saturation[pll]=food_saturation[pll]+0.4
               else                  
                  food_saturation[pll]=food_level[pll]
               end
            else
               food_saturation[pll]=food_points
            end
            minetest.set_node(pos,{name='cake:cake2'},2)
	end,
})

minetest.register_node("cake:cake2", {
	description = "Cake",
	tiles = {"cake_top.png","cake_bottom.png","cake_side.png","cake_side.png","cake_inner.png","cake_side.png"},
	paramtype = "light",
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {-7/16,-0.5,-7/16, 7/16, -1/16, 7/16 - 0.14583*4}
		},
	is_ground_content = false,
	stack_max = 1,
	groups = {dig_immediate=2,falling_node=1,not_in_creative_inventory=1},
	drop = '',
	on_rightclick = function(pos, node, clicker, itemstack)
            local pll = clicker:get_player_name()
            if food_level[pll] then
               if food_level[pll]+2<=max_drumsticks then
                  food_level[pll]=food_level[pll]+2
               else
                  food_level[pll]=max_drumsticks
               end
            else
               food_level[pll]=max_drumsticks
            end

            if food_saturation[pll] then
               if food_saturation[pll]+0.4<=food_level[pll]
               then                     
                  food_saturation[pll]=food_saturation[pll]+0.4
               else                  
                  food_saturation[pll]=food_level[pll]
               end
            else
               food_saturation[pll]=food_points
            end
            minetest.set_node(pos,{name='cake:cake1'},2)
	end,
})

minetest.register_node("cake:cake1", {
	description = "Cake",
	tiles = {"cake_top.png","cake_bottom.png","cake_side.png","cake_side.png","cake_inner.png","cake_side.png"},
	paramtype = "light",
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {-7/16,-0.5,-7/16, 7/16, -1/16, 7/16 - 0.14583*5}
		},
	is_ground_content = false,
	stack_max = 1,
	groups = {dig_immediate=2,falling_node=1,not_in_creative_inventory=1},
	drop = '',
	on_rightclick = function(pos, node, clicker, itemstack)
            local pll = clicker:get_player_name()
            if food_level[pll] then
               if food_level[pll]+2<=max_drumsticks then
                  food_level[pll]=food_level[pll]+2
               else
                  food_level[pll]=max_drumsticks
               end
            else
               food_level[pll]=max_drumsticks
            end

            if food_saturation[pll] then
               if food_saturation[pll]+0.4<=food_level[pll]
               then                     
                  food_saturation[pll]=food_saturation[pll]+0.4
               else                  
                  food_saturation[pll]=food_level[pll]
               end
            else
               food_saturation[pll]=food_points
            end
            minetest.remove_node(pos)
	end,
})

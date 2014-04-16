minetest.register_node("chests_0gb_us:wifi", {
	description = "Wifi Chest",
	tiles = {"chests.0gb.us_wifi_top.png", "chests.0gb.us_wifi_top.png", "chests.0gb.us_wifi_side.png",
		"chests.0gb.us_wifi_side.png", "chests.0gb.us_wifi_side.png",
{name="chests.0gb.us_wifi_front_animated.png", animation={type="vertical_frames", aspect_w=16, aspect_h=16, length=2.0}}
},
	paramtype2 = "facedir",
	groups = {snappy=2,choppy=2,oddly_breakable_by_hand=2},
	legacy_facedir_simple = true,
	sounds = default.node_sound_wood_defaults(),
	on_construct = function(pos)
		local meta = minetest.env:get_meta(pos)
		meta:set_string("formspec",
				"size[9,9]"..
				"list[current_player;chests_0gb_us:wifi;0,0;9,4;]"..
				"list[current_player;main;0,5;9,3;9]"..
                "list[current_player;main;0,8.5;9,1;]")
		meta:set_string("infotext", "Беспроводной Сундук")
	end,
	on_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
		minetest.log("action", player:get_player_name()..
				" что-то поменял местами в беспроводном сундуке в точке "..minetest.pos_to_string(pos))
	end,
    on_metadata_inventory_put = function(pos, listname, index, stack, player)
		minetest.log("action", player:get_player_name()..
				" что-то положил в беспроводной сундук в точке "..minetest.pos_to_string(pos))
	end,
    on_metadata_inventory_take = function(pos, listname, index, stack, player)
		minetest.log("action", player:get_player_name()..
				" что-то забрал из беспроводного сундука в точке "..minetest.pos_to_string(pos))
	end,
})

minetest.register_craft({
	output = 'chests_0gb_us:wifi',
	recipe = {
		{'default:wood','default:mese','default:wood'},
		{'default:wood','default:steel_ingot','default:wood'},
		{'default:wood','default:wood','default:wood'}
	}
})

minetest.register_on_joinplayer(function(player)
	local inv = player:get_inventory()
	inv:set_size("chests_0gb_us:wifi", 9*4)
end)


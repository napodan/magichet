local function has_locked_chest_privilege(meta, player)
	local name = player:get_player_name()
	local shared = " "..meta:get_string("shared").." "
	if name == meta:get_string("owner") then
		return true
	elseif shared:find(" "..name.." ") then

		return true
	else
		return false
	end
end

local function formspec(string)
	return "size[9,11]"..
		"list[current_name;main;0,0;9,4;]"..
		"list[current_player;main;0,5;9,3;9]"..
		"list[current_player;main;0,8.5;9,1;]"..
		"field[.25,10.5;6,1;shared;Имена тех, кому можно лезть в этот сундук (через пробел):;"..string.."]"..
		"button[6,10.2;2,1;submit;Сохранить]"
end

minetest.register_node("chests_0gb_us:shared", {
	description = "Shared Chest",
	tiles = {"default_chest_top.png", "default_chest_top.png", "default_chest_side.png",
		"default_chest_side.png", "default_chest_side.png", "chests.0gb.us_shared_front.png"},
	paramtype2 = "facedir",
	groups = {snappy=2,choppy=2,oddly_breakable_by_hand=2},
	legacy_facedir_simple = true,
	sounds = default.node_sound_wood_defaults(),
	after_place_node = function(pos, placer)
		local meta = minetest.env:get_meta(pos)
		meta:set_string("owner", placer:get_player_name() or "")
		meta:set_string("infotext", "Общий сундук (владелец - "..
				meta:get_string("owner")..")")
	end,
	on_construct = function(pos)
		local meta = minetest.env:get_meta(pos)
		meta:set_string("formspec", formspec(""))
		meta:set_string("infotext", "Общий сундук")
		meta:set_string("owner", "")
		local inv = meta:get_inventory()
		inv:set_size("main", 9*4)
	end,
	can_dig = function(pos,player)
		local meta = minetest.env:get_meta(pos);
		local inv = meta:get_inventory()
		return inv:is_empty("main")
	end,
	allow_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
		local meta = minetest.env:get_meta(pos)
		if not has_locked_chest_privilege(meta, player) then
			minetest.log("action", player:get_player_name()..
					" пытался переложить что-то в общем сундуке, владельцем которго является "..
					meta:get_string("owner").." в точке "..
					minetest.pos_to_string(pos))
			return 0
		end
		return count
	end,
    allow_metadata_inventory_put = function(pos, listname, index, stack, player)
		local meta = minetest.env:get_meta(pos)
		if not has_locked_chest_privilege(meta, player) then
			minetest.log("action", player:get_player_name()..
					" пытался положить что-то в общий сундук, владельцем которго является "..
					meta:get_string("owner").." в точке "..
					minetest.pos_to_string(pos))
			return 0
		end
		return stack:get_count()
	end,
    allow_metadata_inventory_take = function(pos, listname, index, stack, player)
		local meta = minetest.env:get_meta(pos)
		if not has_locked_chest_privilege(meta, player) then
			minetest.log("action", player:get_player_name()..
					" пытался забрать что-то из общего сундука, владельцем которго является "..
					meta:get_string("owner").." в точке "..
					minetest.pos_to_string(pos))
			return 0
		end
		return stack:get_count()
	end,
	on_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
		minetest.log("action", player:get_player_name()..
				" переложил что-то в общем сундуке в точке "..minetest.pos_to_string(pos))
	end,
    on_metadata_inventory_put = function(pos, listname, index, stack, player)
		minetest.log("action", player:get_player_name()..
				" положил что-то в общщий сундук в точке "..minetest.pos_to_string(pos))
	end,
    on_metadata_inventory_take = function(pos, listname, index, stack, player)
		minetest.log("action", player:get_player_name()..
				" забрал что-то из общего сундука в точке "..minetest.pos_to_string(pos))
	end,
	on_receive_fields = function(pos, formname, fields, sender)
		local meta = minetest.env:get_meta(pos);
		if meta:get_string("owner") == sender:get_player_name() then
			meta:set_string("shared", fields.shared);
			meta:set_string("formspec", formspec(fields.shared))
		end
	end,
})

minetest.register_craft({
	output = 'chests_0gb_us:shared',
	recipe = {
		{'default:wood','default:leaves','default:wood'},
		{'default:wood','default:steel_ingot','default:wood'},
		{'default:wood','default:wood','default:wood'}
	}
})


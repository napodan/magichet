local function has_locked_chest_privilege(meta, player)
	if player:get_player_name() ~= meta:get_string("owner") then
		return false
	end
	return true
end

minetest.register_node("chests_0gb_us:cobble", {
	description = "Cobble Chest",
	tiles = {"default_chest_top.png", "default_chest_top.png", "default_chest_side.png",
		"default_chest_side.png", "default_chest_side.png", "default_cobble.png"},
	paramtype2 = "facedir",
	groups = {snappy=2,choppy=2,oddly_breakable_by_hand=2},
	legacy_facedir_simple = true,
	sounds = default.node_sound_wood_defaults(),
	after_place_node = function(pos, placer)
		local meta = minetest.env:get_meta(pos)
		meta:set_string("owner", placer:get_player_name() or "")
--[[		meta:set_string("infotext", "Locked Chest (owned by "..
				meta:get_string("owner")..")")]]
	end,
	on_construct = function(pos)
		local meta = minetest.env:get_meta(pos)
		meta:set_string("formspec",
				"size[9,9]"..
				"list[current_name;main;0,0;9,4;]"..
				"list[current_player;main;0,5;9,3;9]"..
                "list[current_player;main;0,8.5;9,1;]")
--		meta:set_string("infotext", "Locked Chest")
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
					" ������� ���������� ���-�� � �������� �������, ���������� �������� �������� "..
					meta:get_string("owner").." � ����� "..
					minetest.pos_to_string(pos))
			return 0
		end
		return count
	end,
    allow_metadata_inventory_put = function(pos, listname, index, stack, player)
		local meta = minetest.env:get_meta(pos)
		if not has_locked_chest_privilege(meta, player) then
			minetest.log("action", player:get_player_name()..
					" ������� �������� ���-�� � �������� ������, ���������� �������� �������� "..
					meta:get_string("owner").." � ����� "..
					minetest.pos_to_string(pos))
			return 0
		end
		return stack:get_count()
	end,
    allow_metadata_inventory_take = function(pos, listname, index, stack, player)
		local meta = minetest.env:get_meta(pos)
		if not has_locked_chest_privilege(meta, player) then
			minetest.log("action", player:get_player_name()..
					" ������� ������� ���-�� �� ��������� �������, ���������� �������� �������� "..
					meta:get_string("owner").." � ����� "..
					minetest.pos_to_string(pos))
			return 0
		end
		return stack:get_count()
	end,
	on_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
		minetest.log("action", player:get_player_name()..
				" ��������� ���-�� � �������� ������� � ����� "..minetest.pos_to_string(pos))
	end,
    on_metadata_inventory_put = function(pos, listname, index, stack, player)
		minetest.log("action", player:get_player_name()..
				" ������� ���-�� � �������� ������ � ����� "..minetest.pos_to_string(pos))
	end,
    on_metadata_inventory_take = function(pos, listname, index, stack, player)
		minetest.log("action", player:get_player_name()..
				" ������ ���-�� �� ��������� ������� � ����� "..minetest.pos_to_string(pos))
	end,
})

minetest.register_craft({
	output = 'chests_0gb_us:cobble',
	recipe = {
		{'default:wood','default:cobble','default:wood'},
		{'default:cobble','default:steel_ingot','default:cobble'},
		{'default:wood','default:cobble','default:wood'}
	}
})


function send_alldirs_except(pos,dir,power)
	local meta=minetest.env:get_meta(pos)
	if meta:get_int("energy")<power then return end
	for _,d in ipairs(adjlist) do
		if d.x~=dir.x or d.y~=dir.y or d.z~=dir.z then
			local s=send_packet(pos,d,power)
			if s~= nil then
				meta:set_int("energy",meta:get_int("energy")-power)
				return 1
			end
		end
	end
end

minetest.register_node("voltbuild:lv_transformer",{description="LV Transformer",
	groups={energy=1,cracky=2,energy_consumer=1},
	paramtype2 = "facedir",
	legacy_facedir_simple = true,
	tiles={"itest_lv_transformer_lv.png", "itest_lv_transformer_lv.png", "itest_lv_transformer_mv.png", "itest_lv_transformer_lv.png", "itest_lv_transformer_lv.png", "itest_lv_transformer_lv.png"},
	voltbuild = {max_energy=2560,max_psize=128},
	documentation = {summary = "Low voltage transformer for ramping up or down electricity."},
	on_construct = function(pos)
		local meta = minetest.env:get_meta(pos)
		meta:set_int("energy",0)
		meta:set_int("send_lv",0)
	end,
	mesecons = {effector = {
		action_on = function (pos, node)
			local meta = minetest.env:get_meta(pos)
			meta:set_int("send_lv",1)
		end,
		action_off = function (pos, node)
			local meta = minetest.env:get_meta(pos)
			meta:set_int("send_lv",0)
		end}}
})

minetest.register_abm({
	nodenames={"voltbuild:lv_transformer"},
	interval=1.0,
	chance=1,
	action = function(pos, node, active_object_count, active_objects_wider)
		local senddir = param22dir(node.param2)
		local meta = minetest.env:get_meta(pos)
		if meta:get_int("send_lv") == 0 then
			storage.send(pos,128,senddir)
		else
			send_alldirs_except(pos,senddir,32)
		end
	end
})

minetest.register_node("voltbuild:mv_transformer",{description="MV Transformer",
	groups={energy=1,cracky=2,energy_consumer=1},
	paramtype2 = "facedir",
	legacy_facedir_simple = true,
	tiles={"itest_mv_transformer_mv.png", "itest_mv_transformer_mv.png", "itest_mv_transformer_hv.png", "itest_mv_transformer_mv.png", "itest_mv_transformer_mv.png", "itest_mv_transformer_mv.png"},
	voltbuild = {max_energy=10240,max_psize=512},
	documentation = {summary = "Medium voltage transformer for ramping up or down electricity."},
	on_construct = function(pos)
		local meta = minetest.env:get_meta(pos)
		meta:set_int("energy",0)
		meta:set_int("send_mv",0)
	end,
	mesecons = {effector = {
		action_on = function (pos, node)
			local meta = minetest.env:get_meta(pos)
			meta:set_int("send_mv",1)
		end,
		action_off = function (pos, node)
			local meta = minetest.env:get_meta(pos)
			meta:set_int("send_mv",0)
		end}}
})

minetest.register_abm({
	nodenames={"voltbuild:mv_transformer"},
	interval=1.0,
	chance=1,
	action = function(pos, node, active_object_count, active_objects_wider)
		local senddir = param22dir(node.param2)
		local meta = minetest.env:get_meta(pos)
		if meta:get_int("send_mv") == 0 then
			storage.send(pos,512,senddir)
		else
			send_alldirs_except(pos,senddir,128)
		end
	end
})

minetest.register_node("voltbuild:hv_transformer",{description="HV Transformer",
	groups={energy=1,cracky=2,energy_consumer=1},
	paramtype2 = "facedir",
	legacy_facedir_simple = true,
	tiles={"itest_hv_transformer_hv.png", "itest_hv_transformer_hv.png", "itest_hv_transformer_ev.png", "itest_hv_transformer_hv.png", "itest_hv_transformer_hv.png", "itest_hv_transformer_hv.png"},
	voltbuild = {max_energy=40960,max_psize=1000000000},
	documentation = {summary = "High voltage transformer for ramping up or down electricity.\n"..
		"Only thing capable of handling any size packet of electricity."},
	on_construct = function(pos)
		local meta = minetest.env:get_meta(pos)
		meta:set_int("energy",0)
		meta:set_int("send_hv",0)
	end,
	mesecons = {effector = {
		action_on = function (pos, node)
			local meta = minetest.env:get_meta(pos)
			meta:set_int("send_hv",1)
		end,
		action_off = function (pos, node)
			local meta = minetest.env:get_meta(pos)
			meta:set_int("send_hv",0)
		end}}
})

minetest.register_abm({
	nodenames={"voltbuild:hv_transformer"},
	interval=1.0,
	chance=1,
	action = function(pos, node, active_object_count, active_objects_wider)
		local senddir = param22dir(node.param2)
		local meta = minetest.env:get_meta(pos)
		if meta:get_int("send_hv") == 0 then
			storage.send(pos,2048,senddir)
		else
			send_alldirs_except(pos,senddir,512)
		end
	end
})
	

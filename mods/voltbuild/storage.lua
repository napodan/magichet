storage = {}

function storage.charge(pos)
	local meta = minetest.env:get_meta(pos)
	local energy = meta:get_int("energy")
	meta:set_int("energy",voltbuild.charge_item(pos,energy))
end

storage.discharge = voltbuild.discharge_item

function storage.send(pos,energy,dir)
	local node = minetest.env:get_node(pos)
	local meta = minetest.env:get_meta(pos)
	local e = meta:get_int("energy")
	local packet_size = minetest.registered_nodes[node.name]["voltbuild"]["max_psize"]
	energy = math.min(e,packet_size,energy)
	local sent = send_packet(pos,dir,energy)
	if sent~=nil then
		local meta = minetest.env:get_meta(pos)
		local e = meta:get_int("energy")
		meta:set_int("energy",e-sent)
	end
end

function storage.on_construct(pos)
	local meta = minetest.env:get_meta(pos)
	local inv = meta:get_inventory()
	inv:set_size("charge", 1)
	inv:set_size("discharge", 1)
	voltbuild.on_construct(pos)
end

storage.can_dig = voltbuild.can_dig

function storage.get_formspec(pos)
	formspec = voltbuild.common_spec..
	voltbuild.charge_spec..
	voltbuild.discharge_spec..
	voltbuild.chargebar_spec(pos)..
	voltbuild.stressbar_spec(pos)
	return formspec
end

function storage.energy_release(pos)
	local node = minetest.env:get_node(pos)
	local senddir = param22dir(node.param2)
	local meta = minetest.env:get_meta(pos)
	local e = meta:get_int("energy")
	local packet_size = minetest.registered_nodes[node.name]["voltbuild"]["max_psize"]
	energy = math.min(e,packet_size)
	return energy,e-energy,senddir
end

function storage.abm (pos, node, active_object_count, active_objects_wider)
	local senddir = param22dir(node.param2)
	local meta = minetest.env:get_meta(pos)
	local psize = minetest.registered_nodes[node.name]["voltbuild"]["max_psize"]
	storage.charge(pos)
	storage.send(pos,psize,senddir)
	storage.discharge(pos)
	meta:set_string("formspec",storage.get_formspec(pos))
end

dofile(modpath.."/batboxes.lua")
dofile(modpath.."/transformers.lua")

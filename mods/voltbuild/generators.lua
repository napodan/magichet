generators={}

generators.charge = voltbuild.charge_item


function generators.send(pos,energy)
	local sent = send_packet_alldirs(pos,energy)
	if sent~=nil then
		local meta = minetest.env:get_meta(pos)
		local node = minetest.env:get_node(pos)
		local e = meta:get_int("energy")
		local m = get_node_field(node.name,meta,"max_energy")
		meta:set_int("energy",math.min(m,e+(energy-sent)))
	end
end

function generators.produce(pos,energy)
	if energy <= 0 then return end
	local meta = minetest.env:get_meta(pos)
	local inv = meta:get_inventory();
	local rem = generators.charge(pos,energy)
	if rem > 0 then
		generators.send(pos,rem)
	end
end

function generators.on_construct(pos)
	local meta = minetest.env:get_meta(pos)
	local inv = meta:get_inventory()
	inv:set_size("charge", 1)
	voltbuild.on_construct(pos)
end

generators.can_dig = voltbuild.can_dig

function generators.get_formspec(pos)
	formspec = voltbuild.common_spec..
	voltbuild.charge_spec..
	voltbuild.chargebar_spec(pos)..
	voltbuild.stressbar_spec(pos)
	return formspec
end

dofile(modpath.."/generator.lua")
dofile(modpath.."/solarpanel.lua")
dofile(modpath.."/windmill.lua")
dofile(modpath.."/watermill.lua")
dofile(modpath.."/nuclear_reactor.lua")
dofile(modpath.."/geothermal_generator.lua")

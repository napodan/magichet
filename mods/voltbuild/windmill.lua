wind_speed = math.random(0,7)

minetest.register_node("voltbuild:windmill",{description="Windmill",
	groups={energy=1,cracky=2},
	tiles={"itest_windmill_top.png", "itest_windmill_top.png", "itest_windmill_side.png"},
	documentation = {summary = "Generator that produces more electricity the higher it is.\n"..
		"Minimize the number of nodes anywhere near this generator for best electricity production."},
	voltbuild = {max_energy=15,max_tier=1,max_stress=2000,optime=10.0,energy_type_image= "voltbuild_wind.png", psize = 1,
		speed=function(pos)
			local alt = pos.y/30
			local node = minetest.get_node(pos)
			local optime = minetest.registered_nodes[node.name]["voltbuild"]["optime"]
			return math.min(wind_speed*alt,optime*6)
		end},
	on_construct = function(pos)
		local meta = minetest.env:get_meta(pos)
		meta:set_int("energy",0)
		meta:set_int("energyf",0)
		meta:set_int("obstacles",200)
		meta:set_string("formspec", generators.get_formspec(pos)..
				"image["..voltbuild.image_location.."voltbuild_wind_symbol.png]")
		generators.on_construct(pos)
	end,
	can_dig = generators.can_dig,
	allow_metadata_inventory_put = voltbuild.allow_metadata_inventory_put,
	allow_metadata_inventory_move = voltbuild.allow_metadata_inventory_move,
})

components.register_abm({
	nodenames={"voltbuild:windmill"},
	interval=1.0,
	chance=1,
	action = function(pos, node, active_object_count, active_objects_wider)
		local meta = minetest.env:get_meta(pos)
		local speed = minetest.registered_nodes[node.name]["voltbuild"]["speed"](pos)
		local optime = minetest.registered_nodes[node.name]["voltbuild"]["optime"]
		voltbuild.generation_abm(pos,node,active_object_count, active_objects_wider)
		if speed >= optime*3 then
			local stress = meta:get_int("stress")
			meta:set_int("stress",stress+(math.random(1,optime+10)))
		end
		meta:set_string("formspec",generators.get_formspec(pos)..
				"image["..voltbuild.image_location.."voltbuild_wind_symbol.png]")
	end
})

--counts obstacles around the windmill, so not meant to be run as a components abm
minetest.register_abm({
	nodenames={"voltbuild:windmill"},
	interval=20,
	chance=1,
	action = function(pos, node, active_object_count, active_objects_wider)
		local obstacles = 0
		for x = pos.x-4,pos.x+4 do
		for y = pos.y-2,pos.y+4 do
		for z = pos.z-4,pos.z+4 do
			local n = minetest.env:get_node({x=x,y=y,z=z})
			if n.name ~= "air" and n.name ~= "ignore" then
				obstacles = obstacles + 1
			end
		end
		end
		end
		local meta = minetest.env:get_meta(pos)
		meta:set_int("obstacles",obstacles)
		math.randomseed(os.time())
		wind_speed =  math.random(0,7)
	end
})

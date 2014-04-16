local fuel_spec = voltbuild.fuel_spec

local generator_definition = {
	description = "Generator",
	tiles = {"itest_generator_side.png", "itest_generator_side.png", "itest_generator_side.png",
		"itest_generator_side.png", "itest_generator_side.png", "itest_generator_front.png"},
	paramtype2 = "facedir",
	groups = {energy=1, cracky=2},
	legacy_facedir_simple = true,
	sounds = default.node_sound_stone_defaults(),
	documentation = {summary = "A generator that uses coal to generate electricty.\n"..
		"Place in coal to be burned into electricity and attach cable nodes to send the electricity to other machines."..
		"This will be the first type of generator you build"},
	voltbuild = {max_energy=60,max_tier=1,max_stress=2000,psize=10,
		speed = function (pos)
			local meta = minetest.env:get_meta(pos)
			local inv = meta:get_inventory()
			if not inv:is_empty("fuel") and is_fuel_no_lava(inv:get_stack("fuel",1)) then
				return 1
			else
				return 0
			end
		end,
		fueltime = function (pos)
			local meta = minetest.env:get_meta(pos)
			local inv = meta:get_inventory()
			local stack = inv:get_stack("fuel",1)
			if not inv:is_empty("fuel") and is_fuel_no_lava(stack) then
				local list = inv:get_list("fuel")
				local fuel = minetest.get_craft_result({method = "fuel",
					width = 1, items = list})
				return fuel.time
			else
				return false
			end
		end,
		energy_type_image= function (pos)
			local meta = minetest.env:get_meta(pos)
			local node = minetest.get_node(pos)
			local fueltime = minetest.registered_nodes[node.name]["voltbuild"]["fueltime"](pos)
			local percent
			if fueltime then
				percent = (meta:get_float("ftime")/fueltime)*100
			else
				percent = 100
			end
			return("default_furnace_fire_bg.png^[lowpart:"..(100-percent)..":default_furnace_fire_fg.png]")
		end},
	tube={insert_object=function(pos,node,stack,direction)
			local meta=minetest.env:get_meta(pos)
			local inv=meta:get_inventory()
			return inv:add_item("fuel",stack)
		end,
		can_insert=function(pos,node,stack,direction)
			local meta=minetest.env:get_meta(pos)
			local inv=meta:get_inventory()
			return (voltbuild.allow_metadata_inventory_put(pos,"fuel",
				nil,stack,nil) and
				inv:room_for_item("fuel",stack))
			end,
		connects = function (param2)
			return true
		end,
		connect_sides={left=1, right=1, back=1, bottom=1, top=1, front=1}},
	on_construct = function(pos)
		local meta = minetest.env:get_meta(pos)
		meta:set_int("energy",0)
		local inv = meta:get_inventory()
		inv:set_size("fuel", 1)
		meta:set_string("formspec", generators.get_formspec(pos)..
				fuel_spec..
				"image["..voltbuild.image_location.."default_furnace_fire_bg.png]")
		generators.on_construct(pos)
	end,
	can_dig = voltbuild.can_dig,
	allow_metadata_inventory_put = voltbuild.allow_metadata_inventory_put,
	allow_metadata_inventory_move = voltbuild.allow_metadata_inventory_move,
}
if pipeworks_path then
	generator_definition.after_place_node = function (pos)
		tube_scanforobjects(pos)
	end
	generator_definition.after_dig_node = function(pos)
		tube_scanforobjects(pos)
	end
end
minetest.register_node("voltbuild:generator",generator_definition)

local copy = {}
copy.light_source=8
copy.drop = "voltbuild:generator"
copy.tiles = {"itest_generator_side.png", "itest_generator_side.png", "itest_generator_side.png",
		"itest_generator_side.png", "itest_generator_side.png", "itest_generator_front_active.png"}
copy.groups = {}
copy.groups.not_in_creative_inventory=1
copy = voltbuild.deep_copy(generator_definition,copy)

minetest.register_node("voltbuild:generator_active",copy)

components.register_abm({
	nodenames = {"voltbuild:generator","voltbuild:generator_active"},
	interval = 1.0,
	chance = 1,
	action = voltbuild.generation_abm,
})

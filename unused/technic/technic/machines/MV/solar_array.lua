
minetest.register_craft({
	output = 'technic:solar_array_mv 1',
	recipe = {
		{'technic:solar_array_lv', 'technic:solar_array_lv', 'technic:solar_array_lv'},
		{'default:steel_ingot',    'technic:mv_transformer', 'default:steel_ingot'},
		{'',                       'technic:mv_cable0',      ''},
	}
})

technic.register_solar_array({tier="MV", power=30})


local function reverse_recipe(r)
	return {{r[1][1],r[2][1],r[3][1]},{r[1][2],r[2][2],r[3][2]},{r[1][3],r[2][3],r[3][3]}}
end

local function register_craft2(t)
	minetest.register_craft(t)
	t.recipe = reverse_recipe(t.recipe)
	minetest.register_craft(t)
end

minetest.register_craftitem( "voltbuild:refined_iron_ingot", {
	description = "Refined iron ingot",
	inventory_image = "itest_refined_iron_ingot.png",
})

minetest.register_craftitem( "voltbuild:iron_dust", {
	description = "Iron dust",
	inventory_image = "itest_iron_dust.png",
})

minetest.register_craftitem( "voltbuild:coal_dust", {
	description = "Coal dust",
	inventory_image = "itest_coal_dust.png",
})

minetest.register_craftitem( "voltbuild:gold_dust", {
	description = "Gold dust",
	inventory_image = "itest_gold_dust.png",
})

minetest.register_craftitem( "voltbuild:bronze_dust", {
	description = "Bronze dust",
	inventory_image = "itest_bronze_dust.png",
})

minetest.register_craftitem( "voltbuild:tin_dust", {
	description = "Tin dust",
	inventory_image = "itest_tin_dust.png",
})

minetest.register_craftitem( "voltbuild:silver_dust", {
	description = "Silver dust",
	inventory_image = "itest_tin_dust.png",
})

minetest.register_craftitem( "voltbuild:copper_dust", {
	description = "Copper dust",
	inventory_image = "itest_copper_dust.png",
})

minetest.register_node("voltbuild:machine",{description="Machine",
	groups={cracky=2},
	tiles={"itest_machine.png"},
})

minetest.register_node("voltbuild:advanced_machine",{description="Advanced machine",
	groups={cracky=2},
	tiles={"itest_advanced_machine.png"},
})

minetest.register_craftitem( "voltbuild:rubber", {
	description = "Rubber",
	inventory_image = "itest_rubber.png",
})

minetest.register_craftitem( "voltbuild:circuit", {
	description = "Electronic circuit",
	inventory_image = "itest_circuit.png",
})

minetest.register_craftitem( "voltbuild:advanced_circuit", {
	description = "Advanced circuit",
	inventory_image = "itest_advanced_circuit.png",
})

minetest.register_craftitem( "voltbuild:scrap", {
	description = "Scrap",
	inventory_image = "itest_scrap.png",
})

minetest.register_craftitem( "voltbuild:silicon_mesecon", {
	description = "Silicon-doped mesecon",
	inventory_image = "itest_silicon_mesecon.png",
})

minetest.register_node("voltbuild:silicon_mese_block",{description="Silicon-doped mese block",
	groups={cracky=2},
	tiles={"itest_silicon_mese_block.png"},
})

minetest.register_craftitem( "voltbuild:mixed_metal_ingot", {
	description = "Mixed metal ingot",
	inventory_image = "itest_mixed_metal_ingot.png",
})

minetest.register_craftitem( "voltbuild:advanced_alloy", {
	description = "Advanced alloy",
	inventory_image = "itest_advanced_alloy.png",
})

minetest.register_craftitem( "voltbuild:carbon_fibers", {
	description = "Carbon fibers",
	inventory_image = "itest_carbon_fibers.png",
})

minetest.register_craftitem( "voltbuild:combined_carbon_fibers", {
	description = "Combined carbon fibers",
	inventory_image = "itest_combined_carbon_fibers.png",
})

minetest.register_craftitem( "voltbuild:carbon_plate", {
	description = "Carbon plate",
	inventory_image = "itest_carbon_plate.png",
})

minetest.register_craft({
	type = "shapeless",
	output = "voltbuild:silicon_mesecon",
	recipe = {"mesecons:wire_00000000_off","mesecons_materials:silicon","voltbuild:copper_dust"}
})

minetest.register_craft({
	output = "voltbuild:silicon_mesecon 9",
	recipe = {{"voltbuild:silicon_mese_block"}}
})

minetest.register_craft({
	output = "voltbuild:silicon_mese_block",
	recipe = 	{{"voltbuild:silicon_mesecon","voltbuild:silicon_mesecon","voltbuild:silicon_mesecon"},
	{"voltbuild:silicon_mesecon","voltbuild:silicon_mesecon","voltbuild:silicon_mesecon"},
	{"voltbuild:silicon_mesecon","voltbuild:silicon_mesecon","voltbuild:silicon_mesecon"}}
})

minetest.register_craft({
	type = "shapeless",
	output = "voltbuild:bronze_dust 2",
	recipe = {"voltbuild:copper_dust","voltbuild:copper_dust",
		"voltbuild:copper_dust","voltbuild:tin_dust"}
})

minetest.register_craft({
	output = "voltbuild:treetap",
	recipe = {{"","group:wood",""},
		{"group:wood","group:wood","group:wood"},
		{"","","group:wood"}}
})

minetest.register_craft({
	output = "voltbuild:treetap",
	recipe = {{"","group:wood",""},
		{"group:wood","group:wood","group:wood"},
		{"group:wood","",""}}
})


minetest.register_craft({
	output = "voltbuild:alunra_treetap",
	recipe = {{"","voltbuild:alunra_gem",""},
		{"voltbuild:alunra_gem","voltbuild:treetap","voltbuild:alunra_gem"},
		{"","voltbuild:alunra_gem",""}}
})

minetest.register_craft({
	output = "default:wood 3",
	recipe = {{"voltbuild:rubber_tree"}}
})

minetest.register_craft({
	output = "voltbuild:copper_cable0_000000 6",
	recipe = {{"default:copper_ingot","default:copper_ingot","default:copper_ingot"}}
})

minetest.register_craft({
	output = "voltbuild:copper_cable1_000000 6",
	recipe = {{"voltbuild:rubber","voltbuild:rubber","voltbuild:rubber"},
		{"default:copper_ingot","default:copper_ingot","default:copper_ingot"},
		{"voltbuild:rubber","voltbuild:rubber","voltbuild:rubber"}}
})

minetest.register_craft({
	type = "shapeless",
	output = "voltbuild:copper_cable1_000000",
	recipe = {"voltbuild:copper_cable0_000000","voltbuild:rubber"}
})

minetest.register_craft({
	output = "voltbuild:gold_cable0_000000 12",
	recipe = {{"default:gold_ingot","default:gold_ingot","default:gold_ingot"}}
})

minetest.register_craft({
	output = "voltbuild:gold_cable1_000000 4",
	recipe = {{"","voltbuild:rubber",""},
		{"voltbuild:rubber","default:gold_ingot","voltbuild:rubber"},
		{"","voltbuild:rubber",""}}
})

minetest.register_craft({
	output = "voltbuild:gold_cable2_000000 4",
	recipe = {{"voltbuild:rubber","voltbuild:rubber","voltbuild:rubber"},
		{"voltbuild:rubber","default:gold_ingot","voltbuild:rubber"},
		{"voltbuild:rubber","voltbuild:rubber","voltbuild:rubber"}}
})

minetest.register_craft({
	type = "shapeless",
	output = "voltbuild:gold_cable1_000000",
	recipe = {"voltbuild:gold_cable0_000000","voltbuild:rubber"}
})

minetest.register_craft({
	type = "shapeless",
	output = "voltbuild:gold_cable2_000000",
	recipe = {"voltbuild:gold_cable1_000000","voltbuild:rubber"}
})

minetest.register_craft({
	type = "shapeless",
	output = "voltbuild:gold_cable2_000000",
	recipe = {"voltbuild:gold_cable0_000000","voltbuild:rubber","voltbuild:rubber"}
})

minetest.register_craft({
	output = "voltbuild:tin_cable0_000000 9",
	recipe = {{"moreores:tin_ingot","moreores:tin_ingot","moreores:tin_ingot"}}
})

minetest.register_craft({
	output = "voltbuild:hv_cable0_000000 12",
	recipe = {{"voltbuild:refined_iron_ingot","voltbuild:refined_iron_ingot","voltbuild:refined_iron_ingot"}}
})

minetest.register_craft({
	output = "voltbuild:hv_cable1_000000 4",
	recipe = {{"","voltbuild:rubber",""},
		{"voltbuild:rubber","voltbuild:refined_iron_ingot","voltbuild:rubber"},
		{"","voltbuild:rubber",""}}
})

minetest.register_craft({
	output = "voltbuild:hv_cable2_000000 4",
	recipe = {{"voltbuild:rubber","voltbuild:rubber","voltbuild:rubber"},
		{"voltbuild:rubber","voltbuild:refined_iron_ingot","voltbuild:rubber"},
		{"voltbuild:rubber","voltbuild:rubber","voltbuild:rubber"}}
})

minetest.register_craft({
	type = "shapeless",
	output = "voltbuild:hv_cable1_000000",
	recipe = {"voltbuild:hv_cable0_000000","voltbuild:rubber"}
})

minetest.register_craft({
	type = "shapeless",
	output = "voltbuild:hv_cable2_000000",
	recipe = {"voltbuild:hv_cable1_000000","voltbuild:rubber"}
})

minetest.register_craft({
	type = "shapeless",
	output = "voltbuild:hv_cable3_000000",
	recipe = {"voltbuild:hv_cable2_000000","voltbuild:rubber"}
})

minetest.register_craft({
	type = "shapeless",
	output = "voltbuild:hv_cable2_000000",
	recipe = {"voltbuild:hv_cable0_000000","voltbuild:rubber","voltbuild:rubber"}
})

minetest.register_craft({
	type = "shapeless",
	output = "voltbuild:hv_cable3_000000",
	recipe = {"voltbuild:hv_cable1_000000","voltbuild:rubber","voltbuild:rubber"}
})

minetest.register_craft({
	type = "shapeless",
	output = "voltbuild:hv_cable3_000000",
	recipe = {"voltbuild:hv_cable0_000000","voltbuild:rubber","voltbuild:rubber","voltbuild:rubber"}
})

register_craft2({
	output = "voltbuild:glass_fiber_cable_000000 4",
	recipe = {{"default:glass","default:glass","default:glass"},
		{"mesecons:wire_00000000_off","default:diamond","mesecons:wire_00000000_off"},
		{"default:glass","default:glass","default:glass"}}
})

minetest.register_craft({
	output = "voltbuild:detector_cable_off_000000",
	recipe = {{"","voltbuild:circuit",""},
		{"mesecons:wire_00000000_off","voltbuild:hv_cable3_000000","mesecons:wire_00000000_off"},
		{"","mesecons:wire_00000000_off",""}}
})

minetest.register_craft({
	output = "voltbuild:splitter_cable_000000",
	recipe = {{"","mesecons:wire_00000000_off",""},
		{"voltbuild:hv_cable3_000000","mesecons_walllever:wall_lever_off","voltbuild:hv_cable3_000000"},
		{"","mesecons:wire_00000000_off",""}}
})

minetest.register_craft({
	output = "voltbuild:re_battery",
	recipe = {{"","voltbuild:copper_cable1_000000",""},
		{"moreores:tin_ingot","moreores:copper_cable1_000000","moreores:tin_ingot"},
		{"moreores:tin_ingot","moreores:copper_cable1_000000","moreores:tin_ingot"}}
})

minetest.register_craft({
	output = "voltbuild:single_use_battery 20",
	recipe = {{"","voltbuild:tin_cable0_000000",""},
		{"voltbuild:rubber","voltbuild:tin_cable0_000000","voltbuild:rubber"},
		{"voltbuild:rubber","voltbuild:tin_cable0_000000","voltbuild:rubber"}},
})

minetest.register_craft({
	output = "voltbuild:energy_crystal",
	recipe = {{"mesecons:wire_00000000_off","mesecons:wire_00000000_off","mesecons:wire_00000000_off"},
		{"mesecons:wire_00000000_off","default:diamond","mesecons:wire_00000000_off"},
		{"mesecons:wire_00000000_off","mesecons:wire_00000000_off","mesecons:wire_00000000_off"}}
})

minetest.register_craft({
	output = "voltbuild:lapotron_crystal",
	recipe = {{"voltbuild:silicon_mesecon","voltbuild:circuit","voltbuild:silicon_mesecon"},
		{"voltbuild:silicon_mesecon","voltbuild:energy_crystal","voltbuild:silicon_mesecon"},
		{"voltbuild:silicon_mesecon","voltbuild:circuit","voltbuild:silicon_mesecon"}}
})

minetest.register_craft({
	output = "voltbuild:batbox",
	recipe = {{"default:wood","voltbuild:copper_cable1_000000","default:wood"},
		{"voltbuild:re_battery","voltbuild:re_battery","voltbuild:re_battery"},
		{"default:wood","default:wood","default:wood"}}
})

minetest.register_craft({
	output = "voltbuild:mfe_unit",
	recipe = {{"voltbuild:gold_cable2_000000","voltbuild:energy_crystal","voltbuild:gold_cable2_000000"},
		{"voltbuild:energy_crystal","voltbuild:machine","voltbuild:energy_crystal"},
		{"voltbuild:gold_cable2_000000","voltbuild:energy_crystal","voltbuild:gold_cable2_000000"}}
})

minetest.register_craft({
	output = "voltbuild:mfs_unit",
	recipe = {{"voltbuild:lapotron_crystal","voltbuild:advanced_circuit","voltbuild:lapotron_crystal"},
		{"voltbuild:lapotron_crystal","voltbuild:mfe_unit","voltbuild:lapotron_crystal"},
		{"voltbuild:lapotron_crystal","voltbuild:advanced_machine","voltbuild:lapotron_crystal"}}
})

minetest.register_craft({
	output = "voltbuild:iron_furnace",
	recipe = {{"default:steel_ingot","default:steel_ingot","default:steel_ingot"},
		{"default:steel_ingot","","default:steel_ingot"},
		{"default:steel_ingot","default:steel_ingot","default:steel_ingot"}}
})

minetest.register_craft({
	output = "voltbuild:iron_furnace",
	recipe = {{"","default:steel_ingot",""},
		{"default:steel_ingot","","default:steel_ingot"},
		{"default:steel_ingot","default:furnace","default:steel_ingot"}}
})

minetest.register_craft({
	output = "voltbuild:machine",
	recipe = {{"voltbuild:refined_iron_ingot","voltbuild:refined_iron_ingot","voltbuild:refined_iron_ingot"},
		{"voltbuild:refined_iron_ingot","","voltbuild:refined_iron_ingot"},
		{"voltbuild:refined_iron_ingot","voltbuild:refined_iron_ingot","voltbuild:refined_iron_ingot"}}
})

register_craft2({
	output = "voltbuild:advanced_machine",
	recipe = {{"","voltbuild:advanced_alloy",""},
		{"voltbuild:carbon_plate","voltbuild:machine","voltbuild:carbon_plate"},
		{"","voltbuild:advanced_alloy",""}}
})

minetest.register_craft({
	output = "voltbuild:mixed_metal_ingot 2",
	recipe = {{"voltbuild:refined_iron_ingot","voltbuild:refined_iron_ingot","voltbuild:refined_iron_ingot"},
		{"default:bronze_ingot","default:bronze_ingot","default:bronze_ingot"},
		{"moreores:tin_ingot","moreores:tin_ingot","moreores:tin_ingot"}}
})

minetest.register_craft({
	output = "voltbuild:carbon_fibers",
	recipe = {{"voltbuild:coal_dust","voltbuild:coal_dust"},
		{"voltbuild:coal_dust","voltbuild:coal_dust"}}
})

minetest.register_craft({
	type = "shapeless",
	output = "voltbuild:combined_carbon_fibers",
	recipe = {"voltbuild:carbon_fibers","voltbuild:carbon_fibers"}
})

minetest.register_craft({
	output = "voltbuild:generator",
	recipe = {{"","voltbuild:re_battery",""},
		{"voltbuild:refined_iron_ingot","voltbuild:refined_iron_ingot","voltbuild:refined_iron_ingot"},
		{"","voltbuild:iron_furnace",""}}
})

minetest.register_craft({
	output = "voltbuild:generator",
	recipe = {{"voltbuild:re_battery"},
		{"voltbuild:machine"},
		{"default:furnace"}}
})

register_craft2({
	output = "voltbuild:circuit",
	recipe = {{"voltbuild:copper_cable1_000000","voltbuild:copper_cable1_000000","voltbuild:copper_cable1_000000"},
		{"mesecons:wire_00000000_off","voltbuild:refined_iron_ingot","mesecons:wire_00000000_off"},
		{"voltbuild:copper_cable1_000000","voltbuild:copper_cable1_000000","voltbuild:copper_cable1_000000"}}
})

register_craft2({
	output = "voltbuild:advanced_circuit",
	recipe = {{"mesecons:wire_00000000_off","voltbuild:gold_dust","mesecons:wire_00000000_off"},
		{"voltbuild:silicon_mesecon","voltbuild:circuit","voltbuild:silicon_mesecon"},
		{"mesecons:wire_00000000_off","voltbuild:gold_dust","mesecons:wire_00000000_off"}}
})

minetest.register_craft({
	output = "voltbuild:lv_transformer",
	recipe = {{"default:wood","voltbuild:copper_cable1_000000","default:wood"},
		{"default:copper_ingot","default:copper_ingot","default:copper_ingot"},
		{"default:wood","voltbuild:copper_cable1_000000","default:wood"}}
})

minetest.register_craft({
	output = "voltbuild:mv_transformer",
	recipe = {{"voltbuild:gold_cable2_000000"},
		{"voltbuild:machine"},
		{"voltbuild:gold_cable2_000000"}}
})

minetest.register_craft({
	output = "voltbuild:hv_transformer",
	recipe = {{"","voltbuild:hv_cable3_000000",""},
		{"voltbuild:circuit","voltbuild:mv_transformer","voltbuild:energy_crystal"},
		{"","voltbuild:hv_cable3_000000",""}}
})

minetest.register_craft({
	output = "voltbuild:electric_furnace",
	recipe = {{"","voltbuild:circuit",""},
		{"mesecons:wire_00000000_off","voltbuild:iron_furnace","mesecons:wire_00000000_off"}}
})

minetest.register_craft({
	output = "voltbuild:extractor",
	recipe = {{"voltbuild:treetap","voltbuild:machine","voltbuild:treetap"},
		{"voltbuild:treetap","voltbuild:circuit","voltbuild:treetap"},
		{"default:brick","default:brick","default:brick"}}
})

minetest.register_craft({
	output = "voltbuild:macerator",
	recipe = {{"default:gravel","voltbuild:re_battery","default:gravel"},
		{"default:sandstonebrick","voltbuild:machine","default:sandstonebrick"},
		{"default:desert_stone","default:desert_stone","default:desert_stone"}}
})

minetest.register_craft({
	output = "voltbuild:compressor",
	recipe = {{"default:bronze_ingot","","default:bronze_ingot"},
		{"default:bronze_ingot","voltbuild:machine","default:bronze_ingot"},
		{"default:bronze_ingot","voltbuild:circuit","default:bronze_ingot"}}
})

minetest.register_craft({
	output = "voltbuild:recycler",
	recipe = {{"","voltbuild:gold_dust",""},
		{"default:dirt","voltbuild:compressor","default:dirt"},
		{"voltbuild:refined_iron_ingot","default:dirt","voltbuild:refined_iron_ingot"}}
})

minetest.register_craft({
	output = "voltbuild:mining_pipe 8",
	recipe = {{"voltbuild:refined_iron_ingot","","voltbuild:refined_iron_ingot"},
		{"voltbuild:refined_iron_ingot","","voltbuild:refined_iron_ingot"},
		{"voltbuild:refined_iron_ingot","voltbuild:treetap","voltbuild:refined_iron_ingot"}}
})

minetest.register_craft({
	output = "voltbuild:miner",
	recipe = {{"voltbuild:advanced_circuit","voltbuild:extractor","voltbuild:advanced_circuit"},
		{"","voltbuild:mining_pipe",""},
		{"","voltbuild:mining_pipe",""}}
})

minetest.register_craft({
	output = "voltbuild:solar_panel",
	recipe = {{"voltbuild:coal_dust","default:glass","voltbuild:coal_dust"},
		{"default:glass","voltbuild:coal_dust","default:glass"},
		{"voltbuild:tin_ingot","voltbuild:generator","voltbuild:tin_ingot"}}
})

minetest.register_craft({
	output = "voltbuild:watermill",
	recipe = {{"default:stick","default:wood","default:stick"},
		{"default:wood","voltbuild:generator","default:wood"},
		{"default:stick","default:wood","default:stick"}}
})

minetest.register_craft({
	output = "voltbuild:windmill",
	recipe = {{"default:steel_ingot","","default:steel_ingot"},
		{"","voltbuild:generator",""},
		{"default:steel_ingot","","default:steel_ingot"}}
})

minetest.register_craft({
	output = "voltbuild:mining_drill_discharged",
	recipe = {{"","voltbuild:refined_iron_ingot",""},
		{"voltbuild:refined_iron_ingot","voltbuild:circuit","voltbuild:refined_iron_ingot"},
		{"voltbuild:refined_iron_ingot","voltbuild:re_battery","voltbuild:refined_iron_ingot"}}
})

minetest.register_craft({
	output = "voltbuild:diamond_drill_discharged",
	recipe = {{"","default:diamond",""},
		{"default:diamond","voltbuild:mining_drill","default:diamond"}}
})

minetest.register_craft({
	output = "voltbuild:diamond_drill_discharged",
	recipe = {{"","default:diamond",""},
		{"default:diamond","voltbuild:mining_drill_discharged","default:diamond"}}
})

minetest.register_craft({
	output = "voltbuild:od_scanner",
	recipe = {{"","voltbuild:gold_dust",""},
		{"voltbuild:circuit","voltbuild:re_battery","voltbuild:circuit"},
		{"voltbuild:copper_cable1_000000","voltbuild:copper_cable1_000000","voltbuild:copper_cable1_000000"}}
})

minetest.register_craft({
	output = "voltbuild:ov_scanner",
	recipe = {{"","voltbuild:gold_dust",""},
		{"voltbuild:gold_dust","voltbuild:advanced_circuit","voltbuild:gold_dust"},
		{"voltbuild:gold_cable2_000000","voltbuild:od_scanner","voltbuild:gold_cable2_000000"}}
})

minetest.register_craft({
	output = "voltbuild:refined_iron_ingot 8",
	recipe = {{"voltbuild:machine"}}
})

minetest.register_craft({
	type = "cooking",
	output = "voltbuild:rubber",
	recipe = "voltbuild:sticky_resin"
})

minetest.register_craft({
	type = "cooking",
	output = "voltbuild:refined_iron_ingot",
	recipe = "default:steel_ingot"
})

minetest.register_craft({
	type = "cooking",
	output = "default:steel_ingot",
	recipe = "voltbuild:iron_dust"
})

minetest.register_craft({
	type = "cooking",
	output = "default:copper_ingot",
	recipe = "voltbuild:copper_dust"
})

minetest.register_craft({
	type = "cooking",
	output = "default:bronze_ingot",
	recipe = "voltbuild:bronze_dust"
})

minetest.register_craft({
	type = "cooking",
	output = "voltbuild:tin_ingot",
	recipe = "voltbuild:tin_dust"
})

minetest.register_craft({
	type = "cooking",
	output = "moreores:silver_ingot",
	recipe = "voltbuild:silver_dust"
})

minetest.register_craft({
	type = "cooking",
	output = "default:gold_ingot",
	recipe = "voltbuild:gold_dust"
})

minetest.register_craft({
	type = "cooking",
	output = "voltbuild:ignis_dust 2",
	recipe = "voltbuild:ice_with_ignis",
})

minetest.register_craft({
	output = "voltbuild:medpack",
	recipe = {{"default:glass","default:apple","default:glass"},
		{"default:apple","default:apple","default:apple"},
		{"default:glass","default:apple","default:glass"}},
})

minetest.register_craft({
	output = "voltbuild:hospital",
	recipe = {{"voltbuild:medpack","voltbuild:ov_scanner","voltbuild:medpack"},
		{"voltbuild:medpack","voltbuild:machine","voltbuild:medpack"},
		{"voltbuild:extractor","voltbuild:circuit","voltbuild:compressor"}},
})

minetest.register_craft({
	output = "voltbuild:nuclear_reactor",
	recipe = {{"voltbuild:advanced_alloy","voltbuild:windmill","voltbuild:advanced_alloy"},
		{"voltbuild:lapotron_crystal","voltbuild:advanced_machine","voltbuild:lapotron_crystal"},
		{"voltbuild:advanced_alloy","voltbuild:advanced_circuit","voltbuild:advanced_alloy"}},
})

minetest.register_craft({
	output = "voltbuild:radioactive_shielding",
	recipe = {{"voltbuild:advanced_alloy","voltbuild:coal_dust","voltbuild:advanced_alloy"}},
})

minetest.register_craft({
	output = "voltbuild:casing",
	recipe = {{"voltbuild:refined_iron_ingot","voltbuild:advanced_alloy","voltbuild:refined_iron_ingot"}},
})

minetest.register_craft({
	output = "voltbuild:reactor_wiring",
	recipe = {{"voltbuild:hv_cable3_000000"}},
})

minetest.register_craft({
	output = "voltbuild:hv_cable3_000000",
	recipe = {{"voltbuild:reactor_wiring"}},
})

minetest.register_craft({
	output = "voltbuild:nuclear_reaction_chamber",
	recipe = {{"voltbuild:lapotron_crystal","voltbuild:generator","voltbuild:lapotron_crystal"}},
})

minetest.register_craft({
	output = "voltbuild:shielded_reactor_wiring",
	recipe = {{"","voltbuild:radioactive_shielding",""},
		{"voltbuild:radioactive_shielding","voltbuild:reactor_wiring","voltbuild:radioactive_shielding"},
		{"","voltbuild:radioactive_shielding",""}},
})

minetest.register_craft({
	output = "voltbuild:reactor_fan",
	recipe = {{"voltbuild:fan"}},
})

minetest.register_craft({
	output = "voltbuild:fan",
	recipe = {{"voltbuild:reactor_fan"}},
})

minetest.register_craft({
	output = "voltbuild:reactor_steam_gen",
	recipe = {{"voltbuild:advanced_alloy","voltbuild:reactor_wiring","voltbuild:advanced_alloy"},
		{"voltbuild:reactor_wiring","voltbuild:windmill","voltbuild:reactor_wiring"},
		{"voltbuild:advanced_alloy","voltbuild:reactor_wiring","voltbuild:advanced_alloy"}}
})

minetest.register_craft({
	output = "voltbuild:scuba_gear",
	recipe = {{"","default:steel_ingot",""},
		{"default:steel_ingot","voltbuild:rubber","default:steel_ingot"},
		{"default:steel_ingot","default:mese_crystal_fragment","default:steel_ingot"}}
})

minetest.register_craft({
	output = "voltbuild:geothermal_generator",
	recipe = {{"voltbuild:casing","voltbuild:ignis_gem","voltbuild:casing"},
		{"voltbuild:ignis_gem","voltbuild:generator","voltbuild:ignis_gem"},
		{"voltbuild:casing","voltbuild:ignis_gem","voltbuild:casing"}}
})

minetest.register_craft({
	output = "voltbuild:solar_battery",
	recipe = {{"","voltbuild:mobile_solar_panel",""},
		{"voltbuild:mobile_solar_panel","voltbuild:re_battery","voltbuild:mobile_solar_panel"},
		{"","voltbuild:mobile_solar_panel",""}}
})

minetest.register_craft({
	output = "voltbuild:teleport_gloves_discharged",
	recipe = {{"voltbuild:alunra_gem","voltbuild:mfs_unit","voltbuild:alunra_gem"},
		{"voltbuild:alunra_gem","voltbuild:silicon_mese_block","voltbuild:alunra_gem"},
		{"voltbuild:alunra_gem","voltbuild:mfs_unit","voltbuild:alunra_gem"}}
})

minetest.register_craft({
	type = "fuel",
	recipe = "voltbuild:ignis_dust",
	burntime = 40
})

macerator.register_macerator_recipe("default:iron_lump","voltbuild:iron_dust 2")
macerator.register_macerator_recipe("default:gold_lump","voltbuild:gold_dust 2")
macerator.register_macerator_recipe("default:coal_lump","voltbuild:coal_dust")
macerator.register_macerator_recipe("default:copper_lump","voltbuild:copper_dust 2")
macerator.register_macerator_recipe("voltbuild:tin_lump","voltbuild:tin_dust 2")
macerator.register_macerator_recipe("voltbuild:tin_ingot","voltbuild:tin_dust")
macerator.register_macerator_recipe("default:steel_ingot","voltbuild:iron_dust")
macerator.register_macerator_recipe("voltbuild:refined_iron_ingot","voltbuild:iron_dust")
macerator.register_macerator_recipe("default:gold_ingot","voltbuild:gold_dust")
macerator.register_macerator_recipe("default:copper_ingot","voltbuild:copper_dust")
macerator.register_macerator_recipe("default:bronze_ingot","voltbuild:bronze_dust")
macerator.register_macerator_recipe("voltbuild:ignis_gem","voltbuild:ignis_dust")

macerator.register_macerator_recipe("moreores:bronze_ingot","voltbuild:bronze_dust")
macerator.register_macerator_recipe("moreores:copper_ingot","voltbuild:copper_dust")
macerator.register_macerator_recipe("moreores:tin_ingot","voltbuild:tin_dust")
macerator.register_macerator_recipe("moreores:tin_lump","voltbuild:tin_dust 2")
macerator.register_macerator_recipe("moreores:gold_ingot","voltbuild:gold_dust")
macerator.register_macerator_recipe("moreores:gold_lump","voltbuild:gold_dust 2")
macerator.register_macerator_recipe("moreores:copper_lump","voltbuild:copper_dust 2")
macerator.register_macerator_recipe("moreores:silver_lump","voltbuild:silver_dust 2")
macerator.register_macerator_recipe("moreores:silver_ingot","voltbuild:silver_dust")

extractor.register_extractor_recipe("voltbuild:sticky_resin","voltbuild:rubber 3")
extractor.register_extractor_recipe("voltbuild:rubber_tree","voltbuild:rubber")
extractor.register_extractor_recipe("voltbuild:rubber_sapling","voltbuild:rubber")
extractor.register_extractor_recipe("default:mese_crystal","mesecons:wire_00000000_off 32")
extractor.register_extractor_recipe("default:sand","mesecons_materials:silicon")
if minetest.get_modpath("bucket") then
	extractor.register_function_recipe("voltbuild:bucket_water_with_ignis",function (input)
		return {item = ItemStack("voltbuild:ignis_dust 2"),time=20},{items = {"bucket:bucket_empty"}}
	end)
end

compressor.register_compressor_recipe("voltbuild:mixed_metal_ingot","voltbuild:advanced_alloy")
compressor.register_compressor_recipe("voltbuild:combined_carbon_fibers","voltbuild:carbon_plate")
compressor.register_compressor_recipe("voltbuild:ignis_dust","voltbuild:ignis_gem")


-- Basket

minetest.register_craft({
    output = "bushes:basket_empty",
    recipe = {
	{ "default:stick", "default:stick", "default:stick" },
	{ "", "default:stick", "" },
    },
})


for i, berry in ipairs(bushes_classic.bushes) do
	local desc = bushes_classic.bushes_descriptions[i]

	minetest.register_craftitem(":bushes:"..berry.."_pie_raw", {
		description = "Raw "..desc.." pie",
		inventory_image = "bushes_"..berry.."_pie_raw.png",
		on_use = minetest.item_eat(4),
	})

	if berry ~= "mixed_berry" then
		minetest.register_craftitem(":bushes:"..berry, {
			description = desc,
			inventory_image = "bushes_"..berry..".png",
			groups = {berry = 1, [berry] = 1},
			on_use = minetest.item_eat(1),
		})

		if minetest.registered_nodes["farming:soil"] then
			minetest.register_craft({
				output = "bushes:"..berry.."_pie_raw 1",
				recipe = {
				{ "default:sugar", "farming:flour", "default:sugar" },
				{ "group:"..berry, "group:"..berry, "group:"..berry },
				},
			})
		else
			minetest.register_craft({
				output = "bushes:"..berry.."_pie_raw 1",
				recipe = {
				{ "default:sugar", "group:junglegrass", "default:sugar" },
				{ "group:"..berry, "group:"..berry, "group:"..berry },
				},
			})
		end
	end

	-- Cooked pie

	minetest.register_craftitem(":bushes:"..berry.."_pie_cooked", {
		description = "Cooked "..desc.." pie",
		inventory_image = "bushes_"..berry.."_pie_cooked.png",
		on_use = minetest.item_eat(6),
	})

	minetest.register_craft({
		type = "cooking",
		output = "bushes:"..berry.."_pie_cooked",
		recipe = "bushes:"..berry.."_pie_raw",
		cooktime = 30,
	})

	-- slice of pie

	minetest.register_craftitem(":bushes:"..berry.."_pie_slice", {
		description = "Slice of "..desc.." pie",
		inventory_image = "bushes_"..berry.."_pie_slice.png",
		on_use = minetest.item_eat(1),
	})

	minetest.register_craft({
		output = "bushes:"..berry.."_pie_slice 6",
		recipe = {
		{ "bushes:"..berry.."_pie_cooked" },
		},
	})

	-- Basket with pies

	minetest.register_craft({
		output = "bushes:basket_"..berry.." 1",
		recipe = {
		{ "bushes:"..berry.."_pie_cooked", "bushes:"..berry.."_pie_cooked", "bushes:"..berry.."_pie_cooked" },
		{ "", "bushes:basket_empty", "" },
		},
	})
end

if minetest.registered_nodes["farming_plus:strawberry"] then
	minetest.register_craftitem(":farming_plus:strawberry_item", {
		description = "Strawberry",
		inventory_image = "farming_strawberry.png",
		on_use = minetest.item_eat(2),
		groups = {berry=1, strawberry=1}
	})
end

if minetest.registered_nodes["farming:soil"] then
	minetest.register_craft({
		output = "bushes:mixed_berry_pie_raw 2",
		recipe = {
		{ "default:sugar", "farming:flour", "default:sugar" },
		{ "group:berry", "group:berry", "group:berry" },
		{ "group:berry", "group:berry", "group:berry" },
		},
	})
else
	minetest.register_craft({
		output = "bushes:mixed_berry_pie_raw 2",
		recipe = {
		{ "default:sugar", "group:junglegrass", "default:sugar" },
		{ "group:berry", "group:berry", "group:berry" },
		{ "group:berry", "group:berry", "group:berry" },
		},
	})
end


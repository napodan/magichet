--= This section deals with farming of mushrooms

minetest.register_craftitem("ethereal:mushroom_craftingitem", {
    description = "Mushroom Spores",
    groups = {not_in_creative_inventory=1},
    inventory_image = "mushroom_spores.png",
    on_place = function(itemstack, placer, pointed_thing)
        return place_seed(itemstack, placer, pointed_thing, "ethereal:mushroom_garden_1")
    end,
})


for i=1,4 do
    local drop = {
        items = {
            {items = {'ethereal:mushroom_plant 3'},rarity=1},
            {items = {'ethereal:mushroom_plant 6'},rarity=18-i*2},
                }
    }
minetest.register_node("ethereal:mushroom_garden_"..i, {
        drawtype = "plantlike",
        tiles = {"ethereal_mushroom_garden_"..i..".png"},
        paramtype = "light",
        walkable = false,
        drop = drop,
        buildable_to = true,
        is_ground_content = true,
        drop = drop,
        selection_box = {
            type = "fixed",
            fixed = {-0.5, -0.5, -0.5, 0.5, -5/16, 0.5},
        },
        groups = {snappy=default.dig.leaves,flammable=2,plant=1,mushroom=i,attached_node=1},
        sounds = default.node_sound_leaves_defaults(),
    })
end

minetest.register_abm({
    nodenames = {"group:mushroom"},
    neighbors = {"group:soil"},
    interval = 30,
    chance = 2,
    action = function(pos, node)
        -- return if already full grown
        if minetest.get_item_group(node.name, "mushroom") == 4 then
            return
        end

        -- check if on wet soil
        pos.y = pos.y-1
        local n = minetest.get_node(pos)
        if minetest.get_item_group(n.name, "soil") < 3 then
            return
        end
        pos.y = pos.y+1

        -- check light
        if not minetest.get_node_light(pos) then
            return
        end
        if minetest.get_node_light(pos) < 5 then
            return
        end

        -- grow
        local height = minetest.get_item_group(node.name, "mushroom") + 1
        minetest.set_node(pos, {name="ethereal:mushroom_garden_"..height})
    end
})

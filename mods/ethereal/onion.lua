--= This section deals with framing of Wild Onions

minetest.register_craftitem("ethereal:wild_onion_craftingitem", {
    description = "Wild Onion",
    groups = {not_in_creative_inventory=1},
    inventory_image = "wild_onion.png",
    on_use = minetest.item_eat(2),
    on_place = function(itemstack, placer, pointed_thing)
        return place_seed(itemstack, placer, pointed_thing, "ethereal:wild_onion_1")
end
})


for i=1,5 do
    local drop = {
        items = {
            {items = {'ethereal:wild_onion_craftingitem 4'},rarity=10-i*2},
            {items = {'ethereal:wild_onion_craftingitem 8'},rarity=18-i*2},
                    }
    }
minetest.register_node("ethereal:wild_onion_"..i, {
        drawtype = "plantlike",
        tiles = {"ethereal_wild_onion_"..i..".png"},
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
        groups = {snappy=default.dig.leaves,flammable=2,plant=1,onion=i,attached_node=1},
        sounds = default.node_sound_leaves_defaults(),
    })
end

minetest.register_abm({
    nodenames = {"group:onion"},
    neighbors = {"group:soil"},
    interval = 50,
    chance = 3,
    action = function(pos, node)
        -- return if already full grown
        if minetest.get_item_group(node.name, "onion") == 4 then
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
        if minetest.get_node_light(pos) < 13 then
            return
        end

        -- grow
        local height = minetest.get_item_group(node.name, "onion") + 1
        minetest.set_node(pos, {name="ethereal:wild_onion_"..height})
    end
})


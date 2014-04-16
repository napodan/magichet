minetest.after(0,function(dtime)
local def = minetest.registered_craftitems['default:gravel']
if def then
def.drop =  {
        max_items = 1,
        items = {
            {
                items = {'flint:flintstone'},
                rarity = 10,
            },
            {
                items = {'default:gravel'},
            }
        }
    }
minetest.register_node(":default:gravel", def)
end
end)


minetest.register_craftitem("flint:flintstone", {
    description = "Flintstone",
    inventory_image = "flint_flintstone.png",
})


minetest.register_craft({
    output = 'flint:lighter',
    recipe = {
        {'default:steel_ingot', ''},
        {'', 'flint:flintstone'},
    }
})

local function get_nodedef_field(nodename, fieldname)
    if not minetest.registered_nodes[nodename] then
        return nil
    end
    return minetest.registered_nodes[nodename][fieldname]
end

local function set_fire(pointed_thing)
        local n = minetest.env:get_node(pointed_thing.above)
        if n.name ~= ""  and n.name == "air" then
            minetest.env:set_node(pointed_thing.above, {name="fire:flame_normal"})
        end
end

minetest.register_tool("flint:lighter", {
    description = "Lighter",
    inventory_image = "flint_lighter.png",
    liquids_pointable = false,
    stack_max = 1,
    tool_capabilities = {
        full_punch_interval = 1.0,
        max_drop_level=0,
        groupcaps={
            flamable = {uses=65, maxlevel=1},
        }
    },
    --groups = {hot=3, igniter=1, not_in_creative_inventory=1},
    on_place = function(itemstack, user, pointed_thing)
        if pointed_thing.type == "node" then
            set_fire(pointed_thing)
            itemstack:add_wear(65535/65)
            return itemstack
        end
    end,

})

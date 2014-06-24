-- Change j to 1 for 3D style leaves, otherwise 0 is 2D

local j = 1

if j == 0 then
    leaftype = "plantlike"
else
    leaftype = "allfaces_optional"
end

-- drop is like this: {{name='itemname', chance=%},{name='itemname2', chance=%},...}
-- cutby is like {tool1name, tool2name,...}
-- groups can be nil

local function register_leaves(name, desc, txtures, drops, cutby, grps)
if not grps then grps = {snappy=default.dig.leaves, leafdecay=3, flammable=2, leaves=1} end
local ls = 0
if name=="ethereal:yellowleaves" then ls = 4 end
if name=="ethereal:frost_leaves" then ls = 6 end

minetest.register_node(":"..name, {
    description = desc,
    drawtype = leaftype,
    visual_scale = 0.9,
    tiles = txtures,
    paramtype = "light",
    groups = grps,
    -- drop is controlled by the chances and a tool
    drop = "",
    sounds = default.node_sound_leaves_defaults(),
    light_source = ls,

    after_dig_node = function(pos, oldnode, oldmetadata, digger)
        -- let us find if we actually CAN cut that down as a block
        local dropped = false
        local wielded = digger:get_wielded_item():get_name()
        if cutby then
        for i,tool in ipairs(cutby) do
            if wielded == tool
            or minetest.get_item_group(wielded, tool)>0
            then
               dropped = true
               minetest.chat_send_all('wielded: '.. wielded ..', tool/group: '..tool)
               break
            end
        end
        else
            if name:find('mushroom') then dropped=true end
        end
        -- and if we can, then
        -- "drop" defaults to the name
        local nn = name
        -- though chances are in %, the first one has better chances to be dropped
        -- but we don't want to spam rare drop by near-infinite dig/place sequence
        if oldnode.param2~=1 then
            for i,drp in ipairs(drops) do
                if math.random(1, drp.chance)==1 then
                   nn = drp.name
                   break
                end
            end
        end
        minetest.chat_send_all('nn: '..nn..', name: '..name)
        -- let it be dropeed, if it's not the leaves
        if dropped or nn ~= name then
           local obj = minetest.add_item(pos, nn)
                if obj ~= nil then
                    obj:get_luaentity().collect = true
                    local x = math.random(1, 5)
                    if math.random(1,2) == 1 then
                        x = -x
                    end
                    local z = math.random(1, 5)
                    if math.random(1,2) == 1 then
                        z = -z
                    end
                    obj:setvelocity({x=1/x, y=obj:getvelocity().y, z=1/z})
                end
        end
    end,
    after_place_node = function(pos, placer, itemstack)
        minetest.set_node(pos, {name=name, param2=1})
    end,
})

end

--= Define leaves for ALL trees (and Mushroom Tops)
-- dug by shears
register_leaves("default:leaves",
                "Leaves",
                {"default_leaves.png"},
                {{name='ethreal:tree_sapling',chance=20},{name='default:apple',chance=100}},
                {"default:shears"})
-- dug by shears
register_leaves("default:jungleleaves",
                "Jungle Tree Leaves",
                {"default_leaves.png"},
                {{name='ethereal:jungle_tree_sapling',chance=20}},
                {"default:shears"})
-- dug by sharp and shears
register_leaves("ethereal:bananaleaves",
                "Banana Leaves",
                {"banana_leaf.png"},
                {{name='ethereal:banana_tree_sapling',chance=20}},
                {"default:shears", "sharp"})
-- dug by sharp, cutters and shears
register_leaves("ethereal:yellowleaves",
                "Yellow Leaves",
                {"default_leaves.png"},
                {{name='default:apple',chance=30},{name='ethereal:yellow_tree_sapling',chance=10}},
                {"default:shears", "cutters"},
                {snappy=default.dig.leaves, leaves=1})
-- dug by shears
register_leaves("ethereal:palmleaves",
                "Palm Tree Leaves",
                {"moretrees_palm_leaves.png"},
                {{name='ethereal:palm_sapling',chance=20}},
                {"default:shears"})
-- dug by shears and cutters
register_leaves("ethereal:pineleaves",
                "Pine Needles",
                {"pine_leaves.png"},
                {{name='ethereal:pine_tree_sapling',chance=20},{name='ethereal:pine_nuts',chance=5}},
                {"default:shears", "cutters"})
-- dug by cutters
register_leaves("ethereal:frost_leaves",
                "Frost Leaves",
                {"ethereal_frost_leaves.png"},
                {{name='ethereal:frost_tree_sapling',chance=20}},
                {"cutters"},
                {cracky=default.dig.ice, puts_out_fire=1})
-- dug by ...
register_leaves("ethereal:mushroom",
                "Mushroom Cap",
                {"mushroom_block.png"},
                {{name='ethereal:mushroom_sapling',chance=20}},
                nil,
                {snappy=default.dig.leaves, oddly_breakable_by_hand=1})
-- dug by ...
register_leaves("ethereal:mushroom_pore",
                "Mushroom Pore",
                {"mushroom_block2.png"},
                {},
                nil,
                {snappy=default.dig.leaves, leaves=1, bouncy = 50, slippery = 70})

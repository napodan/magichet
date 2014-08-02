local c_air = minetest.get_content_id("air")
local c_ignore = minetest.get_content_id("ignore")
local c_oaktree = minetest.get_content_id("less_trees:oaktree")
local c_oakleaves = minetest.get_content_id("less_trees:oakleaves")

function default.grow_oaktree(data, a, pos, is_apple_tree, seed)
        --[[
                NOTE: Tree-placing code is currently duplicated in the engine
                and in games that have saplings; both are deprecated but not
                replaced yet
        ]]--
        local pr = PseudoRandom(seed)
        local th = pr:next(4, 5)
        local x, y, z = pos.x, pos.y, pos.z
        for yy = y, y+th-1 do
                local vi = a:index(x, yy, z)
                if a:contains(x, yy, z) and (data[vi] == c_air or yy == y) then
                        data[vi] = c_oaktree
                end
        end
        y = y+th-1 -- (x, y, z) is now last piece of trunk
        local oakleaves_a = VoxelArea:new{MinEdge={x=-2, y=-1, z=-2}, MaxEdge={x=2, y=2, z=2}}
        local oakleaves_buffer = {}
        
        -- Force leaves near the trunk
        local d = 1
        for xi = -d, d do
        for yi = -d, d do
        for zi = -d, d do
                oakleaves_buffer[oakleaves_a:index(xi, yi, zi)] = true
        end
        end
        end
        
        -- Add leaves randomly
        for iii = 1, 8 do
                local d = 1
                local xx = pr:next(oakleaves_a.MinEdge.x, oakleaves_a.MaxEdge.x - d)
                local yy = pr:next(oakleaves_a.MinEdge.y, oakleaves_a.MaxEdge.y - d)
                local zz = pr:next(oakleaves_a.MinEdge.z, oakleaves_a.MaxEdge.z - d)
                
                for xi = 0, d do
                for yi = 0, d do
                for zi = 0, d do
                        oakleaves_buffer[oakleaves_a:index(xx+xi, yy+yi, zz+zi)] = true
                end
                end
                end
        end
        
        -- Add the leaves
        for xi = oakleaves_a.MinEdge.x, oakleaves_a.MaxEdge.x do
        for yi = oakleaves_a.MinEdge.y, oakleaves_a.MaxEdge.y do
        for zi = oakleaves_a.MinEdge.z, oakleaves_a.MaxEdge.z do
                if a:contains(x+xi, y+yi, z+zi) then
                        local vi = a:index(x+xi, y+yi, z+zi)
                        if data[vi] == c_air or data[vi] == c_ignore then
                                if oakleaves_buffer[oakleaves_a:index(xi, yi, zi)] then
                                                data[vi] = c_leaves
                                        end
                                end
                        end
                end
        end
        end
        end
end

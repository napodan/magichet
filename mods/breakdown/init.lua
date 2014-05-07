minetest.alter_efficiency = function (pos, value)
   print('At '..minetest.pos_to_string(pos)..' efficiency is altered by '..value)
   local meta = minetest.get_meta(pos)
   local efficiency = meta:get_int("efficiency")
   efficiency = efficiency + value
   if efficiency<=0 then
      local inv = meta:get_inventory()      
      local lists = inv:get_lists()
      for name, data in pairs(lists) do          
          for i=1,inv:get_size(name) do
              local itemstack = inv:get_stack(name, i)
              math.randomseed(os.time())              
              local obj = minetest.add_item(pos, itemstack)
              if obj then obj:setvelocity({x=math.random(-3,3), y=math.random(1,3), z=math.random(-3,3)}) end
          end
      end
      minetest.remove_node(pos)
    else
       -- no need to set meta if a node's gonna be destructed
       meta:set_int("efficiency",efficiency)
    end
end

minetest.after(1,function(dtime)
    for cou,def in pairs(minetest.registered_nodes) do
        local construct = def.on_construct
        local on_construct = function(pos)
           -- call an old on_construct
           if construct then construct(pos) end
           local meta = minetest.get_meta(pos)
           meta:set_int("efficiency", 100)
        end        
        minetest.override_item(def.name, {on_construct = on_construct,})                
    end
end )


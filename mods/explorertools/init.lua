-- 4aiman's version of explorertools mod that changes the default behaviour for
-- all tools in all mods that loaded prior to this mod. License CC-BY-NC-ND.

--Initial version was written by Donald Hines and his son Jesse Hines and was
--licensed as CC0. Say a good word about them to everyone you met ;)

function explorertools_place(item, player, pointed)
  local idx = player:get_wield_index() + 1
  if idx < 9 then
    local inv = player:get_inventory()
    local stack = inv:get_stack("main", idx)
    if pointed ~= nil then
      local success

      stack, success = minetest.item_place(stack, player, pointed)
      if success then  --if item was placed, put modified stack back in inv
        inv:set_stack("main", idx, stack)
      end
    end
  end
end

for cou,def in pairs(minetest.registered_tools) do
    if def.name:find('pick')
    or def.name:find('axe')
    or def.name:find('shovel')
    or def.name:find('spade')
    then
      minetest.override_item(def.name, {on_place = explorertools_place,})
    end
end

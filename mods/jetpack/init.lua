-- Jetpack mod by 4aiman
-- an early alpha version
-- License: GPLv3

--[[
Let us first work with the example you gave and generalize from there.

You have a circle with center (2,3) and radius r=3. You want to rotate
the point (5,3) on the circle by θ=0.2 radians. To do this we parametrize
the circle as (x,y)=(2+3cosθ,3+3sinθ). The point (5,3) has θ=0 and we want
to increase that angle by 0.2.

Thus the new point is (2+3cos(0.2),3+3sin(0.2))≈(4.9,3.6).

Now, in the general case, say you have a circle with center (a,b) and radius r.
The position of the initial point is θ radians along the circle from (a+r,b).
The parametric equation for the circle is (x,y)=(a+rcosθ,b+rsinθ).
Say you want to increase by ϕ radians. Then the new point is (a+rcos(θ+ϕ),b+rsin(θ+ϕ))
]]--


minetest.register_tool("jetpack:jet", {
  description = "Jetpack",
  inventory_image = "jetpack_jet_inv.png",
  wield_image = "jetpack_jet_inv.png",
        voltbuild = {max_charge = 30000,
                max_speed = 600,
                charge_tier = 1},
        documentation = {summary="Electric jetpack.\n"..
                "You can fly as high as 128 nodes above with this charged."},
        tool_capabilities =
                {max_drop_level=0,
                groupcaps={fleshy={times={}, uses=1, maxlevel=0}}},
        groups = {fleshy=5, metal=5, blast=-2, armor_use=100},
})

minetest.register_craft({
  output = "jetpack:jet",
  recipe = {
    {"voltbuild:refined_iron_ingot", "voltbuild:advanced_circuit", "voltbuild:refined_iron_ingot"},
    {"voltbuild:refined_iron_ingot", "voltbuild:batbox", "voltbuild:refined_iron_ingot"},
    {"voltbuild:silicon_mesecon", "", "voltbuild:silicon_mesecon"},
  },
})

local need_to_stop = {}

minetest.register_globalstep(function(dtime)
      local players=minetest.get_connected_players()
      for i,player in ipairs(players) do
          local pll = player:get_player_name()
          local pos = player:getpos()
          local inv = player:get_inventory()
          local wstack = inv:get_stack("torso",1)
          local wstackn = wstack:get_name()
          if wstack:is_empty() or wstackn~='jetpack:jet' then
              --print('no pack')
              if need_to_stop[pll] then
                 local ph = default.player_physics[pll]
                 default.ph_override(player, {gravity=1,speed=ph.speed/1.2})
              need_to_stop[pll] = nil
              end
              return
          end
          pos.y = pos.y-1
          local node = minetest.registered_nodes[minetest.get_node(pos).name]
          local stack = wstack:to_table()
          local chr = charge.get_charge(stack)
          local max_charge = get_item_field(stack.name, "max_charge")
          if chr>10 then
              if isghost and not isghost[pll] then
                  if node and not node.walkable and wstackn=='jetpack:jet' and pos.y<128 then
                     if player:get_player_control().jump then
                        default.player_vw[pll] = 0 
                          if not need_to_stop[pll] then
                             local ph = default.player_physics[pll]
                             default.ph_override(player, {gravity=-0.4,speed=(ph.speed or 1) * 1.2})
                             need_to_stop[pll] = true
                          else
                             default.ph_override(player, {gravity=-0.4})
                          end
                          local nchr = math.max(1,chr-5)
                          charge.set_charge(stack,nchr)
                          charge.set_wear(stack,nchr,max_charge)
                          inv:set_stack("torso",1,stack)
                     else
                          --print('lessened gravity')
                          if not need_to_stop[pll] then
                             local ph = default.player_physics[pll]
                             default.ph_override(player, {gravity=0.4,speed=(ph.speed or 1) * 1.2})
                             need_to_stop[pll] = true
                          else
                             default.ph_override(player, {gravity=0.4})
                          end
                          local nchr = math.max(1,chr-2)
                          charge.set_charge(stack,nchr)
                          charge.set_wear(stack,nchr,max_charge)
                          inv:set_stack("torso",1,stack)
                     end
                  end
              end
          else
              if need_to_stop[pll] then
              default.ph_override(player, {gravity=1,speed=ph.speed/1.2})
              need_to_stop[pll] = nil
              end
          end
      end
end)

print('[OK] Jetpack loaded')

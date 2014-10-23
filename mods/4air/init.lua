local air_hud = {}

minetest.register_on_joinplayer(function(player)
  if player then
     local pll = player:get_player_name()
     air_hud[pll] = 0
     minetest.after(0, function()
     -- add hunger hud background
     air_hud[pll]=player:hud_add({
        hud_elem_type = "statbar",
        position = {x=0.5,y=1},
        direction=1,
        text = "air_bubble.png",
        number = max_drumsticks,
        alignment = {x=-1,y=-1},
        offset = {x=12, y=-80},
     })
     player:hud_set_flags({breathbar = false})

     end)
  end
end)

minetest.after(0.1, function()
      minetest.register_globalstep(function(dtime)
        local players = minetest.get_connected_players()
        for i,player in ipairs(players) do
            local pll = player:get_player_name()
            local air = player:get_breath()
            if not air or air > 10 then air = 0 end
            if air_hud[pll] then player:hud_change(air_hud[pll], "number", air*2) end
        end
      end)
end)

print('[OK] 4air loaded')

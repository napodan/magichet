player_running_physics = {}
minetest.register_globalstep(function(dtime)
	for _,player in ipairs(minetest.get_connected_players()) do
		--local pos = player:getpos()
		--print(dump(player:get_player_control().up))
		if player:get_player_control().up == true and player_running_physics[player:get_player_name()] == nil then
			minetest.after(0.10, function()
				if player:get_player_control().up == false then
					minetest.after(0.10, function()
						if player:get_player_control().up == true then
						    local pll = player:get_player_name()
						    if not isghost[pll] then
                                player:set_physics_override({ 
                                                speed = 1.7, -- multiplier to default value
                                                jump = 1.0, -- multiplier to default value
                                                gravity = 1.0, -- multiplier to default value
                                                sneak = true, -- whether player can sneak
                                                sneak_glitch = false, -- whether player can use the sneak glitch
                                               })							
							else
                                player:set_physics_override({ 
                                                speed = 1, -- multiplier to default value
                                                jump = 1.1, -- multiplier to default value
                                                gravity = 0.2, -- multiplier to default value
                                                sneak = false, -- whether player can sneak
                                                sneak_glitch = true, -- whether player can use the sneak glitch
                                               })							
							end
							player_running_physics[player:get_player_name()] = true
							
						end
					end)
				end
			end)
		elseif player:get_player_control().up == false and player_running_physics[player:get_player_name()] == true then
			--minetest.after(0.2, function()
				if player:get_player_control().up == false then
					player_running_physics[player:get_player_name()] = nil
						    local pll = player:get_player_name()
						    if not isghost[pll] then
                                player:set_physics_override({ 
                                                speed = 1.0, -- multiplier to default value
                                                jump = 1.0, -- multiplier to default value
                                                gravity = 1.0, -- multiplier to default value
                                                sneak = true, -- whether player can sneak
                                                sneak_glitch = false, -- whether player can use the sneak glitch
                                               })							
							else
                                player:set_physics_override({ 
                                                speed = 0.5, -- multiplier to default value
                                                jump = 1.05, -- multiplier to default value
                                                gravity = 0.1, -- multiplier to default value
                                                sneak = false, -- whether player can sneak
                                                sneak_glitch = true, -- whether player can use the sneak glitch
                                               })							
							end
					
				end
			--end)
		end
		
	end
end)

print('[OK] Sprint loaded')

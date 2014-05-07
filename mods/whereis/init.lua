 
minetest.register_chatcommand("whereis", {
	params = "<имя игрока>",
	description = "Сообщает, где на ходится игрок",
	func = function (name, param)
		local player = minetest.get_player_by_name(param)
		
		if ( player == nil ) then
			minetest.chat_send_player(name,param.." вообще-то не в сети!")
			return false
		end
		
		local playerPos = player:getpos()
		playerPos.x = math.floor(playerPos.x)
		playerPos.y = math.floor(playerPos.y)
		playerPos.z = math.floor(playerPos.z)
		
		local me = minetest.get_player_by_name(name)
		local mePos = me:getpos()
		
		local distance = math.floor(math.sqrt( (mePos.x - playerPos.x)^2 + (mePos.y - playerPos.y)^2 + (mePos.z - playerPos.z)^2 ))
		
		minetest.chat_send_player(name, player:get_player_name().." сейчас в точке "..minetest.pos_to_string(playerPos)..". Это где-то в "..tostring(distance).." блоках отсюда")
	end
})

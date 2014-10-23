----------------------------------
--- restrictions mod by 4aiman ---
----------------------------------
--                              --
--    Restricst the power of    --
-- give and giveme chatcommands --
--                              --
--           (GPLv3)            --
--                              --
----------------------------------

prohibited_items = {} -- a table with all prohibited items to give to anyone

minetest.after(1,function()
   for _,def in pairs(minetest.registered_items) do
       local enlist = false
       if def.groups.not_in_creative_inventory then enlist = true end -- prohibition of any unwanted items
       if def.groups.not_in_craft_guide        then enlist = true end -- prohibition of any unwanted items
       if def.liquidtype                       then enlist = true end -- prohibition of any liquid (includes cobweb)
       if def.name:find('fire')                then enlist = true end -- prohibition of flames & fire
       if def.name:find('tnt')                 then enlist = true end -- prohibition of tnt

       if enlist then table.insert(prohibited_items,def.name) end     -- store any matches 
   end
end
)


local function handle_give_command(cmd, giver, receiver, stackstring)
	minetest.log("action", giver .. " invoked " .. cmd
			.. ', stackstring="' .. stackstring .. '"')
	local itemstack = ItemStack(stackstring)
	if itemstack:is_empty() then
		return false, "Can\'t give an empty item"
	elseif not itemstack:is_known() then
		return false, "Can\'t give an unknown item"
	end
	local receiverref = minetest.get_player_by_name(receiver)
	if receiverref == nil then
		return false, receiver .. " is not a known player"
	end
	local leftover = receiverref:get_inventory():add_item("main", itemstack)
	if leftover:is_empty() then
		partiality = ""
	elseif leftover:get_count() == itemstack:get_count() then
		partiality = "couldn\'t be "
	else
		partiality = "partially "
	end
	-- The actual item stack string may be different from what the "giver"
	-- entered (e.g. big numbers are always interpreted as 2^16-1).
	stackstring = itemstack:to_string()
	if giver == receiver then
		return true, ("%q %sadded to inventory.")
				:format(stackstring, partiality)
	else
		minetest.chat_send_player(receiver, ("%q %sadded to inventory.")
				:format(stackstring, partiality))
		return true, ("%q %sadded to %s's inventory.")
				:format(stackstring, partiality, receiver)
	end
end

minetest.register_chatcommand("give", {
	params = "<name> <ItemString>",
	description = "give item to player",
	privs = {give=true},
	func = function(name, param)
		local toname, itemstring = string.match(param, "^([^ ]+) +(.+)$")
		if not toname or not itemstring then
			return false, "Name and ItemString required"
		end
                local really = true
                for _,item in ipairs(prohibited_items) do
                    if item == itemstring then really = false break end
                end
                if really then
		   return handle_give_command("/give", name, toname, itemstring)
                else
                   minetest.chat_send_player(name, 'There\'s no way you can cheat getting a(an) "'..itemstring..'"')
                   minetest.log(name..' tried to give '..toname..' '..itemstring)
                   return false
                end
	end,
})

minetest.register_chatcommand("giveme", {
	params = "<ItemString>",
	description = "give item to yourself",
	privs = {give=true},
	func = function(name, param)
		local itemstring = string.match(param, "(.+)$")
		if not itemstring then
			return false, "ItemString required"
		end
                local really = true
                for _,item in ipairs(prohibited_items) do
                    if item == itemstring then really = false break end
                end
                if really then
		   return handle_give_command("/giveme", name, name, itemstring)
                else
                   minetest.chat_send_player(name, 'There\'s no way you can cheat getting a(an) "'..itemstring..'"')
                   minetest.log(name..' tried to get '..itemstring)
                   return false
                end
        end,
})
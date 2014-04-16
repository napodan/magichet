strs={}

function strs:starts(Str,Start)
	return string.sub(Str,1,string.len(Start))==Start
end

function strs:ends(String,End)
   return End=='' or string.sub(String,-string.len(End))==End
end

function strs:rem_from_start(Str,Start)
	return string.sub(Str,string.len(Start)+1)
end

function strs:rem_from_end(Str,End)
	return string.sub(Str, string.len(Str) - string.len(End))
end

function strs:comparetables(t1, t2)
	if t1==nil or t2==nil then return false end
	if #t1 ~= #t2 then return false end
	for i=1,#t1 do
		if t1[i] ~= t2[i] then return false end
	end
	return true
end

function strs:keys(t1, t2)
	if t1==nil or t2==nil then return false end
	if #t1 ~= #t2 then return false end
	for name,value in pairs(t1) do
		if t1[name] ~= t2[name] then return false end
	end
	return true
end

function strs:inarray(s, t1)
	if t1==nil or s==nil then return false end
	for index,value in pairs(t1) do
		if s == value or s==index then return true end
	end
	return false
end

function strs:inarray_table(s, t1)
	if t1==nil or s==nil then return false end
	for index,value in pairs(t1) do
		if strs:comparetables(value,t1)==true then return true end
	end
	return false
end


--------------------------------------------------------------


--worldprefs = {
--	private_data = {
--		settingsData = {
--		},
--	},
--	get_value = function(name)
--		return worldprefs.private_data.settingsData[name]
--	end,
--}
--
--local path = minetest.get_worldpath() .. "/worldprefs.txt"
--
--if io.open(path, "r") == nil then
--	io.output(path)
--	io.write("") -- minetest.serialize({ok = "true"})
--else
--	io.input(path)
--	local size = 2^13      -- good buffer size (8K)
--	while true do
--		local block = io.read(size)
--		if not block then break end
--		buffer = buffer .. block
--	end
--	
--	local table = minetest.deserialize(buffer)
--	if table~=nil then
--		worldprefs.private_data.settingsData = table
--	end
--end
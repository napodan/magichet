local itest_world_upgrade = minetest.setting_getbool("voltbuild_itest_world_upgrade") or false
local generate_docs = minetest.setting_getbool("voltbuild_generate_docs")

modpath = minetest.get_modpath("voltbuild")
moreores_path = minetest.get_modpath("moreores")
pipeworks_path = minetest.get_modpath("pipeworks")

voltbuild = {}
voltbuild.registered_ores = {}
--enables more assert checks
voltbuild.debug = false
--upgrades nodes in their abm to reset their energy and max energy
voltbuild.upgrade = true or itest_world_upgrade

function voltbuild.register_ore(name,value)
	voltbuild.registered_ores[name]=value
end

function voltbuild_create_infotext(name)
	return(string.gsub(string.sub(name,string.find(name,":")+1),"_"," "))
end

function voltbuild_hacky_swap_node(pos,name)
	local node = minetest.env:get_node(pos)
	local meta = minetest.env:get_meta(pos)
	if node.name == name then
		return
	end
	node.name = name
	local meta0 = meta:to_table()
	minetest.env:set_node(pos,node)
	meta = minetest.env:get_meta(pos)
	meta:from_table(meta0)
	meta:set_string("infotext",voltbuild_create_infotext(node.name))
end

function addVect(pos1,pos2)
	return {x=pos1.x+pos2.x,y=pos1.y+pos2.y,z=pos1.z+pos2.z}
end

function param22dir(param2)
	if param2==0 then
		return {x=1,y=0,z=0}
	elseif param2==1 then
		return {x=0,y=0,z=-1}
	elseif param2==2 then
		return {x=-1,y=0,z=0}
	else
		return {x=0,y=0,z=1}
	end
end

function get_node_field(name,meta,key,pos)
	if meta == nil then meta = minetest.env:get_meta(pos) end
	if name == nil then name = minetest.env:get_node(pos).name end
	if meta:get_string(key) ~= "" then return meta:get_int(key) end
	if minetest.registered_nodes[name] and
		minetest.registered_nodes[name].voltbuild and
		minetest.registered_nodes[name].voltbuild[key] then
			return minetest.registered_nodes[name].voltbuild[key]
	end
	return minetest.get_item_group(name,key)
end

function get_node_field_float(name,meta,key,pos)
	if meta == nil then meta = minetest.env:get_meta(pos) end
	if name == nil then name = minetest.env:get_node(pos).name end
	if meta:get_string(key) ~= "" then return meta:get_float(key) end
	if minetest.registered_nodes[name] and
		minetest.registered_nodes[name].voltbuild and
		minetest.registered_nodes[name].voltbuild[key] then
			return minetest.registered_nodes[name].voltbuild[key]
	end
	return 0
end

function get_item_field(name,key)
	if minetest.registered_items[name] and
		minetest.registered_items[name].voltbuild and
		minetest.registered_items[name].voltbuild[key] then
			return minetest.registered_items[name].voltbuild[key]
	end
	return minetest.get_item_group(name,key)
end

function is_fuel_no_lava(stack)
	return (minetest.get_craft_result({method="fuel",width=1,items={stack}}).time ~= 0)
		and (string.find(stack:get_name(),"lava")==nil)
end

function clone_node(name)
	node2={}
	node=minetest.registered_nodes[name]
	for k,v in pairs(node) do
		node2[k]=v
	end
	return node2
end

function voltbuild.deep_copy (table_from,table_to)
	local key,value
	for key,value in pairs(table_from) do
		if table_to[key] == nil then
			if type(value) == "table" then
				local deep_value = voltbuild.deep_copy(value,{})
				table_to[key]=deep_value
			else
				table_to[key]=value
			end
		elseif type(table_to[key]) == "table" and type(value) == "table" then
			table_to[key] = voltbuild.deep_copy(value,table_to[key])
		end
	end
	return table_to
end


dofile(modpath.."/builtin.lua")
dofile(modpath.."/mapgen.lua")
dofile(modpath.."/voltbuild_objects.lua")
dofile(modpath.."/components.lua")
dofile(modpath.."/iron_furnace.lua")
dofile(modpath.."/energy_transport.lua")
dofile(modpath.."/cables.lua")
dofile(modpath.."/charge.lua")
dofile(modpath.."/generators.lua")
dofile(modpath.."/storage.lua")
dofile(modpath.."/consumers.lua")
dofile(modpath.."/craft.lua")
if itest_world_upgrade then
	dofile(modpath.."/itest_upgrade_compat.lua")
	print("voltbuild is using one way upgrade")
end
if generate_docs then
	print("Generating voltbuild documentation.")
	local key,value
	local  k, v
	local craft_file = io.open(modpath.."/doc/crafts.txt","w")
	for key, value in pairs(minetest.registered_items) do
		if string.match(key,"voltbuild:") then
			local crafts = minetest.get_all_craft_recipes(key)
			if crafts and #crafts > 0 then
				craft_file:write("output is ",key,"\n")
				craft_file:write("In game description is ",value["description"],"\n")
				local recipe 
				for k,recipe in pairs(crafts) do
					if recipe.type then
						craft_file:write("method is ",recipe.type,"\n")
					end
					if recipe.width == 0 then
						craft_file:write("shapeless is true\n")
						recipe.width=3
					end
					craft_file:write("recipe is\n")
					local height
					for k=1,9 do
						if recipe.items[k] then
							height = math.ceil(k/recipe.width)
						end
					end
					for k=1,recipe.width*height do
						if k % recipe.width == 1 or recipe.width == 1 then
							craft_file:write("   ")
						end
						if recipe.items[k] then
							craft_file:write(recipe.items[k])
						else
							craft_file:write("\"\"")
						end
						if k ~= recipe.width*height then
							craft_file:write(", ")
						end
						if k % recipe.width == 0 then
							craft_file:write("\n")
						end
					end
				end
				craft_file:write("\n\n")
			end
		end
	end
	for key, value in pairs(voltbuild.recipes) do
		for k, v in pairs (value) do 
			--ignore __index and other metatable functions
			if string.find(k,"__") ~= 1 then
				local v_name
				if type(v) == "string" then
					craft_file:write("output is ",v,"\n")
					if not string.find(v," ") then 
						v_name = v
					else
						v_name = string.sub(v,1,string.find(v," ")-1)
					end
				else
					local craft_result,leftover = v(ItemStack(k))
					v_name = craft_result.item:get_name()
					craft_file:write("output is ",v_name,"\n")
				end
				local desc = minetest.registered_items[v_name]["description"]
				craft_file:write("In game description is ",desc,"\n")
				craft_file:write("method is ",key,"\n")
				craft_file:write("recipe is ",k,"\n\n")
			end
		end
	end
	io.close(craft_file)

	local volt_objects = {
	generators = {type_check = function (name,table)
		if table.groups.energy and not table.groups.energy_consumer then
			return true
		end
		return false
	end},
	batboxes = {type_check = function (name,table) 
		if table.groups.energy and table.groups.energy_consumer and table.groups.energy_storage then
			return true
		end
		return false
	end},
	transformers = {type_check = function (name,table)
		if table.groups.energy_consumer and string.match(name,"transformer") then
			return true
		end
		return false
	end},
	tools = {type_check = function(name,table)
		if table.tool_capabilities then
			return true
		end
		return false
	end},
	components = {type_check = function(name,table)
		if table.voltbuild and table.voltbuild.component then
			return true
		end
		return false
	end},
	nuclear_parts = {type_check = function(name,table)
		if table.voltbuild and table.voltbuild.nuclear then
			return true
		end
		return false
	end},
	--consumers goes last in list because easier to define it as not the others
	consumers = {}}
	volt_objects.consumers.type_check = function (name,table)
		local ky, vl
		for ky,vl in pairs(volt_objects) do
			if ky ~= "consumers" then
				if vl.type_check(name,table) then
					return false
				end
			end
		end

		if table.groups.energy_consumer then
			return true
		end
		return false
	end

	for key, value in pairs(minetest.registered_items) do
		if string.match(key,"voltbuild:") and not string.match(key,"_active") then
			for k, v in pairs(volt_objects) do
				if v.type_check(key,value) then
					volt_objects[k][key] = value
				end
			end
		end
	end
	for key, value in  pairs(volt_objects) do
		local doc_file = io.open(modpath.."/doc/"..key..".txt","w")
		local ky,vl
		for ky, vl in  pairs(value) do
			if ky ~= "type_check" and ky ~= "file_summary"  then
				if vl and vl.documentation then
					doc_file:write(ky,"\n")
					if vl.description then
						doc_file:write("In game description is ",vl.description,"\n")
					else
						print("WARNING! "..ky.." does not have description!!!!")
					end
					local required_fields = {"summary"}
					for k,v in pairs(required_fields) do
						if not vl.documentation[v] then
							print("WARNING! "..ky.." does not have documentation."..v.." table!!!!")
						end
					end
					for k, v in pairs(vl.documentation) do
						doc_file:write(string.sub(k,1,1):upper(),string.sub(k,2),":\n")
						doc_file:write(v,"\n")
					end
					doc_file:write("\n")
				else
					print("WARNING! "..ky.." does not have documentation table!!!!")
				end
			end
		end
		io.close(doc_file)
	end
end

print("voltbuild loaded!")

automata = {}
--inventory and list name must be set

local i

function automata.__index (table,key)
	return automata[key]
end

function automata.print_all (self)
	local meta = minetest.env:get_meta(self.pos)
	local inventory = meta:get_inventory()
	local size = inventory:get_size(self.listname)
	for i=1,size do
		print("index: "..i)
		print("value: "..meta:get_int(self.name..i))
	end
end

function automata.clear(self)
	local meta = minetest.env:get_meta(self.pos)
	local inventory = meta:get_inventory()
	local size = inventory:get_size(self.listname)
	for i=1,size do
		meta:set_int(self.name..i,0)
	end
end

function automata.step(self)
	local meta = minetest.env:get_meta(self.pos)
	local inventory = meta:get_inventory()
	local size = inventory:get_size(self.listname)
	local width = inventory:get_width(self.listname)
	for i=0,size do
		local item_name = inventory:get_stack(self.listname,i):get_name()
		local item_definition = minetest.registered_items[item_name]
		if item_definition and item_definition.automata then
			item_definition["automata"]["step"](self.name,self.pos,i)
		end
	end
end

function automata.new(self,pos,listname,automata_name)
	local auto = {}
	setmetatable(auto,self)
	auto.listname = listname
	auto.name = automata_name
	local meta = minetest.env:get_meta(pos)
	local inventory = meta:get_inventory()
	auto.pos = pos
	auto:clear()
	return auto
end

function automata.get(self,pos,listname,automata_name)
	local auto = {}
	setmetatable(auto,self)
	auto.pos = pos
	auto.listname = listname
	auto.name = automata_name
	return auto
end

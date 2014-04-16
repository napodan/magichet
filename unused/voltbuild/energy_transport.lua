function addVect(pos,vect)
	return {x=pos.x+vect.x,y=pos.y+vect.y,z=pos.z+vect.z}
end

adjlist={{x=0,y=0,z=1},{x=0,y=0,z=-1},{x=0,y=1,z=0},{x=0,y=-1,z=0},{x=1,y=0,z=0},{x=-1,y=0,z=0}}

function notdir(tbl,dir)
	tbl2={}
	for _,val in ipairs(tbl) do
		if val.x~=-dir.x or val.y~=-dir.y or val.z~=-dir.z then table.insert(tbl2,val) end
	end
	return tbl2
end

function posintbl(tbl,pos)
	for _,val in ipairs(tbl) do
		if val.x==pos.x and val.y==pos.y and val.z==pos.z then return true end
	end
	return false
end

function voltbuild.blast(pos,intensity)
	if intensity == nil then
		intensity = 1
	end
	local node = minetest.env:get_node(pos)
	local destroy = minetest.registered_nodes[node.name]["on_blast"]
	if destroy and type(destroy) == "function" then
		destroy(pos,intensity)
	else 
		minetest.env:set_node(pos,{name="air"})
	end
end

function voltbuild.blast_all(pos,intensity,range)
	local xVect,yVect,zVect
	for xVect=-range,range do
		for yVect=-range+math.abs(xVect),range-math.abs(xVect) do
			for zVect=-range+math.abs(xVect)+math.abs(yVect),range-math.abs(xVect)-math.abs(yVect) do
				local dir=({x=xVect,y=yVect,z=zVect})
				local node = minetest.env:get_node(addVect(pos,dir))
				local destroy = minetest.registered_nodes[node.name]["on_blast"]
				if destroy and type(destroy) == "function" then
					destroy({x=pos.x+xVect,y=pos.y+yVect,z=pos.z+zVect},intensity)
				else 
					voltbuild.blast({x=pos.x+xVect,y=pos.y+yVect,z=pos.z+zVect},intensity)
				end
			end
		end
	end
end

function round0(x) -- This function removes precision error when using decimal
	if x<=0.000001 and x>=-0.000001 then return 0 end
	return x
end

function send(pos,dir,power,explored)
	if power<=0.000001 then return nil end
	if posintbl(explored,pos) then return nil end
	explored[#explored+1]=pos
	local cnode=minetest.env:get_node(pos)
	local maxcurrent=get_node_field(cnode.name,nil,"max_current",pos)
	local currentloss=get_node_field_float(cnode.name,nil,"current_loss",pos)
	local p=math.ceil(round0(power-currentloss))
	local next=energy_go_next(pos,dir,p)
	local diff = 0
	if not next then
		return nil
	end
	while next do
		if type(next) == "table" then
			next = send(addVect(pos,next),next,p,explored)
			if type(next) == "number" then
				diff = diff + next
			end
			break
		elseif type(next) == "number" then
			if next < 1 then
				break
			else
				diff = diff+next
				p = p-next
			end
			next = energy_go_next(pos,dir,p)
		end
	end
	local meta=minetest.env:get_meta(pos)
	local node = minetest.get_node(pos)
	if node.name ~= "air" then
		local conductor = minetest.registered_nodes[node.name]["voltbuild"]["energy_conductor"]
		if conductor and conductor >= 1 then
			if meta:get_int("get_current")>0 then -- We want to mesure current through cable.
				local c=meta:get_int("current")
				meta:set_int("current",c+p)
			end
			if maxcurrent<power then 
				-- Melt cable
				voltbuild.blast(pos) 
			end
		end
	end
	return diff
end

function send_packet(fpos,dir,psize)
	local conductor=get_node_field(
			minetest.env:get_node(addVect(fpos,dir)).name,nil,"energy_conductor",addVect(fpos,dir))
	local s
	local consumer=get_node_field(minetest.env:get_node(addVect(fpos,dir)).name,nil,"energy_consumer",addVect(fpos,dir))
	local closs=get_node_field_float(
			minetest.env:get_node(addVect(fpos,dir)).name,nil,"current_loss",addVect(fpos,dir))
	if conductor>0 then
		s=send(addVect(fpos,dir),dir,psize,{})
	elseif consumer>0 then
		local npos = addVect(fpos,dir)
		local node = minetest.env:get_node(npos)
		local meta = minetest.env:get_meta(npos)
		if minetest.registered_nodes[node.name].voltbuild then
			local max_energy=get_node_field(node.name,meta,"max_energy")
			local current_energy=meta:get_int("energy")
			local max_psize=get_node_field(node.name,meta,"max_psize")
			local diff = max_energy-current_energy
			if psize>max_psize then
				voltbuild.blast_all(npos,1,1)
				return psize
			elseif diff > 0 then 
				if meta:get_int("energy")+psize > max_energy then
					meta:set_int("energy",max_energy)
					s = diff
					local split_sent = send(fpos,dir,psize-diff,{})
					if split_sent then
						s = s+split_sent
					end
				else
					meta:set_int("energy",meta:get_int("energy")+psize)
					s = psize
				end
				return s
			end
		end
	end
	return s
end

function send_packet_alldirs(pos,power)
	for _,dir in ipairs(adjlist) do
		local s=send_packet(pos,dir,power)
		if s~= nil then
			return s
		end
	end
	return 0
end

function energy_go_next(pos,dir,power)
	local consumers={}
	local cables={}
	local cnode=minetest.env:get_node(pos)
	local cmeta=minetest.env:get_meta(pos)
	local node
	local meta
	local conductor
	local consumer
	local n
	local can_go
	if minetest.registered_nodes[cnode.name] and
		minetest.registered_nodes[cnode.name].voltbuild and
		minetest.registered_nodes[cnode.name].voltbuild.can_go then
			can_go=minetest.registered_nodes[cnode.name].voltbuild.can_go(pos,node,dir)
	else
		can_go=notdir(adjlist,dir) -- We don't want to go back
	end
	for _,vect in ipairs(can_go) do
		npos=addVect(pos,vect)
		node=minetest.env:get_node(npos)
		consumer=minetest.get_item_group(node.name,"energy_consumer")
		conductor=minetest.get_item_group(node.name,"energy_conductor")
		meta=minetest.env:get_meta(npos)
		if consumer==1 then
			if minetest.registered_nodes[node.name].voltbuild  then
				local max_energy=get_node_field(node.name,meta,"max_energy")
				local current_energy=meta:get_int("energy")
				local max_psize=get_node_field(node.name,meta,"max_psize")
				if power>max_psize then
					local i=#consumers+1
					consumers[i]={}
					consumers[i].pos=npos
					consumers[i].vect=vect
					consumers[i].overcharge=true
				elseif max_energy-current_energy > 0 then
					local i=#consumers+1
					consumers[i]={}
					consumers[i].pos=npos
					consumers[i].vect=vect
				end
			end
		elseif conductor==1 then
			local i=#cables+1
			cables[i]={}
			cables[i].pos=npos
			cables[i].vect=vect
		end
	end
	if consumers[1]==nil then
		if cables[1]==nil then
			return 0
		else
			local i=#cables
			n=(cmeta:get_int("cdir"))%i+1
			cmeta:set_int("cdir",n)
			return cables[n].vect
		end
	else -- Always try to send to a consumer first
		local i=#consumers
		n=(cmeta:get_int("cdir"))%i+1
		cmeta:set_int("cdir",n)
		if consumers[n].overcharge then
			voltbuild.blast_all(consumers[n].pos,1,1)
			return power
		end
		local meta=minetest.env:get_meta(consumers[n].pos)
		local name = minetest.get_node(consumers[n].pos)["name"]
		local max_energy = get_node_field(name,meta,"max_energy")
		if meta:get_int("energy")+power > max_energy then
			local surplus = (meta:get_int("energy")+power) - max_energy
			cmeta:set_int("energy",cmeta:get_int("energy")+surplus)
			meta:set_int("energy",max_energy)
			return power-surplus
		else
			meta:set_int("energy",meta:get_int("energy")+power)
		end
		return power
	end
end

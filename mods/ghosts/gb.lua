
local do_dig_node = minetest.node_dig
function minetest.node_dig(pos, node, digger)
   if digger~= nil and digger:is_player() then
      local pll=digger:get_player_name()
       if not isghost[pll] or check_for_ghost_tool(digger) then
        --  minetest.debug('not a ghost')
          local ent = minetest.add_entity(pos, "ghosts:ghostly_block")
           if ent then
              ent2=ent:get_luaentity()
              ent2.destroyer = pll
              ent2.node = node
              do_dig_node(pos, node, digger)
                  if  g_blocks_count[pll] == nil
                  then g_blocks_count[pll] = 0
                  else g_blocks_count[pll] = g_blocks_count[pll] + 1
                  end
              local node_textures = minetest.registered_nodes[node.name].tiles
              if #node_textures<6 then
                 for i=#node_textures+1,6 do
                     node_textures[i]=node_textures[i-1]
                 end
              end
              ent2.textures = node_textures
              ent2.object:set_properties({textures=node_textures})

              local drawtype = minetest.registered_nodes[node.name].drawtype
         --[[     if drawtype == 'plantlike' then
                 ent2.visual = "mesh"
                 ent2.mesh   = "plantlike.x"
                 ent2.object:set_properties({visual=ent2.visual, mesh=ent2.mesh})
              else]]
                 ent2.visual = "cube"
                 ent2.object:set_properties({visual=ent2.visual})
              --end

              return pos, node, digger
             -- minetest.debug('on dig:\n' .. ent2.destroyer .. '\n' .. minetest.serialize(ent2.node))
           end
       end

   else
  --- minetest.debug('a ghost')
    return --true,true,true
   end

end

local item_place_node = minetest.item_place_node
function minetest.item_place_node(itemstack, placer, pointed_thing)

    if placer and placer:is_player() then
       local pll = placer:get_player_name()
       if isghost[pll] then return end

        if pointed_thing.type ~= 'nothing' then
           if pointed_thing.type == 'node' then
              pos = pointed_thing.above
              else return
           end
           else return
        end
        if not isghost[pll] or check_for_ghost_tool(digger) then
           local meta = minetest.get_meta(pos)
           meta:set_string("creator",placer_name)
           item_place_node(itemstack, placer, pointed_thing)
        end
    end
    return itemstack, placer, pointed_thing
end

local gblock = {
    hp =1,
    physical = false,
    collisionbox = {-0,-0,-0, 0,0,0},
    visual = "cube",
    textures = {"default_cloud.png",
                "default_cloud.png",
                "default_cloud.png",
                "default_cloud.png",
                "default_cloud.png",
                "default_cloud.png",
                },
    use_texture_alpha = true,
    visual_size = {x=0.0, y=0.0, z = 0.0},
    digger = nil,

    size = 0,
    tag = 0,  -- what for? dunno...
    in_prg = 0,
    is_visible = true,
    makes_footstep_sound = false,
    groups = {punch_operable=0, fleshy=0, crumbly=1},
    destroyer='',
    creator='',
    infotext='gb',
    node={},
    stack_max = 32000,

    on_activate = function(self, staticdata, dtime_s)
        if staticdata then
            local tmp = minetest.deserialize(staticdata)
            if tmp and tmp.textures then
                self.textures = tmp.textures
                self.object:set_properties({textures=self.textures})
            end
            if tmp and tmp.digger then
                self.digger = tmp.digger
            end
            if tmp and tmp.visual then
                self.visual = tmp.visual
                self.object:set_properties({visual=self.visual})
            end
            if tmp and tmp.mesh then
                self.mesh = tmp.mesh
                self.object:set_properties({mesh=self.mesh})
            end
            if tmp and tmp.destroyer then
               self.destroyer = tmp.destroyer
            end
        end

    end,

    get_staticdata = function(self)
        local tmp = {
            textures = self.textures,
            digger = self.digger,
            visual = self.visual,
            mesh = self.mesh,
            destroyer = self.destroyer,
        }
        return minetest.serialize(tmp)
    end,
}


function gblock:on_rightclick(clicker)
    if not clicker or not clicker:is_player() then
        return
    end
   -- pickup only your stuff
    if clicker:get_player_name() == self.destroyer then
       local inv = clicker:get_inventory()
       if inv then
          self.object:remove()
          inv:add_item("main", "ghosts:ghostly_block")
       end
    end
end



function gblock:on_punch(puncher, time_from_last_punch, tool_capabilities, dir)
  -- we don't want to do anything for non-player puncher...
   if (not puncher) or not (puncher:is_player()) then
      return
   end

   local tool = puncher:get_wielded_item()
   -- with your bare hands? noooo!!!
   if tool:is_empty() then
   return
   end
   local toolname = tool:get_name()
   if toolname:find('ghosttool') then
-----------------------------------------------
   end
end

function gblock:on_step(dtime)

   local pos = self.object:getpos()
   local radius = 5
   local found_player = false
   local surroundings = minetest.get_objects_inside_radius(pos, radius)
   for i,player in ipairs (surroundings) do
       if player:is_player() and isghost[player:get_player_name()] then
          found_player=true
          break
       end
   end
   if (self.size == 0) or (self.size==1) then self.in_prg = 0 end

   if (found_player == true) and (self.size<1) then
            local arm = self.object--:get_luaentity()
            local modifier
            if self.visual == "mesh" then modifier = 4 else modifier = 0 end
            local prop = {visual_size = {x=0.9995+modifier, y=0.9995+modifier, z = 0.9995+modifier},
                          collisionbox = {-0.5,-0.5,-0.5, 0.5,0.5,0.5},
                          physical = true,}
            arm:set_properties(prop)
            self.size = 1
   end

   if (found_player == false) and (self.size>0) then
            local arm = self.object--:get_luaentity()
            local prop = {visual_size = {x=0, y=0, z = 0},
                          collisionbox = {-0,-0,-0, 0,0,0},
                          physical = false,}
            arm:set_properties(prop)
            self.size = 0
   end
end


minetest.register_craftitem("ghosts:ghostly_block", {
    description = "Ghostly Block Generic",
    inventory_image = "default_cloud.png",
    wield_image = "gb_0.png",
    wield_scale = {x=1, y=1, z=1},
    liquids_pointable = false,
    stack_max = 32000,

    on_place = function(itemstack, placer, pointed_thing)
        --[[if pointed_thing.type ~= "node" then
            return
        end]]--
        local ent = minetest.add_entity(pointed_thing.above, "ghosts:ghostly_block")
        --minetest.item_place_node(itemstack,placer,pointed_thing)
        local ent2 = ent:get_luaentity()
        if placer and placer:is_player() and ent2 then ent2.destroyer = placer:get_player_name() end
        itemstack:take_item()
        return itemstack
    end,
})


minetest.register_node("ghosts:ectoplasm", {
    description = "Ectoplasm",
    tiles = {"ghosts_ectoplasm.png"},
    inventory_image = "ghosts_ectoplasm_w.png",
    wield_image = "ghosts_ectoplasm_w.png",
    drawtype = "nodebox",
    sunlight_propagates = true,
    paramtype = "light",
    use_texture_alpha = true,
    groups = {oddly_breakable_by_hand=1},
    buildable_to = true,
    node_box = {
        type = "fixed",
        fixed = {
            {-0.52, -0.48, -0.52, 0.52, -1.48, 0.52}
        },
    },
    selection_box = {
        type = "fixed",
        fixed = {
            {-0.5, -0.5, -0.5, 0.5, -0.475, 0.5}
        },
    },
    on_use = minetest.item_eat(1)
})


minetest.register_tool("ghosts:ghosttool_2000", {
    description = "Ghost Tool 2000",
    inventory_image = "default_tool_mesepick.png",
    tool_capabilities = {
        full_punch_interval = 0.1,
        max_drop_level=3,
        groupcaps={
            cracky={times={[1]=0.1, [2]=0.1, [3]=0.1}, uses=2000, maxlevel=3},
            crumbly={times={[1]=0.1, [2]=0.1, [3]=0.1}, uses=2000, maxlevel=3},
            snappy={times={[1]=0.1, [2]=0.1, [3]=0.1}, uses=2000, maxlevel=3}
        }
    },
})

function check_for_ghost_tool(digger)
    if digger and digger:is_player() then
        local wi = digger:get_wielded_item()
        if not wi then return false end
        local nm = wi:get_name()
        if nm:find('ghosttool') then
           return true
        else return false
        end
    end
    return false
end


minetest.register_entity("ghosts:ghostly_block", gblock)

minetest.register_craft({
    output = 'ghosts:ghostly_block',
    recipe = {
        {'ghosts:ectoplasm', 'ghosts:ectoplasm'},
        {'ghosts:ectoplasm', 'ghosts:ectoplasm'},
    }
})

minetest.register_craft({
    cooktime = 3,
    type = 'cooking',
    output = 'ghosts:ectoplasm 2',
    recipe = "ghosts:ghostly_block",
})

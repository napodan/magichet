local tdc = {
    --hp =1,
    physical = true,
    collisionbox = {-0.5001,-0.5001,-0.5001, 0.5001,0.5001,0.5001},
    visual = "mesh",
    visual_size = {x=5, y=5, z=5},
    mesh = "chest_proto.x",
    --mesh = "character.x",
    textures = {"default_chest3d.png"},
    digger = nil,
    makes_footstep_sound = true,
    groups = {punch_operable=0, choppy=default.dig.wood},
    --on_punch = function(self, hitter)
    --   print('add cracks to simulate digging')
    --end,
    on_activate = function(self, staticdata, dtime_s)
        if staticdata then
            local tmp = minetest.deserialize(staticdata)
            if tmp and tmp.textures then
                self.textures = tmp.textures
                self.object:set_properties({textures=self.textures})
            end
            if tmp and tmp.visual then
                self.visual = tmp.visual
                self.object:set_properties({visual=self.visual})
            end
            if tmp and tmp.mesh then
                self.mesh = tmp.mesh
                self.object:set_properties({mesh=self.mesh})
            end
        end

    end,

    get_staticdata = function(self)
        local tmp = {
            textures = self.textures,
            visual = self.visual,
            mesh = self.mesh,
        }
        return minetest.serialize(tmp)
    end,
    on_rightclick = function (self, clicker)
       local pos = self.object:getpos()
       --pos.y=pos.y-1
       local meta = minetest.get_meta(pos)
       local name = '3dchests:3dchest'
       local pll = clicker:get_player_name()
       local formspec = "size[9,7.2]"..
            "bgcolor[#bbbbbb;false]"..
            "listcolors[#777777;#cccccc;#333333;#555555;#dddddd]"..

            "image_button[9.0,-0.3;0.80,1.7;b_bg2.png;just_bg;Z;true;false]"..
            "image_button[9.2,-0.2;0.5,0.5;b_bg.png;sort_horz;=;true;true]"..
            "image_button[9.2,0.3;0.5,0.5;b_bg.png;sort_vert;||;true;true]"..
            "image_button[9.2,0.8;0.5,0.5;b_bg.png;sort_norm;z;true;true]"..

            "list[nodemeta:"..pos.x..","..pos.y..","..pos.z..";main;0,0;9,3;]"..

            "list[current_player;main;0,3.2;9,3;9]"..
            "list[current_player;main;0,6.4;9,1;]"
       self.object:set_animation({x=10,y=25}, 20, 0)
       self.object:set_animation({x=25,y=25}, 20, 0)
       minetest.sound_play('chestopen', {pos = pos, gain = 0.3, max_hear_distance = 5})
       minetest.show_formspec(pll, name..'_'..minetest.serialize(pos), formspec)
    end,--[[
    on_receive_fields = function(pos, formname, fields, sender)
       if sender and sender:is_player() then
          default.sort_inv(sender,formname,fields,pos)
       end
    end,]]
}

minetest.register_entity('3dchests:3dchest', tdc)

minetest.register_craftitem('3dchests:3dchest', {
    description = "Chest",
    inventory_image = "default_chest_front.png",
    wield_image = "default_chest_front.png",
    wield_scale = {x=1, y=1, z=1},
    liquids_pointable = false,

    on_place = function(itemstack, placer, pointed_thing)
        --[[if pointed_thing.type ~= "node" then
            return
        end]]--
        local ent = minetest.add_entity(pointed_thing.under, '3dchests:3dchest')
        --minetest.item_place_node(itemstack,placer,pointed_thing)
        local ent2 = ent:get_luaentity()
        ent:set_animation({x=1,y=1}, 20, 0)
        local dir = placer:get_look_dir()
        local absx, absy, absz = math.abs(dir.x), math.abs(dir.y), math.abs(dir.z)
        local maxd = math.max(math.max(absx,absy),absz)
        if maxd == absx then
           if dir.x>0 then
              ent:setyaw(math.pi/2)
           else
              ent:setyaw(3*math.pi/2)
           end
        elseif maxd == absy then
           if dir.x>dir.z then
              ent:setyaw(math.pi)
           else
              ent:setyaw(3*math.pi/2)
           end
        elseif maxd == absz then
           if dir.z>0 then
              ent:setyaw(math.pi)
           else
              ent:setyaw(0)
           end
        end


        itemstack:take_item()
        return itemstack
    end,
})

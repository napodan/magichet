-- Skins mod for minetest
-- Adds a skin gallery to the inventory, using inventory_plus
-- Released by Zeg9 under WTFPL
-- Have fun !
-- changes by 4aiman (compatibility with ghosts)

skins = {}
skins.type = { SPRITE=0, MODEL=1 }

skins.skins = {}
skins.default = function()
    return "character_1"
end

skins.get_type = function(texture)
    if not texture then return end
    if texture:find("character") then return skins.type.MODEL end
    if texture:find("player") then return skins.type.SPRITE end
    return skins.type.SPRITE

end

skins.modpath = minetest.get_modpath("skins")
dofile(skins.modpath.."/skinlist.lua")
dofile(skins.modpath.."/meta.lua")
dofile(skins.modpath.."/players.lua")

skins.update_player_skin = function(player)
    name = player:get_player_name()
        --minetest.debug(minetest.serialize(skins.skins[name]))
    if skins.get_type(skins.skins[name]) == skins.type.SPRITE then
      -- print('set skin as sprite') --  minetest.debug('goooooooooooooooooooooooooooooo')
        local prop = {
            visual = "upright_sprite",
            textures = {skins.skins[name]..".png",skins.skins[name].."_back.png"},
            visual_size = {x=1, y=2},
        }
        player:set_properties(prop)
           --     minetest.debug(skins.skins[name]..".png; ".. skins.skins[name].."_back.png")
    end
    if skins.get_type(skins.skins[name]) == skins.type.MODEL then
      -- print('set skin as model')
        player:set_properties({
            visual = "mesh",
            textures = {skins.skins[name]..".png"},
            visual_size = {x=1, y=1},
        })
    end
    if minetest.get_modpath("3d_armor") then
        if skins.get_type(skins.skins[name]) == skins.type.MODEL then
            armor.textures[name].skin = skins.skins[name]..".png"
            armor:update_player_visuals(player)
                 --  else
        --         print('armor!')
        end
    end
    skins.save()
end

local file_exists = function(name)
   local f=io.open(name,"r")
   if f~=nil then io.close(f) return true else return false end
end

skins.formspec = {}
skins.formspec.main = function(name)
    page = skins.pages[name]
    if page == nil then page = 0 end
    local formspec = "size[8,7.5]"..
                "bgcolor[#bbbbbb;false]"..
            "listcolors[#777777;#cccccc;#333333;#555555;#dddddd]"..

            "button[6.6,-0.0;0.8,0.5;sort_horz;=]"..
            "button[7.4,-0.0;0.8,0.5;sort_vert;||]"..
            "button[8.2,-0.0;0.8,0.5;sort_norm;Z]"

        .. "button[0,0;2,.5;main;Back]"
    if skins.get_type(skins.skins[name]) == skins.type.MODEL then
        local pre = file_exists(skins.skins[name].."_preview.png")
        if pre then
        formspec = formspec
            .. "image[0,.75;1,2;"..skins.skins[name].."_preview.png]"
            .. "image[1,.75;1,2;"..skins.skins[name].."_preview_back.png]"
            .. "label[6,.5;Texture:]"
            .. "image[6,1;2,1;"..skins.skins[name]..".png]"
        else
        formspec = formspec
            .. "label[6,.5;Texture:]"
            .. "image[6,1;2,1;"..skins.skins[name]..".png]"
        end

    else
        formspec = formspec
            .. "image[0,.75;1,2;"..skins.skins[name]..".png]"
            .. "image[1,.75;1,2;"..skins.skins[name].."_back.png]"
    end
    local meta = skins.meta[skins.skins[name]]
    if meta then
        if meta.name then
            formspec = formspec .. "label[1.5,.5;Name: "..meta.name.."]"
        end
        if meta.author then
            formspec = formspec .. "label[2,1;Author: "..meta.author.."]"
        end
        if meta.description then
            formspec = formspec .. "label[2,1.5;"..meta.description.."]"
        end
        if meta.comment then
            formspec = formspec .. 'label[2,2;"'..meta.comment..'"]'
        end
    end
    local index = 0
    local skip = 0 -- Skip skins, used for pages
    for i, skin in ipairs(skins.list) do
        if skip < page*16 then skip = skip + 1 else
            if index < 16 then
                formspec = formspec .. "image_button["..(index%8)..","..((math.floor(index/8))*2+3)..";1,2;"..skin
                if skins.get_type(skin) == skins.type.MODEL then
                    formspec = formspec .. "_preview"
                end
                formspec = formspec .. ".png;skins_set_"..i..";]"
            end
            index = index +1
        end
    end
    if page > 0 then
        formspec = formspec .. "button[0,7;1,.5;skins_page_"..(page-1)..";<<]"
    else
        formspec = formspec .. "button[0,7;1,.5;skins_page_"..page..";<<]"
    end
    formspec = formspec .. "button[.75,7;6.5,.5;skins_page_"..page..";page "..(page+1).."/"..math.floor(#skins.list/16+1).."]" -- a button is used so text is centered
    if index > 16 then
        formspec = formspec .. "button[7,7;1,.5;skins_page_"..(page+1)..";>>]"
    else
        formspec = formspec .. "button[7,7;1,.5;skins_page_"..page..";>>]"
    end
    return formspec
end

skins.pages = {}


minetest.register_on_joinplayer(function(player)
    if not skins.skins[player:get_player_name()] then
        skins.skins[player:get_player_name()] = skins.default()
    end
    skins.update_player_skin(player)
    inventory_plus.register_button(player,"skins","Skin")
end)

minetest.register_on_player_receive_fields(function(player,formname,fields)
    if fields.skins then
           if player and not isghost[player:get_player_name()] then
        inventory_plus.set_inventory_formspec(player,skins.formspec.main(player:get_player_name()))
           end
    end
if player --[[and not isghost[player:get_player_name()] ]]then
    for field, _ in pairs(fields) do
            if _ ~= 1 then
        if string.sub(field,0,string.len("skins_set_")) == "skins_set_" then
            print(string.sub(field,string.len("skins_set_")+1))
            print(skins.list[tonumber(string.sub(field,string.len("skins_set_")+1))])
            skins.skins[player:get_player_name()] = skins.list[tonumber(string.sub(field,string.len("skins_set_")+1))]
            skins.update_player_skin(player)
            inventory_plus.set_inventory_formspec(player,skins.formspec.main(player:get_player_name()))
        end
        if string.sub(field,0,string.len("skins_page_")) == "skins_page_" then
            skins.pages[player:get_player_name()] = tonumber(string.sub(field,string.len("skins_page_")+1))
            inventory_plus.set_inventory_formspec(player,skins.formspec.main(player:get_player_name()))
        end
              end
    end
end
end)

print('[OK] Skins loaded')

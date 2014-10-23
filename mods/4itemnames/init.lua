
-----------------------------
-- 4itemnames mod by 4aiman -
-----------------------------
--- license: CC BY-NC 3.0 ---
-----------------------------

-- update: added check for 4air mod (breath bar)
-- update: added check for charged items

local wield={}
local huds={}
local dtimes={}
local dlimit=3  -- hud will be hidden after this much seconds
local airhudmod = minetest.get_modpath("4air")

local function get_desc(item)
    if minetest.registered_nodes[item] then return minetest.registered_nodes[item]["description"] end
    if minetest.registered_items[item] then return minetest.registered_items[item]["description"] end
    if minetest.registered_craftitems[item] then return minetest.registered_craftitems[item]["description"] end
    if minetest.registered_tools[item] then return minetest.registered_tools[item]["description"] end
    return ""
end

minetest.after(2, function(dtime)
       minetest.register_globalstep(function(dtime)
          local players = minetest.get_connected_players()
          for i,player in ipairs(players) do
              local pll = player:get_player_name()
              local wstack = player:get_wielded_item():get_name()
              local shift = player:get_player_control()['sneak']
              local meta = player:get_wielded_item():get_metadata()
              if tonumber(meta) == nil then meta='' end
              local desc
              if not shift then
                 desc = get_desc(wstack)
                 if #meta>0 then desc = desc .. ' ('.. meta ..')' end
              else
                 desc = wstack
              end
              if dtimes[pll] then dtimes[pll]=dtimes[pll]+dtime else dtimes[pll]=0 end
              if dtimes[pll]>dlimit then
                 if player:hud_get(huds[pll]) then player:hud_remove(huds[pll]) end
                 dtimes[pll]=dlimit+1
              end
              if wstack ~= wield[pll] then
                  wield[pll]=wstack
                  dtimes[pll]=0
                 -- if huds[pll]
                 -- then
                      -- player:hud_change(huds[pll], 'text', desc) --doesn't work for me :`(
                       if player:hud_get(huds[pll]) then player:hud_remove(huds[pll])
                       huds[pll] = nil
                       end
                 -- else
                  local off = {x=0, y=-80}
                  if airhudmod then off.y=off.y-20 end
                  huds[pll] = player:hud_add({
                                                 hud_elem_type = "text",
                                                 position = {x=0.5, y=1},
                                                 offset = off,
                                                 alignment = {x=0, y=0},
                                                 number = 0xFFFFFF ,
                                                 text = desc,
                                                })
                 -- end
              end

          end
       end)
end)

print('[OK] 4itemnames loaded')

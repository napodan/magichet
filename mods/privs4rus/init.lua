function minetest.register_privilege(name, param)
    local function fill_defaults(def)
        if def.give_to_singleplayer == nil then
            def.give_to_singleplayer = true
        end
        if def.description == nil then
            def.description = "(нет описание)"
        end
    end
    local def = {}
    if type(param) == "table" then
        def = param
    else
        def = {description = param}
    end
    fill_defaults(def)
    minetest.registered_privileges[name] = def
end

minetest.register_privilege("interact", "Даёт право взаимодействовать с объектами и ломать и строить")
minetest.register_privilege("телепорт", "Позволяет использовать команду /teleportдля телепортации")
minetest.register_privilege("bring", "Позволяет телепортировать других")
minetest.register_privilege("settime", "Даёт право изменять внутриигровое время суток")
minetest.register_privilege("privs", "Даёт право изменять привилегии")
minetest.register_privilege("basic_privs", "Даёт право измнять привилегии 'shout' и 'interact'")
minetest.register_privilege("server", "Позволяет отлаживать сервер")
minetest.register_privilege("shout", "Дает право писать в чат")
minetest.register_privilege("ban", "Даёт право банить и снимать бан")
minetest.register_privilege("kick", "Дат право отключать игроков от сервера")
minetest.register_privilege("give", "Даёт право читерить, используя /give /giveme")
minetest.register_privilege("password", "Позволяет использовать /setpassword и /clearpassword для изменения и удаления пароля")
minetest.register_privilege("fly", {
    description = "Позволяет летать при включённом режиме free_move",
    give_to_singleplayer = false,
})
minetest.register_privilege("fast", {
    description = "Ускоряет персонажа, когда используется режим fast_move",
    give_to_singleplayer = false,
})
minetest.register_privilege("noclip", {
    description = "Позволяет проходить сквозь стены",
    give_to_singleplayer = false,
})
minetest.register_privilege("rollback", "Даёт право откатывать миры")

minetest.register_chatcommand("tp", {
    params = "<X>,<Y>,<Z> | <к_игроку> | <имя> <X>,<Y>,<Z> | <имя> <к_игроку>",
    description = "телепортирует в указанное место",
    privs = {teleport=true},
    func = function(name, param)
        -- Returns (pos, true) if found, otherwise (pos, false)
        local function find_free_position_near(pos)
            local tries = {
                {x=1,y=0,z=0},
                {x=-1,y=0,z=0},
                {x=0,y=0,z=1},
                {x=0,y=0,z=-1},
            }
            for _, d in ipairs(tries) do
                local p = {x = pos.x+d.x, y = pos.y+d.y, z = pos.z+d.z}
                local n = minetest.get_node(p)
                if not minetest.registered_nodes[n.name].walkable then
                    return p, true
                end
            end
            return pos, false
        end

        local teleportee = nil
        local p = {}
        p.x, p.y, p.z = string.match(param, "^([%d.-]+)[, ] *([%d.-]+)[, ] *([%d.-]+)$")
        p.x = tonumber(p.x)
        p.y = tonumber(p.y)
        p.z = tonumber(p.z)
        teleportee = minetest.get_player_by_name(name)
        if teleportee and p.x and p.y and p.z then
            minetest.chat_send_player(name, "Телепортирую в ("..p.x..", "..p.y..", "..p.z..")")
            teleportee:setpos(p)
            return
        end

        local teleportee = nil
        local p = nil
        local target_name = nil
        target_name = string.match(param, "^([^ ]+)$")
        teleportee = minetest.get_player_by_name(name)
        if target_name then
            local target = minetest.get_player_by_name(target_name)
            if target then
                p = target:getpos()
            end
        end
        if teleportee and p then
            p = find_free_position_near(p)
            minetest.chat_send_player(name, "Телепортирую в "..target_name.." at ("..p.x..", "..p.y..", "..p.z..")")
            teleportee:setpos(p)
            return
        end

        if minetest.check_player_privs(name, {bring=true}) then
            local teleportee = nil
            local p = {}
            local teleportee_name = nil
            teleportee_name, p.x, p.y, p.z = string.match(param, "^([^ ]+) +([%d.-]+)[, ] *([%d.-]+)[, ] *([%d.-]+)$")
            p.x = tonumber(p.x)
            p.y = tonumber(p.y)
            p.z = tonumber(p.z)
            if teleportee_name then
                teleportee = minetest.get_player_by_name(teleportee_name)
            end
            if teleportee and p.x and p.y and p.z then
                minetest.chat_send_player(name, "Телепортирую "..teleportee_name.." в ("..p.x..", "..p.y..", "..p.z..")")
                teleportee:setpos(p)
                return
            end

            local teleportee = nil
            local p = nil
            local teleportee_name = nil
            local target_name = nil
            teleportee_name, target_name = string.match(param, "^([^ ]+) +([^ ]+)$")
            if teleportee_name then
                teleportee = minetest.get_player_by_name(teleportee_name)
            end
            if target_name then
                local target = minetest.get_player_by_name(target_name)
                if target then
                    p = target:getpos()
                end
            end
            if teleportee and p then
                p = find_free_position_near(p)
                minetest.chat_send_player(name, "Телепортирую "..teleportee_name.." к "..target_name.." в точку ("..p.x..", "..p.y..", "..p.z..")")
                teleportee:setpos(p)
                return
            end
        end

        minetest.chat_send_player(name, "Неверные параметры (\""..param.."\") или игрок не найден (юзай /help tp)")
        return
    end,
})


local profiles = {}

local fill_info = function(pll)
   local info = minetest.get_player_information(pll)
   profiles[pll].details.ip = info.ip
   profiles[pll].details.ip_version = info.ip_version
   profiles[pll].details.rtt = info.avg_rtt
   profiles[pll].details.jitter = info.avg_jitter
   profiles[pll].details.uptime = info.connection_uptime

   if info.ser_vers then
      profiles[pll].details.serialization = info.ser_vers
      profiles[pll].details.protocol = info.prot_vers
      profiles[pll].details.cl_ver = info.vers_string
   end

end

local save_interval = 60

-- add tech info when logged in
minetest.register_on_joinplayer(function(player)
   local pll = player:get_player_name()
   if not profiles[pll] then
          profiles[pll]={}
          profiles[pll].details={}
          profiles[pll].nick = pll
          profiles[pll].karma = {['server']=1}
   end
   fill_info(pll)
end)

-- on chat message purifier
minetest.register_on_chat_message(function(name, message)
    local cmd, param = string.match(message, "^/([^ ]+) *(.*)")
    if not param then
        param = ""
    end
    local cmd_def = minetest.chatcommands[cmd]
    if cmd_def then
        local has_privs, missing_privs = minetest.check_player_privs(name, cmd_def.privs)
        if has_privs then
            cmd_def.func(name, param)
        else
            minetest.chat_send_player(name, "You don't have permission to run this command (missing privileges: "..table.concat(missing_privs, ", ")..")")
        end
        return true -- handled chat message
    else
        minetest.chat_send_all(name..': '..message)
        return true
    end
end)

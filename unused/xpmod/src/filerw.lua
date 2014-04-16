-- Copyright 2012 Andrew Engelbrecht.
-- This file is licensed under the WTFPL.

-- it is included automatically by init.lua

----------------------------------

-- function definitions:
----------------------------------

-- prints out some default error text, the text passed as a parameter.
-- then the function kills the server.
function xp_parseerr(text)
    print("")
    print("*** xp module error:")
    print("*** error parsing /"..xp_file_name.." file!")
    print("*** ")
    print("*** "..text)
    print("*** ")
    print("*** delete or fix line in "..xp_xplevels_file)
    print("*** ")
    print("")
    os.exit()
end

-- extracts xp/level info per skill type for each user
-- pass it a line from the xp_xplevels_file.
-- it returns the user name and a table of their stats
function xp_parselinev1(line)
    local s,e,ign,spaceonly,laste,name,statstr,stkind,stlevel,stxp,badskl,test
    local stats = {}

    -- grabs any space or or an empty string on a blank line
    ign,ign,spaceonly = string.find(line, "^(%s*)$")
    if spaceonly ~= nil then
        -- this is an empty line
        return nil, nil
    end

    -- grabs text before the space
    s,e,name = string.find(line, "^([^%s]+)%s")
    if name == nil then
        xp_parseerr("missing space after user name:\n"..line)
    end

    laste = e
    repeat
        -- grabs the next set of text in parenthesis:
        s,e,statstr = string.find(line, "^%s-%((.-)%)", e + 1)

        if statstr ~= nil then
            laste = e
            -- grabs all the data in the parenthesis:
            ign,ign,stkind,stlevel,stxp = string.find(statstr, "^([^%s]+): level: (%d+) xp: (%d+)$")

            if stxp == nil then
                xp_parseerr("bad text between parenthesis:\n"..statstr.."\n*** in this bad line:\n"..line)
            end

            stats[stkind] = {xp = tonumber(stxp), level = tonumber(stlevel)}
        end
    until statstr == nil

    -- there should only be white space at the end of the line:
    ign,ign,test = string.find(line, "^%s*(.-)$", laste + 1)
    if test ~= "" then
        -- finds the first string of text without parenthesis
        ign,ign,badskl = string.find(line, "^%s*([^%s]+).*$", laste + 1)
        xp_parseerr("skill\n"..badskl.."\n*** lacks parenthesis in this line:\n"..line)
    end

    return name, stats
end

-- checks the version and format version string.
-- these signify the version of the xp mod that made the file,
-- and the formating style that was used.
-- pass it the first line of the xp_xplevels_file
-- returns a pointer to the appropriate parser function
function xp_checkfver(line)
    local s,e,ver,fmt,i,v

    -- grabs the version, and the format version
    s,e,ver,fmt = string.find(line, "-- Version: ([%d%a%.%-]+) File Format: (%d+)%s-$")

    if ver == nil or fmt == nil then
        print("*** xp module error: malformed Version string in /"..xp_file_name.." line 1:")
        print(line)
        os.exit()
    end

    if tonumber(fmt) == 1 then
        return xp_parselinev1
    else
        print("*** xp module error: unsupported file format in /"..xp_file_name.." file: "..fmt)
        print("*** the version of this mod is: "..xp_modver)
        print("*** this version only supports these format versions: ")
        for i,v in ipairs(xp_ffversupport) do
            print(v)
        end
        print("***")
        os.exit()
    end
end

-- read in the xp and levels for each player listed in the xp_xplevels_file
-- store the stats in xp_xplevels, the table.
function xp_loadxp()
    local input, line, parsel, name, stats

    input = io.open(xp_xplevels_file, "r")

    if input ~= nil then
        line = input:read("*l")

        if line ~= nil then
            parsel = xp_checkfver(line)

            line = input:read("*l")
            while line ~= nil do

                name, stats = parsel(line)
                if name ~= nil then
                    xp_xplevels[name] = stats
                end

                line = input:read("*l")
            end
        end
        io.close(input)
    end
end

-- save user xp and levels to xp_xplevels_file
function xp_savetofile()
    local line, output, i, v, j, w

    output = io.open(xp_xplevels_file, "w")

    output:write("-- Version: "..xp_modver.." File Format: "..xp_ffver.."\n")

    for i, v in pairs(xp_xplevels) do
        line = ""
        for j, w in pairs(v) do
            line = line.." ("..j..": level: "..w.level.." xp: "..w.xp..")"
        end
        output:write(i..line.."\n")
    end

    io.close(output)
end

----------------------------------

-- callback registration:
----------------------------------

local delta = 0
-- every xp_save_delta seconds, save the xp and levels, if they have xp_changed for one or more players
minetest.register_globalstep(function(dtime)
    delta = delta + dtime
    -- save it every <xp_save_delta> seconds
    if delta > xp_save_delta then
        delta = delta - xp_save_delta
        if xp_changed then
            xp_savetofile()
            xp_changed = false
        end
    end
end)


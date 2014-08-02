function village_at_point(minp, noise1)
       for xi = -2, 2 do
        for zi = -2, 0 do
                if xi~=0 or zi~=0 then
                        local mp = {x=minp.x+80*xi, z=minp.z+80*zi}
                        local pi = PseudoRandom(get_bseed(mp))
                        local s = pi:next(1, 400)
                        local x = pi:next(mp.x, mp.x+79)
                        local z = pi:next(mp.z, mp.z+79)
                        if s<=28 and noise1:get2d({x=x, y=z})>=-0.3 then
                           --print('no village for ya! (1)')
                           return 0,0,0,0
                        end
                end
        end
        end

        local pr = PseudoRandom(get_bseed(minp))
        if pr:next(1,400)>28 then
           --print('no village for ya! (2)')
           return 0,0,0,0
        end

        local x = pr:next(minp.x, minp.x+79)
        local z = pr:next(minp.z, minp.z+79)
        if noise1:get2d({x=x, y=z})<-0.3 then
          --print('no village for ya! (3)')
          return 0,0,0,0
        end


        local size = pr:next(20, 40)
        local height = pr:next(-5,50)
        local pp = find_base_pos(x,height,z)
        local cnt = 1
        while pp.y<0 do
           --print(pp.y)
           height = pr:next(-5,50)
           pp = find_base_pos(x,height,z)
           cnt=cnt+1
           if cnt>4 then return 0,0,0,0 end
        end
        print('A new village has spawned at '..minetest.pos_to_string(pp))
        height = pp.y
        return x,z,size,height
end

--local function dist_center2(ax, bsizex, az, bsizez)
--      return math.max((ax+bsizex)*(ax+bsizex),ax*ax)+math.max((az+bsizez)*(az+bsizez),az*az)
--end

local function inside_village2(bx, sx, bz, sz, vx, vz, vs, vnoise)
        return inside_village(bx, bz, vx, vz, vs, vnoise) and inside_village(bx+sx, bz, vx, vz, vs, vnoise) and inside_village(bx, bz+sz, vx, vz, vs, vnoise) and inside_village(bx+sx, bz+sz, vx, vz, vs, vnoise)
end

local function choose_building(l, pr)
        --::choose::
        local btype
        while true do
                local p = pr:next(1, 3000)
                for b, i in ipairs(buildings) do
                        if i.max_weight >= p then
                                btype = b
                                break
                        end
                end
                if buildings[btype].pervillage ~= nil then
                        local n = 0
                        for j=1, #l do
                                if l[j].btype == btype then
                                        n = n + 1
                                end
                        end
                        --if n >= buildings[btype].pervillage then
                        --      goto choose
                        --end
                        if n < buildings[btype].pervillage then
                                return btype
                        end
                else
                        return btype
                end
        end
        --return btype
end

local function choose_building_rot(l, pr, orient)
        local btype = choose_building(l, pr)
        local rotation
        if buildings[btype].no_rotate then
                rotation = 0
        else
                if buildings[btype].orients == nil then
                        buildings[btype].orients = {0,1,2,3}
                end
                rotation = (orient+buildings[btype].orients[pr:next(1, #buildings[btype].orients)])%4
        end
        local bsizex = buildings[btype].sizex
        local bsizez = buildings[btype].sizez
        if rotation%2 == 1 then
                bsizex, bsizez = bsizez, bsizex
        end
        return btype, rotation, bsizex, bsizez
end

local function placeable(bx, bz, bsizex, bsizez, l, exclude_roads)
        for _, a in ipairs(l) do
                if (a.btype ~= "road" or not exclude_roads) and math.abs(bx+bsizex/2-a.x-a.bsizex/2)<=(bsizex+a.bsizex)/2 and math.abs(bz+bsizez/2-a.z-a.bsizez/2)<=(bsizez+a.bsizez)/2 then return false end
        end
        return true
end

local function road_in_building(rx, rz, rdx, rdz, roadsize, l)
        if rdx == 0 then
                return not placeable(rx-roadsize+1, rz, 2*roadsize-2, 0, l, true)
        else
                return not placeable(rx, rz-roadsize+1, 0, 2*roadsize-2, l, true)
        end
end

local function when(a, b, c)
        if a then return b else return c end
end

local function generate_road(vx, vz, vs, vh, l, pr, roadsize, rx, rz, rdx, rdz, vnoise)
     --  local vh = find_base_pos(vx,water_level,vz).y
     -- print('new road at '..vx ..' '..vz)

        local calls_to_do = {}
        local rxx = rx
        local rzz = rz
        local mx, m2x, mz, m2z, mmx, mmz
        mx, m2x, mz, m2z = rx, rx, rz, rz
        local orient1, orient2
        if rdx == 0 then
                orient1 = 0
                orient2 = 2
        else
                orient1 = 3
                orient2 = 1
        end
        while inside_village(rx, rz, vx, vz, vs, vnoise) and not road_in_building(rx, rz, rdx, rdz, roadsize, l) do
                if roadsize > 1 and pr:next(1, 4) == 1 then
                        --generate_road(vx, vz, vs, vh, l, pr, roadsize-1, rx, rz, math.abs(rdz), math.abs(rdx))
                        calls_to_do[#calls_to_do+1] = {rx=rx+(roadsize - 1)*rdx, rz=rz+(roadsize - 1)*rdz, rdx=math.abs(rdz), rdz=math.abs(rdx)}
                        m2x = rx + (roadsize - 1)*rdx
                        m2z = rz + (roadsize - 1)*rdz
                        rx = rx + (2*roadsize - 1)*rdx
                        rz = rz + (2*roadsize - 1)*rdz
                end
                --else
                        --::loop::
                        local exitloop = false
                        local bx
                        local bz
                        local tries = 0
                        while true do
                                if not inside_village(rx, rz, vx, vz, vs, vnoise) or road_in_building(rx, rz, rdx, rdz, roadsize, l) then
                                        exitloop = true
                                        break
                                end
                                btype, rotation, bsizex, bsizez = choose_building_rot(l, pr, orient1)
                                bx = rx + math.abs(rdz)*(roadsize+1) - when(rdx==-1, bsizex-1, 0)
                                bz = rz + math.abs(rdx)*(roadsize+1) - when(rdz==-1, bsizez-1, 0)
                                if placeable(bx, bz, bsizex, bsizez, l) and inside_village2(bx, bsizex, bz, bsizez, vx, vz, vs, vnoise) then
                                        break
                                end
                                if tries > 5 then
                                        rx = rx + rdx
                                        rz = rz + rdz
                                        tries = 0
                                else
                                        tries = tries + 1
                                end
                                --goto loop
                        end
                        if exitloop then break end
                        rx = rx + (bsizex+1)*rdx
                        rz = rz + (bsizez+1)*rdz
                        mx = rx - 2*rdx
                        mz = rz - 2*rdz
                        l[#l+1] = {x=bx, y=vh, z=bz, btype=btype, bsizex=bsizex, bsizez=bsizez, brotate = rotation}
                --end
        end
        rx = rxx
        rz = rzz
        while inside_village(rx, rz, vx, vz, vs, vnoise) and not road_in_building(rx, rz, rdx, rdz, roadsize, l) do
                if roadsize > 1 and pr:next(1, 4) == 1 then
                        --generate_road(vx, vz, vs, vh, l, pr, roadsize-1, rx, rz, -math.abs(rdz), -math.abs(rdx))
                        calls_to_do[#calls_to_do+1] = {rx=rx+(roadsize - 1)*rdx, rz=rz+(roadsize - 1)*rdz, rdx=-math.abs(rdz), rdz=-math.abs(rdx)}
                        m2x = rx + (roadsize - 1)*rdx
                        m2z = rz + (roadsize - 1)*rdz
                        rx = rx + (2*roadsize - 1)*rdx
                        rz = rz + (2*roadsize - 1)*rdz
                end
                --else
                        --::loop::
                        local exitloop = false
                        local bx
                        local bz
                        local tries = 0
                        while true do
                                if not inside_village(rx, rz, vx, vz, vs, vnoise) or road_in_building(rx, rz, rdx, rdz, roadsize, l) then
                                        exitloop = true
                                        break
                                end
                                btype, rotation, bsizex, bsizez = choose_building_rot(l, pr, orient2)
                                bx = rx - math.abs(rdz)*(bsizex+roadsize) - when(rdx==-1, bsizex-1, 0)
                                bz = rz - math.abs(rdx)*(bsizez+roadsize) - when(rdz==-1, bsizez-1, 0)
                                if placeable(bx, bz, bsizex, bsizez, l) and inside_village2(bx, bsizex, bz, bsizez, vx, vz, vs, vnoise) then
                                        break
                                end
                                if tries > 5 then
                                        rx = rx + rdx
                                        rz = rz + rdz
                                        tries = 0
                                else
                                        tries = tries + 1
                                end
                                --goto loop
                        end
                        if exitloop then break end
                        rx = rx + (bsizex+1)*rdx
                        rz = rz + (bsizez+1)*rdz
                        m2x = rx - 2*rdx
                        m2z = rz - 2*rdz
                        l[#l+1] = {x=bx, y=vh, z=bz, btype=btype, bsizex=bsizex, bsizez=bsizez, brotate = rotation}
                --end
        end
        if road_in_building(rx, rz, rdx, rdz, roadsize, l) then
                mmx = rx - 2*rdx
                mmz = rz - 2*rdz
        end
        mx = mmx or rdx*math.max(rdx*mx, rdx*m2x)
        mz = mmz or rdz*math.max(rdz*mz, rdz*m2z)
        if rdx == 0 then
                rxmin = rx - roadsize + 1
                rxmax = rx + roadsize - 1
                rzmin = math.min(rzz, mz)
                rzmax = math.max(rzz, mz)
        else
                rzmin = rz - roadsize + 1
                rzmax = rz + roadsize - 1
                rxmin = math.min(rxx, mx)
                rxmax = math.max(rxx, mx)
        end
        l[#l+1] = {x=rxmin, y=vh, z=rzmin, btype="road", bsizex=rxmax-rxmin+1, bsizez=rzmax-rzmin+1, brotate = 0}
        for _,i in ipairs(calls_to_do) do
                generate_road(vx, vz, vs, vh, l, pr, roadsize-1, i.rx, i.rz, i.rdx, i.rdz, vnoise)
        end
end

local function generate_bpos(vx, vz, vs, vh, pr, vnoise)
        local l={}
        local rx = vx-vs
        local rz = vz
        while inside_village(rx, rz, vx, vz, vs, vnoise) do
                rx = rx - 1
        end
        rx = rx + 5
        generate_road(vx, vz, vs, vh, l, pr, 3, rx, rz, 1, 0, vnoise)
        return l
end

local function generate_building(pos, minp, maxp, data, a, pr, extranodes, stop)
       local oldpos = {}
       oldpos.x = pos.x
       oldpos.y = pos.y
       oldpos.z = pos.z
       local pp
       if pos.y<=1 then
          pp = find_base_pos(pos.x,pos.y+20,pos.z)
        --  oldpos.y = pp.y
       else
          pp = find_base_pos(pos.x,pos.y-20,pos.z)
       end
          pos.x = pp.x
          pos.y = pp.y +1
          pos.z = pp.z


        local binfo = buildings[pos.btype]
        local scm
        local building = 'unknown building'
        if type(binfo.scm) == "string" then
                scm = import_scm(binfo.scm)
                building = binfo.scm
        else
                scm = binfo.scm
        end
        scm = rotate(scm, pos.brotate)
        -- do NOT spawn a building if the base_pos is too far...
        local abss = math.abs(pos.y-oldpos.y)
        if abss>10 then return end
        --print('spawning ' .. building ..' at ' .. minetest.pos_to_string(pos) .. '; diff = '..abss)
        if stop then return end
        local t
        if building~='well' and building~='road' --[[and building~='unknown building']]  then

           for x = -1, pos.bsizex+0 do
               for z = -1, pos.bsizez+0 do
                   ax, ayy, az = pos.x+x, pos.y-1, pos.z+z
                   while (data[a:index(ax, ayy, az)] == c_water
                   or data[a:index(ax, ayy, az)] == c_air
                   or data[a:index(ax, ayy, az)] == c_ignore)
                   do
                      ayy=ayy-1
                      -- don't search after 10 nodes below
                      if ayy+10<pos.y-1 then break end
                   end

                   local filler = data[a:index(ax, ayy, az)]
                   if not filler or filler==c_ignore then filler = c_cobble end
                   for ayy = ayy, pos.y-1 do
                      -- data can't be set for some reason while set_node always do the job
                      --data[a:index(ax, ayy, az)] = filler
                      minetest.set_node({x=ax, y=ayy, z=az},{name=minetest.get_name_from_content_id(filler)},2)                      
                   end

               for y = 1, binfo.ysize+1 do
                       ax, ay, az = pos.x+x, pos.y+y+binfo.yoff, pos.z+z
                      -- if (math.abs(x)==1 or math.abs(z)==1) then
                        --  if y==1 then data[a:index(ax, ay, az)] = c_cobble end
    --                      if y==2 then data[a:index(ax, ay, az)] = c_torch end
                          --table.insert(extranodes, {node={name="default:torch", param1=0, param2=0}, meta=nil, pos={x=ax, y=ay, z=az}}})
                      -- else
                          data[a:index(ax, ay, az)] = c_air
                      -- end
                   end
               end
           end
--           print('cleared '..building)
        end

        local desert = false
        if data[a:index(pos.x, pos.y-2, pos.z)] == c_desert_stone
        or data[a:index(pos.x, pos.y-2, pos.z)] == c_desert_cobble
           then
               desert = true
            --  print('desert')
           end

        local bed = false
        for x = 0, pos.bsizex-1 do
        for z = 0, pos.bsizez-1 do
        for y = 0, binfo.ysize-1 do

                ax, ay, az = pos.x+x, pos.y+y+binfo.yoff, pos.z+z
               -- if y>1 then data[a:index(ax, ay, az)] = c_air end

               --if (ax >= minp.x and ax <= maxp.x) and (ay >= minp.y and ay <= maxp.y) and (az >= minp.z and az <= maxp.z) then
                        t = scm[y+1][x+1][z+1]
                        if type(t) == "table" then
--                                if ay< 5 then
                                  if desert then
                                     if t.node.name=='default:wood' then t.node.name = 'desert_uses:desert_cobble' end
                                     if t.node.name=='default:tree' then t.node.name = 'default:desert_stone' end
                                     if t.node.name=='stairs:stair_wood'  then t.node.name = 'stairs:stair_desert_stone' end
                                     if t.node.name=='stairs:slab_wood'  then t.node.name = 'stairs:slab_desert_stone' end
                                  else
                                     if t.node.name=='default:wood' then t.node.name = 'default:cobble' end
                                     if t.node.name=='default:tree' then t.node.name = 'default:stone' end
                                     if t.node.name=='stairs:stair_wood'  then t.node.name = 'stairs:stair_stone' end
                                     if t.node.name=='stairs:slab_wood'  then t.node.name = 'stairs:slab_stone' end
                                  end

                                --end

                                table.insert(extranodes, {node=t.node, meta=t.meta, pos={x=ax, y=ay, z=az},})
                        else
                            if t ~= c_ignore then
                                if t == c_wood then
                                   if desert then
                                      t = c_desert_cobble
                                   else
                                      t = c_cobble
                                   end
                                end
                                data[a:index(ax, ay, az)] = t
                           end
                        end
               -- end
        end
        end
        end

end

local MIN_DIST = 1

local function pos_far_buildings(x, z, l)
        for _,a in ipairs(l) do
                if a.x-MIN_DIST<=x and x<=a.x+a.bsizex+MIN_DIST and a.z-MIN_DIST<=z and z<=a.z+a.bsizez+MIN_DIST then
                        return false
                end
        end
        return true
end

local function generate_walls(bpos, data, a, minp, maxp, vh, vx, vz, vs, vnoise)
        for x = minp.x, maxp.x do
        for z = minp.z, maxp.z do
                local xx = (vnoise:get2d({x=x, y=z})-2)*20+(40/(vs*vs))*((x-vx)*(x-vx)+(z-vz)*(z-vz))
                if xx>=40 and xx <= 44 then
                        bpos[#bpos+1] = {x=x, z=z, y=vh, btype="wall", bsizex=1, bsizez=1, brotate=0}
                end
        end
        end
end

function generate_village(vx, vz, vs, vh, minp, maxp, data, a, vnoise, to_grow)
        local seed = get_bseed({x=vx, z=vz})
        local pr_village = PseudoRandom(seed)
        local bpos = generate_bpos(vx, vz, vs, vh, pr_village, vnoise)
        --if maxp.y<5 then generate_walls(bpos, data, a, minp, maxp, vh, vx, vz, vs, vnoise) end
        local pr = PseudoRandom(seed)
        for _, g in ipairs(to_grow) do
                if pos_far_buildings(g.x, g.z, bpos) then
                        mg.registered_trees[g.id].grow(data, a, g.x, g.y, g.z, minp, maxp, pr)
                end
        end
        local extranodes = {}
        local generated = {}
        for _, pos in ipairs(bpos) do
               -- print('generating at ' .. minetest.pos_to_string(pos))
                local found
                for i=1,#generated do
                    if pos.x==generated[i].x and pos.z==generated[i].z then
                       --print('already one at ' .. minetest.pos_to_string(pos))
                       found = true
                       break
                    end
                end
                if not found then
                  -- print(minetest.serialize(pos))
                   table.insert(generated,pos)
                   generate_building(pos, minp, maxp, data, a, pr_village, extranodes)
              --  else
                --   generate_building(pos, minp, maxp, data, a, pr_village, extranodes, true)
                end
        end
        return extranodes
end

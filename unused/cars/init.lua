--[[
	StreetsMod: Experimental cars
]]
local function get_single_accels(self,p)
	local output = {x = 0, y = -9.81, z = 0}
	local alpha = p.dir
	local beta = 180 - 90 - alpha
	local hyp = p.accel
	output.x = (math.sin(alpha) * hyp * -1) / self.initial_properties.weight
	output.z = (math.sin(beta) * hyp) / self.initial_properties.weight
	return output
end

local function merge_single_forces(x,z)
	return math.sqrt(math.pow(x,2) + math.pow(z,2))
end

minetest.register_entity(":streets:melcar",{
	initial_properties = {
		hp_max = 100,
		physical = true,
		weight = 1000,	-- ( in kg)
		visual = "mesh",
		mesh = "car_001.obj",
		visual_size = {x=1,y=1},
		textures = {"textur_yellow.png"},
		collisionbox = {-0.5,0.0,-1.85,1.35,1.5,1.25},
		stepheight = 0.5
	},
	props = {
		driver = nil,
		on_ground = false,
		max_speed = 10.0,
		max_rpm = 4000,
		accel = 1.5,
		decel = 1,
		gears = 5,
		shift_time = 0.75,
		
		-- Runtime variables
		speed = 0,
		rpm = 0,
		gear = 0,
		brake = false,
		accelerate = false,
		sound = nil,
		hud = {
			gear,
			rpm,
		}
	},
	on_activate = function(self)
		-- Gravity
		self.object:setacceleration({x=0,y= -9.81,z=0})
		self.props.rpm = 500
		self.props.gear = 1
	end,
	on_rightclick = function(self,clicker)
		if self.props.driver == nil then
			-- Update driver
			self.props.driver = clicker:get_player_name()
			-- Attach player
			clicker:set_attach(self.object, "", {x=0,y=5,z=0}, {x=0,y=0,z=0})
			-- HUD
			clicker:hud_set_flags({
				hotbar = false,
				healthbar = false,
				crosshair = false,
				wielditem = false
			})
			-- Start engine
			self.props.engine_rpm = 500
			self.props.gear = 1
			minetest.sound_play("cars_car_start", {
				object = self.object,
				max_hear_distance = 35,
				gain = 10.0,
			})
			minetest.after(1.8,function()
				self.props.sound = minetest.sound_play("cars_car_idle", {
					object = self.object,
					max_hear_distance = 35,
					gain = 10.0,
					loop = true
				})
			end)
		else
			if self.props.driver == clicker:get_player_name() then
				-- Update driver
				self.props.driver = nil
				-- Detach player
				clicker:set_detach()
				-- HUD
				clicker:hud_set_flags({
					hotbar = true,
					healthbar = true,
					crosshair = true,
					wielditem = true
				})
				if self.props.sound then
					minetest.sound_stop(self.props.sound)
					self.props.sound = nil
				end
			else
				minetest.chat_send_player(clicker:get_player_name(),"This car already has a driver")
			end
		end
	end,
	on_step = function(self,dtime)
		-- Player controls
		if self.props.driver then
			local ctrl = minetest.get_player_by_name(self.props.driver):get_player_control()
			-- up
			if ctrl.up then
				self.props.brake = false
				self.props.accelerate = true
				if self.props.rpm < self.props.max_rpm then
					self.props.rpm = self.props.rpm + 20 * (self.props.gears + 1 - self.props.gear)
				end
			else
				self.props.accelerate = false
				if self.props.rpm >= 520 then
					self.props.rpm = self.props.rpm - 20 * self.props.gear
				end
			end
			-- down
			if ctrl.down then
				self.props.brake = true
				self.props.accelerate = false
				if self.props.rpm >= 520 then
					self.props.rpm = self.props.rpm - 40
				end
			else
				self.props.brake = false
			end
			-- left
			if ctrl.left then
				self.object:setyaw(self.object:getyaw() + 1 * dtime)
			end
			-- right
			if ctrl.right then
				self.object:setyaw(self.object:getyaw() - 1 * dtime)
			end
		end
		-- Reset acceleration
		-- Calculate acceleration
		if self.props.brake == false then
			local accel = (self.props.rpm - 500) * self.props.gear * self.props.accel
			self.object:setacceleration(get_single_accels(self,{
				dir = self.object:getyaw(),
				accel = accel
			}))
		else
			if merge_single_forces(self.object:getvelocity().x, self.object:getvelocity().z) > 0.1 then
				self.object:setacceleration(get_single_accels(self,{
					dir = self.object:getyaw(),
					accel = -8000 * self.props.decel
				}))
			end
		end
		-- Slow down, if car doesn't accelerate
		if self.props.accelerate == false and self.props.brake == false then
			self.object:setacceleration(get_single_accels(self,{
				dir = self.object:getyaw(),
				accel = -2000
			}))
		end
		-- Stop acceleration if max_speed reached
		if merge_single_forces(self.object:getvelocity().x, self.object:getvelocity().z) >= self.props.max_speed and self.props.brake == false then
			self.object:setacceleration({x = 0, y= -9.81, z = 0})
		end
		-- Stop if very slow (e.g. because driver brakes)
		minetest.chat_send_all("V = " .. merge_single_forces(self.object:getvelocity().x, self.object:getvelocity().z))
		if math.abs(merge_single_forces(self.object:getvelocity().x, self.object:getvelocity().z)) < 1 and self.props.accelerate == false then
			self.object:setacceleration({x=0,y= -9.81 ,z=0})
			self.object:setvelocity({x=0,y=0,z=0})
		end
		-- Shift gears
		if self.props.rpm > 3000 and self.props.gear < self.props.gears then
			self.props.gear = self.props.gear + 1
			self.props.rpm = math.random(700,800)
		end
		if self.props.rpm < 700 and self.props.gear > 1 then
			self.props.gear = self.props.gear - 1
			self.props.rpm = self.props.rpm + math.random(200,500)
		end
		minetest.chat_send_all(self.props.gear .. " | " .. self.props.rpm)
	end
})
local S = minetest.get_translator("hightech")

local Hoverboard = {
	initial_properties = {
		visual = "mesh",
		mesh = "hightech_hoverboard.obj",
		textures = {"hightech_dark.png"},

		physical = true,
		collisionbox = {-0.5, -0.35, -0.5, 0.5, 0.15, 0.5},
	},
}

function Hoverboard:on_activate()
	self.object:set_armor_groups({
		immortal = 1,
	})
end

function Hoverboard:attach_pilot(player)
	player:set_attach(self.object, nil, vector.new(0.5, 1, -3))
	player_api.player_attached[player:get_player_name()] = true
	minetest.after(0.2, function()
		player_api.set_animation(player, "sit", 30)
	end)

	self.pilot = player
end

function Hoverboard:detach_pilot()
	self.pilot:set_detach()
end

function Hoverboard:on_detach_child(object)
	if object == self.pilot then
		player_api.player_attached[self.pilot:get_player_name()] = false
		player_api.set_animation(self.pilot, "stand", 30)

		self.pilot = nil
	end
end

function Hoverboard:on_rightclick(player)
	if not self.pilot then
		self:attach_pilot(player)
	end
end

function Hoverboard:on_step(dtime)
	if self.pilot and self.pilot:get_player_control().sneak then
		self:detach_pilot()
	end

	if self.pilot then
		self.object:set_rotation(vector.dir_to_rotation(self.pilot:get_look_dir()))
	end

	local velocity = self.object:get_velocity()
	local speed = velocity:length()

	local MAX_SPEED = 20
	local ACCELERATION = 15

	local accelerate = self.pilot and self.pilot:get_player_control().up
	if accelerate and speed < MAX_SPEED then
		speed = speed + ACCELERATION * dtime
	end
	if not accelerate and speed > 0 then
		speed = speed - ACCELERATION * dtime
	end
	if speed < 0 then
		speed = 0
	end
	if speed > MAX_SPEED then
		speed = MAX_SPEED
	end

	velocity = vector.new(0, 0, speed)
	velocity = velocity:rotate(self.object:get_rotation())

	self.object:set_velocity(velocity)

	if accelerate and not self.particle_spawner_id then
		self.particle_spawner_id = minetest.add_particlespawner({
			texture = "hightech_glass.png",
			glow = minetest.LIGHT_MAX,
			amount = 100,
			time = 0,
			attached = self.object,
			minpos = vector.new(0, -0.09, -0.85),
			maxpos = vector.new(0, -0.09, -0.85),
			minvel = vector.new(1, 2, -5),
			maxvel = vector.new(-1, -2, -10),
		})
	end
	if not accelerate and self.particle_spawner_id then
		minetest.delete_particlespawner(self.particle_spawner_id)
		self.particle_spawner_id = nil
	end
end

function Hoverboard:on_punch(player)
	if self.pilot then
		return
	end

	local inv = player:get_inventory()
	if not minetest.is_creative_enabled(player:get_player_name()) or not inv:contains_item("main", "hightech:hoverboard") then
		local leftover = inv:add_item("main", "hightech:hoverboard")
		if not leftover:is_empty() then
			minetest.add_item(self.object:get_pos(), leftover)
		end
	end

	minetest.sound_play(default.node_sound_stone_defaults().dug, {pos = self.object:get_pos()}, true)
	self.object:remove()
end

minetest.register_entity("hightech:hoverboard", Hoverboard)

minetest.register_craft({
	recipe = {
		{"hightech:dark", "hightech:dark"},
		{"hightech:dark", "hightech:dark"},
		{"hightech:dark", "hightech:dark"},
	},
	output = "hightech:hoverboard",
})

minetest.register_craftitem("hightech:hoverboard", {
	description = S("Hoverboard"),
	inventory_image = "hightech_hoverboard_inventory.png",
	wield_image = "hightech_hoverboard_wield.png",

	on_place = function(item, player, pointed_thing)
		if pointed_thing.type == "node" then
			minetest.add_entity(pointed_thing.above, "hightech:hoverboard")
			minetest.sound_play(default.node_sound_stone_defaults().place, {pos = pointed_thing.above}, true)

			if not minetest.is_creative_enabled(player:get_player_name()) then
				item:take_item()
				return item
			end
		end
	end,
})

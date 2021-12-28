local t = minetest.get_translator("hightech")

minetest.register_craft({
	recipe = {
		{"hightech:dark", "hightech:dark", "hightech:dark"},
		{"hightech:dark", "hightech:dark", "hightech:dark"},
	},
	output = "hightech:sign 3",
})

signs_lib.register_sign(
	"hightech:sign",
	{
		description = t("Hightech Sign"),
		inventory_image = "hightech_sign_inventory.png",
		wield_image = "hightech_sign_inventory.png",

		entity_info = "standard",
		allow_yard = true,
		tiles = {
			"hightech_sign.png",
			"hightech_sign_edges.png",
			"",
			"",
			"hightech_dark.png"
		},

		default_color = "f",
		allow_widefont = true,
		y_offset = 3,
		x_offset = 3,

		groups = {cracky = 3, sign = 1},
		sounds = default.node_sound_stone_defaults(),
	}
)

local t = minetest.get_translator("hightech")

minetest.register_node(
	"hightech:glass_ore",
	{
		description = t("Hightech Glass Ore"),
		tiles = {"default_stone.png^hightech_glass_ore.png"},

		paramtype = light,
		light_source = minetest.LIGHT_MAX / 4 * 3,

		groups = {cracky = 3},
		sounds = default.node_sound_stone_defaults(),

		drop = "hightech:glass_dust 2",
	}
)

minetest.register_ore({
	ore_type       = "scatter",
	ore            = "hightech:glass_ore",
	wherein        = "default:stone",
	clust_scarcity = 8 * 8 * 8,
	clust_size     = 3,
	clust_num_ores = 9,
})

minetest.register_craftitem(
	"hightech:glass_dust",
	{
		description = t("Hightech Glass Dust"),
		inventory_image = "hightech_glass_dust.png",
	}
)

minetest.register_craft({
	type = "cooking",
	recipe = "hightech:glass_dust",
	output = "hightech:glass",
})

minetest.register_node(
	"hightech:glass",
	{
		description = t("Hightech Glass"),
		drawtype = "glasslike",
		use_texture_alpha = "blend",
		tiles = {"hightech_glass.png"},

		paramtype = "light",
		sunlight_propagates = true,
		light_source = minetest.LIGHT_MAX,

		groups = {cracky = 3, oddly_breakable_by_hand = 3},
		sounds = default.node_sound_glass_defaults(),
	}
)

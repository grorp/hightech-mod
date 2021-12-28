local t = minetest.get_translator("hightech")

minetest.register_node(
	"hightech:dark_ore",
	{
		description = t("Dark Hightech Ore"),
		tiles = {"default_stone.png^hightech_dark_ore.png"},

		groups = {cracky = 3},
		sounds = default.node_sound_stone_defaults(),

		drop = "hightech:dark_dust 2",
	}
)

minetest.register_ore({
	ore_type       = "scatter",
	ore            = "hightech:dark_ore",
	wherein        = "default:stone",
	clust_scarcity = 6 * 6 * 6,
	clust_size     = 3,
	clust_num_ores = 9,
})

minetest.register_craftitem(
	"hightech:dark_dust",
	{
		description = t("Dark Hightech Dust"),
		inventory_image = "hightech_dark_dust.png",
	}
)

minetest.register_craft({
	type = "cooking",
	recipe = "hightech:dark_dust",
	output = "hightech:dark",
})

minetest.register_node(
	"hightech:dark",
	{
		description = t("Dark Hightech"),
		tiles = {"hightech_dark.png"},

		groups = {cracky = 3},
		sounds = default.node_sound_stone_defaults(),
	}
)

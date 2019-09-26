
minetest.register_node("epic:function", {
	description = "Epic function block",
	tiles = {
		"epic_node_bg.png",
		"epic_node_bg.png",
    "epic_node_bg.png",
    "epic_node_bg.png",
    "epic_node_bg.png",
    "epic_node_bg.png^epic_function.png^epic_blue_right.png",
	},
  paramtype2 = "facedir",
  groups = { oddly_breakable_by_hand=1 },
  legacy_facedir_simple = true
})

minetest.register_node("epic:epic", {
	description = "Epic",
  groups = { oddly_breakable_by_hand=1 },
  tiles = {
    "epic_node_bg.png^epic_epic.png"
	}
})

minetest.register_node("epic:mob", {
	description = "Epic mob block",
  groups = { oddly_breakable_by_hand=1 },
	tiles = {
		"epic_node_bg.png",
		"epic_node_bg.png",
    "epic_node_bg.png",
    "epic_node_bg.png",
    "epic_node_bg.png",
    "epic_node_bg.png^epic_mob.png^epic_blue_right.png",
	},
  paramtype2 = "facedir",
  legacy_facedir_simple = true
})

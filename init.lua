
minetest.register_node("epic:function", {
	description = "Function start block",
	tiles = {
		"epic_node_bg.png",
		"epic_node_bg.png",
    "epic_node_bg.png",
    "epic_node_bg.png",
    "epic_node_bg.png",
    "epic_node_bg.png^epic_function.png",
	},
  paramtype2 = "facedir",
  groups = {snappy = 2, choppy = 2, oddly_breakable_by_hand = 2, mesecon = 2},
  legacy_facedir_simple = true
})

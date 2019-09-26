
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
  groups = { oddly_breakable_by_hand=1 }
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
  paramtype2 = "facedir"
})

minetest.register_node("epic:call", {
	description = "Epic call block",
  groups = { oddly_breakable_by_hand=1 },
	tiles = {
		"epic_node_bg.png",
		"epic_node_bg.png",
    "epic_node_bg.png",
    "epic_node_bg.png",
    "epic_node_bg.png",
    "epic_node_bg.png^epic_call.png^epic_blue_right.png",
	},
  paramtype2 = "facedir"
})

minetest.register_node("epic:nop", {
	description = "Epic nop block",
  groups = { oddly_breakable_by_hand=1 },
	tiles = {
		"epic_node_bg.png",
		"epic_node_bg.png",
    "epic_node_bg.png",
    "epic_node_bg.png",
    "epic_node_bg.png",
    "epic_node_bg.png^epic_nop.png^epic_blue_right.png",
	},
  paramtype2 = "facedir"
})


minetest.register_node("epic:end", {
	description = "Epic end block",
  groups = { oddly_breakable_by_hand=1 },
	tiles = {
		"epic_node_bg.png",
		"epic_node_bg.png",
    "epic_node_bg.png",
    "epic_node_bg.png",
    "epic_node_bg.png",
    "epic_node_bg.png^epic_end.png^epic_red_right.png",
	},
  paramtype2 = "facedir"
})


minetest.register_node("epic:ret", {
	description = "Epic return block",
  groups = { oddly_breakable_by_hand=1 },
	tiles = {
		"epic_node_bg.png",
		"epic_node_bg.png",
    "epic_node_bg.png",
    "epic_node_bg.png",
    "epic_node_bg.png",
    "epic_node_bg.png^epic_ret.png^epic_red_right.png",
	},
  paramtype2 = "facedir"
})


minetest.register_node("epic:if", {
	description = "Epic if block",
  groups = { oddly_breakable_by_hand=1 },
	tiles = {
		"epic_node_bg.png",
		"epic_node_bg.png",
    "epic_node_bg.png",
    "epic_node_bg.png",
    "epic_node_bg.png",
    "epic_node_bg.png^epic_if.png^epic_blue_right.png^(epic_red_right.png^[transformFXR90)",
	},
  paramtype2 = "facedir"
})


minetest.register_node("epic:waypoint", {
	description = "Epic waypoint block",
	tiles = {
		"epic_node_bg.png",
		"epic_node_bg.png",
		"epic_node_bg.png",
		"epic_node_bg.png",
		"epic_node_bg.png",
		"epic_node_bg.png^epic_waypoint.png",
	},
	paramtype2 = "facedir",
	groups = {cracky=3,oddly_breakable_by_hand=3},
	on_rotate = screwdriver.rotate_simple,

	epic = {
    on_enter = function(pos, meta, data, player, ctx)
    end,
    on_check = function(pos, meta, data, player, ctx)
    end,
    on_exit = function(pos, meta, data, player)
    end
  }
})

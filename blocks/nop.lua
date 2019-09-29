
minetest.register_node("epic:nop", {
	description = "Epic no-op block",
	tiles = {
		"epic_node_bg.png",
		"epic_node_bg.png",
		"epic_node_bg.png",
		"epic_node_bg.png",
		"epic_node_bg.png",
		"epic_node_bg.png",
	},
	paramtype2 = "facedir",
	groups = {cracky=3,oddly_breakable_by_hand=3},
	on_rotate = screwdriver.rotate_simple,

  epic = {
    on_enter = function(pos, meta, data, player, ctx)
			ctx.next()
    end
  }
})

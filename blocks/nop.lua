
minetest.register_node("epic:nop", {
	description = "Epic no-op block: placeholder-node, does nothing",
	tiles = {
		"epic_node_bg.png",
		"epic_node_bg.png",
		"epic_node_bg.png",
		"epic_node_bg.png",
		"epic_node_bg.png",
		"epic_node_bg.png^epic_nop.png",
	},
	paramtype2 = "facedir",
	groups = {cracky=3,oddly_breakable_by_hand=3,epic=1},
	on_rotate = screwdriver.rotate_simple,

  epic = {
    on_check = function(_, _, _, ctx)
			ctx.next()
    end
  }
})

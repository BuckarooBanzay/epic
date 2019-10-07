
minetest.register_node("epic:random", {
	description = "Epic random block",
	tiles = {
		"epic_node_bg.png",
		"epic_node_bg.png",
		"epic_node_bg.png",
		"epic_node_bg.png",
		"epic_node_bg.png",
		"epic_node_bg.png",
	},
	paramtype2 = "facedir",
	groups = {cracky=3,oddly_breakable_by_hand=3,epic=1},
	on_rotate = screwdriver.rotate_simple,

  epic = {
    on_check = function(_, _, _, ctx)
	if math.random(2) == 1 then
		ctx.next()
	end
    end
  }
})

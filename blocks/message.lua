

minetest.register_node("epic:message", {
	description = "Epic message block",
	tiles = {
		"epic_node_bg.png",
		"epic_node_bg.png",
		"epic_node_bg.png",
		"epic_node_bg.png",
		"epic_node_bg.png",
		"epic_node_bg.png^epic_bubble.png",
	},
	paramtype2 = "facedir",
	groups = {cracky=3,oddly_breakable_by_hand=3},
	on_rotate = screwdriver.rotate_simple,

	epic = {
    on_enter = function(pos, meta, player, ctx)
      minetest.chat_send_player(player:get_player_name(), "Success!!")
      ctx.next()
    end
  }
})

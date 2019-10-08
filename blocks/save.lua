
minetest.register_node("epic:save", {
	description = "Epic save block",
	tiles = {
		"epic_node_bg.png",
		"epic_node_bg.png",
		"epic_node_bg.png",
		"epic_node_bg.png",
		"epic_node_bg.png",
		"epic_node_bg.png^epic_save.png",
	},
	paramtype2 = "facedir",
	groups = {cracky=3,oddly_breakable_by_hand=3,epic=1},
	on_rotate = screwdriver.rotate_simple,

  epic = {
    on_enter = function(_, _, player, ctx)
			local playername = player:get_player_name()
			minetest.chat_send_player(playername, "[epic] Game state saved!")
			epic.save_player_state(playername)
			ctx.next()
    end
  }
})

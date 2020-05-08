
minetest.register_node("epic:lock", {
	description = "Epic lock block: locks the current execution-path (mutual exclusive execution)",
	tiles = {
		"epic_node_bg.png",
		"epic_node_bg.png",
		"epic_node_bg.png",
		"epic_node_bg.png",
		"epic_node_bg.png",
		"epic_node_bg.png^epic_lock.png",
	},
	paramtype2 = "facedir",
	groups = {cracky=3,oddly_breakable_by_hand=3,epic=1},
	on_rotate = screwdriver.rotate_simple,

	on_construct = function(pos)
    local meta = minetest.get_meta(pos)
		meta:set_int("lock", 0)
  end,

  epic = {
    on_enter = function(_, meta, player, ctx)
			if meta:get_int("lock") == 0 then
				meta:set_int("lock", 1)
				ctx.next()
			else
				minetest.chat_send_player(player:get_player_name(), "[epic] the section is currently occupied, please stand by...")
			end
    end,

		on_check = function(_, meta, player, ctx)
			if meta:get_int("lock") == 0 then
				meta:set_int("lock", 1)
				minetest.chat_send_player(player:get_player_name(), "[epic] advancing to the section...")
				ctx.next()
			end
		end
  }
})

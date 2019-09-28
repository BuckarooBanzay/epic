

epic.register_opcode("epic:message", {
	description = "Epic message block",
  overlay = "epic_msg.png",
  directions = {
    right = true
  },
  epic = {
    on_enter = function(pos, meta, data, player, ctx)
      minetest.chat_send_player(player:get_player_name(), "Success!!")
    end,
    on_check = function(pos, meta, data, player, ctx)
    end
  }
})

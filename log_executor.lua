
epic.register_hook({
  on_execute_function = function(player, main_pos, exit_pos)
    minetest.log("action", "[epic] on_execute_function player=" ..
      player:get_player_name() ..
      " main_pos=" .. minetest.pos_to_string(main_pos) ..
      " exit_pos=" .. minetest.pos_to_string(exit_pos))
  end,

  on_state_restored = function(playername, state)
    minetest.log("action", "[epic] on_state_restored player=" ..
      playername ..
      " state=" .. dump(state))
  end,

  on_before_node_enter = function(pos, player)
    minetest.log("action", "[epic] on_before_node_enter player=" ..
      player:get_player_name() ..
      " pos=" .. minetest.pos_to_string(pos))
  end,

  on_before_node_exit = function(pos, player)
    minetest.log("action", "[epic] on_before_node_exit player=" ..
      player:get_player_name() ..
      " pos=" .. minetest.pos_to_string(pos))
  end,

  on_epic_exit = function(playername, state)
    minetest.log("action", "[epic] on_epic_exit player=" ..
      playername ..
      " state=" .. dump(state))
  end,

  on_epic_abort = function(playername, state, reason)
    minetest.log("action", "[epic] on_epic_exit player=" ..
      playername ..
      " state=" .. dump(state) ..
      " reason=" .. reason)
  end
})



epic.execute_function = function(pos, player)
  minetest.log("action", "[epic] player " .. player:get_player_name() ..
    " executes function at " .. minetest.pos_to_string(pos))

  local step_pos = pos

  while true do
    step_pos = epic.get_next_pos(step_pos)

    if step_pos == nil then
      return
    end

    local node = minetest.get_node(step_pos)
    if not epic.is_epic(node) then
      return
    end

    local next = epic.execute_block(step_pos, node, player)
    if not next then
      return
    end
  end

end

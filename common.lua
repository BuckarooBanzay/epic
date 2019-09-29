
-- converts the direction
local param2_to_code_direction = function(param2)
  local direction = minetest.facedir_to_dir(param2)
  if direction.x == -1 and direction.z == 0 then
    return { x=0, y=0, z=1 }
  elseif direction.x == 0 and direction.z == 1 then
    return { x=1, y=0, z=0 }
  elseif direction.x == 1 and direction.z == 0 then
    return { x=0, y=0, z=-1 }
  elseif direction.x == 0 and direction.z == -1 then
    return { x=-1, y=0, z=0 }
  else
    return nil
  end
end

-- returns the position of the next epic block
epic.get_next_pos = function(pos)
  local node = minetest.get_node(pos)
  local direction = param2_to_code_direction(node.param2)

  if direction == nil then
    return
  end

  local next_pos = vector.add(pos, direction)

  return next_pos
end

-- returns true if the node has an "epic" definition
epic.is_epic = function(node)
  local nodedef = minetest.registered_nodes[node.name]
  return nodedef.epic ~= nil
end

-- executes a single function
epic.execute_function = function(pos, player)
  minetest.log("action", "[epic] player " .. player:get_player_name() ..
    " executes function at " .. minetest.pos_to_string(pos))

  epic.state[player:get_player_name()] = {
    ip = pos,
    initialized = false,
    data = {},
    step_data = {}
  }
end

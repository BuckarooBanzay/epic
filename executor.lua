
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

epic.get_next_pos = function(pos)
  local node = minetest.get_node(pos)
  local direction = param2_to_code_direction(node.param2)

  if direction == nil then
    return
  end

  local next_pos = vector.add(pos, direction)

  return next_pos
end

epic.is_epic = function(node)
  local nodedef = minetest.registered_nodes[node.name]
  return nodedef.epic ~= nil
end

epic.execute_block = function(pos, node, player)
  minetest.log("action", "[epic] player " .. player:get_player_name() ..
    " executes block at " .. minetest.pos_to_string(pos))

  local nodedef = minetest.registered_nodes[node.name]
  local epicdef = nodedef.epic
  local meta = minetest.get_meta(pos)
  local ctx = {}

  if epicdef.on_enter then
    epicdef.on_enter(pos, meta, data, player, ctx)
  end

  return true
end

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

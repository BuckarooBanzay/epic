

local execute_player_state
execute_player_state = function(playername, state)
  local pos = state.ip
  local player = minetest.get_player_by_name(playername)

  local node = minetest.get_node(pos)
  if not epic.is_epic(node) then
    epic.state[playername] = nil
    return
  end

  local result_next = false
  local result_next_pos = nil
  local result_exit = false

  local ctx = {
    next = function(pos)
      result_next = true
      result_next_pos = pos
    end,
    exit = function()
      result_exit = true
    end,
    data = state.data,
    step_data = state.step_data
  }

  minetest.log("action", "[epic] player " .. player:get_player_name() ..
    " executes block at " .. minetest.pos_to_string(pos))

  local nodedef = minetest.registered_nodes[node.name]
  local epicdef = nodedef.epic
  local meta = minetest.get_meta(pos)

  if not state.initialized then
    state.initialized = true

    if epicdef.on_enter then
      epicdef.on_enter(pos, meta, player, ctx)
    end

  else
    if epicdef.on_check then
      epicdef.on_check(pos, meta, player, ctx)
    end
  end

  if result_exit or result_next then
    if epicdef.on_exit then
      epicdef.on_exit(pos, meta, player, ctx)
    end
  end

  if result_exit then
    epic.state[playername] = nil
  end

  if result_next then
    local next_pos = result_next_pos or epic.get_next_pos(pos)
    state.ip = next_pos
    state.initialized = false
    state.step_data = {}
    execute_player_state(playername, state)
  end

end


local executor
executor = function()
  for playername, state in pairs(epic.state) do
    execute_player_state(playername, state)
  end

  -- restart execution
  minetest.after(0.1, executor)
end

-- initial delay
minetest.after(1.0, executor)

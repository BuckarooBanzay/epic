

epic.execute_block = function(pos, node, player)
  minetest.log("action", "[epic] player " .. player:get_player_name() ..
    " executes block at " .. minetest.pos_to_string(pos))

  local nodedef = minetest.registered_nodes[node.name]
  local epicdef = nodedef.epic
  local meta = minetest.get_meta(pos)
  local ctx = {}
  local data = {}

  if epicdef.on_enter then
    epicdef.on_enter(pos, meta, data, player, ctx)
  end

  return true
end

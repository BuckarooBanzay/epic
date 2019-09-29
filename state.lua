
--[[
player_state = {
  ip = <pos>,
  initialized = false,
  data = {}
}
--]]

-- playername => player_state
epic.state = {}

minetest.register_on_joinplayer(function(player)
  -- TODO restore from disk
  -- epic.state[player:get_player_name()] = {}
end)

minetest.register_on_leaveplayer(function(player)
  -- TODO persist
  epic.state[player:get_player_name()] = nil
end)

minetest.register_globalstep(function(dtime)
  -- TODO persist periodically
end)

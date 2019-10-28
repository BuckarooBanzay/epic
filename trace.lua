
-- playername -> true
local trace_enabled = {}

-- playername -> id
local hud = {}

minetest.register_chatcommand("epic_trace", {
	description = "Toggles epic tracing",
  privs = { epic_debug = true },
	func = function(name)
    if trace_enabled[name] then
      trace_enabled[name] = nil
    else
      trace_enabled[name] = true
    end
	end
})

epic.register_hook({
  on_before_node_enter = function(pos, executing_player)
    for _, player in ipairs(minetest.get_connected_players()) do
      local name = player:get_player_name()
      if trace_enabled[name] then
        -- TODO
      end
    end
  end,

  on_before_node_exit = function(pos, executing_player)
  end
})


-- playername => enter-time in micros
local player_delays = {}

-- TODO: persistent

epic.register_opcode("epic:delay", {
	description = "Epic delay block",
  overlay = "epic_time.png",
  directions = {
    right = true
  },
  epic = {
    on_enter = function(pos, meta, data, player, ctx)
      local now = minetest.get_us_time()
      local playername = player:get_player_name()
      player_delays[playername] = now
    end,
    on_check = function(pos, meta, data, player, ctx)
      local now = minetest.get_us_time()
      local playername = player:get_player_name()
      local start = player_delays[playername]
      local diff = now - start
      if diff > 5*1000*1000 then
        ctx.next()
      end
    end,
    on_exit = function(pos, meta, data, player)
      local playername = player:get_player_name()
      player_delays[playername] = nil
    end
  }
})

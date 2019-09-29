
epic.register_opcode("epic:delay", {
	description = "Epic delay block",
  overlay = "epic_time.png",
  directions = {
    right = true
  },
  epic = {
    on_enter = function(pos, meta, data, player, ctx)
			data.delay_start = minetest.get_us_time()
    end,
    on_check = function(pos, meta, data, player, ctx)
      local now = minetest.get_us_time()
      local start = data.delay_start

      local diff = now - start
      if diff > 5*1000*1000 then
        ctx.next()
      end
    end,
    on_exit = function(pos, meta, data, player)
			data.delay_start = nil
    end
  }
})


minetest.register_node("epic:delay", {
	description = "Epic delay block",
	tiles = {
		"epic_node_bg.png",
		"epic_node_bg.png",
		"epic_node_bg.png",
		"epic_node_bg.png",
		"epic_node_bg.png",
		"epic_node_bg.png^epic_pause.png",
	},
	paramtype2 = "facedir",
	groups = {cracky=3,oddly_breakable_by_hand=3},
	on_rotate = screwdriver.rotate_simple,

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

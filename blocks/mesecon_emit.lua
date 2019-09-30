local update_formspec = function(meta, pos)
	local delay = meta:get_int("delay")
	meta:set_string("infotext", "Mesecons emit block: " .. delay .. " seconds")

	meta:set_string("formspec", "size[8,2;]" ..
		-- col 1
		"field[0.2,0.5;8,1;delay;Delay (seconds);" .. delay .. "]" ..

		-- col 2
		"button_exit[0.1,1.5;8,1;save;Save]" ..
		"")
end

minetest.register_node("epic:delay", {
	description = "Epic delay block",
	tiles = {
		"epic_node_bg.png",
		"epic_node_bg.png",
		"epic_node_bg.png",
		"epic_node_bg.png",
		"epic_node_bg.png",
		"epic_node_bg.png",
	},
	paramtype2 = "facedir",
	groups = {cracky=3,oddly_breakable_by_hand=3,epic=1,mesecon_needs_receiver=1},
	on_rotate = screwdriver.rotate_simple,

  on_construct = function(pos)
    local meta = minetest.get_meta(pos)
		meta:set_int("delay", 1)
    update_formspec(meta, pos)
  end,

  on_receive_fields = function(pos, formname, fields, sender)
    local meta = minetest.get_meta(pos);

		if not sender or minetest.is_protected(pos, sender:get_player_name()) then
			-- not allowed
			return
		end

    if fields.save then
      local delay = tonumber(fields.delay) or 1
	if delay < 0 then
		delay = 1
	end

	meta:set_int("delay", delay)
	update_formspec(meta, pos)
    end

  end,

  epic = {
    on_enter = function(pos, meta, player, ctx)
      ctx.data.delay_start = minetest.get_us_time()
      mesecon.receptor_on(pos)

    end,
    on_check = function(pos, meta, player, ctx)
      local now = minetest.get_us_time()
      local start = ctx.data.delay_start
      local delay_micros = meta:get_int("delay")*1000*1000

      local diff = now - start
      if diff > delay_micros then
        ctx.next()
      end
    end
    on_exit = function(pos)
      mesecon.receptor_off(pos)
    end
  }
})

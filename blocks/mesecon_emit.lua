local update_formspec = function(meta)
	local delay = meta:get_int("delay")
	meta:set_string("infotext", "Mesecons emit block: " .. delay .. " seconds")

	meta:set_string("formspec", "size[8,2;]" ..
		-- col 1
		"field[0.2,0.5;8,1;delay;Delay (seconds);" .. delay .. "]" ..

		-- col 2
		"button_exit[0.1,1.5;8,1;save;Save]" ..
		"")
end

minetest.register_node("epic:mesecon_emit", {
	description = "Epic mesecon emit block: emits a mesecons signal for 1 second",
	tiles = {
		"epic_node_bg.png",
		"epic_node_bg.png",
		"epic_node_bg.png",
		"epic_node_bg.png",
		"epic_node_bg.png",
		"epic_node_bg.png^epic_mese_crystal.png",
	},
	paramtype2 = "facedir",
	groups = {cracky=3,oddly_breakable_by_hand=3,epic=1},
	on_rotate = screwdriver.rotate_simple,
	mesecons = {receptor = {
		state = mesecon.state.off,
		rules = mesecon.rules.pplate
	}},

  on_construct = function(pos)
    local meta = minetest.get_meta(pos)
		meta:set_int("delay", 1)
    update_formspec(meta, pos)
  end,

  on_receive_fields = function(pos, _, fields, sender)
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
    on_enter = function(pos, _, _, ctx)
      ctx.data.delay_start = minetest.get_us_time()
      mesecon.receptor_on(pos)

    end,
    on_check = function(_, meta, _, ctx)
      local now = minetest.get_us_time()
      local start = ctx.data.delay_start
      local delay_micros = meta:get_int("delay")*1000*1000

      local diff = now - start
      if diff > delay_micros then
        ctx.next()
      end
    end,
    on_exit = function(pos)
      mesecon.receptor_off(pos)
    end
  }
})

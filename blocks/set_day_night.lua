local update_formspec = function(meta)
	local ratio = meta:get_string("ratio")
	meta:set_string("infotext", "Day night block: ratio=" .. ratio)

	meta:set_string("formspec", "size[8,2;]" ..
		-- col 1
		"field[0.2,0.5;8,1;ratio;Ratio (0...1 or empty);" .. ratio .. "]" ..

		-- col 2
		"button_exit[0.1,1.5;8,1;save;Save]" ..
		"")
end

minetest.register_node("epic:daynightratio", {
	description = "Epic day night ratio block: sets the day-night-ratio for the player",
	tiles = {
		"epic_node_bg.png",
		"epic_node_bg.png",
		"epic_node_bg.png",
		"epic_node_bg.png",
		"epic_node_bg.png",
		"epic_node_bg.png^epic_sky.png",
	},
	paramtype2 = "facedir",
	groups = {cracky=3,oddly_breakable_by_hand=3,epic=1},
	on_rotate = screwdriver.rotate_simple,

  on_construct = function(pos)
    local meta = minetest.get_meta(pos)
		meta:set_string("ratio", "")
    update_formspec(meta, pos)
  end,

  on_receive_fields = function(pos, _, fields, sender)
    local meta = minetest.get_meta(pos);

		if not sender or minetest.is_protected(pos, sender:get_player_name()) then
			-- not allowed
			return
		end

    if fields.save then
      local ratio = tonumber(fields.ratio)
			if not ratio then
				meta:set_string("ratio", "")
			elseif ratio < 0 then
				meta:set_string("ratio", "0")
			elseif ratio > 1 then
				meta:set_string("ratio", "1")
			else
				meta:set_string("ratio", ratio)
			end

			update_formspec(meta, pos)
    end

  end,

  epic = {
    on_enter = function(_, meta, player, ctx)
			local ratio = meta:get_string("ratio")
			if ratio == "" then
				player:override_day_night_ratio(nil)
			else
				player:override_day_night_ratio(tonumber(ratio))
			end

			ctx.next()
    end,
  }
})

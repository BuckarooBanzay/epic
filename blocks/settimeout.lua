local update_formspec = function(meta)
	local timeout = meta:get_int("timeout")
	meta:set_string("infotext", "Settimeout block: " .. timeout .. " seconds")

	meta:set_string("formspec", "size[8,2;]" ..
		-- col 1
		"field[0.2,0.5;8,1;timeout;Timeout (seconds);" .. timeout .. "]" ..

		-- col 2
		"button_exit[0.1,1.5;8,1;save;Save]" ..
		"")
end

minetest.register_node("epic:settimeout", {
	description = "Epic set timeout block: configures the current quest timeout",
	tiles = {
		"epic_node_bg.png",
		"epic_node_bg.png",
		"epic_node_bg.png",
		"epic_node_bg.png",
		"epic_node_bg.png",
		"epic_node_bg.png^epic_clock.png",
	},
	paramtype2 = "facedir",
	groups = {cracky=3,oddly_breakable_by_hand=3,epic=1},
	on_rotate = screwdriver.rotate_simple,

  on_construct = function(pos)
    local meta = minetest.get_meta(pos)
		meta:set_int("timeout", 300)
    update_formspec(meta, pos)
  end,

  on_receive_fields = function(pos, _, fields, sender)
    local meta = minetest.get_meta(pos);

		if not sender or minetest.is_protected(pos, sender:get_player_name()) then
			-- not allowed
			return
		end

    if fields.save then
      local timeout = tonumber(fields.timeout) or 5
			if timeout < 0 then
				timeout = 1
			end

			meta:set_int("timeout", timeout)
			update_formspec(meta, pos)
    end

  end,

  epic = {
    on_enter = function(_, meta, _, ctx)
			local timeout = meta:get_int("timeout") or 300
			ctx.settimeout(timeout)
			ctx.next()
    end
  }
})

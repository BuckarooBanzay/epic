
-- playername => pos
local punch_handler = {}

local update_formspec = function(meta)
	local pos = meta:get_string("pos")
	local name = meta:get_string("name")
	local radius = meta:get_int("radius")

	meta:set_string("infotext", "Inverse waypoint block: pos=" .. pos ..
		", radius=" .. radius)

	meta:set_string("formspec", "size[8,4;]" ..
		"field[0.2,0.5;8,1;radius;Radius;" .. radius .. "]" ..

		"field[0.2,1.5;8,1;name;Name;" .. name .. "]" ..

		"button_exit[0.1,2.5;4,1;setpos;Set]" ..
		"button_exit[4.1,2.5;4,1;showpos;Show]" ..

		"button_exit[0.1,3.5;8,1;save;Save]" ..
		"")
end

minetest.register_node("epic:waypoint_inverse", {
	description = "Epic inverse waypoint block: checks if the player is outside of the defined radius",
	tiles = {
		"epic_node_bg.png",
		"epic_node_bg.png",
		"epic_node_bg.png",
		"epic_node_bg.png",
		"epic_node_bg.png",
		"epic_node_bg.png^epic_waypoint.png",
	},
	paramtype2 = "facedir",
	groups = {cracky=3,oddly_breakable_by_hand=3,epic=1},
	on_rotate = screwdriver.rotate_simple,

	on_construct = function(pos)
    local meta = minetest.get_meta(pos)
		meta:set_string("name", "Waypoint")
		meta:set_string("pos", minetest.pos_to_string({x=0, y=0, z=0}))
		meta:set_int("radius", 3)
    update_formspec(meta, pos)
  end,

  on_receive_fields = function(pos, _, fields, sender)
		if not sender or minetest.is_protected(pos, sender:get_player_name()) then
			-- not allowed
			return
		end

		local meta = minetest.get_meta(pos);

    if fields.save or fields.setpos then
			local radius = tonumber(fields.radius) or 3
			if radius < 0 then
				radius = 1
			end

			meta:set_int("radius", radius)
			meta:set_string("name", fields.name or "")
			update_formspec(meta, pos)
    end

		if fields.setpos then
			minetest.chat_send_player(sender:get_player_name(), "[epic] Please punch the desired target position")
			punch_handler[sender:get_player_name()] = pos
		end

		if fields.showpos then
			local target_pos = minetest.string_to_pos(meta:get_string("pos"))
			if target_pos then
				epic.show_waypoint(sender:get_player_name(), epic.to_absolute_pos(pos, target_pos), "Target position", 10)
			end
		end

  end,

	epic = {
    on_enter = function(pos, meta, player, ctx)
			local target_pos = epic.to_absolute_pos(pos, minetest.string_to_pos(meta:get_string("pos")))
			ctx.step_data.pos = target_pos
			ctx.step_data.radius = meta:get_int("radius")
			local waypoint_name = meta:get_string("name")

			if waypoint_name ~= "" then
				ctx.step_data.waypoint_hud_id = player:hud_add({
					hud_elem_type = "waypoint",
					name = waypoint_name,
					text = "m",
					number = 0x00FF00,
					world_pos = target_pos
				})
			end
    end,
    on_check = function(_, _, player, ctx)
			local pos = player:get_pos()
			if vector.distance(pos, ctx.step_data.pos) > ctx.step_data.radius then
				ctx.next()
			end
    end,
    on_exit = function(_, _, player, ctx)
			if ctx.step_data.waypoint_hud_id then
				player:hud_remove(ctx.step_data.waypoint_hud_id)
			end
    end
  }
})

minetest.register_on_punchnode(function(pos, _, puncher, _)
	local playername = puncher:get_player_name()
	local cfg_pos = punch_handler[playername]
	if cfg_pos then
		local meta = minetest.get_meta(cfg_pos)
		local pos_str = minetest.pos_to_string(epic.to_relative_pos(cfg_pos, pos))
		meta:set_string("pos", pos_str)
		minetest.chat_send_player(playername, "[epic] target position successfully set to " .. pos_str)
		update_formspec(meta, cfg_pos)
		punch_handler[playername] = nil
	end
end)

minetest.register_on_leaveplayer(function(player)
	local playername = player:get_player_name()
	punch_handler[playername] = nil

end)

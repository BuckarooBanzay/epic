
local update_formspec = function(meta)
	local pos = meta:get_string("pos")
	local param2 = meta:get_string("param2")

	meta:set_string("infotext", "Set param2: pos=" .. pos .. " param2=" .. param2)

	meta:set_string("formspec", "size[8,3;]" ..
		"button_exit[0.1,0.1;4,1;setpos;Set position]" ..
		"button_exit[4.1,0.1;4,1;showpos;Show]" ..

		"field[0.2,1.5;8,1;param2;Param2;" .. param2 .. "]" ..
		"button_exit[0.1,2.5;8,1;save;Save]" ..

		"")
end

local function do_set_param2(pos, meta)
	local target_pos = minetest.string_to_pos(meta:get_string("pos"))
	local abs_pos = epic.to_absolute_pos(pos, target_pos)

	local node = epic.get_node(abs_pos)
	local param2 = meta:get_string("param2")

	node.param2 = tonumber(param2) or 0
	minetest.swap_node(abs_pos, node)
end

minetest.register_node("epic:set_param2", {
	description = "Epic set param2 block: Sets the param2 value on doors or other blocks",
	tiles = {
		"epic_node_bg.png",
		"epic_node_bg.png",
		"epic_node_bg.png",
		"epic_node_bg.png",
		"epic_node_bg.png",
		"epic_node_bg.png^epic_filter.png",
	},
	paramtype2 = "facedir",
	groups = {cracky=3,oddly_breakable_by_hand=3,epic=1},
	on_rotate = screwdriver.rotate_simple,

	on_construct = function(pos)
    local meta = minetest.get_meta(pos)
		meta:set_string("pos", minetest.pos_to_string({x=0, y=0, z=0}))
		meta:set_string("param2", "0")

    update_formspec(meta, pos)
  end,

  on_receive_fields = function(pos, _, fields, sender)
		local playername = sender:get_player_name()
		if not sender or minetest.is_protected(pos, playername) then
			-- not allowed
			return
		end

		local meta = minetest.get_meta(pos);

		if fields.save then
			local param2 = tonumber(fields.param2) or 0
			if param2 < 0 or param2 > 255 then
				param2 = 0
			end

			meta:set_int("param2", param2)
			update_formspec(meta, pos)
		end

		if fields.setpos then
			minetest.chat_send_player(playername, "[epic] Please punch the desired target position")
			epic.punchnode_callback(sender, {
			  timeout = 300,
			  callback = function(punch_pos)
					local pos_str = minetest.pos_to_string(epic.to_relative_pos(pos, punch_pos))
					meta:set_string("pos", pos_str)
					minetest.chat_send_player(playername, "[epic] target position successfully set to " .. pos_str)

					-- apply param2 from punched node
					local node = epic.get_node(punch_pos)
					meta:set_string("param2", node.param2)

					update_formspec(meta)
				end
			})
		end

		if fields.showpos then
			local target_pos = minetest.string_to_pos(meta:get_string("pos"))
			if target_pos then
				epic.show_waypoint(
					sender:get_player_name(),
					epic.to_absolute_pos(pos, target_pos),
					"Target position", 2
				)
			end
		end
  end,

	-- allow mesecons triggering
	mesecons = {
		effector = {
	    action_on = function (pos)
				local meta = minetest.get_meta(pos)
				do_set_param2(pos, meta)
			end
	  }
	},

	epic = {
    on_enter = function(pos, meta, _, ctx)
			do_set_param2(pos, meta)
			ctx.next()
    end
  }
})

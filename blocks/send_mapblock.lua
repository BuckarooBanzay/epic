
local update_formspec = function(meta)
	local pos = meta:get_string("pos")

	meta:set_string("infotext", "Send mapblock block: pos=" .. pos)

	meta:set_string("formspec", "size[8,1;]" ..
		-- col 2
		"button_exit[0.1,0.5;4,1;setpos;Set position]" ..
		"button_exit[4.1,0.5;4,1;showpos;Show]" ..
		"")
end

minetest.register_node("epic:send_mapblock", {
	description = "Epic send_mapblock block: sends the target mapblock to the client",
	tiles = {
		"epic_node_bg.png",
		"epic_node_bg.png",
		"epic_node_bg.png",
		"epic_node_bg.png",
		"epic_node_bg.png",
		"epic_node_bg.png^epic_anchor.png",
	},
	paramtype2 = "facedir",
	groups = {cracky=3,oddly_breakable_by_hand=3,epic=1},
	on_rotate = screwdriver.rotate_simple,

	on_construct = function(pos)
    local meta = minetest.get_meta(pos)
		meta:set_string("pos", minetest.pos_to_string({x=0, y=0, z=0}))
    update_formspec(meta, pos)
  end,

  on_receive_fields = function(pos, _, fields, sender)
		if not sender or minetest.is_protected(pos, sender:get_player_name()) then
			-- not allowed
			return
		end

		local meta = minetest.get_meta(pos);
		local playername = sender:get_player_name()

		if fields.setpos then
			minetest.chat_send_player(playername, "[epic] Please punch the desired target position")
			epic.punchnode_callback({
			  timeout = 300,
			  callback = function(punch_pos)
					local pos_str = minetest.pos_to_string(epic.to_relative_pos(pos, punch_pos))
					meta:set_string("pos", pos_str)
					minetest.chat_send_player(playername, "[epic] target position successfully set to " .. pos_str)
					update_formspec(meta)
				end
			})
		end

		if fields.showpos then
			local target_pos = minetest.string_to_pos(meta:get_string("pos"))
			if target_pos then
				epic.show_waypoint(sender:get_player_name(), epic.to_absolute_pos(pos, target_pos), "Target position", 2)
			end
		end

  end,

	epic = {
    on_enter = function(pos, meta, player, ctx)
			local rel_pos = minetest.string_to_pos(meta:get_string("pos"))
			local target_pos = epic.to_absolute_pos(pos, rel_pos)
			local block_pos = {
				x = math.floor(target_pos.x / 16),
				y = math.floor(target_pos.y / 16),
				z = math.floor(target_pos.z / 16)
			}
			player:send_mapblock(block_pos)
			ctx.next()
    end
  }
})

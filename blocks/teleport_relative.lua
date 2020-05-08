
-- playername => pos
local punch_handler_source = {}
local punch_handler_target = {}

local update_formspec = function(meta)
	local source = meta:get_string("source")
	local target = meta:get_string("target")

	meta:set_string("infotext", "Teleport relative block: source=" .. source ..
		" target=" .. target)

	meta:set_string("formspec", "size[8,2;]" ..
		"label[0,0.5;Source]" ..
		"label[2,0.5;" .. source .. "]" ..
		"button_exit[4,0.5;2,1;setsource;Set]" ..
		"button_exit[6,0.5;2,1;showsource;Show]" ..

		"label[0,1.5;Target]" ..
		"label[2,1.5;" .. target .. "]" ..
		"button_exit[4,1.5;2,1;settarget;Set]" ..
		"button_exit[6,1.5;2,1;showtarget;Show]" ..

		"")
end

minetest.register_node("epic:teleport_relative", {
	description = "Epic Teleport relative block: teleports the player to the target coordinates " ..
		"with respect to the source-coordinates (smooth teleport)",
	tiles = {
		"epic_node_bg.png",
		"epic_node_bg.png",
		"epic_node_bg.png",
		"epic_node_bg.png",
		"epic_node_bg.png",
		"epic_node_bg.png^epic_teleport.png",
	},
	paramtype2 = "facedir",
	groups = {cracky=3,oddly_breakable_by_hand=3,epic=1},
	on_rotate = screwdriver.rotate_simple,

	on_construct = function(pos)
    local meta = minetest.get_meta(pos)
		meta:set_string("source", minetest.pos_to_string({x=0, y=0, z=0}))
		meta:set_string("target", minetest.pos_to_string({x=0, y=0, z=0}))
    update_formspec(meta, pos)
  end,

  on_receive_fields = function(pos, _, fields, sender)
		if not sender or minetest.is_protected(pos, sender:get_player_name()) then
			-- not allowed
			return
		end

		local meta = minetest.get_meta(pos);

		if fields.setsource then
			minetest.chat_send_player(sender:get_player_name(), "[epic] Please punch the desired source position")
			punch_handler_source[sender:get_player_name()] = pos
		end

		if fields.settarget then
			minetest.chat_send_player(sender:get_player_name(), "[epic] Please punch the desired target position")
			punch_handler_target[sender:get_player_name()] = pos
		end

		if fields.showsource then
			local show_pos = minetest.string_to_pos(meta:get_string("source"))
			if show_pos then
				epic.show_waypoint(sender:get_player_name(), epic.to_absolute_pos(pos, show_pos), "Source position", 2)
			end
		end

		if fields.showtarget then
			local show_pos = minetest.string_to_pos(meta:get_string("target"))
			if show_pos then
				epic.show_waypoint(sender:get_player_name(), epic.to_absolute_pos(pos, show_pos), "Target position", 2)
			end
		end

  end,

	epic = {
    on_enter = function(pos, meta, player, ctx)
			local source_pos = epic.to_absolute_pos(pos, minetest.string_to_pos(meta:get_string("source")))
			local target_pos = epic.to_absolute_pos(pos, minetest.string_to_pos(meta:get_string("target")))
			local player_pos = player:get_pos()

			if source_pos and target_pos then
				local delta = vector.subtract(player_pos, source_pos)
				local new_pos = vector.add(target_pos, delta)
				-- TODO: account for player:get_velocity()
				player:set_pos(new_pos)
			end
			ctx.next()
    end
  }
})

minetest.register_on_punchnode(function(pos, _, puncher, _)
	local playername = puncher:get_player_name()

	local cfg_pos = punch_handler_source[playername]
	if cfg_pos then
		if minetest.is_protected(pos, playername) and
			not minetest.check_player_privs(playername, {epic_admin=true}) then
			minetest.chat_send_player(playername, "[epic] target is protected! aborting selection.")

		else
			local meta = minetest.get_meta(cfg_pos)
			local pos_str = minetest.pos_to_string(epic.to_relative_pos(cfg_pos, vector.add(pos, {x=0, y=0.5, z=0})))
			meta:set_string("source", pos_str)
			update_formspec(meta)
			minetest.chat_send_player(playername, "[epic] source position successfully set to " .. pos_str)

		end
		punch_handler_source[playername] = nil
	end

	cfg_pos = punch_handler_target[playername]
	if cfg_pos then
		if minetest.is_protected(pos, playername) and
			not minetest.check_player_privs(playername, {epic_admin=true}) then
			minetest.chat_send_player(playername, "[epic] target is protected! aborting selection.")

		else
			local meta = minetest.get_meta(cfg_pos)
			local pos_str = minetest.pos_to_string(epic.to_relative_pos(cfg_pos, vector.add(pos, {x=0, y=0.5, z=0})))
			meta:set_string("target", pos_str)
			update_formspec(meta)
			minetest.chat_send_player(playername, "[epic] target position successfully set to " .. pos_str)

		end
		punch_handler_target[playername] = nil
	end
end)

minetest.register_on_leaveplayer(function(player)
	local playername = player:get_player_name()
	punch_handler_source[playername] = nil
	punch_handler_target[playername] = nil
end)

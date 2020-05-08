
-- playername => pos
local punch_handler = {}

local update_formspec = function(meta)
	local pos = meta:get_string("pos")

	meta:set_string("infotext", "on_exit callback block: function=" .. pos)

	meta:set_string("formspec", "size[8,1;]" ..
		-- col 2
		"button_exit[0.1,0.5;4,1;setfn;Set function]" ..
    "button_exit[4.1,0.5;4,1;showpos;Show]" ..
		"")
end

minetest.register_node("epic:on_exit", {
	description = "Epic on_exit callback block: stores an exit-function to execute in the exit case",
	tiles = {
		"epic_node_bg.png",
		"epic_node_bg.png",
		"epic_node_bg.png",
		"epic_node_bg.png",
		"epic_node_bg.png",
		"epic_node_bg.png^epic_exit.png",
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

		if fields.setfn then
			minetest.chat_send_player(sender:get_player_name(), "[epic] Please punch the desired target function")
			punch_handler[sender:get_player_name()] = pos
		end

		if fields.showpos then
			local meta = minetest.get_meta(pos)
			local target_pos = minetest.string_to_pos(meta:get_string("pos"))
			if target_pos then
			        epic.show_waypoint(
								sender:get_player_name(),
								epic.to_absolute_pos(pos, target_pos),
								"Target position",
								2
							)
			end
		end
  end,

	epic = {
    on_enter = function(pos, meta, _, ctx)
			local target_pos_str = meta:get_string("pos")
			local here_pos_str = minetest.pos_to_string({x=0, y=0, z=0})
			if here_pos_str ~= target_pos_str then
				-- position of configured node
				local target_pos = epic.to_absolute_pos(pos, minetest.string_to_pos(target_pos_str))

				-- set hook for player
				ctx.data.exit_callback_pos = target_pos
				ctx.next()
			else
				-- recursion detected, proceed to next
				ctx.next()
			end
    end
  }
})

minetest.register_on_punchnode(function(pos, node, puncher)
	local playername = puncher:get_player_name()
	local cfg_pos = punch_handler[playername]
	if cfg_pos then
		if minetest.is_protected(pos, playername) and
			not minetest.check_player_privs(playername, {epic_admin=true}) then
			minetest.chat_send_player(playername, "[epic] target is protected! aborting selection.")

		elseif node.name ~= "epic:function" then
			minetest.chat_send_player(playername, "[epic] target is not a function! aborting selection.")

		else
			local meta = minetest.get_meta(cfg_pos)
			local pos_str = minetest.pos_to_string(epic.to_relative_pos(cfg_pos, pos))
			meta:set_string("pos", pos_str)
			minetest.chat_send_player(playername, "[epic] target function successfully set to " .. pos_str)
			update_formspec(meta)

		end
		punch_handler[playername] = nil
	end
end)

minetest.register_on_leaveplayer(function(player)
	local playername = player:get_player_name()
	punch_handler[playername] = nil
end)


epic.register_hook({
  -- called on epic exit
  on_epic_exit = function(playername, state)
		if state.data.exit_callback_pos then
			local node = epic.get_node(state.data.exit_callback_pos)
			if node.name == "epic:function" then
				-- modify instruction pointer on state, flush stack
				local new_state = epic.new_state()
				new_state.ip = state.data.exit_callback_pos
				epic.state[playername] = nil
				epic.execute_player_state(playername, new_state)
			end
		end
	end,
})


-- time in seconds between executor calls
local executor_dtime = 0.1

function epic.execute_player_state(playername, state)
	local pos = state.ip
	local player = minetest.get_player_by_name(playername)

	if not player then
		minetest.log("warn", "[epic][executor] player not found, aborting: " .. playername)
		return
	end

	epic.debug("[executor] execute_player_state(" .. playername .. "))")

	if not pos then
		-- invalid state
		epic.state[playername] = nil
		minetest.log("warn", "[epic][executor] invalid opcode encountered, state-dump: " .. dump(state))
		return
	end

	local node = epic.get_node(pos)

	if not epic.is_epic(node) then
		-- no more instructions in this branch
		epic.debug("[executor] no more instructions in this branch @ " ..
		minetest.pos_to_string(pos) .. " node: " .. node.name)

		if #state.stack > 0 then
			-- pop stack
			state.ip = table.remove(state.stack, #state.stack)
			state.initialized = false
			state.step_data = {}
			epic.debug("[executor] pop stack result: " .. minetest.pos_to_string(state.ip))

			epic.execute_player_state(playername, state)
		else
			-- done
			epic.state[playername] = nil
			epic.run_hook("on_epic_exit", {playername, state})
		end

		return
	end

	local result_next = false
	local result_next_pos = nil
	local abort_flag = state.abort

	local ctx = {
		-- next step
		next = function(_pos)
			result_next = true
			result_next_pos = _pos
		end,
		-- abort epic with given reason
		abort = function(reason)
			abort_flag = reason or "ctx.abort"
		end,
		-- call another epic block
		call = function(_pos)
			-- push next ip
			local next_pos = epic.get_next_pos(pos)
			local next_node = epic.get_node(next_pos)
			if epic.is_epic(next_node) then
				-- this branch has more instructions, push the next onto the stack
				table.insert(state.stack, next_pos)
			end
			result_next = true
			result_next_pos = _pos
		end,
		-- set the new timeout
		settimeout = function(seconds)
			state.time = seconds
		end,
		data = state.data,
		step_data = state.step_data
	}

	local nodedef = minetest.registered_nodes[node.name]
	local epicdef = nodedef.epic
	local meta = minetest.get_meta(pos)

	if not state.initialized then
		state.initialized = true

		epic.run_hook("on_before_node_enter", { pos, player, ctx })
		if epicdef.on_enter then
			epicdef.on_enter(pos, meta, player, ctx)
		end

	else
		epic.run_hook("on_before_node_check", { pos, player, ctx })
		if epicdef.on_check then
			epicdef.on_check(pos, meta, player, ctx)
		end
	end

	if state.time then
		state.time = state.time - executor_dtime
		if state.time < 0 then
			abort_flag = "epic_timeout"
		end
	end

	if abort_flag or result_next then
		epic.run_hook("on_before_node_exit", { pos, player, ctx })
		if epicdef.on_exit then
			epicdef.on_exit(pos, meta, player, ctx)
		end
	end

	if abort_flag then
		epic.state[playername] = nil
		epic.run_hook("on_epic_abort", { playername, state, abort_flag })
		return
	end

	if result_next then
		local next_pos = result_next_pos or epic.get_next_pos(pos)
		state.ip = next_pos
		state.initialized = false
		state.step_data = {}
		epic.execute_player_state(playername, state)
	end

end


local function executor()
	local t0 = minetest.get_us_time()
	for playername, state in pairs(epic.state) do
		if not minetest.get_player_by_name(playername) then
			-- player is gone, clear state
			epic.state[playername] = nil
		else
			-- player is still online
			epic.execute_player_state(playername, state)
		end
	end
	local t1 = minetest.get_us_time()
	local stats = {
		time = t1-t0
	}
	epic.run_hook("globalstep_stats", { stats })

	-- restart execution
	minetest.after(executor_dtime, executor)
end

-- initial delay
minetest.after(1.0, executor)


-- abort epic on leave
-- savepoints are not touched here
minetest.register_on_leaveplayer(function(player, timed_out)
	local playername = player:get_player_name()
	local state = epic.state[playername]
	if state then
		local reason
		if timed_out then
			reason = "leave_timed_out"
		else
			reason = "leave"
		end
		if epic.log_executor then
			minetest.log("action", "[epic] player left the game: " .. playername)
		end

		epic.state[playername] = nil
		epic.run_hook("on_epic_abort", { playername, state, reason })
	end
end)

minetest.register_on_dieplayer(function(player)
	local playername = player:get_player_name()
	local state = epic.state[playername]
	if state then
		if epic.log_executor then
			minetest.log("action", "[epic] player died: " .. playername)
		end
		epic.state[playername] = nil
		epic.run_hook("on_epic_abort", { playername, state, "died" })
	end
end)


local textures = {
	default = "epic_node_bg.png",
	action = "epic_node_action.png",
	condition = "epic_node_condition.png"
}

if minetest.get_modpath("scifi_nodes") then
	textures = {
		default = "scifi_nodes_grey_square.png",
		action = "scifi_nodes_red_square.png",
		condition = "scifi_nodes_blue_square.png",
		control = "scifi_nodes_green_square.png"
	}
end

function epic.create_texture(type, overlay, options)
	local texture = textures[type] or textures.default
	options = options or {}

	return {
		texture,
		texture,
		texture .. (options.disable_marker and "" or "^epic_next_marker.png"),
		texture,
		texture,
		texture .. "^" .. overlay,
	}
end

local has_screwdriver = minetest.get_modpath("screwdriver")

-- local on_rotate function
function epic.on_rotate(...)
	if has_screwdriver then
		-- call rotation function on screwdriver mod if available
		screwdriver.rotate_simple(...)
	end
end

-- creates an empty state, ready for execution
function epic.new_state()
	return {
		stack = {},
		data = {},
		step_data = {},
		initialized = false
	}
end

-- starts the configured epic node at position
function epic.start(playername, pos)

	local player = minetest.get_player_by_name(playername)

	if not player then
		-- player not online
		return false
	end

	local meta = minetest.get_meta(pos)
	local main_pos = epic.to_absolute_pos(pos, minetest.string_to_pos(meta:get_string("main_pos")))
	local epic_name = meta:get_string("name")

	if not main_pos then
		-- no main position
		return false
	end

	-- start epic
	epic.execute_epic(player, main_pos, epic_name)

	return true
end

-- abort epic if running
function epic.abort(playername)
	local state = epic.state[playername]
	if state then
		if epic.log_executor then
			minetest.log("action", "[epic] player aborted manually: " .. playername)
		end
		state.abort = "manual"
	end
end

-- debug log
function epic.debug(msg)
	if epic.log_executor then
		minetest.log("action", "[epic] " .. msg)
	end
end

-- converts a pos to a relative one in respect to the node_pos
function epic.to_relative_pos(node_pos, remote_abs_pos)
	if not node_pos or not remote_abs_pos then
		return
	end
	return vector.subtract(remote_abs_pos, node_pos)
end

-- converts the relative pos to an absolute one
function epic.to_absolute_pos(node_pos, remote_rel_pos)
	if not node_pos or not remote_rel_pos then
		return
	end
	return vector.add(node_pos, remote_rel_pos)
end


-- shows a waypoint for given seconds
function epic.show_waypoint(playername, pos, name, seconds)
	local player = minetest.get_player_by_name(playername)
	if not player then
		return
	end

	local id = player:hud_add({
		[minetest.features.hud_def_type_field and "type" or "hud_elem_type"] = "waypoint",
		name = name,
		text = "m",
		number = 0xFF0000,
		world_pos = pos
	})

	minetest.after(seconds, function()
		player = minetest.get_player_by_name(playername)
		if not player then
			return
		end

		player:hud_remove(id)
	end)
end


local SECONDS_IN_DAY = 3600*24
local SECONDS_IN_HOUR = 3600
local SECONDS_IN_MINUTE = 60

function epic.format_time(seconds)
	local str = ""


	if seconds >= SECONDS_IN_DAY then
		local days = math.floor(seconds / SECONDS_IN_DAY)
		str = str .. days .. " d "
		seconds = seconds - (days * SECONDS_IN_DAY)
	end

	if seconds >= SECONDS_IN_HOUR then
		local hours = math.floor(seconds / SECONDS_IN_HOUR)
		str = str .. hours .. " h "
		seconds = seconds - (hours * SECONDS_IN_HOUR)
	end

	if seconds >= SECONDS_IN_MINUTE then
		local minutes = math.floor(seconds / SECONDS_IN_MINUTE)
		str = str .. minutes .. " min "
		seconds = seconds - (minutes * SECONDS_IN_MINUTE)
	end

	str = str .. math.floor(seconds) .. " s"

	return str
end

-- converts the direction from a param2
function epic.get_direction(param2)
	local direction = minetest.facedir_to_dir(param2)
	if direction.x == -1 and direction.z == 0 then
		return { x=0, y=0, z=1 }
	elseif direction.x == 0 and direction.z == 1 then
		return { x=1, y=0, z=0 }
	elseif direction.x == 1 and direction.z == 0 then
		return { x=0, y=0, z=-1 }
	elseif direction.x == 0 and direction.z == -1 then
		return { x=-1, y=0, z=0 }
	else
		return nil
	end
end

-- returns the position of the next epic block
function epic.get_next_pos(pos)
	local node = minetest.get_node(pos)
	local direction = epic.get_direction(node.param2)

	if direction == nil then
		return
	end

	local next_pos = vector.add(pos, direction)

	return next_pos
end

-- returns a node and loads the area if needed
function epic.get_node(pos)
	local node = minetest.get_node_or_nil(pos)
	if node == nil then
		minetest.get_voxel_manip(pos, pos)
		node = minetest.get_node_or_nil(pos)
	end
	return node
end

-- returns true if the node has an "epic" definition
function epic.is_epic(node)
	local nodedef = minetest.registered_nodes[node.name]
	return nodedef and nodedef.epic
end

-- executes an epic function
function epic.execute_epic(player, main_pos, name)
	if epic.state[player:get_player_name()] then
		-- already running a function
		return
	end

	minetest.log("action", "[epic] player " .. player:get_player_name() ..
		" executes function at " .. minetest.pos_to_string(main_pos))

	local state = epic.new_state()

	state.ip = main_pos
	state.name = name

	epic.state[player:get_player_name()] = state
	epic.run_hook("on_execute_epic", { player, main_pos, state })

end

function epic.get_mapblock_pos(pos)
	return {
		x = math.floor(pos.x / 16),
		y = math.floor(pos.y / 16),
		z = math.floor(pos.z / 16)
	}
end


epic.show_waypoint = function(playername, pos, name, seconds)
	local player = minetest.get_player_by_name(playername)
	if not player then
		return
	end

	local id = player:hud_add({
		hud_elem_type = "waypoint",
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

epic.format_time = function(seconds)
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

	str = str .. seconds .. " s"

	return str
end

-- converts the direction from a param2
epic.get_direction = function(param2)
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
epic.get_next_pos = function(pos)
  local node = minetest.get_node(pos)
  local direction = epic.get_direction(node.param2)

  if direction == nil then
    return
  end

  local next_pos = vector.add(pos, direction)

  return next_pos
end

-- returns a node and loads the area if needed
epic.get_node = function(pos)
	local node = minetest.get_node_or_nil(pos)
	if node == nil then
		minetest.get_voxel_manip(pos, pos)
		node = minetest.get_node_or_nil(pos)
	end
	return node
end

-- returns true if the node has an "epic" definition
epic.is_epic = function(node)
  local nodedef = minetest.registered_nodes[node.name]
  return nodedef.epic ~= nil
end

-- executes a single function
epic.execute_function = function(player, main_pos, exit_pos)
  if epic.state[player:get_player_name()] then
    -- already running a function
    return
  end

  minetest.log("action", "[epic] player " .. player:get_player_name() ..
    " executes function at " .. minetest.pos_to_string(main_pos))

	epic.run_hook("on_execute_function", { player, main_pos, exit_pos })

  epic.state[player:get_player_name()] = {
    ip = main_pos,
    stack = {},
    initialized = false,
		exit_pos = exit_pos,
    data = {},
    step_data = {}
  }
end

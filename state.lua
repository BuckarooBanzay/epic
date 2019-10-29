
local basedir = minetest.get_worldpath().."/epic"

minetest.mkdir(basedir)

local getStateFile = function(playername)
	local saneplayername = string.gsub(playername, "[.|/]", "")
	return basedir .. "/" .. saneplayername .. ".json"
end

-- returns the current state or nil
epic.get_state = function(playername)
	return epic.state[playername]
end

epic.save_player_state = function(playername)
  local state = epic.get_state(playername)

  local file = io.open(getStateFile(playername),"w")
	local json = minetest.write_json(state)
	if file and file:write(json) and file:close() then
		return
	else
		minetest.log("error","[epic] Save failed - state may be lost!")
		return
	end
end

epic.load_player_state = function(playername)
	local file = io.open(getStateFile(playername), "r")
	local state = nil
	if file then
		local json = file:read("*a")
		state = minetest.parse_json(json or "")

		if not state then
			return nil
		end

		state.initialized = false
		state.step_data = {}
		state.data = state.data or {}
		state.stack = state.stack or {}
		file:close()

		epic.run_hook("on_state_restored", { playername, state })
	end

	return state
end

minetest.register_on_joinplayer(function(player)
  -- restore from disk
  local playername = player:get_player_name()
  epic.state[playername] = epic.load_player_state(playername)
end)

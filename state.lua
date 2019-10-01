
-- playername => player_state
epic.state = {}

local getStateFile = function(playername)
	local saneplayername = string.gsub(playername, "[.|/]", "")
	return minetest.get_worldpath().."/epic/" .. saneplayername .. ".json"
end

epic.save_player_state = function(playername)
  local state = epic.state[playername]

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
		state = minetest.parse_json(json or "") or {}
		file:close()
	end

	return state
end

minetest.register_on_joinplayer(function(player)
  -- restore from disk
  local playername = player:get_player_name()
  epic.state[playername] = epic.load_player_state(playername)
end)

minetest.register_on_leaveplayer(function(player)
  -- clear on leave/timeout
  local playername = player:get_player_name()
  epic.state[playername] = nil
end)


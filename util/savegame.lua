local basedir = minetest.get_worldpath() .. "/epic_savegame"

minetest.mkdir(basedir)

epic.savegame = {}

local getStateFile = function(playername)
	local saneplayername = string.gsub(playername, "[.|/]", "")
	return basedir .. "/" .. saneplayername .. ".json"
end

epic.savegame.save = function(playername, savegame)
  local file = io.open(getStateFile(playername),"w")
	local json = minetest.write_json(savegame)
	if file and file:write(json) and file:close() then
		return
	else
		minetest.log("error","[epic] Savegame failed - state may be lost!")
		return
	end
end

epic.savegame.load = function(playername)
	local file = io.open(getStateFile(playername), "r")
	local savegame = nil

	if file then
		local json = file:read("*a")
		savegame = minetest.parse_json(json or "")
	end

	return savegame or {}
end

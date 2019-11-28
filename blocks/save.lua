
--[[
local basedir = minetest.get_worldpath().."/epic"

minetest.mkdir(basedir)

local getStateFile = function(playername)
	local saneplayername = string.gsub(playername, "[.|/]", "")
	return basedir .. "/" .. saneplayername .. ".json"
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

	end

	return state
end

--]]

minetest.register_node("epic:save", {
	description = "Epic save block",
	tiles = {
		"epic_node_bg.png",
		"epic_node_bg.png",
		"epic_node_bg.png",
		"epic_node_bg.png",
		"epic_node_bg.png",
		"epic_node_bg.png^epic_save.png",
	},
	paramtype2 = "facedir",
	groups = {cracky=3,oddly_breakable_by_hand=3,epic=1},
	on_rotate = screwdriver.rotate_simple,

  epic = {
    on_enter = function(_, _, player, ctx)
			local playername = player:get_player_name()
			minetest.chat_send_player(playername, "[epic] Game state saved!")
			-- TODO
			ctx.next()
    end
  }
})

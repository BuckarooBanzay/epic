
-- playername -> { playername -> id }
local hud = {}

local function disable_hud(player)
	hud[player:get_player_name()] = nil
end

local function enable_hud(player)
	hud[player:get_player_name()] = {}
end

local function update_hud(player)
	local hud_data = hud[player:get_player_name()]
	for _, other_player in minetest.get_connected_players() do
		local name = other_player:get_player_name()
		local state = epic.get_state(name)

		if hud_data[name] and state then
			-- update existing entry
			player:hud_change(hud_data[name], "world_pos", state.ip)

		elseif hud_data[name] and not state then
			-- remove entry
			player:hud_remove(hud_data[name])

		elseif not hud_data[name] and state then
			-- add existing entry
			hud_data[name] = player:hud_add({
				hud_elem_type = "waypoint",
				name = "EPIC:" .. name,
				text = "m",
				number = 0xFF0000,
				world_pos = state.ip
			})

		end
	end
end


-- updating

-- playername -> true
local trace_enabled = {}

local function update_huds()
	for _, player in minetest.get_connected_players() do
		if trace_enabled[player:get_player_name()] then
			update_hud(player)
		end
	end
	minetest.after(1.0, update_huds)
end

minetest.after(1.0, update_huds)

minetest.register_on_leaveplayer(function(player)
	trace_enabled[player:get_player_name()] = nil
end)

-- chat command

minetest.register_chatcommand("epic_trace", {
	description = "Enables or disables epic tracing",
  privs = { epic_debug = true },
	func = function(name, params)
		if params == "on" then
			if not trace_enabled[name] then
				trace_enabled[name] = true
				enable_hud(minetest.get_player_by_name(name))
			end
		elseif params == "off" then
			if trace_enabled[name] then
				trace_enabled[name] = nil
				disable_hud(minetest.get_player_by_name(name))
			end
		else
			return true, "Usage: /epic_trace on|off"
    end
	end
})

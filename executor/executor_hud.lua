
local hud = {} -- playername -> data

local HUD_POSITION = {x = epic.hud.posx, y = epic.hud.posy}
local HUD_ALIGNMENT = {x = 1, y = 0}

local get_color = function(r,g,b)
	return b + (g * 256) + (r * 256 * 256)
end

local function setup(playername, name)
	if hud[playername] then
		return
	end

  local player = minetest.get_player_by_name(playername)
  local data = {}

  data.name = player:hud_add({
    hud_elem_type = "text",
    position = HUD_POSITION,
    offset = {x = 0,   y = 0},
    text = name or "",
    alignment = HUD_ALIGNMENT,
    scale = {x = 100, y = 100},
    number = 0x00FF00
  })

  data.time = player:hud_add({
    hud_elem_type = "text",
    position = HUD_POSITION,
    offset = {x = 0,   y = 20},
    text = "",
    alignment = HUD_ALIGNMENT,
    scale = {x = 100, y = 100},
    number = 0x00FF00
  })

  hud[playername] = data
end

local function exit_cleanup(playername)
	local data = hud[playername]
	local player = minetest.get_player_by_name(playername)

	if not data or not player then
		return
	end

	if data.name then
		player:hud_remove(data.name)
	end

	if data.time then
		player:hud_remove(data.time)
	end

	hud[playername] = nil
end

epic.register_hook({
  on_execute_epic = function(player, _, state)
    setup(player:get_player_name(), state.name)
  end,

  on_epic_exit = exit_cleanup,
	on_epic_abort = exit_cleanup
})

local update
update = function()
  for playername, state in pairs(epic.state) do
    local data = hud[playername]
    local player = minetest.get_player_by_name(playername)

    if player and data and data.time then
      local color = get_color(0,255,0)
      local time_str = ""

      if state.time and state.time > 0 then
        time_str = epic.format_time(state.time)

        if state.time < 300 then
          color = get_color(255,255,0)
        elseif state.time < 60 then
          color = get_color(255,0,0)
        end
      end

      player:hud_change(data.time, "text", time_str)
      player:hud_change(data.time, "number", color)
    end

  end
  minetest.after(1.0, update)
end

minetest.after(1.0, update)

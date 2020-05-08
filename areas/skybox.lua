
-- area based skybox

--[[
local active = {}

local function check()
  for _, player in ipairs(minetest.get_connected_players()) do
    local ppos = player:get_pos()
    local playername = player:get_player_name()
    local skybox_found = false

    local list = epic.data_area.get_all_by_pos(ppos)
    for _, entry in pairs(list) do
      if entry.skybox then
        skybox_found = true
        if active[playername] and active[playername] ~= entry.skybox.name then
          -- replace existing skybox
        elseif not active[playername] then
          -- new skybox
        end
      end
    end

    if not skybox_found and active[playername] then
      -- remove skybox
    end
  end

  minetest.after(1, check)
end


minetest.after(1, check)
--]]

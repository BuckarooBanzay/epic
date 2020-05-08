
-- area based skybox

-- playername -> skybox-name
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
          for _, skyboxdef in ipairs(epic.skyboxes) do
            if skyboxdef.name == entry.skybox.name then
              epic.set_skybox(player, skyboxdef)
              active[playername] = entry.skybox.name
            end
          end

        elseif not active[playername] then
          -- new skybox
          for _, skyboxdef in ipairs(epic.skyboxes) do
            if skyboxdef.name == entry.skybox.name then
              epic.set_skybox(player, skyboxdef)
              active[playername] = entry.skybox.name
            end
          end

        end
      end
    end

    if not skybox_found and active[playername] then
      -- remove skybox
      epic.set_skybox(player, {})
      active[playername] = nil
    end
  end

  minetest.after(1, check)
end


minetest.after(1, check)

-- chat

minetest.register_chatcommand("area_skybox_set", {
    params = "<ID> <name>",
    description = "Set the skybox for the area",
    func = function(playername, param)
      local _, _, id_str, skyboxname = string.find(param, "^([^%s]+)%s+([^%s]+)%s*$")
      if id_str == nil then
        return true, "Invalid syntax!"
      end

      local id = tonumber(id_str)
      if not id then
        return true, "area-id is not numeric: " .. id_str
      end

      if not areas:isAreaOwner(id, playername) and
        not minetest.check_player_privs(playername, { protection_bypas=true }) then
        return true, "you are not the owner of area: " .. id
      end

      local data = epic.data_area.get(id) or {}
      data.skybox = data.skybox or {}
      data.skybox.name = skyboxname
      epic.data_area.set(id, data)
			return true, "Area " .. id .. " skybox: " .. skyboxname
    end,
})

minetest.register_chatcommand("area_skybox_clear", {
    params = "<ID> <name>",
    description = "Removes the skybox for the area",
    func = function(playername, param)
      if param == nil then
        return true, "Invalid syntax!"
      end

      local id = tonumber(param)
      if not id then
        return true, "area-id is not numeric: " .. param
      end

      if not areas:isAreaOwner(id, playername) and
        not minetest.check_player_privs(playername, { protection_bypas=true }) then
        return true, "you are not the owner of area: " .. id
      end

      local data = epic.data_area.get(id) or {}
      data.skybox = nil
      epic.data_area.set(id, data)
			return true, "Area " .. id .. " skybox removed"
    end,
})

minetest.register_chatcommand("area_skybox_get", {
    params = "<ID>",
    description = "Returns the skybox of an area",
    func = function(_, param)
      if param == nil then
        return true, "Invalid syntax!"
      end

      local id = tonumber(param)
      if not id then
        return true, "area-id is not numeric: " .. param
      end

      local data = epic.data_area.get(id)
      if data and data.skybox and data.skybox.name then
		     return true, "Area " .. id .. " skybox: " ..data.skybox.name
       else
         return true, "Not set"
       end
    end
})

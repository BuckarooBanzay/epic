
-- area-based data service
-- stores data related to area-id's
-- use-case: area-based weather or effects

-- local data
-- id -> {}
local area_data = {}

-- File writing / reading utilities
local wpath = minetest.get_worldpath()
local filename = wpath.."/epic_areas.dat"

-- namespace
epic.data_area = {}

-- load data from disk
function epic.data_area.load()
	local f = io.open(filename, "r")
	if f == nil then return {} end
	local t = f:read("*all")
	f:close()
  if t ~= "" and t ~= nil then
    -- existing data found
    area_data = minetest.deserialize(t)
  else
    -- no saved data yet
    area_data = {}
  end
end

-- save data to disk
function epic.data_area.save()
	local f = io.open(filename, "w")
	f:write(minetest.serialize(area_data))
	f:close()
end

epic.data_area.load()

-- setter / getter / lookup

function epic.data_area.set(id, value)
  area_data[id] = value
  epic.data_area.save()
end

-- returns "xy" (the data) or nil
function epic.data_area.get(id)
  return area_data[id]
end

-- returns { {id=1,value="xy"}, {...} }
function epic.data_area.get_all_by_pos(pos)
  local result = {}
  local area_list = areas:getAreasAtPos(pos)
  for id in pairs(area_list) do
    if area_data[id] then
      table.insert(result, {
        id = id,
        value = area_data[id]
      })
    end
  end

  return result
end

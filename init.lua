
epic = {}

local MP = minetest.get_modpath("epic")

dofile(MP.."/common.lua")
dofile(MP.."/state.lua")
dofile(MP.."/executor.lua")

dofile(MP.."/blocks/epic.lua")
dofile(MP.."/blocks/nop.lua")
dofile(MP.."/blocks/function.lua")
dofile(MP.."/blocks/message.lua")
dofile(MP.."/blocks/waypoint.lua")
dofile(MP.."/blocks/teleport.lua")
dofile(MP.."/blocks/command.lua")
dofile(MP.."/blocks/delay.lua")
dofile(MP.."/blocks/branch.lua")

if minetest.get_modpath("mobs") then
	dofile(MP.."/blocks/spawn_mob.lua")
end

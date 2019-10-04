
epic = {}

local MP = minetest.get_modpath("epic")

-- common stuff
dofile(MP.."/common.lua")
dofile(MP.."/state.lua")
dofile(MP.."/executor.lua")
dofile(MP.."/executor_hooks.lua")

-- forms
epic.form = {}
dofile(MP.."/forms/epic_configure.lua")
dofile(MP.."/forms/epic_view.lua")

-- blocks
dofile(MP.."/blocks/epic.lua")
dofile(MP.."/blocks/nop.lua")
dofile(MP.."/blocks/function.lua")
dofile(MP.."/blocks/message.lua")
dofile(MP.."/blocks/waypoint.lua")
dofile(MP.."/blocks/teleport.lua")
dofile(MP.."/blocks/command.lua")
dofile(MP.."/blocks/delay.lua")
dofile(MP.."/blocks/call.lua")
dofile(MP.."/blocks/branch.lua")
dofile(MP.."/blocks/set_gravity.lua")
dofile(MP.."/blocks/add_item.lua")
dofile(MP.."/blocks/remove_item.lua")
dofile(MP.."/blocks/lock.lua")
dofile(MP.."/blocks/unlock.lua")
dofile(MP.."/blocks/settimeout.lua")
dofile(MP.."/blocks/save.lua")

if minetest.get_modpath("mobs") then
	dofile(MP.."/blocks/spawn_mob.lua")
end

if minetest.get_modpath("mesecons") then
	dofile(MP.."/blocks/mesecon_emit.lua")
end

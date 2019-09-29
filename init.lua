
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
dofile(MP.."/blocks/delay.lua")

-- debug stuff XXX
minetest.register_on_punchnode(function(pos, node, puncher, pointed_thing)
	minetest.log("action", "[epic] player: " .. puncher:get_player_name() .. " punches " .. node.name .. " at " .. minetest.pos_to_string(pos))
	local olddir = minetest.pos_to_string(minetest.facedir_to_dir(node.param2))
	minetest.log("action", "[epic] dir: " .. olddir)
end)

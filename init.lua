
epic = {}

local MP = minetest.get_modpath("epic")

dofile(MP.."/blocks/epic.lua")
dofile(MP.."/common.lua")
dofile(MP.."/register.lua")
dofile(MP.."/executor.lua")

minetest.register_node("epic:epic", {
	description = "Epic",
	groups = {cracky=3,oddly_breakable_by_hand=3},
  tiles = {
    "epic_node_bg.png^epic_epic.png"
	}
})

minetest.register_on_punchnode(function(pos, node, puncher, pointed_thing)
	minetest.log("action", "[epic] player: " .. puncher:get_player_name() .. " punches " .. node.name .. " at " .. minetest.pos_to_string(pos))
	local olddir = minetest.pos_to_string(minetest.facedir_to_dir(node.param2))
	minetest.log("action", "[epic] dir: " .. olddir)
end)

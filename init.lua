
local MP = minetest.get_modpath("epic")

dofile(MP.."/blocks/epic.lua")
dofile(MP.."/common.lua")

minetest.register_node("epic:function", {
	description = "Epic function block",
	tiles = {
		"epic_node_bg.png",
		"epic_node_bg.png",
    "epic_node_bg.png",
    "epic_node_bg.png",
    "epic_node_bg.png",
    "epic_node_bg.png^epic_function.png^epic_blue_right.png",
	},
  paramtype2 = "facedir",
	groups = {cracky=3,oddly_breakable_by_hand=3},
})

minetest.register_node("epic:epic", {
	description = "Epic",
	groups = {cracky=3,oddly_breakable_by_hand=3},
  tiles = {
    "epic_node_bg.png^epic_epic.png"
	}
})

minetest.register_node("epic:mob", {
	description = "Epic mob block",
	groups = {cracky=3,oddly_breakable_by_hand=3},
	tiles = {
		"epic_node_bg.png",
		"epic_node_bg.png",
    "epic_node_bg.png",
    "epic_node_bg.png",
    "epic_node_bg.png",
    "epic_node_bg.png^epic_mob.png^epic_blue_right.png",
	},
  paramtype2 = "facedir"
})

minetest.register_node("epic:call", {
	description = "Epic call block",
	groups = {cracky=3,oddly_breakable_by_hand=3},
	tiles = {
		"epic_node_bg.png",
		"epic_node_bg.png",
    "epic_node_bg.png",
    "epic_node_bg.png",
    "epic_node_bg.png",
    "epic_node_bg.png^epic_call.png^epic_blue_right.png",
	},
  paramtype2 = "facedir"
})

minetest.register_node("epic:nop", {
	description = "Epic nop block",
	groups = {cracky=3,oddly_breakable_by_hand=3},
	tiles = {
		"epic_node_bg.png",
		"epic_node_bg.png",
    "epic_node_bg.png",
    "epic_node_bg.png",
    "epic_node_bg.png",
    "epic_node_bg.png^epic_nop.png^epic_blue_right.png",
	},
  paramtype2 = "facedir"
})

minetest.register_node("epic:waypoint", {
	description = "Epic waypoint block",
	groups = {cracky=3,oddly_breakable_by_hand=3},
	tiles = {
		"epic_node_bg.png",
		"epic_node_bg.png",
    "epic_node_bg.png",
    "epic_node_bg.png",
    "epic_node_bg.png",
    "epic_node_bg.png^epic_waypoint.png^epic_blue_right.png",
	},
  paramtype2 = "facedir"
})


minetest.register_node("epic:message", {
	description = "Epic message block",
	groups = {cracky=3,oddly_breakable_by_hand=3},
	tiles = {
		"epic_node_bg.png",
		"epic_node_bg.png",
    "epic_node_bg.png",
    "epic_node_bg.png",
    "epic_node_bg.png",
    "epic_node_bg.png^epic_msg.png^epic_blue_right.png",
	},
  paramtype2 = "facedir",
	epic = {
		on_enter = function(ctx)
			ctx.next()
		end
	}
})


minetest.register_node("epic:end", {
	description = "Epic end block",
	groups = {cracky=3,oddly_breakable_by_hand=3},
	tiles = {
		"epic_node_bg.png",
		"epic_node_bg.png",
    "epic_node_bg.png",
    "epic_node_bg.png",
    "epic_node_bg.png",
    "epic_node_bg.png^epic_end.png^epic_red_right.png",
	},
  paramtype2 = "facedir"
})


minetest.register_node("epic:ret", {
	description = "Epic return block",
	groups = {cracky=3,oddly_breakable_by_hand=3},
	tiles = {
		"epic_node_bg.png",
		"epic_node_bg.png",
    "epic_node_bg.png",
    "epic_node_bg.png",
    "epic_node_bg.png",
    "epic_node_bg.png^epic_ret.png^epic_red_right.png",
	},
  paramtype2 = "facedir"
})


minetest.register_node("epic:if", {
	description = "Epic if block",
	groups = {cracky=3,oddly_breakable_by_hand=3},
	tiles = {
		"epic_node_bg.png",
		"epic_node_bg.png",
    "epic_node_bg.png",
    "epic_node_bg.png",
    "epic_node_bg.png",
    "epic_node_bg.png^epic_if.png^epic_blue_right.png^(epic_red_right.png^[transformFXR90)",
	},
  paramtype2 = "facedir"
})


minetest.register_on_punchnode(function(pos, node, puncher, pointed_thing)
	minetest.log("action", "[epic] player: " .. puncher:get_player_name() .. " punches " .. node.name .. " at " .. minetest.pos_to_string(pos))
	local olddir = minetest.pos_to_string(minetest.facedir_to_dir(node.param2))
	minetest.log("action", "[epic] dir: " .. olddir)
end)


minetest.register_node("epic:waypoint", {
	description = "Epic waypoint block",
	tiles = {
		"epic_node_bg.png",
		"epic_node_bg.png",
		"epic_node_bg.png",
		"epic_node_bg.png",
		"epic_node_bg.png",
		"epic_node_bg.png^epic_waypoint.png",
	},
	paramtype2 = "facedir",
	groups = {cracky=3,oddly_breakable_by_hand=3},
	on_rotate = screwdriver.rotate_simple,

	epic = {
    on_enter = function(pos, meta, player, ctx)
			local target_pos = { x=0, y=0, z=0 }

			ctx.step_data.waypoint_hud_id = player:hud_add({
				hud_elem_type = "waypoint",
				name = "Waypoint XY",
				text = "m",
				number = 0xFF0000,
				world_pos = target_pos
			})
    end,
    on_check = function(pos, meta, player, ctx)
			local pos = player:get_pos()
			local target_pos = { x=0, y=0, z=0 }
			if vector.distance(pos, target_pos) < 3 then
				ctx.next()
			end
    end,
    on_exit = function(pos, meta, player, ctx)
			player:hud_remove(ctx.step_data.waypoint_hud_id)
    end
  }
})

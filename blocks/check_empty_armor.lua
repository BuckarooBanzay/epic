
minetest.register_node("epic:check_empty_armor", {
	description = "Epic check empty armor block: checks if the armor-inventory is empty",
	tiles = {
		"epic_node_bg.png",
		"epic_node_bg.png",
		"epic_node_bg.png",
		"epic_node_bg.png",
		"epic_node_bg.png",
		"epic_node_bg.png^epic_briefcase.png",
	},
	paramtype2 = "facedir",
	groups = {cracky=3,oddly_breakable_by_hand=3,epic=1},
	on_rotate = screwdriver.rotate_simple,

	epic = {
    on_check = function(_, _, player, ctx)
			local player_inv = player:get_inventory()

			if player_inv:is_empty("armor") then
				ctx.next()
			end

    end
  }
})

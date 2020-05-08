

minetest.register_node("epic:unstash_inv", {
	description = "Epic unstash inventory block: moves the player inventory to the player again",
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
    on_enter = function(_, _, player, ctx)
      ctx.data.stashed_items = ctx.data.stashed_items or {}
			local player_inv = player:get_inventory()

			for _, itemstr in ipairs(ctx.data.stashed_items) do
				local stack = ItemStack(itemstr)
				if player_inv:room_for_item("main", stack) then
					player_inv:add_item("main", stack)
				end
			end

			ctx.next()
    end
  }
})

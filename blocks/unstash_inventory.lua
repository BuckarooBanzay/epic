

minetest.register_node("epic:unstash_inv", {
	description = "Epic unstash inventory block: moves the player inventory to the player again",
	tiles = epic.create_texture("action", "epic_briefcase.png"),
	paramtype2 = "facedir",
	groups = {cracky=3,oddly_breakable_by_hand=3,epic=1},
	on_rotate = epic.on_rotate,

	epic = {
    on_enter = function(_, _, player, ctx)
      ctx.data.stashed_items = ctx.data.stashed_items or {}
			local player_inv = player:get_inventory()
			local unstashed_string = ""
			local items_unstashed = false

			for i, itemstr in ipairs(ctx.data.stashed_items) do
				local stack = ItemStack(itemstr)
				if player_inv:room_for_item("main", stack) then
					unstashed_string = unstashed_string..itemstr..", "
					items_unstashed = true
					player_inv:add_item("main", stack)
					ctx.data.stashed_items[i] = nil
				end
			end
			if items_unstashed then
				minetest.log("action", ("%s's inventory has had items restored: { %s }"):format(player:get_player_name(), unstashed_string:sub(1, -3)))
			end
			ctx.next()
    end
  }
})

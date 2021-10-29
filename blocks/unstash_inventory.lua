

minetest.register_node("epic:unstash_inv", {
	description = "Epic unstash inventory block: moves the player inventory to the player again",
	tiles = epic.create_texture("action", "epic_briefcase.png"),
	paramtype2 = "facedir",
	groups = {cracky=3,oddly_breakable_by_hand=3,epic=1},
	on_rotate = epic.on_rotate,

	epic = {
		on_enter = function(pos, _, player, ctx)
			-- restore stash from player meta
			local player_meta = player:get_meta()
			local serialized_stash = player_meta:get_string("epic_stash")
			local stashed_items = {}
			if serialized_stash and serialized_stash ~= "" then
				stashed_items = minetest.deserialize(serialized_stash)
				player_meta:set_string("epic_stash", "")
			end
			local player_inv = player:get_inventory()
			local unstashed_string = ""
			local items_unstashed = false

			for _, itemstr in ipairs(stashed_items) do
				local stack = ItemStack(itemstr)
				if player_inv:room_for_item("main", stack) then
					unstashed_string = unstashed_string..itemstr..", "
					items_unstashed = true
					player_inv:add_item("main", stack)
				end
			end
			if items_unstashed then
				minetest.log("action", ("[epic::unstash_inventory@%s] %s's inventory has had items restored: { %s }")
					:format(minetest.pos_to_string(pos), player:get_player_name(), unstashed_string:sub(1, -3)))
			end
			ctx.next()
		end
	}
})


minetest.register_node("epic:check_empty_armor", {
	description = "Epic check empty armor block: checks if the armor-inventory is empty",
	tiles = epic.create_texture("condition", "epic_briefcase.png"),
	paramtype2 = "facedir",
	groups = {cracky=3,oddly_breakable_by_hand=3,epic=1},
	on_rotate = epic.on_rotate,

	epic = {
		on_check = function(_, _, player, ctx)
			local player_name = player:get_player_name()
			local player_armor_inv = minetest.get_inventory({type="detached", name=player_name.."_armor"})

			if player_armor_inv:is_empty("armor") then

				ctx.next()
			end
		end
	}
})

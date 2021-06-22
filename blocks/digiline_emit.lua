
minetest.register_node("epic:digiline_emit", {
	description = "Epic digiline emit block: emits the playername as digilines message",
	tiles = epic.create_texture("action", "digiline_std_inv.png"),
	paramtype2 = "facedir",
	groups = {cracky=3,oddly_breakable_by_hand=3,epic=1},
	on_rotate = epic.on_rotate,

	digiline = {
		receptor = {},
	},

	epic = {
		on_enter = function(pos, _, player, ctx)
			digilines.receptor_send(pos, digilines.rules.default, "epic", player:get_player_name())
			ctx.next()
		end
	}
})

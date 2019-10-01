
minetest.register_node("epic:epic", {
	description = "Epic",
	groups = {cracky=3,oddly_breakable_by_hand=3},
  tiles = {
    "epic_node_bg.png^epic_epic.png"
	},
	on_rightclick = function(pos, node, player)
		if minetest.is_protected(pos, player:get_player_name()) then
			-- view
			epic.form.epic_view(pos, node, player)

		else
			-- configure
			epic.form.epic_configure(pos, node, player)
			
		end
	end
})

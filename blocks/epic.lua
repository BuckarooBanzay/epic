
minetest.register_node("epic:epic", {
	description = "Epic",
	groups = {cracky=3,oddly_breakable_by_hand=3},
  tiles = {
    "epic_node_bg.png^epic_epic.png"
	},

	after_place_node = function(pos, placer)
		local meta = minetest.get_meta(pos)
		meta:set_string("owner", placer:get_player_name())
		meta:set_string("name", "")
		meta:set_int("time", "600")
	end,

	on_rightclick = function(pos, _, player)
		local playername = player:get_player_name()
		if minetest.is_protected(pos, playername) then
			-- view
			epic.form.epic_view(pos, playername)
		else
			-- configure
			epic.form.epic_configure(pos, playername)
		end
	end
})


minetest.register_node("epic:epic", {
	description = "Epic: Configurable starter block for quests",
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
	end,

	-- allow mesecons triggering
	mesecons = {
		effector = {
	    action_on = function (pos)
				for _, player in ipairs(minetest.get_connected_players()) do
					local ppos = player:get_pos()

					if vector.distance(pos, ppos) < 16 then
						-- player is within 16 nodes range, start epic
						epic.start(player:get_player_name(), pos)
					end
				end
			end
	  }
	},

})



minetest.register_node("epic:load", {
	description = "Epic load block: loads a previously saved game",
	tiles = {
		"epic_node_bg.png",
		"epic_node_bg.png",
		"epic_node_bg.png",
		"epic_node_bg.png",
		"epic_node_bg.png",
		"epic_node_bg.png^epic_load.png",
	},
	paramtype2 = "facedir",
	groups = {cracky=3,oddly_breakable_by_hand=3,epic=1},
	on_rotate = screwdriver.rotate_simple,

	on_construct = function(pos)
    local meta = minetest.get_meta(pos)
		meta:set_string("infotext", "Load game")
		meta:set_string("topic", "My maze")
  end,

	on_rightclick = function(pos, _, player)
		local playername = player:get_player_name()
		if minetest.is_protected(pos, playername) then
			-- view
			local meta = minetest.get_meta(pos)
			epic.form.epic_savegame_load(meta:get_string("topic"), playername)

		else
			-- configure
			epic.form.epic_savegame_load_configure(pos, playername)
		end
	end


})

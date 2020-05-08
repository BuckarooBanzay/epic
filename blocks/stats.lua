local update_formspec = function(meta)
	local counter = meta:get_int("counter")
	local lastplayer = meta:get_string("lastplayer")
	meta:set_string("infotext", "Visits: " .. counter ..
		" Last player: ''" .. lastplayer .. "'")

	meta:set_string("formspec", "size[8,2;]" ..
		"label[0,0.5;Visits: " .. counter .. "]" ..
		"button_exit[0.1,1.5;8,1;reset;Reset]" ..
		"")
end

minetest.register_node("epic:stats", {
	description = "Epic stats block: keeps track of the visited players",
	tiles = {
		"epic_node_bg.png",
		"epic_node_bg.png",
		"epic_node_bg.png",
		"epic_node_bg.png",
		"epic_node_bg.png",
		"epic_node_bg.png^epic_stats.png",
	},
	paramtype2 = "facedir",
	groups = {cracky=3,oddly_breakable_by_hand=3,epic=1},
	on_rotate = screwdriver.rotate_simple,

	on_construct = function(pos)
    local meta = minetest.get_meta(pos)
		meta:set_int("counter", 0)
		meta:set_string("lastplayer", "")
    update_formspec(meta)
  end,

	on_receive_fields = function(pos, _, fields, sender)
		if not sender or minetest.is_protected(pos, sender:get_player_name()) then
			-- not allowed
			return
		end

		local meta = minetest.get_meta(pos);

		if fields.reset then
			meta:set_int("counter", 0)
			update_formspec(meta)
		end

	end,

  epic = {
    on_enter = function(_, meta, player, ctx)
			meta:set_int("counter", meta:get_int("counter") + 1)
			meta:set_string("lastplayer", player:get_player_name())
			update_formspec(meta)
			ctx.next()
    end
  }
})

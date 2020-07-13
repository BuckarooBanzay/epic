local update_formspec = function(meta)
	local chance = meta:get_int("chance")
	meta:set_string("infotext", "random block, chance: 1/" .. chance)

	meta:set_string("formspec", "size[8,2;]" ..
		-- col 1
		"field[0.2,0.5;8,1;chance;Chance (1/x);" .. chance .. "]" ..

		-- col 2
		"button_exit[0.1,1.5;8,1;save;Save]" ..
		"")
end

minetest.register_node("epic:random", {
	description = "Epic random block: succeeds randomly (for randomized branches in quests)",
	tiles = {
		"epic_node_bg.png",
		"epic_node_bg.png",
		"epic_node_bg.png",
		"epic_node_bg.png",
		"epic_node_bg.png",
		"epic_node_bg.png^epic_question_mark.png",
	},
	paramtype2 = "facedir",
	groups = {cracky=3,oddly_breakable_by_hand=3,epic=1},
	on_rotate = screwdriver.rotate_simple,

	on_construct = function(pos)
    local meta = minetest.get_meta(pos)
		meta:set_int("chance", 10)
    update_formspec(meta, pos)
  end,

	on_receive_fields = function(pos, _, fields, sender)
    local meta = minetest.get_meta(pos);

		if not sender or minetest.is_protected(pos, sender:get_player_name()) then
			-- not allowed
			return
		end

    if fields.save then
      local chance = tonumber(fields.chance) or 10
			if chance <= 0 then
				chance = 10
			end

			meta:set_int("chance", chance)
			update_formspec(meta, pos)
    end

  end,

  epic = {
    on_check = function(_, meta, _, ctx)
			local chance = meta:get_int("chance")
			if chance <= 0 then
				chance = 10
			end

			if math.random(chance) == 1 then
				ctx.next()
			end
		end
  }
})

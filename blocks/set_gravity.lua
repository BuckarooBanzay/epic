local use_player_monoids = minetest.global_exists("player_monoids")

local update_formspec = function(meta, pos)
	local gravity = meta:get_string("gravity")
	meta:set_string("infotext", "Set-gravity block: '" .. gravity .. "'")

	meta:set_string("formspec", "size[8,2;]" ..
		-- col 1
		"field[0.2,0.5;8,1;gravity;Gravity;" .. gravity .. "]" ..

		-- col 2
		"button_exit[0.1,1.5;8,1;save;Save]" ..
		"")
end


minetest.register_node("epic:command", {
	description = "Epic command block",
	tiles = {
		"epic_node_bg.png",
		"epic_node_bg.png",
		"epic_node_bg.png",
		"epic_node_bg.png",
		"epic_node_bg.png",
		"epic_node_bg.png",
	},
	paramtype2 = "facedir",
	groups = {cracky=3,oddly_breakable_by_hand=3,epic=1},
	on_rotate = screwdriver.rotate_simple,

	after_place_node = function(pos, placer)
		local meta = minetest.get_meta(pos)
		meta:set_string("gravity", "9.81")
		update_formspec(meta, pos)
	end,

  on_receive_fields = function(pos, formname, fields, sender)
    local meta = minetest.get_meta(pos);

		if not sender or minetest.is_protected(pos, sender:get_player_name()) then
			-- not allowed
			return
		end

    if fields.save then
	meta:set_string("gravity", fields.gravity or "9.81")
	update_formspec(meta, pos)
    end

  end,

  epic = {
    on_enter = function(pos, meta, player, ctx)
	local gravity = tonumber(meta:get_string("gravity")) or 9.81
	if use_player_monoids then
		player_monoids.gravity:add_change(player, gravity, "epic:set_gravity")
	else
		player:set_physics_override({ gravity = gravity })
	end
	ctx.next()
    end
  }
})

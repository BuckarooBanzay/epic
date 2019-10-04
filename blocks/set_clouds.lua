
local update_formspec = function(meta)
	meta:set_string("infotext", "Set clouds block")

	meta:set_string("formspec", "size[8,2;]" ..
		"field[0.2,0.5;8,1;thickness;Thickness;${thickness}]" ..
		"button_exit[0.1,1.5;8,1;save;Save]" ..
		"")
end

minetest.register_node("epic:setclouds", {
	description = "Epic set clouds block",
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

	on_construct = function(pos)
    local meta = minetest.get_meta(pos)
		meta:set_int("thickness", 16)
    update_formspec(meta, pos)
  end,

  on_receive_fields = function(pos, _, fields, sender)
    local meta = minetest.get_meta(pos);

		if not sender or minetest.is_protected(pos, sender:get_player_name()) then
			-- not allowed
			return
		end

    if fields.save then
			meta:set_string("thickness", tonumber(fields.thickness) or 16)
			update_formspec(meta, pos)
    end

  end,

	epic = {
    on_enter = function(_, meta, player, ctx)
			player:set_clouds({
				thickness = meta:get_int("thickness"),
				color = {
					r=243,
					g=214,
					b=255,
					a=229
				},
				ambient = {
					r=0,
					g=0,
					b=0,
					a=255
				},
				density=0.4,
				height=200,
				speed={
					y=-2,
					x=-1
				}
			})
			ctx.next()
    end
  }
})

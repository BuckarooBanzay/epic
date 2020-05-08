
local update_formspec = function(meta)
	meta:set_string("infotext", "Set clouds block")

	meta:set_string("formspec", "size[8,6;]" ..
		"field[0.2,0.5;8,1;thickness;Thickness;${thickness}]" ..
		"field[0.2,1.5;8,1;density;Density;${density}]" ..
		"field[0.2,2.5;8,1;height;Height;${height}]" ..

		"field[0.2,3.5;2,1;red;Red;${red}]" ..
		"field[2.2,3.5;2,1;green;Green;${green}]" ..
		"field[4.2,3.5;2,1;blue;Blue;${blue}]" ..
		"field[6.2,3.5;2,1;alpha;Alpha;${alpha}]" ..

		"field[0.2,4.5;4,1;speedx;X-Speed;${speedx}]" ..
		"field[4.2,4.5;4,1;speedx;Y-Speed;${speedy}]" ..

		"button_exit[0.1,5.5;8,1;save;Save]" ..
		"")
end

minetest.register_node("epic:setclouds", {
	description = "Epic set clouds block: sets the clouds with the defined properties",
	tiles = {
		"epic_node_bg.png",
		"epic_node_bg.png",
		"epic_node_bg.png",
		"epic_node_bg.png",
		"epic_node_bg.png",
		"epic_node_bg.png^epic_sky.png",
	},
	paramtype2 = "facedir",
	groups = {cracky=3,oddly_breakable_by_hand=3,epic=1},
	on_rotate = screwdriver.rotate_simple,

	on_construct = function(pos)
    local meta = minetest.get_meta(pos)
		meta:set_int("thickness", 16)
		meta:set_int("height", 120)
		meta:set_string("density", "0.4")
		meta:set_int("red", 243)
		meta:set_int("green", 214)
		meta:set_int("blue", 255)
		meta:set_int("alpha", 229)
		meta:set_int("speedx", 1)
		meta:set_int("speedy", 2)
    update_formspec(meta, pos)
  end,

  on_receive_fields = function(pos, _, fields, sender)
    local meta = minetest.get_meta(pos);

		if not sender or minetest.is_protected(pos, sender:get_player_name()) then
			-- not allowed
			return
		end

    if fields.save then
			meta:set_int("thickness", tonumber(fields.thickness) or 16)
			meta:set_int("height", tonumber(fields.height) or 120)
			meta:set_string("density", tonumber(fields.density) or 0.4)
			meta:set_int("red", tonumber(fields.red) or 243)
			meta:set_int("green", tonumber(fields.green) or 214)
			meta:set_int("blue", tonumber(fields.blue) or 255)
			meta:set_int("alpha", tonumber(fields.alpha) or 229)
			meta:set_int("speedx", tonumber(fields.speedx) or 1)
			meta:set_int("speedy", tonumber(fields.speedy) or 2)
			update_formspec(meta, pos)
    end

  end,

	epic = {
    on_enter = function(_, meta, player, ctx)
			player:set_clouds({
				thickness = meta:get_int("thickness"),
				color = {
					r=meta:get_int("red"),
					g=meta:get_int("green"),
					b=meta:get_int("blue"),
					a=meta:get_int("alpha")
				},
				ambient = {
					r=0,
					g=0,
					b=0,
					a=255
				},
				density = tonumber(meta:get_string("density")),
				height= meta:get_int("height"),
				speed={
					y=meta:get_int("speedy"),
					x=meta:get_int("speedx")
				}
			})
			ctx.next()
    end
  }
})

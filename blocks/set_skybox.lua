

local update_formspec = function(meta)
	local skyboxname = meta:get_string("skyboxname")

	meta:set_string("infotext", "Set skybox block: name=" .. skyboxname)

	local selected = 1
	local list = ""
	for i,skyboxdef in ipairs(epic.skyboxes) do
		if skyboxdef.name == skyboxname then
			selected = i
		end

		list = list .. minetest.formspec_escape(skyboxdef.name)
		if i < #epic.skyboxes then
			-- not end of list
			list = list .. ","
		end
	end

	meta:set_string("formspec", "size[8,6;]" ..
		"textlist[0,0.1;8,5;skyboxname;" .. list .. ";" .. selected .. "]" ..

		"button_exit[0.1,5.5;8,1;save;Save]" ..
		"")
end

minetest.register_node("epic:setskybox", {
	description = "Epic set skybox block",
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
		meta:set_string("skyboxname", "")
    update_formspec(meta, pos)
  end,

  on_receive_fields = function(pos, _, fields, sender)
		if not sender or minetest.is_protected(pos, sender:get_player_name()) then
			-- not allowed
			return
		end

		local meta = minetest.get_meta(pos)

		if fields.skyboxname then
			local parts = fields.skyboxname:split(":")
			if parts[1] == "CHG" then
				local selected_box = tonumber(parts[2])
				local skyboxdef = epic.skyboxes[selected_box]
				if skyboxdef and skyboxdef.name then
					meta:set_string("skyboxname", skyboxdef.name)
				end
				update_formspec(meta, pos)
			end
		end
  end,

	epic = {
    on_enter = function(_, meta, player, ctx)
			local skyboxname = meta:get_string("skyboxname")
			for _, skyboxdef in ipairs(epic.skyboxes) do
				if skyboxdef.name == skyboxname then
					epic.set_skybox(player, skyboxdef)
				end
			end
			ctx.next()
    end
  }
})

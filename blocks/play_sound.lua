
local update_formspec = function(meta)
	local soundname = meta:get_string("soundname")

	meta:set_string("infotext", "Play sound block: soundname: '" .. soundname .. "'")

	local total_count = 0
	for _ in pairs(soundblock.sounds) do
		total_count = total_count + 1
	end

	local selected = 1
	local list = ""
	local i = 1
	for _, sounddef in pairs(soundblock.sounds) do
		if sounddef.name == soundname then
			selected = i
		end

		list = list .. sounddef.name
		if i < total_count then
			-- not end of list
			list = list .. ","
		end

		i = i + 1
	end

	meta:set_string("formspec", "size[8,6;]" ..
		"textlist[0,0.1;8,5;soundname;" .. list .. ";" .. selected .. "]" ..

		"button_exit[0.1,5.5;8,1;save;Save]" ..
		"")
end

minetest.register_node("epic:play_sound", {
	description = "Epic play sound block",
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
		meta:set_string("soundname", "")
    update_formspec(meta, pos)
  end,

  on_receive_fields = function(pos, _, fields, sender)
		if not sender or minetest.is_protected(pos, sender:get_player_name()) then
			-- not allowed
			return
		end

		local meta = minetest.get_meta(pos);

		if fields.soundname then
			local parts = fields.soundname:split(":")
			if parts[1] == "CHG" then
				local selected_sound = tonumber(parts[2])
				local sound_key = ""

				local i = 0
				for _, sounddef in pairs(soundblock.sounds) do
					i = i + 1

					if i == selected_sound then
						sound_key = sounddef.key
					end
				end
				meta:set_string("soundname", sound_key)
				update_formspec(meta, pos)
			end
		end

  end,

	epic = {
    on_enter = function(_, meta, player, ctx)
			local soundname = meta:get_string("soundname")

			for _, sounddef in pairs(soundblock.sounds) do
				if sounddef.key == soundname then
					local filename = sounddef.filename

					if sounddef.filenames then
						filename = sounddef.filenames[math.random(1, #sounddef.filenames)]
					end

					minetest.sound_play(filename, {
						to_player = player:get_player_name(),
						gain = 1.0
					})
				end
			end
			ctx.next()
    end
  }
})

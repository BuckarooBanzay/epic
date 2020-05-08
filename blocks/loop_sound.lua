
local update_formspec = function(meta)
	local soundname = meta:get_string("soundname")
	local gain = meta:get_string("gain") or "1.0"

	meta:set_string("infotext", "Loop sound block: soundname: '" .. soundname .. "'")

	local selected = 1
	local list = ""
	local i = 1
	for _, sounddef in pairs(soundblock.sounds) do
		if sounddef.key == soundname then
			selected = i
		end

		list = list .. sounddef.name .. ","

		i = i + 1
	end

	list = list .. "Stop"

	if soundname == "Stop" then
		selected = i
	end

	meta:set_string("formspec", "size[8,7;]" ..
		"textlist[0,0.1;8,5;soundname;" .. list .. ";" .. selected .. "]" ..

		"field[0.3,5.8;8,1;gain;Gain;" .. gain .. "]" ..
		"button_exit[0.1,6.5;8,1;save;Save]" ..
		"")
end

minetest.register_node("epic:loop_sound", {
	description = "Epic loop sound block: loops a sound for the player",
	tiles = {
		"epic_node_bg.png",
		"epic_node_bg.png",
		"epic_node_bg.png",
		"epic_node_bg.png",
		"epic_node_bg.png",
		"epic_node_bg.png^epic_music.png",
	},
	paramtype2 = "facedir",
	groups = {cracky=3,oddly_breakable_by_hand=3,epic=1},
	on_rotate = screwdriver.rotate_simple,

	on_construct = function(pos)
    local meta = minetest.get_meta(pos)
		meta:set_string("soundname", "")
		meta:set_string("gain", "1.0")
    update_formspec(meta, pos)
  end,

  on_receive_fields = function(pos, _, fields, sender)
		if not sender or minetest.is_protected(pos, sender:get_player_name()) then
			-- not allowed
			return
		end

		local meta = minetest.get_meta(pos);

		if fields.gain then
			meta:set_string("gain", tonumber(fields.gain) or 1)
		end

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
			end
		end

		update_formspec(meta, pos)

  end,

	epic = {
    on_enter = function(_, meta, player, ctx)

			if ctx.data.loop_sound_handle then
				minetest.sound_stop(ctx.data.loop_sound_handle)
				ctx.data.loop_sound_handle = nil
			end

			local soundname = meta:get_string("soundname")
			local gain = tonumber( meta:get_string("gain") or "1.0" )

			for _, sounddef in pairs(soundblock.sounds) do
				if sounddef.key == soundname then
					local filename = sounddef.filename

					if sounddef.filenames then
						filename = sounddef.filenames[math.random(1, #sounddef.filenames)]
					end

					ctx.data.loop_sound_handle = minetest.sound_play(filename, {
						to_player = player:get_player_name(),
						gain = gain,
						loop = true
					})
				end
			end
			ctx.next()
    end
  }
})

local function cleanup(_, state)
	if state and state.data and state.data.loop_sound_handle then
		minetest.sound_stop(state.data.loop_sound_handle)
		state.data.loop_sound_handle = nil
	end
end

epic.register_hook({
  on_epic_exit = cleanup,
	on_epic_abort = cleanup
})

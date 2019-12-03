
local FORMNAME = "epic_savegame_load_configure"

epic.form.epic_savegame_load_configure = function(pos, playername)

	local meta = minetest.get_meta(pos)
	local topic = meta:get_string("topic")

	local formspec = "size[8,2;]" ..
		"label[0,0;Epic savegame load block]" ..

		"field[0.2,1.5;6,1;topic;Topic;" .. topic .. "]" ..
		"button_exit[6.2,1.5;2,1;save;Save]"

	minetest.show_formspec(playername,
		FORMNAME .. ";" .. minetest.pos_to_string(pos),
		formspec
	)
end


minetest.register_on_player_receive_fields(function(player, formname, fields)
	local parts = formname:split(";")
	local name = parts[1]
	if name ~= FORMNAME then
		return
	end

	local playername = player:get_player_name()
	local pos = minetest.string_to_pos(parts[2])

	if minetest.is_protected(pos, playername) then
		return
	end

	local meta = minetest.get_meta(pos)

	if fields.save then
		meta:set_string("topic", fields.topic or "")
		meta:set_string("infotext", "Load game: '" .. (fields.topic or "") .. "'")
	end

end)

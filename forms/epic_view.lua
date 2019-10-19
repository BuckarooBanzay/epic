
local FORMNAME = "epic_view"

epic.form.epic_view = function(pos, playername)

	local meta = minetest.get_meta(pos)
	local name = meta:get_string("name")

	local formspec = "size[8,2;]" ..
		"label[0,0;Epic start block]" ..
		"label[0,1;" .. name .. "]" ..
		"button_exit[5.5,1;2,1;start;Start]"

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

	local pos = minetest.string_to_pos(parts[2])
	local meta = minetest.get_meta(pos)
	local main_pos = epic.to_absolute_pos(pos, minetest.string_to_pos(meta:get_string("main_pos")))
	local exit_pos = epic.to_absolute_pos(pos, minetest.string_to_pos(meta:get_string("exit_pos")))
	local epic_name = meta:get_string("name")

	if not main_pos then
		return
	end

	if fields.start then
		epic.execute_epic(player, main_pos, exit_pos, epic_name)
	end

end)


local FORMNAME = "epic_savegame_load"

-- playername -> id
local player_selections = {}

minetest.register_on_leaveplayer(function(player)
	local playername = player:get_player_name()
	player_selections[playername] = nil
end)

epic.form.epic_savegame_load = function(topic, playername)
	local savegame = epic.savegame.load(playername)
	local levels = savegame[topic] or {}
	local list = ""

	for name in pairs(levels) do
		list = list .. minetest.formspec_escape(name) .. ","
	end

	local formspec = "size[8,8;]" ..
		"label[0,0;Epic savegame load]" ..
		"textlist[0,0.5;7.8,6.5;levelname;" .. list .. "]" ..
		"button_exit[0.1,7.2;8,1;load;Load]"

	minetest.show_formspec(playername,
		FORMNAME .. ";" .. topic,
		formspec
	)
end


minetest.register_on_player_receive_fields(function(player, formname, fields)
	local parts = formname:split(";")
	local name = parts[1]
	if name ~= FORMNAME then
		return
	end

	local topic = parts[2]
	local playername = player:get_player_name()

	if fields.load then
		local savegame = epic.savegame.load(playername)
		local levels = savegame[topic] or {}

		local selected_level = player_selections[playername]
		if not selected_level then
			return true
		end

		local selected_pos = nil

		local i = 1
		for _, pos in pairs(levels) do
			if selected_level == i then
				selected_pos = pos
			end
			i = i + 1
		end

		if not selected_pos then
			return true
		end

		local node = epic.get_node(selected_pos)
		if node.name ~= "epic:save" then
			return true
		end

		local meta = minetest.get_meta(selected_pos)
		local target_pos = minetest.string_to_pos(meta:get_string("pos"))

		if not target_pos then
			return true
		end

		local destination_pos = epic.to_absolute_pos(selected_pos, target_pos)
		player:set_pos(destination_pos)
	end

	if fields.levelname then
		local lvl_parts = fields.levelname:split(":")
		if lvl_parts[1] == "CHG" then
			local selected_level = tonumber(lvl_parts[2])

			if not selected_level then
				return true
			end

			player_selections[playername] = selected_level
		end
	end

end)

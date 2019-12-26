

local FORMNAME = "epic_configure"

-- playername => pos
local punch_handler_main = {}
local punch_handler_exit = {}
local punch_handler_abort = {}

epic.form.epic_configure = function(pos, playername)

	local meta = minetest.get_meta(pos)
	local name = meta:get_string("name")
	local main_pos = meta:get_string("main_pos") or "<none>"
	local exit_pos = meta:get_string("exit_pos") or "<none>"
	local abort_pos = meta:get_string("abort_pos") or "<none>"

	local formspec = "size[8,8;]" ..
		"label[0,0;Epic start block]" ..

		"field[0.2,1.5;8,1;name;Name;" .. name .. "]" ..

		"label[0,2.5;Main function]" ..
		"label[2,2.5;" .. main_pos .. "]" ..
		"button_exit[4,2.5;2,1;setmain;Set]" ..
		"button_exit[6,2.5;2,1;clearmain;Clear]" ..

		"label[0,3.5;Exit function]" ..
		"label[0,4;Called unconditionally on exit]" ..
		"label[2,3.5;" .. exit_pos .. "]" ..
		"button_exit[4,3.5;2,1;setexit;Set]" ..
		"button_exit[6,3.5;2,1;clearexit;Clear]" ..

		"label[0,4.5;Abort function]" ..
		"label[0,5;Death,disconnect,manual abort]" ..
		"label[2,4.5;" .. abort_pos .. "]" ..
		"button_exit[4,4.5;2,1;setabort;Set]" ..
		"button_exit[6,4.5;2,1;clearabort;Clear]" ..

		"button[0,5.5;8,1;view;Show player view]" ..
		"button_exit[0,6.5;8,1;save;Save]" ..

		""

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
	local playername = player:get_player_name()

	if minetest.is_protected(pos, playername) then
		return
	end

	if fields.save then
		meta:set_string("name", fields.name or "")
	end

	if fields.setmain then
		punch_handler_main[playername] = pos
		minetest.chat_send_player(playername, "[epic] please punch the function to set as main")

	elseif fields.setexit then
		punch_handler_exit[playername] = pos
		minetest.chat_send_player(playername, "[epic] please punch the function to set as exit")

	elseif fields.setabort then
		punch_handler_abort[playername] = pos
		minetest.chat_send_player(playername, "[epic] please punch the function to set as abort")

	elseif fields.clearmain then
		meta:set_string("main_pos", "")
		punch_handler_main[playername] = nil

	elseif fields.clearexit then
		meta:set_string("exit_pos", "")
		punch_handler_exit[playername] = nil

	elseif fields.clearabort then
		meta:set_string("abort_pos", "")
		punch_handler_abort[playername] = nil

	elseif fields.view then
		epic.form.epic_view(pos, playername)
		return true

	end

end)


minetest.register_on_punchnode(function(pos, _, puncher, _)
	local playername = puncher:get_player_name()

	-- set main
	local cfg_pos = punch_handler_main[playername]
	if cfg_pos then
		if minetest.is_protected(pos, playername) and
			not minetest.check_player_privs(playername, {epic_admin=true}) then
			minetest.chat_send_player(playername, "[epic] target is protected! aborting selection.")

		else
			local meta = minetest.get_meta(cfg_pos)
			local pos_str = minetest.pos_to_string(epic.to_relative_pos(cfg_pos, pos))
			meta:set_string("main_pos", pos_str)
			minetest.chat_send_player(playername, "[epic] main function set to " .. pos_str)

		end
		punch_handler_main[playername] = nil
	end

	-- set exit
	cfg_pos = punch_handler_exit[playername]
	if cfg_pos then
		if minetest.is_protected(pos, playername) and
			not minetest.check_player_privs(playername, {epic_admin=true}) then
			minetest.chat_send_player(playername, "[epic] target is protected! aborting selection.")

		else
			local meta = minetest.get_meta(cfg_pos)
			local pos_str = minetest.pos_to_string(epic.to_relative_pos(cfg_pos, pos))
			meta:set_string("exit_pos", pos_str)
			minetest.chat_send_player(playername, "[epic] exit function set to " .. pos_str)
		end
		punch_handler_exit[playername] = nil
	end

	-- set abort
	cfg_pos = punch_handler_abort[playername]
	if cfg_pos then
		if minetest.is_protected(pos, playername) and
			not minetest.check_player_privs(playername, {epic_admin=true}) then
			minetest.chat_send_player(playername, "[epic] target is protected! aborting selection.")

		else
			local meta = minetest.get_meta(cfg_pos)
			local pos_str = minetest.pos_to_string(epic.to_relative_pos(cfg_pos, pos))
			meta:set_string("abort_pos", pos_str)
			minetest.chat_send_player(playername, "[epic] abort function set to " .. pos_str)
		end
		punch_handler_abort[playername] = nil
	end

end)

minetest.register_on_leaveplayer(function(player)
	local playername = player:get_player_name()
	punch_handler_main[playername] = nil
	punch_handler_exit[playername] = nil
	punch_handler_abort[playername] = nil

end)

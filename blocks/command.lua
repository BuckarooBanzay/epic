local update_formspec = function(meta)
	local cmd = meta:get_string("cmd")
	meta:set_string("infotext", "Command block: '" .. cmd .. "'")

	meta:set_string("formspec", "size[8,2;]" ..
		-- col 1
		"field[0.2,0.5;8,1;cmd;Command (use @player and @owner);" .. cmd .. "]" ..

		-- col 2
		"button_exit[0.1,1.5;8,1;save;Save]" ..
		"")
end

local execute = function(str, playername)
	minetest.log("action", "[epic] executing: '" .. str .. "'")

	local found, _, commandname, params = str:find("^([^%s]+)%s(.+)$")
	if not found then
		commandname = str
	end
	local command = minetest.chatcommands[commandname]
	if not command then
		minetest.chat_send_player(playername, "Not a valid command: " .. commandname)
		return
	end

	if command.privs and not minetest.check_player_privs(playername, command.privs) then
		minetest.chat_send_player(playername, "Not enough privileges!")
	end

	command.func(playername, (params or ""))
end

minetest.register_node("epic:command", {
	description = "Epic command block: executes a chat-command",
	tiles = {
		"epic_node_bg.png",
		"epic_node_bg.png",
		"epic_node_bg.png",
		"epic_node_bg.png",
		"epic_node_bg.png",
		"epic_node_bg.png^epic_command.png",
	},
	paramtype2 = "facedir",
	groups = {cracky=3,oddly_breakable_by_hand=3,epic=1},
	on_rotate = screwdriver.rotate_simple,

	after_place_node = function(pos, placer)
		local meta = minetest.get_meta(pos)
		meta:set_string("owner", placer:get_player_name())
		meta:set_string("cmd", "status")
    update_formspec(meta, pos)
	end,

  on_receive_fields = function(pos, _, fields, sender)
    local meta = minetest.get_meta(pos);

		if not sender or sender:get_player_name() ~= meta:get_string("owner") then
			-- not allowed
			return
		end

    if fields.save then
      local cmd = fields.cmd or "status"
			meta:set_string("cmd", cmd)
			update_formspec(meta, pos)
    end

  end,

	epic = {
    on_enter = function(_, meta, player, ctx)
      local cmd = meta:get_string("cmd")
			local owner = meta:get_string("owner")
			cmd = cmd:gsub("@player", player:get_player_name())
			cmd = cmd:gsub("@owner", owner)
			execute(cmd, owner)
      ctx.next()
    end
  }
})

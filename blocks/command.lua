local update_formspec = function(meta)
	local cmd = meta:get_string("cmd")
	meta:set_string("infotext", "Command block: '" .. cmd .. "'")

	meta:set_string("formspec", "size[8,2;]" ..
		-- col 1
		"field[0.2,0.5;8,1;cmd;Command;" .. cmd .. "]" ..

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
	command.func(playername, (params or ""))
end

minetest.register_node("epic:command", {
	description = "Epic command block",
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

		if not sender or minetest.is_protected(pos, sender:get_player_name()) then
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
    on_enter = function(_, meta, _, ctx)
      local cmd = meta:get_string("cmd")
			local owner = meta:get_string("owner")
			execute(cmd, owner)
      ctx.next()
    end
  }
})

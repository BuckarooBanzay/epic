local update_formspec = function(meta)
	local text = meta:get_string("text")
	meta:set_string("infotext", "Dialogue block: '" .. text .. "'")

	meta:set_string("formspec", "size[8,2;]" ..
		"field[0.2,0.5;8,1;text;Text;" .. text .. "]" ..
		"button_exit[0.1,1.5;8,1;save;Save]" ..
		"")
end

-- player -> {}
local active_dialogues = {}

-- formspec name
local FORMNAME = "epic_dialogue"

-- create the dialogue formspec
local function show_formspec(player_name)
	local player_dialogue = active_dialogues[player_name]

	local buttons = ""

	local i = 0
	for pos_str, text in pairs(player_dialogue.targets) do
		buttons = buttons ..
			"button_exit[0," .. (i+0) .. ";2,1;" .. pos_str .. ";Choose]" ..
			"label[2.5," .. (i+0.2) .. ";" .. text .. "]"
		i = i + 1
	end

	minetest.show_formspec(player_name,
		FORMNAME,
		"size[8," .. (i) .. ";]" ..
		buttons
	)
end

-- callback
minetest.register_on_player_receive_fields(function(player, formname, fields)
	local parts = formname:split(";")
	local name = parts[1]
	if name ~= FORMNAME then
		return
	end

	print("epic_dialogue", player:get_player_name(), dump(fields))

	local player_name = player:get_player_name()
	local player_dialogue = active_dialogues[player_name]

	if not player_dialogue then
		-- dialogue not active
		return
	end

	for pos_str in pairs(player_dialogue.targets) do
		if fields[pos_str] then
			player_dialogue.selected = pos_str
			return true
		end
	end

	-- no choice = quit
	player_dialogue.quit = true
	return true
end)


minetest.register_node("epic:dialogue", {
	description = "Epic dialogue block: show one or more questions in a formspec",
	tiles = {
		"epic_node_bg.png",
		"epic_node_bg.png",
		"epic_node_bg.png",
		"epic_node_bg.png",
		"epic_node_bg.png",
		"epic_node_bg.png^epic_bubble.png",
	},
	paramtype2 = "facedir",
	groups = {cracky=3,oddly_breakable_by_hand=3,epic=1},
	on_rotate = epic.on_rotate,

	on_construct = function(pos)
    local meta = minetest.get_meta(pos)
		meta:set_string("text", "Example text")
    update_formspec(meta, pos)
  end,

  on_receive_fields = function(pos, _, fields, sender)
    local meta = minetest.get_meta(pos);

		if not sender or minetest.is_protected(pos, sender:get_player_name()) then
			-- not allowed
			return
		end

    if fields.save then
      local text = fields.text or "<no text>"
			meta:set_string("text", text)
			update_formspec(meta, pos)
    end

  end,

	epic = {
    on_enter = function(pos, meta, player)
			local player_name = player:get_player_name()
			local player_dialogue = active_dialogues[player_name]
			if not player_dialogue then
				-- create dialogue entry
				player_dialogue = {
					active = false,
					quit = false,
					selected = nil,
					-- pos-str -> bool(selected)
					targets = {}
				}
				-- save
				active_dialogues[player_name] = player_dialogue
			end

			-- mark dialogue as not selected yet
			player_dialogue.targets[minetest.pos_to_string(pos)] = meta:get_string("text")
    end,
		on_check = function(pos, _, player, ctx)
			local player_name = player:get_player_name()
			local player_dialogue = active_dialogues[player_name]

			if player_dialogue then
				-- show formspec if not alredy active
				if not player_dialogue.active then
					show_formspec(player_name)
					player_dialogue.active = true
				end

				if player_dialogue.quit then
					-- player quit the formname, abort epic execution
					ctx.abort("dialogue-exit")
					return
				end

				-- check if current dialogue node is selected
				if player_dialogue.selected and player_dialogue.selected == minetest.pos_to_string(pos) then
					-- position matches proceed
					ctx.next()
				end
			end
		end,
		on_exit = function(_, _, player)
			-- clear current dialogue
			local player_name = player:get_player_name()
			active_dialogues[player_name] = nil
		end
  }
})

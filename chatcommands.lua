
minetest.register_chatcommand("epic_abort", {
	description = "Aborts the current epic",
	func = function(name)
    epic.abort(name)
	end
})


minetest.register_chatcommand("epic_dump", { -- *chuckles*
	description = "Dumps the current state, optionally from a given user",
  privs = { epic_debug = true },
	func = function(_, params)
		if params then
			return true, dump(epic.state[params])
		else
			return true, dump(epic.state)
		end
	end
})

minetest.register_chatcommand("epic_load", {
	description = "Loads a savegame",
	privs = { epic_debug = true },
	func = function(name, param)
		if not param or param == "" then
			return false, "usage: /epic_load <topic>"
		else
			epic.form.epic_savegame_load(param, name)
			return true
		end
	end
})

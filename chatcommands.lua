
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

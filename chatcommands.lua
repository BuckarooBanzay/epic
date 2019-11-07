
minetest.register_chatcommand("epic_abort", {
	description = "Aborts the current epic",
	func = function(name)
    epic.abort(name)
	end
})


local function check_lock(_, meta, _, ctx)
	if meta:get_int("lock") == 0 then
		meta:set_string("infotext", "Locked")
		meta:set_int("lock", 1)
		ctx.next()
	end
end

minetest.register_node("epic:lock", {
	description = "Epic lock block: locks the current execution-path (mutual exclusive execution)",
	tiles = epic.create_texture("condition", "epic_lock.png"),
	paramtype2 = "facedir",
	groups = {cracky=3,oddly_breakable_by_hand=3,epic=1},
	on_rotate = epic.on_rotate,

	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_string("infotext", "Unlocked")
		meta:set_int("lock", 0)
	end,

	epic = {
		on_enter = check_lock,
		on_check = check_lock
	}
})

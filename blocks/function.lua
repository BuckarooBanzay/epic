
local update_formspec = function(meta, pos)
	meta:set_string("formspec", "size[8,10;]" ..
		"button_exit[0,2;2,1;execute;Execute]")
end

epic.register_opcode("epic:function", {
	description = "Epic function block",
  overlay = "epic_function.png",
  directions = {
    start = true
  },
  on_construct = function(pos)
    local meta = minetest.get_meta(pos)
    update_formspec(meta, pos)
  end,

  on_receive_fields = function(pos, formname, fields, sender)
    local meta = minetest.get_meta(pos);

		if not sender then
			return
		end

		if minetest.is_protected(pos, sender:get_player_name()) then
			-- not allowed
			return
		end

    if fields.execute then
      epic.execute_function(pos, sender)
    end

  end
})


local def = minetest.registered_nodes["signs:paper_poster"]
assert(def)

-- playername -> bool
local closed_forms = {}

local old_on_receive_fields = def.on_receive_fields
def.on_receive_fields = function(pos, formname, fields, player)
	closed_forms[player:get_player_name()] = true
	old_on_receive_fields(pos, formname, fields, player)
end

def.groups.epic = 1
def.epic = {
	on_enter = function(pos, _, player)
		closed_forms[player:get_player_name()] = nil
		local node = epic.get_node(pos)
		def.on_rightclick(pos, node, player)
	end,
	on_check = function(_, _, player, ctx)
		if closed_forms[player:get_player_name()] then
			closed_forms[player:get_player_name()] = nil
			ctx.next()
		end
	end
}


local function find_nearest(pos, list, visited, allowed_axes)

	if visited[minetest.hash_node_position(pos)] then
		return
	end

	local node = epic.get_node(pos)
	if epic.is_epic(node) then
		table.insert(list, pos)
	end

	visited[minetest.hash_node_position(pos)] = true

	local pos1 = { x=pos.x, y=pos.y, z=pos.z }
	local pos2 = { x=pos.x, y=pos.y, z=pos.z }

	if allowed_axes.x then
		pos1.x = pos.x - 1
		pos2.x = pos.x + 1
	end

	if allowed_axes.y then
		pos1.y = pos.y - 1
		pos2.y = pos.y + 1
	end

	if allowed_axes.z then
		pos1.z = pos.z - 1
		pos2.z = pos.z + 1
	end

	-- load area with vmanip
	minetest.get_voxel_manip(pos1, pos2)
	local nodes = minetest.find_nodes_in_area(pos1, pos2, {"group:epic"})

	for _, node_pos in ipairs(nodes) do
		find_nearest(node_pos, list, visited, allowed_axes)
	end

end

local find_epic_blocks_in_plane = function(pos, direction)
	local allowed_axes = {
		x = direction.x == 0,
		y = direction.y == 0,
		z = direction.z == 0
	}

	local start = vector.add(pos, direction)

	local visited = {}
	local list = {}

	find_nearest(start, list, visited, allowed_axes)

	return list
end


minetest.register_node("epic:branch", {
	description = "Epic branch block: selects the first successful conditional block",
	tiles = {
		"epic_node_bg.png",
		"epic_node_bg.png",
		"epic_node_bg.png",
		"epic_node_bg.png",
		"epic_node_bg.png",
		"epic_node_bg.png^epic_branch.png",
	},
	paramtype2 = "facedir",
	groups = {cracky=3,oddly_breakable_by_hand=3,epic=1},
	on_rotate = screwdriver.rotate_simple,

  epic = {
    on_enter = function(pos, _, player, ctx)

			local node = epic.get_node(pos)
			local direction = epic.get_direction(node.param2)
			local pos_list = find_epic_blocks_in_plane(pos, direction)
			local next_called = false

			ctx.step_data.targets = pos_list
			ctx.step_data.target_step_data = {}
			for _, target_pos in ipairs(ctx.step_data.targets) do
				local target_node = minetest.get_node(target_pos)
				local nodedef = minetest.registered_nodes[target_node.name]
				local target_step_data = {}
				ctx.step_data.target_step_data[minetest.hash_node_position(target_pos)] = target_step_data

				local sub_ctx = {
					next = function()
						if not next_called then
							ctx.next(target_pos)
						end
						next_called = true
					end,
					call = ctx.call,
					step_data = target_step_data,
					data = ctx.data
				}

				if nodedef.epic and nodedef.epic.on_enter then
					if epic.log_executor then
						minetest.log("action", "[epic::branch] on_before_node_enter player=" ..
							player:get_player_name() ..
							" pos=" .. minetest.pos_to_string(target_pos) ..
							" node=" .. minetest.get_node(target_pos).name)
					end

					nodedef.epic.on_enter(target_pos, minetest.get_meta(target_pos), player, sub_ctx)

					if epic.log_executor then
						minetest.log("action", "[epic::branch] on_before_node_exit player=" ..
				      player:get_player_name() ..
				      " pos=" .. minetest.pos_to_string(target_pos) ..
				      " node=" .. minetest.get_node(target_pos).name)
					end
				end
			end
    end,
		on_check = function(_, _, player, ctx)
			local next_called = false

			for _, target_pos in ipairs(ctx.step_data.targets) do
				local node = minetest.get_node(target_pos)
				local nodedef = minetest.registered_nodes[node.name]
				local target_step_data = ctx.step_data.target_step_data[minetest.hash_node_position(target_pos)]
				local sub_ctx = {
					next = function()
						if not next_called then
							ctx.next(epic.get_next_pos(target_pos))
						end
						next_called = true
					end,
					step_data = target_step_data,
					data = ctx.data
				}

				if nodedef.epic and nodedef.epic.on_check then
					if epic.log_executor then
						minetest.log("action", "[epic::branch] on_before_node_check player=" ..
				      player:get_player_name() ..
				      " pos=" .. minetest.pos_to_string(target_pos) ..
				      " node=" .. minetest.get_node(target_pos).name)
					end

					nodedef.epic.on_check(target_pos, minetest.get_meta(target_pos), player, sub_ctx)
				end
			end
		end,
		on_exit = function(_, _, player, ctx)
			for _, target_pos in ipairs(ctx.step_data.targets) do
				local node = minetest.get_node(target_pos)
				local nodedef = minetest.registered_nodes[node.name]
				local target_step_data = ctx.step_data.target_step_data[minetest.hash_node_position(target_pos)]
				local sub_ctx = {
					next = function() end,
					step_data = target_step_data,
					data = ctx.data
				}

				if nodedef.epic and nodedef.epic.on_exit then
					nodedef.epic.on_exit(target_pos, minetest.get_meta(target_pos), player, sub_ctx)
				end
			end
		end
  }
})

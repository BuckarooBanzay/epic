local FORMNAME = "epic_review"


-- rate formspec for quest player
local function show_formspec(pos, playername)
	local formspec = "size[8,5;]" ..
		"label[0,0;Rate this quest]" ..

		"image[0,1;1,1;epic_star.png]" ..
		"button_exit[5.5,1;2,1;one;1 Star]" ..

		"image[0,2;1,1;epic_star.png]" ..
		"image[1,2;1,1;epic_star.png]" ..
		"button_exit[5.5,2;2,1;two;2 Star]" ..

		"image[0,3;1,1;epic_star.png]" ..
		"image[1,3;1,1;epic_star.png]" ..
		"image[2,3;1,1;epic_star.png]" ..
		"button_exit[5.5,3;2,1;three;3 Star]" ..

		"image[0,4;1,1;epic_star.png]" ..
		"image[1,4;1,1;epic_star.png]" ..
		"image[2,4;1,1;epic_star.png]" ..
		"image[3,4;1,1;epic_star.png]" ..
		"button_exit[5.5,4;2,1;four;4 Star]" ..

		"image[0,5;1,1;epic_star.png]" ..
		"image[1,5;1,1;epic_star.png]" ..
		"image[2,5;1,1;epic_star.png]" ..
		"image[3,5;1,1;epic_star.png]" ..
		"image[4,5;1,1;epic_star.png]" ..
		"button_exit[5.5,5;2,1;five;5 Star]"

	minetest.show_formspec(playername,
		FORMNAME .. ";" .. minetest.pos_to_string(pos),
		formspec
	)
end

-- block formspec
local update_formspec = function(meta)
	local counter = meta:get_int("counter")
	local lastplayer = meta:get_string("lastplayer")

	meta:set_string("infotext", "Visits: " .. counter ..
		" Last player: ''" .. lastplayer .. "'")

	meta:set_string("formspec", "size[8,8;]" ..
		"label[0,0.5;Visits:${counter}]" ..
		"label[0,1.5;1-Star:${one-star}]" ..
		"label[0,2.5;2-Star:${two-star}]" ..
		"label[0,3.5;3-Star:${three-star}]" ..
		"label[0,4.5;4-Star:${four-star}]" ..
		"label[0,5.5;5-Star:${five-star}]" ..
		"button_exit[0.1,6.5;8,1;reset;Reset]" ..
		"")
end

-- initialize review stats
local function initialize_reviews(meta)
	-- overall counter
	meta:set_int("counter", 0)
	meta:set_string("lastplayer", "")

	-- rating counter
	meta:set_int("no-review", 0)
	meta:set_int("one-star", 0)
	meta:set_int("two-star", 0)
	meta:set_int("three-star", 0)
	meta:set_int("four-star", 0)
	meta:set_int("five-star", 0)

end

-- review block
minetest.register_node("epic:review", {
	description = "Epic review block",
	tiles = {
		"epic_node_bg.png",
		"epic_node_bg.png",
		"epic_node_bg.png",
		"epic_node_bg.png",
		"epic_node_bg.png",
		"epic_node_bg.png^epic_star.png",
	},
	paramtype2 = "facedir",
	groups = {cracky=3,oddly_breakable_by_hand=3,epic=1},
	on_rotate = screwdriver.rotate_simple,

	on_construct = function(pos)
    local meta = minetest.get_meta(pos)
		initialize_reviews(meta)
    update_formspec(meta)
  end,

	on_receive_fields = function(pos, _, fields, sender)
		if not sender or minetest.is_protected(pos, sender:get_player_name()) then
			-- not allowed
			return
		end

		local meta = minetest.get_meta(pos);

		if fields.reset then
			initialize_reviews(meta)
			update_formspec(meta)
		end

	end,

  epic = {
    on_enter = function(pos, meta, player, ctx)
			local name = player:get_player_name()
			meta:set_int("counter", meta:get_int("counter") + 1)
			meta:set_string("lastplayer", name)
			show_formspec(pos, name)
			ctx.next()
    end
  }
})

-- callback from rate-form
minetest.register_on_player_receive_fields(function(_, formname, fields)
	local parts = formname:split(";")
	local name = parts[1]
	if name ~= FORMNAME then
		return
	end

	local pos = minetest.string_to_pos(parts[2])
	local meta = minetest.get_meta(pos)

	if fields.one then
		meta:set_int("one-star", meta:get_int("one-star") + 1)
	elseif fields.two then
		meta:set_int("two-star", meta:get_int("two-star") + 1)
	elseif fields.three then
		meta:set_int("three-star", meta:get_int("three-star") + 1)
	elseif fields.four then
		meta:set_int("four-star", meta:get_int("four-star") + 1)
	elseif fields.five then
		meta:set_int("five-star", meta:get_int("five-star") + 1)
	end

	update_formspec(meta)

end)

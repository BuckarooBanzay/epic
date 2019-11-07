
globals = {
	"epic",
	"minetest",
	"lightning"
}

read_globals = {
	-- Stdlib
	string = {fields = {"split"}},
	table = {fields = {"copy", "getn"}},

	-- Minetest
	"vector", "ItemStack",
	"dump", "VoxelArea",

	-- deps
	"screwdriver",
	"mesecon",
	"player_monoids",
	"soundblock",
	"monitoring",
	"mobs"
}

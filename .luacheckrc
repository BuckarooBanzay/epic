
globals = {
	"epic",
	"minetest",
	"screwdriver",
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
	"mesecon",
	"player_monoids",
	"soundblock",
	"monitoring",
	"mobs"
}

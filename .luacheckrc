
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
	"digilines",
	"player_monoids",
	"soundblock",
	"monitoring",
	"mobs",
	"areas"
}

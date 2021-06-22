#!/bin/sh

docker run --rm -i \
	--user root \
	-v $(pwd)/scripts/minetest.conf:/etc/minetest/minetest.conf:ro \
	-v $(pwd)/worldmods:/root/.minetest/worlds/world/worldmods \
	-v $(pwd)/:/root/.minetest/worlds/world/worldmods/mtinfo \
	-v $(pwd)/output:/root/.minetest/worlds/world/mtinfo \
	registry.gitlab.com/minetest/minetest/server:5.3.0

test -f $(pwd)/output/index.html || exit 1
test -f $(pwd)/output/data/items.js || exit 1
test -d $(pwd)/output/textures || exit 1

rm -rf app/data app/textures
cp -R output/data app/
cp -R output/textures app/
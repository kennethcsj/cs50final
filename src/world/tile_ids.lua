--[[
    GD50
    Pokemon

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

TILE_IDS = {
    ['grass'] = {46, 47},
    ['empty'] = 101,
    ['tall-grass'] = 42,
    ['half-tall-grass'] = 50,
    ['sand'] = {45, 62},
    ['flower'] = {8, 16, 24, 32, 40, 48, 56, 64},
}

-- Tiles which entity can walk on
WALKABLE_TILE_IDS = {
    45, 62, 101
}
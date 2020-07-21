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
    ['flower'] = 41,
    ['horizontal-metal-gate-middle'] = 77,
    ['horizontal-metal-gate-left'] = 80,
    ['horizontal-metal-gate-right'] = 79,
    ['vertical-metal-gate-middle'] = 84,
    ['horizontal-wooden-gate-middle'] = 74,
    ['horizontal-wooden-gate-left'] = 66,
    ['horizontal-wooden-gate-right'] = 65,
    ['vertical-wooden-gate-middle'] = 81,
}

WALKABLE_TILE_IDS = {
    45, 62, 101
}
Class = require 'lib/class'
Event = require 'lib/knife.event'
push = require 'lib/push'
Timer = require 'lib/knife.timer'

require 'src/Animation'
require 'src/constants'
require 'src/StateMachine'
require 'src/Util'

require 'src/entity/entity_defs'
require 'src/entity/Entity'
require 'src/entity/Player'

require 'src/states/BaseState'
require 'src/states/StateStack'

require 'src/states/entity/EntityBaseState'
require 'src/states/entity/EntityIdleState'
require 'src/states/entity/EntityWalkState'
require 'src/states/entity/PlayerIdleState'
require 'src/states/entity/PlayerWalkState'

require 'src/states/game/FadeInState'
require 'src/states/game/FadeOutState'
require 'src/states/game/PlayState'
require 'src/states/game/StartState'

require 'src/world/Level'
require 'src/world/tile_ids'
require 'src/world/Tile'
require 'src/world/TileMap'

gFonts = {
    ['vsmall'] = love.graphics.newFont('fonts/font.ttf', 4),
    ['small'] = love.graphics.newFont('fonts/font.ttf', 8),
    ['medium'] = love.graphics.newFont('fonts/font.ttf', 16),
    ['large'] = love.graphics.newFont('fonts/font.ttf', 32)
}

gTextures = {
    ['arrows'] = love.graphics.newImage('graphics/arrows.png'),
    ['entities'] = love.graphics.newImage('graphics/entities.png'),
    ['tiles'] = love.graphics.newImage('graphics/sheet.png'),
}

gFrames = {
    ['arrows'] = GenerateQuads(gTextures['arrows'], 16, 16),
    ['entities'] = GenerateQuads(gTextures['entities'], 16, 16),
    ['tiles'] = GenerateQuads(gTextures['tiles'], 16, 16),
}
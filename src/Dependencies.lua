Class = require 'lib/class'
Event = require 'lib/knife.event'
push = require 'lib/push'
Timer = require 'lib/knife.timer'

require 'src/Animation'
require 'src/constants'
require 'src/Character'
require 'src/character_defs'
require 'src/object_defs'
require 'src/Party'
require 'src/Item'
require 'src/StateMachine'
require 'src/Util'

require 'src/entity/entity_defs'
require 'src/entity/Entity'
require 'src/entity/Player'
require 'src/entity/Object'

require 'src/gui/Menu'
require 'src/gui/Panel'
require 'src/gui/ProgressBar'
require 'src/gui/Selection'
require 'src/gui/Selector'
require 'src/gui/Textbox'

require 'src/states/BaseState'
require 'src/states/StateStack'

require 'src/battle/Enemy'

require 'src/states/entity/EntityBaseState'
require 'src/states/entity/EntityIdleState'
require 'src/states/entity/EntityWalkState'
require 'src/states/entity/PlayerIdleState'
require 'src/states/entity/PlayerWalkState'

require 'src/states/game/BattleState'
require 'src/states/game/BattleAttackState'
require 'src/states/game/BattleEnemySelectState'
require 'src/states/game/BattleItemState'
require 'src/states/game/BattleItemSelectState'
require 'src/states/game/BattleMenuState'
require 'src/states/game/BattleMessageState'
require 'src/states/game/FadeInState'
require 'src/states/game/FadeOutState'
require 'src/states/game/FieldItemSelectMenuState'
require 'src/states/game/FieldItemMenuState'
require 'src/states/game/FieldIndividualMenuState'
require 'src/states/game/FieldMenuState'
require 'src/states/game/FieldPartyMenuState'
require 'src/states/game/FieldPartySwitchMenuState'
require 'src/states/game/FieldUpgradeStatsMenuState'
require 'src/states/game/MessageConfirmState'
require 'src/states/game/MessagePopUpState'
require 'src/states/game/PlayState'
require 'src/states/game/StartState'

require 'src/world/Level'
require 'src/world/tile_ids'
require 'src/world/Tile'
require 'src/world/TileMap'

require 'src/world/maps/MapHome'
require 'src/world/maps/MapOne'
require 'src/world/maps/MapTwo'
require 'src/world/maps/MapThree'
require 'src/world/maps/MapFour'
require 'src/world/maps/map_defs'

gFonts = {
    ['vsmall'] = love.graphics.newFont('fonts/font.ttf', 4),
    ['small'] = love.graphics.newFont('fonts/font.ttf', 8),
    ['small-medium'] = love.graphics.newFont('fonts/font.ttf', 12),
    ['medium'] = love.graphics.newFont('fonts/font.ttf', 16),
    ['large'] = love.graphics.newFont('fonts/font.ttf', 32)
}

gTextures = {
    ['arrows'] = love.graphics.newImage('graphics/arrows.png'),
    ['red-arrow'] = love.graphics.newImage('graphics/red_arrow.png'),
    ['entities'] = love.graphics.newImage('graphics/entities.png'),
    ['tiles'] = love.graphics.newImage('graphics/sheet.png'),
    ['cursor'] = love.graphics.newImage('graphics/cursor.png'),
    ['food'] = love.graphics.newImage('graphics/food.png'),
    ['portals'] = love.graphics.newImage('graphics/portal.png'),
    ['boss'] = love.graphics.newImage('graphics/boss.png')
}

gFrames = {
    ['arrows'] = GenerateQuads(gTextures['arrows'], 16, 16),
    ['entities'] = GenerateQuads(gTextures['entities'], 16, 16),
    ['tiles'] = GenerateQuads(gTextures['tiles'], 16, 16),
    ['portals'] = GenerateQuads(gTextures['portals'], 48, 48),
    ['boss'] = GenerateQuads(gTextures['boss'], 48, 48)
}
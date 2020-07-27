Class = require 'lib/class'
Event = require 'lib/knife.event'
push = require 'lib/push'
Timer = require 'lib/knife.timer'

require 'src/Animation'
require 'src/constants'
require 'src/Character'
require 'src/character_defs'
require 'src/item_defs'
require 'src/Party'
require 'src/Object'
require 'src/object_defs'
require 'src/Item'
require 'src/StateMachine'
require 'src/Util'

require 'src/entity/entity_defs'
require 'src/entity/Entity'
require 'src/entity/Player'
require 'src/entity/Enemy'

require 'src/gui/Menu'
require 'src/gui/Panel'
require 'src/gui/ProgressBar'
require 'src/gui/Selection'
require 'src/gui/Selector'
require 'src/gui/Textbox'

require 'src/states/BaseState'
require 'src/states/StateStack'

require 'src/states/entity/EntityBaseState'
require 'src/states/entity/EntityIdleState'
require 'src/states/entity/EntityWalkState'
require 'src/states/entity/PlayerIdleState'
require 'src/states/entity/PlayerWalkState'

require 'src/states/game/battle/BattleState'
require 'src/states/game/battle/BattleAttackState'
require 'src/states/game/battle/BattleEnemySelectState'
require 'src/states/game/battle/BattleItemState'
require 'src/states/game/battle/BattleItemSelectState'
require 'src/states/game/battle/BattleMenuState'
require 'src/states/game/battle/BattleMessageState'
require 'src/states/game/DialogueState'
require 'src/states/game/FadeInState'
require 'src/states/game/FadeOutState'
require 'src/states/game/field/FieldItemSelectMenuState'
require 'src/states/game/field/FieldItemMenuState'
require 'src/states/game/field/FieldIndividualMenuState'
require 'src/states/game/field/FieldMenuState'
require 'src/states/game/field/FieldPartyMenuState'
require 'src/states/game/field/FieldPartySwitchMenuState'
require 'src/states/game/field/FieldUpgradeStatsMenuState'
require 'src/states/game/MessageConfirmState'
require 'src/states/game/MessagePopUpState'
require 'src/states/game/PlayState'
require 'src/states/game/StartState'

require 'src/world/Level'
require 'src/world/tile_ids'
require 'src/world/Tile'
require 'src/world/TileMap'

require 'src/world/maps/MapHome'
require 'src/world/maps/MapIntro'
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
    ['boss'] = love.graphics.newImage('graphics/boss.png'),
    ['chest'] = love.graphics.newImage('graphics/chests.png'),
    ['foods'] = love.graphics.newImage('graphics/foods.png'),
}

gFrames = {
    ['arrows'] = GenerateQuads(gTextures['arrows'], 16, 16),
    ['entities'] = GenerateQuads(gTextures['entities'], 16, 16),
    ['tiles'] = GenerateQuads(gTextures['tiles'], 16, 16),
    ['portals'] = GenerateQuads(gTextures['portals'], 48, 48),
    ['boss'] = GenerateQuads(gTextures['boss'], 48, 48),
    ['chest'] = GenerateQuads(gTextures['chest'], 32, 48),
    ['foods'] = GenerateQuads(gTextures['foods'], 16, 16)
}

gSounds = {
    ['beep'] = love.audio.newSource('sounds/beep.wav'),
    ['menu'] = love.audio.newSource('sounds/menu.wav'),
    ['select'] = love.audio.newSource('sounds/select.wav'),
    ['levelup'] = love.audio.newSource('sounds/levelup.wav'),
    ['obtain'] = love.audio.newSource('sounds/obtain.wav'),
    ['attack'] = love.audio.newSource('sounds/attack.wav'),
    ['damage'] = love.audio.newSource('sounds/damage.wav'),
    ['victory'] = love.audio.newSource('sounds/victory.wav'),
    ['gameover'] = love.audio.newSource('sounds/gameover.wav'),
    ['item'] = love.audio.newSource('sounds/item.mp3'),
    ['battle-music'] = love.audio.newSource('sounds/battle.mp3'),
    ['field-music'] = love.audio.newSource('sounds/field-music.mp3'),
    ['intro-music'] = love.audio.newSource('sounds/intro-music.mp3'),
    ['town-music'] = love.audio.newSource('sounds/town-music.mp3'),
    ['dream-music'] = love.audio.newSource('sounds/dream-music.mp3'),
}
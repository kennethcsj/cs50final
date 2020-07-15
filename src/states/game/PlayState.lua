--[[
    GD50
    Pokemon

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

PlayState = Class{__includes = BaseState}

function PlayState:init(def)
    self.player = Player {
        animations = ENTITY_DEFS[def.character].animations,
        mapX = 5,
        mapY = 5,
        width = 16,
        height = 16,
        type = 'player',
        character = def.character
    }

    self.level = MapOne(def, self.player)
end

function PlayState:update(dt)
    if love.keyboard.wasPressed('m') then
        gStateStack:push(FieldMenuState(self))
    end

    self.level:update(dt)
end

function PlayState:render()
    self.level:render()
end


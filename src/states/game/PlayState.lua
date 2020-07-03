--[[
    GD50
    Pokemon

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

PlayState = Class{__includes = BaseState}

function PlayState:init(def)
    self.level = Level(def)
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


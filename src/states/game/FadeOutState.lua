--[[
    GD50
    Pokemon

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

FadeOutState = Class{__includes = BaseState}

function FadeOutState:init(color, time, onFadeComplete, x, y)
    self.opacity = 255
    self.r = color.r
    self.g = color.g
    self.b = color.b
    self.x = x or 0
    self.y = y or 0
    self.time = time

    Timer.tween(self.time, {
        [self] = {opacity = 0}
    })
    :finish(function()
        gStateStack:pop()
        onFadeComplete()
    end)
end

function FadeOutState:update(dt)

end

function FadeOutState:render()
    love.graphics.setColor(self.r, self.g, self.b, self.opacity)
    love.graphics.rectangle('fill', self.x, self.y, VIRTUAL_WIDTH * 5, VIRTUAL_HEIGHT * 5)

    love.graphics.setColor(255, 255, 255, 255)
end
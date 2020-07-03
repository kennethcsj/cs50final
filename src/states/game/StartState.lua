--[[
    GD50
    Pokemon

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

StartState = Class{__includes = BaseState}

function StartState:init()
    self.choice = 5
    self.choiceX = VIRTUAL_WIDTH / 2 - 8
    self.choiceY = VIRTUAL_HEIGHT / 2 + 16
end

function StartState:update(dt)
    if love.keyboard.wasPressed('left') or love.keyboard.wasPressed('right') then
        self.choice = (self.choice == 5) and 8 or 5
    end
    
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        local character
        character = (self.choice == 5) and 'player-boy' or 'player-girl'

        gStateStack:push(FadeInState({
            r = 255, g = 255, b = 255
        }, 1,
        function()
            gStateStack:pop()
            
            gStateStack:push(PlayState({character = character}))
            gStateStack:push(FadeOutState({
                r = 255, g = 255, b = 255
            }, 1,
            function() end))
        end))
    end
end

function StartState:render()
    love.graphics.clear(0, 188, 188, 255)

    love.graphics.setColor(24, 24, 24, 255)
    love.graphics.setFont(gFonts['large'])
    love.graphics.printf('RPG 50!', 0, VIRTUAL_HEIGHT / 2 - 72, VIRTUAL_WIDTH, 'center')
    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf('Press Enter to Start', 0, VIRTUAL_HEIGHT / 2 + 68, VIRTUAL_WIDTH, 'center')
    love.graphics.setFont(gFonts['small'])

    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.draw(gTextures['entities'], gFrames['entities'][self.choice], self.choiceX, self.choiceY)

    -- draws the arrow
    love.graphics.draw(gTextures['arrows'], gFrames['arrows'][2], self.choiceX + 96, self.choiceY)
    love.graphics.draw(gTextures['arrows'], gFrames['arrows'][1], self.choiceX - 96, self.choiceY)
end
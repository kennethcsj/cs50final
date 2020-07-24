FieldIndividualMenuState = Class{__includes = BaseState}

function FieldIndividualMenuState:init(playState, char, charPosition)
    self.playState = playState
    self.char = char
    self.charPosition = charPosition

    self.party = self.playState.level.player.party.party

    self.items = {'Upgrade Stats', 'Change Party Position'}

    self.select = Selector{
        items = self.items
    }

    self.x = self.playState.level.camX + VIRTUAL_WIDTH / 2
    self.y = self.playState.level.camY

    self.panel = Panel(self.x, self.y, VIRTUAL_WIDTH / 2, VIRTUAL_HEIGHT)
end

function FieldIndividualMenuState:update(dt)
    if love.keyboard.wasPressed('backspace') then
        gStateStack:pop()
    elseif love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then       
        if self.select.currentSelection == 1 then
            gStateStack:push(FieldUpgradeStatsMenuState(self.playState, self.party[self.charPosition]))
        elseif self.select.currentSelection == 2 then
            gStateStack:push(FieldPartySwitchMenuState(self.playState, self.charPosition))
        else
            gStateStack:pop()
        end
    end

    self.select:update(dt)
end

function FieldIndividualMenuState:render()
    self.panel:render()

    love.graphics.setColor(0, 0, 0, 255)
    love.graphics.setFont(gFonts['small'])
    love.graphics.print(self.char.name, self.x + VIRTUAL_WIDTH / 4 - 8, self.y + 16)

    local addX, addY = 16, 16
    -- print char stats
    love.graphics.print('HP: ' .. self.char.currentHP .. '/' .. self.char.HP, self.x + addX, self.y + 48)
    love.graphics.print('Attack: ' .. self.char.attack, self.x + addX, self.y + 64)
    love.graphics.print('Defense: ' .. self.char.defense, self.x + addX, self.y + 80)
    love.graphics.print('Speed: ' .. self.char.speed, self.x + addX, self.y + 96)
    love.graphics.print('Exp: ' .. self.char.currentExp .. '/' .. self.char.expToLevel, self.x + addX, self.y + 112)
    love.graphics.print('Stats Upgrade Points: '.. self.char.levelUpPoints, self.x + addX, self.y + 144)

    local y = self.y + 176

    for k, item in pairs(self.items) do
        if k == self.select.currentSelection then
            love.graphics.setColor(255, 255, 255, 255)
        else
            love.graphics.setColor(0, 0, 0, 255)
        end
        love.graphics.print(item, self.x + addX, y)
        y = y + addY
    end

    -- reset color
    love.graphics.setColor(255, 255, 255, 255)
end
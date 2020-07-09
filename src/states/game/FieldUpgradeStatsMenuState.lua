FieldUpgradeStatsMenuState = Class{__includes = BaseState}

function FieldUpgradeStatsMenuState:init(playState, char)
    self.playState = playState
    self.char = char

    -- how much to add 
    self.addHP = 0
    self.addAttack = 0
    self.addDefense = 0
    self.addSpeed = 0

    self.party = self.playState.level.player.party.party

    self.items = {self.addHP, self.addAttack, self.addDefense, self.addSpeed}
    self.stats = {'hp', 'attack', 'defense', 'speed'}
    self.displayStats = {'HP', 'Attack', 'Defense', 'Speed'}

    self.select = Selector{
        items = self.items
    }

    self.x = self.playState.level.camX + VIRTUAL_WIDTH / 2
    self.y = self.playState.level.camY

    self.panel = Panel(self.x, self.y, VIRTUAL_WIDTH / 2, VIRTUAL_HEIGHT)
end

function FieldUpgradeStatsMenuState:update(dt)
    if love.keyboard.wasPressed('backspace') then
        gStateStack:pop()
    elseif love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then       
        for k, stat in pairs(self.stats) do
            self.char:increaseStat(stat, self.items[k])
            self.items[k] = 0
        end
    elseif love.keyboard.wasPressed('left') then
        if not (self.items[self.select.currentSelection] == 0) then
            self.items[self.select.currentSelection] = self.items[self.select.currentSelection] - 1
            self.char.levelUpPoints = self.char.levelUpPoints + 1
        end
    elseif love.keyboard.wasPressed('right') then
        if not (self.char.levelUpPoints <= 0) then
            self.items[self.select.currentSelection] = self.items[self.select.currentSelection] + 1
            self.char.levelUpPoints = self.char.levelUpPoints - 1
        end
    end

    self.select:update(dt)
end

function FieldUpgradeStatsMenuState:render()
    self.panel:render()

    local addX, addY = 16, 16

    love.graphics.setColor(0, 0, 0, 255)
    love.graphics.setFont(gFonts['small'])
    love.graphics.print(self.char.name, self.x + VIRTUAL_WIDTH / 4 - 8, self.y + 16)

    love.graphics.print('Stats Upgrade Points: '.. self.char.levelUpPoints, self.x + addX, self.y + 48)

    local y = self.y + 80

    for k, item in pairs(self.items) do
        if k == self.select.currentSelection then
            love.graphics.setColor(255, 255, 255, 255)
        else
            love.graphics.setColor(0, 0, 0, 255)
        end
        love.graphics.print(self.stats[k] .. ':  <  ' .. item .. '  >', self.x + addX, y)
        y = y + addY
    end

    -- reset color
    love.graphics.setColor(255, 255, 255, 255)
end
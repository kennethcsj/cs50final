BattleItemSelectState = Class{__includes = BaseState}

function BattleItemSelectState:init(battleState, itemNum)
    self.battleState = battleState
    self.itemNum = itemNum

    self.player = self.battleState.player
    self.party = self.battleState.player.party.party
    self.alive = {}

    for k, char in pairs(self.party) do
        if not char.isDead then
            table.insert(self.alive, k)
        end
    end

    self.currentSelection = 1
end

function BattleItemSelectState:update(dt)
    for k, char in pairs(self.party) do
        char:update(dt)
    end

    for k, char in pairs(self.battleState.enemyParty) do
        char:update(dt)
    end

    if love.keyboard.wasPressed('up') then
        if self.currentSelection == 1 then
            self.currentSelection = #self.alive
        else
            self.currentSelection = self.currentSelection - 1
        end
    elseif love.keyboard.wasPressed('down') then
        if self.currentSelection == #self.alive then
            self.currentSelection = 1
        else
            self.currentSelection = self.currentSelection + 1
        end
    elseif self.party[self.currentSelection].currentHP < self.party[self.currentSelection].HP and (love.keyboard.wasPressed('return') or love.keyboard.wasPressed('enter')) then
        self.player.items[self.itemNum]:use(self.party[self.currentSelection])

        if self.player.items[self.itemNum].count > 1 then
            self.player.items[self.itemNum].count = self.player.items[self.itemNum].count - 1
        else
            table.remove(self.player.items, self.itemNum)
        end

        Timer.tween(0.5, {
            [self.party[self.currentSelection].healthBar] = {value = self.party[self.currentSelection].currentHP}
        }):finish(function()
            gStateStack:pop()
            gStateStack:pop()
        end)
    elseif love.keyboard.wasPressed('backspace') then
        gStateStack:pop()
    end
end

function BattleItemSelectState:render()
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.draw(gTextures['cursor'], self.party[self.alive[self.currentSelection]].currentScreenX - 8, self.party[self.alive[self.currentSelection]].currentScreenY)
end

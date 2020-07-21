BattleItemState = Class{__includes = BaseState}

function BattleItemState:init(battleState)
    self.battleState = battleState
    self.player = self.battleState.player

    self.items = self.player.items

    self.select = Selector {
        items = self.items
    }

    self.x = self.battleState.camX
    self.y = self.battleState.camY

    self.bottomPanel = Panel(self.x, self.y + VIRTUAL_HEIGHT - 64, VIRTUAL_WIDTH * 3 / 4, 64)

    -- use to create scrollable
    self.displayFirstItem = 1
    self.displayLastItem = 4
end

function BattleItemState:update(dt)
    if love.keyboard.wasPressed('backspace') then
        gStateStack:pop()
    elseif love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateStack:push(BattleItemSelectState(self.battleState, self.select.currentSelection))
    end

    self.select:update(dt)

    if self.select.currentSelection > self.displayLastItem then
        self.displayFirstItem = self.displayFirstItem + self.select.currentSelection - self.displayLastItem
        self.displayLastItem = self.select.currentSelection
    elseif self.select.currentSelection < self.displayFirstItem then
        self.displayLastItem = self.displayLastItem - (self.displayFirstItem - self.select.currentSelection)
        self.displayFirstItem = self.select.currentSelection
    end

    for k, char in pairs(self.player.party.party) do
        char:update(dt)
    end

    for k, char in pairs(self.battleState.enemyParty.party.party) do
        char:update(dt)
    end
end

function BattleItemState:render()
    self.bottomPanel:render()

    for k, item in pairs(self.items) do
        item.isSelected = (k == self.select.currentSelection) and true or false

        if k >= self.displayFirstItem and k <= self.displayLastItem then
            item.x = self.x + VIRTUAL_WIDTH / 4
            item.y = self.y + VIRTUAL_HEIGHT - 64 + (k - self.displayFirstItem) * 16
            item:render()
        end
    end
end
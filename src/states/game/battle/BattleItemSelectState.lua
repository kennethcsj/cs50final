--[[
    GD50

    BattleItemSelectState Class
    Selects Char to use on
]]

BattleItemSelectState = Class{__includes = BaseState}

function BattleItemSelectState:init(battleState, itemNum)
    self.battleState = battleState
    self.itemNum = itemNum

    self.player = self.battleState.player
    self.playerParty = self.battleState.playerParty
    self.playerAlive = {}

    -- obtain the player's alive char
    for k, char in pairs(self.playerParty) do
        if not char.isDead then
            table.insert(self.playerAlive, k)
        end
    end

    -- a selector for player alive table. retrieve current selection
    self.select = Selector{
        items = self.playerAlive
    }
end

function BattleItemSelectState:update(dt)
    for k, char in pairs(self.playerParty) do
        char:update(dt)
    end

    for k, char in pairs(self.battleState.enemyParty) do
        char:update(dt)
    end

    self.select:update(dt)

    -- allows the usage of the item only when player hp is not at max
    if self.playerParty[self.select.currentSelection].currentHP < self.playerParty[self.select.currentSelection].HP and (love.keyboard.wasPressed('return') or love.keyboard.wasPressed('enter')) then
        -- use item function reduce the item count by one and execute it
        self.player.items[self.itemNum]:use(self.playerParty[self.select.currentSelection])

        -- remove item from list if count is 0
        if (self.player.items[self.itemNum].count <= 0) then
            table.remove(self.player.items, self.itemNum)
        end

        -- increase the healthbar of the player
        Timer.tween(0.5, {
            [self.playerParty[self.select.currentSelection].healthBar] = {value = self.playerParty[self.select.currentSelection].currentHP}
        }):finish(function()
            -- pops current and item state
            gStateStack:pop()
            gStateStack:pop()
        end)
    elseif love.keyboard.wasPressed('backspace') then
        gStateStack:pop()
    end
end

function BattleItemSelectState:render()
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.draw(gTextures['cursor'], self.playerParty[self.playerAlive[self.select.currentSelection]].currentScreenX - 8, self.playerParty[self.playerAlive[self.select.currentSelection]].currentScreenY)
end

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
    self.effectiveParty = {}

    self.type = self.player.items[self.itemNum].type
    self.stat = self.player.items[self.itemNum].stat

    if (self.type == 'recovery') then
        -- obtain the player's alive char
        for k, char in pairs(self.playerParty) do
            if not char.isDead then
                table.insert(self.effectiveParty, char)
            end
        end
    elseif (self.type == 'revival') then
        -- obtain the player's alive char
        for k, char in pairs(self.playerParty) do
            if char.isDead then
                table.insert(self.effectiveParty, char)
            end
        end
    end

    if (#self.effectiveParty > 0) then
        -- a selector for player alive table. retrieve current selection
        self.select = Selector{
            items = self.effectiveParty
        }
    end
end

function BattleItemSelectState:update(dt)
    for k, char in pairs(self.playerParty) do
        char:update(dt)
    end

    for k, char in pairs(self.battleState.enemyParty) do
        char:update(dt)
    end

    if (#self.effectiveParty > 0) then
        self.select:update(dt)
    else
        gStateStack:push(MessagePopUpState('Unable to use item', self.battleState.camX, self.battleState.camY, 'center', function()
            gStateStack:pop() 
        end))
    end

    -- allows the usage of the item only when player hp is not at max
    if (love.keyboard.wasPressed('return') or love.keyboard.wasPressed('enter')) then
        if #self.effectiveParty > 0 then
            -- use item function reduce the item count by one and execute it
            if (self.player.items[self.itemNum]:use(self.effectiveParty[self.select.currentSelection])) then

                -- remove item from list if count is 0
                if (self.player.items[self.itemNum].count <= 0) then
                    table.remove(self.player.items, self.itemNum)
                end

                if (self.type == 'revival') then
                    Timer.tween(0.5, {
                        [self.effectiveParty[self.select.currentSelection]] = {r = 255, g = 255, b = 255},
                    })
                end

                if (self.stat == 'hp') then
                    -- increase the healthbar of the player
                    Timer.tween(0.5, {
                        [self.effectiveParty[self.select.currentSelection].healthBar] = {value = self.effectiveParty[self.select.currentSelection].currentHP}
                    }):finish(function()
                        -- pops current and item state
                        gStateStack:pop()
                        gStateStack:pop()
                    end)
                end
            else
                gStateStack:push(MessagePopUpState('Ineefective usage of item', self.battleState.camX, self.battleState.camY, 'center', function()
                    gStateStack:pop() 
                end))
            end
        end
    elseif love.keyboard.wasPressed('backspace') then
        gStateStack:pop()
    end
end

function BattleItemSelectState:render()
    love.graphics.setColor(255, 255, 255, 255)
    if (#self.effectiveParty > 0) then
        love.graphics.draw(gTextures['cursor'], self.effectiveParty[self.select.currentSelection].currentScreenX - 8, self.effectiveParty[self.select.currentSelection].currentScreenY)
    end
end

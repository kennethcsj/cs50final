--[[
    GD50

    BattleMenuState Class
]]


BattleMenuState = Class{__includes = BaseState}

function BattleMenuState:init(battleState, attackerNum)
    self.battleState = battleState
    self.attackerNum = attackerNum
    
    -- creates a menu at the bottom right
    self.battleMenu = Menu {
        x = self.battleState.playState.camX + VIRTUAL_WIDTH * 3 / 4,
        y = self.battleState.playState.camY + VIRTUAL_HEIGHT - 64,
        width = VIRTUAL_WIDTH / 4,
        height = 64,
        items = {
            {
                text = 'Fight',
                onSelect = function()
                    gStateStack:push(BattleEnemySelectState(self.battleState, self.attackerNum))
                end
            },
            {
                text = 'Items',
                onSelect = function()
                    gStateStack:push(BattleItemState(self.battleState))
                end
            }
        }
    }
end

function BattleMenuState:update(dt)
    self.battleMenu:update(dt)

    for k, char in pairs(self.battleState.playerParty) do
        char:update(dt)
    end

    for k, char in pairs(self.battleState.enemyParty) do
        char:update(dt)
    end
end

function BattleMenuState:render()
    love.graphics.draw(gTextures['red-arrow'], self.battleState.playerParty[self.attackerNum].currentScreenX, self.battleState.playerParty[self.attackerNum].currentScreenY - 24)
    love.graphics.setFont(gFonts['small'])
    love.graphics.print(self.battleState.playerParty[self.attackerNum].name, self.battleState.playState.camX + 24, self.battleState.playState.camY + VIRTUAL_HEIGHT - 56)
    
    -- display healthbar of current attacker
    local healthBar = self.battleState.playerParty[self.attackerNum].displayHealthBar
    healthBar:render()
    love.graphics.print(tostring(healthBar.value) .. ' HP / ' .. tostring(healthBar.max) .. ' HP', healthBar.x + healthBar.width/2 - 32, healthBar.y + 6)
    
    -- display exp bar of current attacker
    local expBar = self.battleState.playerParty[self.attackerNum].expBar
    expBar:render()
    love.graphics.print(tostring(expBar.value) .. ' EXP / ' .. tostring(expBar.max) .. ' EXP', expBar.x + expBar.width/2 - 32, expBar.y + 6)
    
    self.battleMenu:render()
end
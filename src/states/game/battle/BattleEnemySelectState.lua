--[[
    GD50

    BattleEnemySelectState Class
    Determines who attacks first, victory, defeat
]]

BattleEnemySelectState = Class{__includes = BaseState}

function BattleEnemySelectState:init(battleState, attackerNum)
    self.battleState = battleState
    self.attackerNum = attackerNum

    self.playerParty = self.battleState.playerParty
    self.enemyParty = self.battleState.enemyParty

    self.enemyAlive = {}

    -- obtain enemy char alive
    for k, char in pairs(self.enemyParty) do
        if not char.isDead then
            table.insert(self.enemyAlive, k)
        end
    end

    -- a selector for enemy alive table. retrieve current selection
    self.select = Selector{
        items = self.enemyAlive
    }
end

function BattleEnemySelectState:update(dt)
    for k, char in pairs(self.playerParty) do
        char:update(dt)
    end

    for k, char in pairs(self.enemyParty) do
        char:update(dt)
    end

    self.select:update(dt)

    if love.keyboard.wasPressed('return') or love.keyboard.wasPressed('enter') then
        gSounds['select']:stop()
        gSounds['select']:play()

        -- sets player char target on enter
        self.playerParty[self.attackerNum].targetSelected = true
        self.playerParty[self.attackerNum].target = self.enemyParty[self.enemyAlive[self.select.currentSelection]]
        
        -- checks if there are more player char to attack
        if #self.playerParty > self.attackerNum then
            -- pops the current state and the current attacker menustate
            gStateStack:pop()
            gStateStack:pop()

            -- push the next player's alive char battle menu 
            local playerAlive = false
            for k = (self.attackerNum + 1), #self.playerParty do
                if not self.playerParty[k].isDead then
                    playerAlive = true
                    gStateStack:push(BattleMenuState(self.battleState, k))
                    break
                end
            end

            -- if no more player alive, enter battle state
            if not playerAlive then
                gStateStack:push(BattleAttackState(self.battleState))
            end
        else
            -- no more player char to attack, pop current and menu state and push attack state
            gStateStack:pop()
            gStateStack:pop()
            gStateStack:push(BattleAttackState(self.battleState))
        end
    elseif love.keyboard.wasPressed('backspace') then
        gSounds['select']:stop()
        gSounds['select']:play()
        
        gStateStack:pop()
    end
end

function BattleEnemySelectState:render()
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.draw(gTextures['cursor'], self.enemyParty[self.enemyAlive[self.select.currentSelection]].currentScreenX - 8, self.enemyParty[self.enemyAlive[self.select.currentSelection]].currentScreenY)
end

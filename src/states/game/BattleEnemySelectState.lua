BattleEnemySelectState = Class{__includes = BaseState}

function BattleEnemySelectState:init(battleState, attackerNum)
    self.battleState = battleState
    self.attackerNum = attackerNum

    self.enemyParty = self.battleState.enemyParty
    self.party = self.enemyParty

    self.alive = {}

    for k, char in pairs(self.party) do
        if not char.isDead then
            table.insert(self.alive, k)
        end
    end

    self.currentSelection = 1
end

function BattleEnemySelectState:update(dt)
    for k, char in pairs(self.battleState.player.party.party) do
        char:update(dt)
    end

    for k, char in pairs(self.party) do
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
    elseif love.keyboard.wasPressed('return') or love.keyboard.wasPressed('enter') then
        self.battleState.player.party.party[self.attackerNum].targetSelected = true
        self.battleState.player.party.party[self.attackerNum].target = self.party[self.alive[self.currentSelection]]
        
        if #self.battleState.player.party.party > self.attackerNum then
            gStateStack:pop()
            gStateStack:pop()
            local playerAlive = false
            for k = (self.attackerNum + 1), #self.battleState.player.party.party do
                if not self.battleState.player.party.party[k].isDead then
                    playerAlive = true
                    gStateStack:push(BattleMenuState(self.battleState, k))
                    break
                end
            end
            if not playerAlive then
                gStateStack:push(BattleAttackState(self.battleState))
            end
        else
            gStateStack:pop()
            gStateStack:pop()
            gStateStack:push(BattleAttackState(self.battleState))
        end
    elseif love.keyboard.wasPressed('backspace') then
        gStateStack:pop()
    end
end

function BattleEnemySelectState:render()
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.draw(gTextures['cursor'], self.party[self.alive[self.currentSelection]].currentScreenX - 8, self.party[self.alive[self.currentSelection]].currentScreenY)
end

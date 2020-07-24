--[[
    GD50

    BattleAttackState Class
    Determines who attacks first, victory, defeat
]]

BattleAttackState = Class{__includes = BaseState}

function BattleAttackState:init(battleState)
    self.battleState = battleState

    self.playerParty = self.battleState.player.party.party
    self.enemyParty = self.battleState.enemyParty

    self.total = #self.playerParty + #self.enemyParty

    -- store all char sorted by their speed
    self.charSpeeds = {}

    -- sort the speed of the parties
    self:sortSpeed()
end

function BattleAttackState:enter(params)
    -- obtains char in player party who is alive
    local alivePlayerParty = {}
    for k, char in pairs(self.playerParty) do
        if not char.isDead then
            table.insert(alivePlayerParty, char)
        end
    end

    -- assigns a random player party char as target for enemy party character
    for k, char in pairs(self.enemyParty) do
        if not char.targetSelected then
            char.targetSelected = true
            char.target = alivePlayerParty[math.random(#alivePlayerParty)]
        end
    end

    -- use to check if all alive characters have attacked
    local attackerNum = 1
    for k, char in pairs(self.charSpeeds) do
        if not char.isDead then
            attackerNum = k
            break
        end
    end
    self:attack(self.charSpeeds[attackerNum], self.charSpeeds[attackerNum].target, attackerNum)
end

function BattleAttackState:checkDeaths()
    -- checks number of enemy alive
    local numEnemyAlive = 0
    for k, char in pairs(self.enemyParty) do
        if char.currentHP <= 0 then
            -- drop enemy sprite down below the window
            Timer.tween(0.5, {
                [char] = {opacity = 0},
                [char.healthBar] = {opacity = 0}
            })
            char.isDead = true
        else
            char.isDead = false
            numEnemyAlive = numEnemyAlive + 1
        end
    end

    -- checks number of player alive
    local numPlayerAlive = 0
    for k, char in pairs(self.playerParty) do
        if char.currentHP <= 0 then
            char.isDead = true
        else
            char.isDead = false
            numPlayerAlive = numPlayerAlive + 1
        end
    end

    -- play victory or faint if entire player/enemy party is wipe
    if numEnemyAlive == 0 then
        self:victory()
        return true
    elseif numPlayerAlive == 0 then
        self:faint()
        return true
    end

    return false
end

function BattleAttackState:victory()
    -- sets the enemy in playstate to dead
    self.battleState.enemy.dead = true

    Timer.after(0.5, function()
        -- when finished, push a victory message
        gStateStack:push(BattleMessageState('Victory!', function()
            -- get exp amount
            local exp = 0

            for k, char in pairs(self.enemyParty) do
                exp = exp + char.expPerLvl * char.level
            end

            -- give exp to those alive
            local playerAlive = {}

            for k, char in pairs(self.playerParty) do
                if not char.isDead then
                    table.insert(playerAlive, k)
                end
            end

            local expPerChar = math.ceil(exp / #playerAlive)
            local idxAlive = 1

            self:pushExpMessage(playerAlive, idxAlive, expPerChar)
        end, true, self.battleState.camX, self.battleState.camY))
    end)
end

function BattleAttackState:faint()
    Timer.after(0.5, function()
        -- when finished, push a everyone dead message
        gStateStack:push(BattleMessageState('Your party has been killed!', function()
            self.battleState.player.dead = true

            -- restore player pokemon to full health
            for k, char in pairs(self.playerParty) do
                char.isDead = false
                char.currentHP = char.HP
            end

            -- pop off the battle attack state and back into the battle state
            gStateStack:pop()
        end, true, self.battleState.camX, self.battleState.camY))
    end)
    
end

function BattleAttackState:attack(attacker, defender, attackerNum)
    attacker.targetSelected = false

    local shiftX

    if defender.type == 'enemy' then
        shiftX = 4
    else
        shiftX = -4
    end

    -- checks if target is dead
    if defender.isDead then
        -- retarget a new opposing party
        if attacker.type == 'enemy' then
            for k, player in pairs(self.playerParty) do
                if not player.isDead then
                    defender = player
                    break
                end
            end
        elseif attacker.type == 'hero' then
            for k, enemy in pairs(self.enemyParty) do
                if not enemy.isDead then
                    defender = enemy
                    break
                end
            end
        end
    end

    -- if attacker is still alive
    if not attacker.isDead then
        
        -- first push a message on who's attacking
        gStateStack:push(BattleMessageState('Lvl. ' .. attacker.level .. ' ' .. attacker.name .. ' attacks ' .. defender.name .. '!',
            function() end, false, self.battleState.camX, self.battleState.camY))

        Timer.after(0.5, function()
            -- shrink the defender's health bar over half a second, doing at least 1 dmg
            local dmg = math.max(1, attacker.attack - defender.defense)

            -- animation to show who is attacking and receiving the attack
            Timer.tween(0.1, {
                [attacker] = {currentScreenY = attacker.currentScreenY - 4}
            })
            :finish(function()
                Timer.tween(0.1, {
                    [attacker] = {currentScreenY = attacker.currentScreenY + 4}
                })
                :finish(function()
                    Timer.tween(0.1, {
                        [defender] = {currentScreenX = defender.currentScreenX + shiftX}
                    })
                    :finish(function()
                        Timer.tween(0.1, {
                            [defender] = {currentScreenX = defender.currentScreenX - shiftX}
                        })
                        :finish(function()
                            -- end of above animation, apply damage to defender
                            Timer.tween(0.5, {
                                [defender.healthBar] = {value = defender.currentHP - dmg}
                            })
                            :finish(function()
                                -- pops away attack message
                                gStateStack:pop()

                                defender.currentHP = defender.currentHP - dmg
                                -- adjust the healthbar shown on the battle menu
                                if defender.type == 'hero' then
                                    defender.displayHealthBar.value = defender.currentHP
                                end

                                if self:checkDeaths() then
                                    gStateStack:pop()
                                    return
                                end
                                
                                -- checks if everyone has attacked that turn
                                attackerNum = attackerNum + 1
                                if attackerNum > #self.charSpeeds then
                                    -- remove the last attack state from the stack
                                    gStateStack:pop()

                                    -- checks the first alive player in the party to attack
                                    for k, char in pairs(self.playerParty) do
                                        if not char.isDead then
                                            gStateStack:push(BattleMenuState(self.battleState, k))
                                            break
                                        end
                                    end
                                    return
                                end

                                self:attack(self.charSpeeds[attackerNum], self.charSpeeds[attackerNum].target, attackerNum)
                            end)
                        end)
                    end)
                end)
            end)
        end)
    else
        -- checks if everyone has attacked that turn
        attackerNum = attackerNum + 1
        if attackerNum > #self.charSpeeds then
            -- remove the last attack state from the stack
            gStateStack:pop()
            for k, char in pairs(self.playerParty) do
                if not char.isDead then
                    gStateStack:push(BattleMenuState(self.battleState, k))
                    break
                end
            end
            return
        end

        self:attack(self.charSpeeds[attackerNum], self.charSpeeds[attackerNum].target, attackerNum)
    end
end

function BattleAttackState:sortSpeed()
    local allParty = {}

    for k, char in pairs(self.playerParty) do
        table.insert(allParty, char)
    end

    for k, char in pairs(self.enemyParty) do
        table.insert(allParty, char)
    end

    -- sorts according to the speed of the characters
    while #self.charSpeeds < self.total do
        local highest, entity, num = 0, nil

        for k, char in pairs(allParty) do
            if char.speed > highest then
                highest = char.speed
                num = k
                entity = char
            end
        end
        
        table.insert(self.charSpeeds, entity)
        table.remove(allParty, num)
    end
end

function BattleAttackState:pushExpMessage(playerAlive, idxAlive, expPerChar)
    local char = self.playerParty[playerAlive[idxAlive]]
    -- push character experience, maximum of 4 characters possible
    gStateStack:push(BattleMessageState(tostring(self.playerParty[playerAlive[idxAlive]].name) .. ' earned ' .. tostring(expPerChar) .. ' experience points!', function()
        
        char.currentExp = char.currentExp + expPerChar

        -- level up if we've gone over the needed amount
        if char.currentExp > char.expToLevel then

            -- set our exp to whatever the overlap is
            char.currentExp = char.currentExp - char.expToLevel
            self.HPIncrease, self.attackIncrease, self.defenseIncrease, self.speedIncrease = char:levelUp()

            gStateStack:push(BattleMessageState('Congratulations! ' .. tostring(self.playerParty[playerAlive[idxAlive]].name) .. ' Level Up!',
            function()
                gStateStack:push(BattleMessageState(tostring(self.playerParty[playerAlive[idxAlive]].name) .. ' gained ' .. tostring(LEVEL_UP_STATS_UPGRADE) .. ' stats points!',
                function()
                    if idxAlive < #playerAlive then
                        idxAlive = idxAlive + 1
                        self:pushExpMessage(playerAlive, idxAlive, expPerChar)
                    else
                        -- pop off the battle state and back into the field
                        self:fadeOutWhite()
                    end
                end, true, self.battleState.camX, self.battleState.camY))
            end, true, self.battleState.camX, self.battleState.camY))

        else
            if idxAlive < #playerAlive then
                idxAlive = idxAlive + 1
                self:pushExpMessage(playerAlive, idxAlive, expPerChar)
            else
                -- pop off the battle state and back into the field
                self:fadeOutWhite()
            end
            
        end
    end, true, self.battleState.camX, self.battleState.camY))
end

function BattleAttackState:fadeOutWhite()
    -- fade in
    gStateStack:push(FadeInState({
        r = 255, g = 255, b = 255
    }, 1, 
    function()
        
        -- pop off the battle state
        gStateStack:pop()
        gStateStack:push(FadeOutState({
            r = 255, g = 255, b = 255
        }, 1, function() end))
    end))
end

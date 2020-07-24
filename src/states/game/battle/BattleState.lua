BattleState = Class{__includes = BaseState}

function BattleState:init(playState, player, enemy, enemyLvl)
    self.playState = playState
    self.player = player
    self.enemy = enemy

    -- determines the level of the enemy
    self.enemyLvl = enemyLvl

    self.camX = self.playState.camX
    self.camY = self.playState.camY
    self:createBackGround()

    -- flag for when the battle can take input, set in the first update call
    self.battleStarted = false

    -- flag for when all players have attacked
    self.attacking = false

    self.bottomPanel = Panel(self.playState.camX, self.playState.camY + VIRTUAL_HEIGHT - 64, VIRTUAL_WIDTH, 64)

    -- player and enemy party
    self.playerParty = self.player.party.party
    self.enemyParty = self.enemy.party.party

    -- set a max of 3 enemy in a paryt. Only 1 boss
    local numEnemies = math.random(3)
    if (self.enemy.type == 'boss') then
        numEnemies = 1
    end

    for x = 1, numEnemies do
        table.insert(self.enemyParty, Character(ENEMY_DEFS[self.enemy.type], enemyLvl))
    end
    
    for k, char in pairs(self.playerParty) do
        -- position of the char in battle state
        local x, y = math.floor(self.playState.camX + 96), math.floor(self.playState.camY + 96 - (24 * (#self.playerParty - k)))
        char.currentScreenX = x
        char.currentScreenY = y

        -- healthbar above player in battle state
        char.healthBar = ProgressBar {
            x = self.playState.camX + 80,
            y = self.playState.camY + 88 - (24 * (#self.playerParty - k)),
            width = 48,
            height = 3,
            color = {r = 189, g = 32, b = 32},
            value = char.currentHP,
            max = char.HP
        }

        -- healthbar for player in battle menu
        char.displayHealthBar = ProgressBar {
            x = self.camX + 24,
            y = self.camY + VIRTUAL_HEIGHT - 40,
            width = VIRTUAL_WIDTH * 3 / 4 - 48,
            height = 5,
            color = {r = 189, g = 32, b = 32},
            value = char.currentHP,
            max = char.HP
        }

        -- exp bar for player
        char.expBar = ProgressBar {
            x = self.camX + 24,
            y = self.camY + VIRTUAL_HEIGHT - 24,
            width = VIRTUAL_WIDTH * 3 / 4 - 48,
            height = 5,
            color = {r = 32, g = 32, b = 189},
            value = char.currentExp,
            max = char.expToLevel
        }
    end


    for k, char in pairs(self.enemyParty) do
        -- position of each enemy char in battle state
        local x, y = math.floor(self.playState.camX + VIRTUAL_WIDTH - 96), math.floor(self.playState.camY + 96 - (24 * (#self.enemyParty - k)))        
        char.currentScreenX = x
        char.currentScreenY = y
        
        -- healthbar above enemy char
        char.healthBar = ProgressBar {
            x = self.playState.camX + VIRTUAL_WIDTH - 104,
            y = self.playState.camY + 88 - (24 * (#self.enemyParty - k)),
            width = 48,
            height = 3,
            color = {r = 189, g = 32, b = 32},
            value = char.currentHP,
            max = char.HP
        }
    end

    -- set player to face right
    for k, char in pairs(self.playerParty) do
        char:changeAnimation('idle-right')
    end

    -- set enemy to face left
    for k, char in pairs(self.enemyParty) do
        char:changeAnimation('idle-left')
    end

end

function BattleState:enter(params)
    
end

function BattleState:exit()
    -- gSounds['battle-music']:stop()
    -- gSounds['field-music']:play()
end

function BattleState:update(dt)
    -- this will trigger the first time this state is actively updating on the stack
    if not self.battleStarted then
        self.battleStarted = true

        -- push the first alive player char menu
        for k, char in pairs(self.playerParty) do
            if not char.isDead then
                gStateStack:push(BattleMenuState(self, 1))
                break
            end
        end
    else
        -- updates the animations for player and enemy
        for k, char in pairs(self.playerParty) do
            char:update(dt)
        end
    
        for k, char in pairs(self.enemyParty) do
            char:update(dt)
        end
    end
end

function BattleState:render()
    self.baseLayer:render()
    self.bottomPanel:render()

    for k, char in pairs(self.playerParty) do
        char:render()
        char.healthBar:render()
    end

    for k, char in pairs(self.enemyParty) do
        char:render()
        char.healthBar:render()
    end
end

function BattleState:createBackGround()
    local tileWidth, tileHeight = 50, 50
    self.baseLayer = TileMap(tileWidth, tileHeight)

    -- fill the base tiles table with random grass IDs
    for y = 1, tileHeight do
        table.insert(self.baseLayer.tiles, {})

        for x = 1, tileWidth do
            local id = TILE_IDS['grass'][math.random(#TILE_IDS['grass'])]

            table.insert(self.baseLayer.tiles[y], Tile(x, y, id))
        end
    end
end
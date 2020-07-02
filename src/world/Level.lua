--[[
    GD50
    Pokemon

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

Level = Class{}

function Level:init(def)
    self.camX = 0
    self.camY = 0

    self.tileWidth = 30
    self.tileHeight = 30

    self.character = def.character

    self.baseLayer = TileMap(self.tileWidth, self.tileHeight)
    self.grassLayer = TileMap(self.tileWidth, self.tileHeight)
    self.halfGrassLayer = TileMap(self.tileWidth, self.tileHeight)

    self.entities = {}

    self:createMaps()

    self.player = Player {
        animations = ENTITY_DEFS[self.character].animations,
        mapX = 10,
        mapY = 10,
        width = 16,
        height = 16,
        type = 'player',
    }

    self.player.stateMachine = StateMachine {
        ['walk'] = function() return PlayerWalkState(self.player, self) end,
        ['idle'] = function() return PlayerIdleState(self.player) end
    }
    self.player.stateMachine:change('idle')
end

function Level:createMaps()

    -- fill the base tiles table with random grass IDs
    for y = 1, self.tileHeight do
        table.insert(self.baseLayer.tiles, {})

        for x = 1, self.tileWidth do
            local id = TILE_IDS['grass'][math.random(#TILE_IDS['grass'])]

            table.insert(self.baseLayer.tiles[y], Tile(x, y, id))
        end
    end

    -- place tall grass in the tall grass layer
    for y = 1, self.tileHeight do
        table.insert(self.grassLayer.tiles, {})
        table.insert(self.halfGrassLayer.tiles, {})

        for x = 1, self.tileWidth do
            local id = y > 10 and TILE_IDS['tall-grass'] or TILE_IDS['empty']

            table.insert(self.grassLayer.tiles[y], Tile(x, y, id))
        end
    end

    self:generateEntities()
end

function Level:update(dt)
    self.player:update(dt)

    for k, entity in pairs(self.entities) do
        entity:processAI({map = self}, dt)
    end

    for k, entity in pairs(self.entities) do
        if self.player:collides(entity) then
            entity.dead = true
        end
    end

    self:updateCamera()
end

function Level:render()
    -- translate the entire view of the scene to emulate a camera
    -- love.graphics.translate(math.floor(-self.player.x + VIRTUAL_WIDTH / 2), math.floor(-self.player.y + VIRTUAL_HEIGHT / 2))
    -- translate the entire view of the scene to emulate a camera
    love.graphics.translate(-math.floor(self.camX), -math.floor(self.camY))

    self.baseLayer:render()
    self.grassLayer:render()
    self.player:render()

    for k, entity in pairs(self.entities) do
        if not entity.dead then
            entity:render()
        end
    end
    
end

function Level:generateEntities()
    local type = 'bat'

    table.insert(self.entities, Entity {
        animations = ENTITY_DEFS[type].animations,

        -- ensure X and Y are within bounds of the map
        mapX = 15,
        mapY = 15,
        
        width = 16,
        height = 16,
    })

    self.entities[1].stateMachine = StateMachine {
        ['walk'] = function() return EntityWalkState(self.entities[1], self) end,
        ['idle'] = function() return EntityIdleState(self.entities[1]) end
    }

    self.entities[1]:changeState('walk')
end

function Level:updateCamera()
    -- clamp movement of the camera's X between 0 and the map bounds - virtual width,
    -- setting it half the screen to the left of the player so they are in the center
    self.camX = math.max(0,
        math.min(TILE_SIZE * self.tileWidth - VIRTUAL_WIDTH,
        self.player.x - (VIRTUAL_WIDTH / 2 - 8)))

    self.camY = math.max(0,
        math.min(TILE_SIZE * self.tileHeight - VIRTUAL_HEIGHT,
        self.player.y - (VIRTUAL_HEIGHT / 2 - 8)))
end
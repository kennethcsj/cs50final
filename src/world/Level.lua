--[[
    GD50
    Pokemon

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

Level = Class{}

function Level:init(playState, player)
    self.camX = 0
    self.camY = 0

    self.tileWidth = 30
    self.tileHeight = 30

    self.baseLayer = TileMap(self.tileWidth, self.tileHeight)
    self.grassLayer = TileMap(self.tileWidth, self.tileHeight)
    self.halfGrassLayer = TileMap(self.tileWidth, self.tileHeight)

    self.entities = {}

    self:createMaps()

    self.player = player
    self.playState = playState

    self.player.mapX = 1
    self.player.mapY = 18
    self.player:updateCoordinates()

    self:updateCamera()
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
        if self.player:collides(entity) and not self.player.dead and not entity.dead then
            -- first, push a fade in; when that's done, push a battle state and a fade
            -- out, which will fall back to the battle state once it pushes itself off
            gStateStack:push(
                FadeInState({
                    r = 255, g = 255, b = 255,
                }, 1, 
                function()
                    gStateStack:push(BattleState(self, self.player, entity))
                    gStateStack:push(FadeOutState({
                        r = 255, g = 255, b = 255,
                    }, 1,
                
                    function()
                        -- nothing to do or push here once the fade out is done
                    end), self.camX-4, self.camY-4)
                end, self.camX-4, self.camY-4)
            )
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

    local mapPositionX, mapPositionY = {10, 12}, {10, 12}

    for k, value in pairs(mapPositionX) do
        table.insert(self.entities, Entity {
            type = type,
            animations = ENTITY_DEFS[type].animations,

            -- ensure X and Y are within bounds of the map
            mapX = mapPositionX[k],
            mapY = mapPositionY[k],
            
            width = 16,
            height = 16,
        })
    end

    for k, entity in pairs(self.entities) do
        entity.stateMachine = StateMachine {
            ['walk'] = function() return EntityWalkState(entity, self) end,
            ['idle'] = function() return EntityIdleState(entity) end
        }

        entity:changeState('walk')
    end
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
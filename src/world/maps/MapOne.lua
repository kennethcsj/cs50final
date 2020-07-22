MapOne = Class{}

function MapOne:init(playState, player)
    self.camX = 0
    self.camY = 0

    self.tileWidth = 30
    self.tileHeight = 30

    self.layers = {}
    self.entities = {}
    self.objects = {}
    self.walkableTiles = {}

    self:initMap()
    self:createMap()
    self:generateEntities()

    self.player = player
    self.playState = playState

    self.player.stateMachine = StateMachine {
        ['walk'] = function() return PlayerWalkState(self.player, self) end,
        ['idle'] = function() return PlayerIdleState(self.player) end
    }

    self.player.stateMachine:change('idle')

    if self.player.direction == 'up' then
        self.player.mapY = self.tileHeight
    elseif self.player.direction == 'left' then
        self.player.mapX = self.tileWidth
        self.player.mapY = 18
    elseif self.player.direction == 'right' then
        self.player.mapX = 1
        self.player.mapY = 18
    else
        self.player.mapY = 1
    end
    self.player:updateCoordinates()

    self:updateCamera()
end

function MapOne:update(dt)
    self.player:update(dt)

    for k, entity in pairs(self.entities) do
        entity:processAI({map = self}, dt)
        entity:update(dt)
    end

    if love.keyboard.isDown('right') and (self.player.mapX == self.tileWidth) then
        gStateStack:push(FadeInState({
            r = 0, g = 0, b = 0
        }, 1,
        function()            
            self.playState.level = MapThree(self.playState, self.player)
            gStateStack:push(FadeOutState({
                r = 0, g = 0, b = 0
            }, 1,
            function() end))
        end))
    elseif love.keyboard.isDown('up') and (self.player.mapY == 1) then
        gStateStack:push(FadeInState({
            r = 0, g = 0, b = 0
        }, 1,
        function()            
            self.playState.level = MapTwo(self.playState, self.player)
            gStateStack:push(FadeOutState({
                r = 0, g = 0, b = 0
            }, 1,
            function() end))
        end))
    elseif love.keyboard.isDown('left') and (self.player.mapX == 1) then
        gStateStack:push(FadeInState({
            r = 0, g = 0, b = 0
        }, 1,
        function()            
            self.playState.level = MapHome(self.playState, self.player)
            gStateStack:push(FadeOutState({
                r = 0, g = 0, b = 0
            }, 1,
            function() end))
        end))
    end

    for k, entity in pairs(self.entities) do
        if entity.collide and not self.player.dead and not entity.dead then
            entity.collide = false
            -- first, push a fade in; when that's done, push a battle state and a fade
            -- out, which will fall back to the battle state once it pushes itself off
            gStateStack:push(
                FadeInState({
                    r = 255, g = 255, b = 255,
                }, 1, 
                function()
                    gStateStack:push(BattleState(self, self.player, entity, 1))
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

function MapOne:render()
    -- translate the entire view of the scene to emulate a camera
    love.graphics.translate(-math.floor(self.camX), -math.floor(self.camY))

    for k, layer in pairs(self.layers) do
        layer:render()
    end

    for y = 1, self.tileHeight do
        for x = 1, self.tileWidth do
            if not self.walkableTiles[y][x] then
                love.graphics.setColor(255, 0, 0, 100)
                love.graphics.rectangle('fill', (x - 1) * 16, (y - 1) * 16, 16, 16)
            end
        end
    end
    love.graphics.setColor(255, 255, 255, 255)

    for k, entity in pairs(self.entities) do
        if not entity.dead then
            entity:render()
        end
    end

    self.player:render()
end

function MapOne:createMap()
    for y = 1, self.tileHeight do
        table.insert(self.walkableTiles, {})

        for x = 1, self.tileWidth do
            table.insert(self.walkableTiles[y], true)
        end
    end

    for k, layer in pairs(self.layers) do
        for y = 1, self.tileHeight do
            table.insert(layer.tiles, {})

            for x = 1, self.tileWidth do
                local id = ((y >= layer.startY) and (y <= layer.endY) and (x >= layer.startX) and (x <= layer.endX)) and layer.id or TILE_IDS['empty']

                table.insert(layer.tiles[y], Tile(x, y, id))

                local walkable = false
                for k, tile_id in pairs(WALKABLE_TILE_IDS) do
                    if (id == TILE_IDS['empty']) or (id == tile_id) then
                        walkable = true
                        break
                    end
                end

                if not walkable then
                    self.walkableTiles[y][x] = false
                end
            end
        end
    end
end

function MapOne:generateEntities()
    local type = 'bat'

    local mapPositionX, mapPositionY = {19, 10, 25}, {15, 18, 17}

    for k, value in pairs(mapPositionX) do
        table.insert(self.entities, Enemy {
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

function MapOne:updateCamera()
    -- clamp movement of the camera's X between 0 and the map bounds - virtual width,
    -- setting it half the screen to the left of the player so they are in the center
    self.camX = math.max(0,
        math.min(TILE_SIZE * self.tileWidth - VIRTUAL_WIDTH,
        self.player.x - (VIRTUAL_WIDTH / 2 - 8)))

    self.camY = math.max(0,
        math.min(TILE_SIZE * self.tileHeight - VIRTUAL_HEIGHT,
        self.player.y - (VIRTUAL_HEIGHT / 2 - 8)))
end

function MapOne:initMap()
    table.insert(self.layers, TileMap(self.tileWidth, self.tileHeight, 1, 1, self.tileWidth, self.tileHeight, TILE_IDS['sand'][math.random(#TILE_IDS['sand'])]))
    table.insert(self.layers, TileMap(self.tileWidth, self.tileHeight, 1, 1, 15, 15, TILE_IDS['grass'][math.random(#TILE_IDS['grass'])]))
    table.insert(self.layers, TileMap(self.tileWidth, self.tileHeight, 20, 1, 30, 15, TILE_IDS['grass'][math.random(#TILE_IDS['grass'])]))
    table.insert(self.layers, TileMap(self.tileWidth, self.tileHeight, 1, 20, self.tileWidth, self.tileHeight, TILE_IDS['grass'][math.random(#TILE_IDS['grass'])]))
end
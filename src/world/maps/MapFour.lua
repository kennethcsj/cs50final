--[[
    GD50
    
    MapFour Class
]]

MapFour = Class{}

function MapFour:init(playState, player)
    self.camX = 0
    self.camY = 0

    self.tileWidth = 30
    self.tileHeight = 30

    self.layers = {}
    self.entities = {}
    self.objects = {}
    
    -- determines which tile is walkable
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

    -- sets the coordinate of the player on entering map
    if self.player.direction == 'up' then
        self.player.mapY = self.tileHeight
    elseif self.player.direction == 'left' then
        self.player.mapX = self.tileWidth
    elseif self.player.direction == 'right' then
        self.player.mapX = 1
        self.player.mapY = 18
    else
        self.player.mapY = 1
    end

    self.player:updateCoordinates()

    self:updateCamera()
end

function MapFour:update(dt)
    self.player:update(dt)

    -- restart the game if all player party is dead
    if self.player.dead then
        self.playState.restart = true
        self.player.dead = false

        gStateStack:push(DialogueState("" .. 
            "Your party remains have been brought back to the portal to be revived." ..
            " Do not give up just yet!", self.camX, self.camY, 'center', function()
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
        ))
    end

    -- if boss is dead, end the game
    for k, entity in pairs(self.entities) do
        entity:update(dt)
        if (entity.type == 'boss') and entity.dead then
            self:complete()
        end
    end

    if love.keyboard.isDown('left') and (self.player.mapX == 1) then
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
    elseif (love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return')) and (self.player.mapY == 11) then
        -- first, push a fade in; when that's done, push a battle state and a fade
        -- out, which will fall back to the battle state once it pushes itself off
        gStateStack:push(DialogueState("" .. 
            "Bat Boss: Yuo won't be able to defeat me!" ..
            "", self.camX, self.camY, 'center', function()
                gStateStack:push(
                    FadeInState({
                        r = 255, g = 255, b = 255,
                    }, 1, 
                    function()
                        gStateStack:push(BattleState(self, self.player, self.entities[#self.entities], 1))
                        gStateStack:push(FadeOutState({
                            r = 255, g = 255, b = 255,
                        }, 1,
                    
                        function()
                            -- nothing to do or push here once the fade out is done
                        end), self.camX-4, self.camY-4)
                    end, self.camX-4, self.camY-4)
                )
            end
        ))
    end

    self:updateCamera()
end

function MapFour:render()
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

function MapFour:createMap()
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

function MapFour:initMap()
    table.insert(self.layers, TileMap(self.tileWidth, self.tileHeight, 1, 1, self.tileWidth, self.tileHeight, TILE_IDS['sand'][math.random(#TILE_IDS['sand'])]))
    table.insert(self.layers, TileMap(self.tileWidth, self.tileHeight, 1, 1, 15, 15, TILE_IDS['grass'][math.random(#TILE_IDS['grass'])]))
    table.insert(self.layers, TileMap(self.tileWidth, self.tileHeight, 1, 1, self.tileWidth, 10, TILE_IDS['grass'][math.random(#TILE_IDS['grass'])]))
    table.insert(self.layers, TileMap(self.tileWidth, self.tileHeight, 19, 1, self.tileWidth, self.tileHeight, TILE_IDS['grass'][math.random(#TILE_IDS['grass'])]))
    table.insert(self.layers, TileMap(self.tileWidth, self.tileHeight, 1, 20, self.tileWidth, self.tileHeight, TILE_IDS['grass'][math.random(#TILE_IDS['grass'])]))
end

function MapFour:generateEntities()
    table.insert(self.entities, Enemy {
        type = 'boss',
        animations = ENTITY_DEFS['boss'].animations,

        -- ensure X and Y are within bounds of the map
        mapX = 16,
        mapY = 9,
        
        width = 48,
        height = 48,
    })

    for k, entity in pairs(self.entities) do
        entity.stateMachine = StateMachine {
            ['walk'] = function() return EntityWalkState(entity, self) end,
            ['idle'] = function() return EntityIdleState(entity) end
        }

        entity:changeState('walk')
    end
end

function MapFour:updateCamera()
    -- clamp movement of the camera's X between 0 and the map bounds - virtual width,
    -- setting it half the screen to the left of the player so they are in the center
    self.camX = math.max(0,
        math.min(TILE_SIZE * self.tileWidth - VIRTUAL_WIDTH,
        self.player.x - (VIRTUAL_WIDTH / 2 - 8)))

    self.camY = math.max(0,
        math.min(TILE_SIZE * self.tileHeight - VIRTUAL_HEIGHT,
        self.player.y - (VIRTUAL_HEIGHT / 2 - 8)))
end

function MapFour:complete()
    -- game end dialogue
    gStateStack:push(DialogueState("Well Done Chosen One! You have prevented the future from falling apart. " ..
        "The world thanks you for your help. " .. "It's time for you to go back. " .. "Good bye Chosen One!", self.camX, self.camY, 'left', function()
            gStateStack:push(
                FadeInState({
                    r = 255, g = 255, b = 255,
                }, 1, 
                function()
                    gStateStack:pop()

                    -- goes back to StartState
                    gStateStack:push(StartState())
                    gStateStack:push(FadeOutState({
                        r = 255, g = 255, b = 255,
                    }, 1,
                
                    function()
                        -- nothing to do or push here once the fade out is done
                    end), self.camX-4, self.camY-4)
                end, self.camX-4, self.camY-4)
            )       
            
        end
    ))
end
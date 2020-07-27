--[[
    GD50

    MapHome Class
]]

MapHome = Class{}

function MapHome:init(playState, player)
    gSounds['field-music']:stop()
    gSounds['town-music']:setVolume(0.3)
    gSounds['town-music']:setLooping(true)
    gSounds['town-music']:play()

    self.player = player
    self.playState = playState
    
    self.camX = 0
    self.camY = 0

    self.tileWidth = 30
    self.tileHeight = 30

    self.layers = {}
    -- use to determine if tile is walkable
    self.walkableTiles = {}

    self.entities = {}
    self.objects = {}

    self:initMap()
    self:createMap()
    self:generateObjects()

    self.player.stateMachine = StateMachine {
        ['walk'] = function() return PlayerWalkState(self.player, self) end,
        ['idle'] = function() return PlayerIdleState(self.player) end
    }

    self.player.stateMachine:change('idle')

    -- Sets the position of the player on entering the map
    if self.playState.restart or self.playState.firstEnter then
        self.playState.restart = false
        self.player.mapX = 15
        self.player.mapY = 13
        self.player.direction = 'down'
    else
        if self.player.direction == 'up' then
            self.player.mapY = self.tileHeight
        elseif self.player.direction == 'left' then
            self.player.mapX = self.tileWidth
            self.player.mapY = 19
        elseif self.player.direction == 'right' then
            self.player.mapX = 1
            self.player.mapY = 18
        else
            self.player.mapY = 1
        end
    end

    self.player:updateCoordinates()
    self:updateCamera()
end

function MapHome:update(dt)
    if self.playState.firstEnter then
        gStateStack:push(DialogueState("Welcome Chosen One! Press 'M' to open Menu. " ..
            "'Backspace' to return. 'Enter' to select/next. 'Esc' to exit game. 'H' to open Help dialouge. Fight On!", self.camX, self.camY, 'left', function()       
                self.playState.firstEnter = false
            end
        ))
    else
        self.player:update(dt)

        for k, entity in pairs(self.entities) do
            entity:update(dt)
        end

        for k, object in pairs(self.objects) do
            object:update(dt)
        end

        -- Enters the next map
        if love.keyboard.isDown('right') and (self.player.mapX == self.tileWidth) and (self.player.mapY == 18 or self.player.mapY == 19 or self.player.mapY == 20) then
            gStateStack:push(FadeInState({
                r = 0, g = 0, b = 0
            }, 1,
            function()
                gSounds['town-music']:stop()
                gSounds['field-music']:setVolume(0.3)
                gSounds['field-music']:setLooping(true)
                gSounds['field-music']:play()

                self.playState.level = MapOne(self.playState, self.player)
                gStateStack:push(FadeOutState({
                    r = 0, g = 0, b = 0
                }, 1,
                function() end))
            end))
        end

        self:updateCamera()
    end
end

function MapHome:render()
    -- translate the entire view of the scene to emulate a camera
    love.graphics.translate(-math.floor(self.camX), -math.floor(self.camY))

    for k, layer in pairs(self.layers) do
        layer:render()
    end

    for k, entity in pairs(self.entities) do
        if not entity.dead then
            entity:render()
        end
    end

    for k, object in pairs(self.objects) do
        object:render()
    end

    self.player:render()
end

function MapHome:createMap()
    -- creates the tiles for each tilemap
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
            end
        end
    end
end

function MapHome:initMap()
    -- creates the layout of the map
    table.insert(self.layers, TileMap(self.tileWidth, self.tileHeight, 1, 1, self.tileWidth, self.tileHeight, TILE_IDS['grass'][math.random(#TILE_IDS['grass'])]))
    table.insert(self.layers, TileMap(self.tileWidth, self.tileHeight, 27, 18, self.tileWidth, 20, TILE_IDS['sand'][math.random(#TILE_IDS['sand'])]))
end

function MapHome:generateObjects()
    -- generate portal with function
    table.insert(self.objects, Object(
        MAP_DEFS['portal'],
        14,
        12,
        15
    ))

    self.objects[#self.objects].onContact = function()
        gStateStack:push(MessageConfirmState('Recover Party??', self.camX, self.camY, 'center', function()
            for k, char in pairs(self.player.party.party) do
                char.currentHP = char.HP
            end

            -- pops the message
            gStateStack:pop()
            gStateStack:push(FadeInState({
                r = 0, g = 0, b = 0
            }, 1,
            function()
                gStateStack:push(FadeOutState({
                    r = 0, g = 0, b = 0
                }, 1,
                function()
                    gStateStack:push(MessagePopUpState('Your party has been fully healed!', self.camX, self.camY, 'center', function() end))
                end))
            end))
        end))
    end
end

function MapHome:updateCamera()
    -- clamp movement of the camera's X between 0 and the map bounds - virtual width,
    -- setting it half the screen to the left of the player so they are in the center
    self.camX = math.max(0,
        math.min(TILE_SIZE * self.tileWidth - VIRTUAL_WIDTH,
        self.player.x - (VIRTUAL_WIDTH / 2 - 8)))

    self.camY = math.max(0,
        math.min(TILE_SIZE * self.tileHeight - VIRTUAL_HEIGHT,
        self.player.y - (VIRTUAL_HEIGHT / 2 - 8)))
end

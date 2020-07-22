MapTwo = Class{}

function MapTwo:init(playState, player)
    self.camX = 0
    self.camY = 0

    self.tileWidth = 30
    self.tileHeight = 30

    self.layers = {}

    table.insert(self.layers, TileMap(self.tileWidth, self.tileHeight, 1, 1, self.tileWidth, self.tileHeight, TILE_IDS['sand'][math.random(#TILE_IDS['sand'])]))
    table.insert(self.layers, TileMap(self.tileWidth, self.tileHeight, 1, 1, self.tileWidth, 10, TILE_IDS['grass'][math.random(#TILE_IDS['grass'])]))
    table.insert(self.layers, TileMap(self.tileWidth, self.tileHeight, 20, 1, self.tileWidth, self.tileHeight, TILE_IDS['grass'][math.random(#TILE_IDS['grass'])]))
    table.insert(self.layers, TileMap(self.tileWidth, self.tileHeight, 1, 1, 15, self.tileHeight, TILE_IDS['grass'][math.random(#TILE_IDS['grass'])]))

    self.entities = {}
    self.objects = {}
    self.walkableTiles = {}

    self:createMap()
    self:generateObjects()
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
    elseif self.player.direction == 'right' then
        self.player.mapX = 1
    else
        self.player.mapY = 1
    end

    self.player:updateCoordinates()

    self:updateCamera()
end

function MapTwo:render()
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

    for k, object in pairs(self.objects) do
        object:render()
    end

    self.player:render()
end

function MapTwo:createMap()
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

function MapTwo:update(dt)
    self.player:update(dt)

    for k, entity in pairs(self.entities) do
        entity:processAI({map = self}, dt)
        entity:update(dt)
    end

    if love.keyboard.isDown('down') and (self.player.mapY == self.tileHeight) then
        gStateStack:push(FadeInState({
            r = 0, g = 0, b = 0
        }, 1,
        function()            
            self.playState.level = MapOne(self.playState, self.player)
            gStateStack:push(FadeOutState({
                r = 0, g = 0, b = 0
            }, 1,
            function() end))
        end))
    elseif love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        for k, object in pairs(self.objects) do
            if object.activation and not object.activated then
                if (self.player.direction == 'up') and (self.player.mapY == 11) and ((self.player.mapX == 17) or (self.player.mapX == 18)) then
                    object.onActivate()
                end
            end
        end
    end

    self:updateCamera()
end

function MapTwo:generateObjects()
    -- generate portal with function
    table.insert(self.objects, Object(
        MAP_DEFS['chest'],
        17,
        8
    ))

    self.objects[#self.objects].onActivate = function()
        local items = {}
        local count = 10
        local object = 'sushi'

        table.insert(items, Item(OBJECT_DEFS[object]))
        items[#items].count = count

        for k, item in pairs(self.player.items) do
            if (item.name == 'Sushi') then
                item.count = item.count + items[#items].count
                table.remove(items, #items)
                break
            end
        end

        if (#items > 0) then
            table.insert(self.player.items, items[#items])
        end

        gStateStack:push(MessagePopUpState('Obtained ' .. tostring(count) .. ' ' .. tostring(object) , self.camX, self.camY, 'center', function()
            self.objects[#self.objects].activated = true
            self.objects[#self.objects]:changeAnimation('open')
        end))
    end
end

function MapTwo:generateEntities()
    local type = 'bat'

    local mapPositionX, mapPositionY = {19, 10, 25}, {15, 18, 17}

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

function MapTwo:updateCamera()
    -- clamp movement of the camera's X between 0 and the map bounds - virtual width,
    -- setting it half the screen to the left of the player so they are in the center
    self.camX = math.max(0,
        math.min(TILE_SIZE * self.tileWidth - VIRTUAL_WIDTH,
        self.player.x - (VIRTUAL_WIDTH / 2 - 8)))

    self.camY = math.max(0,
        math.min(TILE_SIZE * self.tileHeight - VIRTUAL_HEIGHT,
        self.player.y - (VIRTUAL_HEIGHT / 2 - 8)))
end
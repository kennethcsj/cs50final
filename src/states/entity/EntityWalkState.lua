--[[
    GD50
    
    EntityWalkState Class
]]

EntityWalkState = Class{__includes = EntityBaseState}

function EntityWalkState:init(entity, level)
    self.entity = entity
    self.level = level
    
    self.canWalk = false

    -- used for AI control
    self.moveDuration = 0
    self.movementTimer = 0
end

function EntityWalkState:enter(params)
    self:attemptMove()
end

function EntityWalkState:attemptMove()
    self.entity:changeAnimation('walk-' .. tostring(self.entity.direction))

    local toX, toY = self.entity.mapX, self.entity.mapY

    if self.entity.direction == 'left' then
        toX = toX - 1
    elseif self.entity.direction == 'right' then
        toX = toX + 1
    elseif self.entity.direction == 'up' then
        toY = toY - 1
    else
        toY = toY + 1
    end

    -- break out if we try to move out of the map boundaries
    if toX < 1 or toX > self.level.tileWidth or toY < 1 or toY > self.level.tileHeight then
        self.entity:changeState('idle')
        self.entity:changeAnimation('idle-' .. tostring(self.entity.direction))
        return
    end

    -- break out if we try to move to an unwalkable tile
    if not self.level.walkableTiles[toY][toX] then
        self.entity:changeState('idle')
        self.entity:changeAnimation('idle-' .. tostring(self.entity.direction))
        return
    end

    -- entity collides with object
    for k, object in pairs(self.level.objects) do
        if (toX == object.collideX) and (toY == object.collideY) then
            if object.solid then
                -- only call function if entity is player
                if (self.entity.type == 'player') then
                    object:onCollide()
                end

                -- break out if object is solid
                self.entity:changeState('idle')
                self.entity:changeAnimation('idle-' .. tostring(self.entity.direction))
                return
            elseif object.consumable then
                -- only call function if entity is player
                if (self.entity.type == 'player') then
                    object:onConsume()
                else
                    -- break out if entity is enemy
                    self.entity:changeState('idle')
                    self.entity:changeAnimation('idle-' .. tostring(self.entity.direction))
                    return
                end
            elseif object.contactable then
                -- only call function if entity is player
                if (self.entity.type == 'player') then
                    object:onContact()
                end

                -- break out if object is contactable
                self.entity:changeState('idle')
                self.entity:changeAnimation('idle-' .. tostring(self.entity.direction))
                return 
            end
        end
    end

    -- entity collision with other entities
    for k, entity in pairs(self.level.entities) do
        if (toX == entity.mapX) and (toY == entity.mapY) and not entity.dead then
            self.entity:changeState('idle')
            self.entity:changeAnimation('idle-' .. tostring(self.entity.direction))
            
            -- allow battle when collide with entity
            if (self.entity.type == 'player') then
                entity.collide = true
            end
            return
        end
    end

    self.entity.mapY = toY
    self.entity.mapX = toX

    Timer.tween(0.2, {
        [self.entity] = {x = (toX - 1) * TILE_SIZE, y = (toY - 1) * TILE_SIZE - self.entity.height / 2}
    }):finish(function()
        if (self.entity.type == 'player') then
            if love.keyboard.isDown('left') then
                self.entity.direction = 'left'
                self.entity:changeState('walk')
            elseif love.keyboard.isDown('right') then
                self.entity.direction = 'right'
                self.entity:changeState('walk')
            elseif love.keyboard.isDown('up') then
                self.entity.direction = 'up'
                self.entity:changeState('walk')
            elseif love.keyboard.isDown('down') then
                self.entity.direction = 'down'
                self.entity:changeState('walk')
            else
                self.entity:changeState('idle')
            end
        end
    end)
end

function EntityWalkState:processAI(params, dt)
    local directions = {'left', 'right', 'up', 'down'}

    if self.moveDuration == 0 then
        
        -- set an initial move duration and direction
        self.moveDuration = math.random(2)
        self.entity.direction = directions[math.random(#directions)]
    elseif self.movementTimer > self.moveDuration then
        self.movementTimer = 0

        -- chance to go idle
        if math.random(2) == 1 then
            self.entity:changeState('idle')
        else
            self.moveDuration = math.random(2)
            self.entity.direction = directions[math.random(#directions)]
        end
    end

    self.movementTimer = self.movementTimer + dt
end
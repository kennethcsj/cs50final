--[[
    GD50

    Object Class
]]

Object = Class{}

function Object:init(def, mapX, mapY, collideX, collideY)
    self.mapX = mapX
    self.mapY = mapY

    -- x and y coordinates for callback
    self.collideX = collideX or mapX
    self.collideY = collideY or mapY

    -- whether it acts as an obstacle or not
    self.solid = def.solid

    -- whether it is consumable or not
    self.consumable = def.consumable

    -- whether it can be activate by pressing enter
    self.interactable = def.interactable
    self.interact = false

    -- whether it can be interact on contact
    self.contactable = def.contactable

    self.animations = self:createAnimations(def.animations)

    self.width = def.width
    self.height = def.height

    self.x = (self.mapX - 1) * TILE_SIZE

    -- halfway raised on the tile just to simulate height/perspective
    self.y = (self.mapY - 1) * TILE_SIZE - self.height / 2

    -- set animation to default
    self.currentAnimation = self.animations['default']

    -- default empty collision callback
    self.onCollide = function() end

    self.onConsume = function() end

    self.onInteract = function() end

    self.onContact = function() end
end

function Object:changeAnimation(name)
    self.currentAnimation = self.animations[name]
end

function Object:createAnimations(animations)
    local animationsReturned = {}

    for k, animationDef in pairs(animations) do
        animationsReturned[k] = Animation {
            texture = animationDef.texture or 'portal',
            frames = animationDef.frames,
            interval = animationDef.interval
        }
    end

    return animationsReturned
end

function Object:updateCoordinates()
    self.x = (self.mapX - 1) * TILE_SIZE

    -- halfway raised on the tile just to simulate height/perspective
    self.y = (self.mapY - 1) * TILE_SIZE - self.height / 2
end

function Object:collides(target)
    return not (self.x + self.width < target.x or self.x > target.x + target.width or
                self.y + self.height < target.y or self.y > target.y + target.height)
end

function Object:processAI(params, dt)
    self.stateMachine:processAI(params, dt)
end

function Object:update(dt)
    self.currentAnimation:update(dt)
end

function Object:render()
    love.graphics.draw(gTextures[self.currentAnimation.texture], gFrames[self.currentAnimation.texture][self.currentAnimation:getCurrentFrame()],
        math.floor(self.x), math.floor(self.y))
end
--[[
    GD50

    Item Class
]]

Item = Class{}

function Item:init(def)
    self.name = def.name
    self.type = def.type
    self.stat = def.stat
    self.effect = def.effect
    self.texture = def.texture
    self.frame = def.frame
    self.text = def.text

    self.x = nil
    self.y = nil

    -- number of items the entity has
    self.count = 1

    self.isSelected = false
end

-- can be extended
function Item:use(char)
    if (self.type == 'recovery') then
        if self.stat == 'hp' then
            if (char.currentHP < char.HP) then
                char.currentHP = math.min(char.HP, char.currentHP + self.effect)
            else
                return false
            end
        end
    elseif (self.type == 'revival') then
        if char.isDead then
            char.isDead = false
            if self.stat == 'hp' then
                char.currentHP = math.min(char.HP, char.currentHP + self.effect)
            end
        else
            return false
        end
    end

    -- deduct one when used
    self.count = self.count - 1

    return true
end

function Item:render()
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.draw(gTextures[self.texture], gFrames[self.texture][self.frame], self.x, self.y)
    love.graphics.setFont(gFonts['medium'])
    if self.isSelected then
        love.graphics.setColor(255, 255, 255, 255)
    else
        love.graphics.setColor(0, 0, 0, 255)
    end
    love.graphics.print(' x ' .. self.count, self.x + 16, self.y)
    love.graphics.setFont(gFonts['small'])
    love.graphics.print(self.text, self.x + 64, self.y + 4)
end
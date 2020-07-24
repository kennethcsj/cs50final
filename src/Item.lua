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
    self.text = def.text

    self.x = nil
    self.y = nil

    -- number of items the entity has
    self.count = 1

    self.isUsed = false
    self.isSelected = false
end

-- can be extended
function Item:use(char)
    -- deduct one when used
    self.count = self.count - 1
    
    if self.stat == 'hp' then
        char.currentHP = math.min(char.HP, char.currentHP + self.effect)
    end
end

function Item:render()
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.draw(gTextures[self.texture], self.x, self.y)
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
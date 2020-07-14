Item = Class{}

function Item:init(def)
    self.name = def.name
    self.type = def.type
    self.stat = def.stat
    self.effect = def.effect
    self.texture = def.texture

    self.x = nil
    self.y = nil

    self.count = 1

    self.isUsed = false
end

function Item:use(char)
    if self.stat == 'hp' then
        char.currentHP = math.min(char.HP, char.currentHP + self.effect)
    end
end

function Item:render()
    love.graphics.draw(gTextures[self.texture], self.x, self.y)
    love.graphics.setFont(gFonts['medium'])
    love.graphics.print(' x ' .. self.count, self.x + 32, self.y)
end
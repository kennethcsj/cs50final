--[[
    GD50

    Enemy Class
]]

Enemy = Class{__includes = Entity}

function Enemy:init(def)
    Entity.init(self, def)

    -- Enemy Party during Battle
    self.party = Party {
        party = {}
    }

    -- where player collided with enemy
    self.collide = false
end
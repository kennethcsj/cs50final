--[[
    GD50
    Pokemon

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

Player = Class{__includes = Entity}

function Player:init(def)
    Entity.init(self, def)

    self.party = Party {
        party = {
            Character(CHARACTER_DEFS[def.character], 1),
            Character(CHARACTER_DEFS['player-girl'], 1)
        }
    }
    
    self.items = {}

    for k = 1, 10 do
        table.insert(self.items, Item(OBJECT_DEFS['sushi']))
        self.items[k].count = k
    end
end

function Player:restart(def)
    self.mapX = def.mapX
    self.mapY = def.mapY

    self.x = (self.mapX - 1) * TILE_SIZE

    -- halfway raised on the tile just to simulate height/perspective
    self.y = (self.mapY - 1) * TILE_SIZE - self.height / 2

    self.currentAnimation = self.animations['idle-down']
end
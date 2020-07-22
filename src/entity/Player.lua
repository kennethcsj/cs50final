--[[
    GD50

    Player Class
]]

Player = Class{__includes = Entity}

function Player:init(def)
    Entity.init(self, def)

    -- Use to create a second party member
    local other = (def.character == 'player-boy') and 'player-girl' or 'player-boy'
    self.party = Party {
        party = {
            Character(CHARACTER_DEFS[def.character], 1),
            Character(CHARACTER_DEFS[other], 1)
        }
    }
    
    self.items = {}

    -- Starts with health recovery item
    table.insert(self.items, Item(OBJECT_DEFS['sushi']))
    self.items[#self.items].count = 5
end

function Player:restart(def)
    -- Restarts player to the define mapX and mapY
    self.mapX = def.mapX
    self.mapY = def.mapY

    self.x = (self.mapX - 1) * TILE_SIZE

    -- halfway raised on the tile just to simulate height/perspective
    self.y = (self.mapY - 1) * TILE_SIZE - self.height / 2

    self.currentAnimation = self.animations['idle-down']
end
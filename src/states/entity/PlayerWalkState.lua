--[[
    GD50
    
    PlayerWalkState Class
]]

PlayerWalkState = Class{__includes = EntityWalkState}

function PlayerWalkState:init(entity, level)
    EntityWalkState.init(self, entity, level)
end

function PlayerWalkState:enter()
    self:attemptMove()
end

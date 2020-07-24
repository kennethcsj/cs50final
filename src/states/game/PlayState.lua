--[[
    GD50
    
    PlayState Class
]]

PlayState = Class{__includes = BaseState}

function PlayState:init(def)
    self.player = Player {
        animations = ENTITY_DEFS[def.character].animations,
        mapX = 12,
        mapY = 9,
        width = 16,
        height = 16,
        type = 'player',
        character = def.character
    }
    self.firstEnter = true
    self.restart = false

    self.level = MapIntro(self, self.player)
end

function PlayState:update(dt)
    if love.keyboard.wasPressed('m') then
        gStateStack:push(FieldMenuState(self))
    elseif love.keyboard.wasPressed('h') then
        gStateStack:push(DialogueState("Press 'M' to open Menu. " ..
            "'Backspace' to return. 'Enter' to select/next. 'Esc' to exit game. 'H' to open Help dialouge. " .. 
            "Fight On Chosen One!", self.level.camX, self.level.camY, 'left', function()
            end
        ))
    end

    self.level:update(dt)
end

function PlayState:render()
    self.level:render()
end


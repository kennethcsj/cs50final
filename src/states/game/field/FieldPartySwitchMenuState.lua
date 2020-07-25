--[[
    GD50
    
    FieldPartySwitchMenuState Class
]]

FieldPartySwitchMenuState = Class{__includes = BaseState}

function FieldPartySwitchMenuState:init(playState, charPosition)
    self.playState = playState

    self.charPosition = charPosition

    self.party = self.playState.level.player.party.party

    self.select = Selector{
        items = self.party
    }

    self.x = self.playState.level.camX + VIRTUAL_WIDTH / 2
    self.y = self.playState.level.camY + 24

    self.height = VIRTUAL_HEIGHT - 24

    self.topPanel = Panel(self.x, self.playState.level.camY, VIRTUAL_WIDTH / 2, 24)

    self.panels = {}

    for k = 1, 4 do
        table.insert(self.panels, Panel(self.x, self.y + (k - 1) * self.height / 4, VIRTUAL_WIDTH / 2, self.height / 4))
    end
end

function FieldPartySwitchMenuState:update(dt)
    if love.keyboard.wasPressed('backspace') then
        gSounds['select']:stop()
        gSounds['select']:play()

        gStateStack:pop()
    elseif love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gSounds['select']:stop()
        gSounds['select']:play()
        
        -- switch the party position
        local tempChar = self.party[self.select.currentSelection]
        self.party[self.select.currentSelection] = self.party[self.charPosition]
        self.party[self.charPosition] = tempChar

        -- change the playstate animation to 1st player of the party
        self.playState.level.player.animations = self.playState.level.player:createAnimations(ENTITY_DEFS[self.party[1].id].animations)
        self.playState.level.player.character = self.party[1].id

        gStateStack:pop()

        -- pop away field individual stats state
        gStateStack:pop()
    end

    self.select:update(dt)
end

function FieldPartySwitchMenuState:render()
    love.graphics.setFont(gFonts['small'])
    
    self.topPanel:render()

    love.graphics.setColor(0, 0, 0, 255)
    love.graphics.print('Switch '.. tostring(self.party[self.charPosition].name) .. ' Position with??   ' .. self.party[self.select.currentSelection].name, self.x + 16, self.y - 16)
    
    for k, panel in pairs(self.panels) do
        if k == self.select.currentSelection then
            panel.r, panel.g, panel.b = 255, 255, 255
        else
            panel.r, panel.g, panel.b = 0, 0, 0
        end
        panel:render()
    end

    for k, char in pairs(self.party) do
        love.graphics.draw(gTextures[char.animations['idle-down'].texture], gFrames[char.animations['idle-down'].texture][char.animations['idle-down'].frames[1]], self.x + VIRTUAL_WIDTH / 4 - 8, self.y + (k - 1) * self.height / 4 + self.height / 8 - 8)
    end
end
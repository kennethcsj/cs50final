FieldPartyMenuState = Class{__includes = BaseState}

function FieldPartyMenuState:init(playState)
    self.playState = playState

    self.party = self.playState.level.player.party.party

    self.select = Selector{
        items = self.party
    }

    self.x = self.playState.level.camX + VIRTUAL_WIDTH / 2
    self.y = self.playState.level.camY

    self.panels = {}

    for k = 1, 4 do
        table.insert(self.panels, Panel(self.x, self.y + (k - 1) * VIRTUAL_HEIGHT / 4, VIRTUAL_WIDTH / 2, VIRTUAL_HEIGHT / 4))
    end
end

function FieldPartyMenuState:update(dt)
    if love.keyboard.wasPressed('backspace') then
        gStateStack:pop()
    elseif love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateStack:push(FieldIndividualMenuState(self.playState, self.party[self.select.currentSelection], self.select.currentSelection))
    end

    self.select:update(dt)
end

function FieldPartyMenuState:render()
    love.graphics.setFont(gFonts['small'])

    for k, panel in pairs(self.panels) do
        if k == self.select.currentSelection then
            panel.r, panel.g, panel.b = 255, 255, 255
        else
            panel.r, panel.g, panel.b = 0, 0, 0
        end
        panel:render()
    end

    for k, char in pairs(self.party) do
        love.graphics.draw(gTextures[char.animations['idle-down'].texture], gFrames[char.animations['idle-down'].texture][char.animations['idle-down'].frames[1]], self.x + VIRTUAL_WIDTH / 4 - 8, self.y + (k - 1) * VIRTUAL_HEIGHT / 4 + VIRTUAL_HEIGHT / 8 - 8)
    end
end
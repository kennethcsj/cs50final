--[[
    GD50
    
    FieldItemSelectMenuState Class
]]

FieldItemSelectMenuState = Class{__includes = BaseState}

function FieldItemSelectMenuState:init(playState, itemPosition)
    self.playState = playState

    self.itemPosition = itemPosition

    self.party = self.playState.level.player.party.party
    self.items = self.playState.level.player.items

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

function FieldItemSelectMenuState:update(dt)
    if love.keyboard.wasPressed('backspace') then
        gStateStack:pop()
    elseif love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateStack:push(MessageConfirmState(nil, self.playState.level.camX, self.playState.level.camY, 'center', function()
            -- Use Item
            if (self.items[self.itemPosition]:use(self.party[self.select.currentSelection])) then
                local name = self.items[self.itemPosition].name

                -- remove item from player item list
                if (self.items[self.itemPosition].count <= 0) then
                    table.remove(self.items, self.itemPosition)
                end

                -- push confirmation message
                local text = tostring(name) .. ' used on ' .. tostring(self.party[self.select.currentSelection].name) .. '!'

                gStateStack:push(MessagePopUpState(text, self.playState.level.camX, self.playState.level.camY, 'center', function()
                    gStateStack:pop() 
                end))
            else
                gStateStack:push(MessagePopUpState('Ineffective usage of item', self.playState.level.camX, self.playState.level.camY, 'center', function()
                    gStateStack:pop() 
                end))
            end
        end))
    end

    self.select:update(dt)
end

function FieldItemSelectMenuState:render()
    love.graphics.setFont(gFonts['small'])
    
    self.topPanel:render()

    love.graphics.setColor(0, 0, 0, 255)
    love.graphics.print('Choose character to use item on..  ' .. self.party[self.select.currentSelection].name, self.x + 16, self.y - 16)
    
    -- change color of panel for current selection
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
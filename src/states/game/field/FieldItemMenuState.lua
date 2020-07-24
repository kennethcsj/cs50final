--[[
    GD50
    
    FieldItemMenuState Class
]]

FieldItemMenuState = Class{__includes = BaseState}

function FieldItemMenuState:init(playState)
    self.playState = playState
    self.player = self.playState.level.player

    self.items = self.player.items

    self.select = Selector{
        items = self.items
    }

    self.x = self.playState.level.camX + VIRTUAL_WIDTH / 2
    self.y = self.playState.level.camY

    self.panel = Panel(self.x, self.y, VIRTUAL_WIDTH / 2, VIRTUAL_HEIGHT)

    self.panels = {}

    for k = 1, #self.items do
        table.insert(self.panels, Panel(self.x, self.y + (k - 1) * VIRTUAL_HEIGHT / 8, VIRTUAL_WIDTH / 2, VIRTUAL_HEIGHT / 8))
    end

    -- use to create scrollable
    self.displayFirstItem = 1
    self.displayLastItem = 8
end

function FieldItemMenuState:update(dt)
    if love.keyboard.wasPressed('backspace') then
        gStateStack:pop()
    elseif love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateStack:push(FieldItemSelectMenuState(self.playState, self.select.currentSelection))
    end

    self.select:update(dt)

    -- use to ensure current selection is displayed on screen
    if self.select.currentSelection > self.displayLastItem then
        self.displayFirstItem = self.displayFirstItem + self.select.currentSelection - self.displayLastItem
        self.displayLastItem = self.select.currentSelection
    elseif self.select.currentSelection < self.displayFirstItem then
        self.displayLastItem = self.displayLastItem - (self.displayFirstItem - self.select.currentSelection)
        self.displayFirstItem = self.select.currentSelection
    end
end

function FieldItemMenuState:render()
    self.panel:render()

    for k, panel in pairs(self.panels) do
        if k >= self.displayFirstItem and k <= self.displayLastItem then
            panel.y = self.y + (k - self.displayFirstItem) * VIRTUAL_HEIGHT / 8
            if k == self.select.currentSelection then
                panel.r, panel.g, panel.b = 255, 255, 255
                panel.select = true
            else
                panel.r, panel.g, panel.b = 0, 0, 0
                panel.select = false
            end
            panel:render()
        end
    end

    for k, item in pairs(self.items) do
        item.isSelected = (k == self.select.currentSelection) and true or false
        
        if k >= self.displayFirstItem and k <= self.displayLastItem then
            item.x = self.x + 8
            item.y = self.y + (k - self.displayFirstItem) * VIRTUAL_HEIGHT / 8 + VIRTUAL_HEIGHT / 16 - 8
            item:render()
        end
    end
end
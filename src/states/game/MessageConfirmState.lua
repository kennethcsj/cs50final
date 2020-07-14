MessageConfirmState = Class{__includes = BaseState}

function MessageConfirmState:init(text, camX, camY, alignment, callback)
    self.x = camX
    self.y = camY
    self.alignment = alignment or 'left'

    self.text = text or 'Confirm Selection?'
    self.textbox = Textbox(self.x + VIRTUAL_WIDTH / 2 - VIRTUAL_WIDTH / 4, self.y + VIRTUAL_HEIGHT / 2 - 32, VIRTUAL_WIDTH / 2, 64, self.text, gFonts['small'], self.alignment, false)
    self.callback = callback or function() end

    self.items = {'Yes', 'No'}
    self.select = Selector {
        items = self.items
    }
end

function MessageConfirmState:update(dt)
    self.textbox:update(dt)

    if love.keyboard.wasPressed('backspace') then
        gStateStack:pop()
    elseif love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        if self.items[self.select.currentSelection] == 'Yes' then
            self.callback()
        elseif self.items[self.select.currentSelection] == 'No' then
            gStateStack:pop()
        end
    end

    self.select:update(dt)
end

function MessageConfirmState:render()
    self.textbox:render()

    for k, item in pairs(self.items) do
        if k == self.select.currentSelection then
            love.graphics.setColor(255, 255, 255, 255)
            love.graphics.printf(item, self.x + VIRTUAL_WIDTH / 4, self.y + VIRTUAL_HEIGHT / 2 + 4 + (k - 1) * 16, VIRTUAL_WIDTH / 2, self.alignment)
        else
            love.graphics.setColor(0, 0, 0, 255)
            love.graphics.printf(item, self.x + VIRTUAL_WIDTH / 4, self.y + VIRTUAL_HEIGHT / 2 + 4 + (k - 1) * 16, VIRTUAL_WIDTH / 2, self.alignment)
        end
    end
end
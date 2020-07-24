--[[
    GD50
    
    MessagePopUpState Class
]]

MessagePopUpState = Class{__includes = BaseState}

function MessagePopUpState:init(text, camX, camY, alignment, callback)
    self.x = camX
    self.y = camY
    self.alignment = alignment or 'left'

    self.textbox = Textbox(self.x + VIRTUAL_WIDTH / 2 - VIRTUAL_WIDTH / 4, self.y + VIRTUAL_HEIGHT / 2 - 32, VIRTUAL_WIDTH / 2, 64, text, VIRTUAL_WIDTH / 2, gFonts['small'], self.alignment)
    self.callback = callback or function() end
end

function MessagePopUpState:update(dt)
    self.textbox:update(dt)

    if self.textbox:isClosed() then
        self.callback()
        gStateStack:pop()
    end
end

function MessagePopUpState:render()
    self.textbox:render()
end
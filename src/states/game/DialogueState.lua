--[[
    GD50
    Pokemon

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

DialogueState = Class{__includes = BaseState}

function DialogueState:init(text, camX, camY, alignment, callback)
    self.textbox = Textbox(camX + 6, camY + 6, VIRTUAL_WIDTH - 12, 64, text, VIRTUAL_WIDTH - 12, gFonts['small'])
    self.callback = callback or function() end
end

function DialogueState:update(dt)
    self.textbox:update(dt)

    if self.textbox:isClosed() then
        gStateStack:pop()
        self.callback()
    end
end

function DialogueState:render()
    self.textbox:render()
end
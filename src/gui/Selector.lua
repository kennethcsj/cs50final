--[[
    GD50

    Selector Class
    Similar to Selection Class. Obtains current selection from table of items
]]

Selector = Class{}

function Selector:init(def)
    self.items = def.items

    self.currentSelection = 1
end

function Selector:update(dt)
    if love.keyboard.wasPressed('up') then
        if self.currentSelection == 1 then
            self.currentSelection = #self.items
        else
            self.currentSelection = self.currentSelection - 1
        end
    elseif love.keyboard.wasPressed('down') then
        if self.currentSelection == #self.items then
            self.currentSelection = 1
        else
            self.currentSelection = self.currentSelection + 1
        end
    end
end

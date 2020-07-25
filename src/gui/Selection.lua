--[[
    GD50
    Pokemon

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    The Selection class gives us a list of textual items that link to callbacks;
    this particular implementation only has one dimension of items (vertically),
    but a more robust implementation might include columns as well for a more
    grid-like selection, as seen in many kinds of interfaces and games.
]]

Selection = Class{}

function Selection:init(def)
    self.items = def.items
    self.x = def.x
    self.y = def.y

    self.height = def.height
    self.width = def.width
    self.font = def.font or gFonts['small']

    self.gapHeight = self.height / #self.items

    self.currentSelection = 1

    if def.cursor == nil then
        self.cursor = true
    else
        self.cursor = def.cursor
    end

    self.alignment = def.alignment or 'center'
    self.ox = def.ox or 0
end

function Selection:update(dt)
    if self.cursor then
        if love.keyboard.wasPressed('up') then
            gSounds['beep']:stop()
            gSounds['beep']:play()

            if self.currentSelection == 1 then
                self.currentSelection = #self.items
            else
                self.currentSelection = self.currentSelection - 1
            end
        elseif love.keyboard.wasPressed('down') then
            gSounds['beep']:stop()
            gSounds['beep']:play()

            if self.currentSelection == #self.items then
                self.currentSelection = 1
            else
                self.currentSelection = self.currentSelection + 1
            end
        elseif love.keyboard.wasPressed('return') or love.keyboard.wasPressed('enter') then
            gSounds['select']:stop()
            gSounds['select']:play()

            self.items[self.currentSelection].onSelect()
        end
    else
        if love.keyboard.wasPressed('return') or love.keyboard.wasPressed('enter') then
            gSounds['select']:stop()
            gSounds['select']:play()

            self.items[self.currentSelection].onSelect()
        end
    end
end

function Selection:render()
    local currentY = self.y

    for i = 1, #self.items do
        local paddedY = currentY + (self.gapHeight / 2) - self.font:getHeight() / 2

        love.graphics.setColor(0, 0, 0, 255)

        -- draw selection marker if we're at the right index
        if self.cursor and i == self.currentSelection then
            love.graphics.setColor(255, 255, 255, 255)
        end

        love.graphics.printf(self.items[i].text, self.x, paddedY, self.width, self.alignment, 0, 1, 1, self.ox)

        currentY = currentY + self.gapHeight
    end
end
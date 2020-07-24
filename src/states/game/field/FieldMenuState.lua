--[[
    GD50
    
    FieldMenuState Class
]]

FieldMenuState = Class{__includes = BaseState}

function FieldMenuState:init(playState)
    self.playState = playState

    self.fieldMenu = Menu {
        x = self.playState.level.camX,
        y = self.playState.level.camY,
        width = VIRTUAL_WIDTH / 2,
        height = VIRTUAL_HEIGHT,
        items = {
            {
                text = 'Party',
                onSelect = function()
                    gStateStack:push(FieldPartyMenuState(self.playState))
                end
            },
            {
                text = 'Items',
                onSelect = function()
                    gStateStack:push(FieldItemMenuState(self.playState))
                end
            },
            {
                text = 'Exit',
                onSelect = function()
                    gStateStack:pop()
                end
            },
        },
        font = gFonts['medium'],
        cursor = true,
        alignment = 'center'
    }
end

function FieldMenuState:update(dt)
    if love.keyboard.wasPressed('m') or love.keyboard.wasPressed('backspace') then
        gStateStack:pop()
    end

    self.fieldMenu:update(dt)
end

function FieldMenuState:render()
    love.graphics.setFont(gFonts['medium'])
    self.fieldMenu:render()
end
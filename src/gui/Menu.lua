--[[
    GD50
    
    Menu Class

    A Menu is simply a Selection layered onto a Panel, at least for use in this
    game. More complicated Menus may be collections of Panels and Selections that
    form a greater whole.
]]

Menu = Class{}

function Menu:init(def)
    self.panel = Panel(def.x, def.y, def.width, def.height)
    
    self.selection = Selection {
        items = def.items,
        x = def.x,
        y = def.y,
        width = def.width,
        height = def.height,
        font = def.font,
        cursor = def.cursor,
        alignment = def.alignment,
        ox = def.ox
    }
end

function Menu:update(dt)
    self.selection:update(dt)
end

function Menu:render()
    self.panel:render()
    self.selection:render()
end
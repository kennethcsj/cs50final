--[[
    GD50
    Pokemon

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

TileMap = Class{}

function TileMap:init(width, height, startX, startY, endX, endY, id)
    self.tiles = {}

    self.width = width
    self.height = height

    self.startX = startX
    self.startY = startY
    self.endX = endX
    self.endY = endY
    self.id = id
end

function TileMap:render()
    for y = 1, self.height do
        for x = 1, self.width do
            self.tiles[y][x]:render()
        end
    end
end
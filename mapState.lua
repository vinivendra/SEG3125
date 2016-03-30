
require 'array'


currentMapState = nil


function copyPosition(position)
    return {position[1], position[2]}
end

MapState = {
    map = {"#########",
           "#_______#",
           "#########"},
    imageName = "stages/stage1-1.png",
    startingPosition = {2, 2},
    goalPosition = {2, 8},
    playerPosition = nil,
    playerOffset = {415 - 17, 350 - 25}
}

function MapState:new(o)
    o = o or {}   -- create object if user does not provide one
    setmetatable(o, self)
    self.__index = self

    o:reset()

    return o
end

function MapState:reset()
    self.playerPosition = copyPosition(self.startingPosition)
end

function MapState:move(direction)
    local x = self.playerPosition[1] + direction[2]
    local y = self.playerPosition[2] + direction[1]

    local canMove = false
    if self.map[x] ~= nil then
        canMove = (self.map[x][y] == '_')
    end

    if canMove then
        self.playerPosition[1] = x
        self.playerPosition[2] = y
    end

    return canMove
end



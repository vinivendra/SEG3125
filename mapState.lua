
require 'array'


currentMapState = nil


function copyPosition(position)
    return {position[1], position[2]}
end

MapState = {
    map = {"____########",
           "###_########",
           "###_##______",
           "###____#####",
           "############"},
    startingPosition = {1, 1},
    goalPosition = {3, 12},
    playerPosition = nil
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

    print("current position", self.playerPosition[1], self.playerPosition[2])
    print("direction", direction[2], direction[1])
    print("new position", x, y)

    local canMove = (self.map[x][y] == '_')

    if canMove then
        self.playerPosition[1] = x
        self.playerPosition[2] = y
    end

    return canMove
end



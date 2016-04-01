
require 'array'

require 'animations'


currentMapState = nil


function copyPosition(position)
    return {position[1], position[2]}
end

MapState = {
    
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

function MapState:hasFinished()
    return self.playerPosition[1] == self.goalPosition[1] and
           self.playerPosition[2] == self.goalPosition[2]
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



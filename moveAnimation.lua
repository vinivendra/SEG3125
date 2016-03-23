require 'animation'

--- MoveAnimation: Animation class --------------------------

MoveAnimation = Animation:new({
    originX = nil,
    originY = nil,
    destinationX = nil,
    destinationY = nil,
    displacementX = 0,
    displacementY = 0
    })

function MoveAnimation:new(o)
    o = o or {}   -- create object if user does not provide one

    setmetatable(o, self)
    self.__index = self

    return o
end

function MoveAnimation:run(dt)
    self.t = self.t + (dt / self.duration)

    if self.originX == nil then
        self.originX = self.subject.x
        self.destinationX = self.originX + self.displacementX
    end
    if self.originY == nil then
        self.originY = self.subject.y
        self.destinationY = self.originY + self.displacementY
    end

    if self.t > 1.0 then
        self.subject.x = self.destinationX
        self.subject.y = self.destinationY
        return false
    else
        self.x = self.timingFunction(self.originX, self.destinationX, self.t)
        self.y = self.timingFunction(self.originY, self.destinationY, self.t)
        self.subject.x = self.x
        self.subject.y = self.y
        return true
    end
end



require 'animations/animation'

--- MoveAnimation: ActionAnimation class --------------------------

MoveAnimation = ActionAnimation:new({
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

    if self.state == AnimationReady then
        if self.willStart ~= nil then
            self:willStart()
        end

        if self.action ~= nil then
            self.action:colorView()
        end

        self.originX = self.subject.x
        self.originY = self.subject.y

        if self.destinationX == nil then
            self.destinationX = self.originX + self.displacementX
        end
        if self.destinationY == nil then
            self.destinationY = self.originY + self.displacementY
        end
    end

    if self.t > 1.0 then
        self.state = AnimationEnded

        self.subject.x = self.destinationX
        self.subject.y = self.destinationY

        if self.action ~= nil then
            self.action:bwView()
        end
    else
        self.state = AnimationRunning

        self.x = self.timingFunction(self.originX, self.destinationX, self.t)
        self.y = self.timingFunction(self.originY, self.destinationY, self.t)
        self.subject.x = self.x
        self.subject.y = self.y
    end
end


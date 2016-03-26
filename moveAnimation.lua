require 'animation'

--- ActionAnimation: Animation class ------------------------

ActionAnimation = Animation:new({
    action = nil
    })

--- MoveAnimation: Animation class --------------------------

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
        if self.action ~= nil then
            self.action:animationWillStart(self)
        end

        if self.originX == nil then
            self.originX = self.subject.x
            self.destinationX = self.originX + self.displacementX
        end
        if self.originY == nil then
            self.originY = self.subject.y
            self.destinationY = self.originY + self.displacementY
        end
    end

    if self.t > 1.0 then
        self.state = AnimationEnded

        self.subject.x = self.destinationX
        self.subject.y = self.destinationY
    else
        self.state = AnimationRunning

        self.x = self.timingFunction(self.originX, self.destinationX, self.t)
        self.y = self.timingFunction(self.originY, self.destinationY, self.t)
        self.subject.x = self.x
        self.subject.y = self.y
    end
end


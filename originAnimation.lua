require 'animation'

--- OriginAnimation: Animation class --------------------------

OriginAnimation = Animation:new({
    originX = 0,
    originY = 0,
    destinationX = 0,
    destinationY = 0
    })

function OriginAnimation:new(o)
    o = o or {}   -- create object if user does not provide one

    if o.subject ~= nil then
        if o.originX == nil then
            o.originX = o.subject.x
        end
        if o.originY == nil then
            o.originY = o.subject.y
        end
    end

    setmetatable(o, self)
    self.__index = self

    return o
end

function OriginAnimation:chain(newAnimation)
    newAnimation.originX = self.destinationX
    newAnimation.originY = self.destinationY

    Animation.chain(self, newAnimation)
end

function OriginAnimation:run(dt)
    self.t = self.t + (dt / self.duration)

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
        return true
    end
end


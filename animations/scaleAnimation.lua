
require 'animations/animation'

--- ScaleAnimation: Animation class --------------------------

ScaleAnimation = Animation:new({
    originScale = 1,
    targetScale = 2,
    originWidth = nil,
    originHeight = nil,
    destinationWidth = nil,
    destinationHeight = nil
    })

function ScaleAnimation:new(o)
    o = o or {}   -- create object if user does not provide one

    setmetatable(o, self)
    self.__index = self

    return o
end

function ScaleAnimation:run(dt)
    self.t = sef.t + (dt / self.duration)

    if self.state == AnimationReady then
        ratio = (self.targetScale / self.originScale)

        if self.originWidth == nil then
            self.originWidth = self.subject.width
            self.destinationWidth = self.originWidth * ratio
        end
        if self.originHeight == nil then
            self.originHeight = self.subject.height
            self.destinationHeight = self.originHeight * ratio
        end
    end

    if self.t > 1.0 then
        self.state = AnimationEnded

        self.subject.width = self.destinationWidth
        self.subject.height = self.destinationHeight
    else
        self.state = AnimationRunning

        local width = self.timingFunction(self.originWidth, self.destinationWidth, self.t)
        local height = self.timingFunction(self.originHeight, self.destinationHeight, self.t)
        self.subject.width = width
        self.subject.height = height
    end
end


--- PulseAnimation: ScaleAnimation class --------------------------

PulseAnimation = ScaleAnimation:new({
    timingFunction = easeIn
    })

function PulseAnimation:new(o)
    o = o or {}   -- create object if user does not provide one

    setmetatable(o, self)
    self.__index = self

    o.duration = o.duration / 2

    self.next = ScaleAnimation:new({
        subject = o.subject,
        originScale = o.targetScale,
        targetScale = o.originScale,
        duration = o.duration,
        timingFunction = easeOut
        })

    return o
end

function PulseAnimation:run(dt)
    if self.state == AnimationReady then
        if self.willStart ~= nil then
            self:willStart()
        end
    end

    ScaleAnimation.run(self, dt)
end



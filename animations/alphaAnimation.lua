
require 'animations/animation'

--- AlphaAnimation: Animation class --------------------------

AlphaAnimation = Animation:new({
    originAlpha = nil,
    destinationAlpha = nil
    })

function AlphaAnimation:new(o)
    o = o or {}   -- create object if user does not provide one

    setmetatable(o, self)
    self.__index = self

    return o
end

function AlphaAnimation:run(dt)
    self.t = self.t + (dt / self.duration)

    if self.state == AnimationReady then

        local color = self.subject.color

        if color == nil then
            self.subject.color = {255, 255, 255, 255}
        elseif color[4] == nil then
            self.subject.color = {color[1], color[2], color[3], 255}
        end

        self.originAlpha = self.subject.color[4]
          
        if self.destinationAlpha == nil then
            self.destinationAlpha = 255 - self.originAlpha
        end
    end

    if self.t > 1.0 then
        self.state = AnimationEnded

        self.subject.color[4] = self.destinationAlpha
    else
        self.state = AnimationRunning

        self.subject.color[4] = self.timingFunction(self.originAlpha, self.destinationAlpha, self.t)
    end
end


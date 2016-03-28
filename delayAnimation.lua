--- DelayAnimation: Animation class --------------------------

DelayAnimation = ActionAnimation:new({
    })

function DelayAnimation:new(o)
    o = o or {}   -- create object if user does not provide one
    setmetatable(o, self)
    self.__index = self
    return o
end

function DelayAnimation:run(dt)
    self.t = self.t + (dt / self.duration)

    if self.state == AnimationReady then
        if action ~= nil then
            self.action:animationWillStart(self)
        end
    end

    if self.t > 1.0 then
        self.state = AnimationEnded
    else
        self.state = AnimationRunning
    end
end


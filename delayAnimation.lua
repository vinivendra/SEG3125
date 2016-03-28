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
        if self.action ~= nil then
            self.action:animationWillStart(self)
        end
    end

    if self.t > 1.0 then
        self.state = AnimationEnded
    else
        self.state = AnimationRunning
    end
end


--- StopAnimation: Animation class ---------------------------

StopAnimation = DelayAnimation:new({
    })

function StopAnimation:new(o)
    o = o or {}   -- create object if user does not provide one
    setmetatable(o, self)
    self.__index = self
    return o
end

function StopAnimation:run(dt)
    self.t = self.t + (dt / self.duration)

    if self.state == AnimationReady then
        if self.action ~= nil then
            self.action:animationWillStart(self)
        end

        self.subject.imageName = "individuals/linkStop.png"
        self.subject:updateImage()
    end

    if self.t > 1.0 then
        self.state = AnimationEnded
    else
        self.state = AnimationRunning
    end
end





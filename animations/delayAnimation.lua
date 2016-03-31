
require 'animations/animation'

--- DelayAnimation: ActionAnimation class --------------------------

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
        if self.willStart ~= nil then
            self:willStart()
        end

        if self.action ~= nil then
            self.action:colorView()
        end
    end

    if self.t > 1.0 then
        self.state = AnimationEnded

        if self.action ~= nil then
            self.action:bwView()
        end
    else
        self.state = AnimationRunning
    end
end


--- StopAnimation: DelayAnimation class ---------------------------

StopAnimation = DelayAnimation:new({
    imageName = "individuals/linkStop.png"
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
        if self.willStart ~= nil then
            self:willStart()
        end

        if self.action ~= nil then
            self.action:colorView()
        end

        self.subject.imageName = self.imageName
        self.subject:updateImage()
    end

    if self.t > 1.0 then
        self.state = AnimationEnded

        if self.action ~= nil then
            self.action:bwView()
        end
    else
        self.state = AnimationRunning
    end
end






require 'array'

function interpolate(a, b, t)
    return a + ((b - a) * t)
end

function smoothInterpolate(a, b, t)
    start = a
    interval = b - a
    interp = t * t * t * (t * (t * 6 - 15) + 10)
    return start + interp * interval
end

function startAnimation(animation)
    push(animations, animation)
end

function runAnimations(dt)
    size = getSize(animations)

    for i=1,size do
        animation = animations[i]

        if animation.isActive == false then
            removeAtIndex(animations, i)
        end

        isRunning = animation:run(dt)

        if isRunning == false then
            if animation.next ~= nil then
                startAnimation(animation.next)
            end
            removeAtIndex(animations, i)
        end
    end
end

animations = {}

--- Animation class --------------------------------------------

Animation = {
    duration =  1,
    t = 0,
    subject = {},
    isActive = true,
    next = nil
}

function Animation:new(o)
    o = o or {}   -- create object if user does not provide one
    setmetatable(o, self)
    self.__index = self
    return o
end

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
    self.next = newAnimation
end

function OriginAnimation:run(dt)
    self.t = self.t + (dt / self.duration)

    if self.t > 1.0 then
        self.subject.x = self.destinationX
        self.subject.y = self.destinationY
        return false
    else
        self.x = smoothInterpolate(self.originX, self.destinationX, self.t)
        self.y = smoothInterpolate(self.originY, self.destinationY, self.t)
        self.subject.x = self.x
        self.subject.y = self.y
        return true
    end
end

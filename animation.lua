
require 'interpolate'
require 'array'

function startAnimation(animation)
    push(animations, animation)
end

function runAnimations(dt)
    runAnimationsOnArray(animations, dt)
end

function runActions(dt)
    runAnimationsOnArray(actionAnimations, dt)
end

function runAnimationsOnArray(array, dt)
    size = getSize(array)

    for i=1,size do
        animation = array[i]

        if animation.isActive == false then
            removeAtIndex(array, i)
        end

        isRunning = animation:run(dt)

        if isRunning == false then
            if animation.next ~= nil then
                startAnimation(animation.next)
            end
            removeAtIndex(array, i)
        end
    end
end

actionAnimations = {}
animations = {}

gameAnimation = nil

--- Animation class --------------------------------------------

Animation = {
    duration =  1,
    t = 0,
    subject = {},
    isActive = true,
    next = nil,
    timingFunction = smooth
}

function Animation:new(o)
    o = o or {}   -- create object if user does not provide one
    setmetatable(o, self)
    self.__index = self
    return o
end

function Animation:chain(newAnimation)
    self.next = newAnimation
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
        self.x = self.timingFunction(self.originX, self.destinationX, self.t)
        self.y = self.timingFunction(self.originY, self.destinationY, self.t)
        self.subject.x = self.x
        self.subject.y = self.y
        return true
    end
end

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
    self.t = self.t + (dt / self.duration)

    ratio = (self.targetScale / self.originScale)

    if self.originWidth == nil then
        self.originWidth = self.subject.width
        self.destinationWidth = self.originWidth * ratio
    end
    if self.originHeight == nil then
        self.originHeight = self.subject.height
        self.destinationHeight = self.originHeight * ratio
    end

    if self.t > 1.0 then
        self.subject.width = self.destinationWidth
        self.subject.height = self.destinationHeight
        return false
    else
        self.width = self.timingFunction(self.originWidth, self.destinationWidth, self.t)
        self.height = self.timingFunction(self.originHeight, self.destinationHeight, self.t)
        self.subject.width = self.width
        self.subject.height = self.height
        return true
    end
end


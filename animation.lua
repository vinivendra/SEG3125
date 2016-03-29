
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
    if array == nil or appState == stateEditing then
        return
    end

    local size = getSize(array)

    for i=1,size do
        local animation = array[i]

        if animation.isActive == false then
            removeAtIndex(array, i)
        end

        animation:run(dt)

        if animation.state == AnimationEnded then
            if animation.completion ~= nil then
                animation.completion()
            end
            
            removeAtIndex(array, i)
            if animation.next ~= nil then
                push(array, animation.next)
            end
        end
    end
end

actionAnimations = {}
animations = {}

gameAnimation = nil

--- Animation class --------------------------------------------

AnimationReady = 0
AnimationRunning = 1
AnimationEnded = 2

Animation = {
    state = AnimationReady,
    duration =  1,
    t = 0,
    subject = {},
    isActive = true,
    next = nil,
    timingFunction = smooth,
    completion = nil
}

function Animation:new(o)
    o = o or {}   -- create object if user does not provide one
    setmetatable(o, self)
    self.__index = self
    return o
end

function Animation:chain(newAnimation)
    if self.next == nil then
        self.next = newAnimation
    else
        self.next:chain(newAnimation)
    end
end

function Animation:run()
    self.state = AnimationEnded
end

--- ActionAnimation: Animation class ------------------------

ActionAnimation = Animation:new({
    action = nil
    })



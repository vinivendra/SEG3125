
require 'array'

require 'animation'
require 'scaleAnimation'
require 'moveAnimation'
require 'originAnimation'


function addAction(action) 
    push(actions, action)
end

function startActions()
    actionAnimations = {}

    action1 = MoveAction:new({
        direction = moveRight
        })
    animation1 = action1:getAnimation()

    action2 = MoveAction:new({
        direction = moveDown
        })
    animation2 = action2:getAnimation()

    action3 = MoveAction:new({
        direction = moveLeft
        })
    animation3 = action3:getAnimation()

    action4 = MoveAction:new({
        direction = moveUp
        })
    animation4 = action4:getAnimation()

    animation1:chain(animation2)
    animation1:chain(animation3)
    animation1:chain(animation4)

    action5 = AttackAction:new()
    animation5 = action5:getAnimation()
    animation1:chain(animation5)

    push(actionAnimations, animation1)
end

actions = {}

moveRight = 0
moveDown = 1
moveLeft = 2
moveUp = 3

--- Action class --------------------------------------

Action = {
    subactions = nil
}

function Action:new(o)
    o = o or {}   -- create object if user does not provide one
    setmetatable(o, self)
    self.__index = self
    return o
end

--- MoveAction: Action class --------------------------

MoveAction = Action:new({
    direction = moveRight
    })

function MoveAction:new(o)
    o = o or {}   -- create object if user does not provide one
    setmetatable(o, self)
    self.__index = self
    return o
end

function MoveAction:getAnimation()
    displacementX = 0
    displacementY = 0

    if self.direction == moveRight then
        displacementX = tileSize
    end
    if self.direction == moveLeft then
        displacementX = -tileSize
    end
    if self.direction == moveUp then
        displacementY = -tileSize
    end
    if self.direction == moveDown then
        displacementY = tileSize
    end

    animation = MoveAnimation:new({
        subject = player,
        displacementX = displacementX,
        displacementY = displacementY
        })
    return animation
end

--- AttackAction: Action class --------------------------

AttackAction = Action:new({
    })

function AttackAction:new(o)
    o = o or {}   -- create object if user does not provide one
    setmetatable(o, self)
    self.__index = self
    return o
end

function AttackAction:getAnimation()
    pulseAnimation = PulseAnimation:new({
        subject = player
    })
    return pulseAnimation
end


--- LoopAction: Action class --------------------------

LoopAction = Action:new({
    subactions = {}
    })

function LoopAction:new(o)
    o = o or {}   -- create object if user does not provide one
    setmetatable(o, self)
    self.__index = self
    return o
end

--- ConditionAction: Action class --------------------------

ConditionAction = Action:new({
    subactions = {}
    })

function ConditionAction:new(o)
    o = o or {}   -- create object if user does not provide one
    setmetatable(o, self)
    self.__index = self
    return o
end


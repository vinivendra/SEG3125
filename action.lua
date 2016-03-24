
require 'array'

require 'animation'
require 'scaleAnimation'
require 'moveAnimation'
require 'originAnimation'


function addAction(action) 
    push(actions, action)
end

function startActions()

    action1 = MoveAction:new({
        direction = moveRight
        })
    action2 = MoveAction:new({
        direction = moveDown
        })

    loop = LoopAction:new()
    loop:addSubaction(action1)
    -- loop:addSubaction(action2)
    loop.iterations = 2

    addAction(loop)

    --

    actionAnimations = {}

    firstAnimation = Animation:new()

    for i=1,getSize(actions) do
        action = actions[i]
        animation = action:getAnimation()
        firstAnimation:chain(animation)
    end

    push(actionAnimations, firstAnimation)
end

actions = {}

moveRight = {1, 0}
moveDown = {0, 1}
moveLeft = {-1, 0}
moveUp = {0, -1}

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
    displacementX = self.direction[1] * tileSize
    displacementY = self.direction[2] * tileSize

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
    iterations = 3,
    size = 1,
    subactions = {}
    })

function LoopAction:new(o)
    o = o or {}   -- create object if user does not provide one
    setmetatable(o, self)
    self.__index = self
    return o
end

function LoopAction:validateSize(o)
    size = getSize(self.subactions)
    if self.size > size + 1 then
        self.size = size + 1
    elseif self.size < size then
        self.size = size
    end
end

function LoopAction:addSubaction(newAction)
    push(self.subactions, newAction)
    self:validateSize()
end

function LoopAction:removeActionAtIndex(index)
    removeAtIndex(self.subactions, index)
    self:validateSize()
end

function LoopAction:getAnimation() 
    firstAnimation = Animation:new()

    for i=1,self.iterations do
        for j=1,getSize(self.subactions) do
            subAction = self.subactions[j]
            animation = subAction:getAnimation()
            firstAnimation:chain(animation)
        end
    end

    return firstAnimation
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


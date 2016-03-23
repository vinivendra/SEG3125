
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
    -- animation1 = action1:getAnimation()

    -- action2 = MoveAction:new({
    --     direction = moveDown
    --     })
    -- animation2 = action2:getAnimation()

    -- action3 = MoveAction:new({
    --     direction = moveLeft
    --     })
    -- animation3 = action3:getAnimation()

    -- action4 = MoveAction:new({
    --     direction = moveUp
    --     })
    -- animation4 = action4:getAnimation()

    -- animation1:chain(animation2)
    -- animation1:chain(animation3)
    -- animation1:chain(animation4)

    -- action5 = AttackAction:new()
    -- animation5 = action5:getAnimation()
    -- animation1:chain(animation5)

    loop = LoopAction:new()
    loop:addSubaction(action1)
    loop.iterations = 5

    loopAnimation = loop:getAnimation()

    push(actionAnimations, loopAnimation)
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
    print(self.direction)
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


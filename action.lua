
require 'array'

require 'animation'
require 'scaleAnimation'
require 'moveAnimation'
require 'originAnimation'

function xForCommandAtIndex(index)
    return 180 * (index - 1) + 20
end

function addAction(action) 
    local newView = action.view
    newView.x = xForCommandAtIndex(getSize(actions))
    commandBar:addSubview(newView)

    local addCommandAction = actions[getSize(actions)]
    local addCommandView = addCommandAction.view
    addCommandView.x = xForCommandAtIndex(getSize(actions) + 1)

    pushAction(actions, action)
end

function startActions()
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

moveRight = {1, 0, "linkRight.png"}
moveDown = {0, 1, "linkDown.png"}
moveLeft = {-1, 0, "linkLeft.png"}
moveUp = {0, -1, "linkUp.png"}

--- Action class --------------------------------------

Action = {
    subactions = nil,
    view = nil
}

function Action:new(o)
    o = o or {}   -- create object if user does not provide one
    setmetatable(o, self)
    self.__index = self
    return o
end

--- AddCommandAction: Action class ---------------------

AddCommandAction = Action:new({
    })

function AddCommandAction:new(o)
    o = o or {}   -- create object if user does not provide one
    setmetatable(o, self)
    self.__index = self

    if o.view == nil then
        o.view = SquareView:new({
        x = 20,
        y = 20,
        width = 140,
        height = 140,
        color = {200, 200, 200}
        })
    end

    return o
end

function AddCommandAction:animationWillStart(animation)
end

function AddCommandAction:getAnimation()
    return Animation:new()
end

--- MoveAction: Action class --------------------------

MoveAction = Action:new({
    direction = moveRight
    })

function MoveAction:new(o)
    o = o or {}   -- create object if user does not provide one
    setmetatable(o, self)
    self.__index = self

    if o.view == nil then
        o.view = SquareView:new({
        x = 20,
        y = 20,
        width = 140,
        height = 140
        })
    end

    return o
end

function MoveAction:animationWillStart(animation)
    animation.subject.imageName = self.direction[3]
    animation.subject:updateImage()
end

function MoveAction:getAnimation()
    displacementX = self.direction[1] * tileSize
    displacementY = self.direction[2] * tileSize

    animation = MoveAnimation:new({
        action = self,
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

function AttackAction:animationWillStart(animation)
    animation.subject.imageName = "linkRightAttack.png"
    animation.subject:updateImage()
end

function AttackAction:getAnimation()
    pulseAnimation = PulseAnimation:new({
        subject = player,
        action = self
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
    local firstAnimation = Animation:new()

    for i=1,self.iterations do
        for j=1,getSize(self.subactions) do
            local subAction = self.subactions[j]
            local animation = subAction:getAnimation()
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


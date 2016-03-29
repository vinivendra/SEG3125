
require 'array'

require 'animation'
require 'scaleAnimation'
require 'moveAnimation'
require 'originAnimation'
require 'delayAnimation'

require 'mapState'



function xForCommandAtIndex(index)
    local spacing = 11
    local size = 160
    return (size + spacing) * (index - 1) + 20
end

function layoutCommandViews()
    for i = 1,getSize(actions) do
        local x = xForCommandAtIndex(i)
        local action = actions[i]
        local view = action.view
        view.x = x
    end
end

maxCommandSize = 11

function addAction(action) 
    local newView = action.view

    local currentActionsSize = getSize(actions)

    local addCommandAction = actions[currentActionsSize]
    local addCommandView = addCommandAction.view

    if currentActionsSize == maxCommandSize - 1 then
        addCommandView.color = {255, 255, 255, 0}
    elseif currentActionsSize == maxCommandSize then
        return
    end

    commandBar:addSubview(newView)
    pushAction(actions, action)

    layoutCommandViews()
end

function changeAction(oldAction, newAction) 
    local newView = newAction.view

    index = indexOf(actions, oldAction)
    actions[index] = newAction
    oldAction.view:removeFromSuperview()
    commandBar:addSubview(newView)

    layoutCommandViews()
end

function deleteAction(action)
    if commandState == commandStateAdd then
        return
    end

    if action == nil then
        action = selectedAction 
    end

    local currentActionsSize = getSize(actions)
    if currentActionsSize <= maxCommandSize then
        local addCommandAction = actions[currentActionsSize]
        local addCommandView = addCommandAction.view
        addCommandView.color = {255, 255, 255, 255}
    end

    removeElement(actions, action)
    action.view:removeFromSuperview()

    layoutCommandViews()
end

function startActions()
    actionAnimations = {}
    currentMapState:reset()

    local firstAnimation = nil

    if player.x ~= 0 or player.y ~= 0 then
        firstAnimation = OriginAnimation:new({
            destinationX = 0,
            destinationY = 0,
            subject = player
            })
    else 
        firstAnimation = Animation:new()
    end

    --

    for i=1,getSize(actions) do
        action = actions[i]
        animation = action:getAnimation()
        firstAnimation:chain(animation)
    end

    local lastAnimation = Animation:new({
        completion = finishActions
        })
    firstAnimation:chain(lastAnimation)

    push(actionAnimations, firstAnimation)
end

function finishActions()
    appState = stateEditing
    goButton.imageName = "interface/go.png"
    goButton:updateImage()
end

actions = {}

moveRight = {1, 0, "individuals/linkRight.png", "interface/arrowRight.png"}
moveDown = {0, 1, "individuals/linkDown.png", "interface/arrowDown.png"}
moveLeft = {-1, 0, "individuals/linkLeft.png", "interface/arrowLeft.png"}
moveUp = {0, -1, "individuals/linkUp.png", "interface/arrowUp.png"}

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
        o.view = o:createView()
    end

    return o
end

function AddCommandAction:createView()
    return ImageView:new({
        name = "add command",
        x = 20,
        y = 20,
        width = 140,
        height = 140,
        imageName = "interface/emptyBlock.png"
        })
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
        o.view = o:createView()
    end

    return o
end

function MoveAction:createView()
    return ImageView:new({
        name = "move action",
        x = 20,
        y = 20,
        width = 140,
        height = 140,
        imageName = self.direction[4],
        action = self,
        onTap = toggleCommandMenu
        })
end

function MoveAction:animationWillStart(animation)
    animation.subject.imageName = self.direction[3]
    animation.subject:updateImage()
end

function MoveAction:getAnimation()
    local canMove = currentMapState:move(self.direction)

    if canMove then
        local displacementX = self.direction[1] * tileSize
        local displacementY = self.direction[2] * tileSize

        animation = MoveAnimation:new({
            action = self,
            subject = player,
            displacementX = displacementX,
            displacementY = displacementY
            })
        return animation
    else
        animation = StopAnimation:new({
            subject = player
            })
        return animation
    end
end

--- AttackAction: Action class --------------------------

AttackAction = Action:new({
    })

function AttackAction:new(o)
    o = o or {}   -- create object if user does not provide one
    setmetatable(o, self)
    self.__index = self

    if o.view == nil then
        o.view = o:createView()
    end

    return o
end

function AttackAction:createView()
    return ImageView:new({
        name = "attack action",
        x = 20,
        y = 20,
        width = 140,
        height = 140,
        imageName = "interface/sword.png",
        action = self,
        onTap = toggleCommandMenu
        })
end

function AttackAction:animationWillStart(animation)
    animation.subject.imageName = "individuals/linkRightAttack.png"
    animation.subject:updateImage()
end

function AttackAction:getAnimation()
    pulseAnimation = DelayAnimation:new({
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


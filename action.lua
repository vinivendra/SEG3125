
require 'array'

require 'animation'
require 'scaleAnimation'
require 'moveAnimation'
require 'originAnimation'
require 'delayAnimation'
require 'alphaAnimation'

require 'spriteFunctions'

require 'mapState'



function xForCommandAtIndex(index)
    local spacing = 11

    local sum = 0
    for i=1,(index - 1) do
        local action = actions[i]
        local width = action:width()
        sum = sum + width + spacing
    end

    return 20 + sum
end

function layoutCommandViews()
    for i = 1,getSize(actions) do
        local x = xForCommandAtIndex(i)
        local action = actions[i]
        local view = action.view
        view.x = x

        if action.layoutSubviews ~= nil then
            action:layoutSubviews()
        end
    end
end

maxCommandSize = 11

function addAction(action) 

    if currentSuperaction == nil then
        local newView = action.view

        local currentActionsSize = getSize(actions)

        local addCommandAction = actions[currentActionsSize]
        local addCommandView = addCommandAction.view

        if currentActionsSize == maxCommandSize - 1 then
            addCommandView.color = {255, 255, 255, 0}
            dismissCommandMenu()
        elseif currentActionsSize == maxCommandSize then
            return
        end

        commandBar:addSubview(newView)
        pushAction(actions, action)

        layoutCommandViews()

        moveIndicatorToView(addCommandView)
    else
        local currentActionsSize = getSize(currentSuperaction.subactions)

        local addCommandAction = currentSuperaction.subactions[currentActionsSize]
        local addCommandView = addCommandAction.view

        if currentActionsSize == currentSuperaction.size then
            addCommandView.color = {255, 255, 255, 0}
            addCommandView.onTap = nil
            dismissCommandMenu()
        elseif currentActionsSize > currentSuperaction.size then
            return
        end

        currentSuperaction:addSubaction(action)

        layoutCommandViews()

        moveIndicatorToView(addCommandView)
    end
end

function changeAction(oldAction, newAction) 
    if currentSuperaction == nil then
        local newView = newAction.view

        index = indexOf(actions, oldAction)
        actions[index] = newAction
        oldAction.view:removeFromSuperview()
        commandBar:addSubview(newView)

        layoutCommandViews()

        previousMenuSender = newView
    else
        local newView = newAction.view

        index = indexOf(currentSuperaction.subactions, oldAction)
        currentSuperaction.subactions[index] = newAction
        oldAction.view:removeFromSuperview()

        layoutCommandViews()

        previousMenuSender = newView
    end
end

function deleteAction(action)
    if commandState == commandStateAdd then
        return
    end

    if currentSuperaction == nil then
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
    else
        if action == nil then
            action = selectedAction 
        end

        local currentActionsSize = getSize(currentSuperaction.subactions)
        if currentActionsSize <= maxCommandSize then
            local addCommandAction = currentSuperaction.subactions[currentActionsSize]
            local addCommandView = addCommandAction.view
            addCommandView.color = {255, 255, 255, 255}
            addCommandView.onTap = toggleAddCommandMenu
        end

        removeElement(currentSuperaction.subactions, action)
        action.view:removeFromSuperview()
    end

    layoutCommandViews()
end

function startActions()
    actionAnimations = {}
    currentMapState:reset()

    local firstAnimation = nil

    if player.x ~= currentMapState.playerOffset[1] or
       player.y ~= currentMapState.playerOffset[2] then
        firstAnimation = OriginAnimation:new({
            destinationX = currentMapState.playerOffset[1],
            destinationY = currentMapState.playerOffset[2],
            subject = player
            })
    else 
        firstAnimation = Animation:new()
    end

    --

    local hasFinished = false

    for i=1,getSize(actions) do
        local action = actions[i]
        local animation = action:getAnimation()
        firstAnimation:chain(animation)

        if currentMapState:hasFinished() then
            hasFinished = true
            local endingAnimation = currentMapState:getEndingAnimation()
            firstAnimation:chain(endingAnimation)
            break
        end
    end

    local lastAnimation

    if hasFinished then
        lastAnimation = Animation:new({
            completion = finishActions
            })
    else
        lastAnimation = StopAnimation:new({
            action = self,
            subject = player
            })
        returnAnimation = OriginAnimation:new({
            destinationX = currentMapState.playerOffset[1],
            destinationY = currentMapState.playerOffset[2],
            subject = player,
            completion = finishActions
            })
        lastAnimation:chain(returnAnimation)
    end

    firstAnimation:chain(lastAnimation)

    push(actionAnimations, firstAnimation)

    -- Make views BW
    for i=1,getSize(actions) do
        local action = actions[i]
        action:bwView()
    end

end

function finishActions()
    appState = stateEditing

    -- Restore UI
    player.imageName = "individuals/linkRight.png"
    player:updateImage()

    goButton.imageName = "interface/go.png"
    goButton:updateImage()

    ---- Make views colored
    for i=1,getSize(actions) do
        local action = actions[i]
        action:colorView()
    end
end

actions = {}

moveRight = {1, 0, moveRightSpriteFunction, "interface/arrowRight.png", "interface/arrowRightBW.png"}
moveDown = {0, 1, moveDownSpriteFunction, "interface/arrowDown.png", "interface/arrowDownBW.png"}
moveLeft = {-1, 0, moveLeftSpriteFunction, "interface/arrowLeft.png", "interface/arrowLeftBW.png"}
moveUp = {0, -1, moveUpSpriteFunction, "interface/arrowUp.png", "interface/arrowUpBW.png"}

--- Action class --------------------------------------

Action = {
    superaction = nil,
    subactions = nil,
    view = nil
}

function Action:new(o)
    o = o or {}   -- create object if user does not provide one
    setmetatable(o, self)
    self.__index = self
    return o
end

function Action:width()
    return 160
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
    self.view = ImageView:new({
        name = "add command",
        action = self,
        x = 20,
        y = 20,
        width = 140,
        height = 140,
        imageName = "interface/emptyBlock.png"
        })
    return self.view
end

function AddCommandAction:colorView()
    self.view.imageName = "interface/emptyBlock.png"
    self.view:updateImage()
end

function AddCommandAction:bwView()
    self.view.imageName = "interface/emptyBlockBW.png"
    self.view:updateImage()
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
    self.view = ImageView:new({
        name = "move action",
        x = 20,
        y = 20,
        width = 140,
        height = 140,
        imageName = self.direction[4],
        action = self,
        onTap = toggleCommandMenu
        })
    return self.view
end

function MoveAction:colorView()
    self.view.imageName = self.direction[4]
    self.view:updateImage()

    if self.superaction ~= nil then
        self.superaction:backgroundColorView()
    end
end

function MoveAction:bwView()
    self.view.imageName = self.direction[5]
    self.view:updateImage()

    if self.superaction ~= nil then
        self.superaction:backgroundBwView()
    end
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
            displacementY = displacementY,
            willStart = self.direction[3]
            })
        return animation
    else
        animation = StopAnimation:new({
            action = self,
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
    self.view = ImageView:new({
        name = "attack action",
        x = 20,
        y = 20,
        width = 140,
        height = 140,
        imageName = "interface/sword.png",
        action = self,
        onTap = toggleCommandMenu,
        willStart = attackSpriteFunction
        })
    return self.view
end

function AttackAction:colorView()
    self.view.imageName = "interface/sword.png"
    self.view:updateImage()

    if self.superaction ~= nil then
        self.superaction:backgroundColorView()
    end
end

function AttackAction:bwView()
    self.view.imageName = "interface/swordBW.png"
    self.view:updateImage()

    if self.superaction ~= nil then
        self.superaction:backgroundBwView()
    end
end

function AttackAction:getAnimation()
    animation = StopAnimation:new({
        imageName = "individuals/linkRightAttack.png",
        subject = player,
        action = self
    })
    return animation
end


--- LoopAction: Action class --------------------------

LoopAction = Action:new({
    name = "loopAction",
    iterations = 2,
    size = 2,
    view = nil,
    head = nil,
    backgroundView = nil,
    backgroundEnd = nil,
    commandAddView = nil,
    subactions = {}
    })

function LoopAction:new(o)
    o = o or {}   -- create object if user does not provide one
    setmetatable(o, self)
    self.__index = self

    if o.view == nil then
        o.view = o:createView()
    end

    return o
end

function LoopAction:addSubaction(newAction)
    newAction.superaction = self
    pushAction(self.subactions, newAction)
    self:layoutSubviews()
end

function LoopAction:removeActionAtIndex(index)
    newAction.superaction = nil
    removeAtIndex(self.subactions, index)
    self:layoutSubviews()
end

function LoopAction:width()
    local size = 1
    if self.size > 0 then
        size = self.size
    end
    return 90 + 20 + 160 * size + 20
end

function LoopAction:layoutSubviews()
    local actionSize = 160

    self.backgroundView.width = 20 + actionSize * self.size

    self.backgroundEnd.x = self.backgroundView.x + self.backgroundView.width

    for i=1,getSize(self.subactions) do
        local action = self.subactions[i]
        self.view:addSubview(action.view)
        action.view.x = self.backgroundView.x + 20 + (i-1) * actionSize
    end
end

function LoopAction:createView()

    self.view = SquareView:new({
        color = {0, 0, 0, 0},
        width = self:width(),
        height = 180
        })

    self.head = ImageView:new({
        name = "loop head",
        x = 20,
        y = 0,
        width = 90,
        height = 180,
        imageName = "interface/commandHeadBG.png",
        action = self,
        -- onTap = toggleCommandMenu,
        -- willStart = attackSpriteFunction
        })
    self.view:addSubview(self.head)

    self.backgroundView = SquareView:new({
        name = "loop background",
        color = {194, 226, 228},
        x = 90,
        width = 140 + 40,
        height = 180
        })
    self.view:addSubview(self.backgroundView)

    self.backgroundEnd = ImageView:new({
        name = "loop background end",
        imageName = "interface/commandTailBG.png",
        x = self.backgroundView.x + self.backgroundView.width,
        width = 3,
        height = 180
        })
    self.view:addSubview(self.backgroundEnd)

    local addCommandAction = AddCommandAction:new({
        superaction = self
        })
    self.subactions = {addCommandAction}

    local commandAddView = addCommandAction.view
    self.commandAddView = commandAddView
    commandAddView.name = "loop add"
    commandAddView.onTap = toggleAddCommandMenu
    commandAddView.x = 110
    commandAddView.y = 20
    self.view:addSubview(self.commandAddView)

    --
    self:layoutSubviews()

    return self.view
end

function LoopAction:colorView()
    self.head.imageName = "interface/commandHeadBG.png"
    self.head:updateImage()
    self.backgroundView.color = {194, 226, 228}
    self.backgroundEnd.imageName = "interface/commandTailBG.png"
    self.backgroundEnd:updateImage()
    self.commandAddView.action:colorView()

    for i = 1,getSize(self.subactions) do
        local action = self.subactions[i]
        action:colorView()
    end
end

function LoopAction:backgroundColorView()
    self.head.imageName = "interface/commandHeadBG.png"
    self.head:updateImage()
    self.backgroundView.color = {194, 226, 228}
    self.backgroundEnd.imageName = "interface/commandTailBG.png"
    self.backgroundEnd:updateImage()
    self.commandAddView.action:colorView()
end

function LoopAction:bwView()
    self.head.imageName = "interface/commandHeadBGBW.png"
    self.head:updateImage()
    self.backgroundView.color = {187, 187, 187}
    self.backgroundEnd.imageName = "interface/commandTailBGBW.png"
    self.backgroundEnd:updateImage()
    self.commandAddView.action:bwView()

    for i = 1,getSize(self.subactions) do
        local action = self.subactions[i]
        action:bwView()
    end
end

function LoopAction:backgroundBwView()
    self.head.imageName = "interface/commandHeadBGBW.png"
    self.head:updateImage()
    self.backgroundView.color = {187, 187, 187}
    self.backgroundEnd.imageName = "interface/commandTailBGBW.png"
    self.backgroundEnd:updateImage()
    self.commandAddView.action:bwView()
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


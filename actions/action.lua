
require 'array'

require 'animations'

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

            currentSuperaction:addSubaction(action)

            local globalAddCommand = actions[getSize(actions)]
            local addCommandAlpha = globalAddCommand.view.color[4]
            if addCommandAlpha == nil or
               addCommandAlpha > 0 then
                previousMenuSender = globalAddCommand
                currentSuperaction = nil
            end

            layoutCommandViews()

            moveIndicatorToView(globalAddCommand.view)

        elseif currentActionsSize > currentSuperaction.size then
            return
        else
            currentSuperaction:addSubaction(action)

            layoutCommandViews()

            moveIndicatorToView(addCommandView)
        end
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



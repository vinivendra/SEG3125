
function doNothing(sender)
    return true
end

function hue(sender)
    print("hue", getName(sender))
end

previousSuperMenuSender = nil
previousMenuSender = nil
currentSuperaction = nil

function dismissUI(sender)
    dismissCommandMenu(sender)
    dismissSuperCommandMenu(sender)
end

function dismissCommandMenu(sender)
    previousMenuSender = nil
    commandMenu:removeFromSuperview()
    return true
end

function dismissSuperCommandMenu(sender)
    previousSuperMenuSender = nil
    superactionMenu:removeFromSuperview()
    return true
end

function toggleCommandMenu(commandView)
    if previousMenuSender == commandView then
        dismissCommandMenu(commandView)
        previousMenuSender = nil
    else
        dismissSuperCommandMenu(commandView)

        deleteMenuAction.imageName = "interface/delete.png"
        deleteMenuAction.shouldAnimateTap = true
        deleteMenuAction:updateImage()

        if commandView.action ~= nil and
            commandView.action.superaction ~= nil then
            currentSuperaction = commandView.action.superaction
        else
            currentSuperaction = nil
        end

        if commandMenu.superview ~= view then
            view:addSubview(commandMenu)
        end

        moveIndicatorToView(commandView)

        selectedAction = commandView.action

        commandState = commandStateChange

        previousMenuSender = commandView
    end

    return true
end

function toggleAddCommandMenu(sender)
    toggleCommandMenu(sender)
    commandState = commandStateAdd

    deleteMenuAction.imageName = "interface/deleteBW.png"
    deleteMenuAction.shouldAnimateTap = false
    deleteMenuAction:updateImage()

    return true
end

function toggleSuperactionMenu(commandView)
    if previousSuperMenuSender == commandView then
        dismissSuperCommandMenu(commandView)
        previousSuperMenuSender = nil
    else
        dismissCommandMenu(commandView)

        if superactionMenu.superview ~= view then
            view:addSubview(superactionMenu)
        end

        superactionMenu.x = commandView.relativeX

        commandState = commandStateEdit

        previousSuperMenuSender = commandView
        currentSuperaction = commandView.action
    end

    return true
end

function moveIndicatorToView(commandView)
    previousMenuSender = commandView
    commandView:updateRelativeCoordinates()
    commandMenuIndicator:centerXInView(commandView)
end

function commandMoveRightAction(commandView)
    local moveAction = MoveAction:new()

    if commandState == commandStateAdd then
        addAction(moveAction)
    elseif commandState == commandStateChange then
        changeAction(selectedAction, moveAction)
        selectedAction = moveAction
    end
end

function commandMoveLeftAction(commandView)
    local moveAction = MoveAction:new({
        direction = moveLeft
        })
    
    if commandState == commandStateAdd then
        addAction(moveAction)
    elseif commandState == commandStateChange then
        changeAction(selectedAction, moveAction)
        selectedAction = moveAction
    end
end

function commandMoveUpAction(commandView)
    local moveAction = MoveAction:new({
        direction = moveUp
        })
    
    if commandState == commandStateAdd then
        addAction(moveAction)
    elseif commandState == commandStateChange then
        changeAction(selectedAction, moveAction)
        selectedAction = moveAction
    end
end

function commandMoveDownAction(commandView)
    local moveAction = MoveAction:new({
        direction = moveDown
        })
    
    if commandState == commandStateAdd then
        addAction(moveAction)
    elseif commandState == commandStateChange then
        changeAction(selectedAction, moveAction)
        selectedAction = moveAction
    end
end

function commandAttackAction(commandView)
    local attackAction = AttackAction:new()
    
    if commandState == commandStateAdd then
        addAction(attackAction)
    elseif commandState == commandStateChange then
        changeAction(selectedAction, attackAction)
        selectedAction = attackAction
    end
end

function commandLoopAction(commandView)
    local loopAction = LoopAction:new()
    
    if commandState == commandStateAdd then
        addAction(loopAction)

        local firstAction = loopAction.subactions[1] 
        selectedAction = firstAction

        moveIndicatorToView(firstAction.view)

        currentSuperaction = loopAction
    end
    -- elseif commandState == commandStateChange then
    --     changeAction(selectedAction, loopAction)
    --     selectedAction = loopAction
    -- end
end

function deleteCommand(deleteView)
    deleteAction(selectedAction)
    local addAction = actions[getSize(actions)].view
    moveIndicatorToView(addAction)
    previousMenuSender = addAction
    selectedAction = addAction
    commandState = commandStateAdd
end

function goButtonPressed(sender)
    if appState == stateEditing then
        beginRunningActions()
    else
        finishActions()

        actionAnimations = {}
    end
end

function beginRunningActions()
    appState = stateRunning

    startActions()

    goButton.imageName = "interface/stop.png"
    goButton:updateImage()

    dismissCommandMenu()
    dismissSuperCommandMenu()
end

function increaseSuperaction()
    currentSuperaction:increaseSize()
end

function decreaseSuperaction()
    currentSuperaction:decreaseSize()
end

function leftSuperaction()
    currentSuperaction:decreaseIterations()
end

function rightSuperaction()
    currentSuperaction:increaseIterations()
end

function deleteMenuSuperaction()
    deleteSuperaction()
    dismissSuperCommandMenu()
    currentSuperaction = nil

    local addAction = actions[getSize(actions)].view
    moveIndicatorToView(addAction)
    previousMenuSender = addAction
    selectedAction = addAction
    commandState = commandStateAdd
end




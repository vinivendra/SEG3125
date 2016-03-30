
previousMenuSender = nil

function dismissCommandMenu(sender)
    commandMenu:removeFromSuperview()
    return true
end

function toggleCommandMenu(commandView)

    if previousMenuSender == commandView then
        dismissCommandMenu(commandView)
        previousMenuSender = nil
    else

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

    return true
end

function moveIndicatorToView(view)
    commandMenuIndicator.x = view.x
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
    end
    -- elseif commandState == commandStateChange then
    --     changeAction(selectedAction, loopAction)
    --     selectedAction = loopAction
    -- end
end

function deleteCommand(deleteView)
    deleteAction(selectedAction)
end

function goButtonPressed(sender)
    if appState == stateEditing then
        appState = stateRunning

        startActions()

        goButton.imageName = "interface/stop.png"
        goButton:updateImage()
    else
        appState = stateEditing
        actionAnimations = {}

        goButton.imageName = "interface/go.png"
        goButton:updateImage()
    end
end


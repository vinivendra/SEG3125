
function dismissCommandMenu(sender)
    commandMenu:removeFromSuperview()
end

function toggleCommandMenu(commandView)
    if commandMenu.superview == view then
        dismissCommandMenu(commandView)    
    else
        view:addSubview(commandMenu)

        selectedAction = commandView.action
    end

    commandState = commandStateChange

    return true
end

function toggleAddCommandMenu(sender)
    toggleCommandMenu(sender)
    commandState = commandStateAdd

    return true
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





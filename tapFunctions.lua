
function dismissCommandMenu(sender)
    commandMenu:removeFromSuperview()
end

function toggleCommandMenu(commandView)
    if commandMenu.superview == view then
        dismissCommandMenu(commandView)    
    else
        view:addSubview(commandMenu)
    end

    return true
end

function addMoveRightAction(commandView)
    local moveAction = MoveAction:new()
    addAction(moveAction)
end

function addMoveLeftAction(commandView)
    local moveAction = MoveAction:new({
        direction = moveLeft
        })
    addAction(moveAction)
end

function addMoveUpAction(commandView)
    local moveAction = MoveAction:new({
        direction = moveUp
        })
    addAction(moveAction)
end

function addMoveDownAction(commandView)
    local moveAction = MoveAction:new({
        direction = moveDown
        })
    addAction(moveAction)
end

function addAttackAction(commandView)
    local attackAction = AttackAction:new()
    addAction(attackAction)
end





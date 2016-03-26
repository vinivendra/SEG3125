
function toggleCommandMenu(commandView)
    print("toggleCommandMenu")
    if commandMenu.superview == view then
        commandMenu:removeFromSuperview()
    else
        view:addSubview(commandMenu)
    end

    return true
end

function addMoveAction(commandView)
    local moveAction = MoveAction:new()
    addAction(moveAction)
    toggleCommandMenu()
end

-- TODO: Stop fors in fors

screenWidth = 0
screenHeight = 0

--
view = nil

player = nil
mapView = nil

--
stateEditing = 0
stateRunning = 1

appState = stateEditing

--
tileSize = 180

commandBar = nil
commandMenu = nil
commandMenuIndicator = nil

superactionMenu = nil

goButton = nil

deleteMenuAction = nil
attackMenuAction = nil
loopMenuAction = nil
conditionMenuAction = nil

--
selectedAction = nil

commandStateAdd = 0
commandStateChange = 1
commandStateEdit = 2
commandState = commandStateAdd

--
nextMapState = nil
mapStateIndex = 1

----------------------------------------------------------------

require 'array'

require 'views'

require 'animations'

require 'actions'

require 'tapFunctions'

require 'mapState'
require 'mapStates'

----------------------------------------------------------------



function love.update(dt)
    runAnimations(dt)
    runActions(dt)
end

function love.load()
    screenWidth  = love.graphics.getWidth()
    screenHeight = love.graphics.getHeight()

    view = View:new({
        name = "Window",
        x = 0,
        y = 0,
        width = screenWidth,
        height = screenHeight
        })
    view.onTap = dismissUI

    ----------------------------------

    currentMapState = mapState1
    nextMapState = mapState2

    ----------------------------------

    mapView = currentMapState:createView()
    view:addSubview(mapView)

    --
    player = ImageView:new({
        width = tileSize,
        height = tileSize,
        x = currentMapState.playerOffset[1],
        y = currentMapState.playerOffset[2],
        imageName = "individuals/linkRight.png",
        shouldAnimateTap = false
        })
    mapView:addSubview(player)

    ----------------------------------

    superactionMenu = ImageView:new({
        name = "superactionMenu",
        imageName = "interface/menuCommandBG.png",
        width = 363,
        height = 524,
        y = 900 - 524
        })
    local superactionMinus = ImageView:new({
        name = "superaction Menu minus",
        imageName = "interface/menuCommandBGMinus.png",
        width = 181,
        height = 151,
        onTap = decreaseSuperaction
        })
    superactionMenu:addSubview(superactionMinus)

    local superactionPlus = ImageView:new({
        name = "superaction Menu plus",
        imageName = "interface/menuCommandBGPlus.png",
        width = 182,
        height = 151,
        x = 182,
        onTap = increaseSuperaction
        })
    superactionMenu:addSubview(superactionPlus)

    local superactionLeft = ImageView:new({
        name = "superaction Menu left",
        imageName = "interface/menuCommandBGLeft.png",
        width = 130,
        height = 185,
        y = 151,
        onTap = leftSuperaction
        })
    superactionMenu:addSubview(superactionLeft)

    local superactionRight = ImageView:new({
        name = "superaction Menu right",
        imageName = "interface/menuCommandBGRight.png",
        width = 130,
        height = 185,
        y = 151,
        x = 233,
        onTap = rightSuperaction
        })
    superactionMenu:addSubview(superactionRight)

    local superactionDelete = ImageView:new({
        name = "superaction Menu Delete",
        imageName = "interface/menuCommandBGDelete.png",
        width = 363,
        height = 159,
        y = 336,
        onTap = deleteMenuSuperaction
        })
    superactionMenu:addSubview(superactionDelete)

    superactionMenu.superactionNumber = ImageView:new({
        name = "superaction Menu Number",
        imageName = "interface/repeatX3.png",
        width = 110,
        height = 110,
        x = 127,
        y = 185,
        onTap = deleteMenuSuperaction
        })
    superactionMenu:addSubview(superactionMenu.superactionNumber)

    commandBar = SquareView:new({
        name = "command bar",
        y = 900,
        width = 1920,
        height = 180,
        color = {237, 241, 242}
        })
    view:addSubview(commandBar)

    local indicatorHeight = 28

    local commandMenuMargin = 20
    commandMenu = SquareView:new({
        name = "command menu",
        width = 1920 - 2 * commandMenuMargin,
        height = 180,
        color = {237, 241, 242},
        y = 900 - 180 - indicatorHeight,
        x = commandMenuMargin,
        cornerRadius = 20,
        onTap = doNothing
        })

    commandMenuIndicator = ImageView:new({
        name = "commandMenuIndicator",
        imageName = "interface/triangleMenu.png",
        color = {255, 255, 255},
        width = 63,
        height = indicatorHeight,
        y = commandMenu.height,
        x = 100
        })
    commandMenu:addSubview(commandMenuIndicator)

    local deleteWidth = 180
    local deleteBorder = 30
    local commandWidth = 180

    local separator = SquareView:new({
        width = 2,
        height = commandBar.height,
        x = deleteWidth - deleteBorder
        })
    commandMenu:addSubview(separator)

    local deleteButton = SquareView:new({
        width = deleteWidth,
        height = 180,
        onTap = deleteCommand,
        color = {0, 0, 100, 0}
        })
    commandMenu:addSubview(deleteButton)

    deleteMenuAction = ImageView:new({
        width = 60,
        height = 75,
        x = (deleteWidth - deleteBorder) / 2 - 30,
        y = 90 - 75/2,
        imageName = "interface/delete.png"
        })
    commandMenu:addSubview(deleteMenuAction)

    --
    local menuView1 = MoveAction:new():createView()
    menuView1.onTap = commandMoveRightAction
    menuView1.x = deleteWidth
    commandMenu:addSubview(menuView1)

    local menuView2 = MoveAction:new({
        direction = moveLeft
        }):createView()
    menuView2.action = nil
    menuView2.onTap = commandMoveLeftAction
    menuView2.x = deleteWidth + commandWidth * 1
    commandMenu:addSubview(menuView2)

    local menuView3 = MoveAction:new({
        direction = moveUp
        }):createView()
    menuView3.action = nil
    menuView3.onTap = commandMoveUpAction
    menuView3.x = deleteWidth + commandWidth * 2
    commandMenu:addSubview(menuView3)

    local menuView4 = MoveAction:new({
        direction = moveDown
        }):createView()
    menuView4.action = nil
    menuView4.onTap = commandMoveDownAction
    menuView4.x = deleteWidth + commandWidth * 3
    commandMenu:addSubview(menuView4)

    attackMenuAction = AttackAction:new({
        }):createView()
    attackMenuAction.action = nil
    attackMenuAction.onTap = commandAttackAction
    attackMenuAction.x = deleteWidth + commandWidth * 4
    commandMenu:addSubview(attackMenuAction)

    loopMenuAction = ImageView:new({
        imageName = "interface/repeatBig.png",
        width = 140,
        height = 140,
        y = 20
        })
    loopMenuAction.action = nil
    loopMenuAction.onTap = commandLoopAction
    loopMenuAction.x = deleteWidth + commandWidth * 5
    commandMenu:addSubview(loopMenuAction)

    ----------------------------------

    commandAdd = AddCommandAction:new()
    actions = {commandAdd}
    commandBar:addSubview(commandAdd.view)
    commandAdd.view.onTap = toggleAddCommandMenu

    goButton = ImageView:new({
        name = "go button",
        imageName = "interface/go.png",
        x = 1920 - 180,
        height = 180,
        width = 180,
        onTap = goButtonPressed
        })
    commandBar:addSubview(goButton)

    ----------------------------------

    if currentMapState.attackEnabled then
        attackMenuAction.color = {255, 255, 255, 255}
        attackMenuAction.onTap = commandAttackAction
    else
        attackMenuAction.color = {0, 0, 0, 0}
        attackMenuAction.onTap = nil
    end

    if currentMapState.loopEnabled then
        loopMenuAction.color = {255, 255, 255, 255}
        loopMenuAction.onTap = commandLoopAction
    else
        loopMenuAction.color = {0, 0, 0, 0}
        loopMenuAction.onTap = nil
    end

    ----------------------------------



    -- temp
    -- startActions()
end
 
function love.draw()
   view:draw()
end

function love.mousepressed( x, y, button, istouch )
    view:tapBegan(x, y)
end

function love.mousereleased( x, y, button, istouch )
    view:tap(x, y)
end




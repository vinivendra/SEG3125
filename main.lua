
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
tileSize = 200

commandBar = nil
commandMenu = nil

goButton = nil

--
selectedAction = nil

commandStateAdd = 0
commandStateChange = 1
commandState = commandStateAdd


----------------------------------------------------------------

require 'array'

require 'view'
require 'mapView'
require 'imageView'
require 'squareView'

require 'animation'

require 'action'

require 'tapFunctions'

require 'mapState'

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
    view.onTap = dismissCommandMenu

    ----------------------------------

    currentMapState = MapState:new()

    ----------------------------------

    -- wallWidth = 180
    -- wallHeight = 125
    -- wallView = SquareView:new({
    --     name = "map container",
    --     color = {18, 117, 92},
    --     width = 1560 + 2 * wallWidth,
    --     height = 650 + 2 * wallHeight
    --     })

    -- mapView = MapView:new({
    --     x = wallWidth,
    --     y = wallHeight
    --     })

    -- wallView: addSubview(mapView)
    -- view:addSubview(wallView)

    mapView = ImageView:new({
        name = "map view",
        width = 1920,
        height = 900,
        imageName = currentMapState.imageName
        })
    view:addSubview(mapView)

    --
    player = ImageView:new({
        width = tileSize,
        height = tileSize,
        x = currentMapState.playerOffset[1],
        y = currentMapState.playerOffset[2],
        imageName = "individuals/linkRight.png",
        })
    mapView:addSubview(player)

    ----------------------------------

    commandBar = SquareView:new({
        name = "command bar",
        y = 900,
        width = 1920,
        height = 180,
        color = {237, 241, 242}
        })
    view:addSubview(commandBar)

    commandMenu = SquareView:new({
        name = "command menu",
        width = 1200,
        height = 180,
        color = {237, 241, 242},
        y = 700,
        x = 20
        })

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

    local deleteImage = ImageView:new({
        width = 60,
        height = 75,
        x = (deleteWidth - deleteBorder) / 2 - 30,
        y = 90 - 75/2,
        imageName = "interface/delete.png"
        })
    commandMenu:addSubview(deleteImage)

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

    local menuView5 = AttackAction:new({
        }):createView()
    menuView5.action = nil
    menuView5.onTap = commandAttackAction
    menuView5.x = deleteWidth + commandWidth * 4
    commandMenu:addSubview(menuView5)

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

    -- temp
    -- startActions()
end
 
function love.draw()
   view:draw()
end

function love.mousereleased( x, y, button, istouch )
    view:tap(x, y)
end




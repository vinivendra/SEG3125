
screenWidth = 0
screenHeight = 0

--
view = nil

player = nil
mapView = nil

--
stateEditing = 0
stateRunning = 1

state = stateEditing

--
tileSize = 130

commandBar = nil
commandMenu = nil

goButton = nil

selectedAction = nil


----------------------------------------------------------------

require 'array'

require 'view'
require 'mapView'
require 'imageView'
require 'squareView'

require 'animation'

require 'action'

require 'tapFunctions'

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

    wallWidth = 180
    wallHeight = 125
    wallView = SquareView:new({
        name = "map container",
        color = {18, 117, 92},
        width = 1560 + 2 * wallWidth,
        height = 650 + 2 * wallHeight
        })

    mapView = MapView:new({
        x = wallWidth,
        y = wallHeight,
        })

    wallView: addSubview(mapView)
    view:addSubview(wallView)

    --
    player = ImageView:new({
        width = tileSize,
        height = tileSize,
        imageName = "linkRight.png",
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

    local menuView1 = MoveAction:new():createView()
    menuView1.onTap = addMoveRightAction
    commandMenu:addSubview(menuView1)

    local menuView2 = MoveAction:new({
        direction = moveLeft
        }):createView()
    menuView2.onTap = addMoveLeftAction
    menuView2.x = 190
    commandMenu:addSubview(menuView2)

    local menuView3 = MoveAction:new({
        direction = moveUp
        }):createView()
    menuView3.onTap = addMoveUpAction
    menuView3.x = 380
    commandMenu:addSubview(menuView3)

    local menuView4 = MoveAction:new({
        direction = moveDown
        }):createView()
    menuView4.onTap = addMoveDownAction
    menuView4.x = 570
    commandMenu:addSubview(menuView4)

    local menuView5 = AttackAction:new({
        }):createView()
    menuView5.onTap = addAttackAction
    menuView5.x = 760
    commandMenu:addSubview(menuView5)

    ----------------------------------

    commandAdd = AddCommandAction:new()
    actions = {commandAdd}
    commandBar:addSubview(commandAdd.view)
    commandAdd.view.onTap = toggleCommandMenu

    goButton = ImageView:new({
        name = "go button",
        imageName = "go.png",
        x = 1920 - 180,
        height = 180,
        width = 180,
        onTap = startActions
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

function changeState(newValue)
    state = newValue
end





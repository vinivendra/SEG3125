
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

----------------------------------------------------------------

require 'array'

require 'view'
require 'mapView'
require 'imageView'
require 'squareView'

require 'animation'

require 'action'

----------------------------------------------------------------

function love.update(dt)
    runAnimations(dt)
    runActions(dt)
end

function love.load()
    screenWidth  = love.graphics.getWidth()
    screenHeight = love.graphics.getHeight()

    view = View:new({
        name = "view",
        x = 0,
        y = 0,
        width = screenWidth,
        height = screenHeight
        })

    ----------------------------------

    wallWidth = 180
    wallHeight = 125
    wallView = SquareView:new({
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
        imageName = "link1.png"
        })
    mapView:addSubview(player)

    ----------------------------------

    commandBar = SquareView:new({
        y = 900,
        width = 1920,
        height = 180,
        color = {237, 241, 242}
        })
    view:addSubview(commandBar)

    ----------------------------------

    -- action1 = MoveAction:new({
    --     direction = moveRight
    --     })
    -- action2 = MoveAction:new({
    --     direction = moveDown
    --     })
    -- addAction(action1)
    -- addAction(action2)

    startActions()
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


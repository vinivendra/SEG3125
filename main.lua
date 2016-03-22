
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
tileSize = 66.6666

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

    mapView = MapView:new()
    view:addSubview(mapView)

    player = SquareView:new({
        width = tileSize,
        height = tileSize
        })
    mapView:addSubview(player)

    ----------------------------------

    -- animation1 = MoveAnimation:new({
    --     subject = player,
    --     destinationX = 500,
    --     destinationY = 0,
    --     timingFunction = easeIn
    --     })

    -- animation2 = MoveAnimation:new({
    --     subject = player,
    --     destinationX = 500,
    --     destinationY = 300,
    --     timingFunction = easeOut
    --     })

    -- animation1:chain(animation2)

    -- startAnimation(animation1)

    action1 = MoveAction:new({
        direction = moveRight
        })
    action2 = MoveAction:new({
        direction = moveDown
        })
    addAction(action1)
    addAction(action2)

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


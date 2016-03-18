
require 'array'
require 'view'
require 'animation'
require 'mapView'
require 'imageView'
require 'squareView'

----------------------------------------------------------------

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


function love.update(dt)
    runAnimations(dt)


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

    mapView = MapView:new({
        })
    view:addSubview(mapView)

    player = SquareView:new({
        width = tileSize,
        height = tileSize
        })
    mapView:addSubview(player)

    ----------------------------------

    animation1 = OriginAnimation:new({
        subject = player,
        destinationX = 500,
        destinationY = 0
        })

    animation2 = OriginAnimation:new({
        subject = player,
        destinationX = 500,
        destinationY = 300
        })

    animation1:chain(animation2)

    startAnimation(animation1)
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


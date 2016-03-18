
require 'array'
require 'view'
require 'animation'

----------------------------------------------------------------

screenWidth = 0
screenHeight = 0


view = nil

square = nil
otherSquare = nil


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

    otherSquare = SquareView:new({
        name = "otherSquare",
        color = {100, 0, 0},
        x = 10,
        y = 10,
        width = 30,
        height = 30,
        })

    --
    square = SquareView:new({
        name = "square",
        x = 100,
        y = 100
        })

    square:addSubview(otherSquare)

    view:addSubview(square)

    square.onTap = function (self)
        print("hueeeeeeee")
    end

    ----------------------------------

    -- animation = OriginAnimation:new({
    --     subject = square,
    --     destinationX = 300,
    --     destinationY = 200,
    --     duration = 3
    --     })

    -- startAnimation(animation)
end
 
function love.draw()
   view:draw()
end

function love.mousereleased( x, y, button, istouch )
    view:tap(x, y)
end


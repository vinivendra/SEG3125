
local View = require 'view'

square = View:new()
otherSquare = View:new()


function love.update(dt)
end

function love.load()
    square.name = "square"
    otherSquare.name = "otherSquare"

    otherSquare.color = {100, 0, 0}

    square.x = 100
    square.y = 100

    otherSquare.x = 10
    otherSquare.y = 10
    otherSquare.width = 30
    otherSquare.height = 30

    square:addSubview(otherSquare)
end
 
function love.draw()
   square:draw()
end



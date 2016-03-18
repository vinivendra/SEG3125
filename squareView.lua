require 'view'

-- SquareView: View class ---------------------------------------

SquareView = View:new({
  color = {45, 146, 153}
  })

function SquareView:new(o)
    o = o or {}   -- create object if user does not provide one    
    setmetatable(o, self)
    self.__index = self

    o:init()

    return o
end

function SquareView:copy()
    newCopy = SquareView:new()
    self:copyTo(newCopy)
    return newCopy
end

function SquareView:copyTo(o)
    View.copyTo(self, o)
    o.color = {self.color[1], self.color[2], self.color[3]}
end

function SquareView:draw()
    color = self.color
    if color == nil then
        color = {255, 255, 255}
    end
    love.graphics.setColor(color)

    x = self.x
    y = self.y

    if self.superview ~= nil then
        x = x + self.superview.x
        y = y + self.superview.y
    end

    love.graphics.rectangle("fill", x, y, self.width, self.height)    

    View.draw(self)
end


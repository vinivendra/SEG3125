
require 'views/view'

-- SquareView: View class ---------------------------------------

SquareView = View:new({
  color = {45, 146, 153},
  cornerRadius = 0,
  shouldAnimateTap = false
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

    self:updateRelativeCoordinates()

    love.graphics.rectangle("fill",
        self.relativeX, self.relativeY,
        self.width, self.height,
        self.cornerRadius, self.cornerRadius)

    View.draw(self)
end

function SquareView:animateTap()
    if self.color[3] ~= nil then
        self.color[1] = self.color[1] * 0.8
        self.color[2] = self.color[2] * 0.8
        self.color[3] = self.color[3] * 0.8
    end

    self.isAnimatingTap = true
end

function SquareView:deAnimateTap()
    if self.isAnimatingTap == false then
        return
    end

    if self.color[3] ~= nil then
        self.color[1] = self.color[1] / 0.8
        self.color[2] = self.color[2] / 0.8
        self.color[3] = self.color[3] / 0.8
    end
end



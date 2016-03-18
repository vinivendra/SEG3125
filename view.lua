
require 'array'

function setColor(color)
    love.graphics.setColor(color[1], color[2], color[3])
end

function pointIsInView(x, y, view)
    return x >= view.x and
           y >= view.y and
           x <= view.x + subview.width and
           y <= view.y + subview.height
end  

-- View class ---------------------------------------------------

View = {
    x = 0, y = 0,
    width = 100, height = 100,
    subviews = {},
    superview = nil,
    name = "",
    onTap = nil
}

function View:new(o)
    o = o or {}   -- create object if user does not provide one
    setmetatable(o, self)
    self.__index = self

    o.subviews = {}

    return o
end

function View:draw()
    for i=1,table.getn(self.subviews) do
        subview = self.subviews[i]
        subview:draw()
    end
end

function View:addSubview(subview)
    push(self.subviews, subview)
    subview.superview = self
end

function View:removeFromSuperview()
    removeElement(self.superview.subviews, self)
end

function View:tap(x, y)
    triggered = false

    for i=1,table.getn(self.subviews) do
        subview = self.subviews[i]

        if pointIsInView(x, y, subview) then
            result = subview:tap(x - subview.x, y - subview.y)
            triggered = triggered or result
        end
    end

    if triggered == false then
        if self.onTap ~= nil then
            self:onTap()
            triggered = true
        end
    end

    return triggered
end

-- SquareView: View class ---------------------------------------

SquareView = View:new({
  color = {45, 146, 153}
  })

function SquareView:new(o)
    o = o or {}   -- create object if user does not provide one    
    setmetatable(o, self)
    self.__index = self

    o.subviews = {}

    return o
end

function SquareView:draw()
    setColor(self.color)

    x = self.x
    y = self.y

    if self.superview ~= nil then
        x = x + self.superview.x
        y = y + self.superview.y
    end

    love.graphics.rectangle("fill", x, y, self.width, self.height)    

    for i=1,table.getn(self.subviews) do
        self.subviews[i]:draw()
    end
end




require 'array'

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

function View:init()
    self.subviews = {}
end    

function View:new(o)
    o = o or {}   -- create object if user does not provide one
    setmetatable(o, self)
    self.__index = self

    o:init()

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

    o:init()

    return o
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

-- ImageView: View class ---------------------------------------

ImageView = View:new({
  image = nil,
  imageName = nil,
  scaleX = 1,
  scaleY = 1
  })

function ImageView:new(o)
    o = o or {}   -- create object if user does not provide one    
    setmetatable(o, self)
    self.__index = self

    if o.imageName ~= nil then
        o.image = love.graphics.newImage(o.imageName)

        o.scaleX = o.width  / o.image:getWidth()
        o.scaleY = o.height / o.image:getHeight()
    end

    o:init()

    return o
end

function ImageView:draw()
    if self.image == nil then
        SquareView.draw(self)
        return
    end

    x = self.x
    y = self.y

    if self.superview ~= nil then
        x = x + self.superview.x
        y = y + self.superview.y
    end

    love.graphics.setColor({255, 255, 255})
    love.graphics.draw(self.image, x, y, 0, 
        self.scaleX, self.scaleY, 0, 0, 0, 0)    

    View.draw(self)
end




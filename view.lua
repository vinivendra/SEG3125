
View = {
  x = 0, y = 0,
  width = 100, height = 100,
  color = {45, 146, 153},
  subviews = {},
  superview = nil,
  name= ""
}

function setColor(color)
    love.graphics.setColor(color[1], color[2], color[3])
end

function View:draw()
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

function View:addSubview(subview)
    size = table.getn(self.subviews)
    self.subviews[size + 1] = subview
    subview.superview = self
end

function View:new(o)
    o = o or {}   -- create object if user does not provide one
    setmetatable(o, self)
    self.__index = self

    o.subviews = {}

    return o
end



return View
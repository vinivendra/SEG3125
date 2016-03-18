require 'view'

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

    o:init()

    if o.imageName ~= nil then
        o.image = love.graphics.newImage(o.imageName)

        o.scaleX = o.width  / o.image:getWidth()
        o.scaleY = o.height / o.image:getHeight()
    end

    return o
end

function ImageView:copy()
    newCopy = ImageView:new({
        imageName = self.imageName
        })
    self:copyTo(newCopy)
    return newCopy
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

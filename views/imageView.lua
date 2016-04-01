
require 'views/view'

-- ImageView: View class ---------------------------------------

ImageView = View:new({
  image = nil,
  imageName = nil,
  scaleX = 1,
  scaleY = 1,
  color = {255, 255, 255}
  })

function ImageView:new(o)
    o = o or {}   -- create object if user does not provide one    
    setmetatable(o, self)
    self.__index = self

    o:init()

    o.color = {255, 255, 255}

    o:updateImage()

    return o
end

function ImageView:updateImage()
    if self.imageName ~= nil then
        self.image = love.graphics.newImage("resources/img/" .. self.imageName)

        self.scaleX = self.width  / self.image:getWidth()
        self.scaleY = self.height / self.image:getHeight()
    end
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

    self:updateRelativeCoordinates()

    love.graphics.setColor(self.color)
    love.graphics.draw(self.image, self.relativeX, self.relativeY, 0, 
        self.scaleX, self.scaleY, 0, 0, 0, 0)    

    View.draw(self)
end

function ImageView:animateTap()
    if self.shouldAnimateTap == false then
        return
    end

    if self.color[3] ~= nil then
        self.color[1] = self.color[1] * 0.8
        self.color[2] = self.color[2] * 0.8
        self.color[3] = self.color[3] * 0.8
    end

    self.isAnimatingTap = true
end

function ImageView:deAnimateTap()
    if self.isAnimatingTap == false then
        return
    end
    
    if self.color[3] ~= nil then
        self.color[1] = self.color[1] / 0.8
        self.color[2] = self.color[2] / 0.8
        self.color[3] = self.color[3] / 0.8
    end
end





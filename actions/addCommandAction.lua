
require 'actions/action'

--- AddCommandAction: Action class ---------------------

AddCommandAction = Action:new({
    imageView = nil
    })

function AddCommandAction:new(o)
    o = o or {}   -- create object if user does not provide one
    setmetatable(o, self)
    self.__index = self

    if o.view == nil then
        o.view = o:createView()
    end

    return o
end

function AddCommandAction:createView()
    self.view = SquareView:new({
        color = {237, 241, 242},
        name = "add command bg",
        action = self,
        x = 20,
        y = 20,
        width = 140,
        height = 140,
        shouldAnimateTap = true
        })

    self.imageView = ImageView:new({
        name = "add command",
        action = self,
        width = 140,
        height = 140,
        imageName = "interface/emptyBlock.png",
        shouldAnimateTap = false
        })

    self.view:addSubview(self.imageView)

    return self.view
end

function AddCommandAction:colorView()
    self.imageView.imageName = "interface/emptyBlock.png"
    self.imageView:updateImage()
end

function AddCommandAction:bwView()
    self.imageView.imageName = "interface/emptyBlockBW.png"
    self.imageView:updateImage()
end

function AddCommandAction:getAnimation()
    return Animation:new()
end
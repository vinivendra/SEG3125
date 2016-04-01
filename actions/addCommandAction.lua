
require 'actions/action'

--- AddCommandAction: Action class ---------------------

AddCommandAction = Action:new({
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

    local image = ImageView:new({
        name = "add command",
        action = self,
        width = 140,
        height = 140,
        imageName = "interface/emptyBlock.png",
        shouldAnimateTap = false
        })

    self.view:addSubview(image)

    return self.view
end

function AddCommandAction:colorView()
    self.view.imageName = "interface/emptyBlock.png"
    self.view:updateImage()
end

function AddCommandAction:bwView()
    self.view.imageName = "interface/emptyBlockBW.png"
    self.view:updateImage()
end

function AddCommandAction:getAnimation()
    return Animation:new()
end
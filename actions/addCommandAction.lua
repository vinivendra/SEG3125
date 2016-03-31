
require 'action'

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
    self.view = ImageView:new({
        name = "add command",
        action = self,
        x = 20,
        y = 20,
        width = 140,
        height = 140,
        imageName = "interface/emptyBlock.png"
        })
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

require 'action'

--- MoveAction: Action class --------------------------

MoveAction = Action:new({
    direction = moveRight
    })

function MoveAction:new(o)
    o = o or {}   -- create object if user does not provide one
    setmetatable(o, self)
    self.__index = self

    if o.view == nil then
        o.view = o:createView()
    end

    return o
end

function MoveAction:createView()
    self.view = ImageView:new({
        name = "move action",
        x = 20,
        y = 20,
        width = 140,
        height = 140,
        imageName = self.direction[4],
        action = self,
        onTap = toggleCommandMenu
        })
    return self.view
end

function MoveAction:colorView()
    self.view.imageName = self.direction[4]
    self.view:updateImage()

    if self.superaction ~= nil then
        self.superaction:backgroundColorView()
    end
end

function MoveAction:bwView()
    self.view.imageName = self.direction[5]
    self.view:updateImage()

    if self.superaction ~= nil then
        self.superaction:backgroundBwView()
    end
end

function MoveAction:getAnimation()
    local canMove = currentMapState:move(self.direction)

    if canMove then
        local displacementX = self.direction[1] * tileSize
        local displacementY = self.direction[2] * tileSize

        animation = MoveAnimation:new({
            action = self,
            subject = player,
            displacementX = displacementX,
            displacementY = displacementY,
            willStart = self.direction[3]
            })
        return animation
    else
        animation = StopAnimation:new({
            action = self,
            subject = player
            })
        return animation
    end
end

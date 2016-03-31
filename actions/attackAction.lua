
require 'actions/action'

--- AttackAction: Action class --------------------------

AttackAction = Action:new({
    })

function AttackAction:new(o)
    o = o or {}   -- create object if user does not provide one
    setmetatable(o, self)
    self.__index = self

    if o.view == nil then
        o.view = o:createView()
    end

    return o
end

function AttackAction:createView()
    self.view = ImageView:new({
        name = "attack action",
        x = 20,
        y = 20,
        width = 140,
        height = 140,
        imageName = "interface/sword.png",
        action = self,
        onTap = toggleCommandMenu,
        willStart = attackSpriteFunction
        })
    return self.view
end

function AttackAction:colorView()
    self.view.imageName = "interface/sword.png"
    self.view:updateImage()

    if self.superaction ~= nil then
        self.superaction:backgroundColorView()
    end
end

function AttackAction:bwView()
    self.view.imageName = "interface/swordBW.png"
    self.view:updateImage()

    if self.superaction ~= nil then
        self.superaction:backgroundBwView()
    end
end

function AttackAction:getAnimation()
    animation = StopAnimation:new({
        imageName = "individuals/linkRightAttack.png",
        subject = player,
        action = self
    })
    return animation
end
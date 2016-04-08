
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
    local animation = StopAnimation:new({
        imageName = "individuals/linkRightAttack.png",
        subject = player,
        action = self
    })

    for index,entity in ipairs(currentMapState.entities) do
        if entity.monsterPosition ~= nil then
            if entity.monsterPosition[1] <= currentMapState.playerPosition[1] + 1 or
               entity.monsterPosition[1] >= currentMapState.playerPosition[1] - 1 or
               entity.monsterPosition[2] <= currentMapState.playerPosition[1] + 1 or
               entity.monsterPosition[2] >= currentMapState.playerPosition[1] - 1 then
                if entity.isAlive == true then
                    if entity.monsterPosition[2] == currentMapState.playerPosition[2] then
                        animation.imageName = "individuals/linkUpAttack.png"
                    end

                    entity.isAlive = false
                    local animation2 = AlphaAnimation:new({
                        subject = entity,
                        duration = 0.5
                    })
                    animation.with = animation2
                    break
                end
           end
        end
    end



    return animation
end




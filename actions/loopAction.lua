
require 'actions/action'

--- LoopAction: Action class --------------------------

LoopAction = Action:new({
    name = "loopAction",
    iterations = 2,
    size = 1,
    view = nil,
    head = nil,
    icon = nil,
    timesIcon = nil,
    backgroundView = nil,
    backgroundEnd = nil,
    commandAddView = nil,
    subactions = {}
    })

function LoopAction:new(o)
    o = o or {}   -- create object if user does not provide one
    setmetatable(o, self)
    self.__index = self

    if o.view == nil then
        o.view = o:createView()
    end

    return o
end

function LoopAction:addSubaction(newAction)
    newAction.superaction = self
    pushAction(self.subactions, newAction)
    self:layoutSubviews()
end

function LoopAction:removeActionAtIndex(index)
    newAction.superaction = nil
    removeAtIndex(self.subactions, index)
    self:layoutSubviews()
end

function LoopAction:width()
    local size = 1
    if self.size > 0 then
        size = self.size
    end
    return 90 + 20 + 160 * size + 20
end

function LoopAction:layoutSubviews()
    local actionSize = 160

    self.backgroundView.width = 20 + actionSize * self.size

    self.backgroundEnd.x = self.backgroundView.x + self.backgroundView.width
    self.view.width = self.backgroundEnd.x + self.backgroundEnd.width

    self:updateIterationsImage()

    for i=1,getSize(self.subactions) do
        local action = self.subactions[i]
        action.view.hidden = false
        self.view:addSubview(action.view)
        action.view.x = self.backgroundView.x + 20 + (i-1) * actionSize
    end

    local addAction = self.subactions[getSize(self.subactions)]
    if getSize(self.subactions) > self.size then
        addAction:hide()
    else
        addAction:show()
    end
end

function LoopAction:createView()

    self.view = SquareView:new({
        color = {0, 0, 0, 0},
        width = self:width(),
        height = 180
        })

    self.head = ImageView:new({
        name = "loop head",
        x = 20,
        y = 0,
        width = 90,
        height = 180,
        imageName = "interface/commandHeadBG.png",
        action = self,
        onTap = toggleSuperactionMenu,
        shouldAnimateSubviews = true
        })
    self.view:addSubview(self.head)

    self.icon = ImageView:new({
        name = "loop icon",
        x = 10,
        y = 20,
        width = 50,
        height = 50,
        imageName = "interface/repeatSmall.png",
        action = self,
        shouldAnimateTap = false
        })
    self.head:addSubview(self.icon)

    self.timesIcon = ImageView:new({
        name = "loop number",
        x = 10,
        y = 105,
        width = 50,
        height = 50,
        imageName = "interface/repeatX3.png",
        action = self,
        shouldAnimateTap = false
        })
    self.head:addSubview(self.timesIcon)
    
    self.backgroundView = SquareView:new({
        name = "loop background",
        color = {194, 226, 228},
        x = 90,
        width = 140 + 40,
        height = 180
        })
    self.view:addSubview(self.backgroundView)

    self.backgroundEnd = ImageView:new({
        name = "loop background end",
        imageName = "interface/commandTailBG.png",
        x = self.backgroundView.x + self.backgroundView.width,
        width = 3,
        height = 180
        })
    self.view:addSubview(self.backgroundEnd)

    local addCommandAction = AddCommandAction:new({
        superaction = self
        })
    self.subactions = {addCommandAction}

    local commandAddView = addCommandAction.view
    self.commandAddView = commandAddView
    -- commandAddView.name = "loop add"
    commandAddView.onTap = toggleAddCommandMenu
    commandAddView.x = 110
    commandAddView.y = 20
    self.view:addSubview(self.commandAddView)

    --
    self:layoutSubviews()

    return self.view
end

function LoopAction:colorView()
    self.head.imageName = "interface/commandHeadBG.png"
    self.head:updateImage()
    self.icon.imageName = "interface/repeatSmall.png"
    self.icon:updateImage()
    self.timesIcon.color = {255, 255, 255, 255}
    self.backgroundView.color = {194, 226, 228}
    self.backgroundEnd.imageName = "interface/commandTailBG.png"
    self.backgroundEnd:updateImage()
    self.commandAddView.action:colorView()

    for i = 1,getSize(self.subactions) do
        local action = self.subactions[i]
        action:colorView()
    end
end

function LoopAction:backgroundColorView()
    self.head.imageName = "interface/commandHeadBG.png"
    self.head:updateImage()
    self.icon.imageName = "interface/repeatSmall.png"
    self.icon:updateImage()
    self.timesIcon.color = {255, 255, 255, 255}
    self.backgroundView.color = {194, 226, 228}
    self.backgroundEnd.imageName = "interface/commandTailBG.png"
    self.backgroundEnd:updateImage()
    self.commandAddView.action:colorView()
end

function LoopAction:bwView()
    self.head.imageName = "interface/commandHeadBGBW.png"
    self.head:updateImage()
    self.icon.imageName = "interface/repeatSmallBW.png"
    self.icon:updateImage()
    self.timesIcon.color = {10, 10, 10, 255}
    self.backgroundView.color = {210, 210, 210}
    self.backgroundEnd.imageName = "interface/commandTailBGBW.png"
    self.backgroundEnd:updateImage()
    self.commandAddView.action:bwView()

    for i = 1,getSize(self.subactions) do
        local action = self.subactions[i]
        action:bwView()
    end
end

function LoopAction:backgroundBwView()
    self.head.imageName = "interface/commandHeadBGBW.png"
    self.head:updateImage()
    self.icon.imageName = "interface/repeatSmallBW.png"
    self.icon:updateImage()
    self.timesIcon.color = {10, 10, 10, 255}
    self.backgroundView.color = {225, 225, 225}
    self.backgroundEnd.imageName = "interface/commandTailBGBW.png"
    self.backgroundEnd:updateImage()
    self.commandAddView.action:bwView()
end

function LoopAction:getAnimation() 
    local firstAnimation = Animation:new()

    for i=1,self.iterations do
        for j=1,getSize(self.subactions) do
            local subAction = self.subactions[j]
            local animation = subAction:getAnimation()
            firstAnimation:chain(animation)

            if currentMapState:hasFinished() then
                return firstAnimation
            end
        end
    end

    return firstAnimation
end

function LoopAction:increaseSize()
    self.size = self.size + 1
    if layoutFits() == false then
        self.size = self.size - 1
    else
        layoutCommandViews()
    end
end

function LoopAction:decreaseSize()
    if self.size > 1 then
        self.size = self.size - 1
        layoutCommandViews()
    end
end

function LoopAction:increaseIterations()
    if self.iterations < 3 then
        self.iterations = self.iterations + 1
        self:updateIterationsImage()
    end
end

function LoopAction:updateIterationsImage()
    local numberImageName = "interface/repeatX" .. self.iterations .. ".png"
    self.timesIcon.imageName = numberImageName
    self.timesIcon:updateImage()
    superactionMenu.superactionNumber.imageName = numberImageName
    superactionMenu.superactionNumber:updateImage()
end

function LoopAction:decreaseIterations()
    if self.iterations > 1 then
        self.iterations = self.iterations - 1
        self:updateIterationsImage()
    end
end



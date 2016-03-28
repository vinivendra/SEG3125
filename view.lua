
require 'array'

function pointIsInView(x, y, view)
    return x >= view.x and
           y >= view.y and
           x <= view.x + view.width and
           y <= view.y + view.height
end  

-- View class ---------------------------------------------------

View = {
    x = 0, y = 0,
    width = 100, height = 100,
    subviews = {},
    superview = nil,
    name = "",
    onTap = nil
}

function View:init()
    self.subviews = {}
end    

function View:new(o)
    o = o or {}   -- create object if user does not provide one
    setmetatable(o, self)
    self.__index = self

    o:init()

    return o
end

function View:copy()
    newCopy = View:new()
    self:copyTo(newCopy)
    return newCopy
end

function View:copyTo(o)
    o.x = self.x
    o.y = self.y
    o.width = self.width
    o.height = self.height
    o.name = self.name .. " copy"
    o.onTap = self.onTap

    for i=1,getSize(self.subviews) do
        subview = self.subviews[i]
        subviewCopy = subview:copy()
        o:addSubview(subviewCopy)
    end

    if self.superview ~= nil then
        self.superview:addSubview(o)
    end
end

function View:draw()
    for i=1,getSize(self.subviews) do
        subview = self.subviews[i]
        subview:draw()
    end
end

function View:addSubview(subview)
    push(self.subviews, subview)
    subview.superview = self
end

function View:removeFromSuperview()
    if self.superview ~= nil then
        removeElement(self.superview.subviews, self)
        self.superview = nil
    end
end

function View:tap(x, y)
    print("tap", self.name)

    local triggered = false

    for i=getSize(self.subviews),1,-1 do
        local subview = self.subviews[i]

        if subview ~= nil then
            if pointIsInView(x, y, subview) then
                local result = subview:tap(x - subview.x, y - subview.y)
                triggered = triggered or result
            end
        end
    end

    if triggered == false then
        print("trigger!", self.name)        
        print("onTap =", self.onTap)
        if self.onTap ~= nil then
            print("run!")
            self:onTap()
            triggered = true
        end
    end

    return triggered
end


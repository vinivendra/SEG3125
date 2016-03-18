
require 'array'
require 'animation'

function addAction(action) 
    push(actions, action)
end

-- Action class ------------------------------------------------

Action = {
    type = nil,
    animation = nil
}

actions = {}

function Action:new(o)
    o = o or {}   -- create object if user does not provide one
    setmetatable(o, self)
    self.__index = self

    o:init()

    return o
end


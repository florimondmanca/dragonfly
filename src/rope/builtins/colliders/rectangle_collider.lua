local rope = require 'rope'
local geometry = require 'rope.geometry'
local Collider = require 'rope.builtins.colliders._collider'

local Component = Collider:subclass('RectangleCollider')

function Component:initialize(arguments)
    arguments.origin = geometry.Vector(arguments.origin)
    arguments.sizeFrom = arguments.sizeFrom or nil
    if not arguments.sizeFrom then
        self:require(arguments, 'width', 'height')
        arguments.shape = geometry.Rectangle(arguments.width, arguments.height, arguments.origin)
    else
        arguments.shape = geometry.Rectangle()
    end
    arguments.width, arguments.height = nil, nil
    rope.Component.initialize(self, arguments)
end

function Component:awake()
    if self.sizeFrom then
        local source = self.gameObject:getComponent(self.sizeFrom)
        local width, height = source.shape:getDimensions()
        self.shape = geometry.Rectangle(width, height, self.origin)
    end
end


return Component

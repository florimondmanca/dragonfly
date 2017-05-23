local rope = require 'rope'
local geometry = require 'rope.geometry'
local asserts = require 'rope.asserts'
local Collider = require 'rope.builtins.colliders._collider'

local Component = Collider:subclass('RectangleCollider')

----- initializes a rectangle collider
-- you can declare a rectangle collider dimensions by two ways:
-- a) passing 'width' and 'height' arguments
-- or b) passing a script in 'dimsFrom' argument. The corresponding component must have a Rectangle shape.
-- @tparam table origin as {x=<x>, y=<y>}
-- @tparam number width (required if dimsFrom is not given)
-- @tparam number height (required if dimsFrom is not given)
-- @tparam string dimsFrom the script of the component to get the dimensions from
function Component:initialize(arguments)
    arguments.origin = geometry.Vector(arguments.origin)
    arguments.dimsFrom = arguments.dimsFrom or nil
    if not arguments.dimsFrom then
        self:require(arguments, 'width', 'height')
        arguments.shape = geometry.Rectangle(arguments.width, arguments.height, arguments.origin)
    else
        arguments.shape = geometry.Rectangle()
    end
    arguments.width, arguments.height = nil, nil
    rope.Component.initialize(self, arguments)
end

function Component:awake()
    if self.dimsFrom then
        local source = self.gameObject:getComponent(self.dimsFrom)
        asserts.isInstanceOf(geometry.Rectangle, source, 'source shape')
        local width, height = source.shape.width, source.shape.height
        self.shape = geometry.Rectangle(width, height, self.origin)
    end
end


return Component

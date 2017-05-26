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
    if not arguments.dimsFrom then
        self:require(arguments, 'width', 'height')
        arguments.shape = geometry.Rectangle(arguments.width, arguments.height, arguments.origin)
    else
        arguments.shape = geometry.Rectangle(1, 1, arguments.origin)
    end
    arguments.width, arguments.height = nil, nil
    rope.Component.initialize(self, arguments)
    self.collisions = {}
end

function Component:worksWith()
    return self.dimsFrom and {source = {script = self.dimsFrom}} or {}
end

function Component:awake()
    if self.dimsFrom then
        asserts.isInstanceOf(geometry.Rectangle, self.source.shape, 'source shape')
        self.shape = geometry.Rectangle(
            self.source.shape.width,
            self.source.shape.height,
            self.origin
        )
    end
    -- add debug rectangle renderer
    self.gameObject:buildAndAddComponent({
        script = 'rope.builtins.graphics.rectangle_renderer',
        arguments = {
            color = {255, 255, 0},
            mode = 'line',
            width = self.shape.width,
            height = self.shape.height,
            origin = self.shape.origin,
        },
        isDebug = true
    })
end

return Component

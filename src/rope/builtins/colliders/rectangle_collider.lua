local rope = require 'rope'
local geometry = require 'rope.geometry'
local Collider = require 'rope.builtins.colliders._collider'

local Component = Collider:subclass('RectangleCollider')

----- initializes a rectangle collider
-- @tparam number width (required if shapeFrom is not given)
-- @tparam number height (required if shapeFrom is not given)
-- @tparam table origin as {x=<x>, y=<y>}
-- @tparam string shapeFrom the script of a component to get the shape from
-- @tparam bool alignCenter
function Component:initialize(arguments)
    arguments.origin = geometry.Vector(arguments.origin)
    if not arguments.shapeFrom then
        self:require(arguments, 'width', 'height')
    else arguments.width, arguments.height = 1, 1 end

    rope.Component.initialize(self, arguments)
    self.collisions = {}
end

function Component:worksWith()
    return self.shapeFrom and {source = {script = self.shapeFrom}} or {}
end

function Component:awake()
    -- build the rectangle shape
    self.shape = geometry.Rectangle(self.width, self.height, self.origin)
    if self.shapeFrom then self.shape:setFrom(self.source.shape) end
    if self.alignCenter then self.shape:center() end
    self.width, self.height, self.origin = nil, nil, nil
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

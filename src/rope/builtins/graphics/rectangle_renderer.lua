local rope = require 'rope'
local geometry = require 'rope.geometry'

local Component = rope.Component:subclass('RectangleRenderer')

----- initializes a rectangle renderer.
-- @tparam table origin as {x=<x>, y=<y>} (optional)
-- @tparam number width (required if shapeFrom is not given)
-- @tparam number height (required if shapeFrom is not given)
-- @tparam table color the color of the rectangle (optional, default white).
-- @tparam string mode 'fill' or 'line' (optional, default 'fill')
-- @tparam string shapeFrom the script of a component to get the shape from (optional)
-- @tparam bool alignCenter
function Component:initialize(arguments)
    if not arguments.shapeFrom then
        self:require(arguments, 'width', 'height')
    else arguments.width, arguments.height = 1, 1 end

    arguments.origin = geometry.Vector(arguments.origin)
    arguments.color = arguments.color or {255, 255, 255}
    arguments.mode = arguments.mode or 'fill'
    rope.Component.initialize(self, arguments)
end

function Component:worksWith()
    return self.shapeFrom and {source = {script = self.shapeFrom}} or {}
end

function Component:awake()
    -- build the rectangle shape
    self.shape = geometry.Rectangle(self.width, self.height, geometry.Vector(self.origin))
    if self.shapeFrom then self.shape:setFrom(self.source.shape) end
    if self.alignCenter then self.shape:center() end
    self.width, self.height, self.origin = nil, nil, nil
end

function Component:draw()
    local pos = self.gameObject.globalTransform.position
    love.graphics.setColor(self.color)
    love.graphics.rectangle(
        self.mode,
        self.shape.origin.x + pos.x,
        self.shape.origin.y + pos.y,
        self.shape.width * self.gameObject.globalTransform.size.x,
        self.shape.height * self.gameObject.globalTransform.size.y
    )
end

return Component

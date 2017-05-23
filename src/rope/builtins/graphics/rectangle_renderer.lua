local rope = require 'rope'
local geometry = require 'rope.geometry'

local Component = rope.Component:subclass('RectangleRenderer')

----- initializes a rectangle renderer.
-- @tparam number width (required if sizeFrom is false or nil)
-- @tparam number height (required if sizeFrom is false or nil)
-- @tparam table origin as {x=<x>, y=<y>} (optional)
-- @tparam table color the color of the rectangle (optional, default white).
-- @tparam string mode 'fill' or 'line' (optional, default 'fill')
-- @tparam string sizeFrom pass a script to infer width and height from
-- owner's corresponding component
function Component:initialize(arguments)
    if not arguments.sizeFrom then
        self:require(arguments, 'width', 'height')
    end
    arguments.origin = geometry.Vector(arguments.origin)
    arguments.color = arguments.color or {255, 255, 255}
    arguments.mode = arguments.mode or 'fill'
    rope.Component.initialize(self, arguments)
end

function Component:awake()
    -- infer size from a component if necessary
    local sizeFrom = rope.sizeFromDefaults[self.sizeFrom] or self.sizeFrom
    if sizeFrom then
        local component = self.gameObject:getComponent(sizeFrom)
        self.width, self.height = component:getDimensions()
    end
    -- build the rectangle shape
    self.shape = geometry.Rectangle(self.width, self.height, geometry.Vector(self.origin))
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

local rope = require 'rope'

local Component = rope.Component:subclass('RectangleRenderer')

----- initializes a rectangle renderer.
-- @tparam number width (required if sizeFrom is false or nil)
-- @tparam number height (required if sizeFrom is false or nil)
-- @tparam table color the color of the rectangle (default is white).
-- @tparam string mode 'fill' or 'line'.
-- @tparam string sizeFrom pass a script to infer width and height from
-- owner's corresponding component
function Component:initialize(arguments)
    if not arguments.sizeFrom then
        self:require(arguments, 'width', 'height')
    end
    arguments.color = arguments.color or {255, 255, 255}
    arguments.mode = arguments.mode or 'fill'
    rope.Component.initialize(self, arguments)
end

function Component:awake()
    local sizeFrom = rope.sizeFromDefaults[self.sizeFrom] or self.sizeFrom
    if sizeFrom then
        local component = self.gameObject:getComponent(sizeFrom)
        self.width, self.height = component:getDimensions()
    end
end

function Component:draw(debug)
    if not self.isDebug or debug then
        local pos = self.gameObject.globalTransform.position
        love.graphics.setColor(self.color)
        love.graphics.rectangle(self.mode, pos.x, pos.y, self.width, self.height)
    end
end

return Component

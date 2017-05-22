local rope = require 'rope'

local Component = rope.Component:subclass('CircleRenderer')

----- initializes a circle renderer
-- @tparam number radius in pixels (required)
-- @tparam table color color of the circle
-- @tparam string mode 'fill' or 'line'
function Component:initialize(arguments)
    self:require(arguments, 'radius')
    arguments.color = arguments.color or {255, 255, 255}
    arguments.mode = arguments.mode or 'fill'
    rope.Component.initialize(self, arguments)
end

function Component:draw()
    local pos = self.gameObject.globalTransform.position
    love.graphics.setColor(self.color)
    love.graphics.circle(self.mode, pos.x, pos.y, self.radius)
end

return Component

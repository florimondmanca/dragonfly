local rope = require 'rope'
local geometry = require 'rope.geometry'

local Component = rope.Component:subclass('LineRenderer')

----- initializes a edge renderer.
-- points are given relative to the owner's transform position
-- @tparam table point1 as {x=<x>, y=<y>}
-- @tparam table point2 as {x=<x>, y=<y>}
-- @tparam table origin as {x=<x>, y=<y>} (optional)
-- @tparam table color the color of the line (optional, default white).
function Component:initialize(arguments)
    self:require(arguments, 'point1', 'point2')
    arguments.shape = geometry.Edge(geometry.Vector(arguments.point1), geometry.Vector(arguments.point2))
    arguments.color = arguments.color or {255, 255, 255}
    arguments.point1, arguments.point2 = nil, nil
    rope.Component.initialize(self, arguments)
end

function Component:draw()
    local pos = self.gameObject.globalTransform.position
    local x1, y1, x2, y2 = self.shape:coords()
    love.graphics.setColor(self.color)
    love.graphics.line(
        x1 * self.gameObject.globalTransform.size.x + pos.x,
        y1 * self.gameObject.globalTransform.size.y + pos.y,
        x2 * self.gameObject.globalTransform.size.x + pos.y,
        y2 * self.gameObject.globalTransform.size.y + pos.y
    )
end

return Component

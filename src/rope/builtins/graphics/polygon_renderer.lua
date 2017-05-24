local rope = require 'rope'
local geometry = require 'rope.geometry'
local asserts = require 'rope.asserts'

local Component = rope.Component:subclass('LineRenderer')

----- initializes a polygon renderer.
-- points are given relative to the owner's transform position
-- @tparam table points (required)
-- @tparam table origin as {x=<x>, y=<y>} (optional)
-- @tparam string mode 'fill' or 'line' (default 'line')
-- @tparam table color the color of the line (optional, default white).
function Component:initialize(arguments)
    self:require(arguments, 'points')
    asserts.hasType('table', arguments.points, 'points')
    self.shape = geometry.Polygon(arguments.points)
    arguments.mode = arguments.mode or 'line'
    arguments.color = arguments.color or {255, 255, 255}
    arguments.points = nil
    rope.Component.initialize(self, arguments)
end

function Component:draw()
    love.graphics.setColor(self.color)
    love.graphics.polygon(
        'line',
        self.shape:globalCoords(self.gameObject.globalTransform)
    )
end

return Component

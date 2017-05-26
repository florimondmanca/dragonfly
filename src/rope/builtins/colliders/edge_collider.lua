local rope = require 'rope'
local geometry = require 'rope.geometry'
local Collider = require 'rope.builtins.colliders._collider'

local Component = Collider:subclass('EdgeCollider')

----- initializes an edge collider
-- @tparam table origin as {x=<x>, y=<y>}
-- @tparam number width (required if dimsFrom is not given)
-- @tparam number height (required if dimsFrom is not given)
-- @tparam string dimsFrom the script of the component to get the dimensions from
function Component:initialize(arguments)
    self:require(arguments, 'point1', 'point2')
    self.shape = geometry.Edge(geometry.Vector(arguments.point1), geometry.Vector(arguments.point2))
    arguments.point1, arguments.point2 = nil, nil
    rope.Component.initialize(self, arguments)
    self.collisions = {}
end

function Component:awake()
    -- add debug renderer
    self.gameObject:buildAndAddComponent({
        script = 'rope.builtins.graphics.edge_renderer',
        arguments = {
            color = {255, 255, 0},
            point1 = {x=self.shape.point1.x, y=self.shape.point1.y},
            point2 = {x=self.shape.point2.x, y=self.shape.point2.y}
        },
        isDebug = true
    })
end

return Component

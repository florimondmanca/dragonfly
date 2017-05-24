local rope = require 'rope'
local geometry = require 'rope.geometry'
local Collider = require 'rope.builtins.colliders._collider'

local Component = Collider:subclass('CircleCollider')

----- initializes a circle collider
-- @tparam number radius (required)
-- @tparam table center as {x=<x>, y=<y>}
function Component:initialize(arguments)
    self:require(arguments, 'radius')
    arguments.shape = geometry.Circle(arguments.radius, geometry.Vector(arguments.center))
    arguments.radius, arguments.center = nil, nil
    rope.Component.initialize(self, arguments)
    self.collisions = {}
end

function Component:awake()
    -- add debug renderer
    self.gameObject:buildAndAddComponent({
        script = 'rope.builtins.graphics.circle_renderer',
        arguments = {
            color = {255, 255, 0},
            mode = 'line',
            radius = self.shape.radius,
        },
        isDebug = true
    })
end

return Component

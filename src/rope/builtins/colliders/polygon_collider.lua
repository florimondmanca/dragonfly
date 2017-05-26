local rope = require 'rope'
local lume = require 'rope.lib.lume'
local geometry = require 'rope.geometry'
local asserts = require 'rope.asserts'
local Collider = require 'rope.builtins.colliders._collider'

local Component = Collider:subclass('PolygonLineCollider')

----- initializes a polygon line collider
-- a polygon line collider is basically an assembly of contiguous edge colliders
-- @tparam table origin as {x=<x>, y=<y>}
-- @tparam table points (required)
function Component:initialize(arguments)
    self:require(arguments, 'points')
    asserts.hasType('table', arguments.points, 'points')
    self.shape = geometry.Polygon(arguments.points)
    lume.reject(arguments, 'points')
    rope.Component.initialize(self, arguments)
    self.collisions = {}
end

function Component:awake()
    -- add debug renderer
    self.gameObject:buildAndAddComponent({
        script = 'rope.builtins.graphics.polygon_renderer',
        arguments = {
            color = {255, 255, 0},
            points = self.shape:globalVertices(self.gameObject.globalTransform)
        },
        isDebug = true
    })
end

return Component

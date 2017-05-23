local rope = require 'rope'
local asserts = require 'rope.asserts'

-- Tag Component for scrolling camera
local Component = rope.Component:subclass('ScrollCamera')

function Component:initialize(arguments)
    self:require(arguments, 'axis', 'speed')
    asserts.isIn({'x', 'y'}, arguments.axis, 'axis')
    rope.Component.initialize(self, arguments)
end

-- set cameraFunc to move the camera on axis at speed
function Component:awake()
    local onX, onY = self.axis == 'x' and 1 or 0, self.axis == 'y' and 1 or 0
    self.gameObject.cameraFunc = function(camera, _, dt)
        camera:move(onX * self.speed * dt, onY * self.speed * dt)
    end
end

return Component

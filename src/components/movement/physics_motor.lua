local rope = require 'rope'

local Component = rope.Component:subclass('PhysicsMotor')

function Component:initialize(arguments)
    self:require('axis', 'speed')
    arguments.drag = arguments.drag or 1
    rope.Component.initialize(self, arguments)
end

function Component:worksWith()
    return {'components.velocity'}
end

function Component:awake()
    self.velocity = self.gameObject:getComponent('components.velocity')
end

function Component:move(direction)
    local d = direction > 0 and 1 or -1
    local fx = d * (self.axis == 'x' and self.speed or 0) * self.drag
    local fy = d * (self.axis == 'y' and self.speed or 0) * self.drag
    self.velocity:applyForce(fx, fy)
end


return Component

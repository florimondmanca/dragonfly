local Motor = require 'components.movement.motor'

local Component = Motor:subclass('PhysicsMotor')

function Component:initialize(arguments)
    arguments.drag = arguments.drag or 1
    Motor.initialize(self, arguments)
end

function Component:update()
    self.velocity:applyForce(-self.drag * self.velocity.vx, -self.drag * self.velocity.vy)
end

function Component:move(direction)
    local d = direction > 0 and 1 or -1
    local fx = d * (self.axis == 'x' and self.speed or 0) * self.drag
    local fy = d * (self.axis == 'y' and self.speed or 0) * self.drag
    self.velocity:applyForce(fx, fy)
end


return Component

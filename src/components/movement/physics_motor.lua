local Motor = require 'components.movement.motor'

local Component = Motor:subclass('PhysicsMotor')

function Component:initialize(arguments)
    arguments.drag = arguments.drag or 1
    Motor.initialize(self, arguments)
end

function Component:update()
    self.velocity:applyForce(
        self.axis == 'x' and (-self.drag * self.velocity.vx) or 0,
        self.axis == 'y' and (-self.drag * self.velocity.vy) or 0
    )
end

function Component:move(direction)
    local d = direction > 0 and 1 or -1
    local fx = d * (self.axis == 'x' and self.speed * self.drag or 0)
    local fy = d * (self.axis == 'y' and self.speed * self.drag or 0)
    self.velocity:applyForce(fx, fy)
end


return Component

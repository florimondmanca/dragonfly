local Motor = require('components.motor')

local Component = Motor:subclass('PhysicsMotor')

function Component:initialize(arguments)
    arguments.vel = arguments.vel or 0
    arguments.drag = arguments.drag or 1
    Motor.initialize(self, arguments)
    self.force = 0
end

function Component:update(dt)
    self.vel = self.vel * (1 - self.drag * dt) + self.force * dt
    self.force = 0
    self.gameObject.transform.position[self.axis] = self.gameObject.transform.position[self.axis] + self.vel * dt
end

function Component:move(direction)
    if direction > 0 then
        self.force = self.drag * self.speed
    elseif direction < 0 then
        self.force = -self.drag * self.speed
    end
end

return Component

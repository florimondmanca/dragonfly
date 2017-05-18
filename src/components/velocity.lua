local rope = require 'rope'

local Component = rope.Component:subclass('Velocity')

function Component:initialize(arguments)
    arguments.vx = arguments.vx or 0
    arguments.vy = arguments.vy or 0
    arguments.fx, arguments.fy = 0, 0
    rope.Component.initialize(self, arguments)
end

function Component:applyForce(fx, fy)
    self.fx = self.fx + fx or 0
    self.fy = self.fy + fy or 0
end

function Component:update(dt)
    self.vx = self.vx + self.fx * dt
    self.vy = self.vy + self.fy * dt
    self.gameObject:move(self.vx * dt, self.vy * dt)
    self.fx = 0
    self.fy = 0
end

function Component:stopX()
    self.vx = 0
end

function Component:stopY()
    self.vy = 0
end

function Component:stop()
    self:stopX()
    self:stopY()
end


return Component

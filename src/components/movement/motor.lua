local rope = require('rope')

local Component = rope.Component:subclass('Motor')

function Component:initialize(arguments)
    self:require(arguments, 'axis', 'speed')
    rope.Component.initialize(self, arguments)
end

function Component:moveOnAxis(disp)
    local dx = self.axis == 'x' and disp or 0
    local dy = self.axis == 'y' and disp or 0
    self.gameObject:move(dx, dy)
end

function Component:move(direction, dt)
    self:moveOnAxis((direction > 0 and 1 or -1) * self.speed * dt)
end


return Component

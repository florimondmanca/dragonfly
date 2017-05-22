local rope = require('rope')

local Component = rope.Component:subclass('Motor')

function Component:initialize(arguments)
    self:require(arguments, 'axis', 'speed')
    rope.Component.initialize(self, arguments)
end

function Component:worksWith()
    return {velocity = {script = 'components.movement.velocity'}}
end

function Component:move(direction)
    local d = direction > 0 and 1 or -1
    local dx = d * (self.axis == 'x' and self.speed or 0)
    local dy = d * (self.axis == 'y' and self.speed or 0)
    self.velocity:set(dx, dy)
end


return Component

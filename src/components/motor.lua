local rope = require 'rope'

local Component = rope.Component:subclass('Motor')

function Component:initialize(arguments)
    self:validate(arguments, 'axis', 'speed')
    if arguments.axis ~= 'x' and arguments.axis ~= 'y' then
        error('Unknown axis: ' .. arguments.axis)
    end
    rope.Component.initialize(self, arguments)
end

function Component:move(direction, dt)
    if direction > 0 then
        self.gameObject.transform.position[self.axis] = self.gameObject.transform.position[self.axis] + self.speed * dt
    elseif direction < 0 then
        self.gameObject.transform.position[self.axis] = self.gameObject.transform.position[self.axis] - self.speed * dt
    end
end



return Component

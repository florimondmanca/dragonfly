local rope = require 'rope'

local Component = rope.Component:subclass('CircleRenderer')

function Component:initialize(arguments)
    self:validate(arguments, 'radius', 'color')
    rope.Component.initialize(self, arguments)
end

function Component:draw()
    love.graphics.setColor(self.color)
    love.graphics.circle('fill', self.gameObject.transform.position.x,
    self.gameObject.transform.position.y, self.radius)
end

return Component

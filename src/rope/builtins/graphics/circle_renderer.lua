local rope = require 'rope'

local Component = rope.Component:subclass('CircleRenderer')

function Component:initialize(arguments)
    self:require(arguments, 'radius')
    arguments.color = arguments.color or {0, 0, 0}
    arguments.mode = arguments.mode or 'fill'
    rope.Component.initialize(self, arguments)
end

function Component:draw()
    local pos = self.gameObject.globalTransform.position
    love.graphics.setColor(self.color)
    love.graphics.circle(self.mode, pos.x, pos.y, self.radius)
end

return Component

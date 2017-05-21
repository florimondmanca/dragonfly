local rope = require 'rope'

local Component = rope.Component:subclass('RectangleRenderer')

function Component:initialize(arguments)
    self:require(arguments, 'width', 'height')
    arguments.color = arguments.color or {0, 0, 0}
    arguments.mode = arguments.mode or 'fill'
    rope.assertIsPositiveNumber(arguments.width, 'width')
    rope.assertIsPositiveNumber(arguments.height, 'height')
    rope.assertType('string', arguments.mode, 'mode')
    rope.assertTableOfLength({3, 4}, arguments.color)
    rope.Component.initialize(self, arguments)
end

function Component:draw()
    local pos = self.gameObject.globalTransform.position
    love.graphics.setColor(self.color)
    love.graphics.rectangle(self.mode, pos.x, pos.y, self.width, self.height)
end

return Component

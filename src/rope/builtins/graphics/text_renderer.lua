local rope = require 'rope'

local Component = rope.Component:subclass('TextRenderer')

function Component:initialize(arguments)
    arguments.color = arguments.color or {255, 255, 255, 255}
    arguments.text = arguments.text or ''
    rope.Component.initialize(self, arguments)
end

function Component:setText(text)
    self.text = text
end

function Component:draw()
    love.graphics.setColor(self.color)
    local pos = self.gameObject.globalTransform.position
    love.graphics.print(self.text, pos.x, pos.y)
end

return Component

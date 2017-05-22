local rope = require 'rope'

local Component = rope.Component:subclass('TextRenderer')

----- initializes a text renderer
-- @tparam string text an initial text to render (default is empty string)
-- @tparam table color the color of the text (default is white)
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

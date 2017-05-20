local rope = require 'rope'

local Component = rope.Component:subclass('TextRenderer')

function Component:initialize(arguments)
    local text = love.graphics.newText(love.graphics.getFont())
    if arguments.text then text:set(arguments.text) end
    rope.Component.initialize(self, {text=text})
end

function Component:setText(text)
    self.text:set(text)
end

function Component:draw()
    local pos = self.gameObject.globalTransform.position
    love.graphics.draw(self.text, pos.x, pos.y)
end

return Component

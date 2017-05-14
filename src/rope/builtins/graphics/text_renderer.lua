local rope = require 'rope'

local Component = rope.Component:subclass('TextRenderer')

function Component:initialize(arguments, events)
    local size = arguments.fontsize or 12
    -- build Font object
    local font
    if arguments.font then
        font = love.graphics.newFont(arguments.font, size)
    else
        font = love.graphics.newFont(size)
    end
    -- build Text object
    local text = love.graphics.newText(font)
    if arguments.text then text.set(arguments.text) end
    rope.Component.initialize(self, {text=text}, events)
end

function Component:setText(text)
    self.text:set(text)
end

function Component:draw()
    love.graphics.draw(self.text, self.gameObject.transform.position.x, self.gameObject.transform.position.y)
end

return Component

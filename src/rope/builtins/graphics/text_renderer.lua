local rope = require 'rope'
local geometry = require 'rope.geometry'

local Component = rope.Component:subclass('TextRenderer')

----- initializes a text renderer
-- @tparam string text an initial text to render (default is empty string)
-- @tparam number fontSize (optional, default is love's default)
-- @tparam table color the color of the text (default is white)
-- @tparam bool alignCenter
function Component:initialize(arguments)
    arguments.origin = geometry.Vector(arguments.origin)
    arguments.color = arguments.color or {255, 255, 255}
    arguments.text = arguments.text or 'Text'

    rope.Component.initialize(self, arguments)
    -- create font
    self.font =
        arguments.fontSize and love.graphics.newFont(arguments.fontSize)
        or love.graphics.getFont()
    -- create text object
    self.textObject = love.graphics.newText(self.font)
    self:setText()
end

function Component:setText(text)
    self.text = text or self.text
    self.textObject:set(self.text)
    self.shape = geometry.Rectangle(
        self.textObject:getWidth(),
        self.textObject:getHeight(), geometry.Vector(self.origin)
    )
    if self.alignCenter then self.shape:center() end
end

function Component:draw()
    love.graphics.setColor(self.color)
    local pos = self.gameObject.globalTransform.position
    love.graphics.draw(
        self.textObject,
        pos.x + self.shape.origin.x,
        pos.y + self.shape.origin.y
    )
end

return Component

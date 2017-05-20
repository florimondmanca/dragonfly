local rope = require 'rope'

local Component = rope.Component:subclass('ImageRenderer')

function Component:initialize(arguments)
    self:require(arguments, 'filename')
    arguments = {image = love.graphics.newImage(arguments.filename)}
    rope.Component.initialize(self, arguments)
end

function Component:draw()
    local pos = self.gameObject.globalTransform.position
    love.graphics.setColor(255, 255, 255)
    love.graphics.draw(self.image, pos.x, pos.y)
end

return Component

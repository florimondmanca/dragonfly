local rope = require 'rope'

local Component = rope.Component:subclass('ImageRenderer')

----- initializes an image renderer
-- @tparam string filename path to the image file (required)
function Component:initialize(arguments)
    self:require(arguments, 'filename')
    arguments = {image = love.graphics.newImage(arguments.filename)}
    rope.Component.initialize(self, arguments)
end

function Component:getDimensions() return self.image:getDimensions() end

function Component:draw()
    local pos = self.gameObject.globalTransform.position
    love.graphics.setColor(255, 255, 255)
    love.graphics.draw(self.image, pos.x, pos.y)
end

return Component

local rope = require 'rope'
local geometry = require 'rope.geometry'

local Component = rope.Component:subclass('ImageRenderer')

----- initializes an image renderer
-- @tparam string filename path to the image file (required)
function Component:initialize(arguments)
    self:require(arguments, 'filename')
    arguments.origin = geometry.Vector(arguments.origin)
    arguments = {image = love.graphics.newImage(arguments.filename)}
    rope.Component.initialize(self, arguments)
    self.shape = geometry.Rectangle(self.image:getWidth(), self.image:getHeight(), arguments.origin)
end

function Component:draw()
    local pos = self.gameObject.globalTransform.position
    love.graphics.setColor(255, 255, 255)
    love.graphics.draw(
        self.image,
        self.shape.origin.x + pos.x,
        self.shape.origin.y + pos.y
    )
end

return Component

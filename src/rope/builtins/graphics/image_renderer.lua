local rope = require 'rope'

local Component = rope.Component:subclass('ImageRenderer')

function Component:initialize(arguments)
    self:validate(arguments, 'filename')
    arguments = {image = love.graphics.newImage(arguments.filename)}
    rope.Component.initialize(self, arguments)
end

function Component:draw()
    love.graphics.draw(self.image, self.gameObject.transform.position.x,
    self.gameObject.transform.position.y)
end

return Component

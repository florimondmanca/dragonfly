local rope = require 'rope'
local collision = require 'rope.collision'

local Component = rope.Component:subclass('Rectangle')

function Component:initialize(arguments)
    if not arguments.sizeFromImage then
        self:require(arguments, 'width', 'height')
        arguments.sizeFromImage = false
    end
    rope.Component.initialize(self, arguments)
end

function Component:awake()
    if self.sizeFromImage then
        local image = self.gameObject.parent:getComponent(
            'rope.builtins.graphics.image_renderer').image
        self.width = image:getWidth()
        self.height = image:getHeight()
    end
end

function Component:draw(debug)
    if debug then
        local pos = self.gameObject.globalTransform.position
        love.graphics.setColor(255, 255, 255)
        love.graphics.rectangle('line', pos.x, pos.y, self.width, self.height)
    end
end

return Component

local rope = require 'rope'

local Component = rope.Component:subclass('RectangleRenderer')

function Component:initialize(arguments)
    if not arguments.sizeFromImage then
        self:require(arguments, 'width', 'height')
    end
    arguments.color = arguments.color or {255, 255, 255}
    arguments.mode = arguments.mode or 'fill'
    rope.Component.initialize(self, arguments)
end

function Component:awake()
    if self.sizeFromImage then
        local image = self.gameObject:getComponent(
            'rope.builtins.graphics.image_renderer').image
        self.width = image:getWidth()
        self.height = image:getHeight()
    end
end

function Component:draw(debug)
    if not self.isDebug or debug then
        local pos = self.gameObject.globalTransform.position
        love.graphics.setColor(self.color)
        love.graphics.rectangle(self.mode, pos.x, pos.y, self.width, self.height)
    end
end

return Component

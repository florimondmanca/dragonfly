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

return Component

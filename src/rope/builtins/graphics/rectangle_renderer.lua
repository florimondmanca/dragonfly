local rope = require 'rope'

local Component = rope.Component:subclass('RectangleRenderer')

----- initializes a rectangle renderer.
-- @tparam number width (required if sizeFromImage is false or nil)
-- @tparam number height (required if sizeFromImage is false or nil)
-- @tparam table color the color of the rectangle (default is white).
-- @tparam string mode 'fill' or 'line'.
-- @tparam bool sizeFromImage pass true to infer width and height from
-- owner's image (requires the owner to have a
-- rope.builtins.graphics.image_renderer component).
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

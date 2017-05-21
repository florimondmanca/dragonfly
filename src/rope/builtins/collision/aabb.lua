local rope = require 'rope'

local Component = rope.Component:subclass('AABB')

function Component:initialize(arguments)
    if not arguments.sizeFromImage then
        self:require(arguments, 'width', 'height')
        arguments.sizeFromImage = false
    end
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

--- resolves a collision between the owner game object and another game object.
-- callback function: does nothing by default.
-- @tparam GameObject other
function Component:resolve()
    -- callback function
end

function Component:getAABB()
    local pos = self.gameObject.globalTransform.position
    return {x = pos.x, y = pos.y, w = self.width, h = self.height}
end

return Component

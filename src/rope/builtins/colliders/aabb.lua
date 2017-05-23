local rope = require 'rope'
local collision = require 'rope.collision'

local Component = rope.Component:subclass('AABB')

function Component:initialize(arguments)
    if not arguments.dimsFrom then
        self:require(arguments, 'width', 'height')
    end
    arguments.collideGroup = arguments.collideGroup or ''
    rope.Component.initialize(self, arguments)
end

function Component:awake()
    local dimsFrom = rope.dimsFromDefaults[self.dimsFrom] or self.dimsFrom
    if dimsFrom then
        local component = self.gameObject:getComponent(dimsFrom)
        self.width, self.height = component.shape.width, component.shape.height
    end
end

--- resolves a collision between the owner game object and another game object.
-- callback function: does nothing by default.
-- @tparam GameObject other
function Component:resolve()
    -- callback function
end

--- tests if a point is inside the AABB
-- @tparam number x
-- @tparam number y
-- @return true if (x, y) is inside the AABB, false otherwise
function Component:contains(x, y)
    return collision.containsPoint(self:get(), x, y)
end

function Component:get()
    local pos = self.gameObject.globalTransform.position
    return {x = pos.x, y = pos.y, w = self.width, h = self.height}
end

return Component

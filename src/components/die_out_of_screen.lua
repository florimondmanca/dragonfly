local rope = require 'rope'

local Component = rope.Component:subclass('DieOutOfScreen')

function Component:update()
    local pos = self.gameObject.globalTransform.position
    local x, y = pos.x, pos.y
    if x < 0 or x > love.graphics.getWidth() or
    y < 0 or y > love.graphics.getHeight() then
        self.gameObject:destroy()
    end
end

return Component

local rope = require 'rope'

local Component = rope.Component:subclass('DieOutOfScreen')

function Component:update()
    local boundaries = self.gameScene.camera:screenBoundaries()
    local pos = self.gameObject.globalTransform.position
    local x, y = pos.x, pos.y
    if x < boundaries.left or x > boundaries.right or
    y < boundaries.top or y > boundaries.bottom then
        self.gameObject:destroy()
    end
end

return Component

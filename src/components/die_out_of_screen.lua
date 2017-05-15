local rope = require 'rope'

local Component = rope.Component:subclass('DieOutOfScreen')

function Component:update()
    local x, y = self.gameObject.transform.position.x, self.gameObject.transform.position.y
    if x < 0 or x > love.graphics.getWidth() then
        self.gameObject:destroy()
        return
    end
    if y < 0 or y > love.graphics.getHeight() then
        self.gameObject:destroy()
        return
    end
end

return Component

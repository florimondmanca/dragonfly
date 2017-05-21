local rope = require 'rope'

-- If a game object has this component, it will be the camera's target
local Component = rope.Component:subclass('Target')

function Component:update(_, firstUpdate)
    if firstUpdate then
        self.gameScene.camera.target = self.gameObject
    end
end

return Component

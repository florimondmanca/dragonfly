local rope = require 'rope'

-- If a game object has this component, it will be added to the camera's
-- children.
local Component = rope.Component:subclass('CameraLink')

function Component:update(_, firstUpdate)
    if firstUpdate then
        self.gameScene.camera:addChild(self.gameObject)
    end
end

return Component

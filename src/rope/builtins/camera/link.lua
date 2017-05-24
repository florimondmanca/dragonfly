local rope = require 'rope'

-- If a game object has this component, it will be added to the camera's
-- children.
local Component = rope.Component:subclass('CameraLink')

function Component:awake()
    self.gameScene.camera:addChild(self.gameObject)
end

return Component

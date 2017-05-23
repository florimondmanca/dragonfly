local rope = require 'rope'

-- If a game object has this component, it will stick to the mouse's position
local Component = rope.Component:subclass('MouseLink')

function Component:update()
    self.gameObject:moveTo(self.gameScene.camera:mousePosition())
end

return Component

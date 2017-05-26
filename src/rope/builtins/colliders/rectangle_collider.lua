local Collider = require 'rope.builtins.colliders.collider'

local Component = Collider:subclass('RectangleComponent')


----- a collider using the owner's rectangle shape

function Component:worksWith()
    return {source = {script = 'rope.builtins.shapes.rectangle'}}
end

function Component:awake()
    self.shape = self.source.shape
end


return Component

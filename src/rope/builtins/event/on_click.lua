local rope = require 'rope'

local Component = rope.Component:subclass('OnClick')

----- initializes an onClick action
function Component:initialize(arguments)
    arguments.onClick = arguments.onClick or function (self) end
    rope.Component.initialize(self)
    self.onClick = arguments.onClick
end

function Component:worksWith()
    return {collider = {script = 'rope.builtins.colliders._collider'}}
end

function Component:onClick()
    -- callback function
end

return Component

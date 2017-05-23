local rope = require 'rope'

local Component = rope.Component:subclass('OnClick')

----- initializes an onClick action
function Component:initialize(arguments)
    arguments.onClick = arguments.onClick or function (self) end
    rope.Component.initialize(self)
    self.onClick = arguments.onClick
end

function Component:onClick()
    print('hello')
end

return Component

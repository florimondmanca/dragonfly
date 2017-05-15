local rope = require 'rope'

local Component = rope.Component:subclass('ComponentName')

function Component:initialize(arguments)
    rope.Component.initialize(self, arguments)
end

function Component:update(dt)
    -- optional
end

function Component:draw()
    -- optional
end

return Component

local rope = require 'rope'

local Component = rope.Component:subclass('BackgroundSwitcher')

function Component:initialize()
    rope.Component.initialize(self)
end

function Component:switch()
    local r, g, b, a = love.graphics.getBackgroundColor()
    love.graphics.setBackgroundColor(255 - r, 255 - g, 255 - b, a)
end


return Component

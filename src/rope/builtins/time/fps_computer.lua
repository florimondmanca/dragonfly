local rope = require 'rope'

local Component = rope.Component:subclass('FpsRenderer')

local function format(fps)
    return math.floor(fps * 100) / 100
end

function Component:initialize(arguments)
    arguments.time = 0
    arguments.period = arguments.period or 1
    rope.Component.initialize(self, arguments)
end

function Component:worksWith()
    return {text = {script = 'rope.builtins.graphics.text_renderer'}}
end

function Component:update(dt)
    self.time = self.time + dt
    if self.time > self.period then
        self.text:setText('FPS: ' .. format(1/dt))
        self.time = 0
    end
end


return Component

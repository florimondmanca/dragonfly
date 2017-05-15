local rope = require 'rope'

local Trigger = rope.Component:subclass('Trigger')

function Trigger:initialize(arguments)
    self.key = arguments.key or 'space'
    self.event = arguments.event or ''
    rope.Component.initialize(self)
end

function Trigger:keypressed(key)
    if key == self.key then
        local e = self.globals.events[self.event]
        assert(e, 'Trigger could not find event ' .. self.event)
        e:trigger(self)
    end
end

return Trigger

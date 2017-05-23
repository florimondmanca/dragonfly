local rope = require 'rope'

local KeyTrigger = rope.Component:subclass('KeyTrigger')

----- initializes a key trigger
-- key triggers trigger events when a specific key is pressed
-- @tparam string key (required)
-- @tparam string event the event to trigger on key pressed
function KeyTrigger:initialize(arguments)
    self:require(arguments, 'key', 'event')
    rope.Component.initialize(self, arguments)
end

function KeyTrigger:keypressed(key)
    if key == self.key then
        local e = self.globals.events[self.event]
        assert(e, 'Trigger could not find event ' .. self.event)
        e:trigger(self)
    end
end

return KeyTrigger

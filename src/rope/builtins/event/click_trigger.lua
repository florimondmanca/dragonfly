local rope = require 'rope'

local Trigger = rope.Component:subclass('ClickTrigger')

----- initializes a click trigger
-- click triggers trigger events when mouse clicks on the trigger's area
function Trigger:initialize(arguments)
    self:require(arguments, 'event')
    rope.Component.initialize(self, arguments)
end

function Trigger:worksWith()
    return {collider = {script = 'rope.builtins.colliders.rectangle_collider'}}
end

function Trigger:mousepressed(x, y, button)
    if button == 1 and self.collider:contains(x, y) then
        local e = self.globals.events[self.event]
        assert(e, 'Trigger could not find event ' .. self.event)
        e:trigger(self)
    end
end

return Trigger

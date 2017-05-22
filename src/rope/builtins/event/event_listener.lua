local rope = require 'rope'

local EventListener = rope.Component:subclass('EventListener')

----- initializes an event listener
-- event listeners manage the dispatch of events from triggers to event
-- managers.
-- @tparam string event the name of the event to listen to.
-- @tparam string targetComponent the script of the component that should
-- react to the event.
-- @tparam string targetFunction the name of the target component's function
-- to call on reaction to the event.
function EventListener:initialize(arguments)
    self:require(arguments, 'targetComponent', 'targetFunction')
    self.event = arguments.event or ''
    rope.Component.initialize(self)
end

function EventListener:awake()
    local e = self.globals.events[self.event]
    assert(e, 'EventListener could not find event ' .. self.event)
    e.listeners[#e.listeners + 1] = self
end

function EventListener:eventStart(source)
    if self.targetComponent and self.targetFunction then
        local component = self.gameObject:getComponent(self.targetComponent)
        if component then
            local action = component[self.targetFunction]
            assert(action, component.class.name .. ' has no action ' .. self.targetFunction)
            action(component, source)
        end
    end
end

return EventListener

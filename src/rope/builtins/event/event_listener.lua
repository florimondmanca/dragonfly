local rope = require 'rope'

local EventListener = rope.Component:subclass('EventListener')

function EventListener:initialize(arguments)
    self.event = arguments.event or ''
    self.targetComponent = arguments.targetComponent or error('targetComponent must be declared')
    self.targetFunction = arguments.targetFunction or error('targetFunction must be declared')
    rope.Component.initialize(self)
end

function EventListener:awake()
    local e = self.globals.events[self.event]
    assert(e, 'EventListener could not find event ' .. self.event)
    table.insert(e.listeners, self)
end

function EventListener:eventStart(source)
    if self.targetComponent and self.targetFunction then
        local component = self.gameObject:getComponent(self.targetComponent)
        local action = component[self.targetFunction]
        assert(action, component.class.name .. ' has no action ' .. self.targetFunction)
        action(component, source)
    end
end

return EventListener

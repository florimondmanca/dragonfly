local rope = require 'rope'

local EventManager = rope.Component:subclass('EventManager')

function EventManager:initialize(arguments)
    self.events = arguments.events or {}
    rope.Component.initialize(self)
end

function EventManager:awake()
    if not self.globals.events then
        self.globals.events = {}
    end

    for _, event in ipairs(self.events) do
        self.globals.events[event] = {
            listeners = {},
            trigger = function(self, component)
                -- alert all listeners that an event was just triggered,
                -- and which game object triggered it
                for _, listener in ipairs(self.listeners) do
                    listener:eventStart(component.gameObject)
                end
            end
        }
    end
end

return EventManager

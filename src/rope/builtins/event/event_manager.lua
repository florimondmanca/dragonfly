local rope = require 'rope'

local EventManager = rope.Component:subclass('EventManager')

----- initializes an event manager
-- event managers group listeners and triggers together.
-- all possible events must be declared on creation, so that the
-- manager can populate the globals.events table accordingly.
-- @tparam table events the list of possible events (default is empty table)
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

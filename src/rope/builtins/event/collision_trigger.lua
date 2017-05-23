local rope = require 'rope'

local COLLIDER_SCRIPT = 'rope.builtins.colliders.rectangle_collider'

----- initializes a collision trigger
-- collision triggers trigger an event when the owner's AABB and another
-- game object's AABB collide.
-- @tparam string event the name of the event to trigger on collision
local Trigger = rope.Component:subclass('CollisionTrigger')

function Trigger:initialize(arguments)
    self:require(arguments, 'event')
    rope.Component.initialize(self, arguments)
end

function Trigger:update()
    for _, o1 in ipairs(self.gameScene.gameObjects) do
        local col1 = o1:getComponent(COLLIDER_SCRIPT)
        if col1 then
            for _, o2 in ipairs(self.gameScene.gameObjects) do
                local col2 = o2:getComponent(COLLIDER_SCRIPT)
                if col2 and o1 ~= o2 then
                    if col1:collidesWith(col2) then
                        -- trigger an event on collision
                        local e = self.globals.events[self.event]
                        assert(e, 'Trigger could not find event ' .. self.event ..
                        '. Was it declared in an EventManager game object?')
                        -- send gameObject as the one that caused the collision
                        e:trigger({gameObject={me=o1, them=o2}})
                    end
                end
            end
        end
    end
end

return Trigger

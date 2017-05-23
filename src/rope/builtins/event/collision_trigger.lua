local rope = require 'rope'
local collision = require 'rope.collision'

local AABB_SCRIPT = 'rope.builtins.colliders.aabb'

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
        local aabb1 = o1:getComponent(AABB_SCRIPT)
        if aabb1 then
            for _, o2 in ipairs(self.gameScene.gameObjects) do
                local aabb2 = o2:getComponent(AABB_SCRIPT)
                if aabb2 and o1 ~= o2 then
                    if collision.collideRect(aabb1:get(), aabb2:get()) then
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

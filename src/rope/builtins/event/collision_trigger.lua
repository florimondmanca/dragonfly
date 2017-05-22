local rope = require 'rope'
local collision = require 'rope.collision'

local AABB_SCRIPT = 'rope.builtins.collision.aabb'

----- initializes a collision trigger
-- collision triggers trigger an event when the owner's AABB and another
-- game object's AABB collide.
-- @tparam string event the name of the event to trigger on collision
local Trigger = rope.Component:subclass('CollisionTrigger')

function Trigger:initialize(arguments)
    self.event = arguments.event or ''
    rope.Component.initialize(self)
end

function Trigger:update()
    local aabb = self.gameObject:getComponent(AABB_SCRIPT)

    -- look for other AABB's that collide with this one
    for _, gameObject in ipairs(self.gameScene.gameObjects) do
        local other = gameObject:getComponent(AABB_SCRIPT)
        -- aabb's of a same game object won't collide
        if other and gameObject ~= self.gameObject then
            if collision.collideRect(aabb:getAABB(), other:getAABB()) then
                -- trigger an event on collision
                local e = self.globals.events[self.event]
                assert(e, 'Trigger could not find event ' .. self.event ..
                '. Was it declared in an EventManager game object?')
                -- send gameObject as the one that caused the collision
                e:trigger({gameObject={me=self.gameObject, them=gameObject}})
            end
        end
    end
end

return Trigger

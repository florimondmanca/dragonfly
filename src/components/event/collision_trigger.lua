local rope = require 'rope'
local collision = require 'rope.collision'

local RECT_SCRIPT = 'rope.builtins.collision.aabb'

-- Checks collision between the owner game object's collider Rect and
-- all other game object that have a collider Rect
local Trigger = rope.Component:subclass('CollisionTrigger')

function Trigger:initialize(arguments)
    self.event = arguments.event or ''
    rope.Component.initialize(self)
end

function Trigger:update()
    local rect = self.gameObject:getComponent(RECT_SCRIPT)
    if not rect then return end
    for _, gameObject in ipairs(self.gameScene.gameObjects) do
        local other
        if pcall(function() other = gameObject:getComponent(RECT_SCRIPT) end)
        and other ~= rect then
            if collision.collideRect(rect:getAABB(), other:getAABB()) then
                local e = self.globals.events[self.event]
                assert(e, 'Trigger could not find event ' .. self.event)
                -- send to gameObject as the one that caused the collision
                e:trigger(other)
            end
        end
    end
end

return Trigger

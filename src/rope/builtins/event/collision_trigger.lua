local rope = require 'rope'
local collision = require 'rope.collision'

local RECT_SCRIPT = 'rope.builtins.collision.aabb'

-- Checks collision between the owner game object's AABB and
-- all other game objects that have an AABB
local Trigger = rope.Component:subclass('CollisionTrigger')

function Trigger:initialize(arguments)
    self.event = arguments.event or ''
    rope.Component.initialize(self)
end

function Trigger:update()
    local rect = self.gameObject:getComponent(RECT_SCRIPT)
    for _, gameObject in ipairs(self.gameScene.gameObjects) do
        local other
        if pcall(function() other = gameObject:getComponent(RECT_SCRIPT) end)
        and other ~= rect then
            if collision.collideRect(rect:getAABB(), other:getAABB()) then
                local e = self.globals.events[self.event]
                assert(e, 'Trigger could not find event ' .. self.event ..
                '. Was it declared in an EventManager game object?')
                print('collision between', self.gameObject.name, 'and', gameObject.name)
                -- send gameObject as the one that caused the collision
                e:trigger({gameObject={
                    left=self.gameObject, right=gameObject
                }})
            end
        end
    end
end

return Trigger

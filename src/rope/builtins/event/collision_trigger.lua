local rope = require 'rope'

local COLLIDER_SCRIPT = 'rope.builtins.colliders._collider'

----- initializes a collision trigger
-- collision triggers trigger an event when the owner's AABB and another
-- game object's AABB collide.
-- @tparam string event the name of the event to trigger on collision
local Trigger = rope.Component:subclass('CollisionTrigger')

function Trigger:update()
    for i, o1 in ipairs(self.gameScene.gameObjects) do
        local col1 = o1:getComponent(COLLIDER_SCRIPT)
        if col1 then
            local o2s = {unpack(self.gameScene.gameObjects, i + 1)}
            -- ^ take __distinct__ pairs of (col1, col2)
            for _, o2 in ipairs(o2s) do
                local col2 = o2:getComponent(COLLIDER_SCRIPT)
                if col2 and o1 ~= o2 then
                    if col1:collidesWith(col2) then
                        col1:addCollision(col2)
                    end
                end
            end
        end
    end
end

return Trigger

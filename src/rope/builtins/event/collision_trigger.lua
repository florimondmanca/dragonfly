local rope = require 'rope'
local lume = require 'rope.lib.lume'

local COLLIDER_SCRIPT = 'rope.builtins.colliders._collider'

----- initializes a collision trigger
-- collision triggers trigger an event when the owner's AABB and another
-- game object's AABB collide.
-- @tparam string event the name of the event to trigger on collision
local Trigger = rope.Component:subclass('CollisionTrigger')

function Trigger:update()
    for i, o1 in ipairs(self.gameScene.gameObjects) do
        local cols1 = o1:getComponents(COLLIDER_SCRIPT) or {}
        for _, col1 in ipairs(cols1) do
            local o2s = lume.chain(self.gameScene.gameObjects)
                :slice(i+1)
                :filter(function(o2) return o1 ~= o2 end)
                :result() -- take only distinct pairs of objects
            for _, o2 in ipairs(o2s) do
                for _, col2 in ipairs(o2:getComponents(COLLIDER_SCRIPT) or {}) do
                    if col1:collidesWith(col2) then
                        col1:addCollision(col2)
                    end
                end
            end
        end
    end
end

return Trigger

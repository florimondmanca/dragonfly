local rope = require 'rope'

local COLLIDER_SCRIPT = 'rope.builtins.colliders.collider'

local Component = rope.Component:subclass('Resolver')

function Component:initialize(arguments)
    arguments.resolvedGroups = arguments.resolvedGroups or {}
    rope.Component.initialize(self, arguments)
end

function Component:worksWith()
    return {collider = {script = COLLIDER_SCRIPT}}
end

function Component:update()
    for collider in pairs(self.collider.collisions) do
        if self:resolve(collider) then
            self.collider:resolved(collider)
        end
    end
end

----- callback function, used to resolve collisions
-- @tparam Collider collider
-- @return true if collision could be resolved, false otherwise
function Component:resolve()
    return true
end

return Component

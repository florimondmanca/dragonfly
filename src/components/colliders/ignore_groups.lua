local rope = require 'rope'

local COLLIDER_SCRIPT = 'rope.builtins.colliders.collider'

local Component = rope.Component:subclass('IgnoreGroups')

----- tag component: tells the collider not to take collisions with objects of given groups
function Component:initialize(arguments)
    self:require(arguments, 'groups')
    rope.Component.initialize(self, arguments)
end

function Component:awake()
    local groups = self.groups
    local collider = self.gameObject:getComponent(COLLIDER_SCRIPT)
    if collider then
        collider.acceptsCollisionWith = function (self, other)
            if other.group then
                return groups[other.group] ==  nil
            else
                return groups.all == nil
            end
        end
    end
end


return Component

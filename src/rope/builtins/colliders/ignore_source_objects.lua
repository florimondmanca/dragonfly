local rope = require 'rope'

local COLLIDER_SCRIPT = 'rope.builtins.colliders._collider'

local Component = rope.Component:subclass('IgnoreSourceObjects')

----- tag component: tells the collider not to take collisions between owner and another object whose source is owner.
-- example usage: tell a bullet to ignore collisions with its source (the game object that shoot the bullet)
function Component:initialize(arguments)
    rope.Component.initialize(self, arguments)
end

function Component:awake()
    local collider = self.gameObject:getComponent(COLLIDER_SCRIPT)
    if collider then
        collider.acceptsCollisionWith = function (self, other)
            local source = self.gameObject.source
            return not source or source ~= other.gameObject
        end
    end
end


return Component

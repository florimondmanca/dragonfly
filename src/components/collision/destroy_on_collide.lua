local rope = require 'rope'

local Component = rope.Component:subclass('DestroyOnCollide')
function Component:awake()
    local collider = self.gameObject:getComponent('rope.builtins.collision.aabb')
    collider.resolve = function(self, objects)
        if objects.left == self.gameObject
        or objects.right == self.gameObject then
            self.gameObject:destroy()
        end
    end
end

return Component

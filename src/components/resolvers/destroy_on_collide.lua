local Collider = require 'rope.builtins.colliders._resolver'

local Component = Collider:subclass('DestroyOnCollide')

function Component:resolve(collider)
    -- if collider has a group, only resolve if it is registered in
    -- the resolved groups
    if collider.group then
        local group = self.resolvedGroups[collider.group]
        if not group then return false end
        if group.destroySelf then self.gameObject:destroy() end
        if group.destroyOther then collider.gameObject:destroy() end
        return true
    end
    -- destroy everyone by default
    self.gameObject:destroy()
    collider.gameObject:destroy()
    return true
end

return Component

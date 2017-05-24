local rope = require 'rope'

local COLLIDER_SCRIPT = 'rope.builtins.colliders._collider'

local Component = rope.Component:subclass('DestroyOnCollide')

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

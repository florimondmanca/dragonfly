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

function Component:awake()
    local resolvedGroups = self.resolvedGroups
    self.collider.resolve = function (self, collider, _)
        -- if collider has a group, only resolve if it is registered in
        -- the resolved groups
        if collider.group then
            local group = resolvedGroups[collider.group]
            if group then
                if group.destroySelf then self.gameObject:destroy() end
                if group.destroyOther then collider.gameObject:destroy() end
            end
        -- destroy everyone by default
        else
            self.gameObject:destroy()
            collider.gameObject:destroy()
        end
    end
end

return Component

local rope = require 'rope'

local AABB_SCRIPT = 'rope.builtins.collision.aabb'

local Component = rope.Component:subclass('DestroyOnCollide')

function Component:initialize(arguments)
    arguments.onCollideWithGroup = arguments.onCollideWithGroup or {}
    rope.Component.initialize(self, arguments)
end

function Component:worksWith()
    return {collider = {script = AABB_SCRIPT}}
end

function Component:awake()
    local onCollideWithGroup = self.onCollideWithGroup

    self.collider.resolve = function (self, objects)
        local me, them = objects.me, objects.them
        -- if the other object was created by myself (e.g. a bullet)
        -- then don't destroy anyone!
        if them.source then
            if them.source == me then return end
        end

        local onCollide = onCollideWithGroup
            [them:getComponent(AABB_SCRIPT).collideGroup]
        if onCollide then
            if onCollide.destroySelf then me:destroy() end
            if onCollide.destroyOther then them:destroy() end
        end
    end
end

return Component

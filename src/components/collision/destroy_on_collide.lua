local rope = require 'rope'

local COLLIDER_SCRIPT = 'rope.builtins.colliders._collider'

local Component = rope.Component:subclass('DestroyOnCollide')

function Component:initialize(arguments)
    arguments.onCollideWithGroup = arguments.onCollideWithGroup or {}
    rope.Component.initialize(self, arguments)
end

function Component:worksWith()
    return {collider = {script = COLLIDER_SCRIPT}}
end

function Component:resolve(objects)
    local me, them = objects.me, objects.them
    -- if the other object was created by myself (e.g. a bullet)
    -- then don't destroy anyone!
    if them.source == me then return end

    local themCol = them:getComponent(COLLIDER_SCRIPT)
    if not themCol then return end

    local behavior = self.onCollideWithGroup[themCol.collideGroup]
    if behavior then
        if behavior.destroySelf then me:destroy() end
        if behavior.destroyOther then them:destroy() end
    end
end

return Component

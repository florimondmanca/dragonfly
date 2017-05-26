local Resolver = require 'rope.builtins.colliders._resolver'
local geometry = require 'rope.geometry'

local COLLIDER_SCRIPT = 'rope.builtins.colliders.collider'
local COLLIDER = require(COLLIDER_SCRIPT)

local Component = Resolver:subclass('BlockResolver')

-- { -- overlap on each axis
--     x = math.min(rect1.origin.x + rect1.width, rect2.origin.x + rect2.width)
--         - math.max(rect1.origin.x, rect2.origin.x),
--     y = math.min(rect1.origin.y + rect1.height, rect2.origin.y + rect2.height)
--         - math.max(rect1.origin.y, rect2.origin.y),
-- }

local function whoMoves(col1, col2)
    if col1.static and col2.static then return nil, nil
    elseif col1.static and not col2.static then return col2, col1
    elseif not col1.static and col2.static then return col1, col2
    else return col1, col2 end
end

function Component:resolve(collider)
    -- check that we operate on rectangle colliders
    local myCollider = self.gameObject:getComponent(COLLIDER_SCRIPT)
    if not myCollider or not collider:isInstanceOf(COLLIDER) then
        return true
    end

    if collider.group then
        local group = self.resolvedGroups[collider.group]
        if not group or not group.block then return true end

        local moving, static = whoMoves(myCollider, collider)
        if moving then
            local overlap = geometry.rectanglesOverlap(
                static.shape,
                moving.shape,
                static.gameObject.globalTransform,
                moving.gameObject.globalTransform
            )
            if math.abs(overlap.x) < math.abs(overlap.y) then
                overlap = {x=overlap.x, y=0}
            else
                overlap = {x=0, y=overlap.y}
            end
            moving.gameObject:move(overlap.x, overlap.y)
        end
    end
    return true
end

return Component

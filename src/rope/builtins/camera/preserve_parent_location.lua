local rope = require 'rope'

local Component = rope.Component:subclass('PreserveParentLocation')

function Component:initialize(arguments)
    arguments.on = {x = arguments.onX or false, y = arguments.onY or false}
    arguments.onX, arguments.onY = nil, nil
    self.p0 = {}
    rope.Component.initialize(self, arguments)
end

function Component:update(_, firstUpdate)
    if firstUpdate then
        local pos = self.gameObject.parent.globalTransform.position
        self.pos0 = {x = pos.x, y = pos.y}
        self.gameObject:move(self:firstPos('x'), self:firstPos('y'))
    end
    self.gameObject:moveTo(self:getPos('x'), self:getPos('y'))
end

function Component:firstPos(axis)
    return self.on[axis] and 0 or -self.pos0[axis]
end

function Component:getPos(axis)
    if self.on[axis] then return -self.pos0[axis]
    else return -self.gameObject.parent.globalTransform.position[axis] end
end

return Component

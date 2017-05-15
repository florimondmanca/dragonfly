local rope = require 'rope'

local Bullet = rope.Component:subclass('Bullet')

function Bullet:initialize(arguments)
    self:validate(arguments, 'x', 'y')
    arguments.vx = arguments.vx or 0
    arguments.vy = arguments.vy or 0
end

function Bullet:update(dt)
    self.x = self.x + self.vx * dt
    self.y = self.y + self.vy * dt
    if self.x < 0 or self.x > love.graphics.getWidth() then self:die() end
    if self.y < 0 or self.y > love.graphics.getHeight() then self:die() end
end

return Bullet

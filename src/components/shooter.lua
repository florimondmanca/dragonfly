local rope = require 'rope'
local Bullet = require('components.bullet')


local Component = rope.Component:subclass('Shooter')

function Component:initialize(arguments)
    self:validate(arguments, 'bulletSpeed')
    self.bullets = {}
    rope.Component.initialize(self, arguments)
end

function Component:update(dt)
    for _, bullet in ipairs(self.bullets) do bullet:update(dt) end
end

function Component:draw()
    for _, bullet in ipairs(self.bullets) do bullet:draw() end
end

function Component:addBullet(bullet)
    table.insert(self.bullets, bullet)
end

function Component:shoot()
    table.insert(self.bullets, Bullet(
        self.gameObject.transform.position.x,
        self.gameObject.transform.position.y,
        self.bulletSpeed, 0
    ))
end

return Component

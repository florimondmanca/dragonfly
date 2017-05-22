local rope = require 'rope'

local Component = rope.Component:subclass('InputMotorController')

function Component:initialize(arguments)
    self:require(arguments, 'keyPlus', 'keyMinus')
    rope.Component.initialize(self, arguments)
end

function Component:worksWith()
    return {'components.movement.motor'}
end

function Component:awake()
    self.motor = self.gameObject:getComponent('components.movement.motor')
end

function Component:update(dt)
    local kp = love.keyboard.isDown(self.keyPlus)
    local km = love.keyboard.isDown(self.keyMinus)
    if kp and not km then
        self.motor:move(1, dt)
    elseif km and not kp then
        self.motor:move(-1, dt)
    end
end

return Component

local rope = require 'rope'
local Motor = require 'components.motor'

local Component = rope.Component:subclass('InputMotorController')

function Component:initialize(arguments)
    self:validate(arguments, 'axis')
    arguments.threshold = math.exp(-(arguments.meanChangeTime or 1))
    arguments.direction = arguments.direction or 1
    self.motor = nil
    rope.Component.initialize(self, arguments)
end

function Component:update(dt)
    if love.math.random() < self.threshold then
        self.direction = - self.direction
    end
    if self.motor then
            self.motor:move(self.direction, dt)
    else
        self.motor = self.gameObject:getComponent(Motor, function(c) return c.axis == self.axis end)
    end
end

return Component

local MotorController = require('components.base').MotorController

local Component = MotorController:subclass('AIMotorController')

function Component:initialize(arguments)
    self:validate(arguments, 'axis')
    arguments.threshold = math.exp(-(arguments.meanChangeTime or 1))
    arguments.direction = arguments.direction or 1
    MotorController.initialize(self, arguments)
end

function Component:update(dt)
    if love.math.random() < self.threshold then
        self.direction = - self.direction
    end
    self:getMotor():move(self.direction, dt)
end

return Component

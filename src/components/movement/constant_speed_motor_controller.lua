local MotorController = require('components.base').MotorController

local Component = MotorController:subclass('ConstantSpeedMotorController')

function Component:initialize(arguments)
    self:require(arguments, 'direction')
    MotorController.initialize(self, arguments)
end

function Component:update(dt)
    self.motor:move(self.direction, dt)
end

return Component

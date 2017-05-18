local MotorController = require('components.base').MotorController

local Component = MotorController:subclass('InputMotorController')

function Component:initialize(arguments)
    self:validate(arguments, 'keyPlus', 'keyMinus')
    MotorController.initialize(self, arguments)
end

function Component:update(dt)
    local kp = love.keyboard.isDown(self.keyPlus)
    local km = love.keyboard.isDown(self.keyMinus)
    if kp and not km then
        self:getMotor():move(1, dt)
    elseif km and not kp then
        self:getMotor():move(-1, dt)
    end
end

return Component

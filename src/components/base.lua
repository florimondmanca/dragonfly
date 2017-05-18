local rope = require 'rope'


-- [[ Abstract controllers ]] --

local Controller = rope.Component:subclass('Controller')

function Controller:initialize(arguments)
    self.controlledComponent = nil
    rope.Component.initialize(self, arguments)
end

function Controller:getSlave(slaveClassPath, filter)
    if not self.controlledComponent then
        self.controlledComponent = self.gameObject:getComponent(
            slaveClassPath, filter
        )
    end
    return self.controlledComponent
end


local InputController = Controller:subclass('InputController')

function InputController:initialize(arguments)
    self:validate(arguments, 'axis')
    assert(arguments.axis == 'x' or arguments.axis == 'y', 'Unknown axis: ' .. arguments.axis)
    Controller.initialize(self, arguments)
end

-- [[ Concrete controllers ]] --


-- Motor Controller

local MotorController = InputController:subclass('MotorController')

function MotorController:getMotor()
    return self:getSlave('components.movement.motor', function(c) return c.axis == self.axis end)
end

-- Shoot Controller

local ShootController = Controller:subclass('ShootController')

function ShootController:getShooter()
    return self:getSlave('components.shooter')
end

return {
    MotorController = MotorController,
    ShootController = ShootController,
}

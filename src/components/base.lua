local rope = require 'rope'

local Controller = rope.Component:subclass('Controller')


-- [[ Abstract controller ]] --

function Controller:initialize(arguments)
    self:validate(arguments, 'axis')
    assert(arguments.axis == 'x' or arguments.axis == 'y',
        'Unknown axis: ' .. arguments.axis)
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


-- [[ Concrete controllers ]] --


-- Motor Controller

local MotorController = Controller:subclass('MotorController')

function MotorController:getMotor()
    return self:getSlave('components.movement.motor', function(c) return c.axis == self.axis end)
end

return {
    MotorController = MotorController,
}

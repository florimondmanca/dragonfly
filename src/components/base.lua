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

local MotorController = rope.Component:subclass('MotorController')

function MotorController:initialize(arguments)
    self:require(arguments, 'axis', 'motor_script')
    assert(arguments.axis == 'x' or arguments.axis == 'y',
        'Unknown axis: ' .. arguments.axis)
    rope.Component.initialize(self, arguments)
end

function MotorController:awake()
    self.motor = self.gameObject:getComponent(self.motor_script, function(c) return c.axis == self.axis end)
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

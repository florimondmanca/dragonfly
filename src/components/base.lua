local rope = require 'rope'


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


return {
    MotorController = MotorController,
}

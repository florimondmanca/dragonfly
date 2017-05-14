local rope = require 'rope'
local Motor = require 'components.motor'

local Component = rope.Component:subclass('InputMotorController')

function Component:initialize(arguments)
    self:validate(arguments, 'axis', 'keyPlus', 'keyMinus')
    self.motor = nil
    rope.Component.initialize(self, arguments)
end

function Component:update(dt)
    if self.motor then
        local kp = love.keyboard.isDown(self.keyPlus)
        local km = love.keyboard.isDown(self.keyMinus)
        if kp and not km then
            self.motor:move(1, dt)
        elseif km and not kp then
            self.motor:move(-1, dt)
        end
    else
        self.motor = self.gameObject:getComponent(Motor, function(c) return c.axis == self.axis end)
    end
end

return Component

local MotorController = require('components.base').MotorController

local Component = MotorController:subclass('RandomChaseMotorController')

-- Helper
local function newTargetPositionFunction(axis, min, max)
    local makeX = axis == 'x' and (function(self)
        return (min + (max - min) * love.math.random()) * love.graphics.getWidth()
    end) or (function(self)
        return self.gameObject.transform.position.x
    end)
    local makeY = axis == 'x' and (function(self)
        return self.gameObject.transform.position.y
    end) or (function(self)
        return (min + (max - min) * love.math.random()) * love.graphics.getHeight()
    end)
    return function(self)
        self.targetPos = {
            x = makeX(self),
            y = makeY(self),
        }
        self.direction = (self.targetPos[axis] > self.gameObject.transform.position[axis]) and 1 or -1
    end
end


function Component:initialize(arguments)
    arguments.min = arguments.min or 0
    arguments.max = arguments.max or 1
    arguments.direction = 0
    MotorController.initialize(self, arguments)
    self.newTargetPosition = newTargetPositionFunction(
        self.axis, arguments.min or 0, arguments.max or 1)
end

function Component:reachedTarget()
    return self.direction * (self.gameObject.transform.position[self.axis] - self.targetPos[self.axis]) > 0
end

function Component:update(dt)
    if not self.targetPos then self:newTargetPosition() end
    self:getMotor():move(self.direction, dt)
    if self:reachedTarget() then self:newTargetPosition() end
end

return Component

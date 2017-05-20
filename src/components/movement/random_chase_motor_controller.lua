local MotorController = require('components.base').MotorController

local Component = MotorController:subclass('RandomChaseMotorController')


local function randomRange(min, max)
    return function()
        return min + (max - min) * love.math.random()
    end
end

-- the wandering effect is achieved by going to randomly generated target
-- positions
function Component:initialize(arguments)
    -- min and max allow to limit the amplitude of movement of the
    -- sprite on the screen (0 <= min, max <= 1)
    arguments.min = arguments.min or 0
    arguments.max = arguments.max or 1
    MotorController.initialize(self, arguments)
    self.random = randomRange(arguments.min, arguments.max)
end

function Component:awake()
    self:newTarget()
    MotorController.awake(self)
end

function Component:newTarget()
    -- generates a new target for the sprite to go to
    local x, y
    if self.axis == 'x' then
        x = self.random() * love.graphics.getWidth()
        y = self.gameObject.globalTransform.position.y
    else
        x = self.gameObject.globalTransform.position.x
        y = self.random() * love.graphics.getHeight()
    end
    self.target = {x=x, y=y}
    -- set direction according to the new target and current position
    self.direction = (self.target[self.axis] > self.gameObject.globalTransform.position[self.axis]) and 1 or -1
end

function Component:reachedTarget()
    return self.direction * (self.gameObject.globalTransform.position[self.axis] - self.target[self.axis]) > 0
end

function Component:update(dt)
    self.motor:move(self.direction, dt)
    if self:reachedTarget() then
        self:newTarget()
    end
end

return Component

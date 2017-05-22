local rope = require 'rope'

local Component = rope.Component:subclass('RandomChaseMotorController')

local function randomRange(min, max)
    return function()
        return min + (max - min) * love.math.random()
    end
end

--- initializes a random chase motor controller.
-- this controller achieves a wandering effect by generating random targets
-- that the game object will go to. the range of these random targets
-- is controlled by min and max arguments
-- @tparam string axis x or y (required)
-- @tparam string motor_script which motor this controller uses (required)
-- @tparam number min between 0 and 1
-- @tparam number max between 0 and 1
function Component:initialize(arguments)
    self:require(arguments, 'axis', 'motor_script')
    rope.assertIn({'x', 'y'}, arguments.axis, 'axis')
    -- min and max allow to limit the amplitude of movement of the
    -- sprite on the screen (0 <= min, max <= 1)
    arguments.min = arguments.min or 0
    arguments.max = arguments.max or 1
    rope.Component.initialize(self, arguments)
    self.random = randomRange(arguments.min, arguments.max)
end

function Component:worksWith()
    return {
        motor = {
            script = 'components.movement.motor',
            filter = function(c) return c.axis == self.axis end
        }
    }
end

function Component:awake()
    self:newTarget()
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
    if self:reachedTarget() then self:newTarget() end
end

function Component:draw(debug)
    if debug then
        love.graphics.setColor(255, 255, 255)
        if self.axis == 'x' then
            local y = self.gameObject.globalTransform.position.y
            love.graphics.line(self.min * love.graphics.getWidth(), y, self.max * love.graphics.getWidth(), y)
        elseif self.axis == 'y' then
            local x = self.gameObject.globalTransform.position.x
            love.graphics.line(x, self.min * love.graphics.getHeight(), x, self.max * love.graphics.getHeight())
        end
    end
end

return Component

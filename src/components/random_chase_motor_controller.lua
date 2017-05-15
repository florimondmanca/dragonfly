local rope = require 'rope'
local Motor = require 'components.motor'

local Component = rope.Component:subclass('RandomChaseMotorController')

local function newTargetPosition(axis)
    if axis == 'y' then
        return function(self)
            self.targetPos = {
                x = self.gameObject.transform.position.x,
                y = love.math.random() * love.graphics.getHeight()
            }
            self.direction = (self.targetPos.y > self.gameObject.transform.position.y) and 1 or -1
        end
    elseif axis == 'x' then
        return function(self)
            self.targetPos = {
                x = love.math.random() * love.graphics.getWidth(),
                y = self.gameObject.transform.position.y
            }
            print(self.targetPos.x, self.targetPos.y)
            self.direction = (self.targetPos.x > self.gameObject.transform.position.x) and 1 or -1
        end
    end
end


function Component:initialize(arguments)
    self:validate(arguments, 'axis')
    arguments.direction = 0
    self.motor = nil
    rope.Component.initialize(self, arguments)
    self.newTargetPosition = newTargetPosition(self.axis)
end


function Component:reachedTarget()
    if self.direction > 0 then
        return self.gameObject.transform.position[self.axis] > self.targetPos[self.axis]
    else
        return self.gameObject.transform.position[self.axis] < self.targetPos[self.axis]
    end
end

function Component:update(dt)
    if not self.targetPos then self:newTargetPosition() end
    if self.motor then
            self.motor:move(self.direction, dt)
    else
        self.motor = self.gameObject:getComponent(Motor, function(c) return c.axis == self.axis end)
    end
    if self:reachedTarget() then self:newTargetPosition() end
end

return Component

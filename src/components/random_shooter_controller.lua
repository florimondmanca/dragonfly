local rope = require 'rope'
local Shooter = require 'components.shooter'

local Component = rope.Component:subclass('RandomShooterController')

function Component:initialize(arguments)
    self.shooter = nil
    arguments.meanWaitTime = arguments.meanWaitTime or 1
    arguments.waitTimeSigma = arguments.waitTimeSigma or 1
    rope.Component.initialize(self, arguments)
    self.time = 0
    self.waitTime = self:makeWaitTime()
end

function Component:makeWaitTime()
    -- normally distributed (0 mean, 1 standard deviation) random number
    local randn = math.sqrt(-2*math.log(love.math.random())) * math.cos(2*math.pi*love.math.random())
    return self.meanWaitTime + self.waitTimeSigma * randn
end

function Component:update(dt)
    if self.shooter then
        self.time = self.time + dt
        if self.time > self.waitTime then
            self.shooter:shoot()
            self.time = 0
            self.waitTime = self:makeWaitTime()
        end
    else
        self.shooter = self.gameObject:getComponent(Shooter)
    end
end

return Component

local rope = require 'rope'

local Component = rope.Component:subclass('RandomShootController')

function Component:initialize(arguments)
    self.shooter = nil
    arguments.meanWaitTime = arguments.meanWaitTime or 1
    arguments.waitTimeSigma = arguments.waitTimeSigma or 1
    rope.Component.initialize(self, arguments)
    self.time = 0
    self.waitTime = self:makeWaitTime()
end

function Component:awake()
    self.shooter = self.gameObject:getComponent('components.shooter')
end

function Component:makeWaitTime()
    -- normally distributed (0 mean, 1 standard deviation) random number
    local randn = math.sqrt(-2*math.log(love.math.random())) * math.cos(2*math.pi*love.math.random())
    return self.meanWaitTime + self.waitTimeSigma * randn
end

function Component:update(dt)
    self.time = self.time + dt
    if self.time > self.waitTime then
        self.shooter:shoot()
        self.time = 0
        self.waitTime = self:makeWaitTime()
    end
end

return Component

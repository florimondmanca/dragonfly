local rope = require 'rope'

local Component = rope.Component:subclass('RandomShootController')

function Component:initialize(arguments)
    self.shooter = nil
    arguments.meanWaitTime = arguments.meanWaitTime or 1
    arguments.waitTimeSigma = arguments.waitTimeSigma or 1
    rope.Component.initialize(self, arguments)
end

function Component:awake()
    self:requireComponents('components.shooter')
    self.shooter = self.gameObject:getComponent('components.shooter')
    self:resetTimer()
end

function Component:resetTimer()
    self.time = 0
    -- normally distributed (0 mean, 1 standard deviation) random number
    local randn = math.sqrt(-2*math.log(love.math.random())) * math.cos(2*math.pi*love.math.random())
    self.waitTime = self.meanWaitTime + self.waitTimeSigma * randn
end

function Component:tick(dt) self.time = self.time + dt end
function Component:timeToShoot() return self.time > self.waitTime end

function Component:update(dt)
    self:tick(dt)
    if self:timeToShoot() then
        self.shooter:shoot()
        self:resetTimer()
    end
end

return Component

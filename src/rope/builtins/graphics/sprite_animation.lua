local rope = require 'rope'
local spritesheet = require 'rope.spritesheet'

local Component = rope.Component:subclass('SpriteAnimation')

----- initializes a sprite animator.
-- @tparam string sheetName
-- @tparam number fps defines the speed of the animation
function Component:initialize(arguments)
    self:require(arguments, 'sheetName', 'fps')
    arguments.image, arguments.quads = spritesheet.load(arguments.sheetName)
    arguments.period = 1 / arguments.fps
    arguments.sheetName, arguments.fps = nil, nil
    rope.Component.initialize(self, arguments)
end

function Component:awake()
    self.currentFrame = 1
    self.time = 0
    self:nextQuad()
end

function Component:nextQuad()
    local quad = self.quads[self.currentFrame]
    local _, _, w, h = quad:getViewport()
    self.current = {quad=quad, width=w, height=h}
end

function Component:update(dt)
    self.time = self.time + dt
    if self.time > self.period then
        self.time = 0
        self.currentFrame = self.currentFrame == #self.quads and 1 or self.currentFrame + 1
        self:nextQuad()
    end
end

function Component:draw()
    local pos = self.gameObject.globalTransform.position
    love.graphics.setColor(255, 255, 255)
    love.graphics.draw(
        self.image,
        self.current.quad,
        pos.x - self.current.width/2,
        pos.y - self.current.height/2
    )
end

return Component

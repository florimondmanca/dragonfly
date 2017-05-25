local rope = require 'rope'
local geometry = require 'rope.geometry'
local spritesheet = require 'rope.spritesheet'

local Component = rope.Component:subclass('SpriteAnimation')

----- initializes a sprite animator.
-- @tparam string sheetName
-- @tparam number fps defines the speed of the animation
-- @tparam table origin given as {x=<x>, y=<y>} (or 'center' to put the
-- origin at the center of the maximal size frame).
function Component:initialize(arguments)
    self:require(arguments, 'sheetName', 'fps')

    -- load the sprite sheet data
    local image, quads, maxWidth, maxHeight = spritesheet.load(arguments.sheetName)
    arguments.image, arguments.quads = image, quads
    arguments.period = 1 / arguments.fps

    -- build the rectangle shape
    if arguments.origin == 'center' then
        arguments.origin = {x=maxWidth/2, y=maxHeight/2}
    end
    arguments.shape = geometry.Rectangle(
        maxWidth, maxHeight, geometry.Vector(arguments.origin)
    )

    arguments.sheetName, arguments.fps, arguments.origin = nil, nil, nil

    rope.Component.initialize(self, arguments)
end

function Component:awake()
    self.currentFrame = 1
    self.time = 0
end

function Component:update(dt)
    self.time = self.time + dt
    if self.time > self.period then
        self.time = 0
        self.currentFrame = self.currentFrame == #self.quads and 1 or self.currentFrame + 1
    end
end

function Component:draw()
    local pos = self.gameObject.globalTransform.position
    love.graphics.setColor(255, 255, 255)
    love.graphics.draw(
        self.image,
        self.quads[self.currentFrame],
        pos.x - self.shape.origin.x,
        pos.y - self.shape.origin.y
    )
end

return Component

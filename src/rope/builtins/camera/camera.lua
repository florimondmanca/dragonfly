local rope = require 'rope'

-- Tag Component for cameras
local Camera = rope.Component:subclass('Camera')

-- add all useful functions on awake
function Camera:awake()
    -- set() must be called before all draws,
    -- it manages rotation and scaling
    self.gameObject.set = function(self, target)
        local r = target.globalTransform.rotation
        local scale = target.globalTransform.size
        love.graphics.push()
        love.graphics.rotate(-r)
        love.graphics.scale(1 / scale.x, 1 / scale.y)
    end
    -- apply(target) is called for each object draw
    self.gameObject.apply = function(self, target)
        target:move(
            -self.globalTransform.position.x,
            -self.globalTransform.position.y
        )
    end
    -- unset() must be called after all draws
    self.gameObject.unset = function(self)
        love.graphics.pop()
    end
    -- mousePosition() gives the mouse position from the camera's point of view
    self.gameObject.mousePosition = function(self)
        return
            love.mouse.getX() * self.globalTransform.size.x + self.globalTransform.position.x,
            love.mouse.getY() * self.globalTransform.size.y + self.globalTransform.position.y
    end
    -- boundaries() gives top, left, right and bottom values of camera's
    -- viewport
    self.gameObject.boundaries = function(self)
        local dx, dy = self.globalTransform.position.x, self.globalTransform.position.y
        local left, right = dx, dx + love.graphics.getWidth()
        local top, bottom = dy, dy + love.graphics.getHeight()
        return {left=left, right=right, top=top, bottom=bottom}
    end
end

function Camera:update(dt)
    if self.gameObject.cameraFunc then
        self.gameObject.cameraFunc(self.gameObject, self.gameObject.target, dt)
    end
end

return Camera

local rope = require 'rope'

-- Tag Component for cameras
local Camera = rope.Component:subclass('Camera')

function Camera:awake()
    -- add set() method to Camera gameObject
    self.gameObject.set = function(self)
        local pos = self.globalTransform.position
        local r = self.globalTransform.rotation
        local scale = self.globalTransform.size
        love.graphics.push()
        love.graphics.rotate(-r)
        love.graphics.scale(1 / scale.x, 1 / scale.y)
        love.graphics.translate(-pos.x, -pos.y)
    end
    -- add unset() method to Camera gameObject
    self.gameObject.unset = function(self)
        love.graphics.pop()
    end
    -- add mousePosition() method to Camera gameObject
    self.gameObject.mousePosition = function(self)
        local pos = self.globalTransform.position
        local scale = self.globalTransform.size
        return love.mouse.getX() * scale.x + pos.x, love.mouse.getY() * scale.y + pos.y
    end
    -- add screenBoundaries() method to Camera gameObject
    self.gameObject.screenBoundaries = function(self)
        local pos = self.globalTransform.position
        local dx, dy = pos.x, pos.y
        local left, right = dx, dx + love.graphics.getWidth()
        local top, bottom = dy, dy + love.graphics.getHeight()
        return {left=left, right=right, top=top, bottom=bottom}
    end

    self.gameScene.camera = self.gameObject
end

return Camera

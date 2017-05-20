local rope = require 'rope'

-- Tag Component for cameras
local Camera = rope.Component:subclass('Camera')

function Camera:awake()
    -- add set() and unset() methods to Camera gameObject
    self.gameObject.set = function(self)
        local pos = self.globalTransform.position
        local r = self.globalTransform.rotation
        local scale = self.globalTransform.size
        love.graphics.push()
        love.graphics.rotate(-r)
        love.graphics.scale(1 / scale.x, 1 / scale.y)
        love.graphics.translate(-pos.x, -pos.y)
    end
    self.gameObject.unset = function(self)
        love.graphics.pop()
    end
    self.gameObject.mousePosition = function(self)
        local pos = self.globalTransform.position
        local scale = self.globalTransform.size
        return love.mouse.getX() * scale.x + pos.x, love.mouse.getY() * scale.y + pos.y
    end
    self.gameScene.camera = self.gameObject
end

return Camera

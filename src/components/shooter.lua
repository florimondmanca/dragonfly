local rope = require 'rope'

local Component = rope.Component:subclass('Shooter')
Component.static.k = 0

function Component:initialize(arguments)
    self:require(arguments, 'bulletSpeed', 'filename')
    arguments.shiftX = arguments.shiftX or 0
    arguments.shiftY = arguments.shiftY or 0
    rope.Component.initialize(self, arguments)
end

function Component:shoot()
    -- create a separated, independant bullet object in the scene
    local bullet = {
        name = 'Bullet ' .. Component.k,
        transform = {
            position = {
                x = self.gameObject.globalTransform.position.x + self.shiftX,
                y = self.gameObject.globalTransform.position.y + self.shiftY
            }
        },
        prefab = 'prefabs.bullet',
        prefabComponents = {
            {
                script = 'components.velocity',
                arguments = {vx = self.bulletSpeed},
            },
            {
                script = 'rope.builtins.graphics.image_renderer',
                arguments = {filename = self.filename}
            },
        }
    }
    rope.buildObject(self.gameScene, bullet)
    Component.static.k = Component.k + 1
end

return Component

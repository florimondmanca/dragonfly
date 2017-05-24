local rope = require 'rope'

local Component = rope.Component:subclass('Shooter')

--- initializes a shooter
-- @tparam number bulletSpeed the speed of the bullet (required)
-- @tparam string filename the path to the bullet's image (required)
-- @tparam number shiftX generated bullets will be shifted on x by this amount
-- @tparam number shiftY generated bullets will be shifted on y by this amount
function Component:initialize(arguments)
    self:require(arguments, 'bulletSpeed', 'filename')
    arguments.shiftX = arguments.shiftX or 0
    arguments.shiftY = arguments.shiftY or 0
    rope.Component.initialize(self, arguments)
end

function Component:shoot()
    -- create a separated, independant bullet object in the scene
    local bullet = {
        name = 'Bullet',
        transform = {
            position = {
                x = self.gameObject.globalTransform.position.x + self.shiftX,
                y = self.gameObject.globalTransform.position.y + self.shiftY
            }
        },
        prefab = 'prefabs.bullet',
        prefabComponents = {
            {
                script = 'components.movement.velocity',
                arguments = {vx = self.bulletSpeed},
            },
            {
                script = 'rope.builtins.graphics.image_renderer',
                arguments = {filename = self.filename}
            },
        }
    }
    local object = rope.buildObject(self.gameScene, bullet)
    object.source = self.gameObject
end

return Component

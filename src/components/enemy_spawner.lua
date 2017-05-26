local rope = require 'rope'


local Component = rope.Component:subclass('EnemySpawner')

function Component:spawn(source)
    if source ~= self.gameObject then return end
    rope.buildObject(self.gameScene, {
        name = 'Enemy',
        transform = {
            position = {
                x = self.gameObject.globalTransform.position.x,
                y = (.1 + .8*love.math.random()) * love.graphics.getHeight(),
            }
        },
        prefab = 'prefabs.enemy'
    })
end


return Component

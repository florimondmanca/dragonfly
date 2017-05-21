local rope = require 'rope'

local Component = rope.Component:subclass('Shooter')

function Component:initialize(arguments)
    self:require(arguments, 'bulletSpeed', 'filename')
    arguments.shiftX = arguments.shiftX or 0
    arguments.shiftY = arguments.shiftY or 0
    rope.Component.initialize(self, arguments)
end

function Component:shoot()
    -- create a separated, independant bullet object in the scene
    local bulletObject = rope.GameObject(
        self.gameScene, 'Bullet', {position = {
            x = self.gameObject.globalTransform.position.x + self.shiftX,
            y = self.gameObject.globalTransform.position.y + self.shiftY}
        }
    )
    bulletObject:addComponent(
        rope.loadComponent('components.velocity'){vx=self.bulletSpeed}
    )
    bulletObject:addComponent(
        rope.loadComponent('rope.builtins.graphics.image_renderer')
        {filename=self.filename}
    )
    bulletObject:addComponent(
        rope.loadComponent('components.die_out_of_screen')()
    )
    -- add a rectangle to bullet for collision detection
    local rectangle = rope.GameObject(
        self.gameScene, 'Bullet rectangle', {position = {
            x = 0, y = 0}
        }, bulletObject
    )
    bulletObject:addChild(rectangle)
    rectangle:addComponent(
        rope.loadComponent('rope.builtins.collision.rectangle'){sizeFromImage = true}
    )
end

return Component

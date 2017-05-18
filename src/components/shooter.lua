local rope = require 'rope'

local Component = rope.Component:subclass('Shooter')

function Component:initialize(arguments)
    self:validate(arguments, 'bulletSpeed', 'filename')
    arguments.shiftX = arguments.shiftX or 0
    arguments.shiftY = arguments.shiftY or 0
    rope.Component.initialize(self, arguments)
end

function Component:shoot()
    -- create a separated, independant bullet object in the scene
    local bulletObject = rope.GameObject(
        self.gameScene, 'Bullet', {position = {
            x = self.gameObject.transform.position.x + self.shiftX,
            y = self.gameObject.transform.position.y + self.shiftY}
        }, self.gameObject
    )
    bulletObject:addComponent(
        rope.loadComponent('components.velocity'){vx=self.bulletSpeed}
    )
    bulletObject:addComponent(
        rope.loadComponent('rope.builtins.graphics.image_renderer')
        {filename=self.filename}
    )
    bulletObject:addComponent(
        rope.loadComponent('components.die_out_of_screen')())
end

return Component

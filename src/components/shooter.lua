local rope = require 'rope'
local geometry = require 'rope.geometry'
local Velocity = require 'components.velocity'
local ImageRenderer = require 'rope.builtins.graphics.image_renderer'
local DieOutOfScreen = require 'components.die_out_of_screen'


local Component = rope.Component:subclass('Shooter')

function Component:initialize(arguments)
    self:validate(arguments, 'bulletSpeed')
    arguments.shiftX = arguments.shiftX or 0
    arguments.shiftY = arguments.shiftY or 0
    rope.Component.initialize(self, arguments)
end

function Component:shoot()
    local bulletObject = rope.GameObject(
        self.gameObject.parent, 'Bullet',
        geometry.Transform(
            {x = self.gameObject.transform.position.x + self.shiftX,
            y = self.gameObject.transform.position.y + self.shiftY}
        )
    )
    bulletObject:addComponent(Velocity{vx=self.bulletSpeed})
    bulletObject:addComponent(ImageRenderer{filename='static/img/bullet.png'})
    bulletObject:addComponent(DieOutOfScreen())
end

return Component

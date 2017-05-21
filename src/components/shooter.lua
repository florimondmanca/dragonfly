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
    local bulletObject = rope.GameObject(
        self.gameScene, 'Bullet ' .. Component.k, {position = {
            x = self.gameObject.globalTransform.position.x + self.shiftX,
            y = self.gameObject.globalTransform.position.y + self.shiftY}
        }
    )
    local components = {
        {
            script = 'components.velocity',
            arguments = {vx = self.bulletSpeed},
        },
        {
            script = 'rope.builtins.graphics.image_renderer',
            arguments = {filename = self.filename}
        },
        {script = 'components.die_out_of_screen'},
    }
    for _, component in ipairs(components) do
        bulletObject:buildAndAddComponent(component)
    end
    -- add an AABB tag component to AABB game object
    local collider = bulletObject:buildAndAddComponent({
        script = 'rope.builtins.collision.aabb',
        arguments = {sizeFromImage = true}
    })
    bulletObject:buildAndAddComponent({
        script = 'components.collision.destroy_on_collide'
    })
    bulletObject:buildAndAddComponent({
        script = 'rope.builtins.graphics.rectangle_renderer',
        arguments = {
            width = collider.width,
            height = collider.height,
            mode = 'line',
            isDebug = true
        }
    })
    -- register a collision event on the bullet's AABB
    local eventComponents = {
        {
            script = 'rope.builtins.event.collision_trigger',
            arguments = {event = 'collision'}
        },
        {
            script = 'rope.builtins.event.event_listener',
            arguments = {
                event = 'collision',
                targetComponent = 'rope.builtins.collision.aabb',
                targetFunction = 'resolve'
            }
        },
    }
    for _, component in ipairs(eventComponents) do
        bulletObject:buildAndAddComponent(component)
    end
    Component.static.k = Component.k + 1
end

return Component

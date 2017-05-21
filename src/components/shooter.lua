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
    -- add an AABB to bullet for collision detection
    local aabb = rope.GameObject(
        self.gameScene, 'Bullet AABB', {position = {
            x = 0, y = 0}
        }, bulletObject
    )
    bulletObject:addChild(aabb)
    -- add an AABB tag component to AABB game object
    local collider = aabb:buildAndAddComponent({
        script = 'rope.builtins.collision.aabb',
        arguments = {sizeFromImage = true}
    })
    collider.resolve = function(self, other)
        self.gameObject:destroy()
        other:destroy()
    end
    aabb:buildAndAddComponent({
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
            script = 'components.event.collision_trigger',
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
        aabb:buildAndAddComponent(component)
    end
end

return Component

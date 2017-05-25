return {
    components = {
        {
            script = 'components.movement.velocity',
            -- give vx
        },
        {
            script = 'rope.builtins.graphics.image_renderer',
            -- give filename
        },
        -- collision
        {
            script = 'rope.builtins.colliders.rectangle_collider',
            arguments = {
                group = 'bullet',
                dimsFrom = 'rope.builtins.graphics.image_renderer'
            }
        },
        {
            script = 'components.colliders.ignore_source_objects'
        },
        {
            script = 'components.resolvers.destroy_on_collide',
            arguments = {
                resolvedGroups = {
                    player = {destroySelf = true, destroyOther = true},
                    enemy = {destroySelf = true, destroyOther = true},
                    screen_borders = {destroySelf = true}
                }
            }
        },
    }
}

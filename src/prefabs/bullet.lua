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
        {script = 'components.die_out_of_screen'},
        -- collision
        {
            script = 'rope.builtins.colliders.rectangle_collider',
            arguments = {
                group = 'bullet',
                dimsFrom = 'rope.builtins.graphics.image_renderer'
            }
        },
        {
            script = 'rope.builtins.colliders.ignore_source_objects'
        },
        {
            script = 'components.resolvers.destroy_on_collide',
            arguments = {
                resolvedGroups = {
                    player = {destroySelf = true},
                    enemy = {destroySelf = true},
                }
            }
        },
        {
            script = 'rope.builtins.graphics.rectangle_renderer',
            arguments = {
                dimsFrom = 'rope.builtins.graphics.image_renderer',
                mode = 'line',
                isDebug = true
            }
        },
    }
}

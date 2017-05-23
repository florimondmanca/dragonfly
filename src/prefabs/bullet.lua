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
        -- rectangle collider
        {
            script = 'rope.builtins.colliders.rectangle_collider',
            arguments = {
                collideGroup = 'bullet',
                dimsFrom = 'rope.builtins.graphics.image_renderer'
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

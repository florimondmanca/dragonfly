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
        -- collision AABB
        {
            script = 'rope.builtins.colliders.aabb',
            arguments = {
                collideGroup = 'bullet',
                sizeFrom = 'image'
            }
        },
        {
            script = 'rope.builtins.graphics.rectangle_renderer',
            arguments = {
                sizeFrom = 'image',
                mode = 'line',
                isDebug = true
            }
        },
    }
}

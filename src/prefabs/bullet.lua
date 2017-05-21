return {
    components = {
        {
            script = 'components.velocity',
            -- give vx
        },
        {
            script = 'rope.builtins.graphics.image_renderer',
            -- give filename
        },
        {script = 'components.die_out_of_screen'},
        -- collision AABB
        {
            script = 'rope.builtins.collision.aabb',
            arguments = {
                collideGroup = 'bullet',
                sizeFromImage = true
            }
        },
        {
            script = 'rope.builtins.graphics.rectangle_renderer',
            arguments = {
                sizeFromImage = true,
                mode = 'line',
                isDebug = true
            }
        },
    }
}

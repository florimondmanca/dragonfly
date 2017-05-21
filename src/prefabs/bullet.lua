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
            arguments = {sizeFromImage = true}
        },
        {script = 'components.collision.destroy_on_collide'},
        {
            script = 'rope.builtins.graphics.rectangle_renderer',
            arguments = {
                sizeFromImage = true,
                mode = 'line',
                isDebug = true
            }
        },
        -- collision events
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
}

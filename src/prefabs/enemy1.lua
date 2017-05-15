return {
    components = {
        -- image
        {
            script = 'rope.builtins.graphics.image_renderer',
            arguments = {filename = 'static/img/enemy.png'}
        },
        -- motion control
        {
            script = 'components.physics_motor',
            arguments = {axis = 'y', speed = 50, drag = 3}
        },
        {
            script = 'components.random_chase_motor_controller',
            arguments = {axis = 'y', min = 0.15, max = 0.85}
        }
    }
}

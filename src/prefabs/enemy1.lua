return {
    components = {
        -- image
        {
            script = 'rope.builtins.graphics.image_renderer',
            arguments = {filename = 'static/img/enemy.png'}
        },
        -- motion control
        {
            script = 'components.motor',
            arguments = {axis = 'y', speed = 50}
        },
        {
            script = 'components.random_chase_motor_controller',
            arguments = {axis = 'y'}
        }
    }
}

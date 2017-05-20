return {
    components = {
        -- image
        {
            script = 'rope.builtins.graphics.image_renderer',
            arguments = {filename = 'static/img/enemy.png'}
        },
        -- motion control
        {
            script = 'components.movement.physics_motor',
            arguments = {axis = 'y', speed = 50, drag = 5}
        },
        {
            script = 'components.movement.random_chase_motor_controller',
            arguments = {
                axis = 'y',
                min = 0.15, max = 0.85,
                motor_script = 'components.movement.physics_motor'
            }
        },
        -- shooting
        {
            script = 'components.shooter',
            arguments = {
                bulletSpeed = -200,
                filename = 'static/img/bullet-left.png',
            }
        },
        {
            script = 'components.random_shoot_controller',
            arguments = {meanWaitTime = 3, waitTimeSigma = 1}
        }
    }
}

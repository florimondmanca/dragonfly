return {
    components = {
        -- image
        {
            script = 'rope.builtins.graphics.image_renderer',
            arguments = {filename = 'static/img/enemy.png'}
        },
        -- motion control
        {
            script = 'components.movement.velocity'
        },
        {
            script = 'components.movement.physics_motor',
            arguments = {axis = 'y', speed = 150, drag = 5}
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
        },
        -- collision
        {
            script = 'rope.builtins.colliders.rectangle_collider',
            arguments = {
                collideGroup = 'enemy',
                dimsFrom = 'rope.builtins.graphics.image_renderer'
            }
        },
        {
            script = 'components.collision.destroy_on_collide',
            arguments = {
                onCollideWithGroup = {
                    bullet = {destroySelf = true, destroyOther = true}
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
        -- catch collision events
        {
            script = 'rope.builtins.event.event_listener',
            arguments = {
                event = 'collision',
                targetComponent = 'components.collision.destroy_on_collide',
                targetFunction = 'resolve'
            }
        },
    }
}

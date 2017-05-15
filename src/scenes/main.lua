return {
    name = 'MainScene',
    gameObjects = {
        {
            name = 'FPS',
            transform = {position = {x = 30, y = 30}},
            prefab = 'rope.builtins.prefabs.fps_renderer'
        },
        {
            name = 'DragonFly',
            transform = {
                position = {
                    x = 30,
                    y = love.graphics.getHeight()/2,
                },
            },
            components = {
                -- image
                {
                    script = 'rope.builtins.graphics.image_renderer',
                    arguments = {filename = 'static/img/dragonfly.png'}
                },
                -- motion control
                {
                    script = 'components.physics_motor',
                    arguments = {axis='y', speed=200, drag=10},
                },
                {
                    script = 'components.input_motor_controller',
                    arguments = {axis='y', keyPlus='down', keyMinus='up'}
                },
                {
                    script = 'components.shooter',
                    arguments = {
                        bulletSpeed = 500,
                        shiftX = 108,
                        shiftY = 24,
                        filename = 'static/img/bullet.png',
                    }
                },
                -- events
                {
                    script = 'rope.builtins.event.event_manager',
                    arguments = {events = {'shoot'}}
                },
                {
                    script = 'rope.builtins.event.trigger',
                    arguments = {key = 'space', event = 'shoot'}
                },
                {
                    script = 'rope.builtins.event.event_listener',
                    arguments = {
                        event = 'shoot',
                        targetComponent = 'components.shooter',
                        targetFunction = 'shoot'
                    }
                },
            },
        },
    },
}

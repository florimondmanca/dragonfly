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
                }
            },
        },
    },
}

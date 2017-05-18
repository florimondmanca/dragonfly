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
                -- shooting
                {
                    script = 'components.shooter',
                    arguments = {
                        bulletSpeed = 200,
                        shiftX = 108,
                        shiftY = 24,
                        filename = 'static/img/bullet-right.png',
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
            -- children = {
            --     {
            --         name = 'Some circle',
            --         transform = {position = {x = 0, y = 100}},
            --         prefab = 'prefabs.circle'
            --     }
            -- }
        },
        {
            name = 'Enemy',
            transform = {position = {
                x = 600,
                y = love.graphics.getHeight()/2
            }},
            prefab = 'prefabs.enemy1',
            prefabComponents = {
                {
                    script = 'components.physics_motor',
                    arguments = {speed = 70}
                }
            }
        },
        {
            name = 'Enemy',
            transform = {position = {
                x = 675,
                y = love.graphics.getHeight()/2
            }},
            prefab = 'prefabs.enemy1',
            prefabComponents = {
                {
                    script = 'components.physics_motor',
                    arguments = {speed = 40}
                }
            }
        },
        {
            name = 'Enemy',
            transform = {position = {
                x = 750,
                y = love.graphics.getHeight()/2
            }},
            components = {
                {
                    script = 'components.shooter',
                    arguments = {
                        bulletSpeed = -200,
                        filename = 'static/img/bullet-left.png',
                    }
                },
                {
                    script = 'components.random_shooter_controller',
                    arguments = {meanWaitTime = 3, waitTimeSigma = 1}
                }
            },
            prefab = 'prefabs.enemy1'
        }
    },
}

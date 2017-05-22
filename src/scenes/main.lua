return {
    name = 'MainScene',
    gameObjects = {
        -- utilities : cameras, info renderers...
        {
            name = 'FPS',
            transform = {position = {x = 30, y = 30}},
            prefab = 'rope.builtins.prefabs.fps_renderer',
            isDebug = true
        },
        {
            name = 'Event Manager',
            components = {
                {
                    script = 'rope.builtins.event.event_manager',
                    arguments = {events = {'shoot', 'collision'}}
                },
            },
        },
        -- sprites
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
                    script = 'components.velocity',
                },
                {
                    script = 'components.movement.physics_motor',
                    arguments = {axis='y', speed=200, drag=10},
                },
                {
                    script = 'components.movement.input_motor_controller',
                    arguments = {
                        axis='y',
                        keyPlus='down', keyMinus='up',
                        motor_script = 'components.movement.physics_motor'
                    }
                },
                {
                    script = 'components.movement.physics_motor',
                    arguments = {axis='x', speed=50, drag=10},
                },
                {
                    script = 'components.movement.input_motor_controller',
                    arguments = {
                        axis='x',
                        keyPlus='right', keyMinus='left',
                        motor_script = 'components.movement.physics_motor'
                    }
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
                    script = 'rope.builtins.event.key_trigger',
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
                -- camera
                {script = 'rope.builtins.camera.link'},
                {script = 'rope.builtins.camera.target'}
            },
            children = {
                {
                    name = 'health',
                    components = {
                        {
                            script = 'rope.builtins.graphics.text_renderer',
                            arguments = {text='15 HP'}
                        }
                    }
                },
            },
        },
        {
            name = 'Enemy',
            transform = {position = {
                x = 600,
                y = love.graphics.getHeight()/2
            }},
            prefab = 'prefabs.enemy1',
        },
        {
            name = 'Enemy',
            transform = {position = {
                x = 675,
                y = love.graphics.getHeight()/2
            }},
            prefab = 'prefabs.enemy1',
        },
        {
            name = 'Enemy',
            transform = {position = {
                x = 750,
                y = love.graphics.getHeight()/2
            }},
            prefab = 'prefabs.enemy1'
        }
    },
    camera = {
        name = 'Camera',
        components = {
            {script = 'rope.builtins.camera.camera'},
            {
                script = 'rope.builtins.camera.scroll',
                arguments = {axis = 'x', speed = 20}
            },
        },
    },
}

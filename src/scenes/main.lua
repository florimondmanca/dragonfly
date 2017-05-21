return {
    name = 'MainScene',
    gameObjects = {
        -- utilities : cameras, info renderers...
        {
            name = 'FPS',
            transform = {position = {x = 30, y = 30}},
            prefab = 'rope.builtins.prefabs.fps_renderer'
        },
        {
            name = 'Event Manager',
            components = {
                {
                    script = 'rope.builtins.event.event_manager',
                    arguments = {events = {'shoot'}}
                },
            }
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
                    script = 'components.movement.physics_motor',
                    arguments = {axis='y', speed=100, drag=10},
                },
                {
                    script = 'components.movement.input_motor_controller',
                    arguments = {
                        axis='y',
                        keyPlus='down', keyMinus='up',
                        motor_script = 'components.movement.physics_motor'
                    }
                },
                -- constant speed to the right
                {
                    script = 'components.movement.motor',
                    arguments = {axis = 'x', speed = 20}
                },
                {
                    script = 'components.movement.constant_speed_motor_controller',
                    arguments = {
                        axis = 'x',
                        motor_script = 'components.movement.motor',
                        direction = 1
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
                {
                    name = 'Camera',
                    components = {
                        {script = 'rope.builtins.camera.camera'},
                        {
                            script = 'rope.builtins.camera.preserve_parent_location',
                            arguments = {onX = true}
                        },
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
            prefabComponents = {
                {
                    script = 'components.movement.physics_motor',
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
                    script = 'components.movement.physics_motor',
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
            prefab = 'prefabs.enemy1'
        }
    },
}

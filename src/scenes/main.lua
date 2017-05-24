return {
    name = 'MainScene',
    settings = {
        graphics = {
            backgroundColor = {150, 150, 200}
        }
    },
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
                    arguments = {events = {
                        'player_shoot',
                    }}
                },
                {
                    script = 'rope.builtins.event.key_trigger',
                    arguments = {event = 'player_shoot', key = 'space'}
                },
                {
                    script = 'rope.builtins.event.collision_trigger',
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
                    script = 'components.movement.velocity',
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
                -- collision
                {
                    script = 'rope.builtins.colliders.rectangle_collider',
                    arguments = {
                        dimsFrom = 'rope.builtins.graphics.image_renderer',
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
                -- shoot on event player_shoot
                {
                    script = 'rope.builtins.event.event_listener',
                    arguments = {
                        event = 'player_shoot',
                        targetComponent = 'components.shooter',
                        targetFunction = 'shoot'
                    }
                },
                -- camera
                {script = 'rope.builtins.camera.link'},
                -- {script = 'rope.builtins.camera.target'}
            },
        },
        {
            name = 'Enemy',
            transform = {position = {
                x = 600,
                y = love.graphics.getHeight()/2
            }},
            prefab = 'prefabs.enemy',
        },
        {
            name = 'Enemy',
            transform = {position = {
                x = 675,
                y = love.graphics.getHeight()/2
            }},
            prefab = 'prefabs.enemy',
        },
        {
            name = 'Enemy',
            transform = {position = {
                x = 750,
                y = love.graphics.getHeight()/2
            }},
            prefab = 'prefabs.enemy'
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

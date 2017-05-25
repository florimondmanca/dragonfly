local w, h = love.graphics.getDimensions()

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
                    y = h/2,
                },
            },
            components = {
                -- image
                {
                    script = 'rope.builtins.graphics.sprite_animation',
                    arguments = {
                        sheetName = 'static/sheets/bird',
                        fps = 30,
                    }
                },
                -- motion control
                {
                    script = 'components.movement.velocity',
                    arguments = {vx = 20},
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
                        shiftX = 55,
                        shiftY = 34,
                        filename = 'static/img/bullet-right.png',
                    }
                },
                {
                    script = 'rope.builtins.event.event_listener',
                    arguments = {
                        event = 'player_shoot',
                        targetComponent = 'components.shooter',
                        targetFunction = 'shoot'
                    }
                },
                -- collision
                {
                    script = 'rope.builtins.colliders.rectangle_collider',
                    arguments = {
                        group = 'player',
                        dimsFrom = 'rope.builtins.graphics.sprite_animation',
                    }
                },
                {
                    script = 'components.resolvers.block',
                    arguments = {
                        resolvedGroups = {
                            screen_borders = {block = true},
                        },
                    }
                },
            },
        },
        {
            name = 'Enemy',
            transform = {position = {
                x = 600,
                y = h/2
            }},
            prefab = 'prefabs.enemy',
        },
        {
            name = 'Enemy',
            transform = {position = {
                x = 675,
                y = h/2
            }},
            prefab = 'prefabs.enemy',
        },
        {
            name = 'Enemy',
            transform = {position = {
                x = 750,
                y = h/2
            }},
            prefab = 'prefabs.enemy'
        },
        -- screen borders
        require('prefabs.screen_borders')(w, h),
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

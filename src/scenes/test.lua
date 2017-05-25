return {
    name = 'TestScene',
    settings = {
        graphics = {
            backgroundColor = {150, 150, 150},
        },
    },
    gameObjects = {
        {
            name = 'FPS',
            transform = {position = {x = 30, y = 30}},
            prefab = 'rope.builtins.prefabs.fps_renderer',
            isDebug = true,
        },
        {
            name = 'Event manager',
            components = {
                {script = 'rope.builtins.event.collision_trigger'}
            },
        },
        {
            name = 'Rectangle 1',
            transform = {position = {x = 200, y = 200}},
            components = {
                {
                    script = 'rope.builtins.colliders.rectangle_collider',
                    arguments = {
                        width = 200,
                        height = 300,
                        group = 'rectangle1',
                        static = true,
                    }
                },
                {
                    script = 'components.resolvers.block',
                    arguments = {resolvedGroups = {
                        rectangle2 = {block = true}
                    }}
                }
            }
        },
        {
            name = 'Rectangle 2',
            components = {
                {
                    script = 'rope.builtins.colliders.rectangle_collider',
                    arguments = {
                        width = 100,
                        height = 50,
                        group = 'rectangle2',
                        -- static = true
                    }
                },
                {script = 'rope.builtins.mouse.link'},
            }
        }
    }
}

return {
    name = 'TestScene',
    settings = {
        graphics = {
            backgroundColor = {150, 150, 150},
        },
    },
    gameObjects = {
        {
            name = 'Event Manager',
            components = {
                {
                    script = 'rope.builtins.event.collision_trigger',
                },
            },
        },
        {
            name = 'Edge',
            transform = {position = {x = 400, y = 300}},
            components = {
                {
                    script = 'rope.builtins.colliders.edge_collider',
                    arguments = {point1 = {x=0, y=-100}, point2={x=0, y=100}},
                },
            }
        },
        {
            name = 'Edge',
            transform = {position = {x = 400, y = 300}},
            components = {
                {
                    script = 'rope.builtins.colliders.edge_collider',
                    arguments = {point1 = {x=200, y=-100}, point2={x=0, y=100}},
                },
                {script = 'rope.builtins.mouse.link'}
            }
        },
        -- {
        --     name = 'Rectangle',
        --     transform = {position = {x = 400, y = 300}},
        --     components = {
        --         {
        --             script = 'rope.builtins.colliders.rectangle_collider',
        --             arguments = {
        --                 width = 300,
        --                 height = 200
        --             },
        --         },
        --     }
        -- },
        -- {
        --     name = 'Circle',
        --     components = {
        --         {
        --             script = 'rope.builtins.colliders.circle_collider',
        --             arguments = {radius = 100},
        --         },
        --         {script = 'rope.builtins.mouse.link'}
        --     }
        -- },
    }
}

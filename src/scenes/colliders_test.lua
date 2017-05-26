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
                {script = 'rope.builtins.mouse.link'}
            }
        },
        {
            name = 'Polygon',
            transform = {position = {x = 400, y = 300}},
            components = {
                {
                    script = 'rope.builtins.colliders.polygon_collider',
                    arguments = {
                        points = {200, 200, 400, 300, 250, 450}
                    }
                },
            }
        },
    }
}

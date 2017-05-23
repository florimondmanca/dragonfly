return {
    name = 'TestScene',
    settings = {
        graphics = {
            backgroundColor = {150, 150, 150},
        },
    },
    gameObjects = {
        {
            name = 'Rectangle',
            transform = {position = {x = 400, y = 300}},
            components = {
                {
                    script = 'rope.builtins.graphics.rectangle_renderer',
                    arguments = {width = 200, height = 100},
                }
            }
        },
        {
            name = 'Circle',
            transform = {position = {x = 400, y = 300}},
            components = {
                {
                    script = 'rope.builtins.graphics.circle_renderer',
                    arguments = {radius = 100}
                },
                {
                    script = 'rope.builtins.mouse.link'
                }
            }
        }
    }
}

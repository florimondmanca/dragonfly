return {
    name = 'MenuScene',
    settings = {
        graphics = {
            backgroundColor = {50, 50, 60},
            defaultFont = 'static/font/pixelfont.ttf',
        },
    },
    gameObjects = {
        {
            name = 'FPS',
            transform = {position = {x = 30, y = 30}},
            prefab = 'rope.builtins.prefabs.fps_renderer',
            isDebug = true
        },
        {
            name = 'EventManager',
            components = {
                {
                    script = 'rope.builtins.event.event_manager',
                    arguments = {events = {'start', 'click'}}
                },
                {
                    script = 'rope.builtins.event.click_trigger',
                    arguments = {event = 'click'}
                },
            }
        },
        {
            name = 'Title',
            transform = {
                position = {x = love.graphics.getWidth()/2, y = 100}
            },
            components = {
                {
                    script = 'rope.builtins.graphics.text_renderer',
                    arguments = {text = 'DragonFly'}
                }
            }
        },
        -- buttons
        {
            name = 'Button 1',
            transform = {position = {x = love.graphics.getWidth()/2, y = 300}},
            prefab = 'prefabs.text_button',
            prefabComponents = {
                {
                    script = 'rope.builtins.graphics.text_renderer',
                    arguments = {text = 'Play'}
                },
                {
                    script = 'rope.builtins.event.on_click',
                    arguments = {onClick = function (self)
                        local x, y = self.gameScene.camera:mousePosition()
                        if self.collider.shape:contains({x=x, y=y}) then
                            print('Clicked play')
                            self.gameScene:load('scenes/main.lua')
                        end
                    end}
                },
            }
        }
    },
}

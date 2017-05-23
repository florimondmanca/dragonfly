return {
    components = {
        {
            script = 'rope.builtins.graphics.text_renderer',
            arguments = {text = 'Button'}
        },
        {
            script = 'rope.builtins.colliders.aabb',
            arguments = {
                dimsFrom = 'text'
            }
        },
        -- debug
        {
            script = 'rope.builtins.graphics.rectangle_renderer',
            arguments = {
                mode = 'line',
                dimsFrom = 'text',
                isDebug = true,
            }
        },
        -- click trigger
        {
            script = 'rope.builtins.event.click_trigger',
            arguments = {event = 'click'}
        },
        -- click listener
        {
            script = 'rope.builtins.event.event_listener',
            arguments = {
                event = 'click',
                targetComponent = 'rope.builtins.event.on_click',
                targetFunction = 'onClick',
            }
        },
        -- click action
        {
            script = 'rope.builtins.event.on_click',
            arguments = {onClick = function (self)
                print('Clicked!')
            end}
        },
    }
}

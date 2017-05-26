return {
    components = {
        {
            script = 'rope.builtins.graphics.text_renderer',
            arguments = {text = 'Button', alignCenter = true}
        },
        {
            script = 'components.rectangle_shape',
            arguments = {shapeFrom = 'rope.builtins.graphics.text_renderer'}
        },
        {
            script = 'components.button',
            arguments = {button = 1}
        },
    }
}

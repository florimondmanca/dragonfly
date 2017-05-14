return {
    name = 'Controllable',
    components = {
        {
            script = 'components.motor',
            arguments = {axis='x', speed=100},
        },
        {
            script = 'components.input_motor_controller',
            arguments = {axis='x', keyPlus='right', keyMinus='left'}
        },
        {
            script = 'components.motor',
            arguments = {axis='y', speed=100},
        },
        {
            script = 'components.input_motor_controller',
            arguments = {axis='y', keyPlus='down', keyMinus='up'}
        },
    }
}

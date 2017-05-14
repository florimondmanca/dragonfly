return {
    name = 'Motor Vertical',
    components = {
        {
            script = 'components.physics_motor',
            arguments = {axis='y'},
        },
        {
            script = 'components.input_motor_controller',
            arguments = {axis='y', keyPlus='down', keyMinus='up'}
        }
    }
}

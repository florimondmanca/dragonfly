local lume = require 'rope.lib.lume'


local M = {}

function M.isInstanceOf(cls, object, name)
    name = name or 'value'
    local objectType = object.isInstanceOf and object.class.name or type(object)
    assert(
        object.isInstanceOf and object:isInstanceOf(cls),
        lume.format(
            '{name} must be a {cls}, but was {o} (a {ot})',
            {name=name, cls=cls.name, o=object, ot=objectType}
        )
    )
end

function M.isInstanceOfOrNil(cls, object, name)
    if object == nil then return end
    M.isInstanceOf(cls, object, name)
end

function M.isIn(list, value, name)
    name = name or 'value'
    assert(
        lume.any(list, function(v) return v == value end),
        lume.format(
            '{name} must be one of {names}, but was {value}',
            {name=name, names=table.concat(list, ', '), value=value}
        )
    )
end

function M.hasType(desiredType, value, name)
    name = name or 'value'
    if type(value) ~= desiredType then
        error(lume.format(
            '{1} must be a {2}, but was {3} (a {4})',
            {name, desiredType, value, type(value)}
        ))
    end
end

function M.haveXandY(...)
    lume({...}):each(function(a)
        assert(a.x and a.y, 'both operands must have x and y fields defined')
    end)
end


return M

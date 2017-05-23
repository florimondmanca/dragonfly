local M = {}

function M.isInstanceOf(cls, object, name)
    name = name or 'value'
    local objectName = object.isInstanceOf and object.class.name or type(object)
    assert(object.isInstanceOf and object:isInstanceOf(cls),
        name .. ' must be a ' .. cls.name .. ', but was ' .. tostring(object) .. ' (a ' .. objectName .. ')'
    )
end

function M.isInstanceOfOrNil(cls, object, name)
    if object == nil then return end
    M.isInstanceOf(cls, object, name)
end

function M.isIn(list, value, name)
    name = name or 'value'
    local isIn = false
    for _, v in ipairs(list) do
        if v == value then isIn = true end
    end
    assert(isIn, name .. ' must be one of ' .. table.concat(list, ', ') .. ', but was ' .. tostring(value))
end

function M.hasType(desiredType, value, name)
    name = name or 'value'
    if type(value) ~= desiredType then
        error(name .. ' must be a ' .. desiredType .. ', but was ' .. tostring(value) .. ' (a ' .. type(value) .. ')')
    end
end

--- tests if a value is a strictly positive number.
-- @param value a value to test.
-- @tparam string name the name of the value (for error reporting).
-- @raise error if value is negative or zero.
function M.isPositiveNumber(value, name)
    name = name or 'value'
    if type(value) ~=  'number' or value <= 0 then
        error(name .. ' must be a positive integer, but was ' .. tostring(value) .. '(' .. type(value) .. ')')
    end
end

function M.haveXandY(...)
    for _, a in ipairs{...} do
        assert(a.x and a.y, 'both operands must have x and y fields defined')
    end
end

--- tests if a table has rect-like attributes (x, y, w > 0, h > 0).
-- @tparam table table
-- @raise error if table doesn't provide rect-like attributes.
function M.isRect(table)
    M.hasType('number', table.x, 'x')
    M.hasType('number', table.y, 'y')
    M.isPositiveNumber(table.w, 'w')
    M.isPositiveNumber(table.h, 'h')
end

return M

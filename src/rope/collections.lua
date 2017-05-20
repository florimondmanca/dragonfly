---
-- collections.lua
-- useful collection manipulation functions.
--
-- @module collections


--- finds first index of value in an ordered list
-- @param list a list of values
-- @param value a value to look the index of for
-- @param keyfunc filtering function, must return a boolean (optional)
-- @return the index if found, `nil` otherwise
local function index(list, value, keyfunc)
	for i, entity in ipairs(list) do
		if (keyfunc and keyfunc(entity) == value) or (not keyfunc and entity == value) then
			return i
		end
	end
end

--- finds all indexes of value in an ordered list
-- @param list a list of values
-- @param value a value to look for index of for
-- @param keyfunc filtering function, must return a boolean (optional)
-- @return a table of the indices if any found, `nil` otherwise
-- @see index
local function indices(list, value, keyfunc)
	local indexes = nil
	for i, entity in ipairs(list) do
		if (keyfunc and keyfunc(entity) == value) or (not keyfunc and entity == value) then
			if not indexes then
				indexes = {i}
			else
				indexes[#indexes + 1] = i
			end
		end
	end

	return indexes
end

--- performs shallow copy of a table
-- @param t the table
-- @return a shallow copy of `t`
local function copy(t)

	if type(t) == "table" then
		local _copy = {}

		for k,v in pairs(t) do
			_copy[k] = v
		end

		return _copy
	else
		return t
	end
end

--- performs a recursive deepcopy of a table
-- warning : avoid using for very large/deep tables
-- circular references will not be copied.
local function deepcopy(t, found)
	if type(t) == "table" then
		if not found or not index(found, t) then
			found = copy(found) or {}
			found[#found + 1] = t

			local _copy = {}
			for k, v in pairs(t) do
				_copy[k] = deepcopy(v, found)
			end

			return _copy
		else
			print (index(found, t), t)
			return nil
		end
	else
		return t
	end
end

return {
	copy = copy,
	deepcopy = deepcopy,
	index = index,
	indices = indices
}

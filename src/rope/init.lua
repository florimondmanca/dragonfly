local class = require 'rope.class'
local geometry = require 'rope.geometry'
local collections = require 'rope.collections'


-------------------------
-- Auxiliary functions --
-------------------------

local function assertIn(list, value)
    local isIn = false
    for _, v in ipairs(list) do
        if v == value then isIn = true end
    end
    assert(isIn, tostring(value) ..' not found in list')
end

local function assertType(desiredType, value, name)
    if type(value) ~= desiredType then
        error(name .. ' must be a ' .. desiredType .. ', but was ' .. tostring(value) .. '(a ' .. type(value) .. ')')
    end
end

--- tests if a value is a strictly positive number.
-- @param value a value to test.
-- @tparam string name the name of the value (for error reporting).
-- @raise error if value is negative or zero.
local function assertIsPositiveNumber(value, name)
    if type(value) ~=  'number' or value <= 0 then
        error(name .. ' must be a positive integer, but was ' .. tostring(value) .. '(' .. type(value) .. ')')
    end
end

local function assertTableOfLength(n, table, name)
    assertType('table', table, name)
    if type(n) == 'number' then n = {n}
    else assertType('table', n, 'length') end
    local pass = false
    for _, i in ipairs(n) do
        if #table == i then
            pass = true
        end
    end
    assert(pass)
end


---------------
-- Component --
---------------

local Component = class('Component')

function Component:initialize(arguments)
    self.gameObject = nil
    for k, v in pairs(arguments or {}) do
        self[k] = v
    end
end

--- callback function, invoked any time a component is attached to a game object.
function Component:awake()
    -- callback
end

--- use this to make a Component require certain arguments.
-- Example :
--    ```self:require(arguments, 'imageFilename', 'size')```
-- This will raise an error if the arguments table of the component
-- declaration does not include 'imageFilename' and 'size' fields.
-- @param arguments a table of arguments.
-- @param ... a varargs of strings.
-- @raise error if any of the required arguments is missing.
function Component:require(arguments, ...)
    arguments = arguments or {}
    for _, argName in ipairs{...} do
        if arguments[argName] == nil then
            error(argName .. ' must be declared for component ' .. tostring(self) .. ', nil given')
        end
    end
end


--- callback function. use to declare what components this component needs to work correctly.
function Component:worksWith()
    -- callback function
    return {}
end


--- use this to make a Component require the owner to have other specified components.
-- Example :
--     ```self:requireComponents('rope.builtins.graphics.image_renderer')
-- @tparam varargs components a varargs of component scripts of classes
-- @raise error if any of the required components is missing (with a list of all missing components)
function Component:requireComponents()
    local worksWith = self:worksWith()
    assertType('table', worksWith, 'worksWith')

    local missing = {}

    for _, componentScripts in ipairs(self:worksWith()) do
        -- if single, adapt to a table
        if type(componentScripts) ~= 'table' then
            componentScripts = {componentScripts}
        end

        -- look for one of the component scripts
        local found = false
        for _, script in ipairs(componentScripts) do
            if self.gameObject:getComponent(script) then
                found = true
            end
        end
        -- if no matching component script was found, at to
        if not found then
            if #componentScripts == 1 then
                table.insert(missing, componentScripts[1])
            else
                table.insert(missing,
                    'one of {' .. table.concat(componentScripts, ', ') .. '}')
            end
        end
    end
    if #missing > 0 then
        error('Component ' .. self.class.name .. ' from ' .. self.gameObject.name ..
        ' required the following missing components to work with: '
        .. table.concat(missing, ', '))
    end
end

--- callback function, called once a frame to update the component.
-- @param dt delta time as passed to love.update().
-- @tparam bool firstUpdate true on the very first frame update
function Component:update() end

--- loads a component *class* from a filename.
-- @param filename the filename to the component class.
local function loadComponent(filename)
    local componentClass = require(filename)
    assert(componentClass, 'Could not find component at ' .. filename)
    return componentClass
end


-----------------
-- Game Entity --
-----------------

--- maintains global position and rotation of a GameEntity.
--NOTE: only GameEntity:init() and GameEntity:update() should call this function directly.
local function maintainTransform(self)
	-- clamp rotation between 0 and 360 degrees (e.g., -290 => 70)
	self.transform.rotation = self.transform.rotation % 360

	local t = self.transform
	local p

	if self.parent and next(self.parent) ~= nil then
		p = self.parent.globalTransform
	elseif self.gameScene and next(self.gameScene) ~= nil then
		p = self.gameScene.transform
	else
		self.globalTransform = self.transform
		return
	end

	self.globalTransform = geometry.Transform({
		position = p.position,
		size = geometry.Vector({
			x = t.size.x * p.size.x,
			y = t.size.y * p.size.y
		}),
		rotation = t.rotation + p.rotation
	})

	self.globalTransform.position = self.globalTransform.position + geometry.Vector({
		x = t.position.x * p.size.x,
		y = t.position.y * p.size.y
	}):rotate(p.rotation)
end

local GameEntity = class('GameEntity')

--- initializes an entity.
-- @tparam Transform transform a Transform or a table in the form: `{position={x=, y=}, size={x=, y=}, rotation=}`.
-- @param parent an optional parent for the entity.
-- @see Transform
function GameEntity:initialize(transform, parent)
    transform = transform or {}
    if transform.class == geometry.Transform then
        self.transform = transform
    else
        self.transform = geometry.Transform(transform)
    end

    self.children = {}

    if parent then
        parent:addChild(self)
    end
    maintainTransform(self)
end

--- adds a child to an entity.
-- @tparam GameEntity child
-- @tparam bool trackParent if `true` (the default), assigns this entity is assigned to the child.parent field.
function GameEntity:addChild(child, trackParent)
    assert(child.isInstanceOf and child:isInstanceOf(GameEntity),
        'child must be a GameEntity, it is: ' .. child.name)
    assert(child ~= self, 'circular reference: cannot add self as child')

    if trackParent == nil then trackParent = true end

    table.insert(self.children, child)

    if trackParent then child.parent = self end
end

--- removes a child from an entity (has no effect is child is not one of the entity's children).
-- @tparam GameEntity child
function GameEntity:removeChild(child)
	local index = collections.index(self.children, child)
	if index then
		table.remove(self.children, index)
        return true
	end
    return false
end

--- recursively prints a view of the entity's child tree to the console.
function GameEntity:printChildren(level)
    level = level or 0
    if level == 0 then print('Children of ' .. self.name .. ':') end
    for _, child in ipairs(self.children) do
        print(string.rep('\t', level) .. '> ' .. child.name)
        child:printChildren(level + 1)
    end
end

--- updates the entity and all its children.
-- @param dt delta time as given by love.update().
-- @tparam bool firstUpdate true on the first frame update
function GameEntity:update(dt, firstUpdate)
    local status, err = pcall(function()
        for _, child in ipairs(self.children) do
            child:update(dt, firstUpdate)
        end
    end)
    if not status then error(err .. ' (occured in ' .. self.name .. ', ' .. tostring(self) .. ')') end
end

--- moves an entity.
-- @param number dx
-- @param number dy
function GameEntity:move(dx, dy)
    self.transform.position = self.transform.position + geometry.Vector(dx, dy)
end

--- moves an entity to a specified position.
-- @param number x
-- @param number y
function GameEntity:moveTo(x, y)
    self.transform.position = geometry.Vector(x, y)
end

--- default callback functions for game entities.
local ENTITIES_CALLBACKS = {
    'keypressed', 'keyreleased', 'mousepressed', 'mousemoved',
    'mousereleased', 'quit', 'windowresize', 'visible'
}
for _, f in ipairs(ENTITIES_CALLBACKS) do
    GameEntity[f] = function(self, ...)
        for _, child in ipairs(self.children) do
            child[f](child, ...)
        end
    end
end


----------------
-- GameObject --
----------------

--- helper function for getting components of a game object.
-- @tparam GameObject self
-- @tparam Component componentType can also be a string refering to the component's module filename.
-- @tparam number num number of components to find (no error raised if less than `num` components found).
-- @tparam func filter optional filter function: f(component) -> true or false.
local function getComponents(self, componentType, num, filter)
    filter = filter or function() return true end
    if type(componentType) == 'string' then
        componentType = require(componentType)
        assert(componentType, 'Component ' .. tostring(componentType) .. ' does not exist')
    end
    local found = {}
    for _, component in ipairs(self.components) do
        if component:isInstanceOf(componentType) and filter(component) then
            table.insert(found, component)
        end
        if #found >= num then return found end
    end
    return found
end

local GameObject = GameEntity:subclass('GameObject')

--- initializes a game object.
-- @tparam GameScene scene
-- @tparam string name the object's name (empty string if nil given).
-- @tparam Transform transform the game object's transform.
-- @tparam GameObject parent an optional parent to the game object.
-- @tparam bool trackObject pass false to *not* add the object to the scene's game objects list
function GameObject:initialize(scene, name, transform, parent, trackObject)
    if trackObject ~= false then trackObject = true end
    self.globals = scene.globals
    self.name = name or ''
    GameEntity.initialize(self, transform)
    scene:addGameObject(self, trackObject)
    -- if given, parent must be a game object, else it is the scene
    if parent then
        assert(parent.isInstanceOf and parent:isInstanceOf(GameObject),
        "parent must be GameObject, it is: " .. parent.name)
        parent:addChild(self)
    else
        scene:addChild(self, false)
    end
    self.components = {}
end


--- updates the game object, all its components and all its children.
-- @param dt delta time as given by love.update().
-- @tparam bool firstUpdate true on the first frame update
function GameObject:update(dt, firstUpdate)
    maintainTransform(self)
    for _, component in ipairs(self.components) do
        component:update(dt, firstUpdate)
    end
    GameEntity.update(self, dt, firstUpdate)
end

--- draws the game object by calling draw() on all its components.
function GameObject:draw(debug)
    for _, component in ipairs(self.components) do
        if component.draw then component:draw(debug) end
    end
end

--- adds a child to a game object.
-- @param child
function GameObject:addChild(child)
	-- if child is at the top of the hierarchy, push it down
	child.gameScene:removeChild(child)
    -- remove child from its possible parent
    if child.parent and child.parent:isInstanceOf(GameObject) then
        child.parent:removeChild(child)
    end
	GameEntity.addChild(self, child)
end

--- adds a component to a game object.
-- @tparam Component component
function GameObject:addComponent(component)
    table.insert(self.components, component)
    component.gameObject = self
    component.gameScene = self.gameScene
    component.globals = self.gameScene.globals
    component:requireComponents()
    component:awake()
    return component
end

--- build a component from its table representation and adds it to the game object
-- @tparam table componentTable table representation of a component
function GameObject:buildAndAddComponent(componentTable)
    local componentClass = require(componentTable.script)
    assert(componentClass.isSubclassOf and
    componentClass:isSubclassOf(Component), 'Script ' .. componentTable.script .. ' does not return a Component')
    return self:addComponent(componentClass(componentTable.arguments or {}))
end

--- gets one component of a game object based on its type.
-- @tparam Component componentType the component's class or a string refering to the component's module filename.
-- @tparam func filter optional filter function: f(component) -> true or false.
function GameObject:getComponent(componentType, filter)
    return getComponents(self, componentType, 1, filter)[1]
end

--- gets all components of a game object of a given type.
-- @tparam Component componentType the component's class or a string refering to the component's module filename.
-- @tparam func filter optional filter function: f(component) -> true or false.
function GameObject:getComponents(componentType, filter)
    return getComponents(self, componentType, nil, filter)
end

-- function GameObject:removeComponent(componentType)
--     for i, c in ipairs(self.components) do
--         if c:isInstanceOf(componentClass) then
--             return table.remove(self.components, i)
--         end
--     end
-- end

--- destroys a game object
function GameObject:destroy()
    self.gameScene:removeGameObject(self)
end

-- register default callback functions.
for _, f in ipairs(ENTITIES_CALLBACKS) do
    GameObject[f] = function(self, ...)
        for _, component in ipairs(self.components) do
            if component[f] then component[f](component, ...) end
        end
        GameObject.super[f](self, ...)
    end
end


---------------
-- GameScene --
---------------

--- merges a settings table and the defaults settings table.
-- @tparam table settings
-- @tparam table defaults the default settings.
local function createSettingsTable(settings, defaults)
    settings = settings or {}
    defaults = defaults or require('rope.defaults')

    -- assign defaults for fields not defined in settings
    for sectionName, section in pairs(defaults) do
        -- assign non-defined sections
        if not settings[sectionName] then
            settings[sectionName] = section
        -- if section is defined, assign its non-defined options
        else
            if type(section) == 'table' then
                for optionName, option in pairs(section) do
                    if not settings[sectionName][optionName] then
                        settings[sectionName][optionName] = option
                    end
                end
            -- some sections are not tables,
            -- in this case, only assure that the value is well defined
            else
                settings[sectionName] = settings[sectionName] or section
            end
        end
    end
    return settings
end

--- merges the object table representation's prefabComponents with its prefab's.
-- @tparam table object a game object in its table representation.
local function getPrefabComponents(object)
    local prefabTable = require(object.prefab)
    local components = {}
    for _, component in ipairs(prefabTable.components) do
        table.insert(components, component)
    end

    if not object.prefabComponents then
        return components
    end

    for _, component in ipairs(components) do
        component.arguments = component.arguments or {}
        for _, overridden in ipairs(object.prefabComponents) do
            if component.script == overridden.script then
                for k, v in pairs(overridden.arguments) do
                    component.arguments[k] = v
                end
            end
        end
    end
    return components
end

--- builds a game object from its table representation.
-- @tparam GameScene scene
-- @tparam table object a game object in its table representation.
local function buildObject(scene, object, trackObject)
    -- create the game object and add it to the scene
    local gameObject = GameObject(
        scene, object.name, object.transform, nil, trackObject)
    -- get components from prefab if given
    if object.prefab then
        assert(type(object.prefab) == 'string' and object.prefab ~= '',
            'Prefab must be non-empty string')
        object.components = object.components or {}
        for _, component in ipairs(getPrefabComponents(object)) do
            table.insert(object.components, component)
        end
    end
    -- add components
    for _, componentTable in ipairs(object.components) do
        gameObject:buildAndAddComponent(componentTable)
    end
    -- add children
    for _, child in ipairs(object.children or {}) do
        gameObject:addChild(buildObject(scene, child))
    end
    return gameObject
end

local GameScene = GameEntity:subclass('GameScene')

--- initializes a game scene
-- @tparam string name the scene's name.
-- @tparam Transform the scene's transform.
function GameScene:initialize(name, transform)
    self.name = name or 'GameScene'
    self.gameObjects = {}
    self.globals = {}
    self.finishedFirstUpdate = false
    GameEntity.initialize(self, transform)
end

--- loads settings from a file, creates the settings table from it and assign it to the scene's settings.
-- @tparam string settingsFile
-- @see createSettingsTable
function GameScene:loadSettings(settingsFile)
    self.settings = createSettingsTable(love.filesystem.load(settingsFile)())
end

--- applies the settings to the game scene
function GameScene:applySettings()
    -- window
    love.window.setMode(self.settings.window.width, self.settings.window.height)
    love.window.setTitle(self.settings.window.title or 'Untitled')
    -- graphics
    love.graphics.setBackgroundColor(self.settings.graphics.backgroundColor)
    if self.settings.graphics.defaultFont then
        love.graphics.setNewFont(self.settings.graphics.defaultFont)
    end
end

--- loads a game scene from a scene file.
-- if `nil` is given, it is assumed that settings have already been loaded
-- thanks to loadSettings() and that these settings declare a firstScene field.
-- a string refering to the source scene file can also be given.
-- for maximum flexibility, a table representation of the scene can also be directly passed.
-- @tparam string src
-- @see GameScene.loadSettings
function GameScene:load(src)
    local typeS = type(src)
    local source = ''

    -- load the source game scene file if necessary
    if typeS == 'nil' then
        assert(self.settings, [[Settings not defined.
        You must call scene:loadSettings(settingsFilename) before
        scene:load().]])
        source = self.settings.firstScene
        assert(source ~= '', 'First scene not declared.')
        src = love.filesystem.load(source)()
    elseif typeS == 'string' then
        source = src
        src = love.filesystem.load(source)()
    else
        assert(typeS == 'table', 'src must be filename, module name or table')
        assert(src.gameObjects, 'src.gameObjects is required')
        assert(src.settings, 'src.settings is required')
    end

    self:initialize(src.name)
    self.source = source

    -- scene settings
    self.settings = createSettingsTable(src.settings, self.settings)
    self:applySettings()

    -- load game objects
    for _, object in ipairs(src.gameObjects) do
        if self.settings.debug or not object.isDebug then
            buildObject(self, object)
        end
    end
    -- load camera
    src.camera = src.camera or {
        name = 'Camera',
        transform = {position = {x = 0, y = 0}},
        components = {
            {script = 'rope.builtins.camera.camera'}
        }
    }
    self.camera = buildObject(self, src.camera, false)
end

--- adds a game object to the scene. The scene will then be accessible through the game object's `gameScene` attribute.
-- @tparam GameObject gameObject
function GameScene:addGameObject(gameObject, trackObject)
    if trackObject ~= false then trackObject = true end
    assert(gameObject.isInstanceOf and gameObject:isInstanceOf(GameObject),
    "Can only add GameObject to a GameScene")
    gameObject.gameScene = self
    if trackObject then table.insert(self.gameObjects, gameObject) end
end

--- removes a game object from the scene, as well as all its children
--- (its components will also be removed).
-- @tparam GameObject gameObject
function GameScene:removeGameObject(gameObject)
    local index = collections.index(self.gameObjects, gameObject)
	if index then
		table.remove(self.gameObjects, index)
	end
    self:removeChild(gameObject)
    -- for k, _ in pairs(gameObject) do gameObject[k] = nil end
end

--- updates the scene and all its game objects ;
-- @param dt delta time as given by love.update()
-- @tparam bool firstUpdate true on the first frame update
function GameScene:update(dt)
    maintainTransform(self)
    for _, child in ipairs(self.children) do
        self.camera:apply(child)
        child:update(dt, not self.finishedFirstUpdate)
    end
    if not self.finishedFirstUpdate then
        self.finishedFirstUpdate = true
    end
end

--- draws the game scene
function GameScene:draw()
    self.camera:set()
    for _, gameObject in ipairs(self.gameObjects) do
        gameObject:draw(self.settings.debug)
    end
    self.camera:unset()
end


return {
    Component = Component,
    GameObject = GameObject,
    GameScene = GameScene,
    buildObject = buildObject,
    loadComponent = loadComponent,
    assertIn = assertIn,
    assertType = assertType,
    assertIsPositiveNumber = assertIsPositiveNumber,
    assertTableOfLength = assertTableOfLength,
}

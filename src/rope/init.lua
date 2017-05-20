local class = require 'rope.class'
local geometry = require 'rope.geometry'
local collections = require 'rope.collections'


--[[ Component ]]--

local Component = class('Component')

function Component:initialize(arguments)
    self.gameObject = nil
    for k, v in pairs(arguments or {}) do
        self[k] = v
    end
end

function Component:awake()
    -- callback, invoked any time a component is attached to a game object
end

function Component:validate(arguments, ...)
    arguments = arguments or {}
    for _, argName in ipairs{...} do
        if arguments[argName] == nil then
            error(argName .. ' must be declared for component ' .. tostring(self) .. ', nil given')
        end
    end
end

function Component:update() end

local function loadComponent(filename)
    local componentClass = require(filename)
    assert(componentClass, 'Could not find component at ' .. filename)
    return componentClass
end


-- [[ Game Entity ]] --

local function maintainTransform(self)
	-- maintains global position and rotation
	--NOTE: only GameEntity:init() and GameEntity:update() should call this function directly

	--clamp rotation between 0 and 360 degrees (e.g., -290 => 70)
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

function GameEntity:addChild(child, trackParent)
    assert(child.isInstanceOf and child:isInstanceOf(GameEntity),
        'child must be a GameEntity, it is: ' .. child.name)
    assert(child ~= self, 'circular reference: cannot add self as child')

    if trackParent == nil then trackParent = true end

    table.insert(self.children, child)

    if trackParent then child.parent = self end
end

function GameEntity:removeChild(child)
	local index = collections.index(self.children, child)
	if index then
		table.remove(self.children, index)
	end
end

function GameEntity:printChildren(level)
    level = level or 0
    for _, child in ipairs(self.children) do
        print('> ' .. string.rep('\t', level), child.name)
        child:showChildren(level + 1)
    end
end

function GameEntity:update(dt)
    for _, child in ipairs(self.children) do
        child:update(dt)
    end
end

function GameEntity:move(dx, dy)
    self.transform.position = self.transform.position + geometry.Vector(dx, dy)
end

function GameEntity:moveTo(x, y)
    self.transform.position = geometry.Vector(x, y)
end

-- Default callback functions
for _, f in ipairs{'keypressed', 'keyreleased', 'mousepressed', 'mousemoved',
'mousereleased', 'quit', 'windowresize', 'visible'} do
    GameEntity[f] = function(self, ...)
        for _, child in ipairs(self.children) do
            child[f](child, ...)
        end
    end
end


--[[ GameObject ]]--

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

function GameObject:initialize(scene, name, transform, parent)
    self.globals = scene.globals
    self.name = name or ''
    GameEntity.initialize(self, transform)
    scene:addGameObject(self)
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

function GameObject:update(dt)
    maintainTransform(self)
    for _, component in ipairs(self.components) do
        component:update(dt)
    end
    GameEntity.update(self, dt)
end

function GameObject:draw()
    for _, component in ipairs(self.components) do
        if component.draw then component:draw() end
    end
end

function GameObject:addChild(child)
	-- if child is at the top of the hierarchy, push it down
	child.gameScene:removeChild(child)
    -- remove child from its possible parent
    if child.parent and child.parent:isInstanceOf(GameObject) then
        child.parent:removeChild(child)
    end
	GameEntity.addChild(self, child)
end

function GameObject:addComponent(component)
    table.insert(self.components, component)
    component.gameObject = self
    component.gameScene = self.gameScene
    component.globals = self.gameScene.globals
    component:awake()
end

function GameObject:getComponent(componentType, filter)
    return getComponents(self, componentType, 1, filter)[1] or
        error('No component ' .. tostring(componentType) .. ' found' ..
        (filter and ' with conditions ' .. tostring(filter) or ''))
end

function GameObject:getComponents(componentType, filter)
    return getComponents(self, componentType, nil, filter)
end

-- function GameObject:removeComponent(componentClass)
--     for i, c in ipairs(self.components) do
--         if c:isInstanceOf(componentClass) then
--             return table.remove(self.components, i)
--         end
--     end
-- end

function GameObject:destroy()
    self.gameScene:destroy(self)
end

-- Default callback functions
for _, f in ipairs{'keypressed', 'keyreleased', 'mousepressed', 'mousemoved',
'mousereleased', 'quit', 'windowresize', 'visible'} do
    GameObject[f] = function(self, ...)
        for _, component in ipairs(self.components) do
            if component[f] then component[f](component, ...) end
        end
        GameObject.super[f](self, ...)
    end
end


-- [[ GameScene ]] --

-- Helpers
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

local function buildObject(scene, object)
    -- create the game object and add it to the scene
    local gameObject = GameObject(
        scene, object.name, object.transform)

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
    for _, component in ipairs(object.components) do
        local componentClass = require(component.script)
        assert(componentClass.isSubclassOf and
        componentClass:isSubclassOf(Component), 'Script ' .. component.script .. ' does not return a Component')
        gameObject:addComponent(componentClass(component.arguments or {}))
    end
    -- add children
    for _, child in ipairs(object.children or {}) do
        gameObject:addChild(buildObject(scene, child))
    end
    return gameObject
end

local GameScene = GameEntity:subclass('GameScene')

function GameScene:initialize(name, transform)
    self.name = name or 'GameScene'
    self.gameObjects = {}
    self.globals = {}
    GameEntity.initialize(self, transform)
end

function GameScene:loadSettings(settingsFile)
    self.settings = createSettingsTable(love.filesystem.load(settingsFile)())
end

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
        buildObject(self, object)
    end

    -- if no camera was given in game objects, build a default camera
    if not self.camera then
        buildObject(self, {
            name = 'Camera',
            transform = {position = {x = 0, y = 0}},
            components = {
                {script = 'rope.builtins.camera.camera'}
            }
        })
    end
end

function GameScene:applySettings()
    -- window
    love.window.setMode(self.settings.window.width, self.settings.window.height)
    love.window.setTitle(self.settings.window.title or 'Untitled')
    -- graphics
    love.graphics.setBackgroundColor(self.settings.graphics.backgroundColor)
end

function GameScene:addGameObject(gameObject)
    assert(gameObject.isInstanceOf and gameObject:isInstanceOf(GameObject),
    "Can only add GameObject to a GameScene")
    gameObject.gameScene = self
    table.insert(self.gameObjects, gameObject)
end

function GameScene:destroy(gameObject)
    self.toDestroy = self.toDestroy or {}
    table.insert(self.toDestroy, gameObject)
end

function GameScene:removeGameObject(gameObject)
    local index = collections.index(self.gameObjects, gameObject)
	if index then
		table.remove(self.gameObjects, index)
	end
    self:removeChild(gameObject)

	for k in pairs(gameObject) do
		gameObject[k] = nil
	end
end

function GameScene:update(dt)
    maintainTransform(self)
    GameEntity.update(self, dt)
    for _, gameObject in ipairs(self.toDestroy or {}) do
        self:removeGameObject(gameObject)
    end
    self.toDestroy = {}
end

function GameScene:draw()
    self.camera:set()
    for _, object in ipairs(self.gameObjects) do
        object:draw()
    end
    self.camera:unset()
end


---

return {
    Component = Component,
    GameObject = GameObject,
    GameScene = GameScene,
    loadComponent = loadComponent,
}

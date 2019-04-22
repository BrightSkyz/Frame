local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

_G.Frame = {
	Modules = {
		Shared = {},
		Server = {}
	},
	Helpers = require(ReplicatedStorage.Modules.FrameHelpers)
}

function ScanPathAndRequire(path, isShared)
	for _, item in pairs(path:GetChildren()) do
		if item.ClassName == "Folder" and item.Name ~= "Disabled" then
			ScanPathAndRequire(item, isShared)
		elseif item.ClassName == "ModuleScript" then
			if isShared then
				_G.Frame.Modules.Shared[item.Name] = require(item)
			else
				_G.Frame.Modules.Server[item.Name] = require(item)
			end
		end
	end
end

function _G.Frame:GetRemoteEvent(eventName)
	if ReplicatedStorage.Events:FindFirstChild(eventName) == nil then
		local event = Instance.new("RemoteEvent")
		event.Name = eventName
		event.Parent = ReplicatedStorage.Events
	end
	return ReplicatedStorage.Events:FindFirstChild(eventName)
end

function _G.Frame:HandleEvent(eventName, handler)
	_G.Frame:GetRemoteEvent(eventName).OnServerEvent:Connect(function(...)
		handler(...)
	end)
end

function Init()
	
	-- [[ Shared Modules ]] --

	ScanPathAndRequire(ReplicatedStorage.Modules.Shared, true)
	
	-- Initialize the shared modules
	for _, module in pairs(_G.Frame.Modules.Shared) do
		if type(module.Init) == "function" then
			module:Init()
		end
	end
	
	-- Start the shared modules
	for _, module in pairs(_G.Frame.Modules.Shared) do
		if type(module.Start) == "function" then
			module:Start()
		end
	end
	
	-- Run post start the shared modules
	for _, module in pairs(_G.Frame.Modules.Shared) do
		if type(module.PostStart) == "function" then
			module:PostStart()
		end
	end
	
	-- [[ Server Modules ]] --
	
	ScanPathAndRequire(ServerScriptService.Modules, false)
	
	-- Initialize the server modules
	for _, module in pairs(_G.Frame.Modules.Server) do
		if type(module.Init) == "function" then
			module:Init()
		end
	end
	
	-- Start the server modules
	for _, module in pairs(_G.Frame.Modules.Server) do
		if type(module.Start) == "function" then
			module:Start()
		end
	end

	-- Run post start the server modules
	for _, module in pairs(_G.Frame.Modules.Server) do
		if type(module.PostStart) == "function" then
			module:PostStart()
		end
	end
end

Init()
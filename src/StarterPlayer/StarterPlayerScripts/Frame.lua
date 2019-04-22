local ReplicatedStorage = game:GetService("ReplicatedStorage")

_G.Frame = {
	Modules = {
		Shared = {},
		Client = {}
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
				_G.Frame.Modules.Client[item.Name] = require(item)
			end
		end
	end
end

function _G.Frame:GetRemoteEvent(eventName)
	return ReplicatedStorage.Events:WaitForChild(eventName, math.huge)
end

function _G.Frame:HandleEvent(eventName, handler)
	_G.Frame:GetRemoteEvent(eventName).OnClientEvent:Connect(function(...)
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
	
	-- [[ Client Modules ]] --
	
	ScanPathAndRequire(ReplicatedStorage.Modules.Client, false)
	
	-- Initialize the client modules
	for _, module in pairs(_G.Frame.Modules.Client) do
		if type(module.Init) == "function" then
			module:Init()
		end
	end
	
	-- Start the client modules
	for _, module in pairs(_G.Frame.Modules.Client) do
		if type(module.Start) == "function" then
			module:Start()
		end
	end
end

Init()
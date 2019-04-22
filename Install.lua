local HttpService = game:GetService("HttpService")

local Files = {
	ReplicatedStorage = {
		{ Type = "Folder", Name = "Events", Contents = {} },
		{ Type = "Folder", Name = "Modules", Contents = {
				{ Type = "Folder", Name = "Client", Contents = {
						{ Type = "Folder", Name = "Disabled", Contents = {} }
					}
				},
				{ Type = "Folder", Name = "Shared", Contents = {
						{ Type = "Folder", Name = "Disabled", Contents = {} }
					}
				},
				{ Type = "ModuleScript", Name = "FrameHelpers", Path = "/src/ReplicatedStorage/FrameHelpers.lua" }
			}
		}
	},
	ServerScriptService = {
		{ Type = "Folder", Name = "Modules", Contents = {
				{ Type = "Folder", Name = "Disabled", Contents = {} }
			},
			{ Type = "Script", Name = "FrameServer", Path = "/src/ServerScriptService/FrameServer.lua" }
		}
	},
	StarterPlayerScripts = {
		{ Type = "LocalScript", Name = "Frame", Path = "/src/StarterPlayer/StarterPlayerScripts/Frame.lua" }
	}
}

-- Get latest commit hash
local RepositoryInfo = HttpService:GetAsync("https://api.github.com/repos/BrightSkyz/Frame/git/refs/heads/master")
local DecodedRepositoryInfo = HttpService:JSONDecode(RepositoryInfo)
local CommitHash = DecodedRepositoryInfo.object.sha

function Explode(path, contents)
	for i = 1, #contents do
		local Content = contents[i]
		if Content.Type == "Folder" then
			if path:FindFirstChild(Content.Name) == nil then
				local Folder = Instance.new("Folder")
				Folder.Name = Content.Name
				Folder.Parent = path
			end
			Explode(path:FindFirstChild(Content.Name), Content.Contents)
		elseif Content.Type == "Script" then
			if path:FindFirstChild(Content.Name) == nil then
				local Script = Instance.new("Script")
				Script.Name = Content.Name
				Script.Parent = path
			end
			local ScriptContents = HttpService:GetAsync("https://raw.githubusercontent.com/BrightSkyz/Frame/" .. CommitHash .. Content.Path)
			path:FindFirstChild(Content.Name).Script = ScriptContents
		elseif Content.Type == "LocalScript" then
			if path:FindFirstChild(Content.Name) == nil then
				local Script = Instance.new("LocalScript")
				Script.Name = Content.Name
				Script.Parent = path
			end
			local ScriptContents = HttpService:GetAsync("https://raw.githubusercontent.com/BrightSkyz/Frame/" .. CommitHash .. Content.Path)
			path:FindFirstChild(Content.Name).Script = ScriptContents
		elseif Content.Type == "ModuleScript" then
			if path:FindFirstChild(Content.Name) == nil then
				local Script = Instance.new("ModuleScript")
				Script.Name = Content.Name
				Script.Parent = path
			end
			local ScriptContents = HttpService:GetAsync("https://raw.githubusercontent.com/BrightSkyz/Frame/" .. CommitHash .. Content.Path)
			path:FindFirstChild(Content.Name).Script = ScriptContents
		end
	end
end

Explode(game:GetService("ReplicatedStorage"), Files.ReplicatedStorage)
Explode(game:GetService("ServerScriptService"), Files.ServerScriptService)
Explode(game:GetService("StarterPlayer").StarterPlayerScripts, Files.StarterPlayerScripts)
-- // Start
local StartTime = tick()

-- // Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

-- // Utils
local Utils = ReplicatedStorage.Utils
local Loader = require(Utils.Loader)

-- // Folders
local Services = ServerScriptService.Services
local Components = ServerScriptService.Components

print("------[SERVICES]------")
Loader.Init(Services:GetChildren())
Loader.Start()

print("-----[COMPONENTS]-----")
for _, Module in Components:GetChildren() do
    if not Module:IsA("ModuleScript") then continue end
    require(Module)
    print(`{Module.Name} Initialized`)
end

local EndTime = tick()
EndTime = math.round(EndTime * 100) / 100
print(`Server loaded in {EndTime - StartTime}ms`)
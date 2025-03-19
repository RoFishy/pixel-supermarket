-- // Start
local StartTime = tick()

-- // Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- // Utils
local Utils = ReplicatedStorage:WaitForChild("Modules").Utils
local Loader = require(Utils.Loader)

-- // Folders
local Controllers = script.Parent:WaitForChild("Controllers")

print("-----[CONTROLLERS]----")
Loader.Init(Controllers:GetChildren())
Loader.Start()

local EndTime = tick()
print(`Client loaded in {EndTime - StartTime}ms`)
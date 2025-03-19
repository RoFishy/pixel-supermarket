-- // Services
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

-- // Player
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- // CONSTANTS
local CAMERA_FOV = 50
local CAMERA_OFFSET = Vector3.new(20, 35, -20)
local LERP_ALPHA = 0.05
local TRANASPARENCY_VALUE = 0.8

-- // Raycast
local RaycastParams = RaycastParams.new()
RaycastParams.FilterType = Enum.RaycastFilterType.Exclude
RaycastParams.FilterDescendantsInstances = {LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()}

-- // Camera Handler
local CameraHandler = {}

function CameraHandler.Init()
    Camera.FieldOfView = CAMERA_FOV
    Camera.CameraType = Enum.CameraType.Scriptable
end

function CameraHandler:Start()
    self.LastHiddenInstance = nil

    RunService.Heartbeat:Connect(function()
        self:UpdateCameraPosition()
        self:HandleObjectsInView()
    end)
end

function CameraHandler:SetObjectTransparency(Object : Model | BasePart)
    local HiddenInstance = Object.Parent :IsA("Model") and Object.Parent or Object

    if self.LastHiddenInstance then
        if HiddenInstance == self.LastHiddenInstance then
            return
        end
        self:ResetTransparency(self.LastHiddenInstance)
    end

    if HiddenInstance:IsA("Model") then
        for _, child in HiddenInstance:GetChildren() do
            if child:IsA("BasePart") then
                child.Transparency = TRANASPARENCY_VALUE
            end
        end
    elseif HiddenInstance:IsA("BasePart") then
        HiddenInstance.Transparency = TRANASPARENCY_VALUE
    else
        error("Last camera instance of invalid type: " .. HiddenInstance.ClassName)
    end

    self.LastHiddenInstance = HiddenInstance
end

function CameraHandler:ResetTransparency(Object : Model | BasePart)
    if Object:IsA("Model") then
        for _, child in Object:GetChildren() do
            if child:IsA("Model") then
                self:ResetTransparency(child)
            elseif child:IsA("BasePart") then
                child.Transparency = 0
            end
        end
    elseif Object:IsA("BasePart") then
        Object.Transparency = 0
    else
        error("Last camera instance of invalid type: " .. Object.ClassName)
    end
end

function CameraHandler:HandleObjectsInView()
    if LocalPlayer.Character then
        local RayOrigin = Camera.CFrame.Position
        local RayDirection = LocalPlayer.Character.HumanoidRootPart.Position - RayOrigin

        local Ray = workspace:Raycast(RayOrigin, RayDirection, RaycastParams)

        if Ray then
            self:SetObjectTransparency(Ray.Instance)
        else
            if self.LastHiddenInstance then
                self:ResetTransparency(self.LastHiddenInstance)
            end
        end
    end
end

function CameraHandler:UpdateCameraPosition()
    local Character = LocalPlayer.Character
    if not Character then
        return
    end

    local HumanoidRootPart = Character.HumanoidRootPart
    Camera.CFrame = Camera.CFrame:Lerp(
        CFrame.lookAt(HumanoidRootPart.Position + CAMERA_OFFSET, HumanoidRootPart.Position),
        LERP_ALPHA
    )
end

return CameraHandler
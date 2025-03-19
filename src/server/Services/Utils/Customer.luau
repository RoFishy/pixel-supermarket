-- // Services
local Players = game:GetService("Players")
local PathfindingService = game:GetService("PathfindingService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- // Utils
local Utils = ReplicatedStorage.Utils
local PlayerUtils = require(Utils.PlayerUtils)
local Types = require(Utils.Types)

-- // Packages
local Packages = ReplicatedStorage:WaitForChild("Packages")
local Janitor = require(Packages.Janitor)

-- // Shared
local Assets = ReplicatedStorage.Assets
local Customers = Assets.Customers

-- // Params
type AgentParams = {
    AgentRadius : number?,
    AgentHeight : number?,
    AgentCanJump : boolean?,
    AgentCanClimb : boolean?,
    WaypointSpacing : number?,
    Costs : {}?
}

export type CustomerParams = {
    WaitingTime : number, -- time before the leave the register to go do whatever the fuck else;
    TimeInLine : number, -- time they wait in line before leaving gg

    TimeShopping : number, -- time they spend shopping for items; will determine their speed and stuff
    ItemsToCollect : number, -- number of items to collect before they can stop shopping and checkout

    TippingType : "Gems" | "Cash", -- they can either leave gems tips or cash tips ig
    MinTipAmount : number, -- minimum tip amount they can leave
    MaxTipAmount : number, -- maximum amount they can tip
    TipChance : number -- the chance of them tipping or being greedy and leaving; increase with VIP customers etc
}

local DefaultParams : CustomerParams = {
    WaitingTime = 15,
    TimeInLine = 25,

    TimeShopping = 35,
    ItemsToCollect = 5,

    TippingType = "Gems",
    MinTipAmount = 5,
    MaxTipAmount = 15,
    TipChance = 0.1 -- 10%
}

local PathParams : AgentParams = {
    AgentRadius = 2,
    AgentHeight = 10,
    AgentCanJump = false,
    AgentCanClimb = false,
}

-- // Private Functions
local function GenerateCustomer(Player : Player)
    local Friends = PlayerUtils:GetFriends(Player)
    local RandomFriend = Friends[math.random(1, #Friends)]
    if not RandomFriend then
        warn(`No friend found for user: {Player.Name}`)
        return
    end

    local NewRig : Model = Customers.Rig:Clone()
    NewRig.Parent = workspace.LoadedRigs

    local FriendID = RandomFriend.Id

    local HumanoidDescription = Players:GetHumanoidDescriptionFromUserId(FriendID)
    if not HumanoidDescription then
        warn("No description found")
        return
    end

    local RigHumanoid : Humanoid = NewRig.Humanoid
    RigHumanoid:ApplyDescription(HumanoidDescription)
    NewRig.Archivable = true

    NewRig:PivotTo(workspace.SpawnPoint.CFrame)

    return NewRig
end

-- // Customer
local Customer = {}
Customer.__index = Customer

export type Customer = typeof(setmetatable({} :: any, Customer)) & {
    Store : Model,
    Owner : Player,
    Params : CustomerParams,
    Rig : Model,
    Basket : {Types.Food},
    _janitor : Janitor.Janitor,

    MoveTo : (Position : Vector3) -> (),
    GetBasket : () -> ({}),
    EnterStore : (SpawnPoint : Vector3?) -> (),
    LeaveStore : () -> ()
}


function Customer.new(Store : Model?, Owner : Player, Params : CustomerParams?)
   local self : Customer = setmetatable({}, Customer)

   self.Store = Store or nil
   self.Owner = Owner
   self.Params = Params or DefaultParams
   self.Rig = GenerateCustomer(Owner)
   self.Basket = {}
   self._janitor = Janitor.new() -- for connections

   return self
end

--[[
    Gets what is in the customer's shopping basket
]]--
function Customer.GetBasket(self : Customer)
    return self.Basket
end

--[[
    Moves the customer to a position
]]--
function Customer.MoveTo(self : Customer, Position : Vector3)
    local Humanoid = self.Rig.Humanoid

    local Path = PathfindingService:CreatePath(PathParams)
    Path:ComputeAsync(self.Rig.HumanoidRootPart.Position, Position)

    local Waypoints = Path:GetWaypoints()

    for _, Waypoint in Waypoints do
        Humanoid:MoveTo(Waypoint.Position)
        Humanoid.MoveToFinished:Wait()
    end
end

--[[
    Customer enters the store from the spawn point;
    If there is no spawn point provided, use the default one from the store model
]]--
function Customer.EnterStore(self : Customer, SpawnPoint : Vector3?)
    
end

--[[
    Customer leaves the store, optional provided exit point
]]--
function Customer.LeaveStore(self : Customer, ExitPoint : Vector3?)
    
end

function Customer.Cleanup(self : Customer)
    self._janitor:Cleanup()
end

return Customer
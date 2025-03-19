-- // Init
local Loader = {}
local CachedModules = {}

-- // Funcs
function Loader.Init(Scripts : {ModuleScript})
    for _, Module in Scripts do
        if not Module:IsA("ModuleScript") then continue end
        local LoadedModule = require(Module)
        CachedModules[Module.Name] = LoadedModule
        if LoadedModule.Init then
            task.spawn(LoadedModule.Init)
        end
        print(`{Module.Name} Initialized`)
    end
end

function Loader.Start()
    for Name, Module in CachedModules do
        task.spawn(function()
            Module:Start()
        end)
        print(`{Name} Started`)
    end
end

function Loader.Get(Name : string) : ModuleScript
    return CachedModules[Name]
end

shared.Get = Loader.Get

return Loader
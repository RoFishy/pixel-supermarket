-- // Services
local Players = game:GetService("Players")

-- // Player Utils
local PlayerUtils = {}

function PlayerUtils:GetFriends(Player : Player)
    local Friends = Players:GetFriendsAsync(Player.UserId)
    local _t = {}

    while task.wait() do
        local Page = Friends:GetCurrentPage()
        for _, v in Page do
            table.insert(_t, v)
        end

        break
    end

    return _t
end

return PlayerUtils
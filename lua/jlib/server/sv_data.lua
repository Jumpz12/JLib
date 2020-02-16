util.AddNetworkString("jlib_ClientPlayerData")
util.AddNetworkString("jlib_ServerPlayerData")

net.Receive("jlib_ServerPlayerData", function(len, ply)

    local args = net.ReadTable()

    for _, a in ipairs(args) do

        ply:SetPData(a[1], a[2])

    end

end)
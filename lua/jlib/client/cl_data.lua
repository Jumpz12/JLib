net.Receive("jlib_ClientPlayerData", function()

    local args = net.ReadTable()

    for _, a in ipairs(args) do

        LocalPlayer():SetPData(a[1], a[2])

    end

end)
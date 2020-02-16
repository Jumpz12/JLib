
--[[ Include a table with tables inside as data_title and do not provide a data_value and it'll take multiple pieces of data in the same format.
Exmaple here: {{"title", "value"}, {"title", "value"}}]]--

JLib.SavePData = function(target, data_title, data_value)

    local args = data_title

    if data_value ~= nil then

        args = {{data_title, data_value}}

    end

    for _, a in ipairs(args) do

        target:SetPData(a[1], a[2])

    end

    if (SERVER) then

        net.Start("jlib_ClientPlayerData")
        net.WriteTable(args)
        net.Send(target)

    end

    if (CLIENT) then

        net.Start("jlib_ServerPlayerData")
        net.WriteTable(args)
        net.SendToServer()

    end

end
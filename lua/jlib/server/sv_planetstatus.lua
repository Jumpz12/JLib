util.AddNetworkString("openStatusMenu")

local function openStatusMenu(ply)

    net.Start("openStatusMenu")
    net.Send(ply)
    return true

end
hook.Add("ShowHelp", "StatusMenu", openStatusMenu)
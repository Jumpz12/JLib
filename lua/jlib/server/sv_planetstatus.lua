util.AddNetworkString("openStatusMenu")

local function openStatusMenu(ply, text)
    if not IsValid(ply) then return end
    if text == "!planets" then 
        net.Start("openStatusMenu")
        net.Send(ply)
    end
end
hook.Add("PlayerSay", "StatusMenu", openStatusMenu)
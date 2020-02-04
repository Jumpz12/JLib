util.AddNetworkString("openMercenaryMenu")

local function mercenaryCommand(ply)

    if ply:getJobTable().category == "Hutt Cartel" then

        ply:ChatPrint("You are to be hired, not hire!")
        return true

    end

    local found = false

    for k, v in pairs(JLib.Config.PlanetControl.Factions[ply:getJobTable().side][ply:getJobTable().category]["Allies"]) do

        if ply:Team() == v then

            found = true

        end

    end

    if not found then

        ply:ChatPrint("You need to be a leader to hire mercenaries!")
        return true

    end

    net.Start("openMercenaryMenu")
    net.WriteString(ply:getJobTable().category)
    net.WriteInt(JLib.Config.PlanetControl.Factions[ply:getJobTable().side][ply:getJobTable().category].money, 32)
    net.Send(ply)
    return true

end
hook.Add("ShowTeam", "mercenaryCommand", mercenaryCommand)

net.Receive(messageName, callback)
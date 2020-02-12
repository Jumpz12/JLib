util.AddNetworkString("openMercenaryMenu")

local function mercenaryCommand(ply)

    if ply:getJobTable().category == "Hutt Cartel" then

        ply:ChatPrint("You are to be hired, not hire!")
        return true

    end
    
    if ply:getJobTable().side == "Neutral" then

        ply:ChatPrint("You cannot hire mercenaries")
        return true

    end

    if not table.HasValue(JLib.Config.PlanetControl.Factions[ply:getJobTable().side][ply:getJobTable().category]["Leaders"], ply:Team()) then

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
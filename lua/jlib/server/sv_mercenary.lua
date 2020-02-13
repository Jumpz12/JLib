util.AddNetworkString("openMercenaryMenu")
util.AddNetworkString("receiveMercenaryChoices")
util.AddNetworkString("sendMercenaryAcceptance")
util.AddNetworkString("receiveMercenaryAcceptance")

local cache = {}

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

net.Receive("receiveMercenaryChoices", function(len, ply)

    local choices = net.ReadTable()
    local type = net.ReadString()
    local faction = ply:getJobTable().category

    cache[ply:getJobTable().category] = {ply:getJobTable().side, #choices, net.ReadTable()}

    for _, player in choices do

        net.Start("sendMercenaryAcceptance")
        net.WriteString(faction)
        net.WriteString(type) --Type of hiring
        net.WriteTable(cache)
        net.Send(player)
    
    end

end)

net.Receive("receiveMercenaryAcceptance", function(len, ply)

    local accept = net.ReadBool()
    local faction = net.ReadString()

    if accept then

        ply:SetPData("Hired", faction)

        for _, player in pairs(player.GetAll()) do

            if player:getJobTable().category == faction then

                player:ChatPrint(ply:Name() .. " has accepted your contract!")

            end

        end

    else

        table.remove(cache[faction][3])

        if cache[faction][2] - 1 == 0 then 

            cache[faction][2] = cache[faction][2] - 1

            JLib.Config.PlanetControl.Factions[cache[faction][1]][faction].money = JLib.Config.PlanetControl.Factions[cache[faction][1]][faction].money - cache[faction][3][#cache[faction][3]]

        end

    end

    for _, player in pairs(player.GetAll()) do

        if player:getJobTable().category == faction then

            player:ChatPrint(ply:Name() .. " has declined your contract!")

        end

    end

end)
util.AddNetworkString("openMercenaryMenu")
util.AddNetworkString("receiveMercenaryChoices")
util.AddNetworkString("sendMercenaryAcceptance")
util.AddNetworkString("receiveMercenaryAcceptance")

local moneyTable = {}
local count = {}

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
    local side = ply:getJobTable().side
    moneyTable[ply:getJobTable().category] = net.ReadTable()
    count[ply:getJobTable().category] = #choices
    
    
    

    for _, player in choices do

        net.Start("sendMercenaryAcceptance")
        net.WriteString(faction)
        net.WriteString(type) --Type of hiring
        net.WriteInt(info[2], 32)
        net.Send(player)
    
    end

end)

net.Receive("receiveMercenaryAcceptance", function(len, ply)

    local accept = net.ReadBool()
    local faction = net.ReadString()
    local side = net.ReadString()

    if accept then

        ply:SetPData("Hired", faction)

        for _, player in pairs(player.GetAll()) do

            if player:getJobTable().category == faction then

                player:ChatPrint(ply:Name() .. " has accepted your request!")

            end

        end

        if count[faction] - 1 == 0 then 

            count[faction] = count[faction] - 1

            for k, v in pairs(money[faction]) do

                JLib.Config.PlanetControl.Factions[side][faction].money = JLib.Config.PlanetControl.Factions[side][faction].money - money[#money]

            end

        end

    else

        for _, player in pairs(player.GetAll()) do

            if player:getJobTable().category == faction then

                player:ChatPrint(ply:Name() .. " has declined your request!")

            end

        end

        table.remove(moneyTable[faction])

        if count[faction] - 1 == 0 then 

            count[faction] = count[faction] - 1

            for k, v in pairs(money[faction]) do

                JLib.Config.PlanetControl.Factions[side][faction].money = JLib.Config.PlanetControl.Factions[side][faction].money - money[#money]

            end

        end

    end

end)
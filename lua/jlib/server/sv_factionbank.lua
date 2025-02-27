local function factionBankUpdate()
    if timer.Exists("factionBankUpdate") then return end

    timer.Create("factionBankUpdate", JLib.Config.PlanetControl.BankUpdateTime * 60, 1, factionBankUpdate)

    for k, v in pairs(JLib.Config.Gravity.Spheres) do

        for _, player in pairs(player.GetAll()) do

            local money = 0

            if player:getJobTable().category == v.control then

                money = money + 100

            end

            player:setDarkRPVar("money", money)
            player:ChatPrint("Faction banks have been updated.")

        end

        if v.control == "" then continue end

        for a, b in pairs(JLib.Config.PlanetControl.Factions) do

            if JLib.Config.PlanetControl.Factions["Lightside"][v.control] ~= nil then

                JLib.Config.PlanetControl.Factions["Lightside"][v.control].money = JLib.Config.PlanetControl.Factions["Lightside"][v.control].money + 50

            elseif JLib.Config.PlanetControl.Factions["Darkside"][v.control] ~= nil then 

                JLib.Config.PlanetControl.Factions["Darkside"][v.control].money = JLib.Config.PlanetControl.Factions["Darkside"][v.control].money + 50
            
            else
                
                print("[JLib - Faction Bank] Something is terribly wrong!")

            end

        end

    end

end
hook.Add("Initialize", "factionBankUpdate", factionBankUpdate)



local function factionBankCheck(ply, text)

    if not IsValid(ply) then return end

    if text == "!bank" then

        ply:ChatPrint("Your faction has " .. JLib.Config.PlanetControl.Factions[ply:getJobTable().side][ply:getJobTable().category].money .. ".")

    end

end
hook.Add("PlayerSay", "factionBankCheck", factionBankCheck)
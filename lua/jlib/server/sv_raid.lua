util.AddNetworkString("sendToRaidLeader")
util.AddNetworkString("receiveRaidResponse")

local function raidCommand(ply, text)

    local args = string.Split(text, " ")
    local planet = table.concat(args, " ", 2)

    if args[1] == "!raid" then

        for k, v in pairs(JLib.Config.Gravity.Spheres) do

            if v.name == planet then
    
                if v.raid == true then
    
                    ply:ChatPrint("There is already a raid in progress for this planet")
    
                    return
    
                end
    
            end
            
        end
    
        if ply:GetPData("raidLeader", false) then
    
            ply:ChatPrint("You are already the leader of a raid")

            return
    
        end
        
    
        for _, player in pairs(player.GetAll()) do

            if JLib.Config.PlanetControl.Factions[ply:getJobTable().side][ply:getJobTable().category]["Leaders"] == nil then
                
                ply:ChatPrint("You are not a member of a faction!")

                return
            
            end
    
            for _, leader in pairs(JLib.Config.PlanetControl.Factions[ply:getJobTable().side][ply:getJobTable().category]["Leaders"]) do
    
                if player:Team() == leader then

                    if ply == player then

                        ply:ChatPrint("You cannot request a raid as a leader!")

                        return

                    end

                    net.Start("sendToRaidLeader")
                    net.WriteEntity(ply)
                    net.WriteString(planet)
                    net.Send(player)
    
                end
    
            end
    
        end

    end

end
hook.Add("PlayerSay", "raidCommand", raidCommand)

net.Receive("receiveRaidResponse", function()

    local ply = net.ReadEntity()
    local planet = net.ReadString()
    local response = net.ReadBool()

    if response then

        for _, player in pairs(player.GetAll()) do

            player:ChatPrint(ply:Name() .. " of faction " .. ply:getJobTable().category .. " has started a raid for " .. planet .. "!")

        end

        for k, v in pairs(JLib.Config.Gravity.Spheres) do

            if v.name == planet then

                v.raid = true

            end

        end

        --ply:SetPData("raidLeader", planet)
        JLib.SavePData(ply, "raidLeader", planet)

        timer.Create(planet.."raidTimer", JLib.Config.PlanetControl.SmallRaidTime, 1, function()
    
            for _, player in pairs(player.GetAll()) do

                player:ChatPrint("The raid for " .. planet .. " has ended!")
                
            end

            for k, v in pairs(JLib.Config.Gravity.Spheres) do

                if v.name == planet then

                    v.raid = false

                end

            end

            --ply:SetPData("raidLeader", false)
            JLib.SavePData(ply, "raidLeader", false)
        
        end)
    
    else

        ply:ChatPrint("Your raid request has been denied.")
        
    end

end)

local function raidEndCommand(ply, text)

    if text == "!raidend" then

        if ply:GetPData("raidLeader", false) then

            if timer.Exists(ply:GetPData("raidLeader", false) .. "raidTimer") then

                timer.Remove(ply:GetPData("raidLeader", false) .. "raidTimer")

                for _, player in pairs(player.GetAll()) do

                    player:ChatPrint("The raid for " .. ply:GetPData("raidLeader", false) .. " has ended!")
                    
                end
    
                for k, v in pairs(JLib.Config.Gravity.Spheres) do

                    if v.name == ply:GetPData("raidLeader", false) then

                        v.raid = false

                    end

                end
    
                --ply:SetPData("raidLeader", false)
                JLib.SavePData(ply, "raidLeader", false)
            
            end
        
        end

    end

end

hook.Add("PlayerSay", "raidEndCommand", raidEndCommand)
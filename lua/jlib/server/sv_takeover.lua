util.AddNetworkString("drawCommandPosts")
util.AddNetworkString("removeCommandPosts")


local function Takeover_Command(ply, text)

    if not IsValid(ply) then return end

    local args = string.Split(text, " ")
    local rest = table.concat(args, " ", 2)
    local sides = ""

    if args[1] == "!takeover" then

        for k, v in pairs(DarkRP.getCategories().jobs) do

            if v.name == ply:getJobTable().category then

                sides = v.side

            end

        end

        if sides == "Neutral" then return end

        if not table.HasValue(JLib.Config.PlanetControl.Factions[sides][ply:getJobTable().category]["Leaders"], ply:Team()) then 

            ply:ChatPrint("You are not a leader of your faction!")
            return

        end

        if timer.Exists(string.Replace(ply:getJobTable().category, " ", "") .. "_" .. "JLib_Takeover_Cooldown") then

            ply:ChatPrint("Sorry, but your faction is on a cooldown for " .. (timer.TimeLeft(string.Replace(ply:getJobTable().category, " ", "") .. "_" .. "JLib_Takeover_Cooldown") / 60) .. " minutes.")
            return

        else

            for k, v in pairs(JLib.Config.Gravity.Spheres) do

                if v.name == rest then

                    if v.control == "" then

                        if player.GetCount() < JLib.Config.PlanetControl.Neutral_Limit then

                            ply:ChatPrint("Sorry, there is not enough players online for you to take a neutral planet.")

                        else

                            v.control = ply:getJobTable().category

                            for a, b in pairs(player.GetAll()) do

                                b:ChatPrint(ply:getJobTable().category .. " now owns " .. v.name)

                            end

                            ply:ChatPrint("You now own " .. v.name)
                            timer.Create(string.Replace(ply:getJobTable().category, " ", "") .. "_" .. "JLib_Takeover_Cooldown", JLib.Config.PlanetControl.Cooldown * 60, 1, function()
                                for a, b in pairs(player.GetAll()) do
                                    b:ChatPrint(ply:getJobTable().category .. "'s takeover cooldown has ended.")
                                end
                            end)

                        end

                    elseif(v.control == ply:getJobTable().category) then
                        
                        ply:ChatPrint("Your faction already owns this planet!")

                    else

                        if v.control == JLib.Config.PlanetControl.Factions[sides][ply:getJobTable().category]["Allies"][1] then

                            ply:ChatPrint("Sorry you can't takeover a planet controlled by a faction you are allied with.")
                            return

                        elseif timer.Exists(string.Replace(v.control, " ", "") .. "_" .. "JLib_Takeover_Cooldown") then

                            ply:ChatPrint("Sorry, this faction is on a cooldown for " .. (timer.TimeLeft(string.Replace(v.control, " ", "") .. "_" .. "JLib_Takeover_Cooldown") / 60) .. " minutes.")
                            return

                        else

                            for _, player in pairs(player.GetAll()) do

                                if player:getJobTable().category == v.control then

                                    player:ChatPrint("The faction " .. ply:getJobTable().category .. " has started a takeover for " .. v.name .. "!")

                                elseif player:getJobTable().category == ply:getJobTable().category then

                                    player:ChatPrint("Your faction has started a takeover for " .. v.name .. ", currently controlled by " .. v.control .. "!")

                                else

                                    player:ChatPrint("The faction " .. ply:getJobTable().category .. " has started a takeover for " .. v.name .. ", currently controlled by " .. v.control .. "!")

                                end

                            end

                            table.insert( JLib.Config.PlanetControl.Attacks_Active, v.name )
                            v.attacker = ply:getJobTable().category
                            timer.Create(string.Replace(v.name, " ", ""), JLib.Config.PlanetControl.RaidTime * 60, 1, function()
                                for k, v in pairs(player.GetAll()) do
                                    ply:ChatPrint("The takeover for " .. v.name .. " has ended!")
                                    local index = table.KeyFromValue( JLib.Config.PlanetControl.Attacks_Active, k.name)
                                    table.remove(JLib.Config.PlanetControl.Attacks_Active, index)
                                end
                                v.progress = 0
                                for a, b in pairs(v.control_points) do
                                    b.progress = 0
                                    b.captured = false
                                    net.Start("removeCommandPosts")
                                    net.WriteString(b.name)
                                    net.Broadcast()
                                end
                                timer.Create((string.Replace(v.attacker, " ", "") .. "_" .. "JLib_Takeover_Cooldown"), JLib.Config.PlanetControl.Cooldown * 60, 1, function()
                                    for _, player in pairs(player.GetAll()) do
                                        player:ChatPrint("The cooldown for " .. v.attacker .. " is now over!")
                                    end
                                end)
                                timer.Create((string.Replace(v.control, " ", "") .. "_" .. "JLib_Takeover_Cooldown"), JLib.Config.PlanetControl.Cooldown * 60, 1, function()
                                    for _, player in pairs(player.GetAll()) do
                                        player:ChatPrint("The cooldown for " .. v.control .. " is now over!")
                                    end
                                end)
                                v.attacker = ""
                            end)

                        end

                    end

                end

            end

        end

    end

end

hook.Add("PlayerSay", "JLib_Takeover_Command", Takeover_Command)



local function Planet_Attack()

    if table.IsEmpty(JLib.Config.PlanetControl.Attacks_Active) then 

        timer.Simple(5, Planet_Attack)
        return 

    end

    for _, planet in pairs(JLib.Config.PlanetControl.Attacks_Active) do

        for k, v in pairs(JLib.Config.Gravity.Spheres) do

            if planet == v.name then
                
                if v.progress == 100 then
                    local attacker = v.attacker

                    timer.Remove((string.Replace(v.attacker, " ", "") .. "_" .. "JLib_Takeover_Cooldown"))
                    timer.Create((string.Replace(v.attacker, " ", "") .. "_" .. "JLib_Takeover_Cooldown"), JLib.Config.PlanetControl.Cooldown * 60, 1, function()
                        for _, player in pairs(player.GetAll()) do
                            player:ChatPrint("The cooldown for " .. attacker .. " is now over!")
                        end
                    end)
                    
                    timer.Remove((string.Replace(v.control, " ", "") .. "_" .. "JLib_Takeover_Cooldown"))
                    timer.Create((string.Replace(v.control, " ", "") .. "_" .. "JLib_Takeover_Cooldown"), JLib.Config.PlanetControl.Cooldown * 60, 1, function()
                        for _, player in pairs(player.GetAll()) do
                            player:ChatPrint("The cooldown for " .. v.control .. " is now over!")
                        end
                    end)

                    v.progress = 0
                    timer.Remove(string.Replace(v.name, " ", ""))
                    local index = table.KeyFromValue( JLib.Config.PlanetControl.Attacks_Active, v.name)
                    table.remove(JLib.Config.PlanetControl.Attacks_Active, index)
                    v.control = v.attacker
                    v.attacker = ""

                    for a, b in pairs(v.control_points) do
                        b.progress = 0
                        b.captured = false
                        net.Start("removeCommandPosts")
                        net.WriteString(b.name)
                        net.Broadcast()
                    end

                    for _, player in pairs(player.GetAll()) do
                        player:ChatPrint(v.control .. " has successfully taken over " .. v.name .. "!")
                    end

                    

                else

                    for a, b in pairs(v.control_points) do

                        local participants = ents.FindInSphere(b.origin, b.radius)
                        local attackers = 0
                        local defenders = 0

                        if b.progress == 100 and b.captured == false then

                            if v.progress == 66 then

                                v.progress = v.progress + 34

                                for _, player in pairs(player.GetAll()) do
                                    player:ChatPrint(v.attacker .. " has captured a command post.")
                                end
                            
                            else

                                v.progress = v.progress + 33

                                for _, player in pairs(player.GetAll()) do
                                    player:ChatPrint(v.attacker .. " has captured a command post.")
                                end

                            end

                            b.captured = true

                        end

                        for c, d in pairs(participants) do

                            if d:IsPlayer() then 
                            
                                if d:getJobTable().category == v.control then

                                    defenders = defenders + 1

                                elseif d:getJobTable().category == v.attacker then

                                    attackers = attackers + 1   
                                
                                end
                        
                            end

                        end

                        if defenders == 0 and attackers ~= 0 then

                            if b.progress ~= 100 then

                                b.progress = b.progress + 20
                                net.Start("drawCommandPosts")
                                net.WriteVector(b.origin)
                                net.WriteInt(b.radius, 32)
                                net.WriteString("attacking")
                                net.WriteString(v.attacker)
                                net.WriteString(v.control)
                                net.WriteString(b.name)
                                net.Broadcast()

                            end

                        elseif attackers == 0 and defenders ~= 0 then

                            if b.progress ~= 0 and not b.captured then

                                b.progress = b.progress - 20
                                net.Start("drawCommandPosts")
                                net.WriteVector(b.origin)
                                net.WriteInt(b.radius, 32)
                                net.WriteString("defending")
                                net.WriteString(v.attacker)
                                net.WriteString(v.control)
                                net.WriteString(b.name)
                                net.Broadcast()

                            end

                        else

                            net.Start("drawCommandPosts")
                            net.WriteVector(b.origin)
                            net.WriteInt(b.radius, 32)
                            net.WriteString("neutral")
                            net.WriteString(v.attacker)
                            net.WriteString(b.control)
                            net.Broadcast()
                        
                        end

                    end
                
                end
            
            end

        end

    end

    timer.Simple(5, Planet_Attack)

end
hook.Add("PostGamemodeLoaded", "JLib_Planet_Start", Planet_Attack)
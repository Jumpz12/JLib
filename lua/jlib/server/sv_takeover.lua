--[[local function Takeover_Command (ply, text)
    if not IsValid(ply) then return end
    ply:ChatPrint("You are valid")
    local args = string.Split(text, " ")
    ply:ChatPrint("Split up text")
    if args[1] == "!takeover" then
        ply:ChatPrint("Takeover command found")
        if not JLib.Config.PlanetControl.Status == false then return end
        ply:ChatPrint("No over takeover in progress")
        for k, v in ipairs(JLib.Config.PlanetControl.Factions) do
            if table.HasValue(JLib.Config.PlanetControl.Factions[k], ply:Team()) then
                JLib.Config.PlanetControl.Status = k
            end
        end
        if JLib.Config.PlanetControl.Status == false then return end
        if not table.HasValue(JLib.Config.PlanetControl.HeroLeaders, ply:Team()) then
            if not table.HasValue(JLib.Config.PlanetControl.VillianLeaders, ply:Team()) then return end
        end
        ply:ChatPrint("You are a hero/villian")
        if table.HasValue(JLib.Config.PlanetControl.HeroLeaders, ply:Team()) then
            JLib.Config.PlanetControl.Status = "Heroes"
            ply:ChatPrint("Status Set To Hero")
        elseif table.HasValue(JLib.Config.PlanetControl.VillianLeaders, ply:Team()) then
            JLib.Config.PlanetControl.Status = "Villians"
            ply:ChatPrint("Status Set To Villian")
        end
        for i=1, #JLib.Config.Gravity.Spheres do
            if args[2] == JLib.Config.Gravity.Spheres[i].name then
                JLib.Config.PlanetControl.Planet_Attack = v
            else
                ply:ChatPrint("That isn't a planet")
            end
        end
    end
end
hook.Add("PlayerSay", "Takeover_Command", Takeover_Command)]]

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

        if timer.Exists(string.Replace(ply:getJobTable().category, " ", "") .. "_" .. "JLib_Takeover_Cooldown") then

            ply:ChatPrint("Sorry, but your faction is on a cooldown for " .. timer.TimeLeft(string.Replace(ply:getJobTable().category, " ", "") .. "_" .. "JLib_Takeover_Cooldown") .. " minutes.")
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

                            ply:ChatPrint("Sorry, this faction is on a cooldown for " .. timer.TimeLeft(string.Replace(v.control, " ", "") .. "_" .. "JLib_Takeover_Cooldown") .. " minutes.")
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

                            table.insert( JLib.Config.PlanetControl.Planet_Attack, v.name )
                            v.attacker = ply:getJobTable().category
                            timer.Create(string.Replace(v.name, " ", ""), JLib.Config.PlanetControl.RaidTime * 60, 1, function()
                                for k, v in pairs(player.GetAll()) do
                                    ply:ChatPrint("The raid for " .. v.name .. " has ended!")
                                    local index = table.KeyFromValue( JLib.Config.PlanetControl.Planet_Attack, k.name)
                                    table.remove(JLib.Config.PlanetControl.Planet_Attack, index)
                                end
                                v.progress = 0
                                for a, b in pairs(v.control_points) do
                                    a.progress = 0
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


timer.Create("JLib_PlanetAttack_Loop", JLib.Config.PlanetControl.Update_Time, 0, Planet_Attack())
local function Planet_Attack()

    if #JLib.Config.PlanetControl.Planet_Attack == 0 then return end

    for _, planet in pairs(JLib.Config.PlanetControl.Planet_Attack) do

        for k, v in pairs(JLib.Config.Gravity.Spheres) do

            if planet == k.name then
                
                if k.progress == 100 then

                    timer.Create((string.Replace(k.attacker, " ", "") .. "_" .. "JLib_Takeover_Cooldown"), JLib.Config.PlanetControl.Cooldown * 60, 1, function()
                        for _, player in pairs(player.GetAll()) do
                            player:ChatPrint("The cooldown for " .. k.attacker .. " is now over!")
                        end
                    end)
                    timer.Create((string.Replace(k.control, " ", "") .. "_" .. "JLib_Takeover_Cooldown"), JLib.Config.PlanetControl.Cooldown * 60, 1, function()
                        for _, player in pairs(player.GetAll()) do
                            player:ChatPrint("The cooldown for " .. k.control .. " is now over!")
                        end
                    end)

                    k.progress = 0
                    timer.Remove(string.Replace(k.name, " ", ""))
                    local index = table.KeyFromValue( JLib.Config.PlanetControl.Planet_Attack, k.name)
                    table.remove(JLib.Config.PlanetControl.Planet_Attack, index)
                    k.control = k.attacker
                    k.attacker = ""

                    for a, b in pairs(k.control_points) do
                        a.progress = 0
                        a.captured = false
                    end

                    for _, player in pairs(player.GetAll()) do
                        player:ChatPrint(k.control .. " has successfully taken over " .. k.name .. "!")
                    end

                    

                else

                    for a, b in pairs(k.control_points) do

                        local ents = ents.FindInSphere(a.origin, a.radius)
                        local attackers = 0
                        local defenders = 0

                        if a.progress == 100 and a.captured == false then

                            if k.progress == 66 then

                                k.progress = k.progress + 34
                            
                            else

                                k.progress = k.progress + 33

                            end

                            a.captured = true

                        end

                        for c, d in pairs(ents) do

                            if not d:IsPlayer() then break end

                            if d:getJobTable().category == k.control then

                                defenders = defenders + 1

                            elseif d:getJobTable().category == k.attacker then

                                attackers = attackers + 1   
                            
                            end
                        
                        end

                        if defenders == 0 then

                            a.progress = a.progress + 20

                        elseif attackers == 0 then

                            if a.progress ~= 0 then

                                a.progress = a.progress - 20

                            end
                        
                        end

                    end
                
                end
            
            end

        end

    end

end
--hook.Add("PostGamemodeLoaded", "JLib_Planet_Attack", Planet_Attack)
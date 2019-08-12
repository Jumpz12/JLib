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
    if args[1] == "!takeover" then
        for k, v in pairs(DarkRP.getCategories().jobs) do
            if v.name == ply:getJobTable().category then
                sides = v.side
            end
        end
        if timer.Exists(string.Replace(ply:getJobTable().category, " ", "") .. "_" .. "JLib_Takeover_Cooldown") then
            ply:ChatPrint("Sorry, but your faction is on a cooldown for " .. timer.TimeLeft(string.Replace(ply:getJobTable().category, " ", "") .. "_" .. "JLib_Takeover_Cooldown") .. " minutes.")
            return
        else
            for k, v in pairs(JLib.Config.Gravity.Spheres) do
                if k.name == rest then
                    if k.control == "" then
                        if player.GetCount() < JLib.Config.PlanetControl.Neutral_Limit then
                            ply:ChatPrint("Sorry, there is not enough players online for you to take a neutral planet.")
                        else
                            k.control = ply:getJobTable().category
                            ply:ChatPrint("You now own " .. k.name)
                            timer.Create(string.Replace(ply:getJobTable().category, " ", "") .. "_" .. "JLib_Takeover_Cooldown", JLib.Config.PlanetControl.Cooldown * 60, 1, function()
                                for k, v in pairs(player.GetAll()) do
                                    v:ChatPrint(ply:getJobTable().catergory .. "'s takeover cooldown has ended.")
                                end
                            end)
                        end
                    else
                        if k.control == JLib.Config.PlanetControl.Factions[sides][ply:GetJobTable().catergory]["Allies"][1] then
                            ply:ChatPrint("Sorry you can't takeover a planet controlled by a faction you are allied with.")
                            return
                        elseif timer.Exists(string.Replace(k.control, " ", "") .. "_" .. "JLib_Takeover_Cooldown") then
                            ply:ChatPrint("Sorry, this faction is on a cooldown for " .. timer.TimeLeft(string.Replace(k.control, " ", "") .. "_" .. "JLib_Takeover_Cooldown") .. " minutes.")
                            return
                        else
                            for _, player in pairs(player.GetAll()) do
                                if player:getJobTable().category == k.control then
                                    player:ChatPrint("The faction " .. ply:getJobTable().category .. " has started a takeover for " .. k.name .. "!")
                                elseif player:getJobTable().category == ply:getJobTable().category then
                                    player:ChatPrint("Your faction has started a takeover for " .. k.name .. ", currently controlled by " .. k.control .. "!")
                                else
                                    player:ChatPrint("The faction " .. ply:getJobTable().category .. " has started a takeover for " .. k.name .. ", currently controlled by " .. k.control .. "!")
                                end
                            end

                        end
                    end
                end
            end
        end
    end
end
hook.Add("PlayerSay", "JLib_Takeover_Command", Takeover_Command)


-- TODO: Actual Takeover part here

--[[local function Planet_Takeover()
    if JLib.Config.PlanetControl.Status == false then return end
    





    
hook.Add("Tick", "Planet_Takeover", Planet_Takeover)]]
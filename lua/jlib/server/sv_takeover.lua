local function Takeover_Command (ply, text)
    if not IsValid(ply) then return end
    local args = string.Split(text, " ")
    if args[1] == "!takeover" then
        if not JLib.Config.PlanetControl.Status == false then return end
        if not table.HasValue(JLib.Config.PlanetControl.HeroLeaders, ply:Team()) and not table.HasValue(JLib.Config.PlanetControl.VillianLeaders, ply:Team()) then return end
        if table.HasValue(JLib.Config.PlanetControl.HeroLeaders, ply:Team()) then
            Jlib.Config.PlanetControl.Status = "Heroes"
        elseif table.HasValue(JLib.Config.PlanetControl.VillianLeaders, ply:Team()) then
            JLib.Config.PlanetControl.Status = "Villians"
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
hook.Add("PlayerSay", "Takeover_Command", Takeover_Command)

-- TODO: Actual Takeover part here

--[[local function Planet_Takeover()
    if JLib.Config.PlanetControl.Status == false then return end
    





    
hook.Add("Tick", "Planet_Takeover", Planet_Takeover)]]
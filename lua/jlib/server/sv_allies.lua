local function Allies_Command(ply, text)
    local sides
    if not ply:IsValid() then return end
    local args = string.Split(text, " ")
    local rest = table.concat(args, " ", 2)
    if args[1] ~= "!ally" then return end
    for k, v in pairs(DarkRP.getCategories().jobs) do
        if v.name == ply:getJobTable().category then
            sides = v.side
        end
    end

    if not table.HasValue(JLib.Config.PlanetControl.Factions[sides][ply:getJobTable().category]["Leaders"], ply:Team()) then return end 

    if #JLib.Config.PlanetControl.Factions[sides][ply:getJobTable().category]["Allies"] ~= 0 then
        ply:ChatPrint("Sorry you have the max amount of allies")
        return
    end

    if rest == ply:getJobTable().category then
        ply:ChatPrint("Sorry, you can't ally with your own faction")
        return
    end

    if JLib.Config.PlanetControl.Factions[sides][rest] == nil then
        ply:ChatPrint("Sorry, you can't ally with this faction")
        return
    end

    table.insert(JLib.Config.PlanetControl.Factions[sides][ply:getJobTable().category]["Allies"], rest)
    table.insert(JLib.Config.PlanetControl.Factions[sides][rest]["Allies"], ply:getJobTable().category)
    ply:ChatPrint(rest .. " is now your ally")

end

hook.Add("PlayerSay", "Allies_Command", Allies_Command)
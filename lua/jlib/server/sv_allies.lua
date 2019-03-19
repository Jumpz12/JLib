util.AddNetworkString("_JLib_AlliesMenu")
util.AddNetworkString("_JLib_AlliesInformation")

local function Allies_Command(ply, text)
    local sides
    local found = false


    if not ply:IsValid() then return end
    local args = string.Split(text, " ")
    local rest = table.concat(args, " ", 2)
    if args[1] ~= "!ally" then return end
    for k, v in pairs(DarkRP.getCategories().jobs) do
        if v.name == ply:getJobTable().category then
            sides = v.side
        end
    end

    if JLib.Config.PlanetControl.Factions[sides][rest] == nil then
        ply:ChatPrint("Sorry, you can't ally with this faction")
        return
    end

    if timer.Exists(string.Replace(ply:getJobTable().category, " ", "") .. "_" .. string.Replace(rest, " ", "") .. "_JLib_AllyCoolDown") then 
        ply:ChatPrint("Sorry, you cannot request to ally with this faction for " .. timer.TimeLeft(string.Replace(ply:getJobTable().category, " ", "") .. "_" .. string.Replace(rest, " ", "") .. "_JLib_AllyCoolDown") .. " seconds")
        return
    end

    if not table.HasValue(JLib.Config.PlanetControl.Factions[sides][ply:getJobTable().category]["Leaders"], ply:Team()) then return end 

    if #JLib.Config.PlanetControl.Factions[sides][ply:getJobTable().category]["Allies"] ~= 0 then
        ply:ChatPrint("Sorry you have the max amount of allies")
        return
    end

    if #JLib.Config.PlanetControl.Factions[sides][rest]["Allies"] ~= 0 then
        ply:ChatPrint("Sorry, they have the max amount of allies")
        return
    end

    if rest == ply:getJobTable().category then
        ply:ChatPrint("Sorry, you can't ally with your own faction")
        return
    end

    for k, v in pairs(player.GetAll()) do
        if not found then
            if table.HasValue(JLib.Config.PlanetControl.Factions[sides][rest]["Leaders"], v:Team()) then
                found = true
                net.Start("_JLib_AlliesMenu")
                net.WriteEntity(ply)
                net.WriteTable(
                    {side = sides, myfac = rest, fac = ply:getJobTable().category}
                )
                net.Send(v)
            end
        end
    end
end
hook.Add("PlayerSay", "Allies_Command", Allies_Command)

net.Receive("_JLib_AlliesInformation", function()
    local ply, info, ans = net.ReadEntity(), net.ReadTable(), net.ReadBool()
    if ans then
        table.insert(JLib.Config.PlanetControl.Factions[info.side][info.fac]["Allies"], info.myfac)
        table.insert(JLib.Config.PlanetControl.Factions[info.side][info.myfac]["Allies"], info.fac)
        ply:ChatPrint(info.myfac .. " is now your ally")
    else
        ply:ChatPrint(info.myfac .. " declined your ally request")
        timer.Create(string.Replace(info.fac, " ", "") .. "_" .. string.Replace(info.myfac, " ", "") .. "_JLib_AllyCoolDown", 300, 1, function()
            ply:ChatPrint("You can now request an alliance with" .. info.myfac)
        end)
    end
end)

local function Remove_Allies_Command(ply, text)
    local ally
    local sides
    if not ply:IsValid() then return end
    if text == "!ally_remove" then
        for k, v in pairs(DarkRP.getCategories().jobs) do
            if v.name == ply:getJobTable().category then
                sides = v.side
            end
        end
        for k, v in pairs(JLib.Config.PlanetControl.Factions[sides][ply:getJobTable().category]["Allies"]) do
            ally = v
        end
        JLib.Config.PlanetControl.Factions[sides][ply:getJobTable().category]["Allies"][1] = nil
        JLib.Config.PlanetControl.Factions[sides][ally]["Leaders"] = nil
        ply:ChatPrint(ally .. " Is no longer your Ally")
        for k, v in pairs(player.GetAll()) do
            if table.HasValue(JLib.Config.PlanetControl.Factions[sides][ally]["Leaders"], v:Team()) then
                v:ChatPrint(ply:getJobTable().category .. " Is no longer your Ally")
            end
        end
    end
end
hook.Add("PlayerSay", "Remove_Allies_Command", Remove_Allies_Command)
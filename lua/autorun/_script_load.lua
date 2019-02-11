--[[

    Do NOT touch.
    This is needed to load all files.

]]

-- TABLE SET UP

JLib = JLib or {}
JLib.Script = JLib.Script or {}
JLib.Script.Name = "JLib"
JLib.Script.Author = "Jumpz"
JLib.Script.Build = "SBG - Version 1.4"
JLib.Script.Released = "16/01/2019"
JLib.Script.Website = "https://steamcommunity.com/id/jumpz12/"

-- INFORMATION

local luaroot = "jlib"
local loadlabel = "JLib"

local ScriptStartupHeader = {
    '\n\n',
    [[__________________________________________________ ]],
    '\n',
}

local ScriptStartupInfo = {
    [[Title      ....    ]] .. JLib.Script.Name .. [[ ]],
    [[Build      ....    ]] .. JLib.Script.Build .. [[ ]],
    [[Released   ....    ]] .. JLib.Script.Released .. [[ ]],
    [[Author     ....    ]] .. JLib.Script.Author .. [[ ]],
    [[Website    ....    ]] .. JLib.Script.Website .. [[ ]],
}

local ScriptStartupFooter = {
    [[__________________________________________________ ]],
}

for k, i in ipairs( ScriptStartupHeader ) do
    MsgC( Color( 255, 255, 0 ), i .. '\n' )
end

for k, i in ipairs( ScriptStartupInfo ) do
    MsgC( Color( 255, 255, 255 ), i .. '\n\n' )
end

for k, i in ipairs( ScriptStartupFooter ) do
    MsgC( Color( 255, 255, 0 ), i .. '\n\n' )
end

-- SERVER-SIDE

if SERVER then

    local fol = luaroot .. "/"
    local files, folders = file.Find(fol .. "*", "LUA")

    for k, v in pairs(files) do
        include(fol .. v)
    end

    for _, folder in SortedPairs(folders, true) do
        if folder == "." or folder == ".." then continue end

            for _, File in SortedPairs(file.Find(fol .. folder .. "/sh_*.lua", "LUA"), true) do
                MsgC(Color(255, 255, 0), "[" .. JLib.Script.Name .. "] SHARED file: " .. File .. "\n")
                AddCSLuaFile(fol .. folder .. "/" .. File)
                include(fol .. folder .. "/" .. File)
            end
        end

        for _, folder in SortedPairs(folders, true) do
            if folder == "." or folder == ".." then continue end

                for _, File in SortedPairs(file.Find(fol .. folder .. "/sv_*.lua", "LUA"), true) do
                    MsgC(Color(255, 255, 0), "[" .. JLib.Script.Name .. "] SERVER file: " .. File .. "\n")
                    include(fol .. folder .. "/" .. File)
                end
            end

            for _, folder in SortedPairs(folders, true) do
                if folder == "." or folder == ".." then continue end

                    for _, File in SortedPairs(file.Find(fol .. folder .. "/cl_*.lua", "LUA"), true) do
                        MsgC(Color(255, 255, 0), "[" .. JLib.Script.Name .. "] CLIENT file: " .. File .. "\n")
                        AddCSLuaFile(fol .. folder .. "/" .. File)
                    end
                end

                for _, folder in SortedPairs(folders, true) do
                    if folder == "." or folder == ".." then continue end

                        for _, File in SortedPairs(file.Find(fol .. folder .. "/vgui_*.lua", "LUA"), true) do
                            MsgC(Color(255, 255, 0), "[" .. JLib.Script.Name .. "] CLIENT file: " .. File .. "\n")
                            AddCSLuaFile(fol .. folder .. "/" .. File)
                        end
                    end

                    MsgC(Color( 0, 255, 0 ), "\n[ " .. loadlabel .. " Loaded ]\n\n")
                    MsgC(Color( 255, 255, 0), "__________________________________________________ \n\n")

                end

                -- CLIENT-SIDE

                if CLIENT then

                    local root = luaroot .. "/"
                    local _, folders = file.Find(root .. "*", "LUA")

                    for _, folder in SortedPairs(folders, true) do
                        if folder == "." or folder == ".." then continue end

                            for _, File in SortedPairs(file.Find(root .. folder .. "/sh_*.lua", "LUA"), true) do
                                MsgC(Color(255, 255, 0), "[" .. JLib.Script.Name .. "] SHARED file: " .. File .. "\n")
                                include(root .. folder .. "/" .. File)
                            end
                        end

                        for _, folder in SortedPairs(folders, true) do
                            for _, File in SortedPairs(file.Find(root .. folder .. "/cl_*.lua", "LUA"), true) do
                                MsgC(Color(255, 255, 0), "[" .. JLib.Script.Name .. "] CLIENT file: " .. File .. "\n")
                                include(root .. folder .. "/" .. File)
                            end
                        end

                        for _, folder in SortedPairs(folders, true) do
                            for _, File in SortedPairs(file.Find(root .. folder .. "/vgui_*.lua", "LUA"), true) do
                                MsgC(Color(255, 0, 0), "[" .. JLib.Script.Name .. "] VGUI file: " .. File .. "\n")
                                include(root .. folder .. "/" .. File)
                            end
                        end

                        MsgC(Color( 0, 255, 0 ), "\n[ " .. loadlabel .. " Loaded ]\n\n")
                        MsgC(Color( 255, 255, 0), "__________________________________________________ \n\n")

                    end

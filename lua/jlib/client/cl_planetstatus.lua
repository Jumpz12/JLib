surface.CreateFont("JFontTitle", {
    font = "Arial",
    size = 35,
    weight = 500
} )

surface.CreateFont("JFontBody", {
    font = "Arial",
    size = 25,
    weight = 100
 } )

 local planet = {

    Init = function(self) 

        self.Image = self:Add("DImage")
        self.Image:Dock(LEFT)
        self.Image:DockMargin(0, 0, 0, 0)
        self.Image:SetSize(500, 281)

        self.Info = self:Add("DPanel")
        self.Info:Dock(FILL)
        self.Info:DockMargin(0, 0, 0, 0)
        self.Info:SetHeight(281)
        self.Info.Paint = function(self, w, h)

            draw.RoundedBox(0, 0, 0, w, h, Color(61, 61, 61, 0))

        end

        self.Name = self.Info:Add("DLabel")
        self.Name:SetFont("JFontBody")
        self.Name:SetTextColor(Color(255, 255, 255))
        self.Name:Dock(TOP)
        self.Name:DockMargin(10, 10, 0, 0)
        self.Name:SetContentAlignment(6)

        self.Control = self.Info:Add("DLabel")
        self.Control:SetFont("JFontBody")
        self.Control:SetTextColor(Color(255, 255, 255))
        self.Control:Dock(BOTTOM)
        self.Control:DockMargin(10, 0, 0, 10)
        self.Control:SetContentAlignment(6)

        self:Dock(TOP)
        self:SetHeight(281)
        self:DockMargin(0, 0, 0, 0)

    end,
    Setup = function(self, name, control, jobTable) 

        self.jobTable = jobTable

        self.control = control

        if self.PlanetName == nil or self.PlanetName ~= name then 
            self.PlanetName = name
            self.Name:SetText(name)
        end
        
        if self.PlanetImage == nil or self.PlanetImage ~= true then
            self.PlanetImage = true
            self.Image:SetImage("vgui/" .. name)
        end

        self:Think(self)

    end,
    
    --PerformLayout = function(self)
    --end,
    Paint = function(self, w, h) 
        draw.RoundedBox(8, 0, 0, w, h, Color(61, 61, 61, 0))
    end,

    Think = function(self)

        if self.PlanetControl == nil or self.PlanetControl ~= self.control then
            self.PlanetControl = self.control
            self.Control:SetText(self.control)
            self.Paint = function(self, w, h )

                if self.control == self.jobTable then

                    draw.RoundedBox(8, 0, 0, w, h, Color(0, 0, 255, 100))

                elseif self.control == "Neutral" then

                    draw.RoundedBox(8, 0, 0, w, h, Color(61, 61, 61, 0))

                else

                    draw.RoundedBox(8, 0, 0, w, h, Color(255, 0, 0, 100))

                end

            end

        end

        

    end
}

planet = vgui.RegisterTable(planet, "DPanel")

local popup = {

    Init = function(self) 

        self.Header = self:Add("Panel")
        self.Header:Dock(TOP)
        self.Header:SetHeight(50)
        

        self.Title = self.Header:Add("DLabel")
        self.Title:SetFont("JFontTitle")
        self.Title:SetText("Planet Status")
        self.Title:SetTextColor(Color(255, 255, 255, 255))
        self.Title:Dock(TOP)
        self.Title:SetHeight(50)
        self.Title:SetContentAlignment(5)
        self.Title:DockMargin(0, 0, 0, 0)

        self.Scroll = self:Add("DScrollPanel")
        self.Scroll:Dock(FILL)
        self.Scroll:DockMargin(0, 0, 0, 0)
        
    end,

    Setup = function(self, table) 

        self.Planets = table[1]
        self.jobTable = table[2]
        self:Think(self)
        
    end,

    PerformLayout = function(self)

        self:SetSize(700, ScrH() - 100)
        self:SetPos((ScrW()/2) - (700/2), (ScrH()/2) - ((ScrH() - 100) /2))

    end,

    Paint = function(self, w, h) 

        draw.RoundedBox(8, 0, 0, w, h, Color(61, 61, 61, 180))

    end,

    Think = function(self, w, h)

        for k, v in pairs(JLib.Config.Gravity.Spheres) do 

            if self.Planets[v.name] == nil then

                self.Planets[v.name] = vgui.CreateFromTable(planet, self.Planets[v.name])
                self.Planets[v.name]:Setup(v.name, v.control, self.jobTable)
                self.Scroll:AddItem(self.Planets[v.name])
            
            end
        
        end
        
    end
}






popup = vgui.RegisterTable(popup, "EditablePanel")

net.Receive("openStatusMenu", function()

    if not IsValid(JLib.VGui.PlanetStatus) then 

        JLib.VGui.PlanetStatus = vgui.CreateFromTable(popup)
        JLib.VGui.PlanetStatus:Setup({
            {},
            LocalPlayer():getJobTable().category,
        })
        JLib.VGui.PlanetStatus:MakePopup()
        JLib.VGui.PlanetStatus:SetKeyBoardInputEnabled(false)

    else

        JLib.VGui.PlanetStatus:Remove()

    end


end)
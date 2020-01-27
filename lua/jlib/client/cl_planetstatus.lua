surface.CreateFont("JFontTitle_Status", {
    font = "CloseCaption_Normal",
    size = 25,
} )

surface.CreateFont("JFontBody_Status", {
    font = "CloseCaption_Normal",
    size = 20,
 } )

 local planet = {

    Init = function(self) 

        self.Image = self:Add("DImage")
        self.Image:Dock(LEFT)
        self.Image:DockMargin(0, 0, 0, 0)
        self.Image:SetSize((ScrW() / 100) * 16, (ScrH() / 100) * 16)

        self.ImgHeader = self.Image:Add("DPanel")
        self.ImgHeader:Dock(BOTTOM)
        self.ImgHeader:DockMargin(0, 0, 0, 0)
        self.ImgHeader:SetHeight((ScrH() / 100) * 4)
        self.ImgHeader.Paint = function(self, w, h)

            draw.RoundedBox(0, 0, 0, w, h, Color(28, 28, 28, 200))

        end

        self.Name = self.ImgHeader:Add("DLabel")
        self.Name:SetFont("JFontBody_Status")
        self.Name:SetTextColor(Color(255, 255, 255))
        self.Name:SetHeight((ScrH() / 100) * 4)
        self.Name:Dock(FILL)
        self.Name:DockMargin(0, 0, 0, 0)
        self.Name:SetContentAlignment(5)

        self.Info = self:Add("DPanel")
        self.Info:Dock(FILL)
        self.Info:DockMargin(0, 0, 0, 0)
        self.Info:SetHeight((ScrH() / 100) * 16)
        self.Info.Paint = function(self, w, h)

            draw.RoundedBox(0, 0, 0, w, h, Color(28, 28, 28, 0))

        end

        self.Control = self.Info:Add("DButton")
        self.Control:SetFont("JFontBody_Status")
        self.Control:SetTextColor(Color(255, 255, 255))
        self.Control:Dock(FILL)
        self.Control:SetHeight((ScrH() / 100) * 8)
        self.Control:DockMargin((ScrW() / 100) * 0.5, 0, 0, 0)
        self.Control:SetContentAlignment(5)

        self:Dock(TOP)
        self:SetHeight((ScrH() / 100) * 16)
        self:DockMargin(((ScrW() / 100) * 0.5), 0, ((ScrW() / 100) * 0.5), 0)

    end,
    Setup = function(self, name, control, category)

        self.category = category
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

        draw.RoundedBox(0, 0, 0, w, h, Color(28, 28, 28, 0))

    end,

    Think = function(self)

        if self.PlanetControl == nil or self.PlanetControl ~= self.control then
            self.PlanetControl = self.control
            self.Control:SetText(self.control)
            self.Control.Paint = function(self, w, h)

                if self.control == self.category then

                    draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 255, 200))

                elseif self.control == "Neutral" then

                    draw.RoundedBox(0, 0, 0, w, h, Color(28, 28, 28, 200))

                else

                    draw.RoundedBox(0, 0, 0, w, h, Color(255, 0, 0, 200))

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
        self.Header:SetHeight((ScrH() / 100) * 5)
        self.Header.Paint = function(self, w, h)

            draw.RoundedBox(0, 0, 0, w, h, Color(28, 28, 28, 200))

        end

        self.Title = self.Header:Add("DLabel")
        self.Title:SetFont("JFontTitle_Status")
        self.Title:SetText("PLANET STATUS")
        self.Title:SetTextColor(Color(255, 255, 255, 255))
        self.Title:Dock(TOP)
        self.Title:SetHeight((ScrH() / 100) * 5)
        self.Title:SetContentAlignment(5)
        self.Title:DockMargin(0, 0, 0, 0)

        self.Scroll = self:Add("DScrollPanel")
        self.Scroll:Dock(FILL)
        self.Scroll:DockMargin(0, ((ScrW() / 100) * 0.5), ((ScrW() / 100) * 0.5), ((ScrW() / 100) * 0.5))

        local bar = self.Scroll:GetVBar()

        function bar:Paint( w, h )
            draw.RoundedBox( 0, 0, 0, w, h, Color(28, 28, 28, 0))
        end

        function bar.btnUp:Paint( w, h )
            draw.RoundedBox( 0, 0, 0, w, h, Color(28, 28, 28, 0))
        end

        function bar.btnDown:Paint( w, h )
            draw.RoundedBox( 0, 0, 0, w, h, Color(28, 28, 28, 0))
        end

        function bar.btnGrip:Paint( w, h )
            draw.RoundedBox( 5, 0, 0, w, h, Color(28, 28, 28, 255))
        end
        
    end,

    Setup = function(self, planets, category)

        self.Planets = planets
        self.category = category

        self:Think(self)
        
    end,

    PerformLayout = function(self)

        local width = (ScrW() / 100) * 30
        local height = (ScrH() / 100) * 82

        self:SetSize(width, height)
        self:SetPos((ScrW()/2) - (width/2), (ScrH()/2) - (height/2))

    end,

    Paint = function(self, w, h)

        draw.RoundedBox(0, 0, 0, w, h, Color(28, 28, 28, 200))

    end,

    Think = function(self, w, h)

        for k, v in pairs(JLib.Config.Gravity.Spheres) do 

            if self.Planets[v.name] == nil then

                self.Planets[v.name] = vgui.CreateFromTable(planet, self.Planets[v.name])
                self.Planets[v.name]:Setup(v.name, v.control, self.category)
                self.Scroll:AddItem(self.Planets[v.name])
            
            end
        
        end
        
    end

}

popup = vgui.RegisterTable(popup, "EditablePanel")

net.Receive("openStatusMenu", function()

    if not IsValid(JLib.VGui.PlanetStatus) then 

        JLib.VGui.PlanetStatus = vgui.CreateFromTable(popup)
        JLib.VGui.PlanetStatus:Setup({}, net.ReadString())
        JLib.VGui.PlanetStatus:MakePopup()
        JLib.VGui.PlanetStatus:SetKeyBoardInputEnabled(false)

    else

        JLib.VGui.PlanetStatus:Remove()

    end


end)
surface.CreateFont("JFontTitle_Merc", {
    font = "CloseCaption_Normal",
    size = 20,
} )

surface.CreateFont("JFontBody_Merc", {
    font = "CloseCaption_Normal",
    size = 15,
} )

local bounty = {

    Init = function(self)

        self.Button = self:Add("DButton")
        self.Button:Dock(FILL)
        self.Button:DockMargin(0, 0, 0, 0)
        self.Button:SetTextColor(Color(255, 255, 255, 255))
        self.Button:SetFont("JFontTitle_Merc")

        self:Dock(TOP)
        self:SetHeight((ScrH() / 100) * 6)
        self:DockMargin((ScrW() / 100) * 0.3, (ScrH() / 100) * 0.4, (ScrW() / 100) * 0.3, 0)

    end,

    Setup = function(self, p, job)

        self.Entity = p
        self.Name = p:Name()
        self.Job = job

        self.Button:SetText(p:Name())
        self.Button.Lerp = 0
        self.Button.DoClick = function()

            self.Button.Selected = not self.Button.Selected
            if self.Button.Selected then

                surface.PlaySound("UI/buttonclick.wav")

                if #JLib.VGui.MercMenu.Total < 1 then

                    table.insert(JLib.VGui.MercMenu.Total, 250)

                else

                    table.insert(JLib.VGui.MercMenu.Total, JLib.VGui.MercMenu.Total[#JLib.VGui.MercMenu.Total] * JLib.Config.Mercenary.Multiplier)

                end

            else

                surface.PlaySound("UI/buttonclickrelease.wav")

                table.remove(JLib.VGui.MercMenu.Total)

            end

            if JLib.VGui.MercMenu.Total[#JLib.VGui.MercMenu.Total] then

                JLib.VGui.MercMenu.CheckoutSubmit:SetText("HIRE - " .. JLib.VGui.MercMenu.Total[#JLib.VGui.MercMenu.Total] .. "CR")

            else

                JLib.VGui.MercMenu.CheckoutSubmit:SetText("HIRE - " .. 0 .. "CR")

            end

        end

        self:Think(self)

    end,

    Paint = function(self, w, h)

        draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 0))

    end,

    Think = function(self)

        local found = false

        for _, p in pairs(player.GetAll()) do

            if self.Entity == p then

                if team.GetName(p:Team()) == self.Job.name then

                    found = true

                end

            end

        end

        if not found then

            self:Remove()

            JLib.VGui.MercMenu.Cartel[self.Job.name] = nil

            table.remove(JLib.VGui.MercMenu.Total)
            print(JLib.VGui.MercMenu.Total[#JLib.VGui.MercMenu.Total])

            return

        end

        if self.Button:IsHovered() and JLib.VGui.MercMenu.Model:GetModel() ~= self.Job.model then

            surface.PlaySound("UI/buttonrollover.wav")
            JLib.VGui.MercMenu.Model:SetModel(self.Job.model)
            JLib.VGui.MercMenu.JobName:SetText(self.Job.name)

        end

        self.Button.Paint = function(self, w, h)

            if self:IsHovered() then

                draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 115))

            else

                draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 166))

            end

            if self.Selected then

                self.Lerp = math.min(w, self.Lerp + 30)
                draw.RoundedBox(0, 0, 0, self.Lerp, h, Color(0, 200, 0, 115))

            else

                self.Lerp = math.max(0, self.Lerp - 30)
                draw.RoundedBox(0, 0, 0, self.Lerp, h, Color(0, 200, 0, 115))

            end

        end

    end

}

bounty = vgui.RegisterTable(bounty, "DPanel")

local popup = {

    Init = function(self)

        self.Header = self:Add("Panel")
        self.Header:Dock(TOP)
        self.Header:DockMargin(0, 0, 0, 0)
        self.Header:SetHeight((ScrH() / 100) * 4)
        self.Header.Paint = function(self, w, h)

            draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 230))

        end

        self.Title = self.Header:Add("DLabel")
        self.Title:SetFont("JFontTitle_Merc")
        self.Title:SetText("MERCENARY MENU")
        self.Title:SetTextColor(Color(255, 255, 255, 255))
        self.Title:Dock(TOP)
        self.Title:SetHeight((ScrH() / 100) * 4)
        self.Title:SetContentAlignment(5)
        self.Title:DockMargin(0, 0, 0, 0)

        self.Body = self:Add("Panel")
        self.Body:Dock(FILL)
        self.Body:DockMargin(0, 0, 0, 0)
        self.Body:SetHeight(((ScrH() / 100) * 54) - ((ScrH() / 100) * 4))
        self.Body.Paint = function(self, w, h)

            draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 0))

        end

        self.LeftContain = self.Body:Add("Panel")
        self.LeftContain:Dock(LEFT)
        self.LeftContain:DockMargin((ScrW() / 100) * 0.3, (ScrH() / 100) * 0.5, (ScrW() / 100) * 0.2, (ScrH() / 100) * 0.5)
        self.LeftContain:SetSize((ScrW() / 100) * 17.5, ((ScrH() / 100) * 54) - ((ScrH() / 100) * 4))
        self.LeftContain.Paint = function(self, w, h)

            surface.SetDrawColor(Color(0, 0, 0, 255))
            surface.DrawOutlinedRect(0, 0, w, h)

        end

        self.Model = self.LeftContain:Add("DModelPanel")
        self.Model:Dock(FILL)
        self.Model:DockMargin(0, 0, 0, 0)
        self.Model:SetModel(LocalPlayer():GetModel())

        self.MidContain = self.Body:Add("Panel")
        self.MidContain:Dock(FILL)
        self.MidContain:DockMargin((ScrW() / 100) * 0.3, (ScrH() / 100) * 0.5, (ScrW() / 100) * 0.2, (ScrH() / 100) * 0.5)
        self.MidContain:SetSize((ScrW() / 100) * 17.5, ((ScrH() / 100) * 54) - ((ScrH() / 100) * 4))
        self.MidContain.Paint = function(self, w, h)

            surface.SetDrawColor(Color(0, 0, 0, 255))
            surface.DrawOutlinedRect(0, 0, w, h)

        end

        self.Scroll = self.MidContain:Add("DScrollPanel")
        self.Scroll:Dock(FILL)
        self.Scroll:DockMargin(0, 0, 0, 0)

        local bar = self.Scroll:GetVBar()

        function bar:Paint( w, h )
            draw.RoundedBox( 0, 0, 0, w, h, Color(0, 0, 0, 0))
        end

        function bar.btnUp:Paint( w, h )
            draw.RoundedBox( 0, 0, 0, w, h, Color(0, 0, 0, 0))
        end

        function bar.btnDown:Paint( w, h )
            draw.RoundedBox( 0, 0, 0, w, h, Color(0, 0, 0, 0))
        end

        function bar.btnGrip:Paint( w, h )
            draw.RoundedBox( 0, 0, 0, w, h, Color(0, 0, 0, 0))
        end

        self.RightContain = self.Body:Add("Panel")
        self.RightContain:Dock(RIGHT)
        self.RightContain:DockMargin((ScrW() / 100) * 0.3, (ScrH() / 100) * 0.5, (ScrW() / 100) * 0.2, (ScrH() / 100) * 0.5)
        self.RightContain:SetSize((ScrW() / 100) * 17.5, ((ScrH() / 100) * 54) - ((ScrH() / 100) * 4))
        self.RightContain.Paint = function(self, w, h)

            surface.SetDrawColor(Color(0, 0, 0, 255))
            surface.DrawOutlinedRect(0, 0, w, h)

        end

        self.JobHeader = self.RightContain:Add("Panel")
        self.JobHeader:SetHeight((ScrH() / 100) * 6)
        self.JobHeader:Dock(TOP)
        self.JobHeader:DockMargin((ScrW() / 100) * 0.3, (ScrH() / 100) * 0.4, (ScrW() / 100) * 0.3, 0)
        self.JobHeader.Paint = function(self, w, h)

            draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 166))

        end

        self.JobName = self.JobHeader:Add("DLabel")
        self.JobName:SetFont("JFontTitle_Merc")
        self.JobName:SetTextColor(Color(255, 255, 255, 255))
        self.JobName:Dock(TOP)
        self.JobName:SetHeight((ScrH() / 100) * 6)
        self.JobName:SetContentAlignment(5)
        self.JobName:DockMargin(0, 0, 0, 0)

        self.Checkout = self.RightContain:Add("Panel")
        self.Checkout:Dock(BOTTOM)
        self.Checkout:SetHeight((ScrH() / 100) * 17.5)
        self.Checkout:DockMargin(0, 0, 0, 0)
        self.Checkout.Paint = function(self, w, h)

            draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 0))

        end

        self.CheckoutHeader = self.Checkout:Add("Panel")
        self.CheckoutHeader:SetHeight((ScrH() / 100) * 4)
        self.CheckoutHeader:Dock(TOP)
        self.CheckoutHeader:DockMargin((ScrW() / 100) * 0.3, (ScrH() / 100) * 0.4, (ScrW() / 100) * 0.3, 0)
        self.CheckoutHeader.Paint = function(self, w, h)

            draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 230))

        end

        self.CheckoutTitle = self.CheckoutHeader:Add("DLabel")
        self.CheckoutTitle:SetFont("JFontTitle_Merc")
        self.CheckoutTitle:SetText("CONTRACT TYPE")
        self.CheckoutTitle:SetTextColor(Color(255, 255, 255, 255))
        self.CheckoutTitle:Dock(TOP)
        self.CheckoutTitle:SetHeight((ScrH() / 100) * 4)
        self.CheckoutTitle:SetContentAlignment(5)
        self.CheckoutTitle:DockMargin(0, 0, 0, 0)

        self.CheckoutType = self.Checkout:Add("DComboBox")
        self.CheckoutType:SetHeight((ScrH() / 100) * 6)
        self.CheckoutType:Dock(TOP)
        self.CheckoutType:DockMargin((ScrW() / 100) * 0.3, (ScrH() / 100) * 0.4, (ScrW() / 100) * 0.3, 0)
        self.CheckoutType:AddChoice('Raid')
        self.CheckoutType:AddChoice('Takeover')
        self.CheckoutType:SetTextColor(Color(255, 255, 255))
        self.CheckoutType:SetFont("JFontTitle_Merc")
        self.CheckoutType:SetContentAlignment(5)
        self.CheckoutType.Paint = function(self, w, h)

            draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 166))

        end

        self.CheckoutSubmit = self.Checkout:Add("DButton")
        self.CheckoutSubmit:SetHeight((ScrH() / 100) * 6)
        self.CheckoutSubmit:Dock(TOP)
        self.CheckoutSubmit:SetTextColor(Color(255, 255, 255))
        self.CheckoutSubmit:SetFont("JFontTitle_Merc")
        self.CheckoutSubmit:DockMargin((ScrW() / 100) * 0.3, (ScrH() / 100) * 0.4, (ScrW() / 100) * 0.3, 0)
        self.CheckoutSubmit.Paint = function(self, w, h)

            draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 166))

        end

    end,
    --bot;bot;bot;lua_run local i = 1 for k, v in pairs(player.GetAll()) do if v:IsBot() then v:SetTeam(20 + i) i = i + 1 end if v:Name() == "Luke Call" then v:SetTeam(7) end end
    Setup = function(self)

        self.Cartel = {}
        self.Total = {}

        self.CheckoutSubmit:SetText("HIRE - 0CR")

        self:Think(self)
        self.Model:SetCamPos(Vector(30, 30, 50))
        self.Model:SetLookAng(Angle(10, 225, 0))
        function self.Model:LayoutEntity(ent)
            ent:SetAngles(Angle(0, 90, 0))
            ent:SetSequence(ent:LookupSequence("phalanx_b_idle"))
            self:RunAnimation()
            return
        end

    end,

    PerformLayout = function(self)

        local width = (ScrW() / 100) * 53
        local height = (ScrH() / 100) * 54

        self:SetSize(width, height)
        self:SetPos((ScrW()/2) - (width/2), (ScrH()/2) - (height/2))

    end,

    Paint = function(self, w, h)

        draw.RoundedBox(0, 0, 0, w, h, Color(28, 28, 28, 200))

    end,

    Think = function(self, w, h)

        for _, p in pairs(player.GetAll()) do

            if p:getJobTable().category == "Hutt Cartel" then

                if self.Cartel[p:getJobTable().name] == nil then

                    if self.Model:GetModel() == LocalPlayer():GetModel() then

                        self.Model:SetModel(p:getJobTable().model)
                        self.JobName:SetText(p:getJobTable().name)

                    end

                    self.Cartel[p:getJobTable().name] = vgui.CreateFromTable(bounty, self.Cartel[p:getJobTable().name])
                    self.Cartel[p:getJobTable().name]:Setup(p, {name = p:getJobTable().name, desc = p:getJobTable().description, model = p:getJobTable().model})
                    self.Scroll:AddItem(self.Cartel[p:getJobTable().name])

                end

            end

        end

    end

}

popup = vgui.RegisterTable(popup, "EditablePanel")

net.Receive("openMercenaryMenu", function()

    if not IsValid(JLib.VGui.MercMenu) and not IsValid(JLib.VGui.PlanetStatus) then

        JLib.VGui.MercMenu = vgui.CreateFromTable(popup)
        JLib.VGui.MercMenu:Setup()
        JLib.VGui.MercMenu:MakePopup()
        JLib.VGui.MercMenu:SetKeyBoardInputEnabled(false)

    else

        JLib.VGui.MercMenu:Remove()

    end


end)
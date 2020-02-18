local popup2 = {

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
        self.Title:SetText("CONTRACT REQUEST")
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

        self.LeftContain = self.Body:Add("DModelPanel")
        self.LeftContain:Dock(LEFT)
        self.LeftContain:SetModel(LocalPlayer():GetModel())
        self.LeftContain:DockMargin((ScrW() / 100) * 0.3, (ScrH() / 100) * 0.5, (ScrW() / 100) * 0.2, (ScrH() / 100) * 0.5)
        self.LeftContain:SetSize((ScrW() / 100) * 8, ((ScrH() / 100) * 20) - ((ScrH() / 100) * 4))
        self.LeftContain.Paint = function(self, w, h)

            surface.SetDrawColor(Color(0, 0, 0, 255))
            surface.DrawOutlinedRect(0, 0, w, h)

        end

        self.Model = self.LeftContain:Add("DModelPanel")
        self.Model:Dock(FILL)
        self.Model:DockMargin(0, 0, 0, 0)

        self.RestContain = self.Body:Add("Panel")
        self.RestContain:Dock(RIGHT)
        self.RestContain:DockMargin((ScrW() / 100) * 0.3, (ScrH() / 100) * 0.5, (ScrW() / 100) * 0.3, (ScrH() / 100) * 0.5)
        self.RestContain:SetSize((ScrW() / 100) * 16.1, ((ScrH() / 100) * 20) - ((ScrH() / 100) * 4))
        self.RestContain.Paint = function(self, w, h)

            surface.SetDrawColor(Color(0, 0, 0, 255))
            surface.DrawOutlinedRect(0, 0, w, h)

        end

        self.Message = self.RestContain:Add("DLabel")
        self.Message:SetFont("JFontBody_Merc")
        self.Message:SetText("RAID REQUEST")
        self.Message:SetTextColor(Color(255, 255, 255, 255))
        self.Message:Dock(TOP)
        self.Message:SetWrap(true)
        self.Message:SetContentAlignment(5)
        self.Message:SetHeight((ScrH() / 100) * 3.5)
        self.Message:DockMargin((ScrW() / 100) * 0.5, (ScrH() / 100) * 0.5, (ScrW() / 100) * 0.5, (ScrH() / 100) * 0.5)


        self.Options = self.RestContain:Add("Panel")
        self.Options:SetHeight((ScrH() / 100) * 10)
        self.Options:Dock(BOTTOM)
        self.Options.Paint = function(self, w, h)

            draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 0))

        end

        self.Accept = self.Options:Add("DButton")
        self.Accept:SetHeight((ScrH() / 100) * 4)
        self.Accept:Dock(TOP)
        self.Accept:SetFont("JFontBody_Merc")
        self.Accept:SetTextColor(Color(255, 255, 255))
        self.Accept:SetText("Grant")
        self.Accept:DockMargin((ScrW() / 100) * 0.5, (ScrH() / 100) * 0.5, (ScrW() / 100) * 0.5, (ScrH() / 100) * 0.5)
        self.Accept.Paint = function(self, w, h)

            if self:IsHovered() then

                draw.RoundedBox(0, 0, 0, w, h, Color(0, 150, 0, 115))

            else

                draw.RoundedBox(0, 0, 0, w, h, Color(0, 150, 0, 166))

            end

        end

        self.Decline = self.Options:Add("DButton")
        self.Decline:SetHeight((ScrH() / 100) * 4)
        self.Decline:Dock(TOP)
        self.Decline:SetFont("JFontBody_Merc")
        self.Decline:SetTextColor(Color(255, 255, 255))
        self.Decline:SetText("Deny")
        self.Decline:DockMargin((ScrW() / 100) * 0.5, (ScrH() / 100) * 0.5, (ScrW() / 100) * 0.5, (ScrH() / 100) * 0.5)
        self.Decline.Paint = function(self, w, h)

            if self:IsHovered() then

                draw.RoundedBox(0, 0, 0, w, h, Color(150, 0, 0, 115))

            else

                draw.RoundedBox(0, 0, 0, w, h, Color(150, 0, 0, 166))

            end

        end

    end,

    Setup = function(self, member, planet)

        self.Model:SetModel(member:GetModel())
        self.Message:SetText("A request from " .. member:Name() .. " has come in to raid " .. planet .. ", do you grant this?")

        self.Accept.DoClick = function()

            net.Start("receiveRaidResponse")
            net.WriteBool(true)
            net.WriteString(planet)
            net.WriteEntity(member)
            net.SendToServer()

            self:Remove()

        end

        self.Decline.DoClick = function()

            net.Start("receiveRaidResponse")
            net.WriteBool(false)
            net.WriteString(planet)
            net.WriteEntity(member)
            net.SendToServer()

            self:Remove()

        end

        self:Think(self)

        self.Model:SetCamPos(Vector(4, 15, 65))
        self.Model:SetLookAng(Angle(10, 260, 0))
        function self.Model:LayoutEntity(ent)
            ent:SetAngles(Angle(0, 90, 0))
            return
        end

    end,

    PerformLayout = function(self)

        local width = (ScrW() / 100) * 25
        local height = (ScrH() / 100) * 20

        self:SetSize(width, height)
        self:SetPos((ScrW()/2) - (width/2), 20)

    end,

    Paint = function(self, w, h)

        draw.RoundedBox(0, 0, 0, w, h, Color(28, 28, 28, 200))

    end,

    Think = function(self, w, h)



    end

}

popup = vgui.RegisterTable(popup, "EditablePanel")

net.Receive("sendToRaidLeader", function()

    if not IsValid(JLib.VGui.RaidRequest) then

        JLib.VGui.RaidRequest = vgui.CreateFromTable(popup2)
        local ply = net.ReadEntity()
        JLib.VGui.RaidRequest:Setup(net.ReadString(), ply)
        JLib.VGui.RaidRequest:SetKeyBoardInputEnabled(false)

    else

        JLib.VGui.RaidRequest:Remove()

    end

end)
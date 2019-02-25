surface.CreateFont("JFontTitle", { 
    font = "Helvetica",
    size = "25",
    weight = "500"
 } )

local popup = {

    Init = function(self) 
        self.Header = self:Add("Panel")
        self.Header:Dock(TOP)
        self.Header:SetHeight(50)

        self.Title = self.Header:Add("DLabel")
        self.Title:SetFont("JFontTitle")
        self.Title:SetTextColor(Color(255, 255, 255, 255))
        self.Title:Dock(TOP)
        self.Title:SetHeight(50)
        self.Title:SetContentAlignment(5)
        self.Title:DockMargin(0, 0, 0, 0)
        
        self.Options = self:Add("Panel")
        self.Options:Dock(FILL)
        self.Options:DockMargin(40, 20, 40, 20)
        self.Options:SetHeight(100)
        
        self.Yes = self.Options:Add("DButton")
        self.Yes:SetSize(100, 50)
        self.Yes:Dock(LEFT)
        self.Yes:DockMargin(0, 0, 0, 0)
        self.Yes:SetTextColor(Color(255, 255, 255))
        self.Yes:SetText("Yes")
        self.Yes.Paint = function(self, w, h)
            if not self:IsHovered() then 
                draw.RoundedBox(0, 0, 0, w, h, Color(19, 165, 0))
            else
                draw.RoundedBox(0, 0, 0, w, h, Color(11, 96, 0))
            end
        end

        self.No = self.Options:Add("DButton")
        self.No:SetSize(100, 50)
        self.No:Dock(RIGHT)
        self.No:DockMargin(0, 0, 0, 0)
        self.No:SetTextColor(Color(255, 255, 255))
        self.No:SetText("No")
        self.No.Paint = function(self, w, h)
            if not self:IsHovered() then 
                draw.RoundedBox(0, 0, 0, w, h, Color(198, 3, 3))
            else
                draw.RoundedBox(0, 0, 0, w, h, Color(132, 1, 1))
            end
        end

    end,
    Setup = function(self, ply, info) 
        self.Info = info
        self.Sender = ply
        self.Title:SetText(self.Info.fac .. " wishes to be an Ally!")
        self.Yes.DoClick = function() 
            LocalPlayer():ChatPrint(self.Info.fac .. " is now your ally")
            net.Start("_JLib_AlliesInformation")
            net.WriteEntity(self.Sender)
            net.WriteTable(self.Info)
            net.WriteBool(true)
            net.SendToServer()
            self:Remove()
        end
        self.No.DoClick = function()
            net.Start("_JLib_AlliesInformation")
            net.WriteEntity(self.Sender)
            net.WriteTable(self.Info)
            net.WriteBool(false)
            net.SendToServer()
            self:Remove()
        end
    end,
    PerformLayout = function(self)
        self:SetSize(800, 150)
        self:SetPos((ScrW()/2) - (800/2), (ScrH()/2) - (300/2))
    end,
    Paint = function(self, w, h) 
        draw.RoundedBox(8, 0, 0, w, h, Color(28, 28, 28))
    end,
    --Think = function(self, w, h) 
    --end 
}

popup = vgui.RegisterTable(popup, "EditablePanel")

net.Receive("_JLib_AlliesMenu", function()
    local ply, info = net.ReadEntity(), net.ReadTable()
    if not IsValid(JLib.VGui.AlliesAccept) then 
        JLib.VGui.AlliesAccept = vgui.CreateFromTable(popup)
        JLib.VGui.AlliesAccept:Setup(ply, info)
        JLib.VGui.AlliesAccept:MakePopup()
        JLib.VGui.AlliesAccept:SetKeyBoardInputEnabled(false)
    else
        JLib.VGui.AlliesAccept:Remove()
    end
end )
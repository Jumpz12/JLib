--[[net.Receive("drawCommandPosts", function()

    local origin, radius, control, attackers, defenders = net.ReadVector(), net.ReadInt(32), net.ReadString(), net.ReadString(), net.ReadString() 

    cam.Start3D()
    render.SetColorMaterial()

    if LocalPlayer():getJobTable().category == attackers then

        if control == "attacking" then

            render.DrawSphere(Vector(-4006.552734, -318.367249, 3835.896729), 300, 50, 50, Color(0, 0, 255, 255))

        elseif control == "defending" then

            render.DrawSphere(Vector(-4006.552734, -318.367249, 3835.896729), 300, 50, 50, Color(0, 0, 255, 255))

        elseif control == "neutral" then

            render.DrawSphere(Vector(-4006.552734, -318.367249, 3835.896729), 300, 50, 50, Color(0, 0, 255, 255))

        end
    
    elseif LocalPlayer():getJobTable().category == defenders then

        if control == "defending" then

            render.DrawSphere(Vector(-4006.552734, -318.367249, 3835.896729), 300, 50, 50, Color(0, 0, 255, 255))

        elseif control == "attacking" then

            render.DrawSphere(Vector(-4006.552734, -318.367249, 3835.896729), 300, 50, 50, Color(0, 0, 255, 255))

        elseif control == "neutral" then

            render.DrawSphere(Vector(-4006.552734, -318.367249, 3835.896729), 300, 50, 50, Color(0, 0, 255, 255))

        end

    end
    cam.End3D()
end)]]


local spheresToDraw = {}

net.Receive("drawCommandPosts", function()

    local origin, radius, control, attackers, defenders = net.ReadVector(), net.ReadInt(32), net.ReadString(), net.ReadString(), net.ReadString() 

    table.insert( spheresToDraw, {
        origin,
        radius,
        control,
        attackers,
        defenders,
    } 
)
end)

local function renderingSpheres()

    
    render.SetColorMaterial()

    while true do
        
        cam.Start3D()

        for k, v in pairs(spheresToDraw) do

            if LocalPlayer():getJobTable().category == v.attackers then

                if v.control == "attacking" then

                    render.Clear()
                    render.DrawSphere(Vector(-4006.552734, -318.367249, 3835.896729), 300, 50, 50, Color(0, 0, 255, 255))

                elseif v.control == "defending" then

                    render.Clear()
                    render.DrawSphere(Vector(-4006.552734, -318.367249, 3835.896729), 300, 50, 50, Color(0, 0, 255, 255))

                elseif v.control == "neutral" then

                    render.Clear()
                    render.DrawSphere(Vector(-4006.552734, -318.367249, 3835.896729), 300, 50, 50, Color(0, 0, 255, 255))

                end
            
            elseif LocalPlayer():getJobTable().category == v.defenders then

                if v.control == "defending" then

                    render.Clear()
                    render.DrawSphere(Vector(-4006.552734, -318.367249, 3835.896729), 300, 50, 50, Color(0, 0, 255, 255))

                elseif v.control == "attacking" then

                    render.Clear()
                    render.DrawSphere(Vector(-4006.552734, -318.367249, 3835.896729), 300, 50, 50, Color(0, 0, 255, 255))

                elseif v.control == "neutral" then

                    render.Clear()
                    render.DrawSphere(Vector(-4006.552734, -318.367249, 3835.896729), 300, 50, 50, Color(0, 0, 255, 255))

                end

            end

        end

        cam.End3D()

    end

end

hook.Add("PostDrawTranslucentRenderables", "drawingSpheres", renderingSpheres)
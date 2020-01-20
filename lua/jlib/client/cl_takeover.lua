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

    local origin, radius, control, attackers, defenders, name = net.ReadVector(), net.ReadInt(32), net.ReadString(), net.ReadString(), net.ReadString(), net.ReadString()

    if table.HasValue(spheresToDraw, name) then return end

    table.insert( spheresToDraw, {
        name,
        origin,
        radius,
        control,
        attackers,
        defenders,
    } 
)

end)


local function renderingSpheres(bDepth, bSkybox)

    --if timer.Exists("renderingSpheresDelay") then return end
        
    --timer.Create("renderingSpheresDelay", 5, 1, renderingSpheres)

    cam.Start3D()
    
    render.SetColorMaterial()

    for k, v in pairs(spheresToDraw) do

        --PrintTable(v)
        --print(v.attackers)
        --print(v.defenders)
        --print(LocalPlayer():getJobTable().category)

        if LocalPlayer():getJobTable().category == v[5] then --attackers

            if v[4] == "attacking" then

                render.DrawSphere(v[2], v[3], 50, 50, Color(0, 0, 255, 10))

            elseif v[4] == "defending" then

                render.DrawSphere(v[2], v[3], 50, 50, Color(255, 0, 0, 10))

            elseif v[4] == "neutral" then

                render.DrawSphere(v[2], v[3], 50, 50, Color(117, 117, 117, 10))

            end
        
        elseif LocalPlayer():getJobTable().category == v[6] then --defenders

            if v[4] == "defending" then

                render.DrawSphere(v[2], v[3], 50, 50, Color(0, 0, 255, 10))

            elseif v[4] == "attacking" then

                render.DrawSphere(v[2], v[3], 50, 50, Color(255, 0, 0, 10))

            elseif v[4] == "neutral" then

                render.DrawSphere(v[2], v[3], 50, 50, Color(117, 117, 117, 10))

            end

        end

    end

    cam.End3D()

end

hook.Add("PostDrawTranslucentRenderables", "drawingSpheres", renderingSpheres)
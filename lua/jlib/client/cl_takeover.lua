local spheresToDraw = {}

net.Receive("drawCommandPosts", function()

    local origin, radius, control, attackers, defenders, name = net.ReadVector(), net.ReadInt(32), net.ReadString(), net.ReadString(), net.ReadString(), net.ReadString()

    for k, v in pairs(spheresToDraw) do

        if name == v[1] then

            table.remove(spheresToDraw, k)

        end

    end

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

    if table.IsEmpty(spheresToDraw) then return end

    cam.Start3D()
    
    render.SetColorMaterial()

    for k, v in pairs(spheresToDraw) do

        --PrintTable(v)
        --print(v.attackers)
        --print(v.defenders)
        --print(LocalPlayer():getJobTable().category)

        if LocalPlayer():getJobTable().category == v[5] then --attackers

            if v[4] == "attacking" then

                render.DrawSphere(v[2], v[3], 30, 30, Color(0, 0, 255, 10))

            elseif v[4] == "defending" then

                render.DrawSphere(v[2], v[3], 30, 30, Color(255, 0, 0, 10))

            elseif v[4] == "neutral" then

                render.DrawSphere(v[2], v[3], 30, 30, Color(117, 117, 117, 10))

            end
        
        elseif LocalPlayer():getJobTable().category == v[6] then --defenders

            if v[4] == "defending" then

                render.DrawSphere(v[2], v[3], 30, 30, Color(0, 0, 255, 10))

            elseif v[4] == "attacking" then

                render.DrawSphere(v[2], v[3], 30, 30, Color(255, 0, 0, 10))

            elseif v[4] == "neutral" then

                render.DrawSphere(v[2], v[3], 30, 30, Color(117, 117, 117, 10))

            end

        end

    end

    cam.End3D()

end

hook.Add("PostDrawTranslucentRenderables", "drawingSpheres", renderingSpheres)

net.Receive("removeCommandPosts", function()

    local name = net.ReadString()

    for k, v in pairs(spheresToDraw) do

        if v[1] == name then 

            table.remove(spheresToDraw, k)

        end

    end

end)
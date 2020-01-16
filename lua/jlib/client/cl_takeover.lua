net.Receive("drawCommandPosts", function()

    local origin, radius, control, attackers, defenders = net.ReadVector(), net.ReadInt(32), net.ReadString(), net.ReadString(), net.ReadString()
    ply = LocalPlayer()
    render.SetColorMaterial()

    if LocalPlayer().getJobTable().category == attackers then

        if control == "attacking" then

            render.Clear(0, 0, 0, 0, true, true)
            render.DrawSphere(origin, radius, 50, 50, color(0, 0, 255))

        elseif control == "defending" then

            render.Clear(0, 0, 0, 0, true, true)
            render.DrawSphere(origin, radius, 50, 50, color(255, 0, 0))

        elseif control == "neutral" then

            render.Clear(0, 0, 0, 0, true, true)
            render.DrawSphere(origin, radius, 50, 50, color(143, 143, 143))

        end
    
    elseif LocalPlayer().getJobTable().category == defenders then

        if control == "defending" then

            render.Clear(0, 0, 0, 0, true, true)
            render.DrawSphere(origin, radius, 50, 50, color(0, 0, 255))

        elseif control == "attacking" then

            render.Clear(0, 0, 0, 0, true, true)
            render.DrawSphere(origin, radius, 50, 50, color(255, 0, 0))

        elseif control == "neutral" then

            render.Clear(0, 0, 0, 0, true, true)
            render.DrawSphere(origin, radius, 50, 50, color(143, 143, 143))

        end

    end
    
end)
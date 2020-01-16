net.Receive("drawCommandPosts", function()

    local origin, radius, control, attackers, defenders = net.ReadVector(), net.ReadInt(32), net.ReadString(), net.ReadString(), net.ReadString()
    ply = LocalPlayer()
    render.SetMaterial(mat)
    render.SetColorMaterial()

    if LocalPlayer().getJobTable().category == attackers then

        if control == "attacking" then

            render.DrawSphere(Vector(-3119.504883, -2840.322998, 2147.031250), 300, 50, 50, Color(0, 0, 255, 100))

        elseif control == "defending" then

            render.DrawSphere(Vector(-3119.504883, -2840.322998, 2147.031250), 300, 50, 50, Color(0, 0, 255, 100))

        elseif control == "neutral" then

            render.DrawSphere(Vector(-3119.504883, -2840.322998, 2147.031250), 300, 50, 50, Color(0, 0, 255, 100))

        end
    
    elseif LocalPlayer().getJobTable().category == defenders then

        if control == "defending" then

            render.DrawSphere(Vector(-3119.504883, -2840.322998, 2147.031250), 300, 50, 50, Color(0, 0, 255, 100))

        elseif control == "attacking" then

            render.DrawSphere(Vector(-3119.504883, -2840.322998, 2147.031250), 300, 50, 50, Color(0, 0, 255, 100))

        elseif control == "neutral" then

            render.DrawSphere(Vector(-3119.504883, -2840.322998, 2147.031250), 300, 50, 50, Color(0, 0, 255, 100))

        end

    end
    
end)
local function CheckSpheres()
    local gravity
    for _, p in ipairs(player.GetAll()) do
      --p:ChatPrint("You were selected.")
      gravity = JLib.Config.Gravity.Global
      if not p:IsPlayer() then return end
      if not p:Alive() then return end
      --p:ChatPrint("You are alive and real.")
      for i=1, #JLib.Config.Gravity.Spheres do
          --p:ChatPrint("Checking sphere " .. i .. ".")
          for _, s in ipairs(ents.FindInSphere(JLib.Config.Gravity.Spheres[i].origin, JLib.Config.Gravity.Spheres[i].radius)) do
              if p == s then
                  --p:ChatPrint("You are in sphere " .. i .. ".")
                  gravity = JLib.Config.Gravity.Spheres[i].gravity
              else
                if not timer.Exists(p:SteamID64() .. "DamageTime") then 
                    if ply:HasGodMode() then return end
                    timer.Create(p:SteamID64() .. "DamageTime", JLib.Config.PlanetDamage.Time, 1, function(ply) 
                         p:SetHealth(p:Health() - JLib.Config.PlanetDamage.Global)
                    end)
                    if p:Health() <= 0  then
                        p:Kill()
                    end
                end
            end
          end
      end

      --p:ChatPrint("Your gravity was set to " .. gravity  .. ".")
      p:SetGravity(gravity)
    end
  end
hook.Add("PlayerTick", "CheckSpheres", CheckSpheres)
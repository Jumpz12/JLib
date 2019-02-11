--[[

    Config for JLib!
    Touch as you will.

]]

JLib = JLib or {}
JLib.Config = JLib.Config or {}

-- GRAVITY SETTINGS

JLib.Config.Gravity = JLib.Config.Gravity or {}

JLib.Config.Gravity.Global = 1 -- Gravity Multiplier Outside Of Spheres (0-1)

JLib.Config.Gravity.Spheres = {

    {

        name = "Tatooine",
        origin = Vector(), -- Orgin Point Of The Sphere
        --radius = , -- Radius Of The Sphere
        gravity = 1, -- Gravity Multiplier Inside Of Sphere (0-1)
        control = "",
        control_points = {

            [1] = {
                origin = Vector(5121.949707, -9037.371094, -3383.655518),
                radius = 300,
            },
            [2] = {
                origin = Vector(5468.858398, -12792.708984, -3583.920654),
                radius = 300,
            },
            [3] = {
                origin = Vector(3592.949463, -9114.949219, -3576.496338),
                radius = 300,
            },

        },

    },

    {

        name = "Hoth",
        origin = Vector(),
        --radius = ,
        gravity = 1,
        control = "",
        control_points = {

            [1] = {
                origin = Vector(-3119.504883, -2840.322998, 2147.031250),
                radius = 300,
            },
            [2] = {
                origin = Vector(-1526.392456, -2698.471191, 2147.031250),
                radius = 300,
            },
            [3] = {
                origin = Vector(-6098.393555, 1497.231934, 2165.325684),
                radius = 300,
            },

        },

    },

    {

        name = "Tython",
        origin = Vector(),
        --radius = ,
        gravity = 1,
        control = "",
        control_points = {

            [1] = {
                origin = Vector(-10240.182617, -8438.574219, 10924.031250),
                radius = 300,
            },
            [2] = {
                origin = Vector(-12434.535156, -12257.809570, 10560.892578),
                radius = 300,
            },
            [3] = {
                origin = Vector(-12432.916016, -9054.247070, 8872.031250),
                radius = 300,
            },

        },

    },

    {

        name = "Geonosis",
        origin = Vector(),
        --radius = ,
        gravity = 1,
        control = "",
        control_points = {

            [1] = {
                origin = Vector(-10477.693359, 8412.937500, 8956.291016),
                radius = 300,
            },
            [2] = {
                origin = Vector(-9172.641602, 12798.719727, 9532.031250),
                radius = 300,
            },
            [3] = {
                origin = Vector(-9172.641602, 12798.719727, 9532.031250),
                radius = 300,
            },

        },

    },

    {

        name = "Kashyyyk",
        origin = Vector(),
        --radius = ,
        gravity = 1,
        control = "",
        control_points = {

            [1] = {
                origin = Vector(-9172.641602, 12798.719727, 9532.031250),
                radius = 300,
            },
            [2] = {
                origin = Vector(-8968.150391, 5225.820801, -8116.968750),
                radius = 300,
            },
            [3] = {
                origin = Vector(-8968.150391, 5225.820801, -8116.968750),
                radius = 300,
            },

        },

    },

    {

        name = "Korriban",
        origin = Vector(),
        --radius = ,
        gravity = 1,
        control = "",
        control_points = {

            [1] = {
                origin = Vector(5175.112305, 10922.045898, -9365.117188),
                radius = 300,
            },
            [2] = {
                origin = Vector(2354.235352, 5727.841797, -9381.968750),
                radius = 300,
            },
            [3] = {
                origin = Vector(4436.012207, 6143.295898, -11079.468750),
                radius = 300,
            },

        },

    },

    {

        name = "Illum",
        origin = Vector(),
        --radius = ,
        gravity = 1,
        control = "",
        control_points = {

            [1] = {
                origin = Vector(6907.895996, 10810.828125, 6426.340332),
                radius = 300,
            },
            [2] = {
                origin = Vector(8120.113770, 8403.683594, 3483.031250),
                radius = 300,
            },
            [3] = {
                origin = Vector(10200.030273, 8016.627441, 3483.475098),
                radius = 300,
            },

        },

    },

    {

        name = "Star Destroyer",
        origin = Vector(),
        --radius = ,
        gravity = 1,
        control = "",
        control_points = {

            [1] = {
                origin = Vector(13541.453125, -226.528046, -138.893188),
                radius = 300,
            },
            [2] = {
                origin = Vector(13541.453125, -226.528046, -138.893188),
                radius = 300,
            },
            [3] = {
                origin = Vector(13541.453125, -226.528046, -138.893188),
                radius = 300,
            },

        },

    },

}

-- Planet Damage Settings

JLib.Config.PlanetDamage = JLib.Config.PlanetDamage or {}

JLib.Config.PlanetDamage.Global = 5 -- Damage when not in the sphere

JLib.Config.PlanetDamage.Time = 3 -- Time between damage taken

-- Rebreather Settings

JLib.Config.Rebreather = JLib.Config.Rebreather or {}

JLib.Config.Rebreather.Time = 30 -- How long the rebreathers effects will last

JLib.Config.Rebreather.Command = "/rebreather" -- Command needed to type to activate rebreather

JLib.Config.Rebreather.Name = "Rebreather" -- Name on the HUD (Not sure at the moment)

-- Planet Capture Settings
JLib.Config.PlanetControl = JLib.Config.PlanetControl or {}

JLib.Config.PlanetControl.Cooldown = 25 -- Cooldown between Raids

JLib.Config.PlanetControl.RaidTime = 15 -- How long a faction has to take the planet

JLib.Config.PlanetControl.Status = false

JLib.Config.PlanetControl.Planet_Attack = ""

hook.Add("PostGamemodeLoaded", "Table_Load", function()  
    
    JLib.Config.PlanetControl.HeroLeaders = { -- Hero Characters who can start a raid

        TEAM_LUKESKYWALKER,
        TEAM_COCODY,
        TEAM_CPTREX,
        TEAM_YODA,
        TEAM_JEDIHCMEMBER,
        TEAM_REBELCPT,

    }

    JLib.Config.PlanetControl.VillianLeaders = { -- Villian Characters who can start a raid

        TEAM_DARTHVADER,
        TEAM_PALPATINE,
        TEAM_SITHLORD,
        TEAM_IMPERIALCPT,
        TEAM_DOOKU,
        TEAM_COMMANDODROID,

    }

end )
JLib.Config.PlanetControl.Minimum = 4 -- How many a side must have for a raid to be activated
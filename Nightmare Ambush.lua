--// NIGHTMARE AMBUSH

local Creator = loadstring(game:HttpGet(
    "https://pastebin.com/raw/0fSnvfGt"
))()

local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

--==================================================
-- ENTITY CONFIGURATION
--==================================================

local entity = Creator.createEntity({
    CustomName = "Nightmare Ambush",

    Model = "https://raw.githubusercontent.com/Ilikerobloxdoors/Nightmare-Ambush/main/NIGHTMARE%20AMBUSH.rbxm",

    Speed = 375,
    DelayTime = 3.8,
    HeightOffset = 0,

    CanKill = true,
    KillRange = 40,

    BreakLights = true,
    BackwardsMovement = false,

    FlickerLights = {
        false,
        1,
    },

    Cycles = {
        Min = 4,
        Max = 8,
        WaitTime = 0.3,
    },

    CamShake = {
        true,
        {13, 17.5, 0.2, 1.2},
        100,
    },

    Jumpscare = {
        true,
        {
            Image1 = "rbxassetid://12557955051",
            Image2 = "rbxassetid://12557955051",
            Shake = true,

            Sound1 = {
                116282238939992,
                {Volume = 0.5},
            },

            Sound2 = {
                116282238939992,
                {Volume = 0.5},
            },

            Flashing = {
                true,
                Color3.fromRGB(86, 0, 0),
            },

            Tease = {
                false,
                Min = 4,
                Max = 4,
            },
        },
    },

    CustomDialog = {
        "You died to Nightmare Ambush...",
    },
})

--==================================================
-- RED ROOM + VIOLENT CAMERA SHAKE
--==================================================

local function playNightmareIntro()
    local camera = workspace.CurrentCamera

    if not camera then
        warn("Nightmare Ambush: camera not found")
        return
    end

    -- Create red color correction
    local redEffect = Instance.new("ColorCorrectionEffect")
    redEffect.Name = "NightmareAmbushRedIntro"
    redEffect.TintColor = Color3.fromRGB(120, 0, 0)
    redEffect.Brightness = -0.25
    redEffect.Contrast = 0.6
    redEffect.Saturation = -0.2
    redEffect.Parent = Lighting

    -- Let the red room appear first
    task.wait(0.2)

    -- Start violent shake
    local duration = 1
    local startTime = os.clock()
    local bindName = "NightmareAmbushIntroShake"

    RunService:UnbindFromRenderStep(bindName)

    RunService:BindToRenderStep(
        bindName,
        Enum.RenderPriority.Camera.Value + 1,
        function()
            local elapsed = os.clock() - startTime

            if elapsed >= duration then
                RunService:UnbindFromRenderStep(bindName)
                return
            end

            local fade = 1 - elapsed / duration
            local intensity = 2.5 * fade
            local rotation = 30 * fade

            local x = (math.random() - 0.5) * 2 * intensity
            local y = (math.random() - 0.5) * 2 * intensity
            local z = (math.random() - 0.5) * intensity

            local rx = math.rad(math.random(-rotation, rotation))
            local ry = math.rad(math.random(-rotation, rotation))
            local rz = math.rad(math.random(-rotation, rotation))

            camera.CFrame = camera.CFrame
                * CFrame.new(x, y, z)
                * CFrame.Angles(rx, ry, rz)
        end
    )

    task.wait(duration)

    RunService:UnbindFromRenderStep(bindName)

    -- Restore normal colors
    local restore = TweenService:Create(
        redEffect,
        TweenInfo.new(0.3),
        {
            TintColor = Color3.new(1, 1, 1),
            Brightness = 0,
            Contrast = 0,
            Saturation = 0,
        }
    )

    restore:Play()
    restore.Completed:Wait()
    redEffect:Destroy()
end

--==================================================
-- DEBUG CALLBACKS
--==================================================

entity.Debug.OnEntitySpawned = function(entityTable)
    print("Nightmare Ambush spawned:", entityTable.Model)
end

entity.Debug.OnEntityDespawned = function(entityTable)
    print("Nightmare Ambush despawned:", entityTable.Model)
end

entity.Debug.OnEntityStartMoving = function(entityTable)
    print("Nightmare Ambush started moving:", entityTable.Model)
end

entity.Debug.OnEntityFinishedRebound = function(entityTable)
    print("Nightmare Ambush finished rebound:", entityTable.Model)
end

entity.Debug.OnEntityEnteredRoom = function(entityTable, room)
    print("Nightmare Ambush entered room:", room)
end

entity.Debug.OnLookAtEntity = function(entityTable)
    print("Player looked at Nightmare Ambush:", entityTable.Model)
end

entity.Debug.OnDeath = function(entityTable)
    warn("Player died to Nightmare Ambush.")
end

--==================================================
-- RUN INTRO FIRST, THEN SPAWN
--==================================================

playNightmareIntro()

Creator.runEntity(entity)

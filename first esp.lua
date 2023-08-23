local health_bar = true
local box = true
local name = true
local team_color = true
local enemy_only = true
local outline = false
local chams = false

local player = game.Players.LocalPlayer
local players = {} 
local core = game:GetService("CoreGui")

local function CreateBillboard(adornee, playerName, playerHealth, playerMaxHealth, playerTeamColor)
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "SecretWallStuff"
    billboard.AlwaysOnTop = true
    billboard.Size = UDim2.new(4, 0, 6.5, 0) 
    billboard.StudsOffset = Vector3.new(0, -0.5, 0)
    billboard.Adornee = adornee
    billboard.Parent = core
    
    if box then
        local frame = Instance.new("Frame")
        frame.BackgroundTransparency =  1
        frame.BorderSizePixel = 1
        frame.Size = UDim2.new(1, 0, 1, 0)
        
        local UiStroke = Instance.new("UIStroke")
        UiStroke.Enabled = true
        UiStroke.Thickness = 1  
        if team_color then
            UiStroke.Color = playerTeamColor.Color
        else
            UiStroke.Color = Color3.new(1,1,1)
        end
        UiStroke.Parent = frame

        frame.Parent = billboard
    end
    
    if health_bar then
        local healthBar = Instance.new("Frame")
        healthBar.BackgroundColor3 = Color3.new(0, 1, 0) 
        healthBar.BorderSizePixel = 1
        healthBar.Size = UDim2.new(0, 2, 1, 0)
        healthBar.Parent = billboard

        local healthBar2 = Instance.new("Frame")
        healthBar2.BackgroundColor3 = Color3.new(0, 0, 0) 
        healthBar2.BorderSizePixel = 0
        healthBar2.Size = UDim2.new(0, 2, 1 - playerHealth / playerMaxHealth, 0)
        healthBar2.Parent = healthBar
    end

    if name then
        local nameLabel = Instance.new("TextLabel")
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = playerName
        nameLabel.Font = Enum.Font.SourceSans
        nameLabel.TextColor3 = Color3.new(1, 1, 1)
        nameLabel.TextSize = 14
        nameLabel.TextStrokeTransparency = 0.300
        nameLabel.Position = UDim2.new(0, 0, -0.5, 0)
        nameLabel.Size = UDim2.new(1, 0, 1, 0)

        nameLabel.Parent = billboard
    end
end

local function CreateOutline(character, adornee, teamColor)
    if not adornee or not adornee:IsA("BasePart") then
        return
    end

    for _, highlight in pairs(adornee:GetChildren()) do
        if highlight:IsA("Highlight") then
            highlight:Destroy()
        end
    end

    local highlight = Instance.new("Highlight")
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = adornee
    highlight.Adornee = character
    highlight.FillTransparency = 1
    highlight.Name = "HighlightMuqer"
    if team_color then 
        highlight.OutlineColor = teamColor.Color 
    else
        highlight.OutlineColor = Color3.new(1,1,1)
    end
end

local function CreateChams(character, adornee, teamColor)
    if not adornee or not adornee:IsA("BasePart") then
        return
    end

    for _, BodyPart in pairs(character:GetDescendants()) do
        if BodyPart:IsA("BasePart") then
            if BodyPart.Material == "ForceField" then
                return
            end
            return
        end
    end


    for _, BodyPart in pairs(character:GetDescendants()) do
        if BodyPart:IsA("BasePart") then
            BodyPart.Material = "ForceField"
            if team_color then 
                BodyPart.Color = teamColor.Color 
            else
                BodyPart.Color = Color3.new(1,1,1)
            end 
        end
    end
end

local function GetEnemyPlayers()
    players = {}
    if #game:GetService("Teams"):GetTeams() > 0 then
        local friendly = player.Team.Name
        for i,v in pairs(game:GetService("Teams"):GetTeams()) do
            if v.Name ~= friendly and v.Name ~= (game.Teams:FindFirstChild("Spectators") and game.Teams.Spectators.Name) then
                local enemyPlayers = v:GetPlayers()
                for i,v in pairs(enemyPlayers) do
                    table.insert(players, v)
                end
            end
        end
        return players
    end
end

local function InsertBillboardToPlayers()
    for i,v in pairs(game:GetService("CoreGui"):GetChildren()) do
        if v.Name == "SecretWallStuff" then
            v:Destroy()
        end
    end
    local allPlayers
    if enemy_only then 
    	allPlayers = GetEnemyPlayers()
    else
    	allPlayers = game.Players:GetPlayers()
    end
    for i,v in pairs(allPlayers) do
        local health = v.Character and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health or 0
        local maxHealth = v.Character and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.MaxHealth or 1
        local teamColor = v.TeamColor -- Get the player's team color
        if health/maxHealth ~= 0 and v ~= game.Players.LocalPlayer then
            CreateBillboard(v.Character and v.Character:FindFirstChild("HumanoidRootPart"), v.Name, health, maxHealth, teamColor)
            if outline then
                CreateOutline(v.Character, v.Character:FindFirstChild("HumanoidRootPart"), teamColor)
            end
            if chams then 
                CreateChams(v.Character, v.Character:FindFirstChild("HumanoidRootPart"), teamColor)
            end
        end
    end
end
InsertBillboardToPlayers()
while wait() do 
    InsertBillboardToPlayers()
end
game.Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Wait()
    InsertBillboardToPlayers()
end)
game.Players.PlayerRemoving:Connect(function(plr)
    plr.CharacterRemoving:Wait()
    InsertBillboardToPlayers()
end)

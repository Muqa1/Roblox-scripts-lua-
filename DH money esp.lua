game:GetService("RunService").RenderStepped:Connect(function()
	for i, m in pairs(game:GetService("Workspace").Ignored.Drop:GetChildren()) do 
		if m.Name == "MoneyDrop" then 
			if not m:FindFirstChild("ASDWAgFWE2") then
				local billboard = Instance.new("BillboardGui")
    				billboard.Name = "ASDWAgFWE2"
    				billboard.AlwaysOnTop = true
    				billboard.Size = UDim2.new(4, 0, 4, 0) 
    				billboard.Adornee = m
    				billboard.Parent = m	
    	
    				local nameLabel = Instance.new("TextLabel")
        			nameLabel.BackgroundTransparency = 1
        			nameLabel.Text = "Money"
        			nameLabel.TextScaled = true
        			nameLabel.TextWrapped = true
        			nameLabel.Font = Enum.Font.Code
        			nameLabel.TextColor3 = Color3.new(1, 1, 1)
        			nameLabel.TextSize = 20
        			nameLabel.Position = UDim2.new(0, 0, 0, 0)
        			nameLabel.Size = UDim2.new(1, 0, 1, 0)
        			nameLabel.Parent = billboard
			end
		end
	end
end)

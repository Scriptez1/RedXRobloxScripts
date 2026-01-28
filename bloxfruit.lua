local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
_G.guiParent = player:WaitForChild("PlayerGui")

print("GUI loading...")
local success, RedX = pcall(function()
    local code = game:HttpGet('https://raw.githubusercontent.com/Scriptez1/RedXRobloxScripts/main/gui.lua')
    return loadstring(code)()
end)

if not success then
    warn("❌ GUI not loading:", RedX)
    return
end

if not RedX or type(RedX) ~= "table" then
    warn("❌ RedX module not loaded correctly!")
    return
end

print("✅ RedX GUI loaded successfully!")
local ui = RedX.new("RedX Hub : Blox Fruits")

local mainMenu = ui:CreatePage("Main Menu", "rbxassetid://7733960981")
local mainMenuSec = ui:Section(mainMenu, "Main Menu")

local farm = ui:CreatePage("Farm", "rbxassetid://7733674079")
local farmConfSec = ui:Section(farm, "Config Farm")
local farmSec = ui:Section(farm, "Farm")
local bossSec = ui:Section(farm, "Boss Farm")
local meterialSec = ui:Section(farm, "Material Farm")
local chestSec = ui:Section(farm, "Chest Farm")

local quests = ui:CreatePage("Quests/Items", "rbxassetid://7733914390")
local questsSec = ui:Section(quests, "Quests/Items")

local sea = ui:CreatePage("Sea", "rbxassetid://10747376931")
local seaSec = ui:Section(sea, "Sea")

local fruit = ui:CreatePage("Fruit", "rbxassetid://10709770005")
local fruitSec = ui:Section(fruit, "Fruit")

local raid = ui:CreatePage("Raid", "rbxassetid://7734056608")
local raidSec = ui:Section(raid, "Raid")

local stats = ui:CreatePage("Stats", "rbxassetid://18351727024")
local statsSec = ui:Section(stats, "Stats")

local teleport = ui:CreatePage("Teleport", "rbxassetid://6723742952")
local teleportSec = ui:Section(teleport, "Teleport")

local status = ui:CreatePage("Status", "rbxassetid://7743871002")
local statusSec = ui:Section(status, "Status")

local visual = ui:CreatePage("Visual", "rbxassetid://6031763426")
local visualSec = ui:Section(visual, "ESP")

local shop = ui:CreatePage("Shop", "rbxassetid://7734056813")
local shopSec = ui:Section(shop, "Shop")

local misc = ui:CreatePage("Misc", "rbxassetid://6031280882")
local miscSec = ui:Section(misc, "Misc")

local function toTarget(...)
    local args = {...}
    local target = args[1]
    local cf = (type(target) == "userdata" and target) or CFrame.new(unpack(args))
    
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end
    
    local dist = (cf.Position - player.Character.HumanoidRootPart.Position).Magnitude
    local speed = dist > 1000 and 300 or 315
    
    local tween = TweenService:Create(
        player.Character.HumanoidRootPart, 
        TweenInfo.new(dist/speed, Enum.EasingStyle.Linear),
        {CFrame = cf}
    )
    tween:Play()
    return tween
end

local function AttackNoCoolDown()
    local AC = debug.getupvalues(require(player.PlayerScripts.CombatFramework))[2].activeController
    if not AC then return end
    
    local bladehit = require(game.ReplicatedStorage.CombatFramework.RigLib).getBladeHits(
        player.Character,
        {player.Character.HumanoidRootPart},
        60
    )
    
    if #bladehit > 0 then
        local u8 = debug.getupvalue(AC.attack, 5)
        local u9 = debug.getupvalue(AC.attack, 6)
        local u7 = debug.getupvalue(AC.attack, 4)
        local u10 = debug.getupvalue(AC.attack, 7)
        u10 = u10 + 1
        debug.setupvalue(AC.attack, 7, u10)
        
        game:GetService("ReplicatedStorage").RigControllerEvent:FireServer("hit", bladehit, 1, "")
    end
end

local function AutoHaki()
    if not player.Character:FindFirstChild("HasBuso") then
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Buso")
    end
end

local function EquipWeapon(toolName)
    if player.Backpack:FindFirstChild(toolName) then
        player.Character.Humanoid:EquipTool(player.Backpack[toolName])
    end
end

-- Variables for farming
_G.AutoLevel = false
_G.SelectMonster = ""
local Ms, NameQuest, QuestLv, NameMon, CFrameQ, CFrameMon
local posX, posY, posZ = 0, 25, 0

local First_Sea, Second_Sea, Third_Sea = false, false, false
local placeId = game.PlaceId
if placeId == 2753915549 then First_Sea = true elseif placeId == 4442272183 then Second_Sea = true elseif placeId == 7449423635 then Third_Sea = true end

local function CheckLevel()
    local Lv = player.Data.Level.Value
    if First_Sea then
        if Lv >= 1 and Lv <= 9 then
            Ms = "Bandit"; NameQuest = "BanditQuest1"; QuestLv = 1; NameMon = "Bandit"
            CFrameQ = CFrame.new(1060.9, 16.5, 1547.8); CFrameMon = CFrame.new(1038.5, 41.3, 1576.5)
        elseif Lv >= 10 and Lv <= 14 then
            Ms = "Monkey"; NameQuest = "JungleQuest"; QuestLv = 1; NameMon = "Monkey"
            CFrameQ = CFrame.new(-1601.7, 36.9, 153.4); CFrameMon = CFrame.new(-1448.1, 50.9, 63.6)
        elseif Lv >= 15 and Lv <= 29 then
            Ms = "Gorilla"; NameQuest = "JungleQuest"; QuestLv = 2; NameMon = "Gorilla"
            CFrameQ = CFrame.new(-1601.7, 36.9, 153.4); CFrameMon = CFrame.new(-1142.6, 40.5, -515.4)
        elseif Lv >= 30 and Lv <= 39 then
            Ms = "Pirate"; NameQuest = "BuggyQuest1"; QuestLv = 1; NameMon = "Pirate"
            CFrameQ = CFrame.new(-1140.2, 4.8, 3827.4); CFrameMon = CFrame.new(-1201.1, 40.6, 3857.6)
        elseif Lv >= 40 and Lv <= 59 then
            Ms = "Brute"; NameQuest = "BuggyQuest1"; QuestLv = 2; NameMon = "Brute"
            CFrameQ = CFrame.new(-1140.2, 4.8, 3827.4); CFrameMon = CFrame.new(-1387.5, 24.6, 4101.0)
        elseif Lv >= 60 and Lv <= 74 then
            Ms = "Desert Bandit"; NameQuest = "DesertQuest"; QuestLv = 1; NameMon = "Desert Bandit"
            CFrameQ = CFrame.new(896.5, 6.4, 4390.1); CFrameMon = CFrame.new(985.0, 16.1, 4417.9)
        elseif Lv >= 75 and Lv <= 89 then
            Ms = "Desert Officer"; NameQuest = "DesertQuest"; QuestLv = 2; NameMon = "Desert Officer"
            CFrameQ = CFrame.new(896.5, 6.4, 4390.1); CFrameMon = CFrame.new(1547.2, 14.5, 4381.8)
        elseif Lv >= 90 and Lv <= 99 then
            Ms = "Snow Bandit"; NameQuest = "SnowQuest"; QuestLv = 1; NameMon = "Snow Bandit"
            CFrameQ = CFrame.new(1386.8, 87.3, -1298.4); CFrameMon = CFrame.new(1356.3, 105.8, -1328.2)
        elseif Lv >= 100 and Lv <= 119 then
            Ms = "Snowman"; NameQuest = "SnowQuest"; QuestLv = 2; NameMon = "Snowman"
            CFrameQ = CFrame.new(1386.8, 87.3, -1298.4); CFrameMon = CFrame.new(1218.8, 138.0, -1488.0)
        elseif Lv >= 120 and Lv <= 149 then
            Ms = "Chief Petty Officer"; NameQuest = "MarineQuest2"; QuestLv = 1; NameMon = "Chief Petty Officer"
            CFrameQ = CFrame.new(-5035.5, 28.7, 4324.2); CFrameMon = CFrame.new(-4931.2, 65.8, 4121.8)
        elseif Lv >= 150 and Lv <= 174 then
            Ms = "Sky Bandit"; NameQuest = "SkyQuest"; QuestLv = 1; NameMon = "Sky Bandit"
            CFrameQ = CFrame.new(-4842.1, 717.7, -2623.0); CFrameMon = CFrame.new(-4955.6, 365.5, -2908.2)
        elseif Lv >= 175 and Lv <= 189 then
            Ms = "Dark Master"; NameQuest = "SkyQuest"; QuestLv = 2; NameMon = "Dark Master"
            CFrameQ = CFrame.new(-4842.1, 717.7, -2623.0); CFrameMon = CFrame.new(-5148.2, 439.0, -2333.0)
        elseif Lv >= 190 and Lv <= 209 then
            Ms = "Prisoner"; NameQuest = "PrisonerQuest"; QuestLv = 1; NameMon = "Prisoner"
            CFrameQ = CFrame.new(5310.6, 0.4, 474.9); CFrameMon = CFrame.new(4937.3, 0.3, 649.6)
        elseif Lv >= 210 and Lv <= 249 then
            Ms = "Dangerous Prisoner"; NameQuest = "PrisonerQuest"; QuestLv = 2; NameMon = "Dangerous Prisoner"
            CFrameQ = CFrame.new(5310.6, 0.4, 474.9); CFrameMon = CFrame.new(5099.7, 0.4, 1055.8)
        elseif Lv >= 250 and Lv <= 274 then
            Ms = "Toga Warrior"; NameQuest = "ColosseumQuest"; QuestLv = 1; NameMon = "Toga Warrior"
            CFrameQ = CFrame.new(-1577.8, 7.4, -2984.5); CFrameMon = CFrame.new(-1872.5, 49.1, -2913.8)
        elseif Lv >= 275 and Lv <= 299 then
            Ms = "Gladiator"; NameQuest = "ColosseumQuest"; QuestLv = 2; NameMon = "Gladiator"
            CFrameQ = CFrame.new(-1577.8, 7.4, -2984.5); CFrameMon = CFrame.new(-1521.4, 81.2, -3066.3)
        elseif Lv >= 300 and Lv <= 324 then
            Ms = "Military Soldier"; NameQuest = "MagmaQuest"; QuestLv = 1; NameMon = "Military Soldier"
            CFrameQ = CFrame.new(-5316.1, 12.3, 8517.0); CFrameMon = CFrame.new(-5369.0, 61.2, 8556.5)
        elseif Lv >= 325 and Lv <= 374 then
            Ms = "Military Spy"; NameQuest = "MagmaQuest"; QuestLv = 2; NameMon = "Military Spy"
            CFrameQ = CFrame.new(-5316.1, 12.3, 8517.0); CFrameMon = CFrame.new(-5787.0, 75.8, 8651.7)
        elseif Lv >= 375 and Lv <= 399 then
            Ms = "Fishman Warrior"; NameQuest = "FishmanQuest"; QuestLv = 1; NameMon = "Fishman Warrior"
            CFrameQ = CFrame.new(61122.7, 18.5, 1569.4); CFrameMon = CFrame.new(60844.1, 98.5, 1298.4)
        elseif Lv >= 400 and Lv <= 449 then
            Ms = "Fishman Commando"; NameQuest = "FishmanQuest"; QuestLv = 2; NameMon = "Fishman Commando"
            CFrameQ = CFrame.new(61122.7, 18.5, 1569.4); CFrameMon = CFrame.new(61738.4, 64.2, 1433.8)
        elseif Lv >= 450 and Lv <= 474 then
            Ms = "God's Guard"; NameQuest = "SkyExp1Quest"; QuestLv = 1; NameMon = "God's Guard"
            CFrameQ = CFrame.new(-4721.9, 845.3, -1953.8); CFrameMon = CFrame.new(-4628.0, 866.9, -1931.2)
        elseif Lv >= 475 and Lv <= 524 then
            Ms = "Shanda"; NameQuest = "SkyExp1Quest"; QuestLv = 2; NameMon = "Shanda"
            CFrameQ = CFrame.new(-7863.2, 5545.5, -378.4); CFrameMon = CFrame.new(-7685.1, 5601.1, -441.4)
        elseif Lv >= 525 and Lv <= 549 then
            Ms = "Royal Squad"; NameQuest = "SkyExp2Quest"; QuestLv = 1; NameMon = "Royal Squad"
            CFrameQ = CFrame.new(-7903.4, 5636.0, -1410.9); CFrameMon = CFrame.new(-7654.3, 5637.1, -1407.8)
        elseif Lv >= 550 and Lv <= 624 then
            Ms = "Royal Soldier"; NameQuest = "SkyExp2Quest"; QuestLv = 2; NameMon = "Royal Soldier"
            CFrameQ = CFrame.new(-7903.4, 5636.0, -1410.9); CFrameMon = CFrame.new(-7760.4, 5679.9, -1884.8)
        elseif Lv >= 625 and Lv <= 649 then
            Ms = "Galley Pirate"; NameQuest = "FountainQuest"; QuestLv = 1; NameMon = "Galley Pirate"
            CFrameQ = CFrame.new(5258.3, 38.5, 4050.0); CFrameMon = CFrame.new(5557.2, 152.3, 3998.8)
        elseif Lv >= 650 then
            Ms = "Galley Captain"; NameQuest = "FountainQuest"; QuestLv = 2; NameMon = "Galley Captain"
            CFrameQ = CFrame.new(5258.3, 38.5, 4050.0); CFrameMon = CFrame.new(5677.7, 92.8, 4966.6)
        end
    elseif Second_Sea then
        if Lv >= 700 and Lv <= 724 then
            Ms = "Raider"; NameQuest = "Area1Quest"; QuestLv = 1; NameMon = "Raider"
            CFrameQ = CFrame.new(-427.7, 73.0, 1835.9); CFrameMon = CFrame.new(68.9, 93.6, 2429.7)
        elseif Lv >= 725 and Lv <= 774 then
            Ms = "Mercenary"; NameQuest = "Area1Quest"; QuestLv = 2; NameMon = "Mercenary"
            CFrameQ = CFrame.new(-427.7, 73.0, 1835.9); CFrameMon = CFrame.new(-864.9, 122.5, 1453.2)
        elseif Lv >= 775 and Lv <= 799 then
            Ms = "Swan Pirate"; NameQuest = "Area2Quest"; QuestLv = 1; NameMon = "Swan Pirate"
            CFrameQ = CFrame.new(635.6, 73.1, 917.8); CFrameMon = CFrame.new(1065.4, 137.6, 1324.4)
        elseif Lv >= 800 and Lv <= 874 then
            Ms = "Factory Staff"; NameQuest = "Area2Quest"; QuestLv = 2; NameMon = "Factory Staff"
            CFrameQ = CFrame.new(635.6, 73.1, 917.8); CFrameMon = CFrame.new(533.2, 128.5, 355.6)
        elseif Lv >= 875 and Lv <= 899 then
            Ms = "Marine Lieutenant"; NameQuest = "MarineQuest3"; QuestLv = 1; NameMon = "Marine Lieutenant"
            CFrameQ = CFrame.new(-2441.0, 73.0, -3217.7); CFrameMon = CFrame.new(-2489.3, 84.6, -3151.9)
        elseif Lv >= 900 and Lv <= 949 then
            Ms = "Marine Captain"; NameQuest = "MarineQuest3"; QuestLv = 2; NameMon = "Marine Captain"
            CFrameQ = CFrame.new(-2441.0, 73.0, -3217.7); CFrameMon = CFrame.new(-2335.2, 79.8, -3245.9)
        elseif Lv >= 950 and Lv <= 974 then
            Ms = "Zombie"; NameQuest = "ZombieQuest"; QuestLv = 1; NameMon = "Zombie"
            CFrameQ = CFrame.new(-5494.3, 48.5, -794.6); CFrameMon = CFrame.new(-5536.5, 101.1, -835.6)
        elseif Lv >= 975 and Lv <= 999 then
            Ms = "Vampire"; NameQuest = "ZombieQuest"; QuestLv = 2; NameMon = "Vampire"
            CFrameQ = CFrame.new(-5494.3, 48.5, -794.6); CFrameMon = CFrame.new(-5806.1, 16.7, -1164.4)
        elseif Lv >= 1000 and Lv <= 1049 then
            Ms = "Snow Trooper"; NameQuest = "SnowMountainQuest"; QuestLv = 1; NameMon = "Snow Trooper"
            CFrameQ = CFrame.new(607.1, 401.4, -5370.6); CFrameMon = CFrame.new(535.2, 432.7, -5484.9)
        elseif Lv >= 1050 and Lv <= 1099 then
            Ms = "Winter Warrior"; NameQuest = "SnowMountainQuest"; QuestLv = 2; NameMon = "Winter Warrior"
            CFrameQ = CFrame.new(607.1, 401.4, -5370.6); CFrameMon = CFrame.new(1234.4, 457.0, -5174.1)
        elseif Lv >= 1100 and Lv <= 1124 then
            Ms = "Lab Subordinate"; NameQuest = "IceSideQuest"; QuestLv = 1; NameMon = "Lab Subordinate"
            CFrameQ = CFrame.new(-6061.8, 15.9, -4902.0); CFrameMon = CFrame.new(-5720.6, 63.3, -4784.6)
        elseif Lv >= 1125 and Lv <= 1174 then
            Ms = "Horned Warrior"; NameQuest = "IceSideQuest"; QuestLv = 2; NameMon = "Horned Warrior"
            CFrameQ = CFrame.new(-6061.8, 15.9, -4902.0); CFrameMon = CFrame.new(-6292.8, 91.2, -5502.6)
        elseif Lv >= 1175 and Lv <= 1199 then
            Ms = "Magma Ninja"; NameQuest = "FireSideQuest"; QuestLv = 1; NameMon = "Magma Ninja"
            CFrameQ = CFrame.new(-5429.0, 16.0, -5298.0); CFrameMon = CFrame.new(-5461.8, 130.4, -5836.5)
        elseif Lv >= 1200 and Lv <= 1249 then
            Ms = "Lava Pirate"; NameQuest = "FireSideQuest"; QuestLv = 2; NameMon = "Lava Pirate"
            CFrameQ = CFrame.new(-5429.0, 16.0, -5298.0); CFrameMon = CFrame.new(-5251.2, 55.2, -4774.4)
        elseif Lv >= 1250 and Lv <= 1274 then
            Ms = "Ship Deckhand"; NameQuest = "ShipQuest1"; QuestLv = 1; NameMon = "Ship Deckhand"
            CFrameQ = CFrame.new(1040.3, 125.1, 32911.0); CFrameMon = CFrame.new(921.1, 126.0, 33088.3)
        elseif Lv >= 1275 and Lv <= 1299 then
            Ms = "Ship Engineer"; NameQuest = "ShipQuest1"; QuestLv = 2; NameMon = "Ship Engineer"
            CFrameQ = CFrame.new(1040.3, 125.1, 32911.0); CFrameMon = CFrame.new(886.3, 40.5, 32800.8)
        elseif Lv >= 1300 and Lv <= 1324 then
            Ms = "Ship Steward"; NameQuest = "ShipQuest2"; QuestLv = 1; NameMon = "Ship Steward"
            CFrameQ = CFrame.new(971.4, 125.1, 33245.5); CFrameMon = CFrame.new(943.9, 129.6, 33444.4)
        elseif Lv >= 1325 and Lv <= 1349 then
            Ms = "Ship Officer"; NameQuest = "ShipQuest2"; QuestLv = 2; NameMon = "Ship Officer"
            CFrameQ = CFrame.new(971.4, 125.1, 33245.5); CFrameMon = CFrame.new(955.4, 181.1, 33331.9)
        elseif Lv >= 1350 and Lv <= 1374 then
            Ms = "Arctic Warrior"; NameQuest = "FrostQuest"; QuestLv = 1; NameMon = "Arctic Warrior"
            CFrameQ = CFrame.new(5668.1, 28.2, -6484.6); CFrameMon = CFrame.new(5935.5, 77.3, -6472.8)
        elseif Lv >= 1375 and Lv <= 1424 then
            Ms = "Snow Lurker"; NameQuest = "FrostQuest"; QuestLv = 2; NameMon = "Snow Lurker"
            CFrameQ = CFrame.new(5668.1, 28.2, -6484.6); CFrameMon = CFrame.new(5628.5, 57.6, -6618.3)
        elseif Lv >= 1425 and Lv <= 1449 then
            Ms = "Sea Soldier"; NameQuest = "ForgottenQuest"; QuestLv = 1; NameMon = "Sea Soldier"
            CFrameQ = CFrame.new(-3054.6, 236.9, -10147.8); CFrameMon = CFrame.new(-3185.0, 58.8, -9663.6)
        elseif Lv >= 1450 then
            Ms = "Water Fighter"; NameQuest = "ForgottenQuest"; QuestLv = 2; NameMon = "Water Fighter"
            CFrameQ = CFrame.new(-3054.6, 236.9, -10147.8); CFrameMon = CFrame.new(-3262.9, 298.7, -10552.5)
        end
    elseif Third_Sea then
        if Lv >= 1500 and Lv <= 1524 then
            Ms = "Pirate Millionaire"; NameQuest = "PiratePortQuest"; QuestLv = 1; NameMon = "Pirate Millionaire"
            CFrameQ = CFrame.new(-289.6, 43.8, 5580.1); CFrameMon = CFrame.new(-435.7, 189.7, 5551.1)
        elseif Lv >= 1525 and Lv <= 1574 then
            Ms = "Pistol Billionaire"; NameQuest = "PiratePortQuest"; QuestLv = 2; NameMon = "Pistol Billionaire"
            CFrameQ = CFrame.new(-289.6, 43.8, 5580.1); CFrameMon = CFrame.new(-236.5, 217.5, 6006.1)
        -- [Diğer leveller buraya eklenecek]
        end
    end
end

local tableMon, AreaList = {}, {}
if First_Sea then
    tableMon = {"Bandit","Monkey","Gorilla","Pirate","Brute","Desert Bandit","Desert Officer","Snow Bandit","Snowman","Chief Petty Officer","Sky Bandit","Dark Master","Prisoner","Dangerous Prisoner","Toga Warrior","Gladiator","Military Soldier","Military Spy","Fishman Warrior","Fishman Commando","God's Guard","Shanda","Royal Squad","Royal Soldier","Galley Pirate","Galley Captain"}
    AreaList = {'Jungle', 'Buggy', 'Desert', 'Snow', 'Marine', 'Sky', 'Prison', 'Colosseum', 'Magma', 'Fishman', 'Sky Island', 'Fountain'}
elseif Second_Sea then
    tableMon = {"Raider","Mercenary","Swan Pirate","Factory Staff","Marine Lieutenant","Marine Captain","Zombie","Vampire","Snow Trooper","Winter Warrior","Lab Subordinate","Horned Warrior","Magma Ninja","Lava Pirate","Ship Deckhand","Ship Engineer","Ship Steward","Ship Officer","Arctic Warrior","Snow Lurker","Sea Soldier","Water Fighter"}
    AreaList = {'Area 1', 'Area 2', 'Zombie', 'Marine', 'Snow Mountain', 'Ice fire', 'Ship', 'Frost', 'Forgotten'}
elseif Third_Sea then
    tableMon = {"Pirate Millionaire","Dragon Crew Warrior","Dragon Crew Archer","Female Islander","Giant Islander","Marine Commodore","Marine Rear Admiral","Fishman Raider","Fishman Captain","Forest Pirate","Mythological Pirate","Jungle Pirate","Musketeer Pirate","Reborn Skeleton","Living Zombie","Demonic Soul","Posessed Mummy","Peanut Scout","Peanut President","Ice Cream Chef","Ice Cream Commander","Cookie Crafter","Cake Guard","Baking Staff","Head Baker","Cocoa Warrior","Chocolate Bar Battler","Sweet Thief","Candy Rebel","Candy Pirate","Snow Demon","Isle Outlaw","Island Boy","Isle Champion"}
    AreaList = {'Pirate Port', 'Amazon', 'Marine Tree', 'Deep Forest', 'Haunted Castle', 'Nut Island', 'Ice Cream Island', 'Cake Island', 'Choco Island', 'Candy Island','Tiki Outpost'}
end

local BossList, MaterialList = {}, {}
if First_Sea then
    BossList = {"The Gorilla King", "Bobby", "The Saw", "Yeti", "Mob Leader", "Vice Admiral", "Saber Expert", "Warden", "Chief Warden", "Swan", "Magma Admiral", "Fishman Lord", "Wysper", "Thunder God", "Cyborg", "Ice Admiral", "Greybeard"}
elseif Second_Sea then
    BossList = {"Diamond", "Jeremy", "Fajita", "Don Swan", "Smoke Admiral", "Awakened Ice Admiral", "Tide Keeper", "Darkbeard", "Cursed Captain", "Order"}
elseif Third_Sea then
    BossList = {"Stone", "Island Empress", "Kilo Admiral", "Captain Elephant", "Beautiful Pirate", "Cake Queen", "Longma", "Soul Reaper", "rip_indra True Form"}
end
MaterialList = {"Radioactive Material", "Mystic Droplet", "Magma Ore", "Angel Wings", "Leather", "Scrap Metal", "Fish Tail", "Demonic Wisp", "Vampire Fang", "Conjured Cocoa", "Dragon Scale", "Gunpowder", "Mini Tusk"}

local BossMon, NameBoss, NameQuestBoss, QuestLvBoss, CFrameQBoss, CFrameBoss
local function CheckBossQuest()
    if First_Sea then
        if _G.SelectBoss == "The Gorilla King" then
            BossMon = "The Gorilla King"; NameBoss = "The Gorilla King"; NameQuestBoss = "JungleQuest"; QuestLvBoss = 3
            CFrameQBoss = CFrame.new(-1601.7, 36.9, 153.4); CFrameBoss = CFrame.new(-1088.8, 8.1, -488.6)
        -- ... [Diğer bosslar eklenebilir]
        end
    end
end

local MMon, MPos
local function MaterialMon()
    if _G.SelectMaterial == "Radioactive Material" then
        MMon = "Factory Staff"; MPos = CFrame.new(295,73,-56)
    elseif _G.SelectMaterial == "Mystic Droplet" then
        MMon = "Water Fighter"; MPos = CFrame.new(-3385,239,-10542)
    -- ... [Diğer materyaller]
    end
end



ui:Dropdown(bossSec, "Select Boss", BossList, "None", function(v) _G.SelectBoss = v end)
ui:Toggle(bossSec, "Auto Farm Boss", function(v) _G.AutoBoss = v end)
ui:Toggle(bossSec, "Auto Farm All Boss", function(v) _G.AutoBoss = v end)

ui:Dropdown(meterialSec, "Select Material", MaterialList, "None", function(v) _G.SelectMaterial = v end)
ui:Toggle(meterialSec, "Auto Farm Material", function(v) _G.AutoMaterial = v end)

ui:Toggle(fruitSec, "Auto Store Fruit", function(v)
    if not v then
        for _,fruit in pairs(game.Workspace:GetChildren()) do
            local args = {
                [1] = "StoreFruit",
                [2] = game:GetService("Players").LocalPlayer.Character:FindFirstChild(string.find(fruit.Name, "Fruit"))
            }

            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
        end
    end
end)

-- ESP Functions
-- ESP Distance Slider (maksimum değer)
_G.ESPDistance = 50000
ui:Slider(visualSec, "ESP Distance", 1000, 50000, 50000, function(value)
    _G.ESPDistance = value
end)

-- ESP Functions - Uzaklık gösterimi ile güncellenmiş
local function CreateESP(part, text, color, showDistance)
    if part:FindFirstChild("RedX_ESP") then 
        part.RedX_ESP:Destroy() 
    end
    
    local bg = Instance.new("BillboardGui", part)
    bg.Name = "RedX_ESP"
    bg.AlwaysOnTop = true
    bg.Size = UDim2.new(0, 200, 0, 50)
    bg.StudsOffset = Vector3.new(0, 3, 0)
    
    local tl = Instance.new("TextLabel", bg)
    tl.BackgroundTransparency = 1
    tl.Size = UDim2.new(1, 0, 1, 0)
    tl.Text = text
    tl.TextColor3 = color or Color3.fromRGB(255, 255, 255)
    tl.Font = Enum.Font.GothamBold
    tl.TextSize = 14
    tl.TextStrokeTransparency = 0.5
    
    -- Uzaklık gösterimi için sürekli güncelleme
    if showDistance then
        task.spawn(function()
            while bg and bg.Parent and player.Character and player.Character:FindFirstChild("HumanoidRootPart") do
                local distance = (part.Position - player.Character.HumanoidRootPart.Position).Magnitude
                if distance <= _G.ESPDistance then
                    tl.Text = text .. "\n[" .. math.floor(distance) .. " studs]"
                    bg.Enabled = true
                else
                    bg.Enabled = false
                end
                task.wait(0.1)
            end
        end)
    end
end

-- Player ESP - Uzaklık gösterimli
ui:Toggle(visualSec, "Player ESP", function(v)
    _G.PlayerESP = v
    if not v then
        for _,p in pairs(game.Players:GetPlayers()) do
            if p.Character and p.Character:FindFirstChild("Head") and p.Character.Head:FindFirstChild("RedX_ESP") then
                p.Character.Head.RedX_ESP:Destroy()
            end
        end
    end
end)

task.spawn(function()
    while task.wait(1) do
        if _G.PlayerESP then
            for _,p in pairs(game.Players:GetPlayers()) do
                if p ~= player and p.Character and p.Character:FindFirstChild("Head") then
                    CreateESP(p.Character.Head, p.Name, Color3.fromRGB(255, 50, 50), true)
                end
            end
        end
    end
end)

-- Monster ESP - Uzaklık gösterimli
ui:Toggle(visualSec, "Monster ESP", function(v)
    _G.MonsterESP = v
    if not v then
        for _,mon in pairs(game.Workspace.Enemies:GetChildren()) do
            if mon:FindFirstChild("HumanoidRootPart") and mon.HumanoidRootPart:FindFirstChild("RedX_ESP") then
                mon.HumanoidRootPart.RedX_ESP:Destroy()
            end
        end
    end
end)

task.spawn(function()
    while task.wait(1) do
        if _G.MonsterESP then
            for _,mon in pairs(game.Workspace.Enemies:GetChildren()) do
                if mon:FindFirstChild("Humanoid") and mon:FindFirstChild("HumanoidRootPart") and mon.Humanoid.Health > 0 then
                    local monName = mon.Name
                    local level = mon:FindFirstChild("Level") and mon.Level.Value or "?"
                    CreateESP(mon.HumanoidRootPart, monName .. " [Lv." .. level .. "]", Color3.fromRGB(255, 100, 100), true)
                end
            end
        end
    end
end)

-- Fruit ESP - Uzaklık gösterimli
ui:Toggle(visualSec, "Fruit ESP", function(v)
    _G.FruitESP = v
    if not v then
        for _,fruit in pairs(game.Workspace:GetChildren()) do
            if string.find(fruit.Name, "Fruit") and fruit:FindFirstChild("Handle") and fruit.Handle:FindFirstChild("RedX_ESP") then
                fruit.Handle.RedX_ESP:Destroy()
            end
        end
    end
end)

task.spawn(function()
    while task.wait(2) do
        if _G.FruitESP then
            for _,fruit in pairs(game.Workspace:GetChildren()) do
                if string.find(fruit.Name, "Fruit") and fruit:FindFirstChild("Handle") then
                    CreateESP(fruit.Handle, fruit.Name, Color3.fromRGB(255, 215, 0), true)
                end
            end
        end
    end
end)

-- Chest ESP - Uzaklık gösterimli
ui:Toggle(visualSec, "Chest ESP", function(v)
    _G.ChestESP = v
    if not v then
        for _,chest in pairs(game.Workspace:GetChildren()) do
            if string.find(chest.Name, "Chest") and chest:FindFirstChild("RedX_ESP") then
                chest.RedX_ESP:Destroy()
            end
        end
    end
end)

task.spawn(function()
    while task.wait(2) do
        if _G.ChestESP then
            for _,chest in pairs(game.Workspace:GetChildren()) do
                if string.find(chest.Name, "Chest") then
                    local espPart = chest:IsA("Model") and chest.PrimaryPart or chest:IsA("Part") and chest or nil
                    if espPart then
                        CreateESP(espPart, chest.Name, Color3.fromRGB(100, 255, 100), true)
                    end
                end
            end
        end
    end
end)

-- NPC ESP - Uzaklık gösterimli
ui:Toggle(visualSec, "NPC ESP", function(v)
    _G.NPCESP = v
    if not v then
        for _,npc in pairs(game.Workspace.NPCs:GetChildren()) do
            if npc:FindFirstChild("HumanoidRootPart") and npc.HumanoidRootPart:FindFirstChild("RedX_ESP") then
                npc.HumanoidRootPart.RedX_ESP:Destroy()
            end
        end
    end
end)

task.spawn(function()
    while task.wait(2) do
        if _G.NPCESP then
            pcall(function()
                for _,npc in pairs(game.Workspace.NPCs:GetChildren()) do
                    if npc:FindFirstChild("HumanoidRootPart") then
                        CreateESP(npc.HumanoidRootPart, npc.Name, Color3.fromRGB(150, 150, 255), true)
                    end
                end
            end)
        end
    end
end)

-- Island ESP - Uzaklık gösterimli
ui:Toggle(visualSec, "Island ESP", function(v)
    _G.IslandESP = v
    if not v then
        for _,island in pairs(game.Workspace._WorldOrigin.Locations:GetChildren()) do
            if island:FindFirstChild("RedX_ESP") then
                island.RedX_ESP:Destroy()
            end
        end
    end
end)

task.spawn(function()
    while task.wait(3) do
        if _G.IslandESP then
            pcall(function()
                for _,island in pairs(game.Workspace._WorldOrigin.Locations:GetChildren()) do
                    if island:IsA("BasePart") then
                        CreateESP(island, island.Name, Color3.fromRGB(255, 255, 255), true)
                    end
                end
            end)
        end
    end
end)


task.spawn(function()
    while task.wait(1) do
        if _G.PlayerESP then
            for _,p in pairs(game.Players:GetPlayers()) do
                if p ~= player and p.Character and p.Character:FindFirstChild("Head") then
                    CreateESP(p.Character.Head, p.Name, Color3.fromRGB(255, 50, 50))
                end
            end
        end
    end
end)

ui:Toggle(miscSec, "Anti AFK", function(v)
    _G.AntiAFK = v
end)

ui:Button(miscSec, "FPS Booster", function()
    local decalsyeeted = true
    local g = game
    local w = g.Workspace
    local l = g.Lighting
    local t = w.Terrain
    sethiddenproperty(l,"Technology",2)
    sethiddenproperty(t,"Decoration",false)
    t.WaterWaveSize = 0
    t.WaterWaveSpeed = 0
    t.WaterReflectance = 0
    t.WaterTransparency = 0
    l.GlobalShadows = false
    l.FogEnd = 9e9
    l.Brightness = 0
    settings().Rendering.QualityLevel = "Level01"
    for i, v in pairs(g:GetDescendants()) do
        if v:IsA("Part") or v:IsA("Union") or v:IsA("CornerWedgePart") or v:IsA("TrussPart") then
            v.Material = "Plastic"; v.Reflectance = 0
        elseif v:IsA("Decal") or v:IsA("Texture") and decalsyeeted then
            v.Transparency = 1
        elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
            v.Lifetime = NumberRange.new(0)
        end
    end
end)

ui:Button(miscSec, "Auto Redeem Codes", function()
    local codes = {"LIGHTNINGABUSE", "1LOSTADMIN", "ADMINFIGHT", "GIFTING_HOURS", "Chandler", "kittgaming", "Fudd10", "fudd10_v2", "Bignews", "Sub2CaptainMaui", "Sub2Fer999", "Enyu_is_Pro", "Magicbus", "JCWK", "Starcodeheo", "Bluxxy", "SUB2GAMERROBOT_EXP1", "Sub2NoobMaster123", "Sub2UncleKizaru", "Sub2Daigrock", "Axiore", "TantaiGaming", "StrawHatMaine", "Sub2OfficialNoobie", "TheGreatAce"}
    for _,c in pairs(codes) do
        game:GetService("ReplicatedStorage").Remotes.Redeem:InvokeServer(c)
    end
end)

ui:Button(miscSec, "Reset Stats", function()
    local codes = {"KITT_RESET"}
    for _,c in pairs(codes) do
        game:GetService("ReplicatedStorage").Remotes.Redeem:InvokeServer(c)
    end
end)

ui:Toggle(chestSec, "Auto Chest Farm", function(v)
    _G.AutoChest = v
end)

ui:Slider(miscSec, "Walk Speed", 16, 100, 16, function(value)
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.WalkSpeed = value
    end
end)

ui:Slider(miscSec, "Jump Power", 50, 200, 50, function(value)
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.JumpPower = value
    end
end)

ui:Toggle(miscSec, "Fly", function(v)
    if v then
        _G.flying = true
        local plr = game.Players.LocalPlayer
        local humanoid = plr.Character:FindFirstChildOfClass("Humanoid")
        local bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.MaxForce = Vector3.new(4000,4000,4000)
        bodyVelocity.P = 1250
        bodyVelocity.Velocity = Vector3.new(0,0,0)
        bodyVelocity.Parent = humanoid.RootPart
        
        while _G.flying do
            if humanoid.MoveDirection.Magnitude > 0 then
                bodyVelocity.Velocity = humanoid.MoveDirection * 50
            else
                bodyVelocity.Velocity = Vector3.new(0,0,0)
            end
            task.wait()
        end
        bodyVelocity:Destroy()
    else
        _G.flying = false
    end
end)

-- Farm Settings
ui:Toggle(farmSec, "Auto Farm Level", function(v)
    _G.AutoLevel = v
end)
ui:Toggle(farmSec, "Auto Farm Nearest", function(v)
    
end)

ui:Dropdown(farmConfSec, "Select Weapon", {"Melee", "Sword", "Blox Fruit"}, "Melee", function(v)
    _G.SelectWeaponType = v
end)

ui:Dropdown(farmSec, "Select Monster", tableMon, "None", function(v)
    _G.SelectMonster = v
end)

ui:Dropdown(farmSec, "Select Area", AreaList, "None", function(v)
    _G.SelectArea = v
end)

local function GetWeapon()
    for _,v in pairs(player.Backpack:GetChildren()) do
        if v:IsA("Tool") and v.ToolTip == _G.SelectWeaponType then
            return v.Name
        end
    end
    for _,v in pairs(player.Character:GetChildren()) do
        if v:IsA("Tool") and v.ToolTip == _G.SelectWeaponType then
            return v.Name
        end
    end
end

-- Auto Level için ayrı thread
task.spawn(function()
    while task.wait() do
        if _G.AutoLevel then
            pcall(function()
                if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end
                
                CheckLevel()
                local questTitle = player.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text
                
                if not string.find(questTitle, NameMon or "") or not player.PlayerGui.Main.Quest.Visible then
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AbandonQuest")
                    toTarget(CFrameQ)
                    
                    if (CFrameQ.Position - player.Character.HumanoidRootPart.Position).Magnitude <= 15 then
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", NameQuest, QuestLv)
                    end
                else
                    for _,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                        if v.Name == Ms and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                            repeat task.wait()
                                if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then break end
                                
                                AutoHaki()
                                EquipWeapon(GetWeapon())
                                toTarget(v.HumanoidRootPart.CFrame * CFrame.new(0, 25, 0))
                                AttackNoCoolDown()
                            until not _G.AutoLevel or v.Humanoid.Health <= 0 or not v.Parent
                            break
                        end
                    end
                end
            end)
        end
    end
end)

-- Auto Boss için ayrı thread
task.spawn(function()
    while task.wait() do
        if _G.AutoBoss then
            pcall(function()
                if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end
                
                CheckBossQuest()
                
                -- Quest kontrolü
                if player.PlayerGui.Main.Quest.Visible and string.find(player.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, NameBoss or "") then
                    -- Boss'u bul ve öldür
                    for _,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                        if v.Name == BossMon and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                            repeat task.wait()
                                if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then break end
                                
                                AutoHaki()
                                EquipWeapon(GetWeapon())
                                toTarget(v.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
                                AttackNoCoolDown()
                            until not _G.AutoBoss or v.Humanoid.Health <= 0 or not v.Parent
                        end
                    end
                else
                    -- Quest al
                    if CFrameQBoss and (CFrameQBoss.Position - player.Character.HumanoidRootPart.Position).Magnitude > 15 then
                        toTarget(CFrameQBoss)
                    elseif CFrameQBoss then
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", NameQuestBoss, QuestLvBoss)
                    end
                end
            end)
        end
    end
end)

-- Auto Material için ayrı thread
task.spawn(function()
    while task.wait() do
        if _G.AutoMaterial then
            pcall(function()
                if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end
                
                MaterialMon()
                
                for _,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                    if v.Name == MMon and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                        repeat task.wait()
                            if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then break end
                            
                            AutoHaki()
                            EquipWeapon(GetWeapon())
                            toTarget(v.HumanoidRootPart.CFrame * CFrame.new(0, 25, 0))
                            AttackNoCoolDown()
                        until not _G.AutoMaterial or v.Humanoid.Health <= 0 or not v.Parent
                        break
                    end
                end
            end)
        end
    end
end)

-- Auto Chest için ayrı thread
task.spawn(function()
    while task.wait(1) do
        if _G.AutoChest then
            pcall(function()
                if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end
                
                local closestChest = nil
                local closestDistance = 5000
                
                -- En yakın chest'i bul
                for _,v in pairs(game:GetService("Workspace"):GetChildren()) do
                    if string.find(v.Name, "Chest") and v:IsA("Model") or v:IsA("Part") then
                        local chestPos = v:FindFirstChild("Position") and v.Position or (v:IsA("Model") and v:GetModelCFrame().Position)
                        if chestPos then
                            local distance = (chestPos - player.Character.HumanoidRootPart.Position).Magnitude
                            if distance < closestDistance then
                                closestDistance = distance
                                closestChest = v
                            end
                        end
                    end
                end
                
                -- En yakın chest'e git
                if closestChest then
                    repeat 
                        task.wait()
                        if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then break end
                        
                        local chestCFrame = closestChest:FindFirstChild("CFrame") or (closestChest:IsA("Model") and closestChest:GetModelCFrame())
                        if chestCFrame then
                            toTarget(chestCFrame)
                        end
                        
                        local currentDist = (closestChest.Position - player.Character.HumanoidRootPart.Position).Magnitude
                    until not _G.AutoChest or not closestChest.Parent or currentDist < 5
                end
            end)
        end
    end
end)

-- Background Anti AFK
player.Idled:connect(function()
    if _G.AntiAFK then
        game:GetService("VirtualUser"):Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
        task.wait(1)
        game:GetService("VirtualUser"):Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
    end
end)

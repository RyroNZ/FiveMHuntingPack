spawnedPlayers = {}
driver = 0
defenders = {}
attackers = {}
timerCountdown = 30
gameStarted = false
local driverspawn = vector3(0,0,0)
local attackerspawn = vector3(0,0,0)
local defenderspawn = vector3(0,0,0)
local driverSpawnRot = 0
local attackerSpawnRot = 0
local defenderSpawnRot = 0
local defaultLocation = 'D:\\FXServer\\server-data\\resources\\HuntingPack\\'
local respawnPoint = vector3(0, 0, 0)
local lifeStart = GetGameTimer()
local startTime = GetGameTimer()
local totalLife = 0
local driverName = ''

function GetSpawnedPlayers()
    return spawnedPlayers
end

RegisterNetEvent("OnPlayerSpawned")
AddEventHandler('OnPlayerSpawned', function()
    print('Added spawned playerIdx to table: ' .. source)
    spawnedPlayers[#spawnedPlayers+1] = source
end)

AddEventHandler('playerDropped', function (reason)
    print('Player ' .. GetPlayerName(source) .. ' dropped (Reason: ' .. reason .. ')')
    droppedIdx = -1
    droppedPlayerId = -1
    for Idx, playerId in ipairs(GetSpawnedPlayers()) do
        if playerId == source then
            droppedIdx = Idx
            droppedPlayerId = playerId
        end
    end
    print('DroppedIdx: '.. droppedIdx .. ' DroppedPlayerId ' .. droppedPlayerId)
    if spawnedPlayers[droppedIdx] ~= nil then
        table.remove(spawnedPlayers, droppedIdx)
    end
  end)


function saveTable( t, filename )
 
    -- Path for the file to write
    local path = defaultLocation .. filename
 
    -- Open the file handle
    local file, errorString = io.open( path, "w" )
 
    if not file then
        -- Error occurred; output the cause
        print( "File error (Save): " .. errorString )
        return false
    else
        -- Write encoded JSON data to file
        file:write( json.encode( t ) )
        -- Close the file handle
        io.close( file )
        return true
    end
end

function loadTable( filename )

    -- Path for the file to read
    local path = defaultLocation .. filename
 
    -- Open the file handle
    local file, errorString = io.open( path, "r" )
 
    if not file then
        -- Error occurred; output the cause
        print( "File error(load): " .. errorString )
        saveTable(
            {
                {rank=1,name='None',points=0,players=0},
                {rank=2,name='None',points=0,players=0},
                {rank=3,name='None',points=0,players=0},
                {rank=4,name='None',points=0,players=0},
                {rank=5,name='None',points=0,players=0},
                {rank=6,name='None',points=0,players=0},
                {rank=7,name='None',points=0,players=0},
                {rank=8,name='None',points=0,players=0},
                {rank=9,name='None',points=0,players=0},
                {rank=10,name='None',points=0,players=0},
        
        }, 'ranks.json')
        return loadTable(filename)
    else
        -- Read data from file
        local contents = file:read( "*a" )
        -- Decode JSON data into Lua table
        local t = json.decode( contents )
        -- Close the file handle
        io.close( file )
        -- Return table
        return t
    end
end

local ranks = loadTable('ranks.json')

local function has_value (tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end

    return false
end

local function count_array(tab)
    count = 0
    for index, value in ipairs(tab) do
        count = count + 1
    end

    return count
end


local function send_global_message(text)
    print('Sending Global Message '.. text)
    for _, playerId in ipairs(GetPlayers()) do
        local name = GetPlayerName(playerId)
        TriggerClientEvent('OnReceivedChatMessage', playerId, text)
    end
end



RegisterNetEvent("OnRequestedStart")
AddEventHandler('OnRequestedStart', function(startPoint)
    print("Received Start Event")
    timeBelowSpeed = 0
    total_players = count_array(GetSpawnedPlayers())
    print(("Selecting Teams (Total Players %i)"):format(total_players))
    gameStarted = true
    exports.vSync:RT()
    exports.vSync:RW()
    respawnPoint = vector3(0,0,0)
    if startPoint == 'airport' then
        driverspawn = vector3(-1532, -2946, 14)
        driverSpawnRot = 330.0
        attackerspawn = vector3(-1730, -3088, 14)
        attackerSpawnRot = 298.0
        defenderspawn = vector3(-1766, -3065, 14)
        defenderSpawnRot = 298.0
        print('Spawning at Airport')
    elseif startPoint == 'airport_north' then
        driverspawn = vector3(1712, 3253, 42)
        driverSpawnRot = 296.0
        attackerspawn = vector3(1360, 3160, 41)
        attackerSpawnRot = 296.0
        defenderspawn = vector3(1384,3093,40)
        defenderSpawnRot = 296.0
        print('Spawning At Airport North')
    elseif startPoint == 'dock' then
        driverspawn = vector3(851, -3168, 7)
        driverSpawnRot = 85.0
        attackerspawn = vector3(1036,-3203, 7)
        attackerSpawnRot = 85.0
        defenderspawn = vector3(1062, -3223, 7)
        defenderSpawnRot = 85.0
        print('Spawning at Dock')
    elseif startPoint == 'beach' then
        driverspawn = vector3(-1742, -831, 9)
        driverSpawnRot = 226.0
        attackerspawn = vector3(-1961,-632, 11)
        attackerSpawnRot = 226.0
        defenderspawn = vector3(-1935, -612, 11)
        defenderSpawnRot = 226.0
        print('Spawning at Beach')
    elseif startPoint == 'north' then
        driverspawn = vector3(2012, 4782, 41)
        driverSpawnRot = 225.0
        attackerspawn = vector3(1944,4717, 41)
        attackerSpawnRot = 294.0
        defenderspawn = vector3(2115, 4802, 40)
        defenderSpawnRot = 102.0
        print('Spawning at North')
    elseif startPoint == 'hollywood' then
        driverspawn = vector3(520, 1331, 288)
        driverSpawnRot = 110.0
        attackerspawn = vector3(850,1283, 360)
        attackerSpawnRot = 300.0
        defenderspawn = vector3(630, 1406, 320)
        defenderSpawnRot = 55.0
        print('Spawning at hollywood')
    elseif startPoint == 'north_hollywood' then
        driverspawn = vector3(882, 2168, 50)
        driverSpawnRot = 347.0
        attackerspawn = vector3(771,2261, 50)
        attackerSpawnRot = 217.0
        defenderspawn = vector3(1052, 2044, 50)
        defenderSpawnRot = 36.0
        print('Spawning at north hollywood')
    elseif startPoint == 'paleto' then
        driverspawn = vector3(-133, 6217, 32)
        driverSpawnRot = 44.0
        attackerspawn = vector3(145,6523, 32)
        attackerSpawnRot = 134.0
        defenderspawn = vector3(-289, 6058, 32)
        defenderSpawnRot = 54.0
        print('Spawning at paleto')
    elseif startPoint == 'dock2' then
        driverspawn = vector3(302, -3164, 6)
        driverSpawnRot = 3.0
        attackerspawn = vector3(266,-2775, 6)
        attackerSpawnRot = 174.0
        defenderspawn = vector3(253, -2662, 20)
        defenderSpawnRot = 186.0
        print('Spawning at dock2')
    end


    -- randomly select the driver
    driverIdx = math.random(1, total_players)
    attackers = {}
    defenders = {}

    -- add the attackers first
    while #attackers < (total_players / 2) + 1 do
        random_attacker = math.random(0, total_players)
        if random_attacker ~= driver then
            attackers[#attackers+1] = random_attacker
        end
    end
    
    -- finally add the defenders as remainders
    for i=1,total_players do
        if not has_value(attackers, i) and driver ~= i then
            print('Adding Defender at Index ' .. i .. 'driver indx ' .. driver)
            defenders[#defenders+1] = i
        end
    end
       
    count = 1
    driverName = ''

    for _, playerId in ipairs(GetSpawnedPlayers()) do
        local name = GetPlayerName(playerId)
        if count == driverIdx then
            driverName = name
            send_global_message(('^1%s was selected as the driver!'):format(name))
            TriggerClientEvent('onHuntingPackStart', playerId, 'driver', driverspawn, driverSpawnRot, driverName)
            maxTimeBelowSpeed = math.clamp(total_players * 3 , 9, 12)
            if total_players == 1 then
                maxTimeBelowSpeed = 90000
            end
            TriggerClientEvent('OnUpdateMinSpeed', playerId, 45, maxTimeBelowSpeed)
            send_global_message('^3' .. total_players ..  ' players in game. Vehicle must be stopped for ' .. maxTimeBelowSpeed .. ' seconds')
        end
        count = count + 1
    end

    count = 1
    for _, playerId in ipairs(GetSpawnedPlayers()) do
        local name = GetPlayerName(playerId)
        if count ~= driverIdx then
            if has_value(attackers, count) then
                TriggerClientEvent('onHuntingPackStart', playerId, 'attacker',  attackerspawn + vector3(math.random(-10, 10),math.random(-10,10),0), attackerSpawnRot, driverName)
            elseif has_value(defenders, count) then
                TriggerClientEvent('onHuntingPackStart', playerId, 'defender',  defenderspawn + vector3(math.random(-10, 10),math.random(-10,10),0), defenderSpawnRot, driverName)
            end
        end
        count = count + 1
    end
    print("Finished Selecting Teams!... Preparing spawning")
end)

RegisterNetEvent("OnNotifyBelowSpeed")
AddEventHandler('OnNotifyBelowSpeed', function(name)
    isBelowSpeed = true
    --send_global_message(name .. " has dropped below the speed!")
end)

RegisterNetEvent("OnNotifyAboveSpeed")
AddEventHandler('OnNotifyAboveSpeed', function(name, timeBelowSpeed)
    isBelowSpeed = false 
    timeRemaining = maxTimeBelowSpeed - timeBelowSpeed
    send_global_message("^2" .. name .. " has has gone above the speed! .. " .. timeRemaining  .. ' seconds remaining!')
end)

RegisterNetEvent("OnNewRespawnPoint")
AddEventHandler('OnNewRespawnPoint', function(newRespawnLocation)
    respawnPoint = newRespawnLocation
    print('Received new spawn location ' .. respawnPoint)
end)

RegisterNetEvent("OnUpdateLifeTimers")
AddEventHandler('OnUpdateLifeTimers', function(newTotalLife)
    totalLife = newTotalLife
    TriggerClientEvent('OnUpdateLifeTimers', -1,totalLife)
end)


RegisterNetEvent("OnRequestJoinInProgress")
AddEventHandler('OnRequestJoinInProgress', function(playerId)
   if gameStarted and playerId ~= -1 then
        print('Starting '.. GetPlayerName(playerId) .. ' in progress')
        if respawnPoint ~= vector3(0,0,0) then 
            TriggerClientEvent('onHuntingPackStart', playerId, 'attacker',  respawnPoint + vector3(math.random(-10, 10),math.random(-10,10),0), attackerSpawnRot, driverName)
        else
            TriggerClientEvent('onHuntingPackStart', playerId, 'attacker',  attackerspawn + vector3(math.random(-10, 10),math.random(-10,10),0), attackerSpawnRot, driverName)
        end
    end
end)

function deepcopy(orig, copies)
    copies = copies or {}
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        if copies[orig] then
            copy = copies[orig]
        else
            copy = {}
            copies[orig] = copy
            for orig_key, orig_value in next, orig, nil do
                copy[deepcopy(orig_key, copies)] = deepcopy(orig_value, copies)
            end
            setmetatable(copy, deepcopy(getmetatable(orig), copies))
        end
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

RegisterNetEvent('OnNotifyBlownUp')
AddEventHandler('OnNotifyBlownUp', function(Name, LifeTime)
    send_global_message('Driver has blown up! Total Life: ' .. LifeTime .. ' Seconds')
    gameStarted = false
    timerCountdown = 10
    newhighScoreIdx = -1
    oldRanks = deepcopy(ranks)
    total_players = count_array(GetSpawnedPlayers())
    for i,player in pairs(ranks) do
        if LifeTime * (total_players * 1.68 -1)  > player.points * (player.players * 1.68 - 1) then
            ranks[i].points = LifeTime
            ranks[i].name = Name
            ranks[i].players = total_players
            newhighScoreIdx = i
            send_global_message(Name .. ' just received a new high score! Rank: ' .. ranks[i].rank .. ' Life: ' .. LifeTime)
            break
        end
    end    
    for i,player in pairs(ranks) do
        if i > newhighScoreIdx and newhighScoreIdx ~= -1 then
            if oldRanks[i-1].points ~= 0  then
                ranks[i].points = oldRanks[i-1].points
                ranks[i].name = oldRanks[i-1].name
                ranks[i].players = oldRanks[i-1].players
            end
        end
    end   

    saveTable(ranks, 'ranks.json')

    for _, playerId in ipairs(GetSpawnedPlayers()) do
        TriggerClientEvent('OnGameEnded', playerId)
    end

end)

local function save_score(name, score)
    file = io.open('scores.txt')
end


Citizen.CreateThread(function()
    while true do
        total_players = count_array(GetSpawnedPlayers())
        if total_players >= 2 and not gameStarted then
            if timerCountdown > 10 then
                timerCountdown = timerCountdown - 5
            else
                timerCountdown = timerCountdown - 1
            end
            send_global_message('^1'.. timerCountdown .. " seconds until game starts!")
            if timerCountdown < 0 then
                gameStarted = true
                startPoints = {'airport_north', 'dock', 'beach', 'north', 'north_hollywood', 'paleto'}
                selectedRandomPoint = math.random(1, #startPoints)
                TriggerEvent('OnRequestedStart', startPoints[selectedRandomPoint])
            end
        end
        if timerCountdown > 10 then
            Citizen.Wait(5000)
        else
            Citizen.Wait(1000)
        end
    end    
    
end)

Citizen.CreateThread(function()
    while true do
       Citizen.Wait(1000)
       for _, playerId in ipairs(GetSpawnedPlayers()) do
            TriggerClientEvent('OnClearRanks', playerId)
            for _,player in pairs(ranks) do
                TriggerClientEvent('OnUpdateRanks', playerId, player.name, player.points, player.players)
            end     
       end
    end    
    
end)
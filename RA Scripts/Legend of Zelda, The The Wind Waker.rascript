// Legend of Zelda, The: The Wind Waker
// #ID = 9190

// UTILITY
function Delta(addr) => prev(addr)

function Debug(text)
{
    achievement(title = text + "", description = "", points = 0, trigger = always_false())
}

function WasBitflagJustSetInGame(bit)
{
    return IsValueSet(bit, 0, 1)
        && FileIsLoaded()
}

function IsBitflagSetInGame(bit)
{
    return IsValueSetInGame(bit, 0, 1)
}

function WasValueJustSetInGame(mem, oldValue, newValue)
{
    return IsValueSet(mem, oldValue, newValue) && FileIsLoaded()
}

function WasValueSetInGame(mem, oldValue, newValue)
{
    return once(WasValueJustSetInGame(mem, oldValue, newValue))
}

function IsValueSetInGame(mem, oldValue, newValue)
{
    return IsValueSet(mem, oldValue, newValue)
        && FileIsLoaded()
}

function WasValueSet(mem, oldValue, newValue)
{
    return once(IsValueSet(mem, oldValue, newValue))
}

function WasBitflagSet(mem)
{
    return WasValueSet(mem, 0, 1)
}

function WasBitflagSetInGame(mem)
{
    return once(IsBitflagSetInGame(mem) && FileIsLoaded())
}

function IsValueSet(mem, oldValue, newValue)
{
    return Delta(mem) == oldValue && mem == newValue
}

function DictionaryKeyExists(dict, key)
{
    for i in dict
    {
        if (i == key)
        {
            return true
        }
    }
    
    return false
}

// Dictionary elements must have "addr" and "bit" fields.
// Returns a result like the following:
// {
//    <address>: [ <bit indices> ]
// }
function AggregateBitsFromAddressBits(dict)
{
    ret = {}
    for i in dict
    {
        element = dict[i]
        
        if (element["addr"] != -1)
        {
            if (DictionaryKeyExists(ret, element["addr"]) == true)
            {
                arr = ret[element["addr"]]
                array_push(arr, element["bit"])
                ret[element["addr"]] = arr
            }
            else
            {
                ret[element["addr"]] = [ element["bit"] ]
            }
        }
    }
    
    return ret
}

// BEGINNING OF BITFLAG AGGREGATION REGION

// Converts an aggregate dictionary to an array of objects like the following:
// {
//    "type": "bitX"/"byte"
//    "mem": <memory accessor>
//    "address": <memory address>
// }
function ConvertBitAggregatesToBitCountableMemoryAccessors(aggregates)
{
    accessors = []
    for address in aggregates
    {
        agg = aggregates[address]
        if (length(agg) == 8)
        {
            array_push(accessors, { "type": "byte", "mem": byte(address), "address": address })
        }
        else
        {
            // Simply return each bit instead, since we can't use bitcount() on anything but bytes.
            for bit in agg
            {
                if (bit != -1 && address != -1)
                {
                    array_push(accessors, { "type": "bit", "mem": bit(bit, address), "address": address })
                }
            }
        }
    }
    
    return accessors
}

function GetCountableAccessorArrayFromAddressBits(dict)
{
    return ConvertBitAggregatesToBitCountableMemoryAccessors(AggregateBitsFromAddressBits(dict))
}

function GenerateBitcountFromCountableObjects(addresses)
{
    finalBitcount = 0
    for address in addresses
    {
        if (address["type"] == "byte")
        {
            finalBitcount = finalBitcount + bitcount(address["address"])
        }
        else
        {
            finalBitcount = finalBitcount + address["mem"]
        }
    }
    return finalBitcount
}

function GenerateBitcountFromAddressBits(dict)
{
    GenerateBitcountFromCountableObjects(GetCountableAccessorArrayFromAddressBits(dict))
}

// END OF BITFLAG AGGREGATION REGION

// This function allows the creation of achievements with built-in save protection that deal with a collection of values being set
// throughout the game. The schemas for both parameters are as follows:
//
// name: title
// description: self-explanatory
// points: self-explanatory
// addresses: a list of address accessors that need to have their bits summed (each address must have an "addr" and "bit" value in order to be properly aggregated)
// threshold: how many values in the "conditions" dictionary must be set before this achievement is triggered; uses the number of addresses if left at 0
//
// conditions: "countsWhen": the condition that must be true in order for it to be counted in the total
//             "recalculateWhen": the condition that indicates that relevant values in the condition have changed,
//                                and so everything must be recalculated
//
// onlyAvailableWhen: A condition that must be true in all conditions for the achievement to trigger.
// id: self-explanatory
// badge: self-explanatory
// type: self-explanatory
function GenerateCheevoFromConditions(name, description, points, conditions, threshold = 0, onlyAvailableWhen = always_true(), id = 0, badge = "00000", type = "",
    oneAtATime = false)
{
    loadedCounts = []
    totalCounts = []
    resetAlt = always_false()
    
    if (threshold == 0)
    {
        threshold = length(conditions)
    }

    for i in conditions
    {
        condition = conditions[i]

        // This is the score when the game is loaded. If the loaded score is greater than or equal to the threshold--that is,
        // if the save file would satisfy enough conditions to trigger the achievement on load--this should trigger a
        // permanant pauselock to serve as save protection.
        array_push(loadedCounts, once(condition["countsWhen"] && IsLoadingSaveFile()))

        // We want both loaded and session counts here (that is, we don't care if we're loading a save file when these are tallied).
        // This way, loading a save doesn't invalidate the achievement outright if a player hasn't actually earned it yet.
        array_push(totalCounts, once(condition["countsWhen"]))

        resetAlt = resetAlt || condition["recalculateWhen"]
    }

    achievement(title = name, description = description, points = points, badge = badge, id = id, type = type,
        trigger = FileIsLoaded()
            && measured(tally(threshold, totalCounts)) && unless(tally(threshold, loadedCounts))
            && never(resetAlt) && onlyAvailableWhen && (always_false() || never(IsOnTitleScreen()))
    )
}

// This function allows the creation of achievements with built-in save protection that deal with a collection of values being set
// throughout the game. The schemas for both parameters are as follows:
//
// name: title
// description: self-explanatory
// points: self-explanatory
// addresses: a list of address accessors that need to have their bits summed (each address must have an "addr" and "bit" value in order to be properly aggregated)
// threshold: how many values in the "conditions" dictionary must be set before this achievement is triggered; uses the number of addresses if left at 0
// resetWhen: a condition that, when true, will reset the entire achievement, including pauselocks
// onlyAvailableWhen: a condition that must be true in all conditions for the achievement to trigger
// id: self-explanatory
// badge: self-explanatory
// type: self-explanatory
// oneAtATime: indicates that bits will only ever get flipped one at a time, meaning the achievement will check one below the threshold before triggering
function GenerateCheevoFromBits(name, description, points, addresses, threshold = 0, onlyAvailableWhen = always_true(), resetWhen = always_false(), id = 0, badge = "00000", type = "",
    oneAtATime = false, measuredIf = always_true())
{
    shouldTriggerPauselock = always_false()
    bitcounts = GenerateBitcountFromCountableObjects(GetCountableAccessorArrayFromAddressBits(addresses))
    
    if (threshold == 0)
    {
        threshold = length(addresses)
    }
    
    // We want both loaded and session counts here (that is, we don't care if we're loading a save file when these are tallied).
    // This way, loading a save doesn't invalidate the achievement outright if a player hasn't actually earned it yet.
    if (oneAtATime)
    {
        trigger = measured(bitcounts >= threshold, measuredIf) && Delta(bitcounts) == threshold - 1
    }
    else
    {
        // This is the score when the game is loaded. If the loaded score is greater than or equal to the threshold--that is,
        // if the save file would satisfy enough conditions to trigger the achievement on load--this should trigger a
        // permanant pauselock to serve as save protection.
        shouldTriggerPauselock = once(bitcounts >= threshold && IsOnTitleScreen())
        trigger = measured(bitcounts >= threshold, measuredIf)
    }    

    achievement(title = name, description = description, points = points, badge = badge, id = id, type = type,
        trigger = FileIsLoaded() && trigger && unless(shouldTriggerPauselock) && onlyAvailableWhen
            && (resetWhen || never(IsOnTitleScreen())) // Reset any potential pauselock when exiting to the title screen.
    )
}

function HasKey(dict, key)
{
    for i in dict
    {
        if (i == key)
        {
            return true
        }
    }
    
    return false
}

// This function allows the creation of achievements with built-in save protection that deal with a collection of values being set
// throughout the game. This function is intended only for scenarios where bits are both set statically and loaded into a buffer when entering a specific area.
// As such, to properly capture each bit flip scenario, this is an O(N^2) operation.
//
// name: title
// description: self-explanatory
// points: self-explanatory
// addresses: a list of address pairs that need to have their bits summed (each pair must each have an "addr" and "bit" value, and they must be named "static" and "buffer", respectively)
// threshold: how many values in the "conditions" dictionary must be set before this achievement is triggered; uses the number of addresses if left at 0
// onlyAvailableWhen: a condition that must be true in all conditions for the achievement to trigger
// id: self-explanatory
// badge: self-explanatory
// type: self-explanatory
// measure: Whether or not the Measured flag should be used
// measuredIf: self-explanatory
function GenerateCheevoFromBufferBits(name, description, points, addresses, threshold = 0, onlyAvailableWhen = always_true(), id = 0, badge = "00000", type = "", measure = true)
{
    trigger = always_false()
    measureTrigger = always_true()
    stageGroups = {}
    allStages = {}
    staticSumForAllStages = 0
    
    if (threshold == 0)
    {
        threshold = length(addresses)
    }
    
    for i in addresses
    {
        stage = addresses[i]["buffer"]["stage"]
        stageGroups[stage] = []
        allStages[stage] = 0
    }
    
    // Go through every buffer bit and put them in the correct entry in the dictionary.
    for i in addresses
    {
        addr = addresses[i]
        stage = addr["buffer"]["stage"]
        arr = stageGroups[stage]
        array_push(arr, addr)
    }
    
    // A stage group consists of all address pairs that are dynamic within a specific stage ID. Achievements of this type will only ever trigger when Link is in a room using the same stage ID.
    // Therefore, the actual trigger alts must contain all dynamic bits in the current stage and the STATIC bits for all other stages.
    for i in stageGroups
    {
        bufferSumForThisStage = sum_of(stageGroups[i], x => bit(x["buffer"]["bit"], x["buffer"]["addr"]))
        staticSumForAllStages = staticSumForAllStages + sum_of(stageGroups[i], x => bit(x["static"]["bit"], x["static"]["addr"]))
        staticSumForOtherStages = 0
        
        for j in stageGroups
        {
            if (i != j)
            {
                staticSumForOtherStages = staticSumForOtherStages + sum_of(stageGroups[j], x => bit(x["static"]["bit"], x["static"]["addr"]))
            }
        }
        
        trigger = trigger || measured(bufferSumForThisStage + staticSumForOtherStages == threshold, stageId() == i)
            && Delta(bufferSumForThisStage + staticSumForOtherStages) == threshold - 1 // This delta check is simply for save protection.
    }
    
    // The final alt should just be a measurement for when we're in an area with a stage ID that no dynamic bits are relevant to.
    currentStageIsIrrelevant = always_true()
    for stage in allStages
    {
        currentStageIsIrrelevant = currentStageIsIrrelevant && stageId() != stage
    }
    
    trigger = trigger || measured(staticSumForAllStages == threshold, currentStageIsIrrelevant)
        && Delta(staticSumForAllStages) == threshold - 1 // This delta check is simply for save protection.

    achievement(title = name, description = description, points = points, badge = badge, id = id, type = type,
        trigger = FileIsLoaded() && onlyAvailableWhen && never(IsOnTitleScreen()) && trigger
    )
}
// /utility

superareas = {
    2: { "id":2, "internalName":"sea", "displayName":"The Great Sea", "addrOverride": 0x00ab78c9, "stageId": 0 },3: { "id":3, "internalName":"majroom", "displayName":"Forsaken Fortress", "addrOverride": 0, "stageId": 2 },4: { "id":4, "internalName":"M_NewD2", "displayName":"Dragon Roost Cavern", "addrOverride": 0, "stageId": 3 },5: { "id":5, "internalName":"kindan", "displayName":"Forbidden Woods", "addrOverride": 0, "stageId": 4 },6: { "id":6, "internalName":"Siren", "displayName":"Tower of the Gods", "addrOverride": 0, "stageId": 5 },7: { "id":7, "internalName":"ma2room", "displayName":"Forsaken Fortress", "addrOverride": 0, "stageId": 2 },8: { "id":8, "internalName":"M_Dai", "displayName":"Earth Temple", "addrOverride": 0, "stageId": 6 },9: { "id":9, "internalName":"kaze", "displayName":"Wind Temple", "addrOverride": 0, "stageId": 7 },10: { "id":10, "internalName":"GanonA", "displayName":"Ganon's Tower", "addrOverride": 0, "stageId": 8 },
}

areas = {
859204975: { "name": "Forest of Fairies", "internalName": "A_mori", "roomId": 0, "key": "", "isStatic": 1, "onLoad": 0 },660955507: { "name": "Title Screen", "internalName": "sea_T", "roomId": 44, "key": "", "isStatic": 1, "onLoad": 0 },1315007817: { "name": "File Select", "internalName": "Name", "roomId": 44, "key": "", "isStatic": 1, "onLoad": 0 },1315007845: { "name": "File Select", "internalName": "Name", "roomId": 0, "key": "", "isStatic": 1, "onLoad": 0 },1936023852: { "name": "Outset Island", "internalName": "sea", "roomId": 44, "key": "", "isStatic": 0, "onLoad": 0 },974743663: { "name": "Orca and Sturgeon's House (1F)", "internalName": "Ojhous", "roomId": 0, "key": "", "isStatic": 1, "onLoad": 0 },974740078: { "name": "Orca and Sturgeon's House (2F)", "internalName": "Ojhous2", "roomId": 1, "key": "", "isStatic": 1, "onLoad": 0 },771907955: { "name": "Mesa's House", "internalName": "Omasao", "roomId": 0, "key": "", "isStatic": 1, "onLoad": 0 },974786146: { "name": "Abe and Rose's House", "internalName": "Onobuta", "roomId": 0, "key": "", "isStatic": 1, "onLoad": 0 },505704043: { "name": "Link's House", "internalName": "LinkRM", "roomId": 0, "key": "", "isStatic": 1, "onLoad": 0 },538080106: { "name": "Beedle's Shop Ship", "internalName": "Obshop", "roomId": 2, "key": "", "isStatic": 1, "onLoad": 0 },674500461: { "name": "Tetra's Ship, On Deck", "internalName": "A_umikz", "roomId": 0, "key": "", "isStatic": 1, "onLoad": 0 },779317099: { "name": "Tetra's Ship, Below Deck", "internalName": "Asoko", "roomId": 0, "key": "", "isStatic": 1, "onLoad": 0 },941910649: { "name": "Forsaken Fortress", "internalName": "MajyuE", "roomId": 0, "key": "ForsakenFortressBailey", "isStatic": 1, "onLoad": 0 },34473840: { "name": "Gallery", "internalName": "majroom", "roomId": 2, "key": "ForsakenFortressGallery", "isStatic": 1, "onLoad": 0 },34473842: { "name": "Prison", "internalName": "majroom", "roomId": 0, "key": "ForsakenFortressPrison", "isStatic": 1, "onLoad": 0 },34473846: { "name": "Barracks", "internalName": "majroom", "roomId": 4, "key": "ForsakenFortressBarracks", "isStatic": 1, "onLoad": 0 },34473841: { "name": "Docks", "internalName": "majroom", "roomId": 3, "key": "ForsakenFortressDocks", "isStatic": 1, "onLoad": 0 },34473843: { "name": "Dining Area", "internalName": "majroom", "roomId": 1, "key": "ForsakenFortressDining", "isStatic": 1, "onLoad": 0 },974063215: { "name": "Forsaken Fortress: Tower", "internalName": "Mjtower", "roomId": 0, "key": "ForsakenFortressTower", "isStatic": 1, "onLoad": 0 },1936023819: { "name": "Windfall Island", "internalName": "sea", "roomId": 11, "key": "", "isStatic": 0, "onLoad": 0 },588018279: { "name": "Chu Jelly Juice Shop", "internalName": "Pdrgsh", "roomId": 0, "key": "", "isStatic": 1, "onLoad": 0 },656042339: { "name": "House of Wealth", "internalName": "Orichh", "roomId": 0, "key": "", "isStatic": 1, "onLoad": 0 },1332770146: { "name": "Cafe", "internalName": "Opub", "roomId": 0, "key": "", "isStatic": 1, "onLoad": 0 },1023569253: { "name": "Lenzo's Studio", "internalName": "Ocmera", "roomId": 0, "key": "", "isStatic": 1, "onLoad": 0 },923140457: { "name": "Mrs. Marie's School of Joy", "internalName": "Nitiyou", "roomId": 0, "key": "", "isStatic": 1, "onLoad": 0 },772761971: { "name": "Game Room", "internalName": "Kaisen", "roomId": 0, "key": "", "isStatic": 1, "onLoad": 0 },620956794: { "name": "Windfall Island Jail", "internalName": "Pnezumi", "roomId": 0, "key": "", "isStatic": 1, "onLoad": 0 },755658605: { "name": "Bomb Shop", "internalName": "Obombh", "roomId": 0, "key": "", "isStatic": 1, "onLoad": 0 },672007282: { "name": "Mail Center", "internalName": "Atorizk", "roomId": 0, "key": "", "isStatic": 1, "onLoad": 0 },738526318: { "name": "Dragon Roost Cavern Entrance", "internalName": "Adanmae", "roomId": 0, "key": "", "isStatic": 1, "onLoad": 0 },974879845: { "name": "1F", "internalName": "M_NewD2", "roomId": 0, "key": "CavernEntrance", "isStatic": 1, "onLoad": 0 },1936023820: { "name": "Pawprint Isle", "internalName": "sea", "roomId": 12, "key": "", "isStatic": 0, "onLoad": 0 },1936023821: { "name": "Dragon Roost Island", "internalName": "sea", "roomId": 13, "key": "", "isStatic": 0, "onLoad": 0 },538080104: { "name": "Beedle's Shop Ship", "internalName": "Obshop", "roomId": 0, "key": "", "isStatic": 1, "onLoad": 0 },974879847: { "name": "Main", "internalName": "M_NewD2", "roomId": 2, "key": "CavernMain", "isStatic": 1, "onLoad": 0 },974879848: { "name": "1F", "internalName": "M_NewD2", "roomId": 13, "key": "CavernPots", "isStatic": 1, "onLoad": 0 },974879844: { "name": "1F", "internalName": "M_NewD2", "roomId": 1, "key": "CavernBarricades", "isStatic": 1, "onLoad": 0 },974879854: { "name": "1F", "internalName": "M_NewD2", "roomId": 11, "key": "CavernSwingBarricades", "isStatic": 1, "onLoad": 0 },974879846: { "name": "Outside", "internalName": "M_NewD2", "roomId": 3, "key": "CavernOutside", "isStatic": 1, "onLoad": 0 },974879851: { "name": "Block Climb", "internalName": "M_NewD2", "roomId": 14, "key": "CavernBlockClimb", "isStatic": 1, "onLoad": 0 },974879841: { "name": "2F", "internalName": "M_NewD2", "roomId": 4, "key": "CavernDark", "isStatic": 1, "onLoad": 0 },974879843: { "name": "2F", "internalName": "M_NewD2", "roomId": 6, "key": "CavernTreasureChart", "isStatic": 1, "onLoad": 0 },974879853: { "name": "Geyser", "internalName": "M_NewD2", "roomId": 8, "key": "CavernGeyser", "isStatic": 1, "onLoad": 0 },974879855: { "name": "3F", "internalName": "M_NewD2", "roomId": 10, "key": "CavernBossDoor", "isStatic": 1, "onLoad": 0 },745504123: { "name": "Dragon Roost Cavern: 4F", "internalName": "M_Dra09", "roomId": 9, "key": "", "isStatic": 1, "onLoad": 0 },974879842: { "name": "3F", "internalName": "M_NewD2", "roomId": 7, "key": "CavernBridge", "isStatic": 1, "onLoad": 0 },974879850: { "name": "1F", "internalName": "M_NewD2", "roomId": 15, "key": "CavernTingleStatue", "isStatic": 1, "onLoad": 0 },974879849: { "name": "1F", "internalName": "M_NewD2", "roomId": 12, "key": "CavernFireChest", "isStatic": 1, "onLoad": 0 },741869170: { "name": "Dragon Roost Cavern: 3F", "internalName": "M_DragB", "roomId": 0, "key": "CavernBoss", "isStatic": 1, "onLoad": 0 },1936023808: { "name": "Dragon Roost Island", "internalName": "sea", "roomId": 0, "key": "DragonRoostIslandCutscene", "isStatic": 0, "onLoad": 0 },1648779056: { "name": "Dragon Roost Island Grotto", "internalName": "TF_06", "roomId": 0, "key": "", "isStatic": 1, "onLoad": 0 },1936023828: { "name": "Fire Mountain", "internalName": "sea", "roomId": 20, "key": "", "isStatic": 0, "onLoad": 0 },1936023835: { "name": "Eastern Triangle Island", "internalName": "sea", "roomId": 27, "key": "", "isStatic": 0, "onLoad": 0 },1936023842: { "name": "Bomb Island", "internalName": "sea", "roomId": 34, "key": "", "isStatic": 0, "onLoad": 0 },672297832: { "name": "Inside a submarine...", "internalName": "Abship", "roomId": 0, "key": "", "isStatic": 1, "onLoad": 0 },1936023849: { "name": "Forest Haven", "internalName": "sea", "roomId": 41, "key": "", "isStatic": 0, "onLoad": 0 },644706162: { "name": "Inside the Forest Haven", "internalName": "Omori", "roomId": 0, "key": "", "isStatic": 1, "onLoad": 0 },168259172: { "name": "1F", "internalName": "kindan", "roomId": 0, "key": "FWEntrance", "isStatic": 1, "onLoad": 0 },168259173: { "name": "Main", "internalName": "kindan", "roomId": 1, "key": "FWMain", "isStatic": 1, "onLoad": 0 },168259174: { "name": "2F", "internalName": "kindan", "roomId": 2, "key": "FW2F1", "isStatic": 1, "onLoad": 0 },168259175: { "name": "Gondola", "internalName": "kindan", "roomId": 3, "key": "FWGondola", "isStatic": 1, "onLoad": 0 },168259168: { "name": "3F", "internalName": "kindan", "roomId": 4, "key": "FWVineNut", "isStatic": 1, "onLoad": 0 },168259169: { "name": "Korok House", "internalName": "kindan", "roomId": 5, "key": "FWHouse", "isStatic": 1, "onLoad": 0 },168259170: { "name": "3F", "internalName": "kindan", "roomId": 6, "key": "FWHouseLeftCorridor", "isStatic": 1, "onLoad": 0 },168259171: { "name": "3F", "internalName": "kindan", "roomId": 7, "key": "FWVineMaze", "isStatic": 1, "onLoad": 0 },168259180: { "name": "House North Corridor", "internalName": "kindan", "roomId": 8, "key": "FWHouseNorthCorridor", "isStatic": 1, "onLoad": 0 },168259181: { "name": "Treetops", "internalName": "kindan", "roomId": 9, "key": "FWTreetop", "isStatic": 1, "onLoad": 0 },694775367: { "name": "Forbidden Woods: 4F", "internalName": "kinMB", "roomId": 10, "key": "FWMiniboss", "isStatic": 1, "onLoad": 0 },168259183: { "name": "B1", "internalName": "kindan", "roomId": 11, "key": "FWBasementFork", "isStatic": 1, "onLoad": 0 },168259176: { "name": "B1", "internalName": "kindan", "roomId": 12, "key": "FWRiver", "isStatic": 1, "onLoad": 0 },168259177: { "name": "B1", "internalName": "kindan", "roomId": 13, "key": "FWFiveTargets", "isStatic": 1, "onLoad": 0 },168259179: { "name": "2F", "internalName": "kindan", "roomId": 15, "key": "FWCorridorToBoss", "isStatic": 1, "onLoad": 0 },168259188: { "name": "2F", "internalName": "kindan", "roomId": 16, "key": "FWBossEntrance", "isStatic": 1, "onLoad": 0 },607796546: { "name": "Forbidden Woods: 2F", "internalName": "kinBOSS", "roomId": 0, "key": "FWBoss", "isStatic": 1, "onLoad": 0 },622070887: { "name": "Nintendo Gallery", "internalName": "Pfigure", "roomId": 0, "key": "", "isStatic": 1, "onLoad": 0 },1936023841: { "name": "Private Oasis", "internalName": "sea", "roomId": 33, "key": "", "isStatic": 0, "onLoad": 0 },1936023833: { "name": "Six-Eye Reef", "internalName": "sea", "roomId": 25, "key": "", "isStatic": 0, "onLoad": 0 },1936023826: { "name": "Northern Triangle Isle", "internalName": "sea", "roomId": 18, "key": "", "isStatic": 0, "onLoad": 0 },1936023811: { "name": "Northern Fairy Island", "internalName": "sea", "roomId": 3, "key": "", "isStatic": 0, "onLoad": 0 },672297836: { "name": "Inside a submarine...", "internalName": "Abship", "roomId": 4, "key": "Northern Fairy Island Submarine", "isStatic": 1, "onLoad": 0 },1062295666: { "name": "Northern Fairy Island Great Fairy Fountain", "internalName": "Fairy01", "roomId": 0, "key": "Northern Fairy Island Fountain", "isStatic": 1, "onLoad": 0 },1936023825: { "name": "Tingle Island", "internalName": "sea", "roomId": 17, "key": "", "isStatic": 0, "onLoad": 0 },1936023831: { "name": "Greatfish Isle", "internalName": "sea", "roomId": 23, "key": "", "isStatic": 0, "onLoad": 0 },1936023832: { "name": "Cyclops Reef", "internalName": "sea", "roomId": 24, "key": "", "isStatic": 0, "onLoad": 0 },1936023839: { "name": "Stone Watcher Island", "internalName": "sea", "roomId": 31, "key": "", "isStatic": 0, "onLoad": 0 },1936023846: { "name": "Shark Island", "internalName": "sea", "roomId": 38, "key": "", "isStatic": 0, "onLoad": 0 },1936023838: { "name": "Islet of Steel", "internalName": "sea", "roomId": 30, "key": "", "isStatic": 0, "onLoad": 0 },1936023824: { "name": "Rock Spire Isle", "internalName": "sea", "roomId": 16, "key": "", "isStatic": 0, "onLoad": 0 },1936023817: { "name": "Mother & Child Isles", "internalName": "sea", "roomId": 9, "key": "", "isStatic": 0, "onLoad": 0 },1936023818: { "name": "Spectacle Island", "internalName": "sea", "roomId": 10, "key": "", "isStatic": 0, "onLoad": 0 },538080107: { "name": "Beedle's Shop Ship", "internalName": "Obshop", "roomId": 3, "key": "", "isStatic": 1, "onLoad": 0 },1936023840: { "name": "Southern Triangle Island", "internalName": "sea", "roomId": 32, "key": "", "isStatic": 0, "onLoad": 0 },1936023847: { "name": "Southern Fairy Island", "internalName": "sea", "roomId": 39, "key": "", "isStatic": 0, "onLoad": 0 },1936023854: { "name": "Two-Eyed Reef", "internalName": "sea", "roomId": 46, "key": "", "isStatic": 0, "onLoad": 0 },1936023853: { "name": "Headstone Island", "internalName": "sea", "roomId": 45, "key": "", "isStatic": 0, "onLoad": 0 },1062296946: { "name": "Outset Island Great Fairy Fountain", "internalName": "Fairy04", "roomId": 0, "key": "", "isStatic": 1, "onLoad": 0 },872748150: { "name": "Inside Jabun's hideout...", "internalName": "Pjavdou", "roomId": 0, "key": "", "isStatic": 1, "onLoad": 0 },1062297458: { "name": "Southern Fairy Island Great Fairy Fountain", "internalName": "Fairy06", "roomId": 0, "key": "", "isStatic": 1, "onLoad": 0 },1936023827: { "name": "Eastern Fairy Island", "internalName": "sea", "roomId": 19, "key": "", "isStatic": 0, "onLoad": 0 },1062296434: { "name": "Eastern Fairy Island Great Fairy Fountain", "internalName": "Fairy02", "roomId": 0, "key": "", "isStatic": 1, "onLoad": 0 },1936023834: { "name": "Tower of the Gods", "internalName": "sea", "roomId": 26, "key": "", "isStatic": 0, "onLoad": 0 },741166453: { "name": "The Great Sea: Tower of the Gods", "internalName": "ADMumi", "roomId": 0, "key": "TotGCutscene", "isStatic": 1, "onLoad": 0 },1030320741: { "name": "1F", "internalName": "Siren", "roomId": 0, "key": "TotG1FMain", "isStatic": 1, "onLoad": 0 },1030320736: { "name": "1F ", "internalName": "Siren", "roomId": 5, "key": "TotG1FSmallKey", "isStatic": 1, "onLoad": 0 },1030320742: { "name": "1F", "internalName": "Siren", "roomId": 3, "key": "TotG1FBombableWalls", "isStatic": 1, "onLoad": 0 },1030320737: { "name": "1F", "internalName": "Siren", "roomId": 4, "key": "TotG1FRainbowBridge", "isStatic": 1, "onLoad": 0 },1030320740: { "name": "1F", "internalName": "Siren", "roomId": 1, "key": "TotG1FCompass", "isStatic": 1, "onLoad": 0 },1030320743: { "name": "1F", "internalName": "Siren", "roomId": 2, "key": "TotG1FRainbowStairs", "isStatic": 1, "onLoad": 0 },1030320739: { "name": "Elevator", "internalName": "Siren", "roomId": 6, "key": "TotG1F2FElevator", "isStatic": 1, "onLoad": 0 },1030320738: { "name": "2F", "internalName": "Siren", "roomId": 7, "key": "TotG2FMain", "isStatic": 1, "onLoad": 0 },1030320750: { "name": "2F", "internalName": "Siren", "roomId": 11, "key": "TotG2FRightCorridor", "isStatic": 1, "onLoad": 0 },1030320744: { "name": "2F", "internalName": "Siren", "roomId": 13, "key": "TotG2FCallRainbowPlatform", "isStatic": 1, "onLoad": 0 },1030320747: { "name": "2F", "internalName": "Siren", "roomId": 14, "key": "TotG2FLeftCorridor", "isStatic": 1, "onLoad": 0 },1030320757: { "name": "2F", "internalName": "Siren", "roomId": 16, "key": "TotG2FCommandRainbowBridge", "isStatic": 1, "onLoad": 0 },1030320754: { "name": "2F", "internalName": "Siren", "roomId": 23, "key": "TotG2FMiniboss", "isStatic": 1, "onLoad": 0 },1030320749: { "name": "2F", "internalName": "Siren", "roomId": 8, "key": "TotG2FMiddleCorridor", "isStatic": 1, "onLoad": 0 },1030320752: { "name": "2F", "internalName": "Siren", "roomId": 21, "key": "TotG2FGiantArmos", "isStatic": 1, "onLoad": 0 },1030320748: { "name": "2F", "internalName": "Siren", "roomId": 9, "key": "TotG2FBubblePlatforms", "isStatic": 1, "onLoad": 0 },1030320751: { "name": "2F", "internalName": "Siren", "roomId": 10, "key": "TotG2FLaserGate", "isStatic": 1, "onLoad": 0 },1030320755: { "name": "2F", "internalName": "Siren", "roomId": 22, "key": "TotG2FGiantArmos2", "isStatic": 1, "onLoad": 0 },1030320756: { "name": "3F", "internalName": "Siren", "roomId": 17, "key": "TotG3FWarp", "isStatic": 1, "onLoad": 0 },1030320759: { "name": "Staircase", "internalName": "Siren", "roomId": 18, "key": "TotGStaircase", "isStatic": 1, "onLoad": 0 },1026257509: { "name": "Tower of the Gods: 4F", "internalName": "SirenB", "roomId": 0, "key": "TotGBoss", "isStatic": 1, "onLoad": 0 },605844085: { "name": "Hyrule", "internalName": "Hyrule", "roomId": 0, "key": "", "isStatic": 1, "onLoad": 0 },655651439: { "name": "Hyrule Castle: Great Hall", "internalName": "Hyroom", "roomId": 0, "key": "", "isStatic": 1, "onLoad": 0 },67765106: { "name": "Hyrule Castle: Basement", "internalName": "kenroom", "roomId": 0, "key": "", "isStatic": 1, "onLoad": 0 },1936023830: { "name": "Three-Eye Reef", "internalName": "sea", "roomId": 22, "key": "", "isStatic": 0, "onLoad": 0 },1936023823: { "name": "Western Fairy Island", "internalName": "sea", "roomId": 15, "key": "", "isStatic": 0, "onLoad": 0 },1936023816: { "name": "Four-Eye Reef", "internalName": "sea", "roomId": 8, "key": "", "isStatic": 0, "onLoad": 0 },1936023809: { "name": "Forsaken Fortress", "internalName": "sea", "roomId": 1, "key": "FFSea", "isStatic": 0, "onLoad": 0 },34496368: { "name": "Gallery ", "internalName": "ma2room", "roomId": 2, "key": "ForsakenFortress2Gallery", "isStatic": 1, "onLoad": 0 },34496370: { "name": "Prison ", "internalName": "ma2room", "roomId": 0, "key": "ForsakenFortress2Prison", "isStatic": 1, "onLoad": 0 },34496374: { "name": "Barracks ", "internalName": "ma2room", "roomId": 4, "key": "ForsakenFortress2Barracks", "isStatic": 1, "onLoad": 0 },34496369: { "name": "Docks ", "internalName": "ma2room", "roomId": 3, "key": "ForsakenFortress2Docks", "isStatic": 1, "onLoad": 0 },34496371: { "name": "Dining Area ", "internalName": "ma2room", "roomId": 1, "key": "ForsakenFortress2Dining", "isStatic": 1, "onLoad": 0 },978781807: { "name": "Forsaken Fortress: Tower ", "internalName": "M2tower", "roomId": 0, "key": "ForsakenFortress2Tower", "isStatic": 1, "onLoad": 0 },593299809: { "name": "Forsaken Fortress: Ganondorf's Chambers", "internalName": "M2ganon", "roomId": 0, "key": "ForsakenFortressGanondorf", "isStatic": 1, "onLoad": 0 },1936023836: { "name": "Thorned Fairy Island", "internalName": "sea", "roomId": 28, "key": "", "isStatic": 0, "onLoad": 0 },1062296690: { "name": "Thorned Fairy Island Great Fairy Fountain", "internalName": "Fairy05", "roomId": 0, "key": "", "isStatic": 1, "onLoad": 0 },1936023829: { "name": "Star Belt Archipelago", "internalName": "sea", "roomId": 21, "key": "", "isStatic": 0, "onLoad": 0 },672297838: { "name": "Inside a submarine...", "internalName": "Abship", "roomId": 6, "key": "", "isStatic": 1, "onLoad": 0 },1936023822: { "name": "Flight Control Platform", "internalName": "sea", "roomId": 14, "key": "", "isStatic": 0, "onLoad": 0 },1936023815: { "name": "Overlook Island", "internalName": "sea", "roomId": 7, "key": "", "isStatic": 0, "onLoad": 0 },1936023814: { "name": "Seven-Star Isles", "internalName": "sea", "roomId": 6, "key": "", "isStatic": 0, "onLoad": 0 },1936023813: { "name": "Crescent Moon Island", "internalName": "sea", "roomId": 5, "key": "", "isStatic": 0, "onLoad": 0 },1936023812: { "name": "Gale Isle", "internalName": "sea", "roomId": 4, "key": "", "isStatic": 0, "onLoad": 0 },1936023848: { "name": "Ice Ring Isle", "internalName": "sea", "roomId": 40, "key": "IceRingIsleOverworld", "isStatic": 0, "onLoad": 0 },101192809: { "name": "Inside Fire Mountain", "internalName": "MiniKaz", "roomId": 0, "key": "", "isStatic": 1, "onLoad": 0 },84935017: { "name": "Inside Ice Ring Isle", "internalName": "MiniHyo", "roomId": 0, "key": "", "isStatic": 1, "onLoad": 0 },1936023855: { "name": "Angular Isles", "internalName": "sea", "roomId": 47, "key": "", "isStatic": 0, "onLoad": 0 },1936023856: { "name": "Boating Course", "internalName": "sea", "roomId": 48, "key": "", "isStatic": 0, "onLoad": 0 },560162145: { "name": "The Great Sea: Boating Course", "internalName": "Ocean", "roomId": 0, "key": "", "isStatic": 1, "onLoad": 0 },1936023857: { "name": "Five-Star Isles", "internalName": "sea", "roomId": 49, "key": "", "isStatic": 0, "onLoad": 0 },336339061: { "name": "Nintendo Gallery: Forest Haven Room", "internalName": "figureG", "roomId": 0, "key": "", "isStatic": 1, "onLoad": 0 },336340597: { "name": "Nintendo Gallery: Great Sea Room", "internalName": "figureA", "roomId": 0, "key": "", "isStatic": 1, "onLoad": 0 },336340085: { "name": "Nintendo Gallery: Outset Island Room", "internalName": "figureC", "roomId": 0, "key": "", "isStatic": 1, "onLoad": 0 },336339829: { "name": "Nintendo Gallery: Forsaken Fortress Room", "internalName": "figureD", "roomId": 0, "key": "", "isStatic": 1, "onLoad": 0 },336339317: { "name": "Nintendo Gallery: Boss Room", "internalName": "figureF", "roomId": 0, "key": "", "isStatic": 1, "onLoad": 0 },336339573: { "name": "Nintendo Gallery: Enemy Room", "internalName": "figureE", "roomId": 0, "key": "", "isStatic": 1, "onLoad": 0 },1936023850: { "name": "Cliff Plateau Isles", "internalName": "sea", "roomId": 42, "key": "", "isStatic": 0, "onLoad": 0 },1936023843: { "name": "Bird's Peak Rock", "internalName": "sea", "roomId": 35, "key": "", "isStatic": 0, "onLoad": 0 },1936023851: { "name": "Horseshoe Island", "internalName": "sea", "roomId": 43, "key": "", "isStatic": 0, "onLoad": 0 },1936023844: { "name": "Diamond Steppe Island", "internalName": "sea", "roomId": 36, "key": "", "isStatic": 0, "onLoad": 0 },1936023845: { "name": "Five-Eye Reef", "internalName": "sea", "roomId": 37, "key": "", "isStatic": 0, "onLoad": 0 },1936023837: { "name": "Needle Rock Isle", "internalName": "sea", "roomId": 29, "key": "", "isStatic": 0, "onLoad": 0 },1936023810: { "name": "Star Island", "internalName": "sea", "roomId": 2, "key": "", "isStatic": 0, "onLoad": 0 },1934915173: { "name": "Horseshoe Island Cave", "internalName": "Cave05", "roomId": 0, "key": "", "isStatic": 1, "onLoad": 0 },638322793: { "name": "Earth Temple Entrance", "internalName": "Edaichi", "roomId": 0, "key": "", "isStatic": 1, "onLoad": 0 },610223201: { "name": "1F", "internalName": "M_Dai", "roomId": 0, "key": "ETEntrance", "isStatic": 1, "onLoad": 0 },610223200: { "name": "1F", "internalName": "M_Dai", "roomId": 1, "key": "ETEntrance2", "isStatic": 1, "onLoad": 0 },610223203: { "name": "1F", "internalName": "M_Dai", "roomId": 2, "key": "ETEntrance3", "isStatic": 1, "onLoad": 0 },610223202: { "name": "1F", "internalName": "M_Dai", "roomId": 3, "key": "ETFaceStatue", "isStatic": 1, "onLoad": 0 },610223205: { "name": "1F", "internalName": "M_Dai", "roomId": 4, "key": "ET1FSouthSarcophagus", "isStatic": 1, "onLoad": 0 },610223219: { "name": "1F", "internalName": "M_Dai", "roomId": 18, "key": "ET1FSouthSarcophagusEastRoom", "isStatic": 1, "onLoad": 0 },610223204: { "name": "1F", "internalName": "M_Dai", "roomId": 5, "key": "ET1FNorth", "isStatic": 1, "onLoad": 0 },610223207: { "name": "1F", "internalName": "M_Dai", "roomId": 6, "key": "ET1FNorthBlocks", "isStatic": 1, "onLoad": 0 },610223206: { "name": "1F", "internalName": "M_Dai", "roomId": 7, "key": "ET1FMoblinsAndPoes", "isStatic": 1, "onLoad": 0 },610223209: { "name": "1F", "internalName": "M_Dai", "roomId": 8, "key": "ET1FTomb", "isStatic": 1, "onLoad": 0 },605161069: { "name": "Earth Temple: 1F", "internalName": "M_DaiMB", "roomId": 12, "key": "ETMiniboss", "isStatic": 1, "onLoad": 0 },610223208: { "name": "B1", "internalName": "M_Dai", "roomId": 9, "key": "ETFaceStatueStaircase", "isStatic": 1, "onLoad": 0 },610223211: { "name": "B1", "internalName": "M_Dai", "roomId": 10, "key": "ETStatueReDead", "isStatic": 1, "onLoad": 0 },610223210: { "name": "B1", "internalName": "M_Dai", "roomId": 11, "key": "ETFogPillars", "isStatic": 1, "onLoad": 0 },610223212: { "name": "B1", "internalName": "M_Dai", "roomId": 13, "key": "ETFogFloormasters", "isStatic": 1, "onLoad": 0 },610223215: { "name": "B1", "internalName": "M_Dai", "roomId": 14, "key": "ETSarcophagusHallway", "isStatic": 1, "onLoad": 0 },610223214: { "name": "B1", "internalName": "M_Dai", "roomId": 15, "key": "ETBossEntrance", "isStatic": 1, "onLoad": 0 },610223217: { "name": "B2", "internalName": "M_Dai", "roomId": 16, "key": "ETBeneathBossEntrance", "isStatic": 1, "onLoad": 0 },610223218: { "name": "B2", "internalName": "M_Dai", "roomId": 19, "key": "ETSarcophagusLight", "isStatic": 1, "onLoad": 0 },605897825: { "name": "Earth Temple: B1", "internalName": "M_DaiB", "roomId": 0, "key": "", "isStatic": 1, "onLoad": 0 },543908218: { "name": "Wind Temple Entrance", "internalName": "Ekaze", "roomId": 0, "key": "", "isStatic": 1, "onLoad": 0 },1801550437: { "name": "1F", "internalName": "kaze", "roomId": 0, "key": "WTEntrance", "isStatic": 1, "onLoad": 0 },1024813941: { "name": "The Great Sea: Forest Haven", "internalName": "Otkura", "roomId": 0, "key": "", "isStatic": 1, "onLoad": 0 },639859301: { "name": "Earth Temple", "internalName": "kazeMB", "roomId": 0, "key": "ETMiniboss", "isStatic": 1, "onLoad": 0 },1935177317: { "name": "Savage Labyrinth Entrance", "internalName": "Cave09", "roomId": 0, "key": "", "isStatic": 1, "onLoad": 0 },1935177316: { "name": "Savage Labyrinth: B1", "internalName": "Cave09", "roomId": 1, "key": "", "isStatic": 1, "onLoad": 1 },1935177319: { "name": "Savage Labyrinth: B2", "internalName": "Cave09", "roomId": 2, "key": "", "isStatic": 1, "onLoad": 1 },1935177318: { "name": "Savage Labyrinth: B3", "internalName": "Cave09", "roomId": 3, "key": "", "isStatic": 1, "onLoad": 1 },1935177313: { "name": "Savage Labyrinth: B4", "internalName": "Cave09", "roomId": 4, "key": "", "isStatic": 1, "onLoad": 1 },1935177312: { "name": "Savage Labyrinth: B5", "internalName": "Cave09", "roomId": 5, "key": "", "isStatic": 1, "onLoad": 1 },1935177326: { "name": "Savage Labyrinth: B6", "internalName": "Cave09", "roomId": 11, "key": "", "isStatic": 1, "onLoad": 1 },1935177321: { "name": "Savage Labyrinth: B7", "internalName": "Cave09", "roomId": 12, "key": "", "isStatic": 1, "onLoad": 1 },1935177320: { "name": "Savage Labyrinth: B8", "internalName": "Cave09", "roomId": 13, "key": "", "isStatic": 1, "onLoad": 1 },1935177323: { "name": "Savage Labyrinth: B9", "internalName": "Cave09", "roomId": 14, "key": "", "isStatic": 1, "onLoad": 1 },1935177322: { "name": "Savage Labyrinth: B10", "internalName": "Cave09", "roomId": 15, "key": "", "isStatic": 1, "onLoad": 1 },1917941348: { "name": "Savage Labyrinth: B11", "internalName": "Cave10", "roomId": 1, "key": "", "isStatic": 1, "onLoad": 1 },1917941351: { "name": "Savage Labyrinth: B12", "internalName": "Cave10", "roomId": 2, "key": "", "isStatic": 1, "onLoad": 1 },1917941350: { "name": "Savage Labyrinth: B13", "internalName": "Cave10", "roomId": 3, "key": "", "isStatic": 1, "onLoad": 1 },1917941345: { "name": "Savage Labyrinth: B14", "internalName": "Cave10", "roomId": 4, "key": "", "isStatic": 1, "onLoad": 1 },1917941344: { "name": "Savage Labyrinth: B15", "internalName": "Cave10", "roomId": 5, "key": "", "isStatic": 1, "onLoad": 1 },1917941358: { "name": "Savage Labyrinth: B16", "internalName": "Cave10", "roomId": 11, "key": "", "isStatic": 1, "onLoad": 1 },1917941353: { "name": "Savage Labyrinth: B17", "internalName": "Cave10", "roomId": 12, "key": "", "isStatic": 1, "onLoad": 1 },1917941352: { "name": "Savage Labyrinth: B18", "internalName": "Cave10", "roomId": 13, "key": "", "isStatic": 1, "onLoad": 1 },1917941355: { "name": "Savage Labyrinth: B19", "internalName": "Cave10", "roomId": 14, "key": "", "isStatic": 1, "onLoad": 1 },1917941354: { "name": "Savage Labyrinth: B20", "internalName": "Cave10", "roomId": 15, "key": "", "isStatic": 1, "onLoad": 1 },1935177315: { "name": "Savage Labyrinth: B21", "internalName": "Cave09", "roomId": 6, "key": "", "isStatic": 1, "onLoad": 1 },1935177314: { "name": "Savage Labyrinth: B22", "internalName": "Cave09", "roomId": 7, "key": "", "isStatic": 1, "onLoad": 1 },1935177325: { "name": "Savage Labyrinth: B23", "internalName": "Cave09", "roomId": 8, "key": "", "isStatic": 1, "onLoad": 1 },1935177324: { "name": "Savage Labyrinth: B24", "internalName": "Cave09", "roomId": 9, "key": "", "isStatic": 1, "onLoad": 1 },1935177327: { "name": "Savage Labyrinth: B25", "internalName": "Cave09", "roomId": 10, "key": "", "isStatic": 1, "onLoad": 1 },1935177333: { "name": "Savage Labyrinth: B26", "internalName": "Cave09", "roomId": 16, "key": "", "isStatic": 1, "onLoad": 1 },1935177332: { "name": "Savage Labyrinth: B27", "internalName": "Cave09", "roomId": 17, "key": "", "isStatic": 1, "onLoad": 1 },1935177335: { "name": "Savage Labyrinth: B28", "internalName": "Cave09", "roomId": 18, "key": "", "isStatic": 1, "onLoad": 1 },1935177334: { "name": "Savage Labyrinth: B29", "internalName": "Cave09", "roomId": 19, "key": "", "isStatic": 1, "onLoad": 1 },1935177329: { "name": "Savage Labyrinth: B30", "internalName": "Cave09", "roomId": 20, "key": "", "isStatic": 1, "onLoad": 1 },1917875812: { "name": "Savage Labyrinth: B31", "internalName": "Cave11", "roomId": 1, "key": "", "isStatic": 1, "onLoad": 1 },1917875815: { "name": "Savage Labyrinth: B32", "internalName": "Cave11", "roomId": 2, "key": "", "isStatic": 1, "onLoad": 1 },1917875814: { "name": "Savage Labyrinth: B33", "internalName": "Cave11", "roomId": 3, "key": "", "isStatic": 1, "onLoad": 1 },1917875809: { "name": "Savage Labyrinth: B34", "internalName": "Cave11", "roomId": 4, "key": "", "isStatic": 1, "onLoad": 1 },1917875808: { "name": "Savage Labyrinth: B35", "internalName": "Cave11", "roomId": 5, "key": "", "isStatic": 1, "onLoad": 1 },1917875822: { "name": "Savage Labyrinth: B36", "internalName": "Cave11", "roomId": 11, "key": "", "isStatic": 1, "onLoad": 1 },1917875817: { "name": "Savage Labyrinth: B37", "internalName": "Cave11", "roomId": 12, "key": "", "isStatic": 1, "onLoad": 1 },1917875816: { "name": "Savage Labyrinth: B38", "internalName": "Cave11", "roomId": 13, "key": "", "isStatic": 1, "onLoad": 1 },1917875819: { "name": "Savage Labyrinth: B39", "internalName": "Cave11", "roomId": 14, "key": "", "isStatic": 1, "onLoad": 1 },1917875818: { "name": "Savage Labyrinth: B40", "internalName": "Cave11", "roomId": 15, "key": "", "isStatic": 1, "onLoad": 1 },1917941347: { "name": "Savage Labyrinth: B41", "internalName": "Cave10", "roomId": 6, "key": "", "isStatic": 1, "onLoad": 1 },1917941346: { "name": "Savage Labyrinth: B42", "internalName": "Cave10", "roomId": 7, "key": "", "isStatic": 1, "onLoad": 1 },1917941357: { "name": "Savage Labyrinth: B43", "internalName": "Cave10", "roomId": 8, "key": "", "isStatic": 1, "onLoad": 1 },1917941356: { "name": "Savage Labyrinth: B44", "internalName": "Cave10", "roomId": 9, "key": "", "isStatic": 1, "onLoad": 1 },1917941359: { "name": "Savage Labyrinth: B45", "internalName": "Cave10", "roomId": 10, "key": "", "isStatic": 1, "onLoad": 1 },1917941365: { "name": "Savage Labyrinth: B46", "internalName": "Cave10", "roomId": 16, "key": "", "isStatic": 1, "onLoad": 1 },1917941364: { "name": "Savage Labyrinth: B47", "internalName": "Cave10", "roomId": 17, "key": "", "isStatic": 1, "onLoad": 1 },1917941367: { "name": "Savage Labyrinth: B48", "internalName": "Cave10", "roomId": 18, "key": "", "isStatic": 1, "onLoad": 1 },1917941366: { "name": "Savage Labyrinth: B49", "internalName": "Cave10", "roomId": 19, "key": "", "isStatic": 1, "onLoad": 1 },1917941361: { "name": "Savage Labyrinth: B50", "internalName": "Cave10", "roomId": 20, "key": "", "isStatic": 1, "onLoad": 1 },1732665924: { "name": "Angular Isles Grotto", "internalName": "SubD43", "roomId": 0, "key": "", "isStatic": 1, "onLoad": 0 },325153392: { "name": "Diamond Steppe Island Grotto", "internalName": "WarpD", "roomId": 0, "key": "", "isStatic": 1, "onLoad": 0 },1732731460: { "name": "Needle Rock Isle Grotto", "internalName": "SubD42", "roomId": 0, "key": "", "isStatic": 1, "onLoad": 0 },755791188: { "name": "Pawprint Isle Grotto", "internalName": "TyuTyu", "roomId": 0, "key": "", "isStatic": 1, "onLoad": 0 },1934784101: { "name": "Cliff Plateau Isles Grotto", "internalName": "Cave03", "roomId": 0, "key": "", "isStatic": 1, "onLoad": 0 },1934653029: { "name": "Bomb Island Grotto", "internalName": "Cave01", "roomId": 0, "key": "", "isStatic": 1, "onLoad": 0 },1934653028: { "name": "Bomb Island Grotto", "internalName": "Cave01", "roomId": 1, "key": "", "isStatic": 1, "onLoad": 0 },672297834: { "name": "Inside a submarine...", "internalName": "Abship", "roomId": 2, "key": "", "isStatic": 1, "onLoad": 0 },1029855091: { "name": "Ice Ring Isle Grotto", "internalName": "ITest62", "roomId": 0, "key": "", "isStatic": 1, "onLoad": 0 },1732665136: { "name": "Bird's Peak Rock Grotto", "internalName": "TF_03", "roomId": 0, "key": "", "isStatic": 1, "onLoad": 0 },839738739: { "name": "Cabana", "internalName": "Abesso", "roomId": 0, "key": "", "isStatic": 1, "onLoad": 0 },1615224624: { "name": "Underneath the Cabana", "internalName": "TF_04", "roomId": 0, "key": "", "isStatic": 1, "onLoad": 0 },1682203204: { "name": "Boating Course Grotto", "internalName": "SubD71", "roomId": 0, "key": "", "isStatic": 1, "onLoad": 0 },1699110704: { "name": "Stone Watcher Island Grotto", "internalName": "TF_01", "roomId": 0, "key": "", "isStatic": 1, "onLoad": 0 },1699110705: { "name": "Stone Watcher Island Grotto", "internalName": "TF_01", "roomId": 1, "key": "", "isStatic": 1, "onLoad": 0 },1699110706: { "name": "Stone Watcher Island Grotto", "internalName": "TF_01", "roomId": 2, "key": "", "isStatic": 1, "onLoad": 0 },1699110707: { "name": "Stone Watcher Island Grotto", "internalName": "TF_01", "roomId": 3, "key": "", "isStatic": 1, "onLoad": 0 },1699110708: { "name": "Stone Watcher Island Grotto", "internalName": "TF_01", "roomId": 4, "key": "", "isStatic": 1, "onLoad": 0 },1699110709: { "name": "Stone Watcher Island Grotto", "internalName": "TF_01", "roomId": 5, "key": "", "isStatic": 1, "onLoad": 0 },1699110710: { "name": "Stone Watcher Island Grotto", "internalName": "TF_01", "roomId": 6, "key": "", "isStatic": 1, "onLoad": 0 },1715887920: { "name": "Overlook Island Grotto", "internalName": "TF_02", "roomId": 0, "key": "", "isStatic": 1, "onLoad": 0 },1715887921: { "name": "Overlook Island Grotto", "internalName": "TF_02", "roomId": 1, "key": "", "isStatic": 1, "onLoad": 0 },1715887922: { "name": "Overlook Island Grotto", "internalName": "TF_02", "roomId": 2, "key": "", "isStatic": 1, "onLoad": 0 },1715887923: { "name": "Overlook Island Grotto", "internalName": "TF_02", "roomId": 3, "key": "", "isStatic": 1, "onLoad": 0 },1715887924: { "name": "Overlook Island Grotto", "internalName": "TF_02", "roomId": 4, "key": "", "isStatic": 1, "onLoad": 0 },1715887925: { "name": "Overlook Island Grotto", "internalName": "TF_02", "roomId": 5, "key": "", "isStatic": 1, "onLoad": 0 },1715887926: { "name": "Overlook Island Grotto", "internalName": "TF_02", "roomId": 6, "key": "", "isStatic": 1, "onLoad": 0 },1934849637: { "name": "Star Island Grotto", "internalName": "Cave02", "roomId": 0, "key": "", "isStatic": 1, "onLoad": 0 },1935046245: { "name": "Pawprint Isle Outer Grotto", "internalName": "Cave07", "roomId": 0, "key": "", "isStatic": 1, "onLoad": 0 },1029854835: { "name": "Shark Island Grotto", "internalName": "ITest63", "roomId": 0, "key": "", "isStatic": 1, "onLoad": 0 },1934980709: { "name": "Rock Spire Isle Grotto", "internalName": "Cave04", "roomId": 0, "key": "", "isStatic": 1, "onLoad": 0 },689991279: { "name": "Ganon's Tower", "internalName": "GanonA", "roomId": 0, "key": "", "isStatic": 1, "onLoad": 0 },690646639: { "name": "Puppet Ganon Room", "internalName": "GanonK", "roomId": 0, "key": "", "isStatic": 1, "onLoad": 0 },572944247: { "name": "The Top of the Tower", "internalName": "GTower", "roomId": 0, "key": "", "isStatic": 1, "onLoad": 0 },822504815: { "name": "Komali's Room", "internalName": "Comori", "roomId": 0, "key": "", "isStatic": 1, "onLoad": 0 },671838831: { "name": "Forest Potion Shop", "internalName": "Ocrogh", "roomId": 0, "key": "", "isStatic": 1, "onLoad": 0 },1062296178: { "name": "Western Fairy Island Great Fairy Fountain", "internalName": "Fairy03", "roomId": 0, "key": "", "isStatic": 1, "onLoad": 0 },690843247: { "name": "Ganon's Tower", "internalName": "GanonL", "roomId": 0, "key": "", "isStatic": 1, "onLoad": 0 },1648779057: { "name": "Dragon Roost Island Grotto", "internalName": "TF_06", "roomId": 1, "key": "", "isStatic": 1, "onLoad": 0 },1648779058: { "name": "Dragon Roost Island Grotto", "internalName": "TF_06", "roomId": 2, "key": "", "isStatic": 1, "onLoad": 0 },1648779059: { "name": "Dragon Roost Island Grotto", "internalName": "TF_06", "roomId": 3, "key": "", "isStatic": 1, "onLoad": 0 },1648779060: { "name": "Dragon Roost Island Grotto", "internalName": "TF_06", "roomId": 4, "key": "", "isStatic": 1, "onLoad": 0 },1648779061: { "name": "Dragon Roost Island Grotto", "internalName": "TF_06", "roomId": 5, "key": "", "isStatic": 1, "onLoad": 0 },1648779062: { "name": "Dragon Roost Island Grotto", "internalName": "TF_06", "roomId": 6, "key": "", "isStatic": 1, "onLoad": 0 },
}

// Create lookup mappings for subareas
function GetAreaByHash(inHash)
{
    return areas[inHash]
}

function GetSuperareaByName(name)
{
    for i in superareas
    {
        superarea = superareas[i]
        if (superarea["internalName"] == name)
        {
            return superarea
        }
    }
    
    return false
}

function DoesSuperareaExist(name)
{
    for i in superareas
    {
        superarea = superareas[i]
        if (superarea["internalName"] == name)
        {
            return true
        }
    }
    
    return false
}

function GetLookupKey(internalName) => internalName + "Lookup"

lookups = {}

// Create one lookup mapping for each internal name used in the `areas` dictionary.
for hash in areas
{
    i = GetAreaByHash(hash)
    
    lookupKey = GetLookupKey(i["internalName"])
    lookups[lookupKey] = {}
    
    // Find all areas that use the same internal name and add them to the lookup mapping.
    for hash in areas
    {
        j = areas[hash]
        if (j["internalName"] == i["internalName"])
        {
            lookup = lookups[lookupKey]
            lookup[j["roomId"]] = j["name"]
            
            lookups[lookupKey] = lookup
        }
    }
}

// /lookups

function GetAreaByName(name)
{
    for hash in areas
    {
        area = areas[hash]
        if (area["name"] == name)
        {
            return area
        }
    }
}

function GetAreaByKey(key)
{
    for hash in areas
    {
        area = areas[hash]
        if (area["key"] == key)
        {
            return area
        }
    }
}

function GetAreaByInternalName(name)
{
    for hash in areas
    {
        area = areas[hash]
        if (area["internalName"] == name)
        {
            return area
        }
    }
}

function GetAreaRPLookup()
{
    ret = {}
    for hash in areas
    {
        area = areas[hash]
        ret[hash] = area["name"]
    }
    return ret
}

function mapNameAddr() => 0x003d1664
function loadingMapNameAddr() => 0x003d1670
function mapNamePart1() => dword_be(0x003d1664)
function mapNamePart2() => dword_be(0x003d1668)
function roomPointer() => dword_be(0x003d21f4) & 0x7FFFFFFF
function roomId() => byte(roomPointer() + 0x66d)
function stageId() => byte(0x003ccccc)
function layerId() => byte(0x003ccd24)
function staticRoomId() => byte(0x003cd658)
function roomIdOnLoad() => byte(0x003cccd8)

function GetAreaHash()
{
    return (mapNamePart1() ^ mapNamePart2()) + roomId()
}

function IsInArea(name)
{
    area = GetAreaByName(name)
    return ascii_string_equals(mapNameAddr(), area["internalName"])
}

function IsInAreaByKey(key)
{
    area = GetAreaByKey(key)
    areaRoomId = roomId()
    
    if (area["isStatic"] == 1)
    {
        areaRoomId = staticRoomId()
    }
    
    return ascii_string_equals(mapNameAddr(), area["internalName"]) && areaRoomId == area["roomId"]
}

function WasJustInAreaByKey(key)
{
    area = GetAreaByKey(key)
    areaRoomId = roomId()
    
    if (area["isStatic"] == 1)
    {
        areaRoomId = staticRoomId()
    }
    
    return ascii_string_equals(mapNameAddr(), area["internalName"], transform = Delta) && Delta(areaRoomId) == area["roomId"]
}

function IsInAreaByInternalName(name)
{
    area = GetAreaByInternalName(name)
    return ascii_string_equals(mapNameAddr(), area["internalName"])
}

function WasJustInAreaByInternalName(name, useNullTerminator = false)
{    
    area = GetAreaByInternalName(name)
    nullTerminatorClause = always_true()
    
    if (useNullTerminator)
    {
        nullTerminatorClause = Delta(byte(mapNameAddr() + length(area["internalName"]))) == 0
    }
    
    return ascii_string_equals(mapNameAddr(), area["internalName"], transform = Delta) && nullTerminatorClause
}

function IsTransitioningToAreaByInternalName(name)
{
    area = GetAreaByInternalName(name)
    return ascii_string_equals(loadingMapNameAddr(), area["internalName"]) && !ascii_string_equals(mapNameAddr(), area["internalName"])
}

function IsInAreaByHash(hash)
{
    return hash == GetAreaHash()
}

function IsInSuperarea(internalName)
{
    area = GetSuperareaByName(internalName)
    return stageId() == area["stageId"]
}

function IsOnTitleScreen() => IsInArea("Title Screen")
function IsSelectingFile() => IsInArea("File Select")
internalNamesAddedToRP = []

function maxLifeEnergy() => word_be(0x003cc530)
function Hearts() => maxLifeEnergy() / 4
function ShouldUseStageLookup(stageId) => stageId > 0 && stageId < 9
function outsetIslandCutscenePlayed() => bit4(0x003ccb89)
function IsLoadingSaveFile() => IsValueSet(outsetIslandCutscenePlayed(), 0, 1)
function FileIsLoaded() => Delta(outsetIslandCutscenePlayed()) == 1

lookupForSuperarea = {}
for i in superareas
{
    superarea = superareas[i]
    lookupForSuperarea[superarea["stageId"]] = superarea["displayName"]
}

rich_presence_conditional_display(ShouldUseStageLookup(stageId()), "{0} • {1} ❤️",
    rich_presence_lookup("SuperareaLookup", stageId(), lookupForSuperarea),
    rich_presence_value("Hearts", Hearts())
)

for hash in areas
{
    area = GetAreaByHash(hash)
    superarea = GetSuperareaByName(area["internalName"])
    lookupForArea = lookups[GetLookupKey(area["internalName"])]
    display = ""
    roomIdToUse = roomId()
    shouldUseStageLookup = false
    
    if (superarea != false)
    {
        shouldUseStageLookup = ShouldUseStageLookup(superarea["stageId"])
    } 
    
    if (area["isStatic"] == 1)
    {
        if (area["onLoad"] == 1)
        {
            roomIdToUse = roomIdOnLoad()
        }
        else
        {
            roomIdToUse = staticRoomId()
        }
    }

    if (!any_of(internalNamesAddedToRP, input => input == area["internalName"]) && !shouldUseStageLookup)
    {
        if (superarea != false && superarea["stageId"] == 0) // Great Sea exception
        {
            display = superarea["displayName"] + ": "
        }
        
        rich_presence_conditional_display(IsInArea(area["name"]), display + "{0} • {1} ❤️",
            rich_presence_lookup(GetLookupKey(area["internalName"]), roomIdToUse, lookupForArea, "Somewhere on the Great Sea..."),
            rich_presence_value("Hearts", Hearts())
        )
        array_push(internalNamesAddedToRP, area["internalName"])
    }
}

rich_presence_conditional_display(IsOnTitleScreen(), "On the title screen...")
rich_presence_conditional_display(IsSelectingFile(), "Selecting a file...")
rich_presence_display("Somewhere on the Great Sea...")

function Pluralize(value, unit)
{
    if (value == 1)
    {
        return unit
    }
    else
    {
        return unit + "s"
    }
}

function SecondsToFormat(value)
{
    singleUnitFormat = "{0} {1}"
    doubleUnitFormat = "{0} {1} and {2} {3}"
    minutes = value / 60
    seconds = value % 60
    
    if (minutes == 0)
    {
        return format(singleUnitFormat, seconds, Pluralize(seconds, "second"))
    }
    
    if (seconds == 0)
    {
        return format(singleUnitFormat, Pluralize(minutes, "minute"))
    }
    
    return format(doubleUnitFormat, minutes, Pluralize(minutes, "minute"), seconds, Pluralize(seconds, "second"))
}

// $3ffc3c: (32-bit BE) System timer. Increments by one every frame.
function framesCounter() => dword_be(0x3ffc3c)

function frameIncremented() => prev(framesCounter()) != framesCounter()

function SecondsToFrames(seconds) => seconds * 60 // Assuming a 60 FPS framerate (yes, apparently, this game assumes 60FPS on PAL, too)

function swordActionPointer() => dword_be(0x003c1060)
function swordAnimationId() => byte(swordActionPointer() + 0x1b8 + 0x80000000)
function swordSwingState() => byte(swordActionPointer() + 0x1cf + 0x80000000)
function AreaJustChanged() => swordActionPointer() != Delta(swordActionPointer()) && Delta(swordActionPointer()) == 0

function dialoguePointer() => dword_be(0x003c21b8)
function messageId() => word_be(dialoguePointer() + 0x40 + 0x80000000)
function DisplayingMessageWithId(id) => messageId() == id

function baitBagSlot() => byte(0x003cc577)
achievement(title = "Ready for Hunting", points = 3, description = "Obtain the Bait Bag.", id = 402391, badge = "500800",
    trigger = IsValueSetInGame(baitBagSlot(), 0xff, 0x2c)
)

function rupees() => word_be(0x003cc534)
achievement(title = "Birthday Fine", points = 1, description = "Destroy the pot Sue-Belle's carrying and pay the full fine.", id = 402392, type = "missable", badge = "500801",
    trigger = once(DisplayingMessageWithId(2207)) && Delta(rupees()) == rupees() + 10
)

function crawlingStatus() => bit3(0x3d21f8)
function gavePinkPig() => bit0(0x003ccc13)
function gaveSpottedPig() => bit1(0x003ccc13)
function gaveBlackPig() => bit2(0x003ccc13)
achievement(title = "Hog Wild", points = 5, description = "Wrangle all 3 pigs on Outset Island without crawling or going indoors.", id = 402393, badge = "500803",
    type = "missable",
    trigger = WasBitflagSetInGame(gavePinkPig()) && WasBitflagSetInGame(gaveSpottedPig()) && WasBitflagSetInGame(gaveBlackPig()) && unless(once(crawlingStatus() == 1))
        && (always_false() || never(AreaJustChanged()))
)

function bokoblinsDroppedIn() => bit0(0x003cccaf) // when stageId is 0xb
function tetraAwakens() => bit1(0x003cccaf) // when stageId is 0xb
achievement(title = "With Enemies Like These", points = 25, description = "Rescue Tetra from the 2 Bokoblins without using your sword and without leaving the area.", id = 402394,
    type = "missable", badge = "500870",
    trigger = once(IsInArea("Forest of Fairies") && IsValueSet(bokoblinsDroppedIn(), 0, 1)) && stageId() == 0xb
        && trigger_when(WasBitflagJustSetInGame(tetraAwakens()))
        && never(swordActionPointer() == 0)
        && never(swordAnimationId() != 0)
        && never(!IsInArea("Forest of Fairies"))
)


niko1TimeLimit = 20
tetraPlatformMaxTime = 0x708
function tetraPlatformPointer() => dword_be(0x003c0d7c) // todo: Even more narrowing down of potential pointers needs to be done, but I haven't figured out what causes memory to shift...
function enteredCorrectPassword() => bit4(0x003ccb6d)
function tetraPlatformTimeRemaining() => word_be(tetraPlatformPointer() + 0x1be + 0x80000000)
function TetraPlatformTimerFrozen() => byte(tetraPlatformPointer() + 0x1c0 + 0x80000000) > 0
function TetraPlatformTimeElapsed() => (tetraPlatformMaxTime - tetraPlatformTimeRemaining()) * 2
function WithinPlatformTimeLimit() => TetraPlatformTimeElapsed() <= SecondsToFrames(niko1TimeLimit)
function TetraPlatformsAreUp() => bit0(tetraPlatformPointer() + 0x1bb + 0x80000000) == 1
function NinjaWarriorChallengeActive() => TetraPlatformsAreUp() && enteredCorrectPassword() == 0 && tetraPlatformPointer() != 0
function CompletedFirstObstacleCourse() => bit4(0x003ccb5b) == 1
achievement(title = "Ninja Warrior I", points = 10, description = "Complete Niko's obstacle course within " + SecondsToFormat(niko1TimeLimit) + ".", id = 402395, type = "missable",
    badge = "500804",
    trigger = trigger_when(NinjaWarriorChallengeActive() && TetraPlatformTimerFrozen()) && WithinPlatformTimeLimit() && !CompletedFirstObstacleCourse()
)

leaderboard(title = "Ninja Warrior I", description = "Reach the end of Niko's first obstacle course as quickly as you can.", id = 90099,
    start = NinjaWarriorChallengeActive() && !CompletedFirstObstacleCourse(),
    cancel = !NinjaWarriorChallengeActive(),
    submit = NinjaWarriorChallengeActive() && TetraPlatformTimerFrozen(),
    value = TetraPlatformTimeElapsed(),
    format = "FRAMES",
    lower_is_better = true
)

function metKoRL() => bit2(0x003cc8b6)
achievement(title = "Carried by the Currents", description = "Meet the King of Red Lions.", points = 3, id = 402396, type = "progression", badge = "500805",
    trigger = WasBitflagJustSetInGame(metKoRL())
)

function pictographSidequestProgress() => byte(0x003ccc18)
achievement(title = "Apprentice Pictographer", description = "Complete Lenzo's pictograph sidequest.", points = 5, id = 404243, badge = "500806",
    trigger = WasValueJustSetInGame(pictographSidequestProgress(), 5, 6)
)

function windWakerSlot() => byte(0x003cc56e)
achievement(title = "Maestro of the Mistral", description = "Obtain the Wind Waker.", points = 3, type = "progression",  badge = "500807",
    trigger = IsValueSetInGame(windWakerSlot(), 0xff, 0x22)
)

function letterSortingQuestProgress() => byte(0x003ccc16)
achievement(title = "Part-Time Clerk", description = "Complete the first letter-sorting sidequest.", points = 5, badge = "500808",
    trigger = WasValueJustSetInGame(letterSortingQuestProgress(), 2, 3)
        && measured(letterSortingQuestProgress() == 3)
)

possessedTreasureChartAddressBits = {
    2: { "addr": 0x003cc604, "bit": 0 },3: { "addr": 0x003cc604, "bit": 1 },4: { "addr": 0x003cc604, "bit": 2 },5: { "addr": 0x003cc604, "bit": 5 },6: { "addr": 0x003cc604, "bit": 6 },7: { "addr": 0x003cc605, "bit": 1 },8: { "addr": 0x003cc605, "bit": 2 },9: { "addr": 0x003cc605, "bit": 3 },10: { "addr": 0x003cc605, "bit": 4 },11: { "addr": 0x003cc605, "bit": 5 },12: { "addr": 0x003cc605, "bit": 7 },13: { "addr": 0x003cc606, "bit": 0 },14: { "addr": 0x003cc606, "bit": 1 },15: { "addr": 0x003cc606, "bit": 2 },16: { "addr": 0x003cc606, "bit": 3 },17: { "addr": 0x003cc606, "bit": 5 },18: { "addr": 0x003cc606, "bit": 6 },19: { "addr": 0x003cc606, "bit": 7 },20: { "addr": 0x003cc607, "bit": 4 },21: { "addr": 0x003cc609, "bit": 2 },22: { "addr": 0x003cc60b, "bit": 0 },23: { "addr": 0x003cc60b, "bit": 2 },24: { "addr": 0x003cc60b, "bit": 4 },25: { "addr": 0x003cc60b, "bit": 5 },26: { "addr": 0x003cc60b, "bit": 6 },
}

GenerateCheevoFromBufferBits(name = "Dragon's Hoard", description = "Open all treasure chests in Dragon Roost Cavern.", points = 5,  badge = "500811",
    onlyAvailableWhen = IsInAreaByInternalName("M_NewD2") && Delta(stageId()) == 3,
    addresses = {
        1: { "buffer": { "addr": 0x003cccab, "bit": 0, "stage": 0x3 }, "static": { "addr": 0x003cc91f, "bit": 0 } },
        2: { "buffer": { "addr": 0x003cccab, "bit": 1, "stage": 0x3 }, "static": { "addr": 0x003cc91f, "bit": 1 } },
        3: { "buffer": { "addr": 0x003cccab, "bit": 2, "stage": 0x3 }, "static": { "addr": 0x003cc91f, "bit": 2 } },
        4: { "buffer": { "addr": 0x003cccab, "bit": 3, "stage": 0x3 }, "static": { "addr": 0x003cc91f, "bit": 3 } },
        5: { "buffer": { "addr": 0x003cccab, "bit": 4, "stage": 0x3 }, "static": { "addr": 0x003cc91f, "bit": 4 } },
        6: { "buffer": { "addr": 0x003cccab, "bit": 6, "stage": 0x3 }, "static": { "addr": 0x003cc91f, "bit": 6 } },
        7: { "buffer": { "addr": 0x003cccab, "bit": 7, "stage": 0x3 }, "static": { "addr": 0x003cc91f, "bit": 7 } },
        8: { "buffer": { "addr": 0x003cccaa, "bit": 2, "stage": 0x3 }, "static": { "addr": 0x003cc91e, "bit": 2 } },
        9: { "buffer": { "addr": 0x003cccaa, "bit": 3, "stage": 0x3 }, "static": { "addr": 0x003cc91e, "bit": 3 } },
        10: { "buffer": { "addr": 0x003cccaa, "bit": 4, "stage": 0x3 }, "static": { "addr": 0x003cc91e, "bit": 4 } },
        11: { "buffer": { "addr": 0x003cccaa, "bit": 5, "stage": 0x3 }, "static": { "addr": 0x003cc91e, "bit": 5 } },
        12: { "buffer": { "addr": 0x003cccaa, "bit": 6, "stage": 0x3 }, "static": { "addr": 0x003cc91e, "bit": 6 } },
        13: { "buffer": { "addr": 0x003cccaa, "bit": 7, "stage": 0x3 }, "static": { "addr": 0x003cc91e, "bit": 7 } },
        14: { "buffer": { "addr": 0x003ccca9, "bit": 0, "stage": 0x3 }, "static": { "addr": 0x003cc91d, "bit": 0 } },
    }
)

function dinsPearl() => bit1(0x003cc5ef)
achievement(title = "Jewel of Power", description = "Obtain Din's Pearl.", points = 5, type = "progression", badge = "502207", id = 439027,
    trigger = WasBitflagJustSetInGame(dinsPearl())
)

GenerateCheevoFromBufferBits(
    name = "Spelunker",
    description = "Open the optional treasure chests in all secret caves.",
    points = 10,
    id = 439028,
    badge = "500813",
    addresses = {
        1: { "buffer": { "addr": 0x003cccab, "bit": 0, "group": "TF_06", "stage": 0xd }, "static": { "addr": 0x003cca87, "bit": 0 } }, // Dragoon Roost Island labyrinth
        2: { "buffer": {  "addr": 0x003cccab, "bit": 1, "group": "Cave05", "stage": 0xd }, "static": { "addr": 0x003cca87, "bit": 1 } }, // Horseshoe Island cave
        3: { "buffer": {  "addr": 0x003ccca9, "bit": 7, "group": "WarpD", "stage": 0xc }, "static": { "addr": 0x003cca61, "bit": 7 } }, // Diamond Steppe Island cave
        4: { "buffer": {  "addr": 0x003cccaa, "bit": 1, "group": "SubD42", "stage": 0xd }, "static": { "addr": 0x003cca86, "bit": 1 } }, // Needle Rock Isle cave
        5: { "buffer": {  "addr": 0x003cccab, "bit": 6, "group": "SubD43", "stage": 0xd }, "static": { "addr": 0x003cca87, "bit": 6 } }, // Angular Isles cave
        6: { "buffer": {  "addr": 0x003ccca8, "bit": 0, "group": "TyuTyu", "stage": 0xc }, "static": { "addr": 0x003cca60, "bit": 0 } }, // Pawprint Isle cave
        7: { "buffer": {  "addr": 0x003ccca8, "bit": 1, "group": "TyuTyu", "stage": 0xc }, "static": { "addr": 0x003cca60, "bit": 1 } },
        8: { "buffer": {  "addr": 0x003ccca8, "bit": 2, "group": "TyuTyu", "stage": 0xc }, "static": { "addr": 0x003cca60, "bit": 2 } },
        9: { "buffer": {  "addr": 0x003cccab, "bit": 2, "group": "TyuTyu", "stage": 0xc }, "static": { "addr": 0x003cca63, "bit": 2 } },
        10: { "buffer": {  "addr": 0x003cccab, "bit": 7, "group": "Cave03", "stage": 0xc }, "static": { "addr": 0x003cca63, "bit": 7 } }, // Cliff Plateau Isles cave
        11: { "buffer": {  "addr": 0x003cccab, "bit": 5, "group": "Cave01", "stage": 0xc }, "static": { "addr": 0x003cca63, "bit": 5 } }, // Bomb Island cave
        12: { "buffer": {  "addr": 0x003ccca9, "bit": 5, "group": "ITest62", "stage": 0xc }, "static": { "addr": 0x003cca61, "bit": 5 } }, // Ice Ring Isle cave
        13: { "buffer": {  "addr": 0x003ccca9, "bit": 6, "group": "Cave01", "stage": 0xc }, "static": { "addr": 0x003cca61, "bit": 6 } }, // Underneath the cabana
        14: { "buffer": {  "addr": 0x003cccb6, "bit": 0, "group": "SubD71", "stage": 0xd }, "static": { "addr": 0x003cca92, "bit": 0 } }, // Boating Course cave
        15: { "buffer": {  "addr": 0x003cccab, "bit": 6, "group": "Cave02", "stage": 0xc }, "static": { "addr": 0x003cca63, "bit": 6 } }, // Star Island cave
        16: { "buffer": {  "addr": 0x003cccab, "bit": 2, "group": "Cave07", "stage": 0xd }, "static": { "addr": 0x003cca87, "bit": 2 } }, // Pawprint Isle outer cave
        17: { "buffer": {  "addr": 0x003ccca9, "bit": 6, "group": "ITest63", "stage": 0xd }, "static": { "addr": 0x003cca85, "bit": 6 } }, // Shark Island cave
        18: { "buffer": {  "addr": 0x003cccaa, "bit": 0, "group": "Cave04", "stage": 0xc }, "static": { "addr": 0x003cca62, "bit": 0 } }, // Rock Spire Isle cave
    },
    onlyAvailableWhen = stageId() == 0xd || stageId() == 0xc
)

GenerateCheevoFromBufferBits(
    name = "Krakenslayer",
    description = "Defeat all 6 Big Octos.",
    points = 10,
    id = 444183,
    badge = "500814",
    addresses = {
        1: { "buffer": { "addr": 0x003cccad, "bit": 0, "stage": 0 }, "static": { "addr": 0x003cc8b5, "bit": 0 } },
        2: { "buffer": { "addr": 0x003cccad, "bit": 1, "stage": 0 }, "static": { "addr": 0x003cc8b5, "bit": 1 } },
        3: { "buffer": { "addr": 0x003cccad, "bit": 2, "stage": 0 }, "static": { "addr": 0x003cc8b5, "bit": 2 } },
        4: { "buffer": { "addr": 0x003cccae, "bit": 5, "stage": 0 }, "static": { "addr": 0x003cc8b6, "bit": 5 } },
        5: { "buffer": { "addr": 0x003cccae, "bit": 6, "stage": 0 }, "static": { "addr": 0x003cc8b6, "bit": 6 } },
        6: { "buffer": { "addr": 0x003cccae, "bit": 7, "stage": 0 }, "static": { "addr": 0x003cc8b6, "bit": 7 } }
    },
    onlyAvailableWhen = Delta(stageId()) == 0x0
)

cartographerBits = {}
for i in range(0, 48)
{
    baseChartAddr = 0x003cc634
    cartographerBits[i] = { "addr": (baseChartAddr + i), "bit": 0 }
}

GenerateCheevoFromBits(name = "Rookie Cartographer", description = "Map 50% of the islands on your Sea Chart.", points = 5,
    id = 439029,
    badge = "500817",
    onlyAvailableWhen = IsInAreaByInternalName("sea"),
    addresses = cartographerBits,
    threshold = length(cartographerBits) / 2,
    oneAtATime = true,
    measuredIf = FileIsLoaded() && stageId() != 0xff && !IsInAreaByInternalName("sea_T")
)

treasureChartBitflags = {
    1: { "addr": 0x003cc604, "bit": 0 },
    2: { "addr": 0x003cc604, "bit": 1 },
    3: { "addr": 0x003cc604, "bit": 2 },
    4: { "addr": 0x003cc604, "bit": 3 },
    5: { "addr": 0x003cc604, "bit": 4 },
    6: { "addr": 0x003cc604, "bit": 5 },
    7: { "addr": 0x003cc604, "bit": 6 },
    8: { "addr": 0x003cc604, "bit": 7 },
    9: { "addr": 0x003cc605, "bit": 0 },
    10: { "addr": 0x003cc605, "bit": 1 },
    11: { "addr": 0x003cc605, "bit": 2 },
    12: { "addr": 0x003cc605, "bit": 3 },
    13: { "addr": 0x003cc605, "bit": 4 },
    14: { "addr": 0x003cc605, "bit": 5 },
    15: { "addr": 0x003cc605, "bit": 6 },
    16: { "addr": 0x003cc605, "bit": 7 },
    17: { "addr": 0x003cc606, "bit": 0 },
    18: { "addr": 0x003cc606, "bit": 1 },
    19: { "addr": 0x003cc606, "bit": 2 },
    20: { "addr": 0x003cc606, "bit": 3 },
    21: { "addr": 0x003cc606, "bit": 4 },
    22: { "addr": 0x003cc606, "bit": 5 },
    23: { "addr": 0x003cc606, "bit": 6 },
    24: { "addr": 0x003cc606, "bit": 7 },
    25: { "addr": 0x003cc609, "bit": 0 },
    26: { "addr": 0x003cc609, "bit": 1 },
    27: { "addr": 0x003cc609, "bit": 2 },
    28: { "addr": 0x003cc60a, "bit": 0 },
    29: { "addr": 0x003cc60a, "bit": 1 },
    30: { "addr": 0x003cc60a, "bit": 2 },
    31: { "addr": 0x003cc60a, "bit": 3 },
    32: { "addr": 0x003cc60a, "bit": 4 },
    33: { "addr": 0x003cc60a, "bit": 5 },
    34: { "addr": 0x003cc60a, "bit": 6 },
    35: { "addr": 0x003cc60a, "bit": 7 },
    36: { "addr": 0x003cc60b, "bit": 0 },
    37: { "addr": 0x003cc60b, "bit": 1 },
    38: { "addr": 0x003cc60b, "bit": 4 },
    39: { "addr": 0x003cc60b, "bit": 5 },
    40: { "addr": 0x003cc60b, "bit": 6 },
    41: { "addr": 0x003cc60b, "bit": 7 }
}
GenerateCheevoFromBits(name = "Legendary Atlas", description = "Collect all Treasure Charts.", points = 10, id = 445530, badge = "505461",
    addresses = treasureChartBitflags,
    oneAtATime = true
)

function boomerangSlot() => byte(0x003cc571)
achievement(title = "Back at Ya...Fivefold!", description = "Obtain the Boomerang.", points = 3, type = "progression", id = 439030, badge = "500818",
    trigger = IsValueSetInGame(boomerangSlot(), 0xff, 0x2d)
)

function nintendoGalleryOpenedDynamic() => bit6(0x003cccb4)
function nintendoGalleryOpenedStatic() => bit6(0x003cc8bc)
achievement(title = "Scalpers, Beware", description = "Gain access to the Nintendo Gallery.", points = 3, id = 439031, badge = "500819",
    trigger = WasBitflagJustSetInGame(nintendoGalleryOpenedDynamic()) && nintendoGalleryOpenedStatic() == 0
        && IsInAreaByInternalName("sea")
)

function walletUpgradesObtained() => byte(0x003cc542)
achievement(title = "Silver Status", description = "Obtain the first wallet upgrade.", points = 5, id = 439032, badge = "500820",
    trigger = WasValueJustSetInGame(walletUpgradesObtained(), 0, 1)
)

function dialogueState() => bit4(0x003d21fb)
function IsInDialogue() => dialogueState() == 1
function HideAndSeekQuestActive() => bit6(0x003cd688)
function HideAndSeekStarted() => once(messageId() == 0x26cf) && !IsInDialogue() && never(HideAndSeekCompleted()) // "Goooooo!!!"
function CaughtJunRoberto() => bit2(0x003cd688) == 1
function CaughtJan() => bit3(0x003cd688) == 1
function CaughtJin() => bit4(0x003cd688) == 1
function CaughtIvan() => bit5(0x003cd688) == 1
function HideAndSeekCompleted() => CaughtJunRoberto() && CaughtJan() && CaughtJin() && CaughtIvan() && Delta(HideAndSeekQuestActive()) == 1 && HideAndSeekQuestActive() == 0
function HideAndSeekCanceled() => !IsInArea("Windfall Island") || IsInAreaByInternalName("sea_T")
function systemTimer() => dword_be(0x003a99f8)
function FrameAdvanced() => Delta(systemTimer()) + 1 == systemTimer()
function FrameAdvancedDuringHideAndSeek() => FrameAdvanced() && !IsInDialogue() && !IsPaused()
function IsPaused() => bit0(0x003d2132) == 1
leaderboard(title = "Hide-and-Seek", description = "Catch all the Killer Bees as quickly as you can without going indoors or leaving Windfall Island.", id = 105468,
    start = HideAndSeekStarted() && never(HideAndSeekCanceled()),
    cancel = HideAndSeekCanceled(),
    submit = HideAndSeekCompleted(),
    value = tally(0, FrameAdvancedDuringHideAndSeek(), FrameAdvancedDuringHideAndSeek()),
    format = "FRAMES",
    lower_is_better = true
)

function gaveBirthdayPresent() => bit0(0x003ccc14)
achievement(title = "Teacher of the Year", description = "Give Mrs. Marie a birthday present.", points = 3, id = 439033, badge = "500821",
    trigger = WasBitflagSetInGame(gaveBirthdayPresent()) && !IsInDialogue()
)

function bottle1Slot() => byte(0x003cc57a)
function bottle2Slot() => byte(0x003cc57b)
function bottle3Slot() => byte(0x003cc57c)
function bottle4Slot() => byte(0x003cc57d)
achievement(title = "Seeds of Nightshade", description = "Get a bottle of Blue Potion after trading in Boko Baba Seeds.", points = 3, id = 439048, badge = "506608",
    trigger = IsInAreaByInternalName("Ocrogh") && (
        Delta(bottle1Slot()) != 0x53 && bottle1Slot() == 0x53
        || Delta(bottle2Slot()) != 0x53 && bottle2Slot() == 0x53
        || Delta(bottle3Slot()) != 0x53 && bottle3Slot() == 0x53
        || Delta(bottle4Slot()) != 0x53 && bottle4Slot() == 0x53
    )
)

niko2TimeLimit = 45
niko2MaxTime = 0xbb8
function WithinRopeTimeLimit() => Niko2TimeElapsed() <= SecondsToFrames(niko2TimeLimit)
function Niko2TimeElapsed() => (niko2MaxTime - tetraPlatformTimeRemaining()) * 2
function TetraPlatformsAreUp() => bit0(tetraPlatformPointer() + 0x800001bb) == 1
function NinjaWarriorIIChallengeActive() => TetraPlatformsAreUp() && enteredCorrectPassword() == 1 && IsInAreaByInternalName("Asoko")
function CompletedSecondObstacleCourse() => once(messageId() == 0x1b28)
achievement(title = "Ninja Warrior II", points = 25, description = "Complete Niko's second obstacle course within " + SecondsToFormat(niko2TimeLimit) + ".", type = "missable",
    id = 439034, badge = "500822",
    trigger = trigger_when(NinjaWarriorIIChallengeActive() && TetraPlatformTimerFrozen()) && WithinRopeTimeLimit() && never(CompletedSecondObstacleCourse())
        && enteredCorrectPassword() == 1 // This line is needed to hide the challenge indicator. Kinda h
)

leaderboard(title = "Ninja Warrior II", description = "Reach the end of Niko's second obstacle course as quickly as you can.", id = 105469,
    start = NinjaWarriorIIChallengeActive() && never(CompletedSecondObstacleCourse()),
    cancel = !NinjaWarriorIIChallengeActive(),
    submit = NinjaWarriorIIChallengeActive() && TetraPlatformTimerFrozen(),
    value = Niko2TimeElapsed(),
    format = "FRAMES",
    lower_is_better = true
)

function bombCapacity() => byte(0x003cc5a0)
achievement(title = "Gunboat Diplomacy", description = "Be able to carry 99 bombs.", points = 10, id = 439035, badge = "500823",
    trigger = WasValueSetInGame(bombCapacity(), 0x3c, 0x63)
)

function totgIsAvailable() => bit0(0x003cc8cb)
achievement(title = "From the Sea to the Heavens", description = "Reveal the Tower of the Gods.", points = 3, id = 439036, badge = "500824", type = "progression",
    trigger = WasBitflagSetInGame(totgIsAvailable())
)

function totgMinibossDefeated() => bit4(0x003cccad)
achievement(title = "Familiar Tactics...", description = "Defeat the Darknut in the Tower of the Gods without using a sword, save for a single parry attack.", type = "missable", points = 5,
    id = 439037, badge = "500825",
    trigger = once(WasJustInAreaByKey("TotG2FLeftCorridor") && IsInAreaByKey("TotG2FMiniboss") && totgMinibossDefeated() == 0)
        && trigger_when(WasBitflagJustSetInGame(totgMinibossDefeated()))
        && never(!IsInAreaByKey("TotG2FMiniboss"))
        && never(tally(2, WasValueJustSetInGame(swordAnimationId(), 0, 0xf) || WasValueJustSetInGame(swordAnimationId(), 0, 0x5)))
        && never(swordAnimationId() != 0 && swordAnimationId() != 5 && swordAnimationId() != 0xf)
)

function bowSlot() => byte(0x003cc578)
achievement(title = "A Bowyer's Wrath", description = "Obtain the Hero's Bow.", points = 3, type = "progression", id = 439038, badge = "500826",
    trigger = IsValueSetInGame(bowSlot(), 0xff, 0x27)
)

function swordEquipped() => byte(0x003cc53e)
achievement(title = "The Successor", description = "Obtain the Master Sword.", points = 10, type = "progression", id = 439039, badge = "500827",
    trigger = IsValueSetInGame(swordEquipped(), 0x38, 0x39)
)

function balladOfGalesObtained() => bit1(0x003cc5ed)
achievement(title = "The Voice of Boreas", description = "Learn the Ballad of Gales.", points = 3, id = 439040, badge = "500829",
    trigger = WasBitflagSetInGame(balladOfGalesObtained())
)

function xCoord() => float_be(0x003ebd34)
function zCoord() => float_be(0x003ebd3c)
function blackBarState() => byte(0x003a9a49)
function enemyMusicPointer() => dword_be(0x003a9a54)
function BlackBarsJustDisappeared() => Delta(blackBarState()) > 0 && blackBarState() == 0
function BlackBarsArePresent() => blackBarState() == 5
function PhantomGanonCheckpointReached() => once(!IsInDialogue() && IsInAreaByKey("FFSea") && Delta(enemyMusicPointer()) == 0 && enemyMusicPointer() != 0
    && !PhantomGanonDefeated() && xCoord() == -300306.0 && zCoord() == -303407.0)
function phantomGanonPointer() => dword_be(0x003c1648) & 0x7FFFFFFF
function PhantomGanonDefeated() => bit2(0x003cccb2) == 1
function lLetterboxState() => byte(0x003d1d52)
function lTargetingState() => byte(0x003d1d50)
function IsLTargeting() => lLetterboxState() == 2 && lTargetingState() == 1
function xItem() => byte(0x003cc539)
function yItem() => byte(0x003cc53a)
function zItem() => byte(0x003cc53b)
function BottleIsEquipped() => 
    xItem() == 0xe || yItem() == 0xe || zItem() == 0xe
    || xItem() == 0xf || yItem() == 0xf || zItem() == 0xf
    || xItem() == 0x10 || yItem() == 0x10 || zItem() == 0x10
    || xItem() == 0x11 || yItem() == 0x11 || zItem() == 0x11

function IsItemEquipped(id) => xItem() == id || yItem() == id || zItem() == id

function hp() => word_be(0x003cc532)
achievement(title = "Eyes off the Prize", description = "Defeat Phantom Ganon in the Forsaken Fortress without L-Targeting or equipping a bottle, and without being resurrected.",
    points = 5,
    id = 439041, badge = "500830", type = "missable",
    trigger = PhantomGanonCheckpointReached() && trigger_when(PhantomGanonDefeated()) && never(IsLTargeting())
        && never(BottleIsEquipped())
        && never(hp() <= 0)
        && never(IsTransitioningToAreaByInternalName("sea_T"))
)

function maxArrowCapacity() => byte(0x003cc59f)
achievement(title = "Adept Archery", description = "Be able to carry 60 arrows.", points = 3, id = 439042, badge = "500831",
    trigger = WasValueSetInGame(maxArrowCapacity(), 30, 60)
)

GenerateCheevoFromBufferBits(name = "Pirate Wannabe", description = "Claim the treasure from all 7 submarines.", points = 5, id = 439043, badge = "500832",
    onlyAvailableWhen = IsInAreaByInternalName("Abship") && Delta(stageId()) == 0xa,
    addresses = {
        1: { "buffer": { "addr": 0x003cccab, "bit": 0, "stage": 0xa }, "static": { "addr": 0x003cca1b, "bit": 0 } },
        2: { "buffer": { "addr": 0x003cccab, "bit": 1, "stage": 0xa }, "static": { "addr": 0x003cca1b, "bit": 1 } },
        3: { "buffer": { "addr": 0x003cccab, "bit": 2, "stage": 0xa }, "static": { "addr": 0x003cca1b, "bit": 2 } },
        4: { "buffer": { "addr": 0x003cccab, "bit": 3, "stage": 0xa }, "static": { "addr": 0x003cca1b, "bit": 3 } },
        5: { "buffer": { "addr": 0x003cccab, "bit": 4, "stage": 0xa }, "static": { "addr": 0x003cca1b, "bit": 4 } },
        6: { "buffer": { "addr": 0x003cccab, "bit": 6, "stage": 0xa }, "static": { "addr": 0x003cca1b, "bit": 6 } },
        7: { "buffer": { "addr": 0x003cccab, "bit": 7, "stage": 0xa }, "static": { "addr": 0x003cca1b, "bit": 7 } }
    }
)

function bowSlot() => byte(0x003cc578)
achievement(title = "Diametrically Opposed", description = "Obtain the Fire and Ice Arrows.", points = 3, id = 439044, badge = "502206",
    trigger = WasValueSetInGame(bowSlot(), 0x27, 0x35)
)

GenerateCheevoFromBits(name = "Distinguished Apothecary", description = "Expand the inventory of the Chu Jelly Juice Shop to three different types of potions.", points = 5, id = 439045,
    badge = "500834", type = "missable",
    addresses = {
        1: { "addr": 0x003ccb61, "bit": 1 }, // Blue Potion
        2: { "addr": 0x003ccb61, "bit": 2 } // Green Potion
    },
    oneAtATime = true
)

function readLetterFromAryll() => bit0(0x003ccbdf)
achievement(title = "Warmest Regards", description = "Receive a letter from Aryll.", points = 1, id = 439046, badge = "500835",
    trigger = WasBitflagSetInGame(readLetterFromAryll())
)

function songOfPassingObtained() => bit5(0x003cc5ed)
achievement(title = "From Dusk 'til Dawn", description = "Learn the Song of Passing.", points = 3, id = 439047, badge = "500836",
    trigger = WasBitflagSetInGame(songOfPassingObtained())
)

function deliveryBagBaseAddr() => 0x003cc5b6
deliveryBagSlotAddrs = []
for i in range(0, 7)
{
    array_push(deliveryBagSlotAddrs, deliveryBagBaseAddr() + i)
}

// No bitflag exists for the conclusion of this sidequest. The game clearly assumes that there's only one Moblin letter in the game,
// so hacking more in will let you farm for more Pieces of Heart, hilariously enough.
function LetterFromMoeWasJustRemovedFromBag()
{
    trigger = always_false()
    for slot in deliveryBagSlotAddrs
    {
        trigger = trigger || WasValueJustSetInGame(byte(slot), 0x9b, 0xff)
    }
    
    return trigger
}

function ironBootsSlot() => byte(0x003cc575)
achievement(title = "Anchors Aweigh!", description = "Obtain the Iron Boots.", points = 3, id = 439217, badge = "500837",
    trigger = WasValueSetInGame(ironBootsSlot(), 0xff, 0x29)
)

function ironBootsChest() => bit1(0x003cccab)
function currentTimerType() => dword_be(0x003d221c)
function currentTimerElapsedTime() => dword_be(0x003d2214)
function currentTimerExpiry() => dword_be(0x003d2218)
function IronBootsTimerJustBecameActive() => currentTimerType() == 3 && Delta(currentTimerType()) == 0xffffffff
function IronBootsChallengeHasStarted() => once(IsInAreaByKey("IceRingIsleOverworld") && IronBootsTimerJustBecameActive())
function ironBootsTimeLimitInSeconds() => 75
function IronBootsChallengeCompleted() => WasBitflagSetInGame(ironBootsChest())
function IronBootsChallengeFailed() => currentTimerElapsedTime() >= ironBootsTimeLimitInSeconds() * 1000
function IronBootsChallengeCanceled() => currentTimerExpiry() == 0 && Delta(currentTimerExpiry()) > 0
function ShouldResetIronBootsChallenge() => !WasJustInAreaByKey("IceRingIsleOverworld") && IsInAreaByKey("IceRingIsleOverworld") || IronBootsChallengeCanceled()
achievement(title = "Run off the Cold", description = "Open the chest that contains the Iron Boots within " + SecondsToFormat(ironBootsTimeLimitInSeconds()) + " of thawing Ice Ring Isle.",
    points = 10, type = "missable", id = 439219, badge = "500838",
    trigger = IronBootsChallengeHasStarted() && trigger_when(IronBootsChallengeCompleted())
        && never(IronBootsChallengeFailed())
        && never(ShouldResetIronBootsChallenge())
)

leaderboard(title = "Run off the Cold", description = "Open the chest that contains the Iron Boots as quickly as you can.", id = 105485,
    start = IronBootsChallengeHasStarted() && never(ShouldResetIronBootsChallenge()),
    cancel = ShouldResetIronBootsChallenge(),
    submit = IronBootsChallengeCompleted() && never(ShouldResetIronBootsChallenge()),
    value = currentTimerElapsedTime() / 10,
    format = "MILLISECS",
    lower_is_better = true
)

function boatingCourseTimeLimit() => 105
function boatingCourseStatus() => byte(0x003d220e)
function BoatingCourseChallengeHasStarted() => once(currentTimerType() == 2 && Delta(currentTimerType()) == 0xffffffff && IsInAreaByInternalName("Ocean"))
function BoatingCourseChallengeCompleted() => boatingCourseStatus() == 1 && minigameScore() == 150
function BoatingCourseChallengeFailed() => currentTimerElapsedTime() >= boatingCourseTimeLimit() * 1000
function minigameScore() => word_be(0x003d220c)
achievement(title = "Racing for Rupees", description = "Complete a perfect boating course run within " + SecondsToFormat(boatingCourseTimeLimit()) + ".", points = 10, id = 439218,
    badge = "500842",
    trigger = BoatingCourseChallengeHasStarted() && trigger_when(BoatingCourseChallengeCompleted())
        && never(BoatingCourseChallengeFailed()) && never(!IsInAreaByInternalName("Ocean"))
)

leaderboard(title = "Racing for Rupees", description = "Complete a perfect boating course run as quickly as you can.", id = 105484,
    start = BoatingCourseChallengeHasStarted() && never(currentTimerType() == 0xffffffff),
    cancel = IronBootsChallengeCanceled(),
    submit = BoatingCourseChallengeCompleted(),
    value = currentTimerElapsedTime() / 10,
    format = "MILLISECS",
    lower_is_better = true
)

function JustLeftDialogue() => dialogueState() < Delta(dialogueState())
GenerateCheevoFromBits(name = "Totems of the Forest", description = "Obtain all Nintendo Gallery figurines in the Forest Haven room.", points = 10,
    onlyAvailableWhen = once(DisplayingMessageWithId(0x364d)) && JustLeftDialogue() && never(!IsInAreaByInternalName("Pfigure")), id = 439220, badge = "500843",
    addresses = {
        1: { "addr": 0x003ccbf0, "bit": 0 }, // Irch
        2: { "addr": 0x003ccbf0, "bit": 1 }, // Rown
        3: { "addr": 0x003ccbf0, "bit": 2 }, // Hollo
        4: { "addr": 0x003ccbf0, "bit": 3 }, // Elma
        5: { "addr": 0x003ccbf0, "bit": 4 }, // Linder
        6: { "addr": 0x003ccbf0, "bit": 5 }, // Great Deku Tree
        7: { "addr": 0x003ccbf0, "bit": 6 }, // Carlov
        8: { "addr": 0x003ccbf0, "bit": 7 }, // Manny
        9: { "addr": 0x003ccc05, "bit": 3 }, // Makar
        10: { "addr": 0x003ccc05, "bit": 4 }, // Olivio
        11: { "addr": 0x003ccc05, "bit": 5 }, // Aldo
        12: { "addr": 0x003ccc05, "bit": 6 }, // Oakin
        13: { "addr": 0x003ccc05, "bit": 7 }, // Drona
        14: { "addr": 0x003ccbd8, "bit": 0 }, // Fado
    }
)

GenerateCheevoFromBits(name = "Great Sea Glaze", type = "missable", description = "Obtain all Nintendo Gallery figurines in the Great Sea room via pictographs.",
    points = 10, id = 439221, badge = "500844",
    onlyAvailableWhen = once(DisplayingMessageWithId(0x364d)) && JustLeftDialogue() && never(!IsInAreaByInternalName("Pfigure")),
    addresses = {
        2: { "addr": 0x003ccbe2, "bit": 0 }, // Salvatore
        3: { "addr": 0x003ccbe2, "bit": 1 }, // Loot the Sailor
        4: { "addr": 0x003ccbe2, "bit": 2 }, // Salvage Corp.
        5: { "addr": 0x003ccbe2, "bit": 3 }, // Fairy   
        6: { "addr": 0x003ccbe2, "bit": 4 }, // Great Fairy
        7: { "addr": 0x003ccbe2, "bit": 5 }, // Queen of Fairies
        8: { "addr": 0x003ccbe2, "bit": 6 }, // Princess Zelda
        9: { "addr": 0x003ccbe2, "bit": 7 }, // King of Hyrule
        10: { "addr": 0x003ccbe3, "bit": 0 }, // Tingle
        11: { "addr": 0x003ccbe3, "bit": 1 }, // Ankle
        12: { "addr": 0x003ccbe3, "bit": 2 }, // Knuckle
        13: { "addr": 0x003ccbe3, "bit": 3 }, // David, Jr.
        14: { "addr": 0x003ccbe3, "bit": 4 }, // Fishman
        15: { "addr": 0x003ccbe3, "bit": 5 }, // Traveling Merchants
        16: { "addr": 0x003ccbe3, "bit": 6 }, // Old Man Ho Ho
        17: { "addr": 0x003ccbe3, "bit": 7 }, // Beedle
        18: { "addr": 0x003ccbe4, "bit": 1 }, // Tetra
        19: { "addr": 0x003ccbe4, "bit": 2 }, // Gonzo
        20: { "addr": 0x003ccbe4, "bit": 3 }, // Senza
        21: { "addr": 0x003ccbe4, "bit": 4 }, // Nudge
        22: { "addr": 0x003ccbe4, "bit": 5 }, // Zuko
        23: { "addr": 0x003ccbe4, "bit": 6 }, // Niko
        24: { "addr": 0x003ccbe4, "bit": 7 }, // Mako
    }
)

GenerateCheevoFromBits(name = "Busts from the Beginning", description = "Obtain all Nintendo Gallery figurines in the Outset Island room.", points = 10, id = 439222, badge = "500845",
    onlyAvailableWhen = once(DisplayingMessageWithId(0x364d)) && JustLeftDialogue() && never(!IsInAreaByInternalName("Pfigure")),
    addresses = {
        1: { "addr": 0x003ccbe8, "bit": 0 }, // Joel
        2: { "addr": 0x003ccbe8, "bit": 1 }, // Zill
        3: { "addr": 0x003ccbe8, "bit": 2 }, // Jabun
        4: { "addr": 0x003ccbe8, "bit": 3 }, // Wild Pig
        5: { "addr": 0x003ccbe8, "bit": 4 }, // Seagull
        6: { "addr": 0x003ccbe8, "bit": 5 }, // Crab
        7: { "addr": 0x003ccbe9, "bit": 0 }, // Aryll
        8: { "addr": 0x003ccbe9, "bit": 1 }, // Grandma
        9: { "addr": 0x003ccbe9, "bit": 2 }, // Sue-Belle
        10: { "addr": 0x003ccbe9, "bit": 3 }, // Sturgeon
        11: { "addr": 0x003ccbe9, "bit": 4 }, // Orca
        12: { "addr": 0x003ccbe9, "bit": 5 }, // Abe
        13: { "addr": 0x003ccbe9, "bit": 6 }, // Rose
        14: { "addr": 0x003ccbe9, "bit": 7 }, // Mesa
    }
)

GenerateCheevoFromBits(name = "Effigies of My Foes", description = "Obtain all Nintendo Gallery figurines in the enemies room.", points = 10, id = 439223, badge = "500846",
    onlyAvailableWhen = once(DisplayingMessageWithId(0x364d)) && JustLeftDialogue() && never(!IsInAreaByInternalName("Pfigure")),
    addresses = {
        1: { "addr": 0x003ccbd6, "bit": 0 }, // ReDead
        2: { "addr": 0x003ccbd6, "bit": 1 }, // Octorok
        3: { "addr": 0x003ccbd6, "bit": 2 }, // Seahat
        4: { "addr": 0x003ccbd6, "bit": 3 }, // Gyorg
        5: { "addr": 0x003ccbd7, "bit": 0 }, // Peahat
        6: { "addr": 0x003ccbd7, "bit": 1 }, // Boko Baba
        7: { "addr": 0x003ccbd7, "bit": 2 }, // Morth
        8: { "addr": 0x003ccbd7, "bit": 3 }, // Red Bubble and Blue Bubble
        9: { "addr": 0x003ccbd7, "bit": 4 }, // Floormaster
        10: { "addr": 0x003ccbd7, "bit": 5 }, // Armos
        11: { "addr": 0x003ccbd7, "bit": 6 }, // Armos Knight
        12: { "addr": 0x003ccbd7, "bit": 7 }, // Poe
        13: { "addr": 0x003ccbd8, "bit": 1 }, // Bokoblin
        14: { "addr": 0x003ccbd8, "bit": 2 }, // Miniblin
        15: { "addr": 0x003ccbd8, "bit": 3 }, // Chu Chu
        16: { "addr": 0x003ccbd8, "bit": 4 }, // Rat
        17: { "addr": 0x003ccbd8, "bit": 5 }, // Keese and Fire Keese
        18: { "addr": 0x003ccbd8, "bit": 6 }, // Magtail
        19: { "addr": 0x003ccbd8, "bit": 7 }, // Kargaroc
    }
)

function swordTrainingHitsRemaining() => byte(0x003fe37d)
function IsInSwordTrainingWithOrca() => byte(0x003fe8e4) == 1
function FirstIntentionCheckpointReached() => once(swordTrainingHitsRemaining() == 3 && IsInSwordTrainingWithOrca() && IsInAreaByInternalName("Ojhous"))
achievement(title = "First Intention", description = "Score 1,000 hits on Orca during sword training.", points = 5, id = 444192, badge = "500847",
    trigger = FirstIntentionCheckpointReached() && trigger_when(minigameScore() >= 1000)
        && never(swordTrainingHitsRemaining() == 0 && Delta(swordTrainingHitsRemaining()) == 1)
        && never(!IsInAreaByInternalName("Ojhous"))
)

function learnedHurricaneSpin() => bit5(0x03ccb5f)
achievement(title = "Like a Record, Baby", description = "Learn the Hurricane Spin.", points = 3, id = 444198, badge = "500848",
    trigger = WasBitflagSetInGame(learnedHurricaneSpin()) && DisplayingMessageWithId(0x10f)
)

function baitoMotherLetterProgress() => byte(0x003ccc00)
achievement(title = "A Mother's Thanks", description = "Receive a letter from the mother of Baito, the part-time mail sorter on Dragon Roost Island.", points = 1, id = 444185,
    badge = "500851",
    trigger = WasValueSetInGame(baitoMotherLetterProgress(), 2, 3)
)

GenerateCheevoFromConditions(
    name = "Boukalophile",
    description = "Collect all 4 bottles.",
    points = 10,
    id = 444189,
    badge = "500852",
    conditions = {
        1: { "countsWhen": (bottle1Slot() != 0xff), "recalculateWhen": (Delta(bottle1Slot()) == 0xff && bottle1Slot() == 0xff) },
        2: { "countsWhen": (bottle2Slot() != 0xff), "recalculateWhen": (Delta(bottle2Slot()) == 0xff && bottle1Slot() == 0xff) },
        3: { "countsWhen": (bottle3Slot() != 0xff), "recalculateWhen": (Delta(bottle3Slot()) == 0xff && bottle1Slot() == 0xff) },
        4: { "countsWhen": (bottle4Slot() != 0xff), "recalculateWhen": (Delta(bottle4Slot()) == 0xff && bottle1Slot() == 0xff) },
    }
)

function numberOfBombs() => byte(0x003cc59a)
function numberOfArrows() => byte(0x003cc599)
function grapplingHookInUse() => bit1(0x003d21f9)
function boomerangLaunched() => bit6(0x003d21f9)
function mp() => byte(0x003cc544)
function EarthTempleMinibossCheckpointReached() => once(Delta(staticRoomId()) == 7 && WasJustInAreaByInternalName("M_Dai", true) && staticRoomId() == 7 && IsInAreaByInternalName("M_DaiMB")
    && earthTempleMinibossDefeated() == 0)
function earthTempleMinibossDefeated() => bit0(0x003cccb0)
achievement(title = "Skull Crusher", description = "Defeat the miniboss of the Earth Temple using only the Skull Hammer and without being resurrected.",
    points = 10, type = "missable",
    id = 444199, badge = "502208",
    trigger = EarthTempleMinibossCheckpointReached() && trigger_when(WasBitflagSetInGame(earthTempleMinibossDefeated()))
        && swordActionPointer() != 0 && never(Delta(numberOfBombs()) > numberOfBombs()) && never(Delta(numberOfArrows()) > numberOfArrows())
        && never(swordAnimationId() != 0x12 && swordAnimationId() != 0x11 && swordAnimationId() != 0x13 && swordAnimationId() != 0)
        && never(grapplingHookInUse() == 1) && never(boomerangLaunched() == 1)
        && never(!IsInAreaByInternalName("M_DaiMB"))
        && never(hp() <= 0)
)

function currentShield() => byte(0x003cc53f)
achievement(title = "Under the Gods' Aegis", description = "Obtain the Mirror Shield.", points = 3, id = 444204, badge = "500855", type = "progression",
    trigger = WasValueSetInGame(currentShield(), 0x3b, 0x3c)
)

function learnedWindGodAria() => bit4(0x003cc5ed)
achievement(title = "Fado's Fate", description = "Learn the Wind God's Aria.", points = 3, id = 444191, badge = "500856", type = "progression",
    trigger = WasBitflagSetInGame(learnedWindGodAria()) && never(stageId() == 8) // We need to check for the stage ID here because, otherwise, it would trigger in Ganon's Tower.
)

function shopPoints() => byte(0x003ccbda)
achievement(title = "Indulgent Shopper", description = "Earn a Gold Membership from Beedle's Shop Ship.", points = 10, id = 444195, badge = "500857",
    trigger = WasValueSetInGame(shopPoints(), 0x3b, 0x3c)
)

GenerateCheevoFromBufferBits(name = "Gifts from the Wind", description = "Open all treasure chests in the Wind Temple.", points = 10, id = 444193, badge = "500858",
    onlyAvailableWhen = IsInAreaByInternalName("kaze") && Delta(stageId()) == 0x7,
    addresses = {
        1: { "buffer": { "addr": 0x003cccaa, "bit": 0, "stage": 0x7 }, "static": { "addr": 0x003cc9ae, "bit": 0 } },
        2: { "buffer": { "addr": 0x003cccaa, "bit": 1, "stage": 0x7 }, "static": { "addr": 0x003cc9ae, "bit": 1 } },
        3: { "buffer": { "addr": 0x003cccaa, "bit": 2, "stage": 0x7 }, "static": { "addr": 0x003cc9ae, "bit": 2 } },
        4: { "buffer": { "addr": 0x003cccaa, "bit": 3, "stage": 0x7 }, "static": { "addr": 0x003cc9ae, "bit": 3 } },
        5: { "buffer": { "addr": 0x003cccaa, "bit": 4, "stage": 0x7 }, "static": { "addr": 0x003cc9ae, "bit": 4 } },
        6: { "buffer": { "addr": 0x003cccaa, "bit": 5, "stage": 0x7 }, "static": { "addr": 0x003cc9ae, "bit": 5 } },
        7: { "buffer": { "addr": 0x003cccaa, "bit": 7, "stage": 0x7 }, "static": { "addr": 0x003cc9ae, "bit": 7 } },
        8: { "buffer": { "addr": 0x003cccab, "bit": 0, "stage": 0x7 }, "static": { "addr": 0x003cc9af, "bit": 0 } },
        9: { "buffer": { "addr": 0x003cccab, "bit": 2, "stage": 0x7 }, "static": { "addr": 0x003cc9af, "bit": 2 } },
        10: { "buffer": { "addr": 0x003cccab, "bit": 3, "stage": 0x7 }, "static": { "addr": 0x003cc9af, "bit": 3 } },
        11: { "buffer": { "addr": 0x003cccab, "bit": 4, "stage": 0x7 }, "static": { "addr": 0x003cc9af, "bit": 4 } },
        12: { "buffer": { "addr": 0x003cccab, "bit": 5, "stage": 0x7 }, "static": { "addr": 0x003cc9af, "bit": 5 } },
        13: { "buffer": { "addr": 0x003cccab, "bit": 7, "stage": 0x7 }, "static": { "addr": 0x003cc9af, "bit": 7 } }
    }
)

function CreateHitTargetedAndNextChain(permutation)
{
    trigger = always_true()
    
    for condition in permutation
    {
        trigger = once(trigger && once(condition))
    }
    
    return trigger
}

function ironBootsStatus() => bit0(0x003a9a2e)
function TransitionedToWindTempleMinibossRoom() => once(staticRoomId() == 2 && WasJustInAreaByInternalName("kaze") && staticRoomId() == 2 && IsInAreaByInternalName("kazeMB"))
function WindTempleMinibossCheckpointReached() => once(TransitionedToWindTempleMinibossRoom() && hookshotChest() == 0 && !PhantomGanonDefeated())
function WindTempleMinibossDefeated() => Delta(enemyMusicPointer()) != 0 && enemyMusicPointer() == 0
function hookshotChest() => bit5(0x003cccab)
achievement(title = "Bound to Earth", description = "Defeat the miniboss of the Wind Temple with the Iron Boots equipped the entire time and without being resurrected.",
    points = 10, type = "missable",
    id = 444190, badge = "502209",
    trigger = WindTempleMinibossCheckpointReached() && trigger_when(WindTempleMinibossDefeated())
        && never(ironBootsStatus() == 0 && enemyMusicPointer() != 0)
        && never(hp() <= 0)
        && never(!IsInAreaByInternalName("kazeMB"))
        && never(IsTransitioningToAreaByInternalName("sea_T"))
)

achievement(title = "Hylia's Blessing", description = "Completely restore the Master Sword's power.", points = 5, type = "progression", id = 444194, badge = "500859",
    trigger = IsValueSetInGame(swordEquipped(), 0x3a, 0x3e)
)

function StartedSavageLabyrinth() => once(IsInAreaByInternalName("Cave09") && roomIdOnLoad() == 1 && Delta(roomIdOnLoad()) == 255)
function CompletedSavageLabyrinth() => CreateHitTargetedAndNextChain([ IsInAreaByInternalName("Cave10") && roomIdOnLoad() == 19, IsInAreaByInternalName("Cave10") && roomIdOnLoad() == 255,
    IsInAreaByInternalName("Cave10") && roomIdOnLoad() == 20 ])

achievement(title = "Through Fire and Water", description = "Complete the Savage Labyrinth.", points = 10, id = 444203, badge = "500860",
    trigger = CompletedSavageLabyrinth() && never(IsInAreaByInternalName("sea")) && never(IsInAreaByInternalName("sea_T"))
)

function TookGivenDamage(damage)
{
    conditions = []
    maxDamage = 9
    
    for i in range(1, maxDamage)
    {
        array_push(conditions, Delta(hp()) >= hp() + i)
    }
    
    return tally(damage, conditions)
}

function slChallengeHpLimit() => 60
achievement(title = "Lasting Trauma", description = "Complete the Savage Labyrinth without losing more than a total of " + slChallengeHpLimit() / 4
    + " hearts and without using magic.", points = 50,
    id = 444197, badge = "500861",
    trigger = StartedSavageLabyrinth() && trigger_when(CompletedSavageLabyrinth()) && never(IsInAreaByInternalName("sea")) && never(IsInAreaByInternalName("Cave09") && roomIdOnLoad() == 0)
        && never(TookGivenDamage(slChallengeHpLimit()))
        && never(Delta(mp()) > mp())
)

function heroCharmPossessed() => bit0(0x003cc5e8)
achievement(title = "The Face of a Champion", description = "Obtain the Hero's Charm.", points = 5, id = 444202, badge = "500862",
    trigger = WasBitflagSetInGame(heroCharmPossessed())
)

function slidePuzzlesCompleted() => byte(0x003cc6cf)
achievement(title = "Sliding Adept", description = "Complete 8 slide puzzles in the cabana.", points = 5, id = 444200, badge = "500864",
    trigger = WasValueSetInGame(slidePuzzlesCompleted(), 7, 8)
)

function enemyDeathBitflags() => dword_be(0x003cccd0)
function enemyDeathAndStatusBitflags() => byte(0x003cccd7)
function sharkIslandChestStatus() => bit4(0x003cccd7)
function sharkIslandHitLimit() => 10
function magicArmorId() => 0xa
achievement(title = "A Leaf in the Wind", type = "missable", description = "Clear the enemy gauntlet in the Shark Island grotto without getting hit " + sharkIslandHitLimit() + " times "
    + "and without using magic.",
    points = 25, id = 444184, badge = "505460",
    trigger = once(WasJustInAreaByInternalName("ITest63") && IsInAreaByInternalName("ITest63") && enemyDeathBitflags() == 0 && enemyDeathAndStatusBitflags() == 0)
        && trigger_when(sharkIslandChestStatus() == 1)
        && never(!IsInAreaByInternalName("ITest63")) && never(repeated(sharkIslandHitLimit(), Delta(hp()) > hp()))
        && never(Delta(mp()) > mp())
)

function pigPieceOfHeartStatus() => bit2(0x003cccbf)
achievement(title = "Bait Marks the Spot", description = "Collect the rare treasure that the black pig can dig up on Outset Island.", points = 3, id = 444188, badge = "500865",
    trigger = WasBitflagJustSetInGame(pigPieceOfHeartStatus()) && IsInAreaByInternalName("sea")
        && Delta(stageId()) == 0
)

GenerateCheevoFromBits(name = "A Tree a Day Keeps the Oceans at Bay", description = "Cure all 8 withered tree sprouts within 20 minutes.", points = 5, id = 444186, badge = "500867",
    onlyAvailableWhen = IsInAreaByInternalName("sea"),
    addresses = {
        1: { "addr": 0x003ccbf2, "bit": 0 },
        2: { "addr": 0x003ccbf2, "bit": 1 },
        3: { "addr": 0x003ccbf2, "bit": 2 },
        4: { "addr": 0x003ccbf2, "bit": 3 },
        5: { "addr": 0x003ccbf2, "bit": 4 },
        6: { "addr": 0x003ccbf2, "bit": 5 },
        7: { "addr": 0x003ccbf2, "bit": 6 },
        8: { "addr": 0x003ccbf2, "bit": 7 },
    },
    oneAtATime = true
)

function lindaPieceOfHeartStatus() => bit7(0x003ccb76)
achievement(title = "Invisible, But Not Intangible", description = "Bring Anton and Linda together.", points = 5, id = 444196, badge = "500868",
    trigger = WasBitflagSetInGame(lindaPieceOfHeartStatus()) && !IsInDialogue()
)

function currentHighestBidder() => word_be(0x003d209e)
function PlayerIsHighestBidder() => once(currentHighestBidder() == 0x1ce9 && Delta(minigameScore()) < minigameScore() && never(currentHighestBidder() != 0x1ce9))
function maximumBid() => 75
achievement(title = "Lot Sniper", id = 448883, description = "Win an auction with a bid of 75 Rupees or less.", points = 5, badge = "506828", type = "missable",
    trigger = once(IsInAreaByInternalName("Orichh") && currentTimerExpiry() == 0xea60 && Delta(currentTimerExpiry()) == 0)
        && trigger_when(currentTimerElapsedTime() >= currentTimerExpiry() && Delta(currentTimerElapsedTime()) == 0xea60 && PlayerIsHighestBidder())
        && minigameScore() <= maximumBid()
        && never(!IsInAreaByInternalName("Orichh"))
)

function sqrDistanceFromOrigin() => xCoord() * xCoord() + zCoord() * zCoord()
function puppetGanonFightStatus() => bit3(0x003cccac)
function PuppetGanonFightStartedImmediately() => once(WasJustInAreaByInternalName("GanonL") && IsInAreaByInternalName("GanonK"))
function PuppetGanonFightStartedByCutscene() => once(WasBitflagSetInGame(puppetGanonFightStatus()) && stageId() == 8)
function puppetGanonDefeated() => bit2(0x003cccad)
achievement(title = "Ten Years at Sea", type = "missable", description = "Defeat Puppet Ganon without leaving the water.", points = 25, id = 444201, badge = "502211",
    trigger = trigger_when(WasBitflagSetInGame(puppetGanonDefeated()))
        && never(sqrDistanceFromOrigin() < 582169.0 || sqrDistanceFromOrigin() > 5776812.0 && sqrDistanceFromOrigin() <= 9000000.0)
        && never(!IsInAreaByInternalName("GanonK"))
        && (PuppetGanonFightStartedByCutscene() || PuppetGanonFightStartedImmediately())
)

function ganondorfDefeated() => bit0(0x003cccad)
function dialogueIndex() => dword_be(0x003fe838)
achievement(title = "As Dandelions", type = "win_condition", description = "Defeat Ganondorf and set sail for a new land.", points = 25, id = 444187, badge = "505459",
    trigger = CreateHitTargetedAndNextChain([ dialogueIndex() == 392 && IsInAreaByInternalName("GTower"), repeated(5000, !BlackBarsArePresent()) ])
        && never(!IsInAreaByInternalName("GTower"))
)

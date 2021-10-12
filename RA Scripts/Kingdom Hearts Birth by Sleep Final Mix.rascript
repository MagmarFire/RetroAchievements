// Kingdom Hearts Birth by Sleep
// #ID = 3556

function True() => 1
function False() => 0

function Delta(mem) => prev(mem)

function SecondsToFormat(value)
{
    leadingZero = ""
    if (value % 60 < 10)
    {
        leadingZero = "0"
    }
    return value / 60 + ":" + leadingZero + value % 60
}

function SecondsToFrames(seconds) => seconds * 60

function MergeArrays(arr1, arr2)
{
    newArr = arr1
    for i in arr2
    {
        array_push(newArr, i)
    }
    return newArr
}

// A cluster is defined as an array whose elements all differ by a single quantum value with at least one element.
// For instance, an array containing the values [ 1, 2, 3, 4, 6, 7, 9 ] has three clusters:
// [ 1, 2, 3, 4 ], [ 6, 7 ], and [ 9 ]
function GenerateClustersFromList(data)
{
    clusters = []
    currentElement = -1
    currentCluster = []
    for i in data
    {
        if (i == currentElement + 1 || currentElement == -1)
        {
            currentElement = i
            array_push(currentCluster, currentElement)
        }
        else
        {
            array_push(clusters, currentCluster)
            currentElement = i
            currentCluster = [ currentElement ]
        }
    }
    
    // Get the range we were just working on if it has elements.
    if (length(currentCluster) > 0)
    {
        array_push(clusters, currentCluster)
    }
    
    return clusters
}

function ConvertClustersToRanges(clusters)
{
    ranges = []
    
    for cluster in clusters
    {
        min = cluster[0]
        max = cluster[length(cluster) - 1]
        array_push(ranges, { "min": min, "max": max })
    }
    
    return ranges
}

function GetClustersFromList(list)
{
    return ConvertClustersToRanges(GenerateClustersFromList(list))
}

function GetIdsFromObjects(objects)
{
    ret = []
    
    for object in objects
    {
        array_push(ret, object["id"])
    }
    
    return ret
}

function DictionaryKeyExists(dict, key)
{
    for i in dict
    {
        if (i == key)
        {
            return True()
        }
    }
    
    return False()
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
            if (DictionaryKeyExists(ret, element["addr"]) == True())
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

// This function allows the creation of achievements with built-in save protection that deal with a collection of values being set
// throughout the game. The schemas for both parameters are as follows:
//
// name: title
// description: self-explanatory
// points: self-explanatory
// threshold: how many values in the "conditions" dictionary must be set before this achievement is triggered
// addresses: a list of address accessors that need to have their bits summed (each address must have an "addr" and "bit" value in order to be properly aggregated)
// onlyAvailableWhen: a condition that must be true in all conditions for the achievement to trigger.
// id: self-explanatory
// badge: self-explanatory
function GenerateCheevoFromBits(name, description, points, threshold, addresses, onlyAvailableWhen = always_true(), id = 0, badge = "00000")
{
    bitcounts = GenerateBitcountFromCountableObjects(GetCountableAccessorArrayFromAddressBits(addresses))

    // This is the score when the game is loaded. If the loaded score is greater than or equal to the threshold--that is,
    // if the save file would satisfy enough conditions to trigger the achievement on load--this should trigger a
    // permanant pauselock to serve as save protection.
    shouldTriggerPauselock = once(bitcounts >= threshold && GameJustLoaded())
    
    // We want both loaded and session counts here (that is, we don't care if we're loading a save file when these are tallied).
    // This way, loading a save doesn't invalidate the achievement outright if a player hasn't actually earned it yet.
    trigger = bitcounts >= threshold

    achievement(title = name, description = description, points = points, badge = badge, id = id,
        trigger = IsInGame() && measured(trigger) && unless(shouldTriggerPauselock) && onlyAvailableWhen
            && (always_false() || IsAlwaysInGame()) // Reset any potential pauselock when changing save files.
    )
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

function GenerateConditionFromBitflag(bit)
{
    return { "countsWhen": (bit == 1), "recalculateWhen": (Delta(bit) != bit) }
}

// $B47AC0: World ID
function worldId() => byte(0xB47AC0)

// $B47AC1: Room ID
function areaId() => byte(0xB47AC1)

function systemTimer() => dword(0x1f25ee0)

function saveState() => word(0xb5c1a0)

function IsAlwaysInGame() => never(IsInLocation("Title")) && never(saveState() != 0x0101)

function IsInGame() => !IsInLocation("Title")

function GameJustLoaded() => Delta(saveState()) != 0x0101 && saveState() == 0x0101

function WasValueSet(mem, oldValue, newValue)
{
    return once(IsValueJustSet(mem, oldValue, newValue))
}

function IsValueJustSet(mem, oldValue, newValue)
{
    return Delta(mem) == oldValue && mem == newValue
}

function WasValueIncreasedByAmount(mem, delta)
{
    return Delta(mem) + delta == mem
}

function WasValueSetInGame(mem, oldValue, newValue)
{
    return IsAlwaysInGame() && WasValueSet(mem, oldValue, newValue)
}

function WasValueIncreasedByAmountInGame(mem, delta)
{
    return IsAlwaysInGame() && WasValueIncreasedByAmount(mem, delta)
}

function WasBitflagSetInGame(mem)
{
    return WasValueSetInGame(mem, 0, 1)
}

// $1F2914A: First slot of the key item inventory (16-bit)
//           
//           Each value contains a key item ID. 0x0 when no item is in the slot.
//           
//           Every time the player views the inventory, the items in the buffer are "dumped" to the actual inventory, which appears to begin at another address.
function keyItemInventorySlot1Id() => word(0x1F2914A)

// $1F291AC: Last slot of the key item inventory (16-bit)
function keyItemInventoryLastSlotId() => word(0x1F291AC)

// $1F2927C: Bit 0: First chest in the Land of Departure
// $1F292A8: Bit 4: Earthshaker viewed in the inventory
// $1F29300: Bit 0: Wayfinder viewed in the inventory

// $1F29388: ID of the first command in the player's inventory (16-bit)
function slot1CommandID() => word(0x1F29388)

// $1F2938A: Level of the first command in the player's inventory (8-bit)
function slot1CommandLevel() => byte(0x1F2938A)

// $1F29392: ID of the second command in the player's inventory (16-bit)
function slot2CommandId() => word(0x1F29392)

// $1F2B91C: Index of the command equipped in Slot 1 (16-bit)
//           
//           Each index corresponds to a command instance in the player's inventory. 0xffff when there is no command installed in the slot.
function slot1CommandIndex() => word(0x1F2B91C)

// $1F2B922: Index of the command equipped in Slot 2 (16-bit)
function slot2CommandIndex() => word(0x1F2B922)

// $1F2B928: Index of the command equipped in Slot 3 (16-bit)
function slot3CommandIndex() => word(0x1F2B928)

// $1F2B92E: Index of the command equipped in Slot 4 (16-bit)
function slot4CommandIndex() => word(0x1F2B92E)

// $1F2B934: Index of the command equipped in Slot 5 (16-bit)
function slot5CommandIndex() => word(0x1F2B934)

function level() => byte(0x1f19b11)

function currentCharacter() => byte(0xb5a4bc)

function difficulty() => byte(0x1f25f01)

function IsAtLeastOnDifficulty(value)
{
    if (value == "Beginner")
    {
        return IsOnBeginnerMode()
    }
    else if (value == "Standard")
    {
        return difficulty() >= 0x1
    }
    else if (value == "Proud")
    {
        return difficulty() >= 0x2
    }
    else if (value == "Critical")
    {
        return difficulty() >= 0x3
    }
}

function numberOfActiveEnemies() => word(0xb47578)

// $1F35F80: Floods defeated (16-bit)
// $1F35F82: Scrappers defeated (16-bit)
// $1F35F84: Bruisers defeated (16-bit)
// $1F35F86: Red Hot Chilis defeated (16-bit)
// $1F35F88: Monotruckers defeated (16-bit)
// $1F35F8A: Thornbites defeated (16-bit)
// $1F35F8C: Shoegazers defeated (16-bit)
// $1F35F8E: Spiderchests defeated (16-bit)
// $1F35F90: Archravens defeated (16-bit)
// $1F35F92: Hareraisers defeated (16-bit)
// $1F35F94: Jellyshades defeated, part 1 (16-bit)
//           
//           The total is equal to the sum of this address and parts 2-4.
// $1F35F96: Jellyshades defeated, part 2 (16-bit)
//           
//           The total is equal to the sum of this address and parts 1, 3, and 4.
// $1F35F98: Jellyshades defeated, part 3 (16-bit)
//           
//           The total is equal to the sum of this address and parts 1, 2, and 4.
// $1F35F9A: Jellyshades defeated, part 4 (16-bit)
//           
//           The total is equal to the sum of this address and parts 1-3.
// $1F35F9C: Tank Topplers defeated (16-bit)
// $1F35F9E: Vile Phials defeated (16-bit)
// $1F35FA0: Sonic Blasters defeated, part 1 (16-bit)
//           
//           The total is equal to the sum of this address and 0x1f35fa2.
// $1F35FA2: Sonic Blasters defeated, part 2 (16-bit)
//           
//           The total is equal to the sum of this address and 0x1f35fa0.
// $1F35FA4: Triple Wreckers defeated, part 1 (16-bit)
//           
//           The total is equal to the sum of this and parts 2 and 3.
// $1F35FA6: Triple Wreckers defeated, part 2 (16-bit)
//           
//           The total is equal to the sum of this and parts 1 and 3.
// $1F35FA8: Triple Wreckers defeated, part 3 (16-bit)
//           
//           The total is equal to the sum of this and parts 1 and 2.
// $1F35FAA: Wild Bruisers defeated (16-bit)
// $1F35FAC: Blue Sea Salts defeated (16-bit)
// $1F35FAE: Yellow Mustards defeated (16-bit)
// $1F35FB0: Mandrakes defeated (16-bit)
// $1F35FB2: Buckle Bruisers defeated (16-bit)
// $1F35FB4: Chrono Twisters defeated (16-bit)
// $1F35FB6: Axe Flappers defeated (16-bit)
// $1F35FB8: Prize Pods defeated (16-bit)
// $1F35FBA: Glidewinders defeated, part 1 (16-bit)
//           
//           The total is the sum of the value of this address and parts 2 and 3.
// $1F35FBC: Glidewinders defeated, part 2 (16-bit)
//           
//           The total is the sum of the value of this address and parts 1 and 3.
// $1F35FBE: Glidewinders defeated, part 3 (16-bit)
//           
//           The total is the sum of the value of this address and parts 1 and 2.
// $1F35FC0: Blobmobs defeated (16-bit)
// $1F35FC4: Symphony Masters defeated (16-bit)
// $1F35FC8: Wheel Masters defeated (16-bit)
// $1F35FCA: Mimic Masters defeated (16-bit)
// $1F35FCC: Iron Imprisoner I's defeated (16-bit)
// $1F35FCE: Iron Imprisoner IIs defeated (16-bit)
// $1F35FD0: Iron Imprisoner IIIs defeated (16-bit)
// $1F35FD2: Iron Imprisoner IVs defeated (16-bit)


worlds = {
1: "The Land of Departure",
2: "Dwarf Woodlands",
3: "Castle of Dreams",
4: "Enchanted Dominion",
5: "The Mysterious Tower",
6: "Radiant Garden",
7: "Event",
8: "Olympus Coliseum",
9: "Deep Space",
10: "Destiny Islands",
11: "Neverland",
12: "Disney Town",
13: "Keyblade Graveyard",
14: "Event 2",
15: "Mirage Arena",
16: "Command Board",
17: "World Map",
19: "The 100-Acre Wood",
20: "The Badlands",
}

areas = {
0: { "worldId": 255, "name": "Title", "display": "On the title screen…", "areaId": 255, "hideWorld": 1, },1: { "worldId": 1, "name": "DepartureForecourtDay", "display": "Forecourt", "areaId": 1, "hideWorld": 0, },2: { "worldId": 1, "name": "DepartureGreatHall", "display": "Great Hall", "areaId": 2, "hideWorld": 0, },3: { "worldId": 1, "name": "VentusRoomDay", "display": "Ventus’s Room", "areaId": 3, "hideWorld": 0, },4: { "worldId": 1, "name": "VentusRoomNight", "display": "Ventus’s Room", "areaId": 4, "hideWorld": 0, },6: { "worldId": 1, "name": "DepartureMountainPath", "display": "Mountain Path", "areaId": 5, "hideWorld": 0, },7: { "worldId": 1, "name": "DepartureSummitNight", "display": "Summit", "areaId": 6, "hideWorld": 0, },8: { "worldId": 1, "name": "DepartureForecourtNight", "display": "Forecourt", "areaId": 7, "hideWorld": 0, },9: { "worldId": 1, "name": "DepartureForecourtRuins", "display": "Forecourt", "areaId": 8, "hideWorld": 0, },10: { "worldId": 1, "name": "DepartureGreatHallRuins", "display": "Great Hall", "areaId": 9, "hideWorld": 0, },11: { "worldId": 1, "name": "DepartureSummitRuins", "display": "Summit", "areaId": 10, "hideWorld": 0, },12: { "worldId": 1, "name": "ChamberOfWaking", "display": "Chamber of Waking", "areaId": 11, "hideWorld": 0, },13: { "worldId": 1, "name": "CastleOblivion", "display": "Castle Oblivion", "areaId": 12, "hideWorld": 0, },14: { "worldId": 1, "name": "CharacterSelect", "display": "Selecting a character…", "areaId": 13, "hideWorld": 1, },15: { "worldId": 1, "name": "DepartureForecourtRuins2", "display": "Forecourt", "areaId": 14, "hideWorld": 0, },16: { "worldId": 1, "name": "DepartureMountainPathRuins", "display": "Mountain Path", "areaId": 15, "hideWorld": 0, },17: { "worldId": 1, "name": "DepartureSummitRuins", "display": "Summit", "areaId": 16, "hideWorld": 0, },18: { "worldId": 2, "name": "DwarfMineEntrance", "display": "Mine Entrance", "areaId": 1, "hideWorld": 0, },19: { "worldId": 2, "name": "DwarfMine", "display": "The Mine", "areaId": 2, "hideWorld": 0, },20: { "worldId": 2, "name": "DwarfVault", "display": "Vault", "areaId": 3, "hideWorld": 0, },21: { "worldId": 2, "name": "DwarfMirrorChamber", "display": "Magic Mirror Chamber", "areaId": 4, "hideWorld": 0, },22: { "worldId": 2, "name": "DwarfWaterway", "display": "Underground Waterway", "areaId": 5, "hideWorld": 0, },23: { "worldId": 2, "name": "DwarfCourtyard", "display": "Courtyard", "areaId": 6, "hideWorld": 0, },24: { "worldId": 2, "name": "DwarfGlade", "display": "Flower Glade", "areaId": 7, "hideWorld": 0, },25: { "worldId": 2, "name": "DwarfWoods", "display": "Deep Woods", "areaId": 8, "hideWorld": 0, },26: { "worldId": 2, "name": "DwarfMirror", "display": "Inside the Magic Mirror", "areaId": 9, "hideWorld": 0, },27: { "worldId": 2, "name": "DwarfClearing", "display": "Cottage Clearing", "areaId": 10, "hideWorld": 0, },28: { "worldId": 2, "name": "DwarfCottage", "display": "The Cottage", "areaId": 11, "hideWorld": 0, },29: { "worldId": 2, "name": "DwarfMountainTrail", "display": "Mountain Trail", "areaId": 12, "hideWorld": 0, },30: { "worldId": 3, "name": "CastleHouse", "display": "Cinderella’s House", "areaId": 1, "hideWorld": 0, },31: { "worldId": 3, "name": "CastleMousehole", "display": "Mousehole", "areaId": 2, "hideWorld": 0, },32: { "worldId": 3, "name": "CastleWardrobe", "display": "Wardrobe Room", "areaId": 3, "hideWorld": 0, },33: { "worldId": 3, "name": "CastleEntrance", "display": "Entrance", "areaId": 4, "hideWorld": 0, },34: { "worldId": 3, "name": "CastleChateau", "display": "The Chateau", "areaId": 5, "hideWorld": 0, },35: { "worldId": 3, "name": "CastleForest", "display": "Forest", "areaId": 6, "hideWorld": 0, },36: { "worldId": 3, "name": "CastleCourtyard", "display": "Palace Courtyard", "areaId": 7, "hideWorld": 0, },37: { "worldId": 3, "name": "CastleCorridor", "display": "Corridor", "areaId": 8, "hideWorld": 0, },38: { "worldId": 3, "name": "CastleBallroom", "display": "Ballroom", "areaId": 9, "hideWorld": 0, },39: { "worldId": 3, "name": "CastleFoyer", "display": "Foyer", "areaId": 10, "hideWorld": 0, },40: { "worldId": 3, "name": "CastlePassage", "display": "Passage", "areaId": 11, "hideWorld": 0, },41: { "worldId": 3, "name": "CastleAntechamber", "display": "Antechamber", "areaId": 12, "hideWorld": 0, },42: { "worldId": 3, "name": "CastleWardrobe2", "display": "Wardrobe Room", "areaId": 13, "hideWorld": 0, },43: { "worldId": 3, "name": "CastleMousehole2", "display": "Mousehole", "areaId": 14, "hideWorld": 0, },44: { "worldId": 3, "name": "CastleWardrobe3", "display": "Wardrobe Room", "areaId": 15, "hideWorld": 0, },45: { "worldId": 4, "name": "EnchantedDungeonCell", "display": "Dungeon Cell", "areaId": 1, "hideWorld": 0, },46: { "worldId": 4, "name": "EnchantedGates", "display": "Gates", "areaId": 2, "hideWorld": 0, },47: { "worldId": 4, "name": "EnchantedThrone", "display": "Maleficent’s Throne", "areaId": 3, "hideWorld": 0, },48: { "worldId": 4, "name": "EnchantedDungeon", "display": "Dungeon", "areaId": 4, "hideWorld": 0, },49: { "worldId": 4, "name": "EnchantedHall1", "display": "Hall", "areaId": 5, "hideWorld": 0, },50: { "worldId": 4, "name": "EnchantedMountain", "display": "Forbidden Mountain", "areaId": 6, "hideWorld": 0, },51: { "worldId": 4, "name": "EnchantedWaterside", "display": "Waterside", "areaId": 7, "hideWorld": 0, },52: { "worldId": 4, "name": "EnchantedClearing", "display": "Forest Clearing", "areaId": 8, "hideWorld": 0, },53: { "worldId": 4, "name": "EnchantedBridge", "display": "Bridge", "areaId": 9, "hideWorld": 0, },54: { "worldId": 4, "name": "EnchantedBridgeThorns", "display": "Bridge", "areaId": 10, "hideWorld": 0, },55: { "worldId": 4, "name": "EnchantedAudience1", "display": "Audience Chamber", "areaId": 11, "hideWorld": 0, },56: { "worldId": 4, "name": "EnchantedAudience2", "display": "Audience Chamber", "areaId": 12, "hideWorld": 0, },57: { "worldId": 4, "name": "EnchantedReserved", "display": "Somewhere in the World…", "areaId": 13, "hideWorld": 1, },58: { "worldId": 4, "name": "EnchantedHallway", "display": "Hallway", "areaId": 14, "hideWorld": 0, },59: { "worldId": 4, "name": "EnchantedAurora", "display": "Aurora’s Chamber", "areaId": 15, "hideWorld": 0, },60: { "worldId": 4, "name": "EnchantedTower", "display": "Tower Room", "areaId": 16, "hideWorld": 0, },61: { "worldId": 4, "name": "EnchantedHall2", "display": "Hall", "areaId": 17, "hideWorld": 0, },62: { "worldId": 4, "name": "EnchantedAurora2", "display": "Aurora’s Chamber", "areaId": 18, "hideWorld": 0, },63: { "worldId": 4, "name": "EnchantedHall3", "display": "Hall", "areaId": 19, "hideWorld": 0, },64: { "worldId": 4, "name": "EnchantedHall4", "display": "Hall", "areaId": 20, "hideWorld": 0, },65: { "worldId": 4, "name": "EnchantedHall5", "display": "Hall", "areaId": 21, "hideWorld": 0, },66: { "worldId": 4, "name": "EnchantedHall6", "display": "Hall", "areaId": 22, "hideWorld": 0, },67: { "worldId": 4, "name": "EnchantedHall7", "display": "Hall", "areaId": 23, "hideWorld": 0, },68: { "worldId": 4, "name": "EnchantedHall8", "display": "Hall", "areaId": 24, "hideWorld": 0, },69: { "worldId": 4, "name": "EnchantedHall9", "display": "Hall", "areaId": 25, "hideWorld": 0, },70: { "worldId": 4, "name": "EnchantedHall10", "display": "Hall", "areaId": 26, "hideWorld": 0, },71: { "worldId": 4, "name": "EnchantedHall11", "display": "Hall", "areaId": 27, "hideWorld": 0, },72: { "worldId": 4, "name": "EnchantedHall12", "display": "Hall", "areaId": 28, "hideWorld": 0, },73: { "worldId": 4, "name": "EnchantedHall13", "display": "Hall", "areaId": 29, "hideWorld": 0, },74: { "worldId": 4, "name": "EnchantedHall14", "display": "Hall", "areaId": 30, "hideWorld": 0, },75: { "worldId": 4, "name": "EnchantedHall15", "display": "Hall", "areaId": 31, "hideWorld": 0, },76: { "worldId": 4, "name": "EnchantedHall16", "display": "Hall", "areaId": 32, "hideWorld": 0, },77: { "worldId": 4, "name": "EnchantedHall17", "display": "Hall", "areaId": 33, "hideWorld": 0, },78: { "worldId": 4, "name": "EnchantedHall18", "display": "Hall", "areaId": 34, "hideWorld": 0, },79: { "worldId": 4, "name": "EnchantedHall19", "display": "Hall", "areaId": 35, "hideWorld": 0, },80: { "worldId": 4, "name": "EnchantedHall20", "display": "Hall", "areaId": 36, "hideWorld": 0, },81: { "worldId": 4, "name": "EnchantedHall21", "display": "Hall", "areaId": 37, "hideWorld": 0, },82: { "worldId": 4, "name": "EnchantedHall22", "display": "Hall", "areaId": 38, "hideWorld": 0, },83: { "worldId": 4, "name": "EnchantedGates", "display": "Gates", "areaId": 39, "hideWorld": 0, },84: { "worldId": 5, "name": "MysteriousChamber", "display": "Sorcerer’s Chamber", "areaId": 1, "hideWorld": 0, },85: { "worldId": 5, "name": "MysteriousTower", "display": "Mysterious Tower", "areaId": 2, "hideWorld": 0, },86: { "worldId": 5, "name": "MysteriousEntrance", "display": "Tower Entrance", "areaId": 3, "hideWorld": 0, },87: { "worldId": 5, "name": "MysteriousChamber2", "display": "Sorcerer’s Chamber", "areaId": 4, "hideWorld": 0, },88: { "worldId": 6, "name": "RadiantOuterGardens", "display": "Outer Gardens", "areaId": 1, "hideWorld": 0, },89: { "worldId": 6, "name": "RadiantEntryway", "display": "Entryway", "areaId": 2, "hideWorld": 0, },90: { "worldId": 6, "name": "RadiantCentral", "display": "Central Square", "areaId": 3, "hideWorld": 0, },91: { "worldId": 6, "name": "RadiantAqueduct", "display": "Aqueduct", "areaId": 4, "hideWorld": 0, },92: { "worldId": 6, "name": "RadiantTown", "display": "Castle Town", "areaId": 5, "hideWorld": 0, },93: { "worldId": 6, "name": "RadiantReactor", "display": "Reactor", "areaId": 6, "hideWorld": 0, },94: { "worldId": 6, "name": "RadiantFountain", "display": "Fountain Court", "areaId": 7, "hideWorld": 0, },95: { "worldId": 6, "name": "RadiantMerlin", "display": "Merlin’s House", "areaId": 8, "hideWorld": 0, },96: { "worldId": 6, "name": "RadiantGardens", "display": "Gardens", "areaId": 9, "hideWorld": 0, },97: { "worldId": 6, "name": "RadiantDoors", "display": "Front Doors", "areaId": 10, "hideWorld": 0, },98: { "worldId": 6, "name": "RadiantPurification", "display": "Purification Facility", "areaId": 11, "hideWorld": 0, },99: { "worldId": 6, "name": "RadiantOuterGardens2", "display": "Outer Gardens", "areaId": 12, "hideWorld": 0, },100: { "worldId": 6, "name": "RadiantCentralDark", "display": "Central Square", "areaId": 13, "hideWorld": 0, },101: { "worldId": 6, "name": "RadiantCentralTerranort", "display": "Central Square", "areaId": 14, "hideWorld": 0, },102: { "worldId": 7, "name": "LouieCourt", "display": "Louie’s Ruins (Court)", "areaId": 1, "hideWorld": 0, },103: { "worldId": 7, "name": "LouiePath", "display": "Louie’s Ruins (Path)", "areaId": 2, "hideWorld": 0, },104: { "worldId": 7, "name": "Crossroad", "display": "Crossroad", "areaId": 3, "hideWorld": 0, },105: { "worldId": 7, "name": "UGRuinsEntrance", "display": "Underground Ruins (Entrance)", "areaId": 4, "hideWorld": 0, },106: { "worldId": 7, "name": "UGRuinsPassage1", "display": "Underground Ruins (Passage)", "areaId": 5, "hideWorld": 0, },107: { "worldId": 7, "name": "UGRuinsPassage2", "display": "Underground Ruins (Passage)", "areaId": 6, "hideWorld": 0, },108: { "worldId": 7, "name": "UGCourtyard", "display": "Underground Courtyard", "areaId": 7, "hideWorld": 0, },109: { "worldId": 7, "name": "JungleNearRuins", "display": "Jungle Near Ruins", "areaId": 8, "hideWorld": 0, },110: { "worldId": 7, "name": "Eminence", "display": "Eminence", "areaId": 9, "hideWorld": 0, },111: { "worldId": 7, "name": "Jungle", "display": "Jungle", "areaId": 10, "hideWorld": 0, },112: { "worldId": 7, "name": "River", "display": "Man-Village River", "areaId": 11, "hideWorld": 0, },113: { "worldId": 7, "name": "Bog", "display": "Bog", "areaId": 12, "hideWorld": 0, },114: { "worldId": 7, "name": "LanesBetween", "display": "The Lanes Between", "areaId": 50, "hideWorld": 0, },115: { "worldId": 7, "name": "Blank", "display": "Blank", "areaId": 51, "hideWorld": 0, },116: { "worldId": 7, "name": "Realm of Darkness", "display": "The Realm of Darkness", "areaId": 52, "hideWorld": 1, },117: { "worldId": 8, "name": "OlympusGates", "display": "Coliseum Gates", "areaId": 1, "hideWorld": 0, },118: { "worldId": 8, "name": "OlympusVestibule", "display": "Vestibule", "areaId": 2, "hideWorld": 0, },119: { "worldId": 8, "name": "OlympusWest", "display": "West Bracket", "areaId": 3, "hideWorld": 0, },120: { "worldId": 8, "name": "OlympusEast", "display": "East Bracket", "areaId": 4, "hideWorld": 0, },121: { "worldId": 8, "name": "OlympusTown", "display": "Town Near Thebes", "areaId": 5, "hideWorld": 0, },122: { "worldId": 8, "name": "OlympusEastNight", "display": "East Bracket", "areaId": 6, "hideWorld": 0, },123: { "worldId": 9, "name": "SpaceTuroBlock", "display": "Turo Prison Block", "areaId": 1, "hideWorld": 0, },124: { "worldId": 9, "name": "SpaceTuroTransporter", "display": "Turo Transporter", "areaId": 2, "hideWorld": 0, },125: { "worldId": 9, "name": "SpaceDurgonTransporter", "display": "Durgon Transporter", "areaId": 3, "hideWorld": 0, },126: { "worldId": 9, "name": "SpaceCorridor", "display": "Ship Corridor", "areaId": 4, "hideWorld": 0, },127: { "worldId": 9, "name": "SpaceControl", "display": "Control Room", "areaId": 5, "hideWorld": 0, },128: { "worldId": 9, "name": "SpacePod", "display": "Containment Pod", "areaId": 6, "hideWorld": 0, },129: { "worldId": 9, "name": "SpaceHub", "display": "Ship Hub", "areaId": 7, "hideWorld": 0, },130: { "worldId": 9, "name": "SpaceMachineryBay", "display": "Machinery Bay", "areaId": 8, "hideWorld": 0, },131: { "worldId": 9, "name": "SpaceLaunch", "display": "Launch Deck", "areaId": 9, "hideWorld": 0, },132: { "worldId": 9, "name": "SpaceExterior", "display": "Ship Exterior", "areaId": 10, "hideWorld": 0, },133: { "worldId": 9, "name": "SpaceOuter", "display": "Outer Space", "areaId": 11, "hideWorld": 0, },134: { "worldId": 9, "name": "SpaceCorridor2", "display": "Ship Corridor", "areaId": 12, "hideWorld": 0, },135: { "worldId": 9, "name": "SpaceLanesBetween", "display": "The Lanes Between", "areaId": 13, "hideWorld": 0, },136: { "worldId": 9, "name": "SpaceMachineryBayAccess", "display": "Machinery Bay Access", "areaId": 14, "hideWorld": 0, },137: { "worldId": 10, "name": "DestinyBeachDay", "display": "Island Beach", "areaId": 1, "hideWorld": 0, },138: { "worldId": 10, "name": "DestinyBeachSunset", "display": "Island Beach", "areaId": 2, "hideWorld": 0, },139: { "worldId": 10, "name": "DestinyBeachNight", "display": "Island Beach", "areaId": 3, "hideWorld": 0, },140: { "worldId": 10, "name": "DestinyMainIsland", "display": "Main Island Beach", "areaId": 4, "hideWorld": 0, },141: { "worldId": 11, "name": "NeverlandCove", "display": "Cove", "areaId": 1, "hideWorld": 0, },142: { "worldId": 11, "name": "NeverlandCliff", "display": "Cliff Path", "areaId": 2, "hideWorld": 0, },143: { "worldId": 11, "name": "NeverlandLagoon", "display": "Mermaid Lagoon", "areaId": 3, "hideWorld": 0, },144: { "worldId": 11, "name": "NeverlandSeacoast", "display": "Seacoast", "areaId": 4, "hideWorld": 0, },145: { "worldId": 11, "name": "NeverlandClearing", "display": "Jungle Clearing", "areaId": 5, "hideWorld": 0, },146: { "worldId": 11, "name": "NeverlandHideout", "display": "Peter’s Hideout", "areaId": 6, "hideWorld": 0, },147: { "worldId": 11, "name": "NeverlandGully", "display": "Gully", "areaId": 7, "hideWorld": 0, },148: { "worldId": 11, "name": "NeverlandCamp", "display": "Indian Camp", "areaId": 8, "hideWorld": 0, },149: { "worldId": 11, "name": "NeverlandBase", "display": "Rainbow Falls: Base", "areaId": 9, "hideWorld": 0, },150: { "worldId": 11, "name": "NeverlandAscent", "display": "Rainbow Falls: Ascent", "areaId": 10, "hideWorld": 0, },151: { "worldId": 11, "name": "NeverlandCrest", "display": "Rainbow Falls: Crest", "areaId": 11, "hideWorld": 0, },152: { "worldId": 11, "name": "NeverlandSkullEntrance", "display": "Skull Rock: Entrance", "areaId": 12, "hideWorld": 0, },153: { "worldId": 11, "name": "NeverlandSkullCavern", "display": "Skull Rock: Cavern", "areaId": 13, "hideWorld": 0, },154: { "worldId": 11, "name": "NeverlandSky", "display": "Night Sky", "areaId": 14, "hideWorld": 0, },155: { "worldId": 12, "name": "DisneyLibrary", "display": "Library", "areaId": 1, "hideWorld": 0, },156: { "worldId": 12, "name": "DisneyPlaza", "display": "Main Plaza", "areaId": 2, "hideWorld": 0, },157: { "worldId": 12, "name": "DisneyFruitballCourt", "display": "Fruitball Course", "areaId": 3, "hideWorld": 0, },158: { "worldId": 12, "name": "DisneyCountryChase", "display": "Country Chase", "areaId": 4, "hideWorld": 0, },159: { "worldId": 12, "name": "DisneyRaceway", "display": "Raceway", "areaId": 5, "hideWorld": 0, },160: { "worldId": 12, "name": "DisneyGizmo", "display": "Gizmo Gallery", "areaId": 6, "hideWorld": 0, },161: { "worldId": 12, "name": "DisneyRecRoom", "display": "Pete’s Rec Room", "areaId": 7, "hideWorld": 0, },162: { "worldId": 12, "name": "DisneyDrive", "display": "Disney Drive", "areaId": 8, "hideWorld": 0, },163: { "worldId": 12, "name": "DisneySpree", "display": "Grand Spree", "areaId": 9, "hideWorld": 0, },164: { "worldId": 12, "name": "DisneyCastle", "display": "Castle Circuit", "areaId": 10, "hideWorld": 0, },165: { "worldId": 12, "name": "DisneyLanesBetween", "display": "The Lanes Between", "areaId": 11, "hideWorld": 0, },166: { "worldId": 12, "name": "DisneyRegistration", "display": "Raceway Registration", "areaId": 12, "hideWorld": 0, },167: { "worldId": 12, "name": "DisneyIceCream", "display": "Ice Cream", "areaId": 13, "hideWorld": 0, },168: { "worldId": 12, "name": "DisneyFruitball", "display": "Fruitball", "areaId": 14, "hideWorld": 0, },169: { "worldId": 12, "name": "DisneyCourseCastle", "display": "Race: Castle Course", "areaId": 15, "hideWorld": 0, },170: { "worldId": 13, "name": "GraveyardBadlands", "display": "Badlands", "areaId": 1, "hideWorld": 0, },171: { "worldId": 13, "name": "GraveyardWar", "display": "Seat of War", "areaId": 2, "hideWorld": 0, },172: { "worldId": 13, "name": "GraveyardTwister", "display": "Twister Trench", "areaId": 3, "hideWorld": 0, },173: { "worldId": 13, "name": "GraveyardEye1", "display": "Eye of the Storm", "areaId": 4, "hideWorld": 0, },174: { "worldId": 13, "name": "GraveyardEye2", "display": "Eye of the Storm", "areaId": 5, "hideWorld": 0, },175: { "worldId": 13, "name": "GraveyardEye3", "display": "Eye of the Storm", "areaId": 6, "hideWorld": 0, },176: { "worldId": 13, "name": "GraveyardFissure", "display": "Fissure", "areaId": 7, "hideWorld": 0, },177: { "worldId": 13, "name": "Graveyard1", "display": "Keyblade Graveyard", "areaId": 8, "hideWorld": 1, },178: { "worldId": 13, "name": "Graveyard2", "display": "Keyblade Graveyard", "areaId": 9, "hideWorld": 1, },179: { "worldId": 13, "name": "Graveyard3", "display": "Keyblade Graveyard", "areaId": 10, "hideWorld": 1, },180: { "worldId": 13, "name": "GraveyardCage", "display": "Will’s Cage", "areaId": 11, "hideWorld": 0, },181: { "worldId": 13, "name": "Graveyard4", "display": "Keyblade Graveyard", "areaId": 12, "hideWorld": 1, },182: { "worldId": 13, "name": "VentusHeart1", "display": "Ventus’s Heart", "areaId": 50, "hideWorld": 0, },183: { "worldId": 13, "name": "VentusHeart2", "display": "Ventus’s Heart", "areaId": 51, "hideWorld": 0, },184: { "worldId": 13, "name": "VentusHeart3", "display": "Ventus’s Heart", "areaId": 52, "hideWorld": 0, },185: { "worldId": 13, "name": "SoraHeart", "display": "Sora’s Heart", "areaId": 53, "hideWorld": 0, },186: { "worldId": 13, "name": "TerraHeart", "display": "Terra’s Heart", "areaId": 54, "hideWorld": 0, },187: { "worldId": 13, "name": "Graveyard5", "display": "Keyblade Graveyard", "areaId": 55, "hideWorld": 0, },188: { "worldId": 13, "name": "GraveyardBadlands2", "display": "Badlands", "areaId": 56, "hideWorld": 0, },189: { "worldId": 15, "name": "MirageHub", "display": "Hub", "areaId": 1, "hideWorld": 0, },190: { "worldId": 15, "name": "MirageColiseum", "display": "Coliseum", "areaId": 2, "hideWorld": 0, },191: { "worldId": 15, "name": "MirageArena1", "display": "Arena", "areaId": 3, "hideWorld": 0, },192: { "worldId": 15, "name": "MirageBadlands", "display": "Badlands", "areaId": 4, "hideWorld": 0, },193: { "worldId": 15, "name": "MiragePinball", "display": "Pinball", "areaId": 5, "hideWorld": 0, },194: { "worldId": 15, "name": "MirageShipHub", "display": "Ship Hub", "areaId": 6, "hideWorld": 0, },195: { "worldId": 15, "name": "MirageMousehole", "display": "Mousehole", "areaId": 7, "hideWorld": 0, },196: { "worldId": 15, "name": "MirageForest", "display": "Forest", "areaId": 8, "hideWorld": 0, },197: { "worldId": 15, "name": "MirageSkull", "display": "Skull Rock", "areaId": 9, "hideWorld": 0, },198: { "worldId": 15, "name": "MirageChamber", "display": "Audience Chamber", "areaId": 10, "hideWorld": 0, },199: { "worldId": 15, "name": "MirageForecourt", "display": "Forecourt", "areaId": 11, "hideWorld": 0, },200: { "worldId": 15, "name": "MirageSummit", "display": "Summit", "areaId": 12, "hideWorld": 0, },201: { "worldId": 15, "name": "MirageDeck", "display": "Launch Deck", "areaId": 13, "hideWorld": 0, },202: { "worldId": 15, "name": "MirageExterior", "display": "Ship Exterior", "areaId": 14, "hideWorld": 0, },203: { "worldId": 15, "name": "MirageArena2", "display": "Arena", "areaId": 15, "hideWorld": 0, },204: { "worldId": 16, "name": "CommandDeparture", "display": "The Land of Departure Command Board", "areaId": 1, "hideWorld": 1, },205: { "worldId": 16, "name": "CommandCinderella", "display": "Cinderella Command Board", "areaId": 3, "hideWorld": 1, },206: { "worldId": 16, "name": "CommandSitch", "display": "Lilo and Stitch Command Board", "areaId": 9, "hideWorld": 1, },207: { "worldId": 16, "name": "CommandPan", "display": "Peter Pan Command Board", "areaId": 11, "hideWorld": 1, },208: { "worldId": 16, "name": "CommandDisney", "display": "Disney Castle Command Board", "areaId": 12, "hideWorld": 1, },209: { "worldId": 16, "name": "CommandPooh", "display": "Winnie the Pooh Command Board", "areaId": 18, "hideWorld": 1, },210: { "worldId": 16, "name": "CommandPan2", "display": "Peter Pan Command Board", "areaId": 19, "hideWorld": 1, },211: { "worldId": 17, "name": "WorldMap", "display": "World Map", "areaId": 1, "hideWorld": 1, },212: { "worldId": 15, "name": "MirageMonstro", "display": "Prankster’s Paradise", "areaId": 17, "hideWorld": 0, },
}

commands = {
   0xFFFF: { "id": 0xFFFF, "name": "N/A", "category": "N/A", "slots": 0, "type": "N/A", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "N/A", "element": "N/A" },0x3f: { "id": 0x3f, "name": "Finish (Terra)", "category": "Finish", "slots": 0, "type": "Finish", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "Finish", "element": "Physical" },0x42: { "id": 0x42, "name": "Rising Rock 1", "category": "Finish", "slots": 0, "type": "Finish", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "Finish", "element": "Physical" },0x47: { "id": 0x47, "name": "Rising Rock 2", "category": "Finish", "slots": 0, "type": "Finish", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "Finish", "element": "Physical" },0x49: { "id": 0x49, "name": "Ramuh’s Judgment", "category": "Finish", "slots": 0, "type": "Finish", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "Finish", "element": "Thunder" },0x4a: { "id": 0x4a, "name": "Twisted Hours", "category": "Finish", "slots": 0, "type": "Finish", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "Finish", "element": "Physical" },0x4b: { "id": 0x4b, "name": "Surprise! 1", "category": "Finish", "slots": 0, "type": "Finish", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "Finish", "element": "Physical" },0x4e: { "id": 0x4e, "name": "Dark Star 1", "category": "Finish", "slots": 0, "type": "Finish", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "Finish", "element": "Physical" },0x4f: { "id": 0x4f, "name": "Heal Strike", "category": "Finish", "slots": 0, "type": "Finish", "tier": 0, "healsHp": 1, "equippableBattleCommand": 0, "supercategory": "Finish", "element": "Physical" },0x50: { "id": 0x50, "name": "Random End", "category": "Finish", "slots": 0, "type": "Finish", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "Finish", "element": "Physical" },0x51: { "id": 0x51, "name": "Surprise! 2", "category": "Finish", "slots": 0, "type": "Finish", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "Finish", "element": "Physical" },0x54: { "id": 0x54, "name": "Dark Star 2", "category": "Finish", "slots": 0, "type": "Finish", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "Finish", "element": "Physical" },0x55: { "id": 0x55, "name": "Explosion", "category": "Finish", "slots": 0, "type": "Finish", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "Finish", "element": "Physical" },0x5a: { "id": 0x5a, "name": "Demolition", "category": "Finish", "slots": 0, "type": "Finish", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "Finish", "element": "Physical" },0x5b: { "id": 0x5b, "name": "Quick Blitz", "category": "Attack", "slots": 1, "type": "Jump", "tier": 0, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Attack", "element": "Physical" },0x5c: { "id": 0x5c, "name": "Blitz", "category": "Melee", "slots": 1, "type": "Jump", "tier": 0, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Attack", "element": "Physical" },0x5d: { "id": 0x5d, "name": "Magic Hour", "category": "Ranged", "slots": 2, "type": "Jump", "tier": 0, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Attack", "element": "Physical" },0x5e: { "id": 0x5e, "name": "Meteor Crash", "category": "Ranged", "slots": 2, "type": "Jump", "tier": 0, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Attack", "element": "Physical" },0x5f: { "id": 0x5f, "name": "Sliding Dash", "category": "Melee", "slots": 1, "type": "Jump", "tier": 0, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Attack", "element": "Physical" },0x60: { "id": 0x60, "name": "Fire Dash", "category": "Melee", "slots": 1, "type": "Rush", "tier": 0, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Attack", "element": "Fire" },0x61: { "id": 0x61, "name": "Dark Haze", "category": "Melee", "slots": 1, "type": "Rush", "tier": 0, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Attack", "element": "Dark" },0x62: { "id": 0x62, "name": "Sonic Blade", "category": "Melee", "slots": 1, "type": "Rush", "tier": 0, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Attack", "element": "Physical" },0x63: { "id": 0x63, "name": "Chaos Blade", "category": "Melee", "slots": 2, "type": "Rush", "tier": 0, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Attack", "element": "Dark" },0x64: { "id": 0x64, "name": "Zantetsuken", "category": "Melee", "slots": 1, "type": "Rush", "tier": 0, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Attack", "element": "Physical" },0x65: { "id": 0x65, "name": "Strike Raid", "category": "Ranged", "slots": 1, "type": "Raid", "tier": 0, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Attack", "element": "Physical" },0x66: { "id": 0x66, "name": "Freeze Raid", "category": "Ranged", "slots": 1, "type": "Raid", "tier": 0, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Attack", "element": "Blizzard" },0x67: { "id": 0x67, "name": "Treasure Raid", "category": "Ranged", "slots": 1, "type": "Raid", "tier": 0, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Attack", "element": "Physical" },0x68: { "id": 0x68, "name": "Spark Raid", "category": "Ranged", "slots": 1, "type": "Raid", "tier": 0, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Attack", "element": "Physical" },0x69: { "id": 0x69, "name": "Wind Raid", "category": "Ranged", "slots": 1, "type": "Raid", "tier": 0, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Attack", "element": "Physical" },0x6a: { "id": 0x6a, "name": "Fire Surge", "category": "Melee", "slots": 1, "type": "Rush", "tier": 0, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Attack", "element": "Fire" },0x6b: { "id": 0x6b, "name": "Barrier Surge", "category": "Melee", "slots": 1, "type": "Rush", "tier": 0, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Attack", "element": "Physical" },0x6c: { "id": 0x6c, "name": "Thunder Surge", "category": "Melee", "slots": 1, "type": "Rush", "tier": 0, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Attack", "element": "Thunder" },0x6d: { "id": 0x6d, "name": "Aerial Slam", "category": "Melee", "slots": 1, "type": "Jump", "tier": 0, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Attack", "element": "Physical" },0x6e: { "id": 0x6e, "name": "Ars Solum", "category": "Melee", "slots": 2, "type": "Chain Hit", "tier": 0, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Attack", "element": "Physical" },0x6f: { "id": 0x6f, "name": "Ars Arcanum", "category": "Melee", "slots": 2, "type": "Chain Hit", "tier": 0, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Attack", "element": "Physical" },0x70: { "id": 0x70, "name": "Time Splicer", "category": "Melee", "slots": 2, "type": "Chain Hit", "tier": 0, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Attack", "element": "Physical" },0x71: { "id": 0x71, "name": "Poison Edge", "category": "Melee", "slots": 1, "type": "Blade", "tier": 0, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Attack", "element": "Physical" },0x72: { "id": 0x72, "name": "Wishing Edge", "category": "Melee", "slots": 1, "type": "Blade", "tier": 0, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Attack", "element": "Physical" },0x73: { "id": 0x73, "name": "Blizzard Edge", "category": "Melee", "slots": 1, "type": "Blade", "tier": 0, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Attack", "element": "Blizzard" },0x74: { "id": 0x74, "name": "Stun Edge", "category": "Melee", "slots": 1, "type": "Blade", "tier": 0, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Attack", "element": "Physical" },0x75: { "id": 0x75, "name": "Slot Edge", "category": "Melee", "slots": 1, "type": "Blade", "tier": 0, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Attack", "element": "Physical" },0x76: { "id": 0x76, "name": "Fire Strike", "category": "Melee", "slots": 1, "type": "Strike", "tier": 0, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Attack", "element": "Fire" },0x77: { "id": 0x77, "name": "Confuse Strike", "category": "Melee", "slots": 1, "type": "Strike", "tier": 0, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Attack", "element": "Physical" },0x78: { "id": 0x78, "name": "Binding Strike", "category": "Melee", "slots": 1, "type": "Strike", "tier": 0, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Attack", "element": "Physical" },0x79: { "id": 0x79, "name": "Tornado Strike", "category": "Melee", "slots": 2, "type": "Strike", "tier": 0, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Attack", "element": "Physical" },0x7a: { "id": 0x7a, "name": "Brutal Blast", "category": "Melee", "slots": 1, "type": "Strike", "tier": 0, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Attack", "element": "Physical" },0x7b: { "id": 0x7b, "name": "Magnet Spiral", "category": "Melee", "slots": 1, "type": "Strike", "tier": 0, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Attack", "element": "Physical" },0x7c: { "id": 0x7c, "name": "Salvation", "category": "Ranged", "slots": 2, "type": "Strike", "tier": 0, "healsHp": 1, "equippableBattleCommand": 1, "supercategory": "Attack", "element": "Physical" },0x7d: { "id": 0x7d, "name": "Wind Cutter", "category": "Melee", "slots": 1, "type": "Strike", "tier": 0, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Attack", "element": "Physical" },0x7e: { "id": 0x7e, "name": "Limit Storm", "category": "Melee", "slots": 1, "type": "Strike", "tier": 0, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Attack", "element": "Physical" },0x7f: { "id": 0x7f, "name": "Collision Magnet", "category": "Hybrid", "slots": 1, "type": "Blade", "tier": 0, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Attack", "element": "Physical" },0x80: { "id": 0x80, "name": "Geo Impact", "category": "Melee", "slots": 2, "type": "Blade", "tier": 0, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Attack", "element": "Physical" },0x81: { "id": 0x81, "name": "Sacrifice", "category": "Melee", "slots": 1, "type": "Blade", "tier": 0, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Attack", "element": "Physical" },0x82: { "id": 0x82, "name": "Break Time", "category": "Support", "slots": 1, "type": "N/A", "tier": 0, "healsHp": 1, "equippableBattleCommand": 1, "supercategory": "Attack", "element": "N/A" },0x83: { "id": 0x83, "name": "Fire", "category": "Ranged", "slots": 1, "type": "N/A", "tier": 1, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Magic", "element": "Fire" },0x84: { "id": 0x84, "name": "Fira", "category": "Ranged", "slots": 1, "type": "N/A", "tier": 2, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Magic", "element": "Fire" },0x85: { "id": 0x85, "name": "Firaga", "category": "Ranged", "slots": 1, "type": "N/A", "tier": 3, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Magic", "element": "Fire" },0x86: { "id": 0x86, "name": "Dark Firaga", "category": "Ranged", "slots": 1, "type": "N/A", "tier": 3, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Magic", "element": "Dark" },0x87: { "id": 0x87, "name": "Fission Firaga", "category": "Ranged", "slots": 1, "type": "N/A", "tier": 3, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Magic", "element": "Fire" },0x88: { "id": 0x88, "name": "Triple Firaga", "category": "Ranged", "slots": 1, "type": "N/A", "tier": 3, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Magic", "element": "Fire" },0x89: { "id": 0x89, "name": "Crawling Fire", "category": "Ranged", "slots": 1, "type": "N/A", "tier": 3, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Magic", "element": "Fire" },0x8a: { "id": 0x8a, "name": "Blizzard", "category": "Ranged", "slots": 1, "type": "N/A", "tier": 1, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Magic", "element": "Blizzard" },0x8b: { "id": 0x8b, "name": "Blizzara", "category": "Ranged", "slots": 1, "type": "N/A", "tier": 2, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Magic", "element": "Blizzard" },0x8c: { "id": 0x8c, "name": "Blizzaga", "category": "Ranged", "slots": 1, "type": "N/A", "tier": 3, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Magic", "element": "Blizzard" },0x8d: { "id": 0x8d, "name": "Triple Blizzaga", "category": "Ranged", "slots": 1, "type": "N/A", "tier": 3, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Magic", "element": "Blizzard" },0x8e: { "id": 0x8e, "name": "Thunder", "category": "Ranged", "slots": 1, "type": "N/A", "tier": 1, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Magic", "element": "Thunder" },0x8f: { "id": 0x8f, "name": "Thundara", "category": "Ranged", "slots": 1, "type": "N/A", "tier": 2, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Magic", "element": "Thunder" },0x90: { "id": 0x90, "name": "Thundaga", "category": "Ranged", "slots": 1, "type": "N/A", "tier": 3, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Magic", "element": "Thunder" },0x91: { "id": 0x91, "name": "Thundaga Shot", "category": "Ranged", "slots": 1, "type": "N/A", "tier": 3, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Magic", "element": "Thunder" },0x92: { "id": 0x92, "name": "Cure", "category": "Support", "slots": 1, "type": "Cure", "tier": 1, "healsHp": 1, "equippableBattleCommand": 1, "supercategory": "Magic", "element": "N/A" },0x93: { "id": 0x93, "name": "Cura", "category": "Support", "slots": 1, "type": "Cure", "tier": 2, "healsHp": 1, "equippableBattleCommand": 1, "supercategory": "Magic", "element": "N/A" },0x94: { "id": 0x94, "name": "Curaga", "category": "Support", "slots": 1, "type": "Cure", "tier": 3, "healsHp": 1, "equippableBattleCommand": 1, "supercategory": "Magic", "element": "N/A" },0x95: { "id": 0x95, "name": "Esuna", "category": "Support", "slots": 1, "type": "Cure", "tier": 1, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Magic", "element": "N/A" },0x96: { "id": 0x96, "name": "Mine Shield", "category": "Mine", "slots": 1, "type": "Detonate", "tier": 0, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Magic", "element": "Null" },0x97: { "id": 0x97, "name": "Mine Square", "category": "Mine", "slots": 1, "type": "Detonate", "tier": 0, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Magic", "element": "Null" },0x98: { "id": 0x98, "name": "Seeker Mine", "category": "Mine", "slots": 1, "type": "Detonate", "tier": 0, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Magic", "element": "Null" },0x99: { "id": 0x99, "name": "Zero Gravity", "category": "Ranged", "slots": 1, "type": "Zero Gravity", "tier": 1, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Magic", "element": "Null" },0x9a: { "id": 0x9a, "name": "Zero Gravira", "category": "Ranged", "slots": 1, "type": "Zero Gravity", "tier": 2, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Magic", "element": "Null" },0x9b: { "id": 0x9b, "name": "Zero Graviga", "category": "Ranged", "slots": 1, "type": "Zero Gravity", "tier": 3, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Magic", "element": "Null" },0x9c: { "id": 0x9c, "name": "Magnet", "category": "Ranged", "slots": 1, "type": "Magnet", "tier": 1, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Magic", "element": "Null" },0x9d: { "id": 0x9d, "name": "Magnera", "category": "Ranged", "slots": 1, "type": "Magnet", "tier": 2, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Magic", "element": "Null" },0x9e: { "id": 0x9e, "name": "Magnega", "category": "Ranged", "slots": 1, "type": "Magnet", "tier": 3, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Magic", "element": "Null" },0x9f: { "id": 0x9f, "name": "Munny Magnet", "category": "Support", "slots": 1, "type": "Magnet", "tier": 2, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Magic", "element": "Null" },0xa0: { "id": 0xa0, "name": "Energy Magnet", "category": "Support", "slots": 1, "type": "Magnet", "tier": 2, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Magic", "element": "Null" },0xa1: { "id": 0xa1, "name": "D-Link Magnet", "category": "Support", "slots": 1, "type": "Magnet", "tier": 2, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Magic", "element": "Null" },0xa2: { "id": 0xa2, "name": "Aero", "category": "Ranged", "slots": 1, "type": "Aero", "tier": 1, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Magic", "element": "Null" },0xa3: { "id": 0xa3, "name": "Aerora", "category": "Ranged", "slots": 1, "type": "Aero", "tier": 2, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Magic", "element": "Null" },0xa4: { "id": 0xa4, "name": "Aeroga", "category": "Ranged", "slots": 1, "type": "Aero", "tier": 3, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Magic", "element": "Null" },0xa5: { "id": 0xa5, "name": "Warp", "category": "Ranged", "slots": 1, "type": "N/A", "tier": 0, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Magic", "element": "Null" },0xa6: { "id": 0xa6, "name": "Faith", "category": "Ranged", "slots": 2, "type": "N/A", "tier": 0, "healsHp": 1, "equippableBattleCommand": 1, "supercategory": "Magic", "element": "Null" },0xa7: { "id": 0xa7, "name": "Deep Freeze", "category": "Ranged", "slots": 2, "type": "N/A", "tier": 0, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Magic", "element": "Blizzard" },0xa8: { "id": 0xa8, "name": "Glacier", "category": "Ranged", "slots": 2, "type": "N/A", "tier": 0, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Magic", "element": "Blizzard" },0xa9: { "id": 0xa9, "name": "Ice Barrage", "category": "Ranged", "slots": 2, "type": "N/A", "tier": 0, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Magic", "element": "Blizzard" },0xaa: { "id": 0xaa, "name": "Firaga Burst", "category": "Ranged", "slots": 2, "type": "N/A", "tier": 3, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Magic", "element": "Fire" },0xab: { "id": 0xab, "name": "Raging Storm", "category": "Ranged", "slots": 2, "type": "N/A", "tier": 0, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Magic", "element": "Fire" },0xac: { "id": 0xac, "name": "Mega Flare", "category": "Ranged", "slots": 2, "type": "N/A", "tier": 0, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Magic", "element": "Fire" },0xad: { "id": 0xad, "name": "Quake", "category": "Ranged", "slots": 2, "type": "N/A", "tier": 0, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Magic", "element": "Null" },0xae: { "id": 0xae, "name": "Tornado", "category": "Ranged", "slots": 2, "type": "Aero", "tier": 0, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Magic", "element": "Null" },0xaf: { "id": 0xaf, "name": "Meteor", "category": "Ranged", "slots": 2, "type": "N/A", "tier": 0, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Magic", "element": "Null" },0xb0: { "id": 0xb0, "name": "Transcendence", "category": "Ranged", "slots": 2, "type": "Zero Gravity", "tier": 0, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Magic", "element": "Null" },0xb1: { "id": 0xb1, "name": "Mini", "category": "Status", "slots": 1, "type": "Status Effect", "tier": 1, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Magic", "element": "Null" },0xb2: { "id": 0xb2, "name": "Blackout", "category": "Status", "slots": 1, "type": "Status Effect", "tier": 1, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Magic", "element": "Null" },0xb3: { "id": 0xb3, "name": "Ignite", "category": "Status", "slots": 1, "type": "Status Effect", "tier": 1, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Magic", "element": "Fire" },0xb4: { "id": 0xb4, "name": "Confuse", "category": "Status", "slots": 1, "type": "Status Effect", "tier": 1, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Magic", "element": "Null" },0xb5: { "id": 0xb5, "name": "Bind", "category": "Status", "slots": 1, "type": "Status Effect", "tier": 1, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Magic", "element": "Null" },0xb6: { "id": 0xb6, "name": "Poison", "category": "Status", "slots": 1, "type": "Status Effect", "tier": 1, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Magic", "element": "Null" },0xb7: { "id": 0xb7, "name": "Slow", "category": "Status", "slots": 1, "type": "Status Effect", "tier": 1, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Magic", "element": "Null" },0xb8: { "id": 0xb8, "name": "Stop", "category": "Status", "slots": 1, "type": "Status Effect", "tier": 1, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Magic", "element": "Null" },0xb9: { "id": 0xb9, "name": "Stopra", "category": "Status", "slots": 1, "type": "Status Effect", "tier": 2, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Magic", "element": "Null" },0xba: { "id": 0xba, "name": "Stopga", "category": "Status", "slots": 1, "type": "Status Effect", "tier": 3, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Magic", "element": "Null" },0xbb: { "id": 0xbb, "name": "Sleep", "category": "Status", "slots": 1, "type": "Status Effect", "tier": 1, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Magic", "element": "Null" },0xbc: { "id": 0xbc, "name": "Potion", "category": "Item", "slots": 1, "type": "Item", "tier": 0, "healsHp": 1, "equippableBattleCommand": 1, "supercategory": "Item", "element": "N/A" },0xbd: { "id": 0xbd, "name": "Hi-Potion", "category": "Item", "slots": 1, "type": "Item", "tier": 0, "healsHp": 1, "equippableBattleCommand": 1, "supercategory": "Item", "element": "N/A" },0xbe: { "id": 0xbe, "name": "Mega-Potion", "category": "Item", "slots": 1, "type": "Item", "tier": 0, "healsHp": 1, "equippableBattleCommand": 1, "supercategory": "Item", "element": "N/A" },0xbf: { "id": 0xbf, "name": "Ether", "category": "Item", "slots": 1, "type": "Item", "tier": 0, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Item", "element": "N/A" },0xc0: { "id": 0xc0, "name": "Mega-Ether", "category": "Item", "slots": 1, "type": "Item", "tier": 0, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Item", "element": "N/A" },0xc1: { "id": 0xc1, "name": "Panacea", "category": "Item", "slots": 1, "type": "Item", "tier": 0, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Item", "element": "N/A" },0xc2: { "id": 0xc2, "name": "Elixir", "category": "Item", "slots": 1, "type": "Item", "tier": 0, "healsHp": 1, "equippableBattleCommand": 1, "supercategory": "Item", "element": "N/A" },0xc3: { "id": 0xc3, "name": "Megalixir", "category": "Item", "slots": 1, "type": "Item", "tier": 0, "healsHp": 1, "equippableBattleCommand": 1, "supercategory": "Item", "element": "N/A" },0xc4: { "id": 0xc4, "name": "Balloon Letter", "category": "Item", "slots": 1, "type": "Item", "tier": 0, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Item", "element": "N/A" },0xc5: { "id": 0xc5, "name": "Vanilla Glitz", "category": "Item", "slots": 1, "type": "Item", "tier": 0, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Item", "element": "N/A" },0xc6: { "id": 0xc6, "name": "Fabracadabra", "category": "Item", "slots": 1, "type": "Item", "tier": 0, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Item", "element": "N/A" },0xc7: { "id": 0xc7, "name": "Honeybunny", "category": "Item", "slots": 1, "type": "Item", "tier": 0, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Item", "element": "N/A" },0xc8: { "id": 0xc8, "name": "Bueno Volcano", "category": "Item", "slots": 1, "type": "Item", "tier": 0, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Item", "element": "N/A" },0xc9: { "id": 0xc9, "name": "Snow Bear", "category": "Item", "slots": 1, "type": "Item", "tier": 0, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Item", "element": "N/A" },0xca: { "id": 0xca, "name": "Spark Lemon", "category": "Item", "slots": 1, "type": "Item", "tier": 0, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Item", "element": "N/A" },0xcb: { "id": 0xcb, "name": "Goofy Parfait", "category": "Item", "slots": 1, "type": "Item", "tier": 0, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Item", "element": "N/A" },0xcc: { "id": 0xcc, "name": "Royalberry", "category": "Item", "slots": 1, "type": "Item", "tier": 0, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Item", "element": "N/A" },0xcd: { "id": 0xcd, "name": "Milky Way", "category": "Item", "slots": 1, "type": "Item", "tier": 0, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Item", "element": "N/A" },0xce: { "id": 0xce, "name": "Rockin’ Crunch", "category": "Item", "slots": 1, "type": "Item", "tier": 0, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Item", "element": "N/A" },0xcf: { "id": 0xcf, "name": "Donald Fizz", "category": "Item", "slots": 1, "type": "Item", "tier": 0, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Item", "element": "N/A" },0xd0: { "id": 0xd0, "name": "Space Mint", "category": "Item", "slots": 1, "type": "Item", "tier": 0, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Item", "element": "N/A" },0xd1: { "id": 0xd1, "name": "Big Bad Pete", "category": "Item", "slots": 1, "type": "Item", "tier": 0, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Item", "element": "N/A" },0xd2: { "id": 0xd2, "name": "Double Crunch", "category": "Item", "slots": 1, "type": "Item", "tier": 0, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Item", "element": "N/A" },0xd3: { "id": 0xd3, "name": "Group Cure", "category": "Support", "slots": 1, "type": "Cure", "tier": 1, "healsHp": 1, "equippableBattleCommand": 1, "supercategory": "Friendship", "element": "N/A" },0xd4: { "id": 0xd4, "name": "Group Cura", "category": "Support", "slots": 1, "type": "Cure", "tier": 2, "healsHp": 1, "equippableBattleCommand": 1, "supercategory": "Friendship", "element": "N/A" },0xd5: { "id": 0xd5, "name": "Group Curaga", "category": "Support", "slots": 1, "type": "Cure", "tier": 3, "healsHp": 1, "equippableBattleCommand": 1, "supercategory": "Friendship", "element": "N/A" },0xd6: { "id": 0xd6, "name": "Group Esuna", "category": "Support", "slots": 1, "type": "Cure", "tier": 1, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Friendship", "element": "N/A" },0xd7: { "id": 0xd7, "name": "Confetti", "category": "Friendship", "slots": 1, "type": "N/A", "tier": 0, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Friendship", "element": "N/A" },0xd8: { "id": 0xd8, "name": "Fireworks", "category": "Friendship", "slots": 1, "type": "N/A", "tier": 0, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Friendship", "element": "N/A" },0xd9: { "id": 0xd9, "name": "Taunt", "category": "Support", "slots": 1, "type": "N/A", "tier": 0, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Friendship", "element": "N/A" },0xda: { "id": 0xda, "name": "Victory Pose", "category": "Friendship", "slots": 1, "type": "N/A", "tier": 0, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Friendship", "element": "N/A" },0xdb: { "id": 0xdb, "name": "Deck Scramble", "category": "Melee", "slots": 1, "type": "N/A", "tier": 0, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Friendship", "element": "N/A" },0xdc: { "id": 0xdc, "name": "Vanish", "category": "Support", "slots": 1, "type": "N/A", "tier": 0, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Friendship", "element": "N/A" },0xdd: { "id": 0xdd, "name": "Unison Rush", "category": "Melee", "slots": 3, "type": "N/A", "tier": 0, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Friendship", "element": "N/A" },0xde: { "id": 0xde, "name": "Voltage Stack", "category": "Ranged", "slots": 3, "type": "N/A", "tier": 0, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Friendship", "element": "N/A" },0xdf: { "id": 0xdf, "name": "Trinity Limit", "category": "Ranged", "slots": 3, "type": "N/A", "tier": 0, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Friendship", "element": "N/A" },0xe0: { "id": 0xe0, "name": "Gold", "category": "Dummy", "slots": 1, "type": "N/A", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "Dummy", "element": "N/A" },0xe1: { "id": 0xe1, "name": "Black", "category": "Dummy", "slots": 1, "type": "N/A", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "Dummy", "element": "N/A" },0xe2: { "id": 0xe2, "name": "Finish (Dummy)", "category": "Dummy", "slots": 1, "type": "N/A", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "Dummy", "element": "N/A" },0xe3: { "id": 0xe3, "name": "Wrath of Darkness", "category": "Dummy", "slots": 1, "type": "N/A", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "Dummy", "element": "N/A" },0xe4: { "id": 0xe4, "name": "Sign of Faith", "category": "Dummy", "slots": 1, "type": "N/A", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "Dummy", "element": "N/A" },0xe5: { "id": 0xe5, "name": "Wish Circle", "category": "D-Link", "slots": 1, "type": "N/A", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "D-Link", "element": "N/A" },0xe6: { "id": 0xe6, "name": "Enchanted Step", "category": "D-Link", "slots": 1, "type": "N/A", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "D-Link", "element": "N/A" },0xe7: { "id": 0xe7, "name": "Wish Shot", "category": "D-Link", "slots": 1, "type": "N/A", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "D-Link", "element": "N/A" },0xe8: { "id": 0xe8, "name": "Magic Mending", "category": "D-Link", "slots": 1, "type": "N/A", "tier": 0, "healsHp": 1, "equippableBattleCommand": 0, "supercategory": "D-Link", "element": "N/A" },0xe9: { "id": 0xe9, "name": "Doc", "category": "D-Link", "slots": 1, "type": "N/A", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "D-Link", "element": "N/A" },0xea: { "id": 0xea, "name": "Grumpy", "category": "D-Link", "slots": 1, "type": "N/A", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "D-Link", "element": "N/A" },0xeb: { "id": 0xeb, "name": "Sneezy", "category": "D-Link", "slots": 1, "type": "N/A", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "D-Link", "element": "N/A" },0xec: { "id": 0xec, "name": "Happy", "category": "D-Link", "slots": 1, "type": "N/A", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "D-Link", "element": "N/A" },0xed: { "id": 0xed, "name": "Sleepy", "category": "D-Link", "slots": 1, "type": "N/A", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "D-Link", "element": "N/A" },0xee: { "id": 0xee, "name": "Bashful", "category": "D-Link", "slots": 1, "type": "N/A", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "D-Link", "element": "N/A" },0xef: { "id": 0xef, "name": "Dopey", "category": "D-Link", "slots": 1, "type": "N/A", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "D-Link", "element": "N/A" },0xf0: { "id": 0xf0, "name": "Dark Spiral", "category": "D-Link", "slots": 1, "type": "N/A", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "D-Link", "element": "N/A" },0xf1: { "id": 0xf1, "name": "Dark Splicer", "category": "D-Link", "slots": 1, "type": "N/A", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "D-Link", "element": "N/A" },0xf2: { "id": 0xf2, "name": "Illusion L", "category": "D-Link", "slots": 2, "type": "N/A", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "D-Link", "element": "N/A" },0xf3: { "id": 0xf3, "name": "Illusion R", "category": "D-Link", "slots": 2, "type": "N/A", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "D-Link", "element": "N/A" },0xf4: { "id": 0xf4, "name": "Illusion S", "category": "D-Link", "slots": 2, "type": "N/A", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "D-Link", "element": "N/A" },0xf5: { "id": 0xf5, "name": "Illusion P", "category": "D-Link", "slots": 2, "type": "N/A", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "D-Link", "element": "N/A" },0xf6: { "id": 0xf6, "name": "Illusion D", "category": "D-Link", "slots": 2, "type": "N/A", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "D-Link", "element": "N/A" },0xf7: { "id": 0xf7, "name": "Dummy", "category": "Dummy", "slots": 0, "type": "N/A", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "Dummy", "element": "N/A" },0xf8: { "id": 0xf8, "name": "Slide", "category": "Movement", "slots": 1, "type": "N/A", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "Movement", "element": "N/A" },0xf9: { "id": 0xf9, "name": "Jump", "category": "Movement", "slots": 1, "type": "N/A", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "Movement", "element": "N/A" },0xfa: { "id": 0xfa, "name": "High Jump", "category": "Movement", "slots": 1, "type": "N/A", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "Movement", "element": "N/A" },0xfb: { "id": 0xfb, "name": "Dodge Roll", "category": "Movement", "slots": 1, "type": "N/A", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "Movement", "element": "N/A" },0xfc: { "id": 0xfc, "name": "Thunder Roll", "category": "Movement", "slots": 1, "type": "N/A", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "Movement", "element": "Thunder" },0xfd: { "id": 0xfd, "name": "Cartwheel", "category": "Movement", "slots": 1, "type": "N/A", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "Movement", "element": "N/A" },0xfe: { "id": 0xfe, "name": "Firewheel", "category": "Movement", "slots": 1, "type": "N/A", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "Movement", "element": "Fire" },0xff: { "id": 0xff, "name": "Air Slide", "category": "Movement", "slots": 1, "type": "N/A", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "Movement", "element": "N/A" },0x100: { "id": 0x100, "name": "Ice Slide", "category": "Movement", "slots": 1, "type": "N/A", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "Movement", "element": "N/A" },0x101: { "id": 0x101, "name": "Reversal", "category": "Movement", "slots": 1, "type": "N/A", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "Movement", "element": "N/A" },0x102: { "id": 0x102, "name": "Glide", "category": "Movement", "slots": 1, "type": "N/A", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "Movement", "element": "N/A" },0x103: { "id": 0x103, "name": "Superglide", "category": "Movement", "slots": 1, "type": "N/A", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "Movement", "element": "N/A" },0x104: { "id": 0x104, "name": "Fire Glide", "category": "Movement", "slots": 1, "type": "N/A", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "Movement", "element": "Fire" },0x105: { "id": 0x105, "name": "Homing Slide", "category": "Movement", "slots": 1, "type": "N/A", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "Movement", "element": "N/A" },0x106: { "id": 0x106, "name": "Teleport", "category": "Movement", "slots": 1, "type": "N/A", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "Movement", "element": "N/A" },0x107: { "id": 0x107, "name": "Sonic Impact", "category": "Movement", "slots": 1, "type": "N/A", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "Movement", "element": "Physical" },0x108: { "id": 0x108, "name": "Doubleflight", "category": "Movement", "slots": 1, "type": "N/A", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "Movement", "element": "N/A" },0x109: { "id": 0x109, "name": "Block", "category": "Defense", "slots": 1, "type": "N/A", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "Defense", "element": "N/A" },0x10a: { "id": 0x10a, "name": "Renewal Block", "category": "Defense", "slots": 1, "type": "N/A", "tier": 0, "healsHp": 1, "equippableBattleCommand": 0, "supercategory": "Defense", "element": "N/A" },0x10b: { "id": 0x10b, "name": "Focus Guard", "category": "Defense", "slots": 1, "type": "N/A", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "Defense", "element": "N/A" },0x10c: { "id": 0x10c, "name": "Stun Block", "category": "Defense", "slots": 1, "type": "N/A", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "Defense", "element": "N/A" },0x10d: { "id": 0x10d, "name": "Poison Block", "category": "Defense", "slots": 1, "type": "N/A", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "Defense", "element": "N/A" },0x10e: { "id": 0x10e, "name": "Barrier", "category": "Defense", "slots": 1, "type": "N/A", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "Defense", "element": "N/A" },0x10f: { "id": 0x10f, "name": "Renewal Barrier", "category": "Defense", "slots": 1, "type": "N/A", "tier": 0, "healsHp": 1, "equippableBattleCommand": 0, "supercategory": "Defense", "element": "N/A" },0x110: { "id": 0x110, "name": "Focus Barrier", "category": "Defense", "slots": 1, "type": "N/A", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "Defense", "element": "N/A" },0x111: { "id": 0x111, "name": "Confuse Barrier", "category": "Defense", "slots": 1, "type": "N/A", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "Defense", "element": "N/A" },0x112: { "id": 0x112, "name": "Stop Barrier", "category": "Defense", "slots": 1, "type": "N/A", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "Defense", "element": "N/A" },0x113: { "id": 0x113, "name": "Counter Rush", "category": "Reprisal", "slots": 1, "type": "N/A", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "Reprisal", "element": "N/A" },0x114: { "id": 0x114, "name": "Counter Hammer", "category": "Reprisal", "slots": 1, "type": "N/A", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "Reprisal", "element": "N/A" },0x115: { "id": 0x115, "name": "Reversal Slash", "category": "Reprisal", "slots": 1, "type": "N/A", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "Reprisal", "element": "N/A" },0x116: { "id": 0x116, "name": "Counter Barrier", "category": "Reprisal", "slots": 1, "type": "N/A", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "Reprisal", "element": "N/A" },0x117: { "id": 0x117, "name": "Payback Raid", "category": "Reprisal", "slots": 1, "type": "N/A", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "Reprisal", "element": "N/A" },0x118: { "id": 0x118, "name": "Payback Surge", "category": "Reprisal", "slots": 1, "type": "N/A", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "Reprisal", "element": "N/A" },0x119: { "id": 0x119, "name": "Payback Fang", "category": "Reprisal", "slots": 1, "type": "N/A", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "Reprisal", "element": "N/A" },0x11a: { "id": 0x11a, "name": "Aerial Recovery", "category": "Reprisal", "slots": 1, "type": "N/A", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "Reprisal", "element": "N/A" },0x11b: { "id": 0x11b, "name": "Shotlock", "category": "Dummy", "slots": 1, "type": "N/A", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "Dummy", "element": "N/A" },0x11c: { "id": 0x11c, "name": "Meteor Shower", "category": "Shotlock", "slots": 1, "type": "Blaster", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "Shotlock", "element": "Null" },0x11d: { "id": 0x11d, "name": "Flame Salvo", "category": "Shotlock", "slots": 1, "type": "Blaster", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "Shotlock", "element": "Fire" },0x11e: { "id": 0x11e, "name": "Chaos Snake", "category": "Shotlock", "slots": 1, "type": "Blaster", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "Shotlock", "element": "Null" },0x11f: { "id": 0x11f, "name": "Bubble Blaster", "category": "Shotlock", "slots": 1, "type": "Blaster", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "Shotlock", "element": "Null" },0x120: { "id": 0x120, "name": "Dark Volley", "category": "Shotlock", "slots": 1, "type": "Blaster", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "Shotlock", "element": "Dark" },0x121: { "id": 0x121, "name": "Ragnarok", "category": "Shotlock", "slots": 1, "type": "Ragnarok", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "Shotlock", "element": "Null" },0x122: { "id": 0x122, "name": "Thunderstorm", "category": "Shotlock", "slots": 1, "type": "Ragnarok", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "Shotlock", "element": "Thunder" },0x123: { "id": 0x123, "name": "Bio Barrage", "category": "Shotlock", "slots": 1, "type": "Ragnarok", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "Shotlock", "element": "Thunder" },0x124: { "id": 0x124, "name": "Prism Rain", "category": "Shotlock", "slots": 1, "type": "Ragnarok", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "Shotlock", "element": "Thunder" },0x125: { "id": 0x125, "name": "Pulse Bomb", "category": "Shotlock", "slots": 1, "type": "Ragnarok", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "Shotlock", "element": "Thunder" },0x126: { "id": 0x126, "name": "Photon Charge", "category": "Shotlock", "slots": 1, "type": "Rave", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "Shotlock", "element": "Null" },0x127: { "id": 0x127, "name": "Absolute Zero", "category": "Shotlock", "slots": 1, "type": "Rave", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "Shotlock", "element": "Blizzard" },0x128: { "id": 0x128, "name": "Lightning Ray", "category": "Shotlock", "slots": 1, "type": "Rave", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "Shotlock", "element": "Null" },0x129: { "id": 0x129, "name": "Sonic Shadow", "category": "Shotlock", "slots": 1, "type": "Rave", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "Shotlock", "element": "Null" },0x12a: { "id": 0x12a, "name": "Dark Link", "category": "Shotlock", "slots": 1, "type": "N/A", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "Shotlock", "element": "N/A" },0x12b: { "id": 0x12b, "name": "Ultima Cannon", "category": "Shotlock", "slots": 1, "type": "Ragnarok", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "Shotlock", "element": "Null" },0x12c: { "id": 0x12c, "name": "Lightbloom", "category": "Shotlock", "slots": 1, "type": "Spin", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "Shotlock", "element": "Null" },0x12d: { "id": 0x12d, "name": "Multivortex", "category": "Shotlock", "slots": 1, "type": "Spin", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "Shotlock", "element": "Null" },
}

// Each property element has the following schema:
// property: value
function GetCommandsByProperties(properties)
{
    ret = []
    
    for id in commands
    {
        command = commands[id]
        mismatchFound = False()
        
        for key in properties
        {
            if (command[key] != properties[key])
            {
                mismatchFound = True()
            }
        }
        
        if (mismatchFound == False())
        {
            array_push(ret, command)
        }
    }
    
    return ret
}

// Returns a list of commands for whom `callback()` returns true.
// `callback` is a function that accepts a single parameter, `command`.
function GetCommandsByCallback(callback)
{
    ret = []
    
    for id in commands
    {
        command = commands[id]
        
        if (callback(command) == True())
        {
            array_push(ret, command)
        }
    }
    
    return ret
}

function GetLocationByName(name)
{
    for i in areas
    {
        area = areas[i]
        if (area["name"] == name)
        {
            return area
        }
    }
}

function GetWorldIdByName(name)
{
    for i in worlds
    {
        world = worlds[i]
        if (world == name)
        {
            return i
        }
    }
}

function IsInLocation(name)
{
    area = GetLocationByName(name)
    return areaId() == area["areaId"] && worldId() == area["worldId"]
}

function IsInWorld(name)
{
    world = GetWorldIdByName(name)
    return worldId() == world
}

function WasInLocation(name)
{
    area = GetLocationByName(name)
    return Delta(areaId()) == area["areaId"] && Delta(worldId()) == area["worldId"]
}

function Terra() => 3
function TerraArmored() => 6
function TerraArmoredGlider() => 0xc
function Ventus() => 1
function Aqua() => 2

function TerraOnly() => [ Terra() ]
function VentusOnly() => [ Ventus() ]
function AquaOnly() => [ Aqua() ]

function CharacterIdToNames()
{
    return {
        Terra(): "Terra",
        Aqua(): "Aqua",
        Ventus(): "Ventus",
        TerraArmored(): "Terra",
        TerraArmoredGlider(): "Terra"
    }
}

function GetAreaRPLookup(worldId)
{
    ret = {}
    for id in areas
    {
        area = areas[id]
        if (area["worldId"] == worldId)
        {
            ret[area["areaId"]] = area["display"]
        }
    }
    return ret
}

function playTime() => dword(0x1f19880)

for world in worlds
{
    rich_presence_conditional_display(worldId() == world, "{0}, Level {1} | " + worlds[world] + ": {2} | Play time: {3}",
        rich_presence_lookup("Characters", currentCharacter(), CharacterIdToNames()),
        rich_presence_value("Level", level(), "VALUE"),
        rich_presence_lookup("Areas" + world, areaId(), GetAreaRPLookup(world)),
        rich_presence_value("Play Time", playTime(), "SECS")
    )
}

rich_presence_display("Somewhere in the World...")

achievement(title = "The Final Stargaze", points = 1,
    description = "Complete the prologue.",
    trigger = WasInLocation("DepartureSummitNight") && IsInLocation("MysteriousChamber")
)

function characterFieldPointer() => tbyte(0xb5a4b0)
function hp() => word(characterFieldPointer() + 0xdc0 + 0x1000000)
function characterState() => word(characterFieldPointer() + 0xc50 + 0x1000000)
function currentAttackInCombo() => word(characterFieldPointer() + 0xeb8 + 0x1000000)
function nextAttackInCombo() => word(characterFieldPointer() + 0xeba + 0x1000000)
function mirageArenaCurrentRound() => byte(characterFieldPointer() + 0xb58 + 0x1000000)
function mirageArenaRoundsCompleted() => byte(characterFieldPointer() + 0xb5a + 0x1000000)
function commandBeingUsed() => word(characterFieldPointer() + 0xc98 + 0x1000000)

function characterArenaPointer() => tbyte(0xb59ce8)
function arenaHp() => word(characterArenaPointer() + 0x7c + 0x1000000)
function commandBeingUsedInArena() => word(characterArenaPointer() - 0x149a8 + 0x1000000)
function TookDamageInTheMirageArena() => Delta(arenaHp()) > arenaHp() && characterArenaPointer() != 0

function EnteredAttackState() => Delta(characterState()) != 0x10 && characterState() == 0x10
function IsUsingFinisher() => characterState() == 0x14
function IsGuarding() => characterState() == 0x16
function IsUsingAPhysicalAttack() => characterState() == 0x10
function IsUsingAStandardAttack() => currentAttackInCombo() != 0 && nextAttackInCombo() != 0

function dLinkPointer() => tbyte(0xb59ce8)
function dLinkCharge() => dword(dLinkPointer() + 0x1000000 + 0x3c) // todo: actually a float; change when supported
function commandGaugeCharge() => dword(dLinkPointer() + 0x1000000 + 0x1d30) // todo: also a float
function IsUsingDLink() => Delta(dLinkCharge()) > dLinkCharge() && dLinkPointer() != 0
function CommandGaugeEmptied() => Delta(commandGaugeCharge()) != commandGaugeCharge() && commandGaugeCharge() == 0

function JustUsedAnyGivenCommand(haystack)
{
    trigger = always_false()
    commandIds = GetIdsFromObjects(haystack)
    clusters = GetClustersFromList(commandIds)
    for needle in clusters
    {
        if (needle["min"] == needle["max"])
        {
            trigger = trigger || Delta(commandBeingUsed()) == 0 && commandBeingUsed() == needle["min"]
        }
        else
        {
            trigger = trigger || Delta(commandBeingUsed()) == 0 && commandBeingUsed() >= needle["min"] && commandBeingUsed() <= needle["max"]
        }
    }
    return trigger
}

function JustUsedAnyGivenCommandInArena(haystack)
{
    trigger = always_false()
    for needle in haystack
    {
        trigger = trigger || Delta(commandBeingUsedInArena()) == 0 && commandBeingUsedInArena() == needle["id"]
    }
    return trigger
}

function CheckpointPassedForCharacters(checkpointLogic, allowedCharacters, resetOnDeath = 0)
{
    characterIsAllowed = always_false()
    
    for character in allowedCharacters
    {
        characterIsAllowed = characterIsAllowed || currentCharacter() == character
    }
    
    returnedLogic = once(checkpointLogic && characterIsAllowed)
    
    if (resetOnDeath == True())
    {
        returnedLogic = returnedLogic && never(GameOverTriggered())
    }

    return returnedLogic
}

// charactersToTrigger: a dictionary of character IDs to trigger logic; each logical statement will only apply if the player is controlling a specific character
function TriggerConditionsMetForCharacters(charactersToTriggerLogic, useTrigger = 0)
{
    triggerMet = always_false()
    for id in charactersToTriggerLogic
    {
        characterLogicIsMet = charactersToTriggerLogic[id]
        
        if (useTrigger == True())
        {
            characterLogicIsMet = trigger_when(characterLogicIsMet)
        }
        
        triggerMet = triggerMet || characterLogicIsMet && currentCharacter() == id
    }
    
    return triggerMet 
}

function battleFlagsAddr() => 0xb5a4b4
function IsInBattle() => bit0(battleFlagsAddr()) == 1
function HUDAndAttacksDisabled() => bit5(0xb5a4b5) == 1
function GameOverTriggered() => IsInBattle() && HUDAndAttacksDisabled() && hp() == 0 && characterFieldPointer() != 0
function BossDefeatTriggered() => IsInBattle() && bit3(battleFlagsAddr()) == 1 && bit5(battleFlagsAddr()) == 1 && hp() > 0 && characterFieldPointer() != 0
function IsPausing() => always_false()
function FrameAdvanced() => Delta(systemTimer()) != systemTimer()

function firstCommandSlotAddr() => 0x1f29388
function lastCommandSlotAddr() => 0x1f2a9b8
function JustObtainedCommandWithId(id, useTrigger = 0)
{
    trigger = always_false()
    for addr in range(firstCommandSlotAddr(), lastCommandSlotAddr(), 10)
    {
        slotI = word(addr)
        condition = Delta(slotI) == 0 && slotI == id
        
        if (useTrigger == True())
        {
            condition = trigger_when(condition)
        }
        
        trigger = trigger || condition
    }
    
    return trigger
}

function informationBarState() => byte(0x1f3d760)
function InformationBarJustPoppedUp() => Delta(informationBarState()) == 1 && informationBarState() == 2
function InformationBarPoppedUpOnce() => once(InformationBarJustPoppedUp())
function criticalImpactState() => byte(0x1f2accc)
function LearnedCriticalImpact() => criticalImpactState() == 5 && Delta(criticalImpactState()) == 0

function MarkOfMasteryCheckpointReached() => CheckpointPassedForCharacters(InformationBarPoppedUpOnce()
    && IsInLocation("DepartureGreatHall"), [ Terra(), Ventus(), Aqua() ], True()
)
    
function TriggerConditionsMetForMarkOfMastery() =>
    TriggerConditionsMetForCharacters({
        Terra(): LearnedCriticalImpact()
    }, True())

achievement(title = "Hit Ball to Pass Test [m]", points = 3,
    description = "Complete the first phase of the Mark of Mastery using only one attack or fewer.",
    trigger = MarkOfMasteryCheckpointReached() && never(repeated(2, EnteredAttackState()))
        && TriggerConditionsMetForMarkOfMastery()
)

function diamondDustState() => byte(0x1f2acd0)
function LearnedDiamondDust() => diamondDustState() == 5 && Delta(diamondDustState()) == 0

achievement(title = "Snap the Spindle [m]", points = 25,
    description = "Finish off the Wheel Master in Enchanted Dominion with a Finish command (Proud Mode or higher, Level 1).",
    trigger = CheckpointPassedForCharacters(InformationBarPoppedUpOnce()
        && IsInLocation("EnchantedAudience2"), TerraOnly(), True()
    ) && TriggerConditionsMetForCharacters({
        Terra(): LearnedDiamondDust()
    }, True()) && trigger_when(IsUsingFinisher())
    && IsAtLeastOnDifficulty("Proud") && level() == 1
    && never(!IsInLocation("EnchantedAudience2"))
)

function enchantedDominionTerraStoryEntry() => bit0(0x1f28485)
achievement(title = "The First of Seven", points = 3,
    description = "Complete Enchanted Dominion as Terra.",
    trigger = WasBitflagSetInGame(enchantedDominionTerraStoryEntry()) && IsInLocation("WorldMap")
)

function counterHammerId() => 0x114
achievement(title = "Chipped Shield [m]", points = 10,
    description = "Escort Cinderella to the ball without guarding (Critical Mode, Level 3 or below).",
    trigger = IsAlwaysInGame()
        && CheckpointPassedForCharacters(once(InformationBarJustPoppedUp() && IsInLocation("CastleCorridor")) && IsAtLeastOnDifficulty("Critical") && level() <= 3, TerraOnly(), False())
        && TriggerConditionsMetForCharacters({
            Terra(): (JustObtainedCommandWithId(counterHammerId(), True()) && trigger_when(IsInLocation("CastleFoyer")))
        }, False())
        && unless(characterFieldPointer() == 0) // Prevent resets when transitioning to the foyer.
        && never(IsGuarding())
)

// NOTE: It's theoretically possible to defeat more than one enemy at a time in this battle. As such, I'll consider it a valid unlock if the player defeats more than one instrument ONLY IF
// the boss itself is defeated in the same frame. We need to do this because the number of active enemies is set to zero as soon as the boss is defeated.
function symphonyMastersDefeated() => word(0x1f35fc4)
achievement(title = "Syncopation [m]", points = 25,
    description = "Defeat the Symphony Master without destroying more than one instrument (Proud Mode or higher, Level 3 or below).",
    trigger = CheckpointPassedForCharacters(InformationBarPoppedUpOnce()
        && IsInLocation("CastleBallroom"), TerraOnly(), True()
    ) && TriggerConditionsMetForCharacters({
        Terra(): WasValueSetInGame(symphonyMastersDefeated(), 0, 1)
    }, True()) && trigger_when(Delta(numberOfActiveEnemies()) >= 3 && numberOfActiveEnemies() == 0)
    && IsAtLeastOnDifficulty("Proud") && level() <= 3
    && never(!IsInLocation("CastleBallroom"))
)

function castleOfDreamsTerraStoryEntry() => bit7(0x1f28464)
achievement(title = "Boundless Faith", points = 3,
    description = "Complete the Castle of Dreams as Terra.",
    trigger = WasBitflagSetInGame(castleOfDreamsTerraStoryEntry()) && IsInLocation("WorldMap")
)

function fissionFiragaTerraChest() => bit3(0x1f2927f)
function dwarfWoodlandsTerraStoryEntry() => bit7(0x1f28444)
achievement(title = "Swiping the Cookie Jar [m]", points = 5,
    description = "Open the Fission Firaga chest in Dwarf Woodlands as Terra before defeating the boss.",
    trigger = WasBitflagSetInGame(fissionFiragaTerraChest()) && dwarfWoodlandsTerraStoryEntry() == 0
)

function commandInventorySlot1BaseAddr() => 0x1f29388
function deck1Slot1BaseAddr() => 0x1f2b91c
function deck2Slot1BaseAddr() => 0x1f2b9e0
function deck3Slot1BaseAddr() => 0x1f2baa4
function commandInventoryWidth() => 10
function commandIndexWidth() => 6
function maxNumberOfInventorySlots() => 569
function currentDeck() => byte(0x1f2bb78)
function CurrentDeckIs(deckId) => currentDeck() == deckId - 1
function maxNumberOfCommandSlots() => 8

function HasAnyOfTheGivenCommandsEquipped(commands)
{
    commandIds = GetIdsFromObjects(commands)
    clusters = GetClustersFromList(commandIds)
    trigger = always_false()
    slotBaseAddrs = [ deck1Slot1BaseAddr(), deck2Slot1BaseAddr(), deck3Slot1BaseAddr() ]
    
    for deck in range(0, 2)
    {
        for i in range(0, maxNumberOfCommandSlots() - 1)
        {
            inventoryIndex = word(slotBaseAddrs[deck] + i * commandIndexWidth()) // 0xffff when no command is equipped
            inventoryOffset = inventoryIndex * commandInventoryWidth() // The memory offset from the beginning of the inventory where the command lies
            inventoryCommandId = word(commandInventorySlot1BaseAddr() + inventoryOffset) // The accessor containing the actual command ID
            
            for cluster in clusters
            {
                idLiesInCluster = always_false()
                if (cluster["min"] == cluster["max"]) // Just for a little optimization
                {
                    idLiesInCluster = inventoryCommandId == cluster["min"]
                }
                else
                {
                    idLiesInCluster = inventoryCommandId >= cluster["min"] && inventoryCommandId <= cluster["max"]
                }
                
                trigger = trigger || idLiesInCluster && currentDeck() == deck && inventoryIndex != 0xffff
            }
        }
    }
    
    return trigger
}

function Debug(text)
{
    achievement(title = text + "", description = "", points = 0, trigger = always_false())
}

function CreateCommandDenylistFromAllowlist(allowlist)
{
    denylist = []
    
    for i in commands
    {
        command = commands[i]
        commandFound = False()
        
        for allowed in allowlist
        {
            if (allowed["id"] == command["id"])
            {
                commandFound = True()
            }
        }
        
        if (commandFound == False())
        {
            array_push(denylist, command)
        }
    }
    
    return denylist
}

function HasOnlyTheGivenCommandsEquipped(commands)
{
    denylistedCommands = CreateCommandDenylistFromAllowlist(commands)
    return never(HasAnyOfTheGivenCommandsEquipped(denylistedCommands))
}

function deckCapacity() => byte(0x1f19b16)
function DeckCapacityIncreased() => WasValueIncreasedByAmountInGame(deckCapacity(), 1)
function firestormState() => byte(0x1f2accf)
function FirestormLearned() => firestormState() == 5 && Delta(firestormState()) == 0
statusCommands = GetCommandsByProperties({ "type": "Status Effect" })
cureCommands = GetCommandsByProperties({ "type": "Cure" })
achievement(title = "Sleeping Death [m]", points = 10,
    description = "Defeat the Spirit of the Magic Mirror equipping battle commands that only inflict status effects (Proud Mode or higher, Level 4 or below, no D-Links).",
    trigger = HasOnlyTheGivenCommandsEquipped(statusCommands)
        && CheckpointPassedForCharacters(InformationBarPoppedUpOnce()
            && IsInLocation("DwarfMirror"), [Terra(), Aqua() ], True()
        ) && TriggerConditionsMetForCharacters({
            Terra(): FirestormLearned(),
            Aqua(): DeckCapacityIncreased()
        }, True()) && trigger_when(Delta(numberOfActiveEnemies()) >= 1 && numberOfActiveEnemies() == 0)
        && IsAtLeastOnDifficulty("Proud") && level() <= 4
        && never(!IsInLocation("DwarfMirror"))
        && never(IsUsingDLink())
)

achievement(title = "A Grave Riddle", points = 3,
    description = "Complete the Dwarf Woodlands as Terra.",
    trigger = WasBitflagSetInGame(dwarfWoodlandsTerraStoryEntry()) && IsInLocation("WorldMap")
)

function IsAbilityTurnedOn(addr)
{
    return bit0(addr) + bit1(addr) * 2 + bit2(addr) * 4 > 0
}

function trinityArmorsDefeated() => word(0x1f35fd6)
function TrinityArmorWasJustDefeated() => Delta(trinityArmorsDefeated()) < trinityArmorsDefeated()
function secondChanceActiveAddr() => 0x1f2acbc
function onceMoreActiveAddr() => 0x1f2acc0
achievement(title = "Face, Meet Cannon [m]", points = 10,
    description = "Defeat the Trinity Armor in Radiant Garden without Second Chance or Once More equipped (Critical Mode, Level 6 or below).",
    trigger = IsAlwaysInGame()
        && CheckpointPassedForCharacters(once(InformationBarJustPoppedUp() && IsInLocation("RadiantReactor")) && IsAtLeastOnDifficulty("Critical") && level() <= 6, [ Terra(), Ventus(), Aqua() ], True())
        && TriggerConditionsMetForCharacters({
            Terra(): TrinityArmorWasJustDefeated(),
            Ventus(): TrinityArmorWasJustDefeated(),
            Aqua(): TrinityArmorWasJustDefeated()
        }, True())
        && never(IsAbilityTurnedOn(secondChanceActiveAddr()))
        && never(IsAbilityTurnedOn(onceMoreActiveAddr()))
)

achievement(title = "He Who Liveth by the Sword... [m]", points = 10,
    description = "Defeat Braig in Radiant Garden without using any standard attacks (Proud Mode or higher, Level 6 or below).",
    trigger = CheckpointPassedForCharacters(InformationBarPoppedUpOnce()
        && IsInLocation("RadiantPurification"), TerraOnly(), True()
    ) && TriggerConditionsMetForCharacters({
        Terra(): DeckCapacityIncreased()
    }, True())
    && IsAtLeastOnDifficulty("Proud") && level() <= 6
    && never(!IsInLocation("RadiantPurification"))
    && never(IsUsingAStandardAttack())
)

function radiantGardenTerraStoryEntry() => bit5(0x1f284c5)
achievement(title = "The Shame of Sin", points = 3,
    description = "Complete Radiant Garden as Terra.",
    trigger = WasBitflagSetInGame(radiantGardenTerraStoryEntry()) && IsInLocation("WorldMap")
)

function breakTimeChest() => bit3(0x1f29294)
achievement(title = "Full Tilt", points = 5,
    description = "Obtain the Break Time command from a chest in Disney Town.",
    trigger = WasBitflagSetInGame(breakTimeChest())
)

function maxHp() => word(0x1f19afc)
function MaxHPIncreased() => Delta(maxHp()) < maxHp()
nonHealingMagicCommands = GetCommandsByProperties({ "supercategory": "Magic", "healsHp": False() })
function BeganFinalsAsTerra() => bit4(0x1f28505) == 1
achievement(title = "Self-Reliance [m]", points = 50,
    description = "Reach the finals of the Olympus Coliseum Games as Terra without using D-Links or non-healing magic commands (Proud Mode or higher, Level 8 or below).",
    trigger = CheckpointPassedForCharacters(InformationBarPoppedUpOnce()
            && IsInLocation("OlympusEast"), TerraOnly(), True())
            && TriggerConditionsMetForCharacters({
                Terra(): MaxHPIncreased()
            }, True())
        && IsAtLeastOnDifficulty("Proud") && level() <= 8
        && never(!IsInLocation("OlympusEast"))
        && never(IsUsingDLink())
        && never(JustUsedAnyGivenCommand(nonHealingMagicCommands))
        && !BeganFinalsAsTerra()
)

function ForbiddenCommandsAgainstZackCallback(command)
{
    if (command["element"] != "N/A" && command["element"] != "Null" && command["element"] != "Physical" && command["id"] != 0xffff)
    {
        return True()
    }
    else
    {
        return False()
    }
}

forbiddenCommandsAgainstZack = GetCommandsByCallback(ForbiddenCommandsAgainstZackCallback)
function DefeatedZackForTheFirstTime() => bit2(0x1f28505) == 1
achievement(title = "Out of Your Element [m]", points = 10,
    description = "Win your second fight against Zack using only physical- or null-elemental commands (Proud Mode or higher, Level 8 or below).",
    trigger = CheckpointPassedForCharacters(InformationBarPoppedUpOnce()
            && IsInLocation("OlympusEast"), TerraOnly(), True())
            && TriggerConditionsMetForCharacters({
                // The second fight yields no reward, so we must use something that may be less than reliable here...
                Terra(): BossDefeatTriggered()
            }, True())
        && IsAtLeastOnDifficulty("Proud") && level() <= 8
        && never(!IsInLocation("OlympusEast"))
        && never(JustUsedAnyGivenCommand(forbiddenCommandsAgainstZack))
        && BeganFinalsAsTerra()
        && never(!DefeatedZackForTheFirstTime())
)

function olympusColiseumTerraStoryEntry() => bit3(0x1f28505)
achievement(title = "First-Class Soldier", points = 3,
    description = "Complete Olympus Coliseum as Terra.",
    trigger = WasBitflagSetInGame(olympusColiseumTerraStoryEntry()) && IsInLocation("WorldMap")
)

fireCommands = GetCommandsByProperties({ "element": "Fire" })
function thunderboltState() => byte(0x1f2acd1)
function ThunderboltLearned() => Delta(thunderboltState()) == 0 && thunderboltState() == 5
achievement(title = "Hypoxic Cabin [m]", points = 5,
    description = "Defeat Experiment 221 without using any fire-elemental commands (Proud Mode or higher, Level 11 or below).",
    trigger = CheckpointPassedForCharacters(InformationBarPoppedUpOnce()
            && IsInLocation("SpacePod"), TerraOnly(), True())
            && TriggerConditionsMetForCharacters({
                Terra(): ThunderboltLearned()
            }, True())
        && IsAtLeastOnDifficulty("Proud") && level() <= 11
        && never(!IsInLocation("SpacePod"))
        && never(JustUsedAnyGivenCommand(fireCommands))
)

function deepSpaceTerraStoryEntry() => bit7(0x1f28524)
achievement(title = "For but a Moment", points = 3,
    description = "Complete Deep Space as Terra.",
    trigger = WasBitflagSetInGame(deepSpaceTerraStoryEntry()) && IsInLocation("WorldMap")
)

function UsedAnyUniqueCommandsGivenNumberOfTimes(usableCommands, usages)
{
    trigger = []
    
    for command in usableCommands
    {
        array_push(trigger, once(Delta(commandBeingUsed()) == 0 && commandBeingUsed() == command["id"]))
    }
    
    return tally(usages, trigger)
}

function UsedAnyUniqueCommandsGivenNumberOfTimesInArena(usableCommands, usages)
{
    trigger = []
    
    for command in usableCommands
    {
        array_push(trigger, once(Delta(commandBeingUsedInArena()) == 0 && commandBeingUsedInArena() == command["id"]))
    }
    
    return tally(usages, trigger)
}

function BattleCommandsCallback(command)
{
    if (command["supercategory"] == "Attack" || command["supercategory"] == "Magic" || command["supercategory"] == "Item" || command["supercategory"] == "Friendship"
        || command["supercategory"] == "D-Link")
    {
        return True()
    }
    else
    {
        return False()
    }
}

function JumpCommandsCallback(command)
{
    if (command["name"] == "Jump" || command["name"] == "High Jump")
    {
        return True()
    }
    else
    {
        return False()
    }
}

jumpCommands = GetCommandsByCallback(JumpCommandsCallback)
battleCommands = GetCommandsByCallback(BattleCommandsCallback)
function bladechargeState() => byte(0x1f2acd3)
function BladechargeLearned() => Delta(bladechargeState()) == 0 && bladechargeState() == 5
function DefeatedPeterPan() => bit5(0x1f28564) == 1
achievement(title = "Minesweeper [m]", points = 5,
    description = "Defeat Peter Pan using only one type of battle command and without taking damage (Proud Mode or higher, Level 15 or below).",
    trigger = CheckpointPassedForCharacters(InformationBarPoppedUpOnce()
        && IsInLocation("NeverlandSkullCavern"), TerraOnly(), True())
        && TriggerConditionsMetForCharacters({
            Terra(): BladechargeLearned()
        }, True())
        && IsAtLeastOnDifficulty("Proud") && level() <= 15
        && never(!IsInLocation("NeverlandSkullCavern"))
        && never(UsedAnyUniqueCommandsGivenNumberOfTimes(battleCommands, 2))
        && never(Delta(hp()) > hp())
        && never(DefeatedPeterPan())
)

function neverlandTerraStoryEntry() => bit1(0x1f28565)
achievement(title = "One Man's Treasure", points = 3,
    description = "Complete Neverland as Terra.",
    trigger = WasBitflagSetInGame(neverlandTerraStoryEntry()) && IsInLocation("LanesBetween")
)

achievement(title = "Claimed by the Abyss [m]", points = 25,
    description = "Defeat Eraqus without ever leaving the Dark Impulse Command Style (Proud Mode or higher, Level 16 or below).",
    trigger = CheckpointPassedForCharacters(InformationBarPoppedUpOnce()
        && IsInLocation("DepartureForecourtDay"), TerraOnly(), True())
        && TriggerConditionsMetForCharacters({
            Terra(): MaxHPIncreased()
        }, True())
        && IsAtLeastOnDifficulty("Proud") && level() <= 16
        && never(!IsInLocation("DepartureForecourtDay"))
        && never(CommandGaugeEmptied())
)

function landOfDepartureIITerraStoryEntry() => bit0(0x1f28425)
achievement(title = "Patricide", points = 3,
    description = "Complete Terra's second visit to the Land of Departure.",
    trigger = WasBitflagSetInGame(landOfDepartureIITerraStoryEntry()) && IsInLocation("WorldMap")
)

function DefeatedXehanortI() => bit0(0x1f285a5) == 1
achievement(title = "Give Me Strength [m]", points = 10,
    description = "Defeat Xehanort solo using only battle commands while a D-Link is active (Proud Mode or higher, Level 20 or below).",
    trigger = CheckpointPassedForCharacters(InformationBarPoppedUpOnce()
        && IsInLocation("Graveyard3"), TerraOnly(), True())
        && TriggerConditionsMetForCharacters({
            Terra(): MaxHPIncreased()
        }, True())
        && IsAtLeastOnDifficulty("Proud") && level() <= 20
        && never(!IsInLocation("Graveyard3"))
        && never(!DefeatedXehanortI())
        && (always_true() || never(JustUsedAnyGivenCommand(battleCommands)) && unless(IsUsingDLink()))
)

function CureFamilyCommandsCallback(command)
{
    if (command["name"] == "Cure" || command["name"] == "Cura" || command["name"] == "Curaga")
    {
        return True()
    }
    else
    {
        return False()
    }
}

function DefeatedXehanortII() => bit1(0x1f285a5) == 1
cureFamilyCommands = GetCommandsByCallback(CureFamilyCommandsCallback)
achievement(title = "Terminal Corruption [m]", points = 50,
    description = "Defeat Terra-Xehanort in the Keyblade Graveyard without using any commands in the Cure family (Proud Mode or higher, Level 20 or below).",
    trigger = CheckpointPassedForCharacters(InformationBarPoppedUpOnce()
        && IsInLocation("GraveyardCage"), [ TerraArmored() ], True())
        && TriggerConditionsMetForCharacters({
            // The final boss, of course, yields no rewards.
            TerraArmored(): BossDefeatTriggered()
        }, True())
        && IsAtLeastOnDifficulty("Proud") && level() <= 20
        && never(!IsInLocation("GraveyardCage"))
        && never(JustUsedAnyGivenCommand(cureFamilyCommands))
)

function gameStateDeterminer() => byte(0xb47ade)
function xehanortReport11() => bit0(0x1f2932d)
function ViewedBattleReportLongEnough() => once(Delta(gameStateDeterminer()) == 0xd && gameStateDeterminer() == 0x81) && repeated(60, gameStateDeterminer() == 0x81)
function TerraStoryCompleted() => WasBitflagSetInGame(xehanortReport11()) && ViewedBattleReportLongEnough() && currentCharacter() == TerraArmored()
achievement(title = "The Vessel", points = 10, // todo: name subject to change
    description = "Complete Terra's story.",
    trigger = TerraStoryCompleted()
)

achievement(title = "Proud Warrior [m]", points = 10,
    description = "Complete Terra's Story on Proud Mode or higher.",
    trigger = TerraStoryCompleted() && IsAtLeastOnDifficulty("Proud")
)

achievement(title = "Critical Warrior [m]", points = 25,
    description = "Complete Terra's story on Critical Mode.",
    trigger = TerraStoryCompleted() && IsAtLeastOnDifficulty("Critical")
)

achievement(title = "Apotheosis [m]", points = 100,
    description = "Complete any character's story at Level 1 on Critical Mode.",
    trigger = level() == 1 && IsAtLeastOnDifficulty("Critical")
        && TerraStoryCompleted() // todo: add more characters' stories later
)

// We're checking for a pointer-esque format rather than checking for NULL here because this address flickers between values before finally settling onto the final pointer address
// when the race begins.
function AddressIsPointer(addr) => byte(addr + 3) == 0x8 || byte(addr + 3) == 0x9

function rumbleRacingPointerAddr() => 0x1944774
function rumbleRacingPointer() => dword(rumbleRacingPointerAddr()) - 0x8000000
function rumbleRacingState() => dword(rumbleRacingPointer() - 0x1a0)
function RumbleRacingIntroWasJustPlaying() => Delta(rumbleRacingState()) == 4 && AddressIsPointer(rumbleRacingPointerAddr())
function RumbleRacingCountingDown() => rumbleRacingState() == 5 && AddressIsPointer(rumbleRacingPointerAddr())
function RumbleRacingWasJustInProgress() => Delta(rumbleRacingState()) == 6 && AddressIsPointer(rumbleRacingPointerAddr())
function RumbleRacingFinished() => rumbleRacingState() == 7 && AddressIsPointer(rumbleRacingPointerAddr())
function rumbleRacingElapsedMinutes() => dword(rumbleRacingPointer() - 0x16c)
function rumbleRacingElapsedSeconds() => dword(rumbleRacingPointer() - 0x168)
function rumbleRacingElapsedCentiseconds() => dword(rumbleRacingPointer() - 0x164)
function rumbleRacingTotalLaps() => dword(rumbleRacingPointer() - 0x148)

// The final time will still always be off by a couple centiseconds here, but deltas are probably the best we can do right now unless there's a hidden time
// address that gets set that I don't know about. This will at least ensure that recorded time will always be slightly in the player's favor, if only by a couple centiseconds.
function RumbleRacingRecordableTimeElapsed() => Delta(rumbleRacingElapsedMinutes()) * 6000 + Delta(rumbleRacingElapsedSeconds()) * 100 + Delta(rumbleRacingElapsedCentiseconds())
function RumbleRacingJustFinished() => RumbleRacingWasJustInProgress() && RumbleRacingFinished()

function CreateRumbleRacingAchievementAndLeaderboard(achievementName, location, timeLimit, points)
{
    rumbleRacingCheckpointReached = once(RumbleRacingIntroWasJustPlaying() && RumbleRacingCountingDown() && IsInLocation(location["name"]) && rumbleRacingTotalLaps() == 5)
    isInRaceLocation = AddressIsPointer(rumbleRacingPointerAddr()) && IsInLocation(location["name"])
    achievement(title = achievementName, points = points,
        description = "Finish a five-lap race on the " + location["display"] + " course in Rumble Racing in " + SecondsToFormat(timeLimit) + ".",
        trigger = rumbleRacingCheckpointReached
            && trigger_when(RumbleRacingJustFinished())
            && RumbleRacingRecordableTimeElapsed() <= timeLimit * 100
            && never(!isInRaceLocation)
    )
    
    leaderboard(title = "Rumble Racing - " + location["display"] + " (5 Laps)", description = "Race to the finish!",
        start = rumbleRacingCheckpointReached,
        cancel = !isInRaceLocation,
        submit = RumbleRacingJustFinished(),
        value = RumbleRacingRecordableTimeElapsed()
    )
}

CreateRumbleRacingAchievementAndLeaderboard("Country Thrills", GetLocationByName("DisneyCountryChase"), 125, 10)

CreateRumbleRacingAchievementAndLeaderboard("Disney Town Dragster", GetLocationByName("DisneyDrive"), 246, 10)

CreateRumbleRacingAchievementAndLeaderboard("Prix Spree", GetLocationByName("DisneySpree"), 294, 25)

CreateRumbleRacingAchievementAndLeaderboard("Castle Crasher", GetLocationByName("DisneyCastle"), 236, 50)

GenerateCheevoFromBits(name = "Sticker Warrior", description = "Collect every sticker in Terra's story.", points = 5,
    threshold = 20,
    addresses = {
        1: { "addr": 0x1f2929c, "bit": 1 },
        2: { "addr": 0x1f2929c, "bit": 2 },
        3: { "addr": 0x1f2929c, "bit": 3 },
        4: { "addr": 0x1f2929c, "bit": 4 },
        5: { "addr": 0x1f2929c, "bit": 5 },
        6: { "addr": 0x1f2929c, "bit": 6 },
        7: { "addr": 0x1f2929c, "bit": 7 },
        8: { "addr": 0x1f2929d, "bit": 0 },
        9: { "addr": 0x1f2929d, "bit": 1 },
        10: { "addr": 0x1f2929d, "bit": 2 },
        11: { "addr": 0x1f2929d, "bit": 3 },
        12: { "addr": 0x1f2929e, "bit": 2 },
        13: { "addr": 0x1f2929e, "bit": 3 },
        14: { "addr": 0x1f2929d, "bit": 4 },
        15: { "addr": 0x1f2929d, "bit": 5 },
        16: { "addr": 0x1f2929d, "bit": 6 },
        17: { "addr": 0x1f2929e, "bit": 1 },
        18: { "addr": 0x1f2929d, "bit": 7 },
        19: { "addr": 0x1f2929e, "bit": 0 },
        20: { "addr": 0x1f2929e, "bit": 4 },
    }
)

function finishCommandWidth() => 8
function finishCommandArraySize() => 15

function UnlockedFinishCommand(id)
{
    trigger = always_false()
    
    for i in range(0, finishCommandArraySize() - 1)
    {
        finishCommandBaseAddr = 0x1f2b534
        commandStatus = byte(finishCommandBaseAddr + i * finishCommandWidth() + 2)
        commandId = word(finishCommandBaseAddr + i * finishCommandWidth())
        
        trigger = trigger || commandId == id && Delta(commandStatus) == 1 && commandStatus == 2
    }
    
    return trigger
}

achievement(title = "Apex of War", points = 5,
    description = "Unlock Terra's ultimate Finish command.",
    trigger = UnlockedFinishCommand(0x5a) && (currentCharacter() == Terra() || currentCharacter() == TerraArmored() || currentCharacter() == TerraArmoredGlider())
)

GenerateCheevoFromBits(name = "Career Rumbler", description = "Complete all Rumble Racing Arena Missions for any character.", points = 5,
    threshold = 4,
    addresses = {
        1: { "addr": 0x1f35d7e, "bit": 2 },
        2: { "addr": 0x1f35d7e, "bit": 3 },
        3: { "addr": 0x1f35d7e, "bit": 4 },
        4: { "addr": 0x1f35d7e, "bit": 5 },
    }
)

GenerateCheevoFromBits(name = "Medal Detector", description = "Complete all medal Arena Missions for any character.", points = 10,
    threshold = 6,
    addresses = {
        1: { "addr": 0x1f35d7c, "bit": 0 },
        2: { "addr": 0x1f35d7c, "bit": 1 },
        3: { "addr": 0x1f35d7c, "bit": 2 },
        4: { "addr": 0x1f35d7c, "bit": 3 },
        5: { "addr": 0x1f35d7c, "bit": 4 },
        6: { "addr": 0x1f35d7c, "bit": 5 },
    }
)

GenerateCheevoFromBits(name = "Command Street", description = "Complete all Command Board Arena Missions for any character.", points = 10,
    threshold = 4,
    addresses = {
        1: { "addr": 0x1f35d7f, "bit": 1 },
        2: { "addr": 0x1f35d7f, "bit": 2 },
        3: { "addr": 0x1f35d7f, "bit": 3 },
        4: { "addr": 0x1f35d7f, "bit": 4 },
    }
)

GenerateCheevoFromBits(name = "Savage Slayer", description = "Complete all Arena Mode Arena Missions for any character.", points = 25,
    threshold = 15,
    addresses = {
        1: { "addr": 0x1f35d7c, "bit": 6 }, // Day of Reckoning
        2: { "addr": 0x1f35d7c, "bit": 7 }, // Wheels of Misfortune
        3: { "addr": 0x1f35d7d, "bit": 0 }, // Risky Riches
        4: { "addr": 0x1f35d7d, "bit": 1 }, // Weaver Fever
        5: { "addr": 0x1f35d7d, "bit": 2 }, // Sinister Sentinel
        6: { "addr": 0x1f35d7d, "bit": 3 }, // Dead Ringer
        7: { "addr": 0x1f35d7d, "bit": 4 }, // Combined Threat
        8: { "addr": 0x1f35d7d, "bit": 5 }, // Treasure Tussle
        9: { "addr": 0x1f35d7d, "bit": 6 }, // Harsh Punishment
        10: { "addr": 0x1f35d7d, "bit": 7 }, // A Time to Chill
        11: { "addr": 0x1f35d7e, "bit": 0 }, // Copycat Crisis
        12: { "addr": 0x1f35d7e, "bit": 1 }, // Keepers of the Arena
        13: { "addr": 0x1f35d7e, "bit": 6 }, // Monster of the Sea
        14: { "addr": 0x1f35d7e, "bit": 7 }, // Villains' Vendetta
        15: { "addr": 0x1f35d7f, "bit": 0 }, // Light's Lessons
    }
)

function HostingArenaEvent() => bit0(0x194e9f0) == 1
function mirageArenaEvent() => word(0x194ea38)

function DayOfReckoningCallback(command)
{
    if (command["healsHp"] == True() && command["name"] != "Cure")
    {
        return True()
    }
    else
    {
        return False()
    }
}

dayOfReckoningForbiddenHealingCommands = GetCommandsByCallback(DayOfReckoningCallback)
cureCommand = GetCommandsByProperties({ "name": "Cure" })
cureLimit = 3

function MirageArenaCheckpointPassedCallback(eventId, locationName) => once(HostingArenaEvent() && mirageArenaEvent() == eventId && IsInLocation(locationName))

function MirageArenaCheckpointReachedForCharacters(eventId, locationName, characters, numberOfRounds)
{
    return CheckpointPassedForCharacters(MirageArenaCheckpointPassedCallback(eventId, locationName), characters, False())
        && never(!WasInLocation(locationName) && IsInLocation("MirageHub"))
        && trigger_when(mirageArenaRoundsCompleted() == numberOfRounds)
}

achievement(title = "Prison Rations [m]", points = 10,
    description = "Complete \"Day of Reckoning\" in the Mirage Arena using Cure as your only healing command no more than thrice (Critical Mode, Level 8 or below).",
    trigger = never(JustUsedAnyGivenCommandInArena(dayOfReckoningForbiddenHealingCommands))
        && never(repeated(cureLimit + 1, JustUsedAnyGivenCommandInArena(cureCommand)))
        && MirageArenaCheckpointReachedForCharacters(1, "MirageArena1", [ TerraArmored() ], 4) // todo: insert other characters
        && IsAtLeastOnDifficulty("Critical") && level() <= 8
)

function HasDuplicateCommandInDeckOfSize(haystack, deckId, deckSize = 8)
{
    trigger = always_false()
    slotBaseAddrs = [ deck1Slot1BaseAddr(), deck2Slot1BaseAddr(), deck3Slot1BaseAddr() ]
    
    for commandToCheckForDuplicate in haystack
    {
        commandChecks = []
        
        for i in range(0, deckSize)
        {
            inventoryIndex = word(slotBaseAddrs[deckId - 1] + i * commandIndexWidth()) // 0xffff when no command is equipped
            inventoryOffset = inventoryIndex * commandInventoryWidth() // The memory offset from the beginning of the inventory where the command lies
            inventoryCommandId = word(commandInventorySlot1BaseAddr() + inventoryOffset) // The accessor containing the actual command ID
            
            array_push(commandChecks, once(inventoryCommandId == commandToCheckForDuplicate["id"]))
        }
        
        trigger = trigger || tally(2, commandChecks)
    }
    
    return trigger
}

function DeckLoadoutChanged()
{
    trigger = always_false()
    slotBaseAddrs = [ deck1Slot1BaseAddr(), deck2Slot1BaseAddr(), deck3Slot1BaseAddr() ]
    
    for deck in range(0, 2)
    {
        for i in range(0, maxNumberOfCommandSlots() - 1)
        {
            inventoryIndex = word(slotBaseAddrs[deck] + i * commandIndexWidth()) // 0xffff when no command is equipped
            trigger = trigger || Delta(inventoryIndex) != inventoryIndex
        }
    }
    
    return trigger
}

equippableBattleCommands = GetCommandsByProperties({ "equippableBattleCommand": True() })
achievement(title = "Rainbow Loom [m]", points = 10,
    description = "Complete \"Weaver Fever\" in the Mirage Arena without any duplicate commands equipped (Critical Mode, Level 8 or below, Deck 1 only).",
    trigger = never(HasDuplicateCommandInDeckOfSize(equippableBattleCommands, 1, 8))
        && never(DeckLoadoutChanged()) && CurrentDeckIs(1)
        && MirageArenaCheckpointReachedForCharacters(0x301, "MirageChamber", [ TerraArmored() ], 4) // todo: insert other characters
)

function CommandDeckSlotsFilledIsAtLeast(slotsFilled)
{
    trigger = always_false()
    slotBaseAddrs = [ deck1Slot1BaseAddr(), deck2Slot1BaseAddr(), deck3Slot1BaseAddr() ]
    
    for deck in range(0, 2)
    {
        slotsUsedInDeck = []
        for i in range(0, maxNumberOfCommandSlots() - 1)
        {
            inventoryIndex = word(slotBaseAddrs[deck] + i * commandIndexWidth()) // 0xffff when no command is equipped
            array_push(slotsUsedInDeck, once(inventoryIndex != 0xffff))
        }
        
        trigger = trigger || CurrentDeckIs(deck + 1) && tally(slotsFilled, slotsUsedInDeck)
    }
    
    return trigger
}

shotlocks = GetCommandsByProperties({ "supercategory": "Shotlock" })

// todo: rebalance, since Level 20 is probably too high
achievement(title = "Weapon Confiscation [m]", points = 5,
    description = "Complete \"Sinister Sentinel\" in the Mirage Arena with only three battle command slots filled and without using Shotlocks (Critical Mode, Level 20 or below).",
    trigger = never(JustUsedAnyGivenCommandInArena(shotlocks))
        && MirageArenaCheckpointReachedForCharacters(0x401, "MirageArena1", [ TerraArmored() ], 5) // todo: insert other characters
        && IsAtLeastOnDifficulty("Critical") && level() <= 20
        && never(CommandDeckSlotsFilledIsAtLeast(4))
)

function SurgeCallback(command)
{
    if (command["name"] == "Fire Surge" || command["name"] == "Thunder Surge" || command["name"] == "Barrier Surge")
    {
        return True()
    }
    else
    {
        return False()
    }
}

surgeBattleCommands = GetCommandsByCallback(SurgeCallback)
achievement(title = "Minor Duplication [m]", points = 5,
    description = "Complete \"Dead Ringer\" in the Mirage Arena using only two kinds of non-Surge battle commands (Critical Mode, Level 20 or below).",
    trigger = MirageArenaCheckpointReachedForCharacters(0x501, "MirageDeck", [ TerraArmored() ], 5) // todo: insert other characters
        && IsAtLeastOnDifficulty("Critical") && level() <= 20
        && never(UsedAnyUniqueCommandsGivenNumberOfTimesInArena(battleCommands, 3))
        && never(JustUsedAnyGivenCommandInArena(surgeBattleCommands))
)

function GetAbilityByAddress(addr)
{
    return {
        "numberEquipped": (bit0(addr) + bit1(addr) * 2 + bit2(addr) * 4)
    }
}

function NumberOfStatAbilitiesEquipped(max)
{
    statAbilityAddrs = [
        0x1f2ac64, // HP Boost
        0x1f2ac6c, // Fire Boost
        0x1f2ac70, // Blizzard Boost
        0x1f2ac74, // Thunder Boost
        0x1f2ac78, // Cure Boost
        0x1f2ac7c, // Item Boost
        0x1f2ac80, // Attack Haste
        0x1f2ac84, // Magic Haste
        0x1f2ac88, // Combo F Boost
        0x1f2ac8c, // Finish Boost
        0x1f2ac98, // Fire Screen
        0x1f2ac9c, // Blizzard Screen
        0x1f2aca0, // Thunder Screen
        0x1f2aca4, // Dark Screen
        0x1f2aca8, // Reload Boost
        0x1f2acac // Defender
    ]
    
    return NumberOfGivenAbilitiesEquippedByAddrGreaterThanOrEqualTo(statAbilityAddrs, max)
}

function NumberOfBeneficialSupportAbilitiesEquippedGreaterThanOrEqualTo(max)
{
    supportAbilityAddrs = [
        //0x1f2ac68, // Zero EXP
        0x1f2ac90, // Combo Plus
        0x1f2ac94, // Air Combo Plus
        0x1f2acb0, // EXP Chance
        0x1f2acb4, // EXP Walker
        0x1f2acb8, // Damage Syphon
        0x1f2acbc, // Second Chance
        0x1f2acc0, // Once More
        0x1f2acc4, // Scan
        0x1f2acc8, // Leaf Bracer
    ]
    
    return NumberOfGivenAbilitiesEquippedByAddrGreaterThanOrEqualTo(supportAbilityAddrs, max)
}

function NumberOfGivenAbilitiesEquippedByAddrGreaterThanOrEqualTo(addrs, max)
{
    ret = []
    for addr in addrs
    {
        ability = GetAbilityByAddress(addr)
        array_push(ret, once(ability["numberEquipped"] > 0))
    }
    
    return tally(max, ret)
}

achievement(title = "Combined Boon [m]", points = 10,
    description = "Complete \"Combined Threat\" in the Mirage Arena with only two beneficial Stat and Support Abilities each turned on (Critical Mode, Level 20 or below).",
    trigger = MirageArenaCheckpointReachedForCharacters(0x601, "MirageExterior", [ TerraArmored() ], 6) // todo: insert other characters
        && IsAtLeastOnDifficulty("Critical") && level() <= 20
        && never(NumberOfStatAbilitiesEquipped(3))
        && never(NumberOfBeneficialSupportAbilitiesEquippedGreaterThanOrEqualTo(3))
)

function MultiSlotCommandCallback(command)
{
    if (command["slots"] > 1)
    {
        return True()
    }
    else
    {
        return False()
    }
}

battleCommandsThatUseMoreThanOneSlot = GetCommandsByCallback(MultiSlotCommandCallback)
achievement(title = "Healthcare Budgeting [m]", points = 10,
    description = "Complete \"Risky Riches\" in the Mirage Arena using only commands that take up a single slot and without taking damage more than three times (Critical Mode, Level 20 or below).",
    trigger = MirageArenaCheckpointReachedForCharacters(0x201, "MirageSkull", [ TerraArmored() ], 3) // todo: insert other characters
        && IsAtLeastOnDifficulty("Critical") && level() <= 20
        && never(repeated(4, TookDamageInTheMirageArena()))
        && never(JustUsedAnyGivenCommandInArena(battleCommandsThatUseMoreThanOneSlot))
)

achievement(title = "Escalation of Force [m]", points = 10,
    description = "Complete \"Harsh Punishment\" in the Mirage Arena with only five battle command slots filled (Critical Mode, Level 20 or below).",
    trigger = MirageArenaCheckpointReachedForCharacters(0x801, "MirageArena1", [ TerraArmored() ], 6) // todo: insert other characters
        && IsAtLeastOnDifficulty("Critical") && level() <= 20
        && never(CommandDeckSlotsFilledIsAtLeast(6))
)

function MonstroMirageArenaCheckpointReachedForCharacters()
{    
    return CheckpointPassedForCharacters(MirageArenaCheckpointPassedCallback(0xc01, "MirageMonstro"), [ TerraArmored() ], False()) // todo: insert other characters
        && never(!WasInLocation("MirageMonstro") && IsInLocation("MirageHub"))
        && mirageArenaCurrentRound() < 7
        && trigger_when(MonstroDefeatTriggered())
}

function MonstroDefeatTriggered() => IsInBattle() && bit3(battleFlagsAddr()) == 1 && arenaHp() > 0 && characterArenaPointer() != 0
achievement(title = "The Madness of Man [m]", points = 25,
    description = "Complete \"The Monster of the Sea\" in the Mirage Arena in six rounds or less (Critical Mode, Level 20 or below).",
    trigger = MonstroMirageArenaCheckpointReachedForCharacters() // todo: insert other characters
        && IsAtLeastOnDifficulty("Critical")
        && level() <= 20
)

// Kingdom Hearts Birth by Sleep
// #ID = 3556

// todo: There is an issue with the save protection that could cause pauselocks to not reset when loading different save files from a game over screen.
//       Fixing this will likely require an address that actually tells us what episode is currently being played instead of knowing what character is currently under the player's control.
//       This will, then, have to wait until after achievements for each episode are completed.

// todo: put level restrictions in the checkpoint instead of putting them in a never()

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
function GenerateCheevoFromBits(name, description, points, addresses, onlyAvailableWhen = always_true(), id = 0, badge = "00000", threshold = 0)
{
    bitcounts = GenerateBitcountFromCountableObjects(GetCountableAccessorArrayFromAddressBits(addresses))
    
    if (threshold <= 0)
    {
        threshold = length(addresses)
    }

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

function saveLoadMenuPointer() => dword(0xb5c188)
function SaveOrLoadMenuIsActive() => saveLoadMenuPointer() != 0

// There are some (unknown) instances where saveState() will equal 0x0401
function IsAlwaysInGame() => never(IsInLocation("Title")) && never(SaveOrLoadMenuIsActive()) && never(currentCharacter() != Delta(currentCharacter()))

function IsInGame() => !IsInLocation("Title") && !SaveOrLoadMenuIsActive()

function GameJustLoaded() => SaveOrLoadMenuIsActive() && saveState() != 0xff01

function WasValueSet(mem, oldValue, newValue)
{
    return once(IsValueJustSet(mem, oldValue, newValue))
}

function ValueJustIncreased(mem)
{
    return Delta(mem) < mem
}

function ValueJustDecreased(mem)
{
    return Delta(mem) > mem
}

function ValueJustIncreasedInGame(mem)
{
    return IsAlwaysInGame() && ValueJustIncreased(mem)
}

function ValueJustDecreasedInGame(mem)
{
    return IsAlwaysInGame() && ValueJustDecreased(mem)
}

function IsValueJustSetGreaterThanOrEqualToValue(mem, value)
{
    return Delta(mem) < value && mem >= value
}

function IsValueJustSetLessThanOrEqualToValue(mem, value, min = 0)
{
    return Delta(mem) != mem && mem <= value && (Delta(mem) == min || Delta(mem) > value)
}

function IsValueJustSetGreaterThanOrEqualToValueInGame(mem, value)
{
    return IsValueJustSetGreaterThanOrEqualToValue(mem, value) && IsAlwaysInGame()
}

function IsValueJustSetLessThanOrEqualToValueInGame(mem, value)
{
    return IsValueJustSetLessThanOrEqualToValue(mem, value) && IsAlwaysInGame()
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
65535: { "worldId": 255, "name": "Title", "display": "On the title screen…", "areaId": 255, "hideWorld": 1, },257: { "worldId": 1, "name": "DepartureForecourtDay", "display": "Forecourt", "areaId": 1, "hideWorld": 0, },258: { "worldId": 1, "name": "DepartureGreatHall", "display": "Great Hall", "areaId": 2, "hideWorld": 0, },259: { "worldId": 1, "name": "VentusRoomDay", "display": "Ventus’s Room", "areaId": 3, "hideWorld": 0, },260: { "worldId": 1, "name": "VentusRoomNight", "display": "Ventus’s Room", "areaId": 4, "hideWorld": 0, },261: { "worldId": 1, "name": "DepartureMountainPath", "display": "Mountain Path", "areaId": 5, "hideWorld": 0, },262: { "worldId": 1, "name": "DepartureSummitNight", "display": "Summit", "areaId": 6, "hideWorld": 0, },263: { "worldId": 1, "name": "DepartureForecourtNight", "display": "Forecourt", "areaId": 7, "hideWorld": 0, },264: { "worldId": 1, "name": "DepartureForecourtRuins", "display": "Forecourt", "areaId": 8, "hideWorld": 0, },265: { "worldId": 1, "name": "DepartureGreatHallRuins", "display": "Great Hall", "areaId": 9, "hideWorld": 0, },266: { "worldId": 1, "name": "DepartureSummitRuins", "display": "Summit", "areaId": 10, "hideWorld": 0, },267: { "worldId": 1, "name": "ChamberOfWaking", "display": "Chamber of Waking", "areaId": 11, "hideWorld": 0, },268: { "worldId": 1, "name": "CastleOblivion", "display": "Castle Oblivion", "areaId": 12, "hideWorld": 0, },269: { "worldId": 1, "name": "CharacterSelect", "display": "Selecting a character…", "areaId": 13, "hideWorld": 1, },270: { "worldId": 1, "name": "DepartureForecourtRuins2", "display": "Forecourt", "areaId": 14, "hideWorld": 0, },271: { "worldId": 1, "name": "DepartureMountainPathRuins", "display": "Mountain Path", "areaId": 15, "hideWorld": 0, },272: { "worldId": 1, "name": "DepartureSummitRuins2", "display": "Summit", "areaId": 16, "hideWorld": 0, },513: { "worldId": 2, "name": "DwarfMineEntrance", "display": "Mine Entrance", "areaId": 1, "hideWorld": 0, },514: { "worldId": 2, "name": "DwarfMine", "display": "The Mine", "areaId": 2, "hideWorld": 0, },515: { "worldId": 2, "name": "DwarfVault", "display": "Vault", "areaId": 3, "hideWorld": 0, },516: { "worldId": 2, "name": "DwarfMirrorChamber", "display": "Magic Mirror Chamber", "areaId": 4, "hideWorld": 0, },517: { "worldId": 2, "name": "DwarfWaterway", "display": "Underground Waterway", "areaId": 5, "hideWorld": 0, },518: { "worldId": 2, "name": "DwarfCourtyard", "display": "Courtyard", "areaId": 6, "hideWorld": 0, },519: { "worldId": 2, "name": "DwarfGlade", "display": "Flower Glade", "areaId": 7, "hideWorld": 0, },520: { "worldId": 2, "name": "DwarfWoods", "display": "Deep Woods", "areaId": 8, "hideWorld": 0, },521: { "worldId": 2, "name": "DwarfMirror", "display": "Inside the Magic Mirror", "areaId": 9, "hideWorld": 0, },522: { "worldId": 2, "name": "DwarfClearing", "display": "Cottage Clearing", "areaId": 10, "hideWorld": 0, },523: { "worldId": 2, "name": "DwarfCottage", "display": "The Cottage", "areaId": 11, "hideWorld": 0, },524: { "worldId": 2, "name": "DwarfMountainTrail", "display": "Mountain Trail", "areaId": 12, "hideWorld": 0, },769: { "worldId": 3, "name": "CastleRoom", "display": "Cinderella’s Room", "areaId": 1, "hideWorld": 0, },770: { "worldId": 3, "name": "CastleMousehole", "display": "Mousehole", "areaId": 2, "hideWorld": 0, },771: { "worldId": 3, "name": "CastleWardrobe", "display": "Wardrobe Room", "areaId": 3, "hideWorld": 0, },772: { "worldId": 3, "name": "CastleEntrance", "display": "Entrance", "areaId": 4, "hideWorld": 0, },773: { "worldId": 3, "name": "CastleChateau", "display": "The Chateau", "areaId": 5, "hideWorld": 0, },774: { "worldId": 3, "name": "CastleForest", "display": "Forest", "areaId": 6, "hideWorld": 0, },775: { "worldId": 3, "name": "CastleCourtyard", "display": "Palace Courtyard", "areaId": 7, "hideWorld": 0, },776: { "worldId": 3, "name": "CastleCorridor", "display": "Corridor", "areaId": 8, "hideWorld": 0, },777: { "worldId": 3, "name": "CastleBallroom", "display": "Ballroom", "areaId": 9, "hideWorld": 0, },778: { "worldId": 3, "name": "CastleFoyer", "display": "Foyer", "areaId": 10, "hideWorld": 0, },779: { "worldId": 3, "name": "CastlePassage", "display": "Passage", "areaId": 11, "hideWorld": 0, },780: { "worldId": 3, "name": "CastleAntechamber", "display": "Antechamber", "areaId": 12, "hideWorld": 0, },781: { "worldId": 3, "name": "CastleWardrobe2", "display": "Wardrobe Room", "areaId": 13, "hideWorld": 0, },782: { "worldId": 3, "name": "CastleMousehole2", "display": "Mousehole", "areaId": 14, "hideWorld": 0, },783: { "worldId": 3, "name": "CastleWardrobe3", "display": "Wardrobe Room", "areaId": 15, "hideWorld": 0, },1025: { "worldId": 4, "name": "EnchantedDungeonCell", "display": "Dungeon Cell", "areaId": 1, "hideWorld": 0, },1026: { "worldId": 4, "name": "EnchantedGates", "display": "Gates", "areaId": 2, "hideWorld": 0, },1027: { "worldId": 4, "name": "EnchantedThrone", "display": "Maleficent’s Throne", "areaId": 3, "hideWorld": 0, },1028: { "worldId": 4, "name": "EnchantedDungeon", "display": "Dungeon", "areaId": 4, "hideWorld": 0, },1029: { "worldId": 4, "name": "EnchantedHall1", "display": "Hall", "areaId": 5, "hideWorld": 0, },1030: { "worldId": 4, "name": "EnchantedMountain", "display": "Forbidden Mountain", "areaId": 6, "hideWorld": 0, },1031: { "worldId": 4, "name": "EnchantedWaterside", "display": "Waterside", "areaId": 7, "hideWorld": 0, },1032: { "worldId": 4, "name": "EnchantedClearing", "display": "Forest Clearing", "areaId": 8, "hideWorld": 0, },1033: { "worldId": 4, "name": "EnchantedBridge", "display": "Bridge", "areaId": 9, "hideWorld": 0, },1034: { "worldId": 4, "name": "EnchantedBridgeThorns", "display": "Bridge", "areaId": 10, "hideWorld": 0, },1035: { "worldId": 4, "name": "EnchantedAudience1", "display": "Audience Chamber", "areaId": 11, "hideWorld": 0, },1036: { "worldId": 4, "name": "EnchantedAudience2", "display": "Audience Chamber", "areaId": 12, "hideWorld": 0, },1037: { "worldId": 4, "name": "EnchantedReserved", "display": "Somewhere in the World…", "areaId": 13, "hideWorld": 1, },1038: { "worldId": 4, "name": "EnchantedHallway", "display": "Hallway", "areaId": 14, "hideWorld": 0, },1039: { "worldId": 4, "name": "EnchantedAurora", "display": "Aurora’s Chamber", "areaId": 15, "hideWorld": 0, },1040: { "worldId": 4, "name": "EnchantedTower", "display": "Tower Room", "areaId": 16, "hideWorld": 0, },1041: { "worldId": 4, "name": "EnchantedHall2", "display": "Hall", "areaId": 17, "hideWorld": 0, },1042: { "worldId": 4, "name": "EnchantedAurora2", "display": "Aurora’s Chamber", "areaId": 18, "hideWorld": 0, },1043: { "worldId": 4, "name": "EnchantedHall3", "display": "Hall", "areaId": 19, "hideWorld": 0, },1044: { "worldId": 4, "name": "EnchantedHall4", "display": "Hall", "areaId": 20, "hideWorld": 0, },1045: { "worldId": 4, "name": "EnchantedHall5", "display": "Hall", "areaId": 21, "hideWorld": 0, },1046: { "worldId": 4, "name": "EnchantedHall6", "display": "Hall", "areaId": 22, "hideWorld": 0, },1047: { "worldId": 4, "name": "EnchantedHall7", "display": "Hall", "areaId": 23, "hideWorld": 0, },1048: { "worldId": 4, "name": "EnchantedHall8", "display": "Hall", "areaId": 24, "hideWorld": 0, },1049: { "worldId": 4, "name": "EnchantedHall9", "display": "Hall", "areaId": 25, "hideWorld": 0, },1050: { "worldId": 4, "name": "EnchantedHall10", "display": "Hall", "areaId": 26, "hideWorld": 0, },1051: { "worldId": 4, "name": "EnchantedHall11", "display": "Hall", "areaId": 27, "hideWorld": 0, },1052: { "worldId": 4, "name": "EnchantedHall12", "display": "Hall", "areaId": 28, "hideWorld": 0, },1053: { "worldId": 4, "name": "EnchantedHall13", "display": "Hall", "areaId": 29, "hideWorld": 0, },1054: { "worldId": 4, "name": "EnchantedHall14", "display": "Hall", "areaId": 30, "hideWorld": 0, },1055: { "worldId": 4, "name": "EnchantedHall15", "display": "Hall", "areaId": 31, "hideWorld": 0, },1056: { "worldId": 4, "name": "EnchantedHall16", "display": "Hall", "areaId": 32, "hideWorld": 0, },1057: { "worldId": 4, "name": "EnchantedHall17", "display": "Hall", "areaId": 33, "hideWorld": 0, },1058: { "worldId": 4, "name": "EnchantedHall18", "display": "Hall", "areaId": 34, "hideWorld": 0, },1059: { "worldId": 4, "name": "EnchantedHall19", "display": "Hall", "areaId": 35, "hideWorld": 0, },1060: { "worldId": 4, "name": "EnchantedHall20", "display": "Hall", "areaId": 36, "hideWorld": 0, },1061: { "worldId": 4, "name": "EnchantedHall21", "display": "Hall", "areaId": 37, "hideWorld": 0, },1062: { "worldId": 4, "name": "EnchantedHall22", "display": "Hall", "areaId": 38, "hideWorld": 0, },1063: { "worldId": 4, "name": "EnchantedGates", "display": "Gates", "areaId": 39, "hideWorld": 0, },1281: { "worldId": 5, "name": "MysteriousChamber", "display": "Sorcerer’s Chamber", "areaId": 1, "hideWorld": 0, },1282: { "worldId": 5, "name": "MysteriousTower", "display": "Mysterious Tower", "areaId": 2, "hideWorld": 0, },1283: { "worldId": 5, "name": "MysteriousEntrance", "display": "Tower Entrance", "areaId": 3, "hideWorld": 0, },1284: { "worldId": 5, "name": "MysteriousChamber2", "display": "Sorcerer’s Chamber", "areaId": 4, "hideWorld": 0, },1537: { "worldId": 6, "name": "RadiantOuterGardens", "display": "Outer Gardens", "areaId": 1, "hideWorld": 0, },1538: { "worldId": 6, "name": "RadiantEntryway", "display": "Entryway", "areaId": 2, "hideWorld": 0, },1539: { "worldId": 6, "name": "RadiantCentral", "display": "Central Square", "areaId": 3, "hideWorld": 0, },1540: { "worldId": 6, "name": "RadiantAqueduct", "display": "Aqueduct", "areaId": 4, "hideWorld": 0, },1541: { "worldId": 6, "name": "RadiantTown", "display": "Castle Town", "areaId": 5, "hideWorld": 0, },1542: { "worldId": 6, "name": "RadiantReactor", "display": "Reactor", "areaId": 6, "hideWorld": 0, },1543: { "worldId": 6, "name": "RadiantFountain", "display": "Fountain Court", "areaId": 7, "hideWorld": 0, },1544: { "worldId": 6, "name": "RadiantMerlin", "display": "Merlin’s House", "areaId": 8, "hideWorld": 0, },1545: { "worldId": 6, "name": "RadiantGardens", "display": "Gardens", "areaId": 9, "hideWorld": 0, },1546: { "worldId": 6, "name": "RadiantDoors", "display": "Front Doors", "areaId": 10, "hideWorld": 0, },1547: { "worldId": 6, "name": "RadiantPurification", "display": "Purification Facility", "areaId": 11, "hideWorld": 0, },1548: { "worldId": 6, "name": "RadiantOuterGardens2", "display": "Outer Gardens", "areaId": 12, "hideWorld": 0, },1549: { "worldId": 6, "name": "RadiantCentralDark", "display": "Central Square", "areaId": 13, "hideWorld": 0, },1550: { "worldId": 6, "name": "RadiantCentralTerranort", "display": "Central Square", "areaId": 14, "hideWorld": 0, },1793: { "worldId": 7, "name": "LouieCourt", "display": "Louie’s Ruins (Court)", "areaId": 1, "hideWorld": 0, },1794: { "worldId": 7, "name": "LouiePath", "display": "Louie’s Ruins (Path)", "areaId": 2, "hideWorld": 0, },1795: { "worldId": 7, "name": "Crossroad", "display": "Crossroad", "areaId": 3, "hideWorld": 0, },1796: { "worldId": 7, "name": "UGRuinsEntrance", "display": "Underground Ruins (Entrance)", "areaId": 4, "hideWorld": 0, },1797: { "worldId": 7, "name": "UGRuinsPassage1", "display": "Underground Ruins (Passage)", "areaId": 5, "hideWorld": 0, },1798: { "worldId": 7, "name": "UGRuinsPassage2", "display": "Underground Ruins (Passage)", "areaId": 6, "hideWorld": 0, },1799: { "worldId": 7, "name": "UGCourtyard", "display": "Underground Courtyard", "areaId": 7, "hideWorld": 0, },1800: { "worldId": 7, "name": "JungleNearRuins", "display": "Jungle Near Ruins", "areaId": 8, "hideWorld": 0, },1801: { "worldId": 7, "name": "Eminence", "display": "Eminence", "areaId": 9, "hideWorld": 0, },1802: { "worldId": 7, "name": "Jungle", "display": "Jungle", "areaId": 10, "hideWorld": 0, },1803: { "worldId": 7, "name": "River", "display": "Man-Village River", "areaId": 11, "hideWorld": 0, },1804: { "worldId": 7, "name": "Bog", "display": "Bog", "areaId": 12, "hideWorld": 0, },1842: { "worldId": 7, "name": "LanesBetween", "display": "The Lanes Between", "areaId": 50, "hideWorld": 0, },1843: { "worldId": 7, "name": "Blank", "display": "Blank", "areaId": 51, "hideWorld": 0, },1844: { "worldId": 7, "name": "RealmOfDarkness", "display": "Realm of Darkness", "areaId": 52, "hideWorld": 1, },1812: { "worldId": 7, "name": "DarknessMiddleZone", "display": "Realm of Darkness: Middle Zone", "areaId": 20, "hideWorld": 1, },1813: { "worldId": 7, "name": "DarknessLowerZone", "display": "Realm of Darkness: Lower Zone", "areaId": 21, "hideWorld": 1, },1814: { "worldId": 7, "name": "DarknessUpperZone", "display": "Realm of Darkness: Upper Zone", "areaId": 22, "hideWorld": 1, },1815: { "worldId": 7, "name": "DarknessValley", "display": "Realm of Darkness: Valley of the Dark", "areaId": 23, "hideWorld": 1, },1816: { "worldId": 7, "name": "RealmOfDarkness2", "display": "Realm of Darkness", "areaId": 24, "hideWorld": 1, },2049: { "worldId": 8, "name": "OlympusGates", "display": "Coliseum Gates", "areaId": 1, "hideWorld": 0, },2050: { "worldId": 8, "name": "OlympusVestibule", "display": "Vestibule", "areaId": 2, "hideWorld": 0, },2051: { "worldId": 8, "name": "OlympusWest", "display": "West Bracket", "areaId": 3, "hideWorld": 0, },2052: { "worldId": 8, "name": "OlympusEast", "display": "East Bracket", "areaId": 4, "hideWorld": 0, },2053: { "worldId": 8, "name": "OlympusTown", "display": "Town Near Thebes", "areaId": 5, "hideWorld": 0, },2054: { "worldId": 8, "name": "OlympusEastNight", "display": "East Bracket", "areaId": 6, "hideWorld": 0, },2305: { "worldId": 9, "name": "SpaceTuroBlock", "display": "Turo Prison Block", "areaId": 1, "hideWorld": 0, },2306: { "worldId": 9, "name": "SpaceTuroTransporter", "display": "Turo Transporter", "areaId": 2, "hideWorld": 0, },2307: { "worldId": 9, "name": "SpaceDurgonTransporter", "display": "Durgon Transporter", "areaId": 3, "hideWorld": 0, },2308: { "worldId": 9, "name": "SpaceCorridor", "display": "Ship Corridor", "areaId": 4, "hideWorld": 0, },2309: { "worldId": 9, "name": "SpaceControl", "display": "Control Room", "areaId": 5, "hideWorld": 0, },2310: { "worldId": 9, "name": "SpacePod", "display": "Containment Pod", "areaId": 6, "hideWorld": 0, },2311: { "worldId": 9, "name": "SpaceHub", "display": "Ship Hub", "areaId": 7, "hideWorld": 0, },2312: { "worldId": 9, "name": "SpaceMachineryBay", "display": "Machinery Bay", "areaId": 8, "hideWorld": 0, },2313: { "worldId": 9, "name": "SpaceLaunch", "display": "Launch Deck", "areaId": 9, "hideWorld": 0, },2314: { "worldId": 9, "name": "SpaceExterior", "display": "Ship Exterior", "areaId": 10, "hideWorld": 0, },2315: { "worldId": 9, "name": "SpaceOuter", "display": "Outer Space", "areaId": 11, "hideWorld": 0, },2316: { "worldId": 9, "name": "SpaceCorridor2", "display": "Ship Corridor", "areaId": 12, "hideWorld": 0, },2317: { "worldId": 9, "name": "SpaceLanesBetween", "display": "The Lanes Between", "areaId": 13, "hideWorld": 0, },2318: { "worldId": 9, "name": "SpaceMachineryBayAccess", "display": "Machinery Bay Access", "areaId": 14, "hideWorld": 0, },2561: { "worldId": 10, "name": "DestinyBeachDay", "display": "Island Beach", "areaId": 1, "hideWorld": 0, },2562: { "worldId": 10, "name": "DestinyBeachSunset", "display": "Island Beach", "areaId": 2, "hideWorld": 0, },2563: { "worldId": 10, "name": "DestinyBeachNight", "display": "Island Beach", "areaId": 3, "hideWorld": 0, },2564: { "worldId": 10, "name": "DestinyMainIsland", "display": "Main Island Beach", "areaId": 4, "hideWorld": 0, },2817: { "worldId": 11, "name": "NeverlandCove", "display": "Cove", "areaId": 1, "hideWorld": 0, },2818: { "worldId": 11, "name": "NeverlandCliff", "display": "Cliff Path", "areaId": 2, "hideWorld": 0, },2819: { "worldId": 11, "name": "NeverlandLagoon", "display": "Mermaid Lagoon", "areaId": 3, "hideWorld": 0, },2820: { "worldId": 11, "name": "NeverlandSeacoast", "display": "Seacoast", "areaId": 4, "hideWorld": 0, },2821: { "worldId": 11, "name": "NeverlandClearing", "display": "Jungle Clearing", "areaId": 5, "hideWorld": 0, },2822: { "worldId": 11, "name": "NeverlandHideout", "display": "Peter’s Hideout", "areaId": 6, "hideWorld": 0, },2823: { "worldId": 11, "name": "NeverlandGully", "display": "Gully", "areaId": 7, "hideWorld": 0, },2824: { "worldId": 11, "name": "NeverlandCamp", "display": "Indian Camp", "areaId": 8, "hideWorld": 0, },2825: { "worldId": 11, "name": "NeverlandBase", "display": "Rainbow Falls: Base", "areaId": 9, "hideWorld": 0, },2826: { "worldId": 11, "name": "NeverlandAscent", "display": "Rainbow Falls: Ascent", "areaId": 10, "hideWorld": 0, },2827: { "worldId": 11, "name": "NeverlandCrest", "display": "Rainbow Falls: Crest", "areaId": 11, "hideWorld": 0, },2828: { "worldId": 11, "name": "NeverlandSkullEntrance", "display": "Skull Rock: Entrance", "areaId": 12, "hideWorld": 0, },2829: { "worldId": 11, "name": "NeverlandSkullCavern", "display": "Skull Rock: Cavern", "areaId": 13, "hideWorld": 0, },2830: { "worldId": 11, "name": "NeverlandSky", "display": "Night Sky", "areaId": 14, "hideWorld": 0, },3073: { "worldId": 12, "name": "DisneyLibrary", "display": "Library", "areaId": 1, "hideWorld": 0, },3074: { "worldId": 12, "name": "DisneyPlaza", "display": "Main Plaza", "areaId": 2, "hideWorld": 0, },3075: { "worldId": 12, "name": "DisneyFruitballCourt", "display": "Fruitball Course", "areaId": 3, "hideWorld": 0, },3076: { "worldId": 12, "name": "DisneyCountryChase", "display": "Country Chase", "areaId": 4, "hideWorld": 0, },3077: { "worldId": 12, "name": "DisneyRaceway", "display": "Raceway", "areaId": 5, "hideWorld": 0, },3078: { "worldId": 12, "name": "DisneyGizmo", "display": "Gizmo Gallery", "areaId": 6, "hideWorld": 0, },3079: { "worldId": 12, "name": "DisneyRecRoom", "display": "Pete’s Rec Room", "areaId": 7, "hideWorld": 0, },3080: { "worldId": 12, "name": "DisneyDrive", "display": "Disney Drive", "areaId": 8, "hideWorld": 0, },3081: { "worldId": 12, "name": "DisneySpree", "display": "Grand Spree", "areaId": 9, "hideWorld": 0, },3082: { "worldId": 12, "name": "DisneyCastle", "display": "Castle Circuit", "areaId": 10, "hideWorld": 0, },3083: { "worldId": 12, "name": "DisneyLanesBetween", "display": "The Lanes Between", "areaId": 11, "hideWorld": 0, },3084: { "worldId": 12, "name": "DisneyRegistration", "display": "Raceway Registration", "areaId": 12, "hideWorld": 0, },3085: { "worldId": 12, "name": "DisneyIceCream", "display": "Ice Cream", "areaId": 13, "hideWorld": 0, },3086: { "worldId": 12, "name": "DisneyFruitball", "display": "Fruitball", "areaId": 14, "hideWorld": 0, },3087: { "worldId": 12, "name": "DisneyCourseCastle", "display": "Race: Castle Course", "areaId": 15, "hideWorld": 0, },3329: { "worldId": 13, "name": "GraveyardBadlands", "display": "Badlands", "areaId": 1, "hideWorld": 0, },3330: { "worldId": 13, "name": "GraveyardWar", "display": "Seat of War", "areaId": 2, "hideWorld": 0, },3331: { "worldId": 13, "name": "GraveyardTwister", "display": "Twister Trench", "areaId": 3, "hideWorld": 0, },3332: { "worldId": 13, "name": "GraveyardEye1", "display": "Eye of the Storm", "areaId": 4, "hideWorld": 0, },3333: { "worldId": 13, "name": "GraveyardEye2", "display": "Eye of the Storm", "areaId": 5, "hideWorld": 0, },3334: { "worldId": 13, "name": "GraveyardEye3", "display": "Eye of the Storm", "areaId": 6, "hideWorld": 0, },3335: { "worldId": 13, "name": "GraveyardFissure", "display": "Fissure", "areaId": 7, "hideWorld": 0, },3336: { "worldId": 13, "name": "Graveyard1", "display": "Keyblade Graveyard", "areaId": 8, "hideWorld": 1, },3337: { "worldId": 13, "name": "Graveyard2", "display": "Keyblade Graveyard", "areaId": 9, "hideWorld": 1, },3338: { "worldId": 13, "name": "Graveyard3", "display": "Keyblade Graveyard", "areaId": 10, "hideWorld": 1, },3339: { "worldId": 13, "name": "GraveyardCage", "display": "Will’s Cage", "areaId": 11, "hideWorld": 0, },3340: { "worldId": 13, "name": "Graveyard4", "display": "Keyblade Graveyard", "areaId": 12, "hideWorld": 1, },3378: { "worldId": 13, "name": "VentusHeart1", "display": "Ventus’s Heart", "areaId": 50, "hideWorld": 0, },3379: { "worldId": 13, "name": "VentusHeart2", "display": "Ventus’s Heart", "areaId": 51, "hideWorld": 0, },3380: { "worldId": 13, "name": "VentusHeart3", "display": "Ventus’s Heart", "areaId": 52, "hideWorld": 0, },3381: { "worldId": 13, "name": "SoraHeart", "display": "Sora’s Heart", "areaId": 53, "hideWorld": 0, },3382: { "worldId": 13, "name": "TerraHeart", "display": "Terra’s Heart", "areaId": 54, "hideWorld": 0, },3383: { "worldId": 13, "name": "Graveyard5", "display": "Keyblade Graveyard", "areaId": 55, "hideWorld": 0, },3384: { "worldId": 13, "name": "GraveyardBadlands2", "display": "Badlands", "areaId": 56, "hideWorld": 0, },3841: { "worldId": 15, "name": "MirageHub", "display": "Hub", "areaId": 1, "hideWorld": 0, },3842: { "worldId": 15, "name": "MirageColiseum", "display": "Coliseum", "areaId": 2, "hideWorld": 0, },3843: { "worldId": 15, "name": "MirageArena1", "display": "Arena", "areaId": 3, "hideWorld": 0, },3844: { "worldId": 15, "name": "MirageBadlands", "display": "Badlands", "areaId": 4, "hideWorld": 0, },3845: { "worldId": 15, "name": "MiragePinball", "display": "Pinball", "areaId": 5, "hideWorld": 0, },3846: { "worldId": 15, "name": "MirageShipHub", "display": "Ship Hub", "areaId": 6, "hideWorld": 0, },3847: { "worldId": 15, "name": "MirageMousehole", "display": "Mousehole", "areaId": 7, "hideWorld": 0, },3848: { "worldId": 15, "name": "MirageForest", "display": "Forest", "areaId": 8, "hideWorld": 0, },3849: { "worldId": 15, "name": "MirageSkull", "display": "Skull Rock", "areaId": 9, "hideWorld": 0, },3850: { "worldId": 15, "name": "MirageChamber", "display": "Audience Chamber", "areaId": 10, "hideWorld": 0, },3851: { "worldId": 15, "name": "MirageForecourt", "display": "Forecourt", "areaId": 11, "hideWorld": 0, },3852: { "worldId": 15, "name": "MirageSummit", "display": "Summit", "areaId": 12, "hideWorld": 0, },3853: { "worldId": 15, "name": "MirageDeck", "display": "Launch Deck", "areaId": 13, "hideWorld": 0, },3854: { "worldId": 15, "name": "MirageExterior", "display": "Ship Exterior", "areaId": 14, "hideWorld": 0, },3855: { "worldId": 15, "name": "MirageArena2", "display": "Arena", "areaId": 15, "hideWorld": 0, },3856: { "worldId": 15, "name": "MirageGreatHall", "display": "Great Hall", "areaId": 16, "hideWorld": 0, },3860: { "worldId": 15, "name": "MirageSummit2", "display": "Summit", "areaId": 20, "hideWorld": 0, },4097: { "worldId": 16, "name": "CommandDeparture", "display": "The Land of Departure Command Board", "areaId": 1, "hideWorld": 1, },4099: { "worldId": 16, "name": "CommandCinderella", "display": "Cinderella Command Board", "areaId": 3, "hideWorld": 1, },4105: { "worldId": 16, "name": "CommandSitch", "display": "Lilo and Stitch Command Board", "areaId": 9, "hideWorld": 1, },4107: { "worldId": 16, "name": "CommandPan", "display": "Peter Pan Command Board", "areaId": 11, "hideWorld": 1, },4108: { "worldId": 16, "name": "CommandDisney", "display": "Disney Castle Command Board", "areaId": 12, "hideWorld": 1, },4114: { "worldId": 16, "name": "CommandPooh", "display": "Winnie the Pooh Command Board", "areaId": 18, "hideWorld": 1, },4115: { "worldId": 16, "name": "CommandPan2", "display": "Peter Pan Command Board", "areaId": 19, "hideWorld": 1, },4353: { "worldId": 17, "name": "WorldMap", "display": "World Map", "areaId": 1, "hideWorld": 1, },3857: { "worldId": 15, "name": "MirageMonstro", "display": "Prankster’s Paradise", "areaId": 17, "hideWorld": 0, },
}

commands = {
   0xFFFF: { "id": 0xFFFF, "name": "N/A", "category": "N/A", "slots": 0, "type": "N/A", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "N/A", "element": "N/A" },0x13: { "id": 0x13, "name": "Spellweaver", "category": "Finish", "slots": 0, "type": "Finish", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "Finish", "element": "Physical" },0x17: { "id": 0x17, "name": "Thunderbolt", "category": "Finish", "slots": 0, "type": "Finish", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "Finish", "element": "Thunder" },0x2f: { "id": 0x2f, "name": "Last Charge", "category": "Finish", "slots": 0, "type": "Finish", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "Finish", "element": "Null" },0x3d: { "id": 0x3d, "name": "Finish (Ventus)", "category": "Finish", "slots": 0, "type": "Finish", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "Finish", "element": "Physical" },0x3e: { "id": 0x3e, "name": "Finish (Aqua)", "category": "Finish", "slots": 0, "type": "Finish", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "Finish", "element": "Physical" },0x3f: { "id": 0x3f, "name": "Finish (Terra)", "category": "Finish", "slots": 0, "type": "Finish", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "Finish", "element": "Physical" },0x40: { "id": 0x40, "name": "Air Flair 1", "category": "Finish", "slots": 0, "type": "Finish", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "Finish", "element": "Null" },0x41: { "id": 0x41, "name": "Magic Pulse 1", "category": "Finish", "slots": 0, "type": "Finish", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "Finish", "element": "Null" },0x42: { "id": 0x42, "name": "Rising Rock 1", "category": "Finish", "slots": 0, "type": "Finish", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "Finish", "element": "Physical" },0x43: { "id": 0x43, "name": "Heat Slash 1", "category": "Finish", "slots": 0, "type": "Finish", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "Finish", "element": "Fire" },0x45: { "id": 0x45, "name": "Air Flair 2", "category": "Finish", "slots": 0, "type": "Finish", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "Finish", "element": "Null" },0x46: { "id": 0x46, "name": "Magic Pulse 2", "category": "Finish", "slots": 0, "type": "Finish", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "Finish", "element": "Null" },0x47: { "id": 0x47, "name": "Rising Rock 2", "category": "Finish", "slots": 0, "type": "Finish", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "Finish", "element": "Physical" },0x48: { "id": 0x48, "name": "Heat Slash 2", "category": "Finish", "slots": 0, "type": "Finish", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "Finish", "element": "Fire" },0x49: { "id": 0x49, "name": "Ramuh’s Judgment", "category": "Finish", "slots": 0, "type": "Finish", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "Finish", "element": "Thunder" },0x4a: { "id": 0x4a, "name": "Twisted Hours", "category": "Finish", "slots": 0, "type": "Finish", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "Finish", "element": "Physical" },0x4b: { "id": 0x4b, "name": "Surprise! 1", "category": "Finish", "slots": 0, "type": "Finish", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "Finish", "element": "Physical" },0x4c: { "id": 0x4c, "name": "Air Flair 3", "category": "Finish", "slots": 0, "type": "Finish", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "Finish", "element": "Null" },0x4d: { "id": 0x4d, "name": "Magic Pulse 3", "category": "Finish", "slots": 0, "type": "Finish", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "Finish", "element": "Null" },0x4e: { "id": 0x4e, "name": "Dark Star 1", "category": "Finish", "slots": 0, "type": "Finish", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "Finish", "element": "Physical" },0x4f: { "id": 0x4f, "name": "Heal Strike", "category": "Finish", "slots": 0, "type": "Finish", "tier": 0, "healsHp": 1, "equippableBattleCommand": 0, "supercategory": "Finish", "element": "Physical" },0x50: { "id": 0x50, "name": "Random End", "category": "Finish", "slots": 0, "type": "Finish", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "Finish", "element": "Physical" },0x51: { "id": 0x51, "name": "Surprise! 2", "category": "Finish", "slots": 0, "type": "Finish", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "Finish", "element": "Physical" },0x52: { "id": 0x52, "name": "Air Flair 4", "category": "Finish", "slots": 0, "type": "Finish", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "Finish", "element": "Physical" },0x53: { "id": 0x53, "name": "Magic Pulse 4", "category": "Finish", "slots": 0, "type": "Finish", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "Finish", "element": "Null" },0x54: { "id": 0x54, "name": "Dark Star 2", "category": "Finish", "slots": 0, "type": "Finish", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "Finish", "element": "Physical" },0x55: { "id": 0x55, "name": "Explosion", "category": "Finish", "slots": 0, "type": "Finish", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "Finish", "element": "Physical" },0x56: { "id": 0x56, "name": "Ice Burst", "category": "Finish", "slots": 0, "type": "Finish", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "Finish", "element": "Blizzard" },0x57: { "id": 0x57, "name": "Celebration", "category": "Finish", "slots": 0, "type": "Finish", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "Finish", "element": "Physical" },0x58: { "id": 0x58, "name": "Stratosphere", "category": "Finish", "slots": 0, "type": "Finish", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "Finish", "element": "Null" },0x59: { "id": 0x59, "name": "Teleport Spike", "category": "Finish", "slots": 0, "type": "Finish", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "Finish", "element": "Null" },0x5a: { "id": 0x5a, "name": "Demolition", "category": "Finish", "slots": 0, "type": "Finish", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "Finish", "element": "Physical" },0x5b: { "id": 0x5b, "name": "Quick Blitz", "category": "Attack", "slots": 1, "type": "Jump", "tier": 0, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Attack", "element": "Physical" },0x5c: { "id": 0x5c, "name": "Blitz", "category": "Melee", "slots": 1, "type": "Jump", "tier": 0, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Attack", "element": "Physical" },0x5d: { "id": 0x5d, "name": "Magic Hour", "category": "Ranged", "slots": 2, "type": "Jump", "tier": 0, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Attack", "element": "Physical" },0x5e: { "id": 0x5e, "name": "Meteor Crash", "category": "Ranged", "slots": 2, "type": "Jump", "tier": 0, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Attack", "element": "Physical" },0x5f: { "id": 0x5f, "name": "Sliding Dash", "category": "Melee", "slots": 1, "type": "Jump", "tier": 0, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Attack", "element": "Physical" },0x60: { "id": 0x60, "name": "Fire Dash", "category": "Melee", "slots": 1, "type": "Rush", "tier": 0, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Attack", "element": "Fire" },0x61: { "id": 0x61, "name": "Dark Haze", "category": "Melee", "slots": 1, "type": "Rush", "tier": 0, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Attack", "element": "Dark" },0x62: { "id": 0x62, "name": "Sonic Blade", "category": "Melee", "slots": 1, "type": "Rush", "tier": 0, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Attack", "element": "Physical" },0x63: { "id": 0x63, "name": "Chaos Blade", "category": "Melee", "slots": 2, "type": "Rush", "tier": 0, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Attack", "element": "Dark" },0x64: { "id": 0x64, "name": "Zantetsuken", "category": "Melee", "slots": 1, "type": "Rush", "tier": 0, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Attack", "element": "Physical" },0x65: { "id": 0x65, "name": "Strike Raid", "category": "Ranged", "slots": 1, "type": "Raid", "tier": 0, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Attack", "element": "Physical" },0x66: { "id": 0x66, "name": "Freeze Raid", "category": "Ranged", "slots": 1, "type": "Raid", "tier": 0, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Attack", "element": "Blizzard" },0x67: { "id": 0x67, "name": "Treasure Raid", "category": "Ranged", "slots": 1, "type": "Raid", "tier": 0, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Attack", "element": "Physical" },0x68: { "id": 0x68, "name": "Spark Raid", "category": "Ranged", "slots": 1, "type": "Raid", "tier": 0, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Attack", "element": "Physical" },0x69: { "id": 0x69, "name": "Wind Raid", "category": "Ranged", "slots": 1, "type": "Raid", "tier": 0, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Attack", "element": "Physical" },0x6a: { "id": 0x6a, "name": "Fire Surge", "category": "Melee", "slots": 1, "type": "Rush", "tier": 0, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Attack", "element": "Fire" },0x6b: { "id": 0x6b, "name": "Barrier Surge", "category": "Melee", "slots": 1, "type": "Rush", "tier": 0, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Attack", "element": "Physical" },0x6c: { "id": 0x6c, "name": "Thunder Surge", "category": "Melee", "slots": 1, "type": "Rush", "tier": 0, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Attack", "element": "Thunder" },0x6d: { "id": 0x6d, "name": "Aerial Slam", "category": "Melee", "slots": 1, "type": "Jump", "tier": 0, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Attack", "element": "Physical" },0x6e: { "id": 0x6e, "name": "Ars Solum", "category": "Melee", "slots": 2, "type": "Chain Hit", "tier": 0, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Attack", "element": "Physical" },0x6f: { "id": 0x6f, "name": "Ars Arcanum", "category": "Melee", "slots": 2, "type": "Chain Hit", "tier": 0, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Attack", "element": "Physical" },0x70: { "id": 0x70, "name": "Time Splicer", "category": "Melee", "slots": 2, "type": "Chain Hit", "tier": 0, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Attack", "element": "Physical" },0x71: { "id": 0x71, "name": "Poison Edge", "category": "Melee", "slots": 1, "type": "Blade", "tier": 0, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Attack", "element": "Physical" },0x72: { "id": 0x72, "name": "Wishing Edge", "category": "Melee", "slots": 1, "type": "Blade", "tier": 0, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Attack", "element": "Physical" },0x73: { "id": 0x73, "name": "Blizzard Edge", "category": "Melee", "slots": 1, "type": "Blade", "tier": 0, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Attack", "element": "Blizzard" },0x74: { "id": 0x74, "name": "Stun Edge", "category": "Melee", "slots": 1, "type": "Blade", "tier": 0, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Attack", "element": "Physical" },0x75: { "id": 0x75, "name": "Slot Edge", "category": "Melee", "slots": 1, "type": "Blade", "tier": 0, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Attack", "element": "Physical" },0x76: { "id": 0x76, "name": "Fire Strike", "category": "Melee", "slots": 1, "type": "Strike", "tier": 0, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Attack", "element": "Fire" },0x77: { "id": 0x77, "name": "Confuse Strike", "category": "Melee", "slots": 1, "type": "Strike", "tier": 0, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Attack", "element": "Physical" },0x78: { "id": 0x78, "name": "Binding Strike", "category": "Melee", "slots": 1, "type": "Strike", "tier": 0, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Attack", "element": "Physical" },0x79: { "id": 0x79, "name": "Tornado Strike", "category": "Melee", "slots": 2, "type": "Strike", "tier": 0, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Attack", "element": "Physical" },0x7a: { "id": 0x7a, "name": "Brutal Blast", "category": "Melee", "slots": 1, "type": "Strike", "tier": 0, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Attack", "element": "Physical" },0x7b: { "id": 0x7b, "name": "Magnet Spiral", "category": "Melee", "slots": 1, "type": "Strike", "tier": 0, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Attack", "element": "Physical" },0x7c: { "id": 0x7c, "name": "Salvation", "category": "Ranged", "slots": 2, "type": "Strike", "tier": 0, "healsHp": 1, "equippableBattleCommand": 1, "supercategory": "Attack", "element": "Physical" },0x7d: { "id": 0x7d, "name": "Wind Cutter", "category": "Melee", "slots": 1, "type": "Strike", "tier": 0, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Attack", "element": "Physical" },0x7e: { "id": 0x7e, "name": "Limit Storm", "category": "Melee", "slots": 1, "type": "Strike", "tier": 0, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Attack", "element": "Physical" },0x7f: { "id": 0x7f, "name": "Collision Magnet", "category": "Hybrid", "slots": 1, "type": "Blade", "tier": 0, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Attack", "element": "Physical" },0x80: { "id": 0x80, "name": "Geo Impact", "category": "Melee", "slots": 2, "type": "Blade", "tier": 0, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Attack", "element": "Physical" },0x81: { "id": 0x81, "name": "Sacrifice", "category": "Melee", "slots": 1, "type": "Blade", "tier": 0, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Attack", "element": "Physical" },0x82: { "id": 0x82, "name": "Break Time", "category": "Support", "slots": 1, "type": "N/A", "tier": 0, "healsHp": 1, "equippableBattleCommand": 1, "supercategory": "Attack", "element": "N/A" },0x83: { "id": 0x83, "name": "Fire", "category": "Ranged", "slots": 1, "type": "N/A", "tier": 1, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Magic", "element": "Fire" },0x84: { "id": 0x84, "name": "Fira", "category": "Ranged", "slots": 1, "type": "N/A", "tier": 2, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Magic", "element": "Fire" },0x85: { "id": 0x85, "name": "Firaga", "category": "Ranged", "slots": 1, "type": "N/A", "tier": 3, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Magic", "element": "Fire" },0x86: { "id": 0x86, "name": "Dark Firaga", "category": "Ranged", "slots": 1, "type": "N/A", "tier": 3, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Magic", "element": "Dark" },0x87: { "id": 0x87, "name": "Fission Firaga", "category": "Ranged", "slots": 1, "type": "N/A", "tier": 3, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Magic", "element": "Fire" },0x88: { "id": 0x88, "name": "Triple Firaga", "category": "Ranged", "slots": 1, "type": "N/A", "tier": 3, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Magic", "element": "Fire" },0x89: { "id": 0x89, "name": "Crawling Fire", "category": "Ranged", "slots": 1, "type": "N/A", "tier": 3, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Magic", "element": "Fire" },0x8a: { "id": 0x8a, "name": "Blizzard", "category": "Ranged", "slots": 1, "type": "N/A", "tier": 1, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Magic", "element": "Blizzard" },0x8b: { "id": 0x8b, "name": "Blizzara", "category": "Ranged", "slots": 1, "type": "N/A", "tier": 2, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Magic", "element": "Blizzard" },0x8c: { "id": 0x8c, "name": "Blizzaga", "category": "Ranged", "slots": 1, "type": "N/A", "tier": 3, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Magic", "element": "Blizzard" },0x8d: { "id": 0x8d, "name": "Triple Blizzaga", "category": "Ranged", "slots": 1, "type": "N/A", "tier": 3, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Magic", "element": "Blizzard" },0x8e: { "id": 0x8e, "name": "Thunder", "category": "Ranged", "slots": 1, "type": "N/A", "tier": 1, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Magic", "element": "Thunder" },0x8f: { "id": 0x8f, "name": "Thundara", "category": "Ranged", "slots": 1, "type": "N/A", "tier": 2, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Magic", "element": "Thunder" },0x90: { "id": 0x90, "name": "Thundaga", "category": "Ranged", "slots": 1, "type": "N/A", "tier": 3, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Magic", "element": "Thunder" },0x91: { "id": 0x91, "name": "Thundaga Shot", "category": "Ranged", "slots": 1, "type": "N/A", "tier": 3, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Magic", "element": "Thunder" },0x92: { "id": 0x92, "name": "Cure", "category": "Support", "slots": 1, "type": "Cure", "tier": 1, "healsHp": 1, "equippableBattleCommand": 1, "supercategory": "Magic", "element": "N/A" },0x93: { "id": 0x93, "name": "Cura", "category": "Support", "slots": 1, "type": "Cure", "tier": 2, "healsHp": 1, "equippableBattleCommand": 1, "supercategory": "Magic", "element": "N/A" },0x94: { "id": 0x94, "name": "Curaga", "category": "Support", "slots": 1, "type": "Cure", "tier": 3, "healsHp": 1, "equippableBattleCommand": 1, "supercategory": "Magic", "element": "N/A" },0x95: { "id": 0x95, "name": "Esuna", "category": "Support", "slots": 1, "type": "Cure", "tier": 1, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Magic", "element": "N/A" },0x96: { "id": 0x96, "name": "Mine Shield", "category": "Mine", "slots": 1, "type": "Detonate", "tier": 0, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Magic", "element": "Null" },0x97: { "id": 0x97, "name": "Mine Square", "category": "Mine", "slots": 1, "type": "Detonate", "tier": 0, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Magic", "element": "Null" },0x98: { "id": 0x98, "name": "Seeker Mine", "category": "Mine", "slots": 1, "type": "Detonate", "tier": 0, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Magic", "element": "Null" },0x99: { "id": 0x99, "name": "Zero Gravity", "category": "Ranged", "slots": 1, "type": "Zero Gravity", "tier": 1, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Magic", "element": "Null" },0x9a: { "id": 0x9a, "name": "Zero Gravira", "category": "Ranged", "slots": 1, "type": "Zero Gravity", "tier": 2, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Magic", "element": "Null" },0x9b: { "id": 0x9b, "name": "Zero Graviga", "category": "Ranged", "slots": 1, "type": "Zero Gravity", "tier": 3, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Magic", "element": "Null" },0x9c: { "id": 0x9c, "name": "Magnet", "category": "Ranged", "slots": 1, "type": "Magnet", "tier": 1, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Magic", "element": "Null" },0x9d: { "id": 0x9d, "name": "Magnera", "category": "Ranged", "slots": 1, "type": "Magnet", "tier": 2, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Magic", "element": "Null" },0x9e: { "id": 0x9e, "name": "Magnega", "category": "Ranged", "slots": 1, "type": "Magnet", "tier": 3, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Magic", "element": "Null" },0x9f: { "id": 0x9f, "name": "Munny Magnet", "category": "Support", "slots": 1, "type": "Magnet", "tier": 2, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Magic", "element": "Null" },0xa0: { "id": 0xa0, "name": "Energy Magnet", "category": "Support", "slots": 1, "type": "Magnet", "tier": 2, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Magic", "element": "Null" },0xa1: { "id": 0xa1, "name": "D-Link Magnet", "category": "Support", "slots": 1, "type": "Magnet", "tier": 2, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Magic", "element": "Null" },0xa2: { "id": 0xa2, "name": "Aero", "category": "Ranged", "slots": 1, "type": "Aero", "tier": 1, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Magic", "element": "Null" },0xa3: { "id": 0xa3, "name": "Aerora", "category": "Ranged", "slots": 1, "type": "Aero", "tier": 2, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Magic", "element": "Null" },0xa4: { "id": 0xa4, "name": "Aeroga", "category": "Ranged", "slots": 1, "type": "Aero", "tier": 3, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Magic", "element": "Null" },0xa5: { "id": 0xa5, "name": "Warp", "category": "Ranged", "slots": 1, "type": "N/A", "tier": 0, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Magic", "element": "Null" },0xa6: { "id": 0xa6, "name": "Faith", "category": "Ranged", "slots": 2, "type": "N/A", "tier": 0, "healsHp": 1, "equippableBattleCommand": 1, "supercategory": "Magic", "element": "Null" },0xa7: { "id": 0xa7, "name": "Deep Freeze", "category": "Ranged", "slots": 2, "type": "N/A", "tier": 0, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Magic", "element": "Blizzard" },0xa8: { "id": 0xa8, "name": "Glacier", "category": "Ranged", "slots": 2, "type": "N/A", "tier": 0, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Magic", "element": "Blizzard" },0xa9: { "id": 0xa9, "name": "Ice Barrage", "category": "Ranged", "slots": 2, "type": "N/A", "tier": 0, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Magic", "element": "Blizzard" },0xaa: { "id": 0xaa, "name": "Firaga Burst", "category": "Ranged", "slots": 2, "type": "N/A", "tier": 3, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Magic", "element": "Fire" },0xab: { "id": 0xab, "name": "Raging Storm", "category": "Ranged", "slots": 2, "type": "N/A", "tier": 0, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Magic", "element": "Fire" },0xac: { "id": 0xac, "name": "Mega Flare", "category": "Ranged", "slots": 2, "type": "N/A", "tier": 0, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Magic", "element": "Fire" },0xad: { "id": 0xad, "name": "Quake", "category": "Ranged", "slots": 2, "type": "N/A", "tier": 0, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Magic", "element": "Null" },0xae: { "id": 0xae, "name": "Tornado", "category": "Ranged", "slots": 2, "type": "Aero", "tier": 0, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Magic", "element": "Null" },0xaf: { "id": 0xaf, "name": "Meteor", "category": "Ranged", "slots": 2, "type": "N/A", "tier": 0, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Magic", "element": "Null" },0xb0: { "id": 0xb0, "name": "Transcendence", "category": "Ranged", "slots": 2, "type": "Zero Gravity", "tier": 0, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Magic", "element": "Null" },0xb1: { "id": 0xb1, "name": "Mini", "category": "Status", "slots": 1, "type": "Status Effect", "tier": 1, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Magic", "element": "Null" },0xb2: { "id": 0xb2, "name": "Blackout", "category": "Status", "slots": 1, "type": "Status Effect", "tier": 1, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Magic", "element": "Null" },0xb3: { "id": 0xb3, "name": "Ignite", "category": "Status", "slots": 1, "type": "Status Effect", "tier": 1, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Magic", "element": "Fire" },0xb4: { "id": 0xb4, "name": "Confuse", "category": "Status", "slots": 1, "type": "Status Effect", "tier": 1, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Magic", "element": "Null" },0xb5: { "id": 0xb5, "name": "Bind", "category": "Status", "slots": 1, "type": "Status Effect", "tier": 1, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Magic", "element": "Null" },0xb6: { "id": 0xb6, "name": "Poison", "category": "Status", "slots": 1, "type": "Status Effect", "tier": 1, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Magic", "element": "Null" },0xb7: { "id": 0xb7, "name": "Slow", "category": "Status", "slots": 1, "type": "Status Effect", "tier": 1, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Magic", "element": "Null" },0xb8: { "id": 0xb8, "name": "Stop", "category": "Status", "slots": 1, "type": "Status Effect", "tier": 1, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Magic", "element": "Null" },0xb9: { "id": 0xb9, "name": "Stopra", "category": "Status", "slots": 1, "type": "Status Effect", "tier": 2, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Magic", "element": "Null" },0xba: { "id": 0xba, "name": "Stopga", "category": "Status", "slots": 1, "type": "Status Effect", "tier": 3, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Magic", "element": "Null" },0xbb: { "id": 0xbb, "name": "Sleep", "category": "Status", "slots": 1, "type": "Status Effect", "tier": 1, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Magic", "element": "Null" },0xbc: { "id": 0xbc, "name": "Potion", "category": "Item", "slots": 1, "type": "Item", "tier": 0, "healsHp": 1, "equippableBattleCommand": 1, "supercategory": "Item", "element": "N/A" },0xbd: { "id": 0xbd, "name": "Hi-Potion", "category": "Item", "slots": 1, "type": "Item", "tier": 0, "healsHp": 1, "equippableBattleCommand": 1, "supercategory": "Item", "element": "N/A" },0xbe: { "id": 0xbe, "name": "Mega-Potion", "category": "Item", "slots": 1, "type": "Item", "tier": 0, "healsHp": 1, "equippableBattleCommand": 1, "supercategory": "Item", "element": "N/A" },0xbf: { "id": 0xbf, "name": "Ether", "category": "Item", "slots": 1, "type": "Item", "tier": 0, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Item", "element": "N/A" },0xc0: { "id": 0xc0, "name": "Mega-Ether", "category": "Item", "slots": 1, "type": "Item", "tier": 0, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Item", "element": "N/A" },0xc1: { "id": 0xc1, "name": "Panacea", "category": "Item", "slots": 1, "type": "Item", "tier": 0, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Item", "element": "N/A" },0xc2: { "id": 0xc2, "name": "Elixir", "category": "Item", "slots": 1, "type": "Item", "tier": 0, "healsHp": 1, "equippableBattleCommand": 1, "supercategory": "Item", "element": "N/A" },0xc3: { "id": 0xc3, "name": "Megalixir", "category": "Item", "slots": 1, "type": "Item", "tier": 0, "healsHp": 1, "equippableBattleCommand": 1, "supercategory": "Item", "element": "N/A" },0xc4: { "id": 0xc4, "name": "Balloon Letter", "category": "Item", "slots": 1, "type": "Item", "tier": 0, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Item", "element": "N/A" },0xc5: { "id": 0xc5, "name": "Vanilla Glitz", "category": "Item", "slots": 1, "type": "Item", "tier": 0, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Item", "element": "N/A" },0xc6: { "id": 0xc6, "name": "Fabracadabra", "category": "Item", "slots": 1, "type": "Item", "tier": 0, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Item", "element": "N/A" },0xc7: { "id": 0xc7, "name": "Honeybunny", "category": "Item", "slots": 1, "type": "Item", "tier": 0, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Item", "element": "N/A" },0xc8: { "id": 0xc8, "name": "Bueno Volcano", "category": "Item", "slots": 1, "type": "Item", "tier": 0, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Item", "element": "N/A" },0xc9: { "id": 0xc9, "name": "Snow Bear", "category": "Item", "slots": 1, "type": "Item", "tier": 0, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Item", "element": "N/A" },0xca: { "id": 0xca, "name": "Spark Lemon", "category": "Item", "slots": 1, "type": "Item", "tier": 0, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Item", "element": "N/A" },0xcb: { "id": 0xcb, "name": "Goofy Parfait", "category": "Item", "slots": 1, "type": "Item", "tier": 0, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Item", "element": "N/A" },0xcc: { "id": 0xcc, "name": "Royalberry", "category": "Item", "slots": 1, "type": "Item", "tier": 0, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Item", "element": "N/A" },0xcd: { "id": 0xcd, "name": "Milky Way", "category": "Item", "slots": 1, "type": "Item", "tier": 0, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Item", "element": "N/A" },0xce: { "id": 0xce, "name": "Rockin’ Crunch", "category": "Item", "slots": 1, "type": "Item", "tier": 0, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Item", "element": "N/A" },0xcf: { "id": 0xcf, "name": "Donald Fizz", "category": "Item", "slots": 1, "type": "Item", "tier": 0, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Item", "element": "N/A" },0xd0: { "id": 0xd0, "name": "Space Mint", "category": "Item", "slots": 1, "type": "Item", "tier": 0, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Item", "element": "N/A" },0xd1: { "id": 0xd1, "name": "Big Bad Pete", "category": "Item", "slots": 1, "type": "Item", "tier": 0, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Item", "element": "N/A" },0xd2: { "id": 0xd2, "name": "Double Crunch", "category": "Item", "slots": 1, "type": "Item", "tier": 0, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Item", "element": "N/A" },0xd3: { "id": 0xd3, "name": "Group Cure", "category": "Support", "slots": 1, "type": "Cure", "tier": 1, "healsHp": 1, "equippableBattleCommand": 1, "supercategory": "Friendship", "element": "N/A" },0xd4: { "id": 0xd4, "name": "Group Cura", "category": "Support", "slots": 1, "type": "Cure", "tier": 2, "healsHp": 1, "equippableBattleCommand": 1, "supercategory": "Friendship", "element": "N/A" },0xd5: { "id": 0xd5, "name": "Group Curaga", "category": "Support", "slots": 1, "type": "Cure", "tier": 3, "healsHp": 1, "equippableBattleCommand": 1, "supercategory": "Friendship", "element": "N/A" },0xd6: { "id": 0xd6, "name": "Group Esuna", "category": "Support", "slots": 1, "type": "Cure", "tier": 1, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Friendship", "element": "N/A" },0xd7: { "id": 0xd7, "name": "Confetti", "category": "Friendship", "slots": 1, "type": "N/A", "tier": 0, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Friendship", "element": "N/A" },0xd8: { "id": 0xd8, "name": "Fireworks", "category": "Friendship", "slots": 1, "type": "N/A", "tier": 0, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Friendship", "element": "N/A" },0xd9: { "id": 0xd9, "name": "Taunt", "category": "Support", "slots": 1, "type": "N/A", "tier": 0, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Friendship", "element": "N/A" },0xda: { "id": 0xda, "name": "Victory Pose", "category": "Friendship", "slots": 1, "type": "N/A", "tier": 0, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Friendship", "element": "N/A" },0xdb: { "id": 0xdb, "name": "Deck Scramble", "category": "Melee", "slots": 1, "type": "N/A", "tier": 0, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Friendship", "element": "N/A" },0xdc: { "id": 0xdc, "name": "Vanish", "category": "Support", "slots": 1, "type": "N/A", "tier": 0, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Friendship", "element": "N/A" },0xdd: { "id": 0xdd, "name": "Unison Rush", "category": "Melee", "slots": 3, "type": "N/A", "tier": 0, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Friendship", "element": "N/A" },0xde: { "id": 0xde, "name": "Voltage Stack", "category": "Ranged", "slots": 3, "type": "N/A", "tier": 0, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Friendship", "element": "N/A" },0xdf: { "id": 0xdf, "name": "Trinity Limit", "category": "Ranged", "slots": 3, "type": "N/A", "tier": 0, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Friendship", "element": "N/A" },0xe0: { "id": 0xe0, "name": "Gold", "category": "Dummy", "slots": 1, "type": "N/A", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "Dummy", "element": "N/A" },0xe1: { "id": 0xe1, "name": "Black", "category": "Dummy", "slots": 1, "type": "N/A", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "Dummy", "element": "N/A" },0xe2: { "id": 0xe2, "name": "Finish (Dummy)", "category": "Dummy", "slots": 1, "type": "N/A", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "Dummy", "element": "N/A" },0xe3: { "id": 0xe3, "name": "Wrath of Darkness", "category": "Dummy", "slots": 1, "type": "N/A", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "Dummy", "element": "N/A" },0xe4: { "id": 0xe4, "name": "Sign of Faith", "category": "Dummy", "slots": 1, "type": "N/A", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "Dummy", "element": "N/A" },0xe5: { "id": 0xe5, "name": "Wish Circle", "category": "D-Link", "slots": 1, "type": "N/A", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "D-Link", "element": "N/A" },0xe6: { "id": 0xe6, "name": "Enchanted Step", "category": "D-Link", "slots": 1, "type": "N/A", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "D-Link", "element": "N/A" },0xe7: { "id": 0xe7, "name": "Wish Shot", "category": "D-Link", "slots": 1, "type": "N/A", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "D-Link", "element": "N/A" },0xe8: { "id": 0xe8, "name": "Magic Mending", "category": "D-Link", "slots": 1, "type": "N/A", "tier": 0, "healsHp": 1, "equippableBattleCommand": 0, "supercategory": "D-Link", "element": "N/A" },0xe9: { "id": 0xe9, "name": "Doc", "category": "D-Link", "slots": 1, "type": "N/A", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "D-Link", "element": "N/A" },0xea: { "id": 0xea, "name": "Grumpy", "category": "D-Link", "slots": 1, "type": "N/A", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "D-Link", "element": "N/A" },0xeb: { "id": 0xeb, "name": "Sneezy", "category": "D-Link", "slots": 1, "type": "N/A", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "D-Link", "element": "N/A" },0xec: { "id": 0xec, "name": "Happy", "category": "D-Link", "slots": 1, "type": "N/A", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "D-Link", "element": "N/A" },0xed: { "id": 0xed, "name": "Sleepy", "category": "D-Link", "slots": 1, "type": "N/A", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "D-Link", "element": "N/A" },0xee: { "id": 0xee, "name": "Bashful", "category": "D-Link", "slots": 1, "type": "N/A", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "D-Link", "element": "N/A" },0xef: { "id": 0xef, "name": "Dopey", "category": "D-Link", "slots": 1, "type": "N/A", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "D-Link", "element": "N/A" },0xf0: { "id": 0xf0, "name": "Dark Spiral", "category": "D-Link", "slots": 1, "type": "N/A", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "D-Link", "element": "N/A" },0xf1: { "id": 0xf1, "name": "Dark Splicer", "category": "D-Link", "slots": 1, "type": "N/A", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "D-Link", "element": "N/A" },0xf2: { "id": 0xf2, "name": "Illusion-L", "category": "Friendship", "slots": 2, "type": "N/A", "tier": 0, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Friendship", "element": "N/A" },0xf3: { "id": 0xf3, "name": "Illusion-F", "category": "Friendship", "slots": 2, "type": "N/A", "tier": 0, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Friendship", "element": "N/A" },0xf4: { "id": 0xf4, "name": "Illusion-V", "category": "Friendship", "slots": 2, "type": "N/A", "tier": 0, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Friendship", "element": "N/A" },0xf5: { "id": 0xf5, "name": "Illusion-R", "category": "Friendship", "slots": 2, "type": "N/A", "tier": 0, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Friendship", "element": "N/A" },0xf6: { "id": 0xf6, "name": "Illusion-B", "category": "Friendship", "slots": 2, "type": "N/A", "tier": 0, "healsHp": 0, "equippableBattleCommand": 1, "supercategory": "Friendship", "element": "N/A" },0xf7: { "id": 0xf7, "name": "Dummy", "category": "Dummy", "slots": 0, "type": "N/A", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "Dummy", "element": "N/A" },0xf8: { "id": 0xf8, "name": "Slide", "category": "Movement", "slots": 1, "type": "N/A", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "Movement", "element": "N/A" },0xf9: { "id": 0xf9, "name": "Jump", "category": "Movement", "slots": 1, "type": "N/A", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "Movement", "element": "N/A" },0xfa: { "id": 0xfa, "name": "High Jump", "category": "Movement", "slots": 1, "type": "N/A", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "Movement", "element": "N/A" },0xfb: { "id": 0xfb, "name": "Dodge Roll", "category": "Movement", "slots": 1, "type": "N/A", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "Movement", "element": "N/A" },0xfc: { "id": 0xfc, "name": "Thunder Roll", "category": "Movement", "slots": 1, "type": "N/A", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "Movement", "element": "Thunder" },0xfd: { "id": 0xfd, "name": "Cartwheel", "category": "Movement", "slots": 1, "type": "N/A", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "Movement", "element": "N/A" },0xfe: { "id": 0xfe, "name": "Firewheel", "category": "Movement", "slots": 1, "type": "N/A", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "Movement", "element": "Fire" },0xff: { "id": 0xff, "name": "Air Slide", "category": "Movement", "slots": 1, "type": "N/A", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "Movement", "element": "N/A" },0x100: { "id": 0x100, "name": "Ice Slide", "category": "Movement", "slots": 1, "type": "N/A", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "Movement", "element": "N/A" },0x101: { "id": 0x101, "name": "Reversal", "category": "Movement", "slots": 1, "type": "N/A", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "Movement", "element": "N/A" },0x102: { "id": 0x102, "name": "Glide", "category": "Movement", "slots": 1, "type": "N/A", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "Movement", "element": "N/A" },0x103: { "id": 0x103, "name": "Superglide", "category": "Movement", "slots": 1, "type": "N/A", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "Movement", "element": "N/A" },0x104: { "id": 0x104, "name": "Fire Glide", "category": "Movement", "slots": 1, "type": "N/A", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "Movement", "element": "Fire" },0x105: { "id": 0x105, "name": "Homing Slide", "category": "Movement", "slots": 1, "type": "N/A", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "Movement", "element": "N/A" },0x106: { "id": 0x106, "name": "Teleport", "category": "Movement", "slots": 1, "type": "N/A", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "Movement", "element": "N/A" },0x107: { "id": 0x107, "name": "Sonic Impact", "category": "Movement", "slots": 1, "type": "N/A", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "Movement", "element": "Physical" },0x108: { "id": 0x108, "name": "Doubleflight", "category": "Movement", "slots": 1, "type": "N/A", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "Movement", "element": "N/A" },0x109: { "id": 0x109, "name": "Block", "category": "Defense", "slots": 1, "type": "N/A", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "Defense", "element": "N/A" },0x10a: { "id": 0x10a, "name": "Renewal Block", "category": "Defense", "slots": 1, "type": "N/A", "tier": 0, "healsHp": 1, "equippableBattleCommand": 0, "supercategory": "Defense", "element": "N/A" },0x10b: { "id": 0x10b, "name": "Focus Block", "category": "Defense", "slots": 1, "type": "N/A", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "Defense", "element": "N/A" },0x10c: { "id": 0x10c, "name": "Stun Block", "category": "Defense", "slots": 1, "type": "N/A", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "Defense", "element": "N/A" },0x10d: { "id": 0x10d, "name": "Poison Block", "category": "Defense", "slots": 1, "type": "N/A", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "Defense", "element": "N/A" },0x10e: { "id": 0x10e, "name": "Barrier", "category": "Defense", "slots": 1, "type": "N/A", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "Defense", "element": "N/A" },0x10f: { "id": 0x10f, "name": "Renewal Barrier", "category": "Defense", "slots": 1, "type": "N/A", "tier": 0, "healsHp": 1, "equippableBattleCommand": 0, "supercategory": "Defense", "element": "N/A" },0x110: { "id": 0x110, "name": "Focus Barrier", "category": "Defense", "slots": 1, "type": "N/A", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "Defense", "element": "N/A" },0x111: { "id": 0x111, "name": "Confuse Barrier", "category": "Defense", "slots": 1, "type": "N/A", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "Defense", "element": "N/A" },0x112: { "id": 0x112, "name": "Stop Barrier", "category": "Defense", "slots": 1, "type": "N/A", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "Defense", "element": "N/A" },0x113: { "id": 0x113, "name": "Counter Rush", "category": "Reprisal", "slots": 1, "type": "N/A", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "Reprisal", "element": "N/A" },0x114: { "id": 0x114, "name": "Counter Hammer", "category": "Reprisal", "slots": 1, "type": "N/A", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "Reprisal", "element": "N/A" },0x115: { "id": 0x115, "name": "Reversal Slash", "category": "Reprisal", "slots": 1, "type": "N/A", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "Reprisal", "element": "N/A" },0x116: { "id": 0x116, "name": "Counter Barrier", "category": "Reprisal", "slots": 1, "type": "N/A", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "Reprisal", "element": "N/A" },0x117: { "id": 0x117, "name": "Payback Raid", "category": "Reprisal", "slots": 1, "type": "N/A", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "Reprisal", "element": "N/A" },0x118: { "id": 0x118, "name": "Payback Surge", "category": "Reprisal", "slots": 1, "type": "N/A", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "Reprisal", "element": "N/A" },0x119: { "id": 0x119, "name": "Payback Fang", "category": "Reprisal", "slots": 1, "type": "N/A", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "Reprisal", "element": "N/A" },0x11a: { "id": 0x11a, "name": "Aerial Recovery", "category": "Reprisal", "slots": 1, "type": "N/A", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "Reprisal", "element": "N/A" },0x11b: { "id": 0x11b, "name": "Shotlock", "category": "Dummy", "slots": 1, "type": "N/A", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "Dummy", "element": "N/A" },0x11c: { "id": 0x11c, "name": "Meteor Shower", "category": "Shotlock", "slots": 1, "type": "Blaster", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "Shotlock", "element": "Null" },0x11d: { "id": 0x11d, "name": "Flame Salvo", "category": "Shotlock", "slots": 1, "type": "Blaster", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "Shotlock", "element": "Fire" },0x11e: { "id": 0x11e, "name": "Chaos Snake", "category": "Shotlock", "slots": 1, "type": "Blaster", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "Shotlock", "element": "Null" },0x11f: { "id": 0x11f, "name": "Bubble Blaster", "category": "Shotlock", "slots": 1, "type": "Blaster", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "Shotlock", "element": "Null" },0x120: { "id": 0x120, "name": "Dark Volley", "category": "Shotlock", "slots": 1, "type": "Blaster", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "Shotlock", "element": "Dark" },0x121: { "id": 0x121, "name": "Ragnarok", "category": "Shotlock", "slots": 1, "type": "Ragnarok", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "Shotlock", "element": "Null" },0x122: { "id": 0x122, "name": "Thunderstorm", "category": "Shotlock", "slots": 1, "type": "Ragnarok", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "Shotlock", "element": "Thunder" },0x123: { "id": 0x123, "name": "Bio Barrage", "category": "Shotlock", "slots": 1, "type": "Ragnarok", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "Shotlock", "element": "Thunder" },0x124: { "id": 0x124, "name": "Prism Rain", "category": "Shotlock", "slots": 1, "type": "Ragnarok", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "Shotlock", "element": "Thunder" },0x125: { "id": 0x125, "name": "Pulse Bomb", "category": "Shotlock", "slots": 1, "type": "Ragnarok", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "Shotlock", "element": "Thunder" },0x126: { "id": 0x126, "name": "Photon Charge", "category": "Shotlock", "slots": 1, "type": "Rave", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "Shotlock", "element": "Null" },0x127: { "id": 0x127, "name": "Absolute Zero", "category": "Shotlock", "slots": 1, "type": "Rave", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "Shotlock", "element": "Blizzard" },0x128: { "id": 0x128, "name": "Lightning Ray", "category": "Shotlock", "slots": 1, "type": "Rave", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "Shotlock", "element": "Null" },0x129: { "id": 0x129, "name": "Sonic Shadow", "category": "Shotlock", "slots": 1, "type": "Rave", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "Shotlock", "element": "Null" },0x12a: { "id": 0x12a, "name": "Dark Link", "category": "Shotlock", "slots": 1, "type": "N/A", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "Shotlock", "element": "N/A" },0x12b: { "id": 0x12b, "name": "Ultima Cannon", "category": "Shotlock", "slots": 1, "type": "Ragnarok", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "Shotlock", "element": "Null" },0x12c: { "id": 0x12c, "name": "Lightbloom", "category": "Shotlock", "slots": 1, "type": "Spin", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "Shotlock", "element": "Null" },0x12d: { "id": 0x12d, "name": "Multivortex", "category": "Shotlock", "slots": 1, "type": "Spin", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "Shotlock", "element": "Null" },0x139: { "id": 0x139, "name": "Saber Counter", "category": "Situational", "slots": 0, "type": "N/A", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "Situational", "element": "Null" },0x13c: { "id": 0x13c, "name": "White Calm", "category": "Situational", "slots": 0, "type": "N/A", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "Situational", "element": "Null" },0x13d: { "id": 0x13d, "name": "Selfless Prince", "category": "Situational", "slots": 0, "type": "N/A", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "Situational", "element": "N/A" },0x13e: { "id": 0x13e, "name": "Swing Slash", "category": "Situational", "slots": 0, "type": "N/A", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "Situational", "element": "Null" },0x140: { "id": 0x140, "name": "Astro Strike", "category": "Situational", "slots": 0, "type": "N/A", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "Situational", "element": "Null" },0x141: { "id": 0x141, "name": "Holy Burst", "category": "Situational", "slots": 0, "type": "N/A", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "Situational", "element": "Null" },0x142: { "id": 0x142, "name": "Dual Limit", "category": "Situational", "slots": 0, "type": "N/A", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "Situational", "element": "Null" },0x145: { "id": 0x145, "name": "Joint Force", "category": "Situational", "slots": 0, "type": "N/A", "tier": 0, "healsHp": 0, "equippableBattleCommand": 0, "supercategory": "Situational", "element": "Null" },
}

// Each property element has the following schema:
// property: value
function GetCommandsByProperties(properties)
{
    ret = []
    
    for id in commands
    {
        command = commands[id]
        mismatchFound = false
        
        for key in properties
        {
            if (command[key] != properties[key])
            {
                mismatchFound = true
            }
        }
        
        if (mismatchFound == false)
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
        
        if (callback(command) == true)
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
function VentusArmored() => 4
function VentusArmoredGlider() => 0xa
function VentusArmoredHelmetless() => 0xd
function Aqua() => 2
function AquaArmored() => 5
function AquaArmoredGlider() => 0xb
function AquaArmoredHelmetless() => 0xe

function TerraOnly() => [ Terra() ]
function VentusOnly() => [ Ventus() ]
function AquaOnly() => [ Aqua() ]

function AnyArmoredCharacter() => [ TerraArmored(), VentusArmored(), AquaArmored() ]

function CharacterIsInArray(arr)
{
    trigger = false
    for element in arr
    {
        trigger = trigger || currentCharacter() == element
    }
    
    return trigger
}

function IsPlayingAsTerra() => CharacterIsInArray([ Terra(), TerraArmored(), TerraArmoredGlider() ])
function IsPlayingAsVentus() => CharacterIsInArray([ Ventus(), VentusArmored(), VentusArmoredGlider(), VentusArmoredHelmetless() ])
function IsPlayingAsAqua() => CharacterIsInArray([ Aqua(), AquaArmored(), AquaArmoredGlider(), AquaArmoredHelmetless() ])

function CharacterIdToNames()
{
    return {
        Terra(): "Terra",
        Aqua(): "Aqua",
        Ventus(): "Ventus",
        VentusArmored(): "Ventus",
        TerraArmored(): "Terra",
        AquaArmored(): "Aqua",
        VentusArmoredGlider(): "Ventus",
        TerraArmoredGlider(): "Terra",
        AquaArmoredGlider(): "Aqua",
        VentusArmoredHelmetless(): "Ventus",
        AquaArmoredHelmetless(): "Aqua"
    }
}

function GetAreaRPLookup()
{
    ret = {}
    for hash in areas
    {
        area = areas[hash]
        ret[hash] = area["display"]
    }
    return ret
}

function playTime() => dword(0x1f19880)

function GetWorldById(worldId)
{
    for i in worlds
    {
        if (i == worldId)
        {
            return worlds[i]
        }
    }
    return ""
}

function GetRPWorldLookup()
{
    groups = {}
    
    for hash in areas
    {
        area = areas[hash]
        
        if (area["hideWorld"] == 1)
        {
            groups[hash] = ""
        }
        else
        {
            groups[hash] = GetWorldById(area["worldId"]) + ": "
        }
    }
    
    return groups
}

function IsOnTitleScreen() => IsInLocation("Title")

function GetAreaHash(areaId, worldId) => areaId + worldId * 256

rich_presence_conditional_display(!IsOnTitleScreen(), "{0}, Level {1} | {2}{3} | Play time: {4}",
    rich_presence_lookup("Characters", currentCharacter(), CharacterIdToNames()),
    rich_presence_value("Level", level(), "VALUE"),
    rich_presence_lookup("WorldDisplay", GetAreaHash(areaId(), worldId()), GetRPWorldLookup()),
    rich_presence_lookup("Areas", GetAreaHash(areaId(), worldId()), GetAreaRPLookup()),
    rich_presence_value("Play Time", playTime(), "SECS")
)

rich_presence_conditional_display(IsOnTitleScreen(), "On the title screen...")

rich_presence_display("Somewhere in the World...")

achievement(title = "The Final Stargaze", points = 1, id = 187047, badge = "207934",
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

function ArenaRoundChanged() => mirageArenaCurrentRound() != Delta(mirageArenaCurrentRound()) && characterFieldPointer() != 0

function characterArenaPointer() => tbyte(0xb59ce8)
function arenaHp() => word(characterArenaPointer() + 0x7c + 0x1000000)
function commandBeingUsedInArenaByTerra() => word(characterArenaPointer() - 0x149a8 + 0x1000000)
function commandBeingUsedInArenaByVentus() => word(characterArenaPointer() - 0x15018 + 0x1000000)
function commandBeingUsedInArenaByAqua() => word(characterArenaPointer() - 0x15b48 + 0x1000000)

// We need to check the character pointer delta here because the pointer + offset may point to garbage that's less than the player's HP, causing a hit.
function TookDamageInTheMirageArena() => Delta(arenaHp()) > arenaHp() && Delta(characterArenaPointer()) != 0

function partyFieldPointer() => tbyte(0xb59cec)
function kingMickeyHp() => word(partyFieldPointer() - 0x9af4 + 0x1000000)
function jaqDamage() => word(partyFieldPointer() + 0x20c4 + 0x1000000)
function KingMickeyHpReachedZero() => kingMickeyHp() <= 0 && Delta(kingMickeyHp()) > 0 && partyFieldPointer() != 0
function JaqTookDamage() => Delta(jaqDamage()) < jaqDamage()

function EnteredAttackState() => Delta(characterState()) != 0x10 && characterState() == 0x10
function EnteredMagicState() => Delta(characterState()) != 0x11 && characterState() == 0x11
function IsUsingFinisher() => characterState() == 0x14
function IsGuarding() => characterState() == 0x16
function IsUsingAPhysicalAttack() => characterState() == 0x10
function IsUsingAStandardAttack() => currentAttackInCombo() != 0 && nextAttackInCombo() != 0
function JustStartedSwimming() => characterState() != Delta(characterState()) && characterState() == 0x9
function IsRunning() => characterState() == 0x3
function IsWaitingForBattleToBegin() => characterState() == 0x1c
function IsPerformingASituationalCommand() => characterState() == 0x1d

function dLinkPointer() => tbyte(0xb59ce8)
function dLinkCharge() => dword(dLinkPointer() + 0x1000000 + 0x3c) // todo: actually a float; change when supported
function dLinkId() => word(dLinkPointer() + 0x1000000 + 0x8c)
function commandGaugeCharge() => dword(dLinkPointer() + 0x1000000 + 0x1d30) // todo: also a float
function IsUsingDLink() => dLinkId() != 0 && dLinkPointer() != 0
function CommandGaugeEmptied() => Delta(commandGaugeCharge()) != commandGaugeCharge() && commandGaugeCharge() == 0

function IsUsingAnyGivenCommand(haystack)
{
    trigger = always_false()
    commandIds = GetIdsFromObjects(haystack)
    clusters = GetClustersFromList(commandIds)
    for needle in clusters
    {
        if (needle["min"] == needle["max"])
        {
            trigger = trigger || commandBeingUsed() == needle["min"]
        }
        else
        {
            trigger = trigger || commandBeingUsed() >= needle["min"] && commandBeingUsed() <= needle["max"]
        }
    }
    return trigger
}

function JustUsedAnyGivenCommand(haystack, when = true)
{
    trigger = always_false()
    commandIds = GetIdsFromObjects(haystack)
    clusters = GetClustersFromList(commandIds)
    for needle in clusters
    {
        if (needle["min"] == needle["max"])
        {
            trigger = trigger || Delta(commandBeingUsed()) != commandBeingUsed() && commandBeingUsed() == needle["min"] && when
        }
        else
        {
            trigger = trigger || Delta(commandBeingUsed()) != commandBeingUsed() && commandBeingUsed() >= needle["min"] && commandBeingUsed() <= needle["max"] && when
        }
    }
    return trigger
}

function JustUsedAnyGivenCommandInArenaByMem(haystack, memContainingIdOfCommandBeingUsedInArenaByCharacter)
{
    trigger = always_false()
    for needle in haystack
    {
        trigger = trigger || Delta(memContainingIdOfCommandBeingUsedInArenaByCharacter) != memContainingIdOfCommandBeingUsedInArenaByCharacter
            && memContainingIdOfCommandBeingUsedInArenaByCharacter == needle["id"]
    }
    return trigger 
}

function TerraJustUsedAnyGivenCommandInArena(haystack)
{
    return JustUsedAnyGivenCommandInArenaByMem(haystack, commandBeingUsedInArenaByTerra())
}

function VentusJustUsedAnyGivenCommandInArena(haystack)
{
    return JustUsedAnyGivenCommandInArenaByMem(haystack, commandBeingUsedInArenaByVentus())
}

function AquaJustUsedAnyGivenCommandInArena(haystack)
{
    return JustUsedAnyGivenCommandInArenaByMem(haystack, commandBeingUsedInArenaByAqua())
}

function CheckpointPassedForCharacters(checkpointLogic, allowedCharacters, resetOnDeath = false)
{
    characterIsAllowed = always_false()
    
    for character in allowedCharacters
    {
        characterIsAllowed = characterIsAllowed || currentCharacter() == character
    }
    
    returnedLogic = once(checkpointLogic && characterIsAllowed)
    
    if (resetOnDeath == true)
    {
        returnedLogic = returnedLogic && never(GameOverTriggered())
    }

    return returnedLogic
}

// charactersToTrigger: a dictionary of character IDs to trigger logic; each logical statement will only apply if the player is controlling a specific character
function TriggerConditionsMetForCharacters(charactersToTriggerLogic, useTrigger = false)
{
    triggerMet = always_false()
    for id in charactersToTriggerLogic
    {
        characterLogicIsMet = charactersToTriggerLogic[id]
        
        if (useTrigger == true)
        {
            characterLogicIsMet = trigger_when(characterLogicIsMet)
        }
        
        triggerMet = triggerMet || characterLogicIsMet && currentCharacter() == id
    }
    
    return triggerMet 
}

function battleFlagsAddr() => 0xb5a4b4
function IsInBattle() => bit0(battleFlagsAddr()) == 1
function hudStatus() => bit5(0xb5a4b5)
function HUDAndAttacksDisabled() => hudStatus() == 1
function GameOverTriggered() => IsInBattle() && HUDAndAttacksDisabled() && hp() == 0 && characterFieldPointer() != 0
function BossDefeatTriggered() => IsInBattle() && bit3(battleFlagsAddr()) == 1 && bit5(battleFlagsAddr()) == 1 && hp() > 0 && characterFieldPointer() != 0
function IsPausing() => always_false()
function FrameAdvanced() => Delta(systemTimer()) != systemTimer()

function firstCommandSlotAddr() => 0x1f29388
function lastCommandSlotAddr() => 0x1f2a9b8
function JustObtainedCommandWithId(id, useTrigger = false)
{
    trigger = always_false()
    for addr in range(firstCommandSlotAddr(), lastCommandSlotAddr(), 10)
    {
        slotI = word(addr)
        condition = Delta(slotI) == 0 && slotI == id
        
        if (useTrigger == true)
        {
            condition = trigger_when(condition)
        }
        
        trigger = trigger || condition
    }
    
    return trigger
}

function informationBarState() => byte(0x1f3d760)
function informationBarTextPointer() => tbyte(0x01f3d75c)
function InformationBarJustPoppedUp() => Delta(informationBarState()) == 1 && informationBarState() == 2
function InformationBarPoppedUpOnce() => once(InformationBarJustPoppedUp())
function InformationBarJustReset() => Delta(informationBarState()) > 0 && informationBarState() == 0
function criticalImpactState() => byte(0x1f2accc)
function feverPitchState() => byte(0x1f2acce)
function spellweaverState() => byte(0x1f2accd)

function LearnedCommandStyle(commandStyleStateMem) => commandStyleStateMem == 5 && Delta(commandStyleStateMem) == 0

function LearnedCriticalImpact() => LearnedCommandStyle(criticalImpactState())
function LearnedFeverPitch() => LearnedCommandStyle(feverPitchState())
function LearnedThunderbolt() => LearnedCommandStyle(thunderboltState())
function LearnedSpellweaver() => LearnedCommandStyle(spellweaverState())

function MarkOfMasteryCheckpointReached() => CheckpointPassedForCharacters(InformationBarPoppedUpOnce()
    && IsInLocation("DepartureGreatHall"), [ Terra(), Ventus(), Aqua() ], true
)
    
function TriggerConditionsMetForMarkOfMastery() =>
    TriggerConditionsMetForCharacters({
        Terra(): LearnedCriticalImpact(),
        Ventus(): LearnedFeverPitch(),
        Aqua(): LearnedSpellweaver()
    }, true)

shotlocks = GetCommandsByProperties({ "supercategory": "Shotlock" })
achievement(title = "Hit Ball to Pass Test [m]", points = 3, id = 187048, badge = "207935",
    description = "Complete the first phase of the Mark of Mastery exam using only one attack or fewer and no Shotlocks.",
    trigger = MarkOfMasteryCheckpointReached() && never(tally(2, [ EnteredAttackState(), EnteredMagicState() ]))
        && TriggerConditionsMetForMarkOfMastery()
        && never(JustUsedAnyGivenCommand(shotlocks))
)

function diamondDustState() => byte(0x1f2acd0)
function LearnedDiamondDust() => diamondDustState() == 5 && Delta(diamondDustState()) == 0

achievement(title = "Snap the Spindle [m]", points = 25, id = 187049, badge = "207936",
    description = "Finish off the Wheel Master in Enchanted Dominion with a Finish command (Proud Mode or higher, Level 4 or below).",
    trigger = CheckpointPassedForCharacters(InformationBarPoppedUpOnce()
        && IsInLocation("EnchantedAudience2"), TerraOnly(), true
    ) && TriggerConditionsMetForCharacters({
        Terra(): LearnedDiamondDust()
    }, true) && trigger_when(IsUsingFinisher())
    && IsAtLeastOnDifficulty("Proud") && level() <= 4
    && never(!IsInLocation("EnchantedAudience2"))
)

function MustBeTerra() => never(currentCharacter() != Terra())

function enchantedDominionTerraStoryEntry() => bit0(0x1f28485)
achievement(title = "The First of Seven", points = 3,
    description = "Complete Enchanted Dominion as Terra.",
    trigger = WasBitflagSetInGame(enchantedDominionTerraStoryEntry()) && IsInLocation("WorldMap")
        && MustBeTerra()
)

function counterHammerId() => 0x114
achievement(title = "Chipped Shield [m]", points = 10, id = 187051, badge = "207938",
    description = "Escort Cinderella to the ball without guarding (Proud Mode or higher, Level 5 or below).",
    trigger = IsAlwaysInGame()
        && CheckpointPassedForCharacters(once(InformationBarJustPoppedUp() && IsInLocation("CastleCorridor")) && IsAtLeastOnDifficulty("Proud") && level() <= 5, TerraOnly(), false)
        && TriggerConditionsMetForCharacters({
            Terra(): (JustObtainedCommandWithId(counterHammerId(), true) && trigger_when(IsInLocation("CastleFoyer")))
        }, false)
        && unless(characterFieldPointer() == 0) // Prevent resets when transitioning to the foyer.
        && never(IsGuarding())
)

// NOTE: It's theoretically possible to defeat more than one enemy at a time in this battle. As such, I'll consider it a valid unlock if the player defeats more than one instrument ONLY IF
// the boss itself is defeated in the same frame. We need to do this because the number of active enemies is set to zero as soon as the boss is defeated.
function symphonyMastersDefeated() => word(0x1f35fc4)
achievement(title = "Syncopation [m]", points = 10, id = 187052, badge = "207939",
    description = "Defeat the Symphony Master without destroying more than one instrument (Proud Mode or higher, Level 5 or below).",
    trigger = CheckpointPassedForCharacters(InformationBarPoppedUpOnce()
        && IsInLocation("CastleBallroom"), TerraOnly(), true
    ) && TriggerConditionsMetForCharacters({
        Terra(): WasValueSetInGame(symphonyMastersDefeated(), 0, 1)
    }, true) && trigger_when(Delta(numberOfActiveEnemies()) >= 3 && numberOfActiveEnemies() == 0)
    && IsAtLeastOnDifficulty("Proud") && level() <= 5
    && never(!IsInLocation("CastleBallroom"))
)

function castleOfDreamsTerraStoryEntry() => bit7(0x1f28464)
achievement(title = "Boundless Faith", points = 3,
    description = "Complete Castle of Dreams as Terra.",
    trigger = WasBitflagSetInGame(castleOfDreamsTerraStoryEntry()) && IsInLocation("WorldMap")
        && MustBeTerra()
)

function fissionFiragaTerraChest() => bit3(0x1f2927f)
function dwarfWoodlandsTerraStoryEntry() => bit7(0x1f28444)
achievement(title = "Swiping the Cookie Jar [m]", points = 5,
    description = "Open the Fission Firaga chest in Dwarf Woodlands as Terra before defeating the boss.",
    trigger = WasBitflagSetInGame(fissionFiragaTerraChest()) && dwarfWoodlandsTerraStoryEntry() == 0
        && MustBeTerra()
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

slotBaseAddrs = [ deck1Slot1BaseAddr(), deck2Slot1BaseAddr(), deck3Slot1BaseAddr() ]

function GetInventoryIndex(deckId, commandSlot)
{
    return word(slotBaseAddrs[deckId] + commandSlot * commandIndexWidth()) // 0xffff when no command is equipped
}

// note: will return 0xffff in memory if no command is equipped in the given deck's given slot
function GetInventoryCommandId(deckId, commandSlot)
{
    inventoryIndex = GetInventoryIndex(deckId, commandSlot)
    inventoryOffset = inventoryIndex * commandInventoryWidth() // The memory offset from the beginning of the inventory where the command lies
    inventoryCommandId = word(commandInventorySlot1BaseAddr() + inventoryOffset) // The accessor containing the actual command ID
    
    return inventoryCommandId
}

// `callback` is an anonymous function that makes a comparison for every battle command slot and accepts the following parameters:
// inventoryIndex - (16-bit) accessor that holds the index for what command lies in a given slot in the Command Menu
// inventoryCommandId - (16-bit) accessor that holds the actual ID of the command represented by the slot being looked at in the callback function
//
// It then evaluates to a tally() call that represents the number of slots that satisfy the callback.
function CommandDeckSlotsFulfillCallback(callback, numberToSatisfy = 0)
{
    trigger = always_false()
    
    for deck in range(0, 2)
    {
        slotsUsedInDeck = []
        for i in range(0, maxNumberOfCommandSlots() - 1)
        {
            needleFoundInHaystack = false
            inventoryIndex = GetInventoryIndex(deck, i)
            inventoryCommandId = GetInventoryCommandId(deck, i)
            
            array_push(slotsUsedInDeck, once(CurrentDeckIs(deck + 1) && callback(inventoryIndex, inventoryCommandId)))
        }
        
        trigger = trigger || tally(numberToSatisfy, slotsUsedInDeck)
    }
    
    return trigger
}

function CommandDeckSlotsFilledIsAtLeast(slotsFilled)
{
    return CommandDeckSlotsFulfillCallback((index, id) => index != 0xffff, slotsFilled)
}

function CommandDeckSlotsFilledByGivenCommandsIsAtLeast(haystack, slotsFilled)
{
    return CommandDeckSlotsFulfillCallback((index, id) {
        needleFoundInHaystack = false
        for i in haystack
        {
            needleFoundInHaystack = needleFoundInHaystack || id == i["id"]
        }
        
        return index != 0xffff && needleFoundInHaystack
    }, slotsFilled)
}

// todo: the last attempt to refactor this to use `CommandDeckSlotsFulfillCallback` resulted in a "&& and || chain is too complex" error. Attempt to try again later.
function HasAnyOfTheGivenCommandsEquipped(commands)
{
    commandIds = GetIdsFromObjects(commands)
    clusters = GetClustersFromList(commandIds)
    trigger = always_false()
    
    for deck in range(0, 2)
    {
        for i in range(0, maxNumberOfCommandSlots() - 1)
        {
            inventoryIndex = GetInventoryIndex(deck, i)
            inventoryCommandId = GetInventoryCommandId(deck, i)
            
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
        commandFound = false
        
        for allowed in allowlist
        {
            if (allowed["id"] == command["id"])
            {
                commandFound = true
            }
        }
        
        if (commandFound == false)
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
achievement(title = "Sleeping Death [m]", points = 10, id = 187055, badge = "207942",
    description = "Defeat the Spirit of the Magic Mirror equipping battle commands that only inflict status effects (Proud Mode or higher, Level 7 or below, no D-Links).",
    trigger = HasOnlyTheGivenCommandsEquipped(statusCommands)
        && CheckpointPassedForCharacters(InformationBarPoppedUpOnce()
            && IsInLocation("DwarfMirror"), [ Terra(), Aqua() ], true
        ) && TriggerConditionsMetForCharacters({
            Terra(): FirestormLearned(),
            Aqua(): DeckCapacityIncreased()
        }, true)
        && IsAtLeastOnDifficulty("Proud") && level() <= 7
        && never(!IsInLocation("DwarfMirror"))
        && never(IsUsingDLink())
)

achievement(title = "A Grave Riddle", points = 3,
    description = "Complete Dwarf Woodlands as Terra.",
    trigger = WasBitflagSetInGame(dwarfWoodlandsTerraStoryEntry()) && IsInLocation("WorldMap")
        && MustBeTerra()
)

function IsAbilityTurnedOn(addr)
{
    return bit0(addr) + bit1(addr) * 2 + bit2(addr) * 4 > 0
}

function trinityArmorsDefeated() => word(0x1f35fd6)
function TrinityArmorWasJustDefeated() => Delta(trinityArmorsDefeated()) < trinityArmorsDefeated()
function secondChanceActiveAddr() => 0x1f2acbc
function onceMoreActiveAddr() => 0x1f2acc0
achievement(title = "Face, Meet Cannon [m]", points = 10, id = 187057, badge = "207944",
    description = "Defeat the Trinity Armor in Radiant Garden without Second Chance or Once More equipped (Critical Mode, Level 8 or below).",
    trigger = IsAlwaysInGame()
        && CheckpointPassedForCharacters(once(InformationBarJustPoppedUp() && IsInLocation("RadiantReactor")) && IsAtLeastOnDifficulty("Critical") && level() <= 8,
            [ Terra(), Ventus(), Aqua() ], true)
        && TriggerConditionsMetForCharacters({
            Terra(): TrinityArmorWasJustDefeated(),
            Ventus(): TrinityArmorWasJustDefeated(),
            Aqua(): TrinityArmorWasJustDefeated()
        }, true)
        && never(IsAbilityTurnedOn(secondChanceActiveAddr()))
        && never(IsAbilityTurnedOn(onceMoreActiveAddr()))
)

achievement(title = "He Who Liveth by the Sword... [m]", points = 10, id = 187058, badge = "207945",
    description = "Defeat Braig in Radiant Garden without using any standard attacks (Proud Mode or higher, Level 8 or below).",
    trigger = CheckpointPassedForCharacters(InformationBarPoppedUpOnce()
        && IsInLocation("RadiantPurification"), TerraOnly(), true
    ) && TriggerConditionsMetForCharacters({
        Terra(): DeckCapacityIncreased()
    }, true)
    && IsAtLeastOnDifficulty("Proud") && level() <= 8
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
nonHealingMagicCommands = GetCommandsByProperties({ "supercategory": "Magic", "healsHp": 0 })
function BeganFinalsAsTerra() => bit4(0x1f28505) == 1
achievement(title = "Self-Reliance [m]", points = 25, id = 187061, badge = "207948",
    description = "Reach the finals of the Olympus Coliseum Games as Terra without using D-Links or non-healing magic commands (Proud Mode or higher, Level 11 or below).",
    trigger = CheckpointPassedForCharacters(InformationBarPoppedUpOnce()
            && IsInLocation("OlympusEast") && level() <= 11, TerraOnly(), true)
            && TriggerConditionsMetForCharacters({
                Terra(): MaxHPIncreased()
            }, true)
        && IsAtLeastOnDifficulty("Proud")
        && never(!IsInLocation("OlympusEast"))
        && never(IsUsingDLink())
        && never(JustUsedAnyGivenCommand(nonHealingMagicCommands))
        && !BeganFinalsAsTerra()
        && never(InformationBarJustReset()) // Ensure the checkpoints are reset on timeout failure, too.
)

forbiddenCommandsAgainstZack = GetCommandsByCallback(command => command["element"] != "N/A" && command["element"] != "Null" && command["element"] != "Physical" && command["id"] != 0xffff)
function DefeatedZackForTheFirstTime() => bit2(0x1f28505) == 1
achievement(title = "Out of Your Element [m]", points = 10, id = 187062, badge = "207949",
    description = "Win your second fight against Zack using only physical- or null-elemental commands (Proud Mode or higher, Level 11 or below).",
    trigger = CheckpointPassedForCharacters(InformationBarPoppedUpOnce()
            && IsInLocation("OlympusEast"), TerraOnly(), true)
            && TriggerConditionsMetForCharacters({
                // The second fight yields no reward, so we must use something that may be less than reliable here...
                Terra(): BossDefeatTriggered()
            }, true)
        && IsAtLeastOnDifficulty("Proud") && level() <= 11
        && never(!IsInLocation("OlympusEast"))
        && never(JustUsedAnyGivenCommand(forbiddenCommandsAgainstZack))
        && BeganFinalsAsTerra()
        && never(!DefeatedZackForTheFirstTime())
)

function olympusColiseumTerraStoryEntry() => bit3(0x1f28505)
achievement(title = "First-Class Soldier", points = 3,
    description = "Complete Olympus Coliseum as Terra.",
    trigger = WasBitflagSetInGame(olympusColiseumTerraStoryEntry()) && IsInLocation("WorldMap")
        && MustBeTerra()
)

fireCommands = GetCommandsByProperties({ "element": "Fire" })
function thunderboltState() => byte(0x1f2acd1)
function ThunderboltLearned() => Delta(thunderboltState()) == 0 && thunderboltState() == 5
achievement(title = "Hypoxic Cabin [m]", points = 5, id = 187064, badge = "207951",
    description = "Defeat Experiment 221 without using any fire-elemental commands (Proud Mode or higher, Level 15 or below).",
    trigger = CheckpointPassedForCharacters(InformationBarPoppedUpOnce()
            && IsInLocation("SpacePod"), TerraOnly(), true)
            && TriggerConditionsMetForCharacters({
                Terra(): ThunderboltLearned()
            }, true)
        && IsAtLeastOnDifficulty("Proud") && level() <= 15
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

function TerraUsedAnyUniqueCommandsGivenNumberOfTimesInArena(usableCommands, usages)
{
    trigger = []
    
    for command in usableCommands
    {
        array_push(trigger, once(Delta(commandBeingUsedInArenaByTerra()) == 0 && commandBeingUsedInArenaByTerra() == command["id"]))
    }
    
    return tally(usages, trigger)
}

function VentusUsedAnyUniqueCommandsGivenNumberOfTimesInArena(usableCommands, usages)
{
    trigger = []
    
    for command in usableCommands
    {
        array_push(trigger, once(Delta(commandBeingUsedInArenaByVentus()) == 0 && commandBeingUsedInArenaByVentus() == command["id"]))
    }
    
    return tally(usages, trigger)
}


function AquaUsedAnyUniqueCommandsGivenNumberOfTimesInArena(usableCommands, usages)
{
    trigger = []
    
    for command in usableCommands
    {
        array_push(trigger, once(Delta(commandBeingUsedInArenaByAqua()) == 0 && commandBeingUsedInArenaByAqua() == command["id"]))
    }
    
    return tally(usages, trigger)
}

jumpCommands = GetCommandsByCallback(command => command["name"] == "Jump" || command["name"] == "High Jump")
battleCommands = GetCommandsByCallback(command => command["supercategory"] == "Attack" || command["supercategory"] == "Magic" || command["supercategory"] == "Item"
    || command["supercategory"] == "Friendship" || command["supercategory"] == "D-Link")
function bladechargeState() => byte(0x1f2acd3)
function BladechargeLearned() => Delta(bladechargeState()) == 0 && bladechargeState() == 5
function DefeatedPeterPan() => bit5(0x1f28564) == 1
achievement(title = "Minesweeper [m]", points = 5, id = 187066, badge = "207953",
    description = "Defeat Peter Pan using only one type of battle command and without taking damage (Proud Mode or higher, Level 17 or below).",
    trigger = CheckpointPassedForCharacters(InformationBarPoppedUpOnce()
        && IsInLocation("NeverlandSkullCavern"), TerraOnly(), true)
        && TriggerConditionsMetForCharacters({
            Terra(): BladechargeLearned()
        }, true)
        && IsAtLeastOnDifficulty("Proud") && level() <= 17
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

achievement(title = "Claimed by the Abyss [m]", points = 50, id = 187068, badge = "207955",
    description = "Defeat Eraqus without ever leaving the Dark Impulse Command Style (Proud Mode or higher, Level 18 or below).",
    trigger = CheckpointPassedForCharacters(InformationBarPoppedUpOnce()
        && IsInLocation("DepartureForecourtDay"), TerraOnly(), true)
        && TriggerConditionsMetForCharacters({
            Terra(): MaxHPIncreased()
        }, true)
        && IsAtLeastOnDifficulty("Proud") && level() <= 18
        && never(!IsInLocation("DepartureForecourtDay"))
        && never(CommandGaugeEmptied())
)

function landOfDepartureIITerraStoryEntry() => bit0(0x1f28425)
achievement(title = "Patricide", points = 3,
    description = "Complete Terra's second visit to the Land of Departure.",
    trigger = WasBitflagSetInGame(landOfDepartureIITerraStoryEntry()) && IsInLocation("WorldMap")
        && MustBeTerra()
)

function DefeatedXehanortI() => bit0(0x1f285a5) == 1
achievement(title = "Give Me Strength [m]", points = 10, id = 187070, badge = "207957",
    description = "Defeat Xehanort solo using only battle commands while a D-Link is active (Proud Mode or higher, Level 20 or below).",
    trigger = CheckpointPassedForCharacters(InformationBarPoppedUpOnce()
        && IsInLocation("Graveyard3"), TerraOnly(), true)
        && TriggerConditionsMetForCharacters({
            Terra(): BossDefeatTriggered()
        }, true)
        && IsAtLeastOnDifficulty("Proud") && level() <= 20
        && never(!IsInLocation("Graveyard3"))
        && never(!DefeatedXehanortI())
        && (always_true() || never(JustUsedAnyGivenCommand(battleCommands)) && unless(IsUsingDLink()))
)

function DefeatedXehanortII() => bit1(0x1f285a5) == 1
cureFamilyCommands = GetCommandsByCallback(command => command["name"] == "Cure" || command["name"] == "Cura" || command["name"] == "Curaga")
achievement(title = "Terminal Corruption [m]", points = 25, id = 187071, badge = "207958",
    description = "Defeat the final boss of Terra's story without using any commands in the Cure family (Proud Mode or higher, Level 22 or below).",
    trigger = CheckpointPassedForCharacters(InformationBarPoppedUpOnce()
        && IsInLocation("GraveyardCage"), [ TerraArmored() ], true)
        && TriggerConditionsMetForCharacters({
            // The final boss, of course, yields no rewards.
            TerraArmored(): BossDefeatTriggered()
        }, true)
        && IsAtLeastOnDifficulty("Proud") && level() <= 22
        && never(!IsInLocation("GraveyardCage"))
        && never(JustUsedAnyGivenCommand(cureFamilyCommands))
)

function gameStateDeterminer() => byte(0xb47ade)
function xehanortReport11() => bit0(0x1f2932d)
function battleReportFrameLimit() => 60
function ViewedBattleReportLongEnough() => once(Delta(gameStateDeterminer()) != gameStateDeterminer() && gameStateDeterminer() == 0x81)
    && repeated(battleReportFrameLimit(), gameStateDeterminer() == 0x81)
    // This reset clause here is intended to avoid false triggers. The idea is that if the player doesn't earn the achievement by the time the previous line of code is true,
    // they won't have the chance to unlock it at all. We need to do this because the game doesn't properly clear key memory once the player returns to the title screen.
    && never(repeated(battleReportFrameLimit() + 1, gameStateDeterminer() == 0x81))
    
function TerraStoryCompleted() => WasBitflagSetInGame(xehanortReport11()) && ViewedBattleReportLongEnough() && currentCharacter() == TerraArmored()
achievement(title = "The Vessel", points = 10, id = 187072, badge = "207959",
    description = "Complete Terra's story.",
    trigger = TerraStoryCompleted()
)

achievement(title = "Proud Warrior", points = 10, id = 187073, badge = "207960",
    description = "Complete Terra's story on Proud Mode or higher.",
    trigger = TerraStoryCompleted() && IsAtLeastOnDifficulty("Proud")
)

achievement(title = "Critical Warrior", points = 25, id = 187074, badge = "207961",
    description = "Complete Terra's story on Critical Mode.",
    trigger = TerraStoryCompleted() && IsAtLeastOnDifficulty("Critical")
)

function EscortedSnowWhite() => bit3(0x1f28445) == 1
whiteCalmCommands = GetCommandsByProperties({ "name": "White Calm" })
achievement(title = "White Noise [m]", points = 10,
    description = "Escort Snow White out of the Deep Woods using White Calm only two times or fewer (Proud Mode or higher, Level 1).",
    trigger = CheckpointPassedForCharacters(InformationBarPoppedUpOnce()
        && IsInLocation("DwarfWoods"), VentusOnly(), true)
        && TriggerConditionsMetForCharacters({
            Ventus(): MaxHPIncreased()
        }, true)
        && IsAtLeastOnDifficulty("Proud") && level() <= 1
        && !EscortedSnowWhite() // We need to check this because the boss fight for this world takes place in the same room.
        && never(!IsInLocation("DwarfWoods"))
        && never(repeated(3, JustUsedAnyGivenCommand(whiteCalmCommands)))
        // We need to reset after every game over, and the standard game over check doesn't work if Snow White dies. The HUD is only disabled on game over in this case,
        // so we can use this safely.
        && never(Delta(hudStatus()) == 0 && hudStatus() == 1)
)

madTreantForbiddenCommands = GetCommandsByCallback(command => command["element"] == "Fire" || command["element"] == "Thunder")
achievement(title = "Only You Can Prevent Wildfires [m]", points = 10, id = 187076, badge = "207963",
    description = "Defeat the Mad Treant in the Dwarf Woodlands without using fire- or thunder-elemental commands (Proud Mode or higher, Level 3 or below).",
    trigger = CheckpointPassedForCharacters(InformationBarPoppedUpOnce()
        && IsInLocation("DwarfWoods"), VentusOnly(), true)
        && TriggerConditionsMetForCharacters({
            Ventus(): DeckCapacityIncreased()
        }, true)
        && IsAtLeastOnDifficulty("Proud") && level() <= 3
        && EscortedSnowWhite() // We need to check this because another achievement is triggered in the same room.
        && never(!IsInLocation("DwarfWoods"))
        && never(JustUsedAnyGivenCommand(madTreantForbiddenCommands))
)

function MustBeVentus() => never(currentCharacter() != Ventus())

function dwarfWoodlandsVenStoryEntry() => bit6(0x1f28445)
achievement(title = "The Fruits of His Labor", points = 3,
    description = "Complete Dwarf Woodlands as Ventus.",
    trigger = WasBitflagSetInGame(dwarfWoodlandsVenStoryEntry()) && IsInLocation("WorldMap")
)

// This does not include boss Unversed--at the moment, anyway--since different bosses can share the same address depending on the character.
enemyMem = [
    word(0x1f35f80), // Floods
    word(0x1f35f82), // Scrappers
    word(0x1f35f84), // Bruisers
    word(0x1f35f86), // Red Hot Chilis
    word(0x1f35f88), // Monotruckers
    word(0x1f35f8a), // Thornbites
    word(0x1f35f8c), // Shoegazers
    word(0x1f35f8e), // Spiderchests
    word(0x1f35f90), // Archravens
    word(0x1f35f92), // Hareraisers
    word(0x1f35f94), // Jellyshades I
    word(0x1f35f96), // Jellyshades II
    word(0x1f35f98), // Jellyshades III
    word(0x1f35f9a), // Jellyshades IV
    word(0x1f35f9c), // Tank Topplers
    word(0x1f35f9e), // Vile Phials
    word(0x1f35fa0), // Sonic Blasters I
    word(0x1f35fa2), // Sonic Blasters II
    word(0x1f35fa4), // Triple Wreckers I
    word(0x1f35fa6), // Triple Wreckers II
    word(0x1f35fa8), // Triple Wreckers III
    word(0x1f35faa), // Wild Bruisers
    word(0x1f35fac), // Blue Sea Salts
    word(0x1f35fae), // Yellow Mustards
    word(0x1f35fb0), // Mandrakes
    word(0x1f35fb2), // Buckle Bruisers
    word(0x1f35fb4), // Chrono Twisters
    word(0x1f35fb6), // Axe Flappers
    word(0x1f35fb8), // Prize Pods
    word(0x1f35fba), // Glidewinders I
    word(0x1f35fbc), // Glidewinders II
    word(0x1f35fbe), // Glidewinders III
    word(0x1f35fc0) // Blobmobs
]

function JustDefeatedEnemy(simultaneousKillsAllowed = 29)
{
    trigger = false
    
    for mem in enemyMem
    {
        for i in range(0, simultaneousKillsAllowed) // To help mitigate the risk that multiples of a given enemy are killed in a single frame.
        {
            trigger = trigger || Delta(mem) + i < mem
        }
    }
    
    return trigger
}

function cutsceneBeforeLuciferFight() => bit7(0x1f28464)
function castleOfDreamsVenStoryEntry() => bit2(0x1f28465)
function IsFacingLucifer() => cutsceneBeforeLuciferFight() == 1 && castleOfDreamsVenStoryEntry() == 0

nonJumpCommands = GetCommandsByCallback(command => command["name"] != "Jump" && command["name"] != "High Jump")
achievement(title = "Be-twine My Toes", points = 1,
    description = "Defeat 34 enemies in a row in the Wardrobe Room as Ventus without using any command besides jumping.",
    trigger = never(!IsInLocation("CastleWardrobe")) && repeated(34, JustDefeatedEnemy(10))
         && never(JustUsedAnyGivenCommand(nonJumpCommands))
         && never(IsFacingLucifer())
)

achievement(title = "Accept Your Helplessness [m]", points = 5, id = 187079, badge = "207966",
    description = "Defeat Lucifer without healing (Proud Mode or higher, Level 4 or below).",
    trigger = CheckpointPassedForCharacters(InformationBarPoppedUpOnce()
        && IsInLocation("CastleWardrobe2"), VentusOnly(), true)
        && TriggerConditionsMetForCharacters({
            Ventus(): LearnedDiamondDust()
        }, true)
        && IsAtLeastOnDifficulty("Proud") && level() <= 4
        && never(!IsFacingLucifer()) // We need to check this because the information bar is triggered while collecting dress materials in the same room.
        && never(!IsInLocation("CastleWardrobe2"))
        && never(Delta(hp()) < hp())
)

achievement(title = "Shoot for the Moon", points = 3,
    description = "Complete Castle of Dreams as Ventus.",
    trigger = WasBitflagSetInGame(castleOfDreamsVenStoryEntry()) && IsInLocation("WorldMap")
        && MustBeVentus()
)

function cutsceneBeforeMaleficentFight() => bit3(0x1f28485)
function enchantedDominionVenStoryEntry() => bit6(0x1f28485)
function IsFacingMaleficent() => cutsceneBeforeMaleficentFight() == 1 && enchantedDominionVenStoryEntry() == 0
jointForceCommand = GetCommandsByProperties({ "name": "Joint Force" })
achievement(title = "Disbelief in Fairies [m]", points = 5, id = 187081, badge = "207968",
    description = "Defeat Maleficent without using the Joint Force command (Proud Mode or higher, Level 5 or below).",
    trigger = CheckpointPassedForCharacters(InformationBarPoppedUpOnce()
        && IsInLocation("EnchantedThrone"), VentusOnly(), true)
        && TriggerConditionsMetForCharacters({
            Ventus(): LearnedThunderbolt()
        }, true)
        && IsAtLeastOnDifficulty("Proud") && level() <= 5
        && never(!IsInLocation("EnchantedThrone"))
        && never(JustUsedAnyGivenCommand(jointForceCommand))
        && never(!IsFacingMaleficent()) // We need to check this because the information bar is triggered in this room in a previous scripted battle.
)

achievement(title = "Pursuit of the Wayward", points = 3,
    description = "Complete Enchanted Dominion as Ventus.",
    trigger = WasBitflagSetInGame(enchantedDominionVenStoryEntry()) && IsInLocation("WorldMap")
        && MustBeVentus()
)

function cutsceneBeforeVanitasIFightAsVen() => bit5(0x1f285a4)
function badlandsVenStoryEntry() => bit7(0x1f285a4)
function IsFacingVanitasIAsVen() => cutsceneBeforeVanitasIFightAsVen() == 1 && badlandsVenStoryEntry() == 0
achievement(title = "Field Medic [m]", points = 25, id = 187083, badge = "207970",
    description = "Defeat Vanitas alongside King Mickey without the latter's HP dropping to zero (Proud Mode or higher, Level 7 or below).",
    trigger = CheckpointPassedForCharacters(InformationBarPoppedUpOnce()
        && IsInLocation("GraveyardBadlands"), VentusOnly(), true)
        && TriggerConditionsMetForCharacters({
            Ventus(): DeckCapacityIncreased()
        }, true)
        && IsAtLeastOnDifficulty("Proud") && level() <= 7
        && never(!IsInLocation("GraveyardBadlands"))
        && never(!IsFacingVanitasIAsVen()) // We need to check this because the information bar is triggered in this room in a previous scripted battle (sure is happening a lot with Ven...).
        && never(KingMickeyHpReachedZero())
)

function radiantGardenVenStoryEntry() => bit2(0x1f284c5)
achievement(title = "The Problem of Trust", points = 3,
    description = "Complete Radiant Garden as Ventus.",
    trigger = WasBitflagSetInGame(radiantGardenVenStoryEntry()) && IsInLocation("WorldMap")
        && MustBeVentus()
)

// A "golf" setting of true means that lower values are better.
function HighScoreEarned(mem, target, golf = false)
{
    if (golf == true)
    {
        // We assume that golf values are set to 0 by default before a new record is set.
        return (ValueJustDecreasedInGame(mem) || ValueJustIncreasedInGame(mem) && Delta(mem) == 0) && mem <= target && mem > 0
    }
    else
    {
        return ValueJustIncreasedInGame(mem) && mem >= target
    }
}

// So, some explanation is in order in regards to how ranking works in Ice Cream Beat. As it turns out, the only score that matters is the base high score, NOT the total
// high score. The latter is simply a sum of the base high score and the "meter bonus" and ultimately has no bearing whatsoever on the final ranking.

function itsASmallWorldMasterBaseHighScore() => dword(0x1f357a4)
function itsASmallWorldMasterScoreTarget() => 0x9b8
achievement(title = "Maestro - \"It's a Small World\"", points = 10,
    description = "Set a new base high score that earns a ranking of Fantastic for the song \"It's a Small World\" in Ice Cream Beat on Master Mode.",
    trigger = HighScoreEarned(itsASmallWorldMasterBaseHighScore(), itsASmallWorldMasterScoreTarget())
)

function blastAwayMasterBaseHighScore() => dword(0x1f35804)
function blastAwayMasterScoreTarget() => 0xcc6
achievement(title = "Maestro - \"Blast Away! Gummi Ship II\"", points = 10,
    description = "Set a new base high score that earns a ranking of Fantastic for the song \"Blast Away! Gummi Ship II\" in Ice Cream Beat on Master Mode.",
    trigger = HighScoreEarned(blastAwayMasterBaseHighScore(), blastAwayMasterScoreTarget())
)

function dessertParadiseMasterBaseHighScore() => dword(0x1f357d4)
function dessertParadiseMasterScoreTarget() => 0x94e
achievement(title = "Maestro - \"Dessert Paradise\"", points = 10,
    description = "Set a new base high score that earns a ranking of Fantastic for the song \"Dessert Paradise\" in Ice Cream Beat on Master Mode.",
    trigger = HighScoreEarned(dessertParadiseMasterBaseHighScore(), dessertParadiseMasterScoreTarget())
)

function destinyIslandsMasterBaseHighScore() => dword(0x1f35834)
function destinyIslandsMasterScoreTarget() => 0xb8e
achievement(title = "Maestro - \"Destiny Islands\"", points = 10,
    description = "Set a new base high score that earns a ranking of Fantastic for the song \"Destiny Islands\" in Ice Cream Beat on Master Mode.",
    trigger = HighScoreEarned(destinyIslandsMasterBaseHighScore(), destinyIslandsMasterScoreTarget())
)

function handInHandMasterBaseHighScore() => dword(0x1f35864)
function handInHandMasterScoreTarget() => 0xc6a
achievement(title = "Maestro - \"Hand in Hand\"", points = 25,
    description = "Set a new base high score that earns a ranking of Fantastic for the song \"Hand in Hand\" in Ice Cream Beat on Master Mode.",
    trigger = HighScoreEarned(handInHandMasterBaseHighScore(), handInHandMasterScoreTarget())
)

function CharacterSpecificHighScoreEarned(terraHighScore, venHighScore, aquaHighScore, target, golf = false)
{
    return HighScoreEarned(terraHighScore, target, golf) && currentCharacter() == Terra()
        || HighScoreEarned(venHighScore, target, golf) && currentCharacter() == Ventus()
        || HighScoreEarned(aquaHighScore, target, golf) && currentCharacter() == Aqua()
}

function breakTheUrnsHighScoreTerra() => word(0x1f35c9a)
function breakTheUrnsHighScoreVen() => word(0x1f35c98)
function breakTheUrnsHighScoreAqua() => word(0x1f35c9c)
function breakTheUrnsScoreTarget() => 180
achievement(title = "The Urninator", points = 10, id = 187090, badge = "207977",
    description = "Set a new high score of at least " + breakTheUrnsScoreTarget() + " in the Break the Urns minigame.",
    trigger = CharacterSpecificHighScoreEarned(breakTheUrnsHighScoreTerra(), breakTheUrnsHighScoreVen(), breakTheUrnsHighScoreAqua(), breakTheUrnsScoreTarget())
)

function airSlideId() => 0xff
function cutsceneBeforeOlympusDefense() => bit3(0x1f28505)
function olympusColiseumVenStoryEntry() => bit4(0x1f28505)
function IsDefendingOlympusColiseum() => cutsceneBeforeOlympusDefense() == 1 && olympusColiseumVenStoryEntry() == 0
olympusDefenseForbiddenCommands = GetCommandsByCallback(command => command["name"] != "Swing Slash" && command["supercategory"] != "Movement")
swingSlash = GetCommandsByProperties({ "name": "Swing Slash" })
achievement(title = "So Long, King Ventus! [m]", points = 1, id = 187091, badge = "207978",
    description = "As Ventus, defend the Games from the Unversed using only Swing Slash and movement commands, and no standard attacks (Proud Mode or higher, Level 14 or below).",
    trigger = CheckpointPassedForCharacters(InformationBarPoppedUpOnce() && IsInLocation("OlympusTown"), VentusOnly(), true)
        && TriggerConditionsMetForCharacters({
            Ventus(): (JustObtainedCommandWithId(airSlideId(), true) && trigger_when(IsInLocation("OlympusTown")))
        }, false)
        && IsAtLeastOnDifficulty("Proud") && level() <= 14
        && never(!IsInLocation("OlympusTown"))
        && never(JustUsedAnyGivenCommand(olympusDefenseForbiddenCommands))
        && never(IsUsingAStandardAttack())
        && never(!IsDefendingOlympusColiseum()) // We need to check this because the information bar is triggered in this room in a previous scripted battle.
)

achievement(title = "A Wish to Reconcile", points = 3,
    description = "Complete Olympus Coliseum as Ventus.",
    trigger = WasBitflagSetInGame(olympusColiseumVenStoryEntry()) && IsInLocation("WorldMap")
        && MustBeVentus()
)

metamorphosisForbiddenCommands = GetCommandsByCallback(command => command["name"] == "Astro Strike")
achievement(title = "The Miracle of Gravity [m]", points = 5, id = 187093, badge = "207980",
    description = "Defeat the Metamorphosis without using Astro Strike (Proud Mode or higher, Level 17 or below).",
    trigger = CheckpointPassedForCharacters(InformationBarPoppedUpOnce() && IsInLocation("SpaceMachineryBay"), VentusOnly(), true)
        && TriggerConditionsMetForCharacters({
            Ventus(): MaxHPIncreased()
        }, true)
        && IsAtLeastOnDifficulty("Proud") && level() <= 17
        && never(!IsInLocation("SpaceMachineryBay"))
        && never(JustUsedAnyGivenCommand(metamorphosisForbiddenCommands))
)

function deepSpaceVenStoryEntryUnlocked() => bit3(0x1f28525)
achievement(title = "To the Ends of the Cosmos", points = 3,
    description = "Complete Deep Space as Ventus.",
    trigger = WasBitflagSetInGame(deepSpaceVenStoryEntryUnlocked()) && IsInLocation("WorldMap")
        && MustBeVentus()
)

achievement(title = "Closest Quarters [m]", points = 25, id = 187095, badge = "207982",
    description = "Defeat Captain Hook without swimming in the water more than three times (Proud Mode or higher, Level 23 or below).",
    trigger = CheckpointPassedForCharacters(InformationBarPoppedUpOnce() && IsInLocation("NeverlandCove"), VentusOnly(), true)
        && TriggerConditionsMetForCharacters({
            Ventus(): BossDefeatTriggered()
        }, true)
        && IsAtLeastOnDifficulty("Proud") && level() <= 23
        && never(!IsInLocation("NeverlandCove"))
        && never(repeated(4, JustStartedSwimming()))
)

function neverlandVenStoryEntryUnlocked() => bit4(0x1f28565)
achievement(title = "Always a Step Closer to Home", points = 3,
    description = "Complete Neverland as Ventus.",
    trigger = WasBitflagSetInGame(neverlandVenStoryEntryUnlocked()) && IsInLocation("WorldMap")
        && MustBeVentus()
)

function fireScreenActiveAddr() => 0x1f2ac98
function blizzardScreenActiveAddr() => 0x1f2ac9c
function thunderScreenActiveAddr() => 0x1f2aca0
function darkScreenActiveAddr() => 0x1f2aca4
nonBlizzardAndNonCureBattleCommandsAndShotlocks = GetCommandsByCallback(command => command["element"] != "Blizzard" && command["healsHp"] == 0 && command["equippableBattleCommand"] == 1
    || command["supercategory"] == "Shotlock" && command["element"] != "Blizzard")
achievement(title = "Severe Frostbite [m]", points = 10, id = 187097, badge = "207984",
    description = "Defeat Vanitas in the Keyblade Graveyard with no Screen abilities enabled and " +
        "without using battle commands or Shotlocks that aren't Blizzard-based or HP curative (Proud Mode or higher, Level 24 or below).",
    trigger = CheckpointPassedForCharacters(InformationBarPoppedUpOnce() && IsInLocation("Graveyard4"), [ VentusArmoredHelmetless() ], true)
        && TriggerConditionsMetForCharacters({
            VentusArmoredHelmetless(): MaxHPIncreased()
        }, true)
        && IsAtLeastOnDifficulty("Proud") && level() <= 24
        && never(!IsInLocation("Graveyard4"))
        && never(JustUsedAnyGivenCommand(nonBlizzardAndNonCureBattleCommandsAndShotlocks))
        && never(IsAbilityTurnedOn(fireScreenActiveAddr()))
        && never(IsAbilityTurnedOn(blizzardScreenActiveAddr()))
        && never(IsAbilityTurnedOn(thunderScreenActiveAddr()))
        && never(IsAbilityTurnedOn(darkScreenActiveAddr()))
)

healingCommands = GetCommandsByProperties({ "healsHp": 1, "equippableBattleCommand": 1 })
achievement(title = "Incomplete Being [m]", points = 25, id = 187098, badge = "207985",
    description = "Defeat Vanitas at the end of Ventus's story with only four battle command slots occupied in the Command Deck, " +
        "only three max of which may be healing commands (Proud Mode or higher, Level 24 or below).",
    trigger = CheckpointPassedForCharacters(InformationBarPoppedUpOnce() && IsInLocation("VentusHeart2"), VentusOnly(), true)
        && TriggerConditionsMetForCharacters({
            Ventus(): BossDefeatTriggered()
        }, true)
        && IsAtLeastOnDifficulty("Proud") && level() <= 24
        && never(!IsInLocation("VentusHeart2"))
        && never(CommandDeckSlotsFilledIsAtLeast(5))
        && never(CommandDeckSlotsFilledByGivenCommandsIsAtLeast(healingCommands, 4))
)

function xehanortReport10() => bit7(0x1f2932c)
function VentusStoryCompleted() => WasBitflagSetInGame(xehanortReport10()) && ViewedBattleReportLongEnough() && currentCharacter() == Ventus()
achievement(title = "The Dormant", points = 10, id = 187099, badge = "207986",
    description = "Complete Ventus's story.",
    trigger = VentusStoryCompleted()
)

achievement(title = "Proud Guardian", points = 10, id = 187100, badge = "207987",
    description = "Complete Ventus's story on Proud Mode or higher.",
    trigger = VentusStoryCompleted() && IsAtLeastOnDifficulty("Proud")
)

achievement(title = "Critical Guardian", points = 25, id = 187101, badge = "207988",
    description = "Complete Ventus's story on Critical Mode.",
    trigger = VentusStoryCompleted() && IsAtLeastOnDifficulty("Critical")
)

achievement(title = "Mouse-like Stealth [m]", points = 5, id = 187102, badge = "207989",
    description = "Escort Jaq to the mousehole without running or using battle commands (Proud Mode or higher, Level 3 or below).",
    trigger = CheckpointPassedForCharacters(InformationBarPoppedUpOnce()
        && IsInLocation("CastleWardrobe"), AquaOnly(), true)
        && TriggerConditionsMetForCharacters({
            Aqua(): LearnedThunderbolt()
        }, true)
        && IsAtLeastOnDifficulty("Proud") && level() <= 3
        && never(!IsInLocation("CastleWardrobe"))
        && never(IsRunning())
        && never(JustUsedAnyGivenCommand(battleCommands))
)

magicCommands = GetCommandsByProperties({ "supercategory": "Magic" })
achievement(title = "Broken Wand [m]", points = 5, id = 187103, badge = "207990",
    description = "Defeat the Cursed Coach in Castle of Dreams without using magic commands (Proud Mode or higher, Level 3 or below).",
    trigger = CheckpointPassedForCharacters(InformationBarPoppedUpOnce()
        && IsInLocation("CastleForest"), AquaOnly(), true)
        && TriggerConditionsMetForCharacters({
            Aqua(): DeckCapacityIncreased()
        }, true)
        && IsAtLeastOnDifficulty("Proud") && level() <= 3
        && never(!IsInLocation("CastleForest"))
        && never(JustUsedAnyGivenCommand(magicCommands))
)

function MustBeAqua() => never(currentCharacter() != Aqua())
function castleOfDreamsAquaStoryEntry() => bit6(0x1f28465)
achievement(title = "Innocence of Youth", points = 3,
    description = "Complete Castle of Dreams as Aqua.",
    trigger = WasBitflagSetInGame(castleOfDreamsAquaStoryEntry()) && IsInLocation("WorldMap")
        && MustBeAqua()
)

function dwarfWoodlandsAquaStoryEntry() => bit1(0x1f28445)
achievement(title = "Sound Awake", points = 3,
    description = "Complete Dwarf Woodlands as Aqua.",
    trigger = WasBitflagSetInGame(dwarfWoodlandsAquaStoryEntry()) && IsInLocation("WorldMap")
        && MustBeAqua()
)

unallowedCastleEscapeCommands = GetCommandsByCallback(command => command["supercategory"] != "Magic" && command["name"] != "Jump" && command["name"] != "Selfless Prince")
function highJumpId() => 0xfa
achievement(title = "You Never Split the Party [m]", points = 10, id = 187106, badge = "207993",
    description = "Escape from Maleficent's castle alongside Prince Phillip using only magic commands, Jump, and Selfless Prince (Proud Mode or higher, Level 6 or below).",
    trigger = CheckpointPassedForCharacters(InformationBarPoppedUpOnce() && IsAtLeastOnDifficulty("Proud") && level() <= 6
        && IsInLocation("EnchantedGates"), AquaOnly(), true)
        && TriggerConditionsMetForCharacters({
            Aqua(): (JustObtainedCommandWithId(highJumpId(), true) && trigger_when(IsInLocation("EnchantedGates")))
        }, false)
        && never(!IsInLocation("EnchantedGates"))
        && never(JustUsedAnyGivenCommand(unallowedCastleEscapeCommands, !IsPerformingASituationalCommand()))
        && never(IsUsingAStandardAttack())
)


function NumberOfTimesGivenCommandsUsed(haystack)
{
    triggers = []
    commandIds = GetIdsFromObjects(haystack)
    clusters = GetClustersFromList(commandIds)
    for needle in clusters
    {
        if (needle["min"] == needle["max"])
        {
            array_push(triggers, Delta(commandBeingUsed()) != commandBeingUsed() && commandBeingUsed() == needle["min"])
        }
        else
        {
            array_push(triggers, Delta(commandBeingUsed()) != commandBeingUsed() && commandBeingUsed() >= needle["min"] && commandBeingUsed() <= needle["max"])
        }
    }
    return triggers
}

balanceGroup1Commands = GetCommandsByProperties({ "supercategory": "Attack" })
balanceGroup2Commands = GetCommandsByProperties({ "supercategory": "Magic" })
itemCommands = GetCommandsByProperties({ "supercategory": "Item" })
achievement(title = "Mind-Body Balance [m]", points = 25, id = 187107, badge = "207994",
    description = "Defeat Dragon Maleficent without using magic commands two more times than attack commands, and vice versa (Proud Mode or higher, Level 6 or below, no items).",
    trigger = CheckpointPassedForCharacters(InformationBarPoppedUpOnce() && IsAtLeastOnDifficulty("Proud") && level() <= 6
        && IsInLocation("EnchantedBridgeThorns"), AquaOnly(), true)
        && TriggerConditionsMetForCharacters({
            Aqua(): MaxHPIncreased()
        }, true)
        && never(!IsInLocation("EnchantedBridgeThorns"))
        && never(tally(2, tally(0, NumberOfTimesGivenCommandsUsed(balanceGroup1Commands)), deduct(tally(0, NumberOfTimesGivenCommandsUsed(balanceGroup2Commands)))))
        && never(tally(2, tally(0, NumberOfTimesGivenCommandsUsed(balanceGroup2Commands)), deduct(tally(0, NumberOfTimesGivenCommandsUsed(balanceGroup1Commands)))))
        && never(JustUsedAnyGivenCommand(itemCommands))
)

function enchantedDominionAquaStoryEntry() => bit3(0x1f28485)
achievement(title = "Love Conquers", points = 3,
    description = "Complete Enchanted Dominion as Aqua.",
    trigger = WasBitflagSetInGame(enchantedDominionAquaStoryEntry()) && IsInLocation("WorldMap")
        && MustBeAqua()
)

achievement(title = "One Precious Chance [m]", points = 50, id = 187109, badge = "207996",
    description = "Defeat Vanitas in Radiant Garden without healing more than twice (Proud Mode or higher, Level 8 or below).",
    trigger = CheckpointPassedForCharacters(InformationBarPoppedUpOnce() && IsAtLeastOnDifficulty("Proud") && level() <= 8
        && IsInLocation("RadiantCentral"), AquaOnly(), true)
        && TriggerConditionsMetForCharacters({
            Aqua(): DeckCapacityIncreased()
        }, true)
        && never(!IsInLocation("RadiantCentral"))
        && never(repeated(3, Delta(hp()) < hp() && Delta(hp()) != 0))
)

function radiantGardenAquaStoryEntry() => bit0(0x1f284c5)
achievement(title = "Unwitting Predecessor", points = 3,
    description = "Complete Radiant Garden as Aqua.",
    trigger = WasBitflagSetInGame(radiantGardenAquaStoryEntry()) && IsInLocation("WorldMap")
        && MustBeAqua()
)


function fruitballShoegazersHighScore() => dword(0x1f35754)

function fruitballBruisersHighScoreTerra() => dword(0x1f35760)
function fruitballBruisersHighScoreVen() => dword(0x1f356e8)
function fruitballBruisersHighScoreAqua() => dword(0x1f35724)

function fruitballChipAndDaleHighScoreTerra() => dword(0x1f3576c)
function fruitballChipAndDaleHighScoreVen() => dword(0x1f356f4)
function fruitballChipAndDaleHighScoreAqua() => dword(0x1f35730)

function fruitballPeteHighScoreTerra() => dword(0x1f35778)
function fruitballPeteHighScoreVen() => dword(0x1f3570c)
function fruitballPeteHighScoreAqua() => dword(0x1f35748)

function fruitballChallengeScoreTarget() => 20

function HighScoreEarnedAgainstBruisers(target = 1) => CharacterSpecificHighScoreEarned(fruitballBruisersHighScoreTerra(), fruitballBruisersHighScoreVen(), fruitballBruisersHighScoreAqua(), target)
function HighScoreEarnedAgainstChipAndDale(target = 1) => CharacterSpecificHighScoreEarned(fruitballChipAndDaleHighScoreTerra(), fruitballChipAndDaleHighScoreVen(),
    fruitballChipAndDaleHighScoreAqua(), target)
function HighScoreEarnedAgainstPete(target = 1) => CharacterSpecificHighScoreEarned(fruitballPeteHighScoreTerra(), fruitballPeteHighScoreVen(), fruitballPeteHighScoreAqua(), target)

achievement(title = "Running Up the Score", points = 5, id = 187111, badge = "207998",
    description = "Set a new high score of " + fruitballChallengeScoreTarget() + " or more in any round of Fruitball.",
    trigger = HighScoreEarned(fruitballShoegazersHighScore(), fruitballChallengeScoreTarget())
        || HighScoreEarnedAgainstBruisers(fruitballChallengeScoreTarget())
        || HighScoreEarnedAgainstChipAndDale(fruitballChallengeScoreTarget())
        || HighScoreEarnedAgainstPete(fruitballChallengeScoreTarget())
)

achievement(title = "Regular Fruitballer", points = 5, id = 187112, badge = "207999",
    description = "Set a new high score versus the Bruisers team in Fruitball.",
    trigger = HighScoreEarnedAgainstBruisers()
)

achievement(title = "Veteran Fruitballer", points = 10, id = 187113, badge = "208000",
    description = "Set a new high score versus Chip and Dale in Fruitball.",
    trigger = HighScoreEarnedAgainstChipAndDale()
)

achievement(title = "Legendary Fruitballer", points = 25, id = 187114, badge = "208001",
    description = "Set a new high score versus Captain Justice or Captain Dark in Fruitball.",
    trigger = HighScoreEarnedAgainstPete()
)

function BeganFinalsAsAqua() => bit7(0x1f28504) == 1
achievement(title = "With but a Finger [m]", points = 10, id = 187115, badge = "208002",
    description = "Reach the finals of the Olympus Coliseum Games as Aqua using only one type of battle command (Proud Mode or higher, Level 10 or below).",
    trigger = CheckpointPassedForCharacters(InformationBarPoppedUpOnce()
            && IsInLocation("OlympusEast") && IsAtLeastOnDifficulty("Proud") && level() <= 10, AquaOnly(), true)
            && TriggerConditionsMetForCharacters({
                Aqua(): MaxHPIncreased()
            }, true)
        && never(!IsInLocation("OlympusEast"))
        && !BeganFinalsAsAqua()
        && never(UsedAnyUniqueCommandsGivenNumberOfTimes(battleCommands, 2))
)

firewheelCommand = GetCommandsByProperties({ "name": "Firewheel" })
achievement(title = "Bad Manners [m]", points = 5, id = 187116, badge = "208003",
    description = "As Aqua, finish off Zack with Firewheel (Proud Mode or higher, Level 10 or below).",
    trigger = CheckpointPassedForCharacters(InformationBarPoppedUpOnce()
            && IsInLocation("OlympusEast") && IsAtLeastOnDifficulty("Proud") && level() <= 10, AquaOnly(), true)
            && TriggerConditionsMetForCharacters({
                Aqua(): (BossDefeatTriggered() && IsUsingAnyGivenCommand(firewheelCommand)) // Like with Terra, defeating Zack yields no reward.
            }, true)
        && never(!IsInLocation("OlympusEast"))
        && BeganFinalsAsAqua()
)

defenseCommand = GetCommandsByProperties({ "supercategory": "Defense" })
achievement(title = "By His Own Petard [m]", points = 5, id = 187117, badge = "208004",
    description = "Defeat Hades and the Ice Titan while a defensive command is active (Proud Mode or higher, Level 10 or below).",
    trigger = CheckpointPassedForCharacters(InformationBarPoppedUpOnce()
            && IsInLocation("OlympusEastNight") && IsAtLeastOnDifficulty("Proud") && level() <= 10, AquaOnly(), true)
            && TriggerConditionsMetForCharacters({
                Aqua(): (LearnedDiamondDust() && IsUsingAnyGivenCommand(defenseCommand))
            }, true)
        && never(!IsInLocation("OlympusEastNight"))
)

function olympusColiseumAquaStoryEntry() => bit5(0x1f28505)
achievement(title = "Star-Crossed", points = 3,
    description = "Complete Olympus Coliseum as Aqua.",
    trigger = WasBitflagSetInGame(olympusColiseumAquaStoryEntry()) && IsInLocation("WorldMap")
        && MustBeAqua()
)

cartwheelAndFirewheelCommands = GetCommandsByCallback(command => command["name"] == "Cartwheel" || command["name"] == "Firewheel")
achievement(title = "Heightened Vulnerability [m]", points = 3, id = 187119, badge = "208006",
    description = "Defeat Gantu without using the Cartwheel or Firewheel commands (Proud Mode or higher, Level 16 or below).",
    trigger = CheckpointPassedForCharacters(InformationBarPoppedUpOnce()
            && IsInLocation("SpaceLaunch") && IsAtLeastOnDifficulty("Proud") && level() <= 16, AquaOnly(), true)
            && TriggerConditionsMetForCharacters({
                Aqua(): BossDefeatTriggered()
            }, true)
        && never(!IsInLocation("SpaceLaunch"))
        && never(JustUsedAnyGivenCommand(cartwheelAndFirewheelCommands))
)

function deepSpaceAquaStoryEntry() => bit6(0x1f28525)
achievement(title = "Proof of Amicability", points = 3,
    description = "Complete Deep Space as Aqua.",
    trigger = WasBitflagSetInGame(deepSpaceAquaStoryEntry()) && IsInLocation("WorldMap")
        && MustBeAqua()
)

achievement(title = "Undergrowth [m]", points = 5, id = 187121, badge = "208008",
    description = "Defeat Vanitas in Neverland at Level 23 or below on Critical Mode.",
    trigger = CheckpointPassedForCharacters(InformationBarPoppedUpOnce()
            && IsInLocation("NeverlandCamp") && IsAtLeastOnDifficulty("Critical") && level() <= 23, AquaOnly(), true)
            && TriggerConditionsMetForCharacters({
                Aqua(): MaxHPIncreased()
            }, true)
        && never(!IsInLocation("NeverlandCamp"))
)

function neverlandAquaStoryEntry() => bit0(0x1f28565)
achievement(title = "Never Apart", points = 3,
    description = "Complete Neverland as Aqua.",
    trigger = WasBitflagSetInGame(neverlandAquaStoryEntry()) && IsInLocation("LanesBetween")
        && MustBeAqua()
)

function equippedKeyblade() => byte(0x1f19b15)
function defeatedBraigKeybladeGraveyard() => bit7(0x1f285a4)
aquaGuardCommands = GetCommandsByCallback(command => command["name"] == "Barrier" || command["name"] == "Renewal Barrier" || command["name"] == "Focus Barrier"
    || command["name"] == "Confuse Barrier" || command["name"] == "Stop Barrier")
function AquaFinalSegmentSharedConditions() => never(JustUsedAnyGivenCommand(aquaGuardCommands)) && never(CommandDeckSlotsFilledByGivenCommandsIsAtLeast(cureFamilyCommands, 2))
    && equippedKeyblade() == 0x17
function DefeatBraigInformationDisplayed() => ascii_string_equals(informationBarTextPointer(), "Defeat Braig!")

achievement(title = "Magical Rage [m]", points = 10, id = 187123, badge = "208010",
    description = "Defeat Braig in the Keyblade Graveyard without using Barrier defensive commands and with Pixie Petal and only one Cure-family command"
        + " equipped (Proud Mode or higher, Level 28 or below).",
    trigger = CheckpointPassedForCharacters(InformationBarPoppedUpOnce()
            && DefeatBraigInformationDisplayed()
            && IsInLocation("Graveyard4") && IsAtLeastOnDifficulty("Proud") && level() <= 28, [ AquaArmoredHelmetless() ], true)
            && TriggerConditionsMetForCharacters({
                AquaArmoredHelmetless(): BossDefeatTriggered()
            }, true)
        && never(!IsInLocation("Graveyard4"))
        && never(!DefeatBraigInformationDisplayed())
        && AquaFinalSegmentSharedConditions()
)

achievement(title = "Divine Rebellion [m]", points = 25, id = 187124, badge = "208011",
    description = "Defeat the final boss of Aqua's story with the same restrictions as the ones in \"Magical Rage\", but with only four battle command slots filled"
        + " (Proud Mode or higher, Level 28 or below).",
    trigger = CheckpointPassedForCharacters(InformationBarPoppedUpOnce()
            && !DefeatBraigInformationDisplayed()
            && IsInLocation("Graveyard4") && IsAtLeastOnDifficulty("Proud") && level() <= 28, [ AquaArmoredHelmetless() ], true)
            && TriggerConditionsMetForCharacters({
                AquaArmoredHelmetless(): BossDefeatTriggered() // Venitas doesn't yield any rewards, of course, being a final boss.
            }, true)
        && never(!IsInLocation("Graveyard4"))
        && never(DefeatBraigInformationDisplayed())
        && AquaFinalSegmentSharedConditions()
        && never(CommandDeckSlotsFilledIsAtLeast(5))
)

function xehanortReport7() => bit4(0x1f2932c)
function AquaStoryCompleted() => WasBitflagSetInGame(xehanortReport7()) && ViewedBattleReportLongEnough() && currentCharacter() == AquaArmoredHelmetless()
achievement(title = "The Seeker", points = 10, id = 187125, badge = "208012",
    description = "Complete Aqua's story.",
    trigger = AquaStoryCompleted()
)

achievement(title = "Proud Mystic", points = 10, id = 187126, badge = "208013",
    description = "Complete Aqua's story on Proud Mode or higher.",
    trigger = AquaStoryCompleted() && IsAtLeastOnDifficulty("Proud")
)

achievement(title = "Critical Mystic", points = 25, id = 187127, badge = "208014",
    description = "Complete Aqua's story on Critical Mode.",
    trigger = AquaStoryCompleted() && IsAtLeastOnDifficulty("Critical")
)

equippableBattleCommands = GetCommandsByProperties({ "equippableBattleCommand": 1 })
nonIllusionEquippableBattleCommands = GetCommandsByCallback(command => command["equippableBattleCommand"] == 1 && command["id"] <= 0xdf)
achievement(title = "Prime Sacrifice [m]", points = 10, id = 187128, badge = "208015",
    description = "Defeat the first phase of the final boss of the Final Episode using any two of non-Illusion battle commands, D-Links, or Shotlocks, but not all three"
        + " (Proud Mode or higher, Level 29 or below).",
    trigger = CheckpointPassedForCharacters(InformationBarPoppedUpOnce()
            && IsInLocation("RadiantCentralDark") && IsAtLeastOnDifficulty("Proud") && level() <= 29, AquaOnly(), true)
            && TriggerConditionsMetForCharacters({
                Aqua(): BossDefeatTriggered()
            }, true)
        && never(!IsInLocation("RadiantCentralDark"))
        && never(tally(3, [ once(IsUsingDLink()), once(IsUsingAnyGivenCommand(shotlocks)), once(IsUsingAnyGivenCommand(nonIllusionEquippableBattleCommands)) ]))
)

dualLimitCommand = GetCommandsByProperties({ "name": "Dual Limit" })
achievement(title = "Lonely Duet [m]", points = 5, id = 187129, badge = "208016",
    description = "Finish off the second phase of the final boss of the Final Episode with Dual Limit (Proud Mode or higher, Level 29 or below).",
    trigger = CheckpointPassedForCharacters(InformationBarPoppedUpOnce()
            && IsInLocation("RadiantCentralTerranort") && IsAtLeastOnDifficulty("Proud") && level() <= 29, AquaOnly(), true)
            && TriggerConditionsMetForCharacters({
                Aqua(): (BossDefeatTriggered() && IsUsingAnyGivenCommand(dualLimitCommand))
            }, true)
        && never(!IsInLocation("RadiantCentralTerranort"))
)

function aquaMetHerFate() => bit3(0x1f285a5)
function FinalEpisodeCompleted() => WasBitflagSetInGame(aquaMetHerFate()) && ViewedBattleReportLongEnough() && currentCharacter() == Aqua()
achievement(title = "The Wanderer", points = 3, id = 187130, badge = "208017",
    description = "Complete the Final Episode.",
    trigger = FinalEpisodeCompleted()
)

achievement(title = "Proud Wanderer [m]", points = 5, id = 187131, badge = "208018",
    description = "Complete the Final Episode on Proud Mode or higher.",
    trigger = FinalEpisodeCompleted() && IsAtLeastOnDifficulty("Proud")
)

achievement(title = "Critical Wanderer [m]", points = 10, id = 187132, badge = "208019",
    description = "Complete the Final Episode on Critical Mode.",
    trigger = FinalEpisodeCompleted() && IsAtLeastOnDifficulty("Critical")
)

cartwheelCommand = GetCommandsByProperties({ "name": "Cartwheel" })
function DarkHideCheckpointReached() => CheckpointPassedForCharacters(InformationBarPoppedUpOnce()
    && IsInLocation("DarknessValley") && IsAtLeastOnDifficulty("Proud") && level() <= 33, AquaOnly(), true)
    
function DarkHideChallengeCompleted(resetOnDeath) => TriggerConditionsMetForCharacters({
        Aqua(): BossDefeatTriggered()
    }, true)
    
function DarkHideCancel() => !IsInLocation("DarknessValley") || GameOverTriggered()

function DarkHideScoreIncreased() => JustUsedAnyGivenCommand(cartwheelCommand)

function darkHideCartwheelLimit() => 155

// High score: 186
achievement(title = "Dance with Death [m]", points = 25, id = 187133, badge = "208020",
    description = "Defeat the Dark Hide without using the Cartwheel command more than " + darkHideCartwheelLimit() + " times (Proud Mode or higher, Level 33 or below).",
    trigger = DarkHideCheckpointReached()
        && DarkHideChallengeCompleted(true)
        && never(DarkHideCancel())
        && never(repeated(darkHideCartwheelLimit() + 1, DarkHideScoreIncreased()))
)

leaderboard(title = "Dance with Death", description = "Defeat the Dark Hide with as few Cartwheel commands as possible.",
    start = DarkHideCheckpointReached(),
    cancel = DarkHideCancel(),
    submit = DarkHideChallengeCompleted(false),
    value = measured(repeated(0, DarkHideScoreIncreased())),
    id = 27894
)

function darkHideDefeated() => bit2(0x1f284e5)
function SecretEpisodeCompleted() => WasBitflagSetInGame(darkHideDefeated()) && ViewedBattleReportLongEnough() && currentCharacter() == Aqua()
achievement(title = "The Wayfinder", points = 3, id = 187134, badge = "208021",
    description = "Complete the Secret Episode.",
    trigger = SecretEpisodeCompleted()
)

achievement(title = "Proud Wayfinder [m]", points = 5, id = 187135, badge = "208022",
    description = "Complete the Secret Episode on Proud Mode or higher.",
    trigger = SecretEpisodeCompleted() && IsAtLeastOnDifficulty("Proud")
)

achievement(title = "Critical Wayfinder [m]", points = 10, id = 187136, badge = "208023",
    description = "Complete the Secret Episode on Critical Mode.",
    trigger = SecretEpisodeCompleted() && IsAtLeastOnDifficulty("Critical")
)

achievement(title = "The Mark of Mastery [m]", points = 100, id = 187137, badge = "208024",
    description = "Complete any character's story at Level 1 on Critical Mode.",
    trigger = never(level() > 1) && IsAtLeastOnDifficulty("Critical")
        && (
        TerraStoryCompleted() || VentusStoryCompleted() || AquaStoryCompleted()
        )
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

function CreateRumbleRacingAchievementAndLeaderboard(achievementName, location, timeLimit, points, id = 0, badge = "00000")
{
    rumbleRacingCheckpointReached = RumbleRacingIntroWasJustPlaying() && RumbleRacingCountingDown() && IsInLocation(location["name"]) && rumbleRacingTotalLaps() == 5
    isInRaceLocation = AddressIsPointer(rumbleRacingPointerAddr()) && IsInLocation(location["name"])
    achievement(title = achievementName, points = points, id = id, badge = badge,
        description = "Finish a five-lap race on the " + location["display"] + " course in Rumble Racing in " + SecondsToFormat(timeLimit) + ".",
        trigger = once(rumbleRacingCheckpointReached)
            && trigger_when(RumbleRacingJustFinished())
            && RumbleRacingRecordableTimeElapsed() <= timeLimit * 100
            && never(!isInRaceLocation)
    )
    
    leaderboard(title = "Rumble Racing - " + location["display"] + " (5 Laps)", description = "Race to the finish!",
        start = once(rumbleRacingCheckpointReached) && never(!isInRaceLocation),
        cancel = !isInRaceLocation,
        submit = RumbleRacingJustFinished(),
        value = RumbleRacingRecordableTimeElapsed()
    )
}

CreateRumbleRacingAchievementAndLeaderboard("Country Thrills", GetLocationByName("DisneyCountryChase"), 125, 10, id = 187138, badge = "208025")

CreateRumbleRacingAchievementAndLeaderboard("Disney Town Dragster", GetLocationByName("DisneyDrive"), 246, 10, id = 187139, badge = "208026")

CreateRumbleRacingAchievementAndLeaderboard("Prix Spree", GetLocationByName("DisneySpree"), 294, 25, id = 187140, badge = "208027")

CreateRumbleRacingAchievementAndLeaderboard("Castle Crasher", GetLocationByName("DisneyCastle"), 236, 50, id = 187141, badge = "208028")

GenerateCheevoFromBits(name = "Sticker Warrior", description = "Collect every sticker in Terra's story.", points = 5,
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
        12: { "addr": 0x1f2929d, "bit": 4 },
        13: { "addr": 0x1f2929d, "bit": 5 },
        14: { "addr": 0x1f2929d, "bit": 6 },
        15: { "addr": 0x1f2929d, "bit": 7 },
        16: { "addr": 0x1f2929e, "bit": 0 },
        17: { "addr": 0x1f2929e, "bit": 1 },
        18: { "addr": 0x1f2929e, "bit": 2 },
        19: { "addr": 0x1f2929e, "bit": 3 },
        20: { "addr": 0x1f2929e, "bit": 4 },
    },
    onlyAvailableWhen = IsPlayingAsTerra()
)

GenerateCheevoFromBits(name = "Sticker Guardian", description = "Collect every sticker in Ventus's story.", points = 5,
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
        12: { "addr": 0x1f2929d, "bit": 4 },
        13: { "addr": 0x1f2929d, "bit": 5 },
        14: { "addr": 0x1f2929d, "bit": 6 },
        15: { "addr": 0x1f2929d, "bit": 7 },
        16: { "addr": 0x1f2929e, "bit": 0 },
        17: { "addr": 0x1f2929e, "bit": 1 },
        18: { "addr": 0x1f2929e, "bit": 2 },
        19: { "addr": 0x1f2929e, "bit": 3 },
        20: { "addr": 0x1f2929e, "bit": 4 },
    },
    onlyAvailableWhen = IsPlayingAsVentus()
)

GenerateCheevoFromBits(name = "Sticker Mystic", description = "Collect every sticker in Aqua's story.", points = 5,
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
        12: { "addr": 0x1f2929d, "bit": 4 },
        13: { "addr": 0x1f2929d, "bit": 5 },
        14: { "addr": 0x1f2929d, "bit": 6 },
        15: { "addr": 0x1f2929d, "bit": 7 },
        16: { "addr": 0x1f2929e, "bit": 0 },
        17: { "addr": 0x1f2929e, "bit": 1 },
        18: { "addr": 0x1f2929e, "bit": 2 },
        19: { "addr": 0x1f2929e, "bit": 3 },
        20: { "addr": 0x1f2929e, "bit": 4 },
    },
    onlyAvailableWhen = IsPlayingAsAqua()
)

function finishCommandWidth() => 8
function finishCommandArraySize() => 16

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
    trigger = UnlockedFinishCommand(0x5a) && IsPlayingAsTerra()
)

achievement(title = "Apex of Warding", points = 5,
    description = "Unlock Ventus's ultimate Finish command.",
    trigger = UnlockedFinishCommand(0x58) && IsPlayingAsVentus()
)

achievement(title = "Apex of Witchcraft", points = 5,
    description = "Unlock Aqua's ultimate Finish command.",
    trigger = UnlockedFinishCommand(0x59) && IsPlayingAsAqua()
)

function flameBoxMissionHighScoreTerra() => dword(0x1f35d38)
function flameBoxMissionHighScoreVen() => dword(0x1f35cb8)
function flameBoxMissionHighScoreAqua() => dword(0x1f35cf8)
function flameBoxMissionScoreTarget() => 65
achievement(title = "Orbital Defender", points = 10, id = 187148, badge = "208035",
    description = "Set a new high score of " + flameBoxMissionScoreTarget() + " or more in the Flame Box Unversed Mission.",
    trigger = CharacterSpecificHighScoreEarned(flameBoxMissionHighScoreTerra(), flameBoxMissionHighScoreVen(), flameBoxMissionHighScoreAqua(), flameBoxMissionScoreTarget())
)

function loneRunnerMissionHighScoreTerra() => dword(0x1f35d3c)
function loneRunnerMissionHighScoreVen() => dword(0x1f35cbc)
function loneRunnerMissionHighScoreAqua() => dword(0x1f35cfc)
function loneRunnerMissionScoreTarget() => 80
achievement(title = "Shoe Snatcher", points = 5, id = 187149, badge = "208036",
    description = "Set a new high score of " + loneRunnerMissionScoreTarget() + " or more in the Lone Runner Unversed Mission.",
    trigger = CharacterSpecificHighScoreEarned(loneRunnerMissionHighScoreTerra(), loneRunnerMissionHighScoreVen(), loneRunnerMissionHighScoreAqua(), loneRunnerMissionScoreTarget())
)

function vitalityVialMissionHighScoreTerra() => dword(0x1f35d44)
function vitalityVialMissionHighScoreVen() => dword(0x1f35cc4)
function vitalityVialMissionHighScoreAqua() => dword(0x1f35d04)
function vitalityVialMissionScoreTarget() => 180
achievement(title = "Iron Lung", points = 5, id = 187150, badge = "208037",
    description = "Set a new survival record of " + SecondsToFormat(vitalityVialMissionScoreTarget()) + " or longer in the Vitality Vial Unversed Mission.",
    trigger = CharacterSpecificHighScoreEarned(vitalityVialMissionHighScoreTerra(), vitalityVialMissionHighScoreVen(), vitalityVialMissionHighScoreAqua(),
        SecondsToFrames(vitalityVialMissionScoreTarget()))
)

function bellyBalloonMissionHighScoreTerra() => dword(0x1f35d30)
function bellyBalloonMissionHighScoreVen() => dword(0x1f35cb0)
function bellyBalloonMissionHighScoreAqua() => dword(0x1f35cf0)
function bellyBalloonMissionScoreTarget() => 15
achievement(title = "Wind Rusher", points = 5, id = 187151, badge = "208038",
    description = "Set a new record of " + SecondsToFormat(bellyBalloonMissionScoreTarget()) + " or faster in the Belly Balloon Unversed Mission.",
    trigger = CharacterSpecificHighScoreEarned(bellyBalloonMissionHighScoreTerra(), bellyBalloonMissionHighScoreVen(), bellyBalloonMissionHighScoreAqua(),
        SecondsToFrames(bellyBalloonMissionScoreTarget()), true)
)

function ringerMissionHighScoreTerra() => dword(0x1f35d48)
function ringerMissionHighScoreVen() => dword(0x1f35cc8)
function ringerMissionHighScoreAqua() => dword(0x1f35d08)
function ringerMissionScoreTarget() => 50
achievement(title = "Allegro con Grazia", points = 10, id = 187152, badge = "208039",
    description = "Set a new high score of " + ringerMissionScoreTarget() + " or more in the Ringer Unversed Mission.",
    trigger = CharacterSpecificHighScoreEarned(ringerMissionHighScoreTerra(), ringerMissionHighScoreVen(), ringerMissionHighScoreAqua(), ringerMissionScoreTarget())
)

function gluttonousGooMissionHighScoreTerra() => dword(0x1f35d4c)
function gluttonousGooMissionHighScoreVen() => dword(0x1f35ccc)
function gluttonousGooMissionHighScoreAqua() => dword(0x1f35d0c)
function gluttonousGooMissionScoreTarget() => 100
achievement(title = "Struggle Champion", points = 10, id = 187153, badge = "208040",
    description = "Set a new high score of " + gluttonousGooMissionScoreTarget() + " in the Gluttonous Goo Unversed Mission.",
    trigger = CharacterSpecificHighScoreEarned(gluttonousGooMissionHighScoreTerra(), gluttonousGooMissionHighScoreVen(), gluttonousGooMissionHighScoreAqua(), gluttonousGooMissionScoreTarget())
)

function elementClusterMissionHighScoreTerra() => dword(0x1f35d34)
function elementClusterMissionHighScoreVen() => dword(0x1f35cb4)
function elementClusterMissionHighScoreAqua() => dword(0x1f35cf4)
function elementClusterMissionScoreTarget() => 100
achievement(title = "Elemental Pulsar", points = 10, id = 187154, badge = "208041",
    description = "Set a new high score of " + elementClusterMissionScoreTarget() + " or more in the Element Cluster Unversed Mission.",
    trigger = CharacterSpecificHighScoreEarned(elementClusterMissionHighScoreTerra(), elementClusterMissionHighScoreVen(), elementClusterMissionHighScoreAqua(), elementClusterMissionScoreTarget())
)

function jellyshadeMissionHighScoreTerra() => dword(0x1f35d50)
function jellyshadeMissionHighScoreVen() => dword(0x1f35cd0)
function jellyshadeMissionHighScoreAqua() => dword(0x1f35d10)
function jellyshadeMissionScoreTarget() => 20
achievement(title = "Greater Fumigator", points = 5, id = 187155, badge = "208042",
    description = "Set a new record of " + SecondsToFormat(jellyshadeMissionScoreTarget()) + " or faster in the Jellyshade Unversed Mission.",
    trigger = CharacterSpecificHighScoreEarned(jellyshadeMissionHighScoreTerra(), jellyshadeMissionHighScoreVen(), jellyshadeMissionHighScoreAqua(),
        SecondsToFrames(jellyshadeMissionScoreTarget()), true)
)

function floatingFloraMissionHighScoreTerra() => dword(0x1f35d40)
function floatingFloraMissionHighScoreVen() => dword(0x1f35cc0)
function floatingFloraMissionHighScoreAqua() => dword(0x1f35d00)
function floatingFloraMissionScoreTarget() => 999
achievement(title = "Green Thumb", points = 3, id = 187156, badge = "208043",
    description = "Set a new record of " + floatingFloraMissionScoreTarget() + " in the Floating Flora Unversed Mission.",
    trigger = CharacterSpecificHighScoreEarned(floatingFloraMissionHighScoreTerra(), floatingFloraMissionHighScoreVen(), floatingFloraMissionHighScoreAqua(), floatingFloraMissionScoreTarget())
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

GenerateCheevoFromBits(name = "Command Street", description = "Complete all Command Board Arena Missions for any character.", points = 5,
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

dayOfReckoningForbiddenHealingCommands = GetCommandsByCallback(command => command["healsHp"] == 1 && command["name"] != "Cure")
cureCommand = GetCommandsByProperties({ "name": "Cure" })
cureLimit = 3

function MirageArenaCheckpointPassedCallback(eventId, locationName, difficulty, level) => once(HostingArenaEvent() && mirageArenaEvent() == eventId && IsInLocation(locationName)
    && IsAtLeastOnDifficulty(difficulty) && level() <= level)

function MirageArenaCheckpointReachedForCharacters(eventId, locationName, characters, numberOfRounds, difficulty, level)
{
    return CheckpointPassedForCharacters(MirageArenaCheckpointPassedCallback(eventId, locationName, difficulty, level), characters, false)
        && never(!WasInLocation(locationName) && IsInLocation("MirageHub"))
        && trigger_when(mirageArenaRoundsCompleted() == numberOfRounds && Delta(mirageArenaRoundsCompleted()) != mirageArenaRoundsCompleted())
}

function TerraNeverUsedAnyGivenCommandInArenaGivenNumberOfTimes(command, commandLimit)
{
    return never(repeated(commandLimit, TerraJustUsedAnyGivenCommandInArena(command)) && currentCharacter() == TerraArmored())
}

function VentusNeverUsedAnyGivenCommandInArenaGivenNumberOfTimes(command, commandLimit)
{
    return never(repeated(commandLimit, VentusJustUsedAnyGivenCommandInArena(command)) && currentCharacter() == VentusArmored())
}

function AquaNeverUsedAnyGivenCommandInArenaGivenNumberOfTimes(command, commandLimit)
{
    return never(repeated(commandLimit, AquaJustUsedAnyGivenCommandInArena(command)) && currentCharacter() == AquaArmored())
}

function NeverUsedAnyGivenCommandInArenaGivenNumberOfTimes(command, commandLimit)
{
    return TerraNeverUsedAnyGivenCommandInArenaGivenNumberOfTimes(command, commandLimit)
        && VentusNeverUsedAnyGivenCommandInArenaGivenNumberOfTimes(command, commandLimit)
        && AquaNeverUsedAnyGivenCommandInArenaGivenNumberOfTimes(command, commandLimit)
}

function NeverJustUsedAnyGivenCommandInArena(haystack)
{
    return never(TerraJustUsedAnyGivenCommandInArena(haystack) && currentCharacter() == TerraArmored())
        && never(VentusJustUsedAnyGivenCommandInArena(haystack) && currentCharacter() == VentusArmored())
        && never(AquaJustUsedAnyGivenCommandInArena(haystack) && currentCharacter() == AquaArmored())
}

achievement(title = "Prison Rations [m]", points = 10, id = 187161, badge = "208048",
    description = "Complete \"Day of Reckoning\" in the Mirage Arena using Cure as your only healing command no more than thrice (Critical Mode, Level 12 or below).",
    trigger = MirageArenaCheckpointReachedForCharacters(1, "MirageArena1", AnyArmoredCharacter(), 4, difficulty = "Critical", level = 12)
        && NeverJustUsedAnyGivenCommandInArena(dayOfReckoningForbiddenHealingCommands)
        && NeverUsedAnyGivenCommandInArenaGivenNumberOfTimes(cureCommand, cureLimit + 1)
)

function HasDuplicateCommandInDeckOfSize(haystack, deckId, deckSize = 8)
{
    trigger = always_false()
    
    for commandToCheckForDuplicate in haystack
    {
        commandChecks = []
        
        for i in range(0, deckSize)
        {
            inventoryCommandId = GetInventoryCommandId(deckId - 1, i)
            
            array_push(commandChecks, once(inventoryCommandId == commandToCheckForDuplicate["id"]))
        }
        
        trigger = trigger || tally(2 * commandToCheckForDuplicate["slots"], commandChecks)
    }
    
    return trigger
}

function DeckLoadoutChanged()
{
    trigger = always_false()
    
    for deck in range(0, 2)
    {
        for i in range(0, maxNumberOfCommandSlots() - 1)
        {
            inventoryIndex = GetInventoryIndex(deck, i)
            trigger = trigger || Delta(inventoryIndex) != inventoryIndex
        }
    }
    
    return trigger
}

// todo: it would be nice if we could get NeverUsedAnyGivenCommandInArenaGivenNumberOfTimes() to work with more than one command at a time so that way we can get "Equivalent Exchange"
// to work
megaFlareLimit = 3
directHealingCommands = GetCommandsByProperties({ "healsHp": 1 })
megaFlareCommand = GetCommandsByProperties({ "name": "Mega Flare" })
achievement(title = "Nuclear Disarmament [m]", points = 5, id = 187162, badge = "208049",
    description = "Complete \"Wheels of Misfortune\" in the Mirage Arena using Mega Flare only three times or fewer and with a max of "
        + "six battle command slots filled (Critical Mode, Level 12 or below).",
    trigger = MirageArenaCheckpointReachedForCharacters(0x101, "MirageForest", AnyArmoredCharacter(), 4, difficulty = "Critical", level = 12)
        && NeverUsedAnyGivenCommandInArenaGivenNumberOfTimes(megaFlareCommand, megaFlareLimit + 1)
)

equippableBattleCommands = GetCommandsByProperties({ "equippableBattleCommand": 1 })
achievement(title = "Rainbow Loom [m]", points = 5, id = 187163, badge = "208050",
    description = "Complete \"Weaver Fever\" in the Mirage Arena without any duplicate commands equipped (Critical Mode, Level 16 or below, Deck 1 only).",
    trigger = never(HasDuplicateCommandInDeckOfSize(equippableBattleCommands, 1, 8))
        && never(DeckLoadoutChanged()) && CurrentDeckIs(1)
        && MirageArenaCheckpointReachedForCharacters(0x301, "MirageChamber", AnyArmoredCharacter(), 4, difficulty = "Critical", level = 16)
)

achievement(title = "Weapon Confiscation [m]", points = 5, id = 187164, badge = "208051",
    description = "Complete \"Sinister Sentinel\" in the Mirage Arena with only three battle command slots filled and without using Shotlocks (Critical Mode, Level 23 or below).",
    trigger = NeverJustUsedAnyGivenCommandInArena(shotlocks)
        && MirageArenaCheckpointReachedForCharacters(0x401, "MirageArena1", AnyArmoredCharacter(), 5, difficulty = "Critical", level = 23)
        && never(CommandDeckSlotsFilledIsAtLeast(4))
)

function NeverUsedAnyUniqueCommandsGivenNumberOfTimesInArena(haystack, limit)
{
    return never(TerraUsedAnyUniqueCommandsGivenNumberOfTimesInArena(haystack, limit))
        && never(VentusUsedAnyUniqueCommandsGivenNumberOfTimesInArena(haystack, limit))
        && never(AquaUsedAnyUniqueCommandsGivenNumberOfTimesInArena(haystack, limit))
}

surgeBattleCommands = GetCommandsByCallback(command => command["name"] == "Fire Surge" || command["name"] == "Thunder Surge" || command["name"] == "Barrier Surge")
achievement(title = "Minor Duplication [m]", points = 5, id = 187165, badge = "208052",
    description = "Complete \"Dead Ringer\" in the Mirage Arena using only two kinds of non-Surge battle commands (Critical Mode, Level 25 or below).",
    trigger = MirageArenaCheckpointReachedForCharacters(0x501, "MirageDeck", AnyArmoredCharacter(), 5, difficulty = "Critical", level = 25)
        && NeverUsedAnyUniqueCommandsGivenNumberOfTimesInArena(battleCommands, 3)
        && NeverJustUsedAnyGivenCommandInArena(surgeBattleCommands)
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

achievement(title = "Combined Boon [m]", points = 10, id = 187166, badge = "208053",
    description = "Complete \"Combined Threat\" in the Mirage Arena with only two beneficial Stat and Support Abilities each turned on (Critical Mode, Level 29 or below).",
    trigger = MirageArenaCheckpointReachedForCharacters(0x601, "MirageExterior", AnyArmoredCharacter(), 6, difficulty = "Critical", level = 29)
        && never(NumberOfStatAbilitiesEquipped(3))
        && never(NumberOfBeneficialSupportAbilitiesEquippedGreaterThanOrEqualTo(3))
)

battleCommandsThatUseMoreThanOneSlot = GetCommandsByCallback(command => command["slots"] > 1)
achievement(title = "Healthcare Budgeting [m]", points = 5, id = 187167, badge = "208054",
    description = "Complete \"Risky Riches\" in the Mirage Arena using only commands that take up a single slot and without taking damage more than three times (Critical Mode, Level 20 or below).",
    trigger = MirageArenaCheckpointReachedForCharacters(0x201, "MirageSkull", AnyArmoredCharacter(), 3, difficulty = "Critical", level = 20)
        && never(repeated(4, TookDamageInTheMirageArena()))
        && NeverJustUsedAnyGivenCommandInArena(battleCommandsThatUseMoreThanOneSlot)
)

achievement(title = "Escalation of Force [m]", points = 10, id = 187168, badge = "208055",
    description = "Complete \"Harsh Punishment\" in the Mirage Arena with only five battle command slots filled (Critical Mode, Level 32 or below).",
    trigger = MirageArenaCheckpointReachedForCharacters(0x801, "MirageArena1", AnyArmoredCharacter(), 6, difficulty = "Critical", level = 32)
        && never(CommandDeckSlotsFilledIsAtLeast(6))
)

function MonstroMirageArenaCheckpointReachedForCharacters()
{
    return CheckpointPassedForCharacters(MirageArenaCheckpointPassedCallback(0xc01, "MirageMonstro", difficulty = "Critical", level = 35), AnyArmoredCharacter(), false)
        && never(!WasInLocation("MirageMonstro") && IsInLocation("MirageHub"))
        && mirageArenaCurrentRound() < 5
        && trigger_when(MonstroDefeatTriggered())
}

function MonstroDefeatTriggered() => IsInBattle() && bit3(battleFlagsAddr()) == 1 && arenaHp() > 0 && characterArenaPointer() != 0
achievement(title = "The Madness of Man [m]", points = 25, id = 187169, badge = "208056",
    description = "Complete \"The Monster of the Sea\" in the Mirage Arena in four rounds or fewer (Critical Mode, Level 35 or below).",
    trigger = MonstroMirageArenaCheckpointReachedForCharacters()
)

achievement(title = "Scrounging to Survive [m]", points = 10, id = 187170, badge = "208057",
    description = "Complete \"Treasure Tussle\" in the Mirage Arena without using commands that directly heal you (Critical Mode, Level 24 or below).",
    trigger = MirageArenaCheckpointReachedForCharacters(0x701, "MiragePinball", AnyArmoredCharacter(), 3, difficulty = "Critical", level = 24)
        && NeverJustUsedAnyGivenCommandInArena(directHealingCommands)
)

achievement(title = "Rolling Blackout [m]", points = 25, id = 187171, badge = "208058",
    description = "Complete \"Copycat Crisis\" in the Mirage Arena using battle commands only on even-numbered rounds (Critical Mode, Level 45 or below).",
    trigger = MirageArenaCheckpointReachedForCharacters(0xa01, "MirageSummit", AnyArmoredCharacter(), 8, difficulty = "Critical", level = 45)
        // We need to check oddness for each round individually because (1) the modulo operator isn't supported in the editor and (2) the logic would be too complex otherwise.
        && never(TerraJustUsedAnyGivenCommandInArena(battleCommands) && mirageArenaCurrentRound() == 1 && currentCharacter() == TerraArmored())
        && never(TerraJustUsedAnyGivenCommandInArena(battleCommands) && mirageArenaCurrentRound() == 3 && currentCharacter() == TerraArmored())
        && never(TerraJustUsedAnyGivenCommandInArena(battleCommands) && mirageArenaCurrentRound() == 5 && currentCharacter() == TerraArmored())
        && never(TerraJustUsedAnyGivenCommandInArena(battleCommands) && mirageArenaCurrentRound() == 7 && currentCharacter() == TerraArmored())
        
        && never(VentusJustUsedAnyGivenCommandInArena(battleCommands) && mirageArenaCurrentRound() == 1 && currentCharacter() == VentusArmored())
        && never(VentusJustUsedAnyGivenCommandInArena(battleCommands) && mirageArenaCurrentRound() == 3 && currentCharacter() == VentusArmored())
        && never(VentusJustUsedAnyGivenCommandInArena(battleCommands) && mirageArenaCurrentRound() == 5 && currentCharacter() == VentusArmored())
        && never(VentusJustUsedAnyGivenCommandInArena(battleCommands) && mirageArenaCurrentRound() == 7 && currentCharacter() == VentusArmored())
        
        && never(AquaJustUsedAnyGivenCommandInArena(battleCommands) && mirageArenaCurrentRound() == 1 && currentCharacter() == AquaArmored())
        && never(AquaJustUsedAnyGivenCommandInArena(battleCommands) && mirageArenaCurrentRound() == 3 && currentCharacter() == AquaArmored())
        && never(AquaJustUsedAnyGivenCommandInArena(battleCommands) && mirageArenaCurrentRound() == 5 && currentCharacter() == AquaArmored())
        && never(AquaJustUsedAnyGivenCommandInArena(battleCommands) && mirageArenaCurrentRound() == 7 && currentCharacter() == AquaArmored())
)

// Happy Advanceshipping Day 2021!
nonFireBattleCommandsAndShotlocks = GetCommandsByCallback(command => (command["equippableBattleCommand"] == 1 || command["supercategory"] == "Shotlock") && command["element"] != "Fire")
nonFireOrCureBattleCommandsAndShotlocks = GetCommandsByCallback(command => (command["equippableBattleCommand"] == 1 || command["supercategory"] == "Shotlock") && command["element"] != "Fire"
    && command["name"] != "Cure" && command["name"] != "Cura" && command["name"] != "Curaga")
achievement(title = "Ribbon of Terracotta [m]", points = 10, id = 187172, badge = "208059",
    description = "As Terra, complete \"A Time to Chill\" in the Mirage Arena using only fire-based battle commands and Shotlocks, "
        + "with Cure commands permissible only in Round 4 (Proud Mode or higher, Level 45 or below).",
    trigger = MirageArenaCheckpointReachedForCharacters(0x901, "MirageColiseum", [ TerraArmored() ], 8, difficulty = "Proud", level = 45)
        && never(TerraJustUsedAnyGivenCommandInArena(nonFireBattleCommandsAndShotlocks) && mirageArenaCurrentRound() != 4)
        && never(TerraJustUsedAnyGivenCommandInArena(nonFireOrCureBattleCommandsAndShotlocks) && mirageArenaCurrentRound() == 4)
)

function timesCritialImpactWasActivated() => word(0x1f35ebc)
function timesSpellweaverWasActivated() => word(0x1f35ebe)
function timesFeverPitchWasActivated() => word(0x1f35ec0)
function timesFirestormWasActivated() => word(0x1f35ec2)
function timesDiamondDustWasActivated() => word(0x1f35ec4)
function timesThunderboltWasActivated() => word(0x1f35ec6)
function timesCycloneWasActivated() => word(0x1f35ec8)
function timesBladechargeWasActivated() => word(0x1f35eca)
function timesSkyClimberWasActivated() => word(0x1f35ecc)
function timesRockbreakerWasActivated() => word(0x1f35ece)
function timesGhostDriveWasActivated() => word(0x1f35ed0)
function timesRhythmMixerWasActivated() => word(0x1f35ed2)
function timesDarkImpulseWasActivated() => word(0x1f35ed4)
function timesWingbladeWasActivated() => word(0x1f35ed6)
function timesFrozenFortuneWasActivated() => word(0x1f35ed8)

function GivenCommandStyleWasActivated(activatedMem)
{
    return activatedMem == Delta(activatedMem) + 1
}

achievement(title = "The Spice of Life [m]", points = 50, id = 187173, badge = "208060",
    description = "Activate seven different Command Styles in a single attempt of the \"Keepers of the Arena\" event in the Mirage Arena, and then complete it (Critical Mode, Level 48 or below).",
    trigger = MirageArenaCheckpointReachedForCharacters(0xb01, "MirageArena1", AnyArmoredCharacter(), 9, difficulty = "Critical", level = 48)
        && trigger_when(tally(7, [
            once(GivenCommandStyleWasActivated(timesCritialImpactWasActivated())),
            once(GivenCommandStyleWasActivated(timesSpellweaverWasActivated())),
            once(GivenCommandStyleWasActivated(timesFeverPitchWasActivated())),
            once(GivenCommandStyleWasActivated(timesFirestormWasActivated())),
            once(GivenCommandStyleWasActivated(timesDiamondDustWasActivated())),
            once(GivenCommandStyleWasActivated(timesThunderboltWasActivated())),
            once(GivenCommandStyleWasActivated(timesCycloneWasActivated())),
            once(GivenCommandStyleWasActivated(timesBladechargeWasActivated())),
            once(GivenCommandStyleWasActivated(timesSkyClimberWasActivated())),
            once(GivenCommandStyleWasActivated(timesRockbreakerWasActivated())),
            once(GivenCommandStyleWasActivated(timesGhostDriveWasActivated())),
            once(GivenCommandStyleWasActivated(timesRhythmMixerWasActivated())),
            once(GivenCommandStyleWasActivated(timesDarkImpulseWasActivated())),
            once(GivenCommandStyleWasActivated(timesWingbladeWasActivated())),
            once(GivenCommandStyleWasActivated(timesFrozenFortuneWasActivated())),
        ]))
)

achievement(title = "Style Specialist [m]", points = 50, id = 187174, badge = "208061",
    description = "Complete \"Villains' Vendetta\" in the Mirage Arena while activating at most one type of Command Style (Critical Mode, Level 53 or below).",
    trigger = MirageArenaCheckpointReachedForCharacters(0xd01, "MirageArena1", AnyArmoredCharacter(), 8, difficulty = "Critical", level = 53)
        && never(tally(2, [
            once(GivenCommandStyleWasActivated(timesCritialImpactWasActivated())),
            once(GivenCommandStyleWasActivated(timesSpellweaverWasActivated())),
            once(GivenCommandStyleWasActivated(timesFeverPitchWasActivated())),
            once(GivenCommandStyleWasActivated(timesFirestormWasActivated())),
            once(GivenCommandStyleWasActivated(timesDiamondDustWasActivated())),
            once(GivenCommandStyleWasActivated(timesThunderboltWasActivated())),
            once(GivenCommandStyleWasActivated(timesCycloneWasActivated())),
            once(GivenCommandStyleWasActivated(timesBladechargeWasActivated())),
            once(GivenCommandStyleWasActivated(timesSkyClimberWasActivated())),
            once(GivenCommandStyleWasActivated(timesRockbreakerWasActivated())),
            once(GivenCommandStyleWasActivated(timesGhostDriveWasActivated())),
            once(GivenCommandStyleWasActivated(timesRhythmMixerWasActivated())),
            once(GivenCommandStyleWasActivated(timesDarkImpulseWasActivated())),
            once(GivenCommandStyleWasActivated(timesWingbladeWasActivated())),
            once(GivenCommandStyleWasActivated(timesFrozenFortuneWasActivated())),
        ]))
)

shotlockCommands = GetCommandsByProperties({ "supercategory": "Shotlock" })
achievement(title = "Clash of Blades", points = 50, id = 187175, badge = "208062",
    description = "Defeat the Armor of Eraqus without using Shotlocks (Critical Mode only).",
    trigger = MirageArenaCheckpointReachedForCharacters(0xe01, "MirageSummit2", AnyArmoredCharacter(), 1, difficulty = "Critical", level = 99)
        && NeverJustUsedAnyGivenCommandInArena(shotlockCommands)
)

function damageSyphonAddr() => 0x1f2acb8
commandsThatExplicitlyAffectFocus = GetCommandsByCallback(command => command["name"] == "Focus Block" || command["name"] == "Focus Barrier" || command["name"] == "Ether"
    || command["name"] == "Mega-Ether" || command["name"] == "Elixir" || command["name"] == "Megalixir")
achievement(title = "Unparalleled Focus", points = 50, id = 187176, badge = "208063",
    description = "Defeat No Heart without using battle commands or abilities that explicitly refill the Focus Gauge (Critical Mode only).",
    trigger = MirageArenaCheckpointReachedForCharacters(0xf01, "MirageGreatHall", AnyArmoredCharacter(), 2, difficulty = "Critical", level = 99)
        && never(IsAbilityTurnedOn(damageSyphonAddr()))
        && NeverJustUsedAnyGivenCommandInArena(commandsThatExplicitlyAffectFocus)
)

healingGuardCommands = GetCommandsByCallback(command => command["name"] == "Renewal Block" || command["name"] == "Renewal Barrier")
achievement(title = "Conservation of Life", points = 50,
    description = "Defeat the Vanitas Remnant without using Renewal Block or Renewal Barrier (Proud Mode or higher).",
    trigger = CheckpointPassedForCharacters(InformationBarPoppedUpOnce()
            && IsInLocation("GraveyardBadlands2") && IsAtLeastOnDifficulty("Proud"), [ Terra(), Ventus(), Aqua() ], true)
            && TriggerConditionsMetForCharacters({
                Terra(): BossDefeatTriggered(),
                Ventus(): BossDefeatTriggered(),
                Aqua(): BossDefeatTriggered()
            }, true)
        && never(!IsInLocation("GraveyardBadlands2"))
        && never(IsUsingAnyGivenCommand(healingGuardCommands))
)

achievement(title = "Portent of Pain", points = 50,
    description = "Defeat the Unknown on Proud Mode or higher.",
    trigger = CheckpointPassedForCharacters(IsWaitingForBattleToBegin()
            && IsInLocation("DepartureSummitRuins2") && IsAtLeastOnDifficulty("Proud"), [ Terra(), Ventus(), Aqua() ], true)
            && TriggerConditionsMetForCharacters({
                Terra(): BossDefeatTriggered(),
                Ventus(): BossDefeatTriggered(),
                Aqua(): BossDefeatTriggered()
            }, true)
        && never(!IsInLocation("DepartureSummitRuins2"))
)

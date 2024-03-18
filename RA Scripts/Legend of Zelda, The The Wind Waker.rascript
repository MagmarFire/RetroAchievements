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
// resetWhen: a condition that, when true, will reset the entire achievement, including pauselocks
// onlyAvailableWhen: a condition that must be true in all conditions for the achievement to trigger
// id: self-explanatory
// badge: self-explanatory
// type: self-explanatory
// oneAtATime: indicates that bits will only ever get flipped one at a time, meaning the achievement will check one below the threshold before triggering
function GenerateCheevoFromBits(name, description, points, addresses, threshold = 0, onlyAvailableWhen = always_true(), resetWhen = always_false(), id = 0, badge = "00000", type = "",
    oneAtATime = false)
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
        trigger = measured(bitcounts >= threshold) && Delta(bitcounts) == threshold - 1
    }
    else
    {
        // This is the score when the game is loaded. If the loaded score is greater than or equal to the threshold--that is,
        // if the save file would satisfy enough conditions to trigger the achievement on load--this should trigger a
        // permanant pauselock to serve as save protection.
        shouldTriggerPauselock = once(bitcounts >= threshold && IsOnTitleScreen())
        trigger = measured(bitcounts >= threshold)
    }    

    achievement(title = name, description = description, points = points, badge = badge, id = id,
        trigger = FileIsLoaded() && trigger && unless(shouldTriggerPauselock) && onlyAvailableWhen
            && (resetWhen || never(IsOnTitleScreen())) // Reset any potential pauselock when exiting to the title screen.
    )
}
// /utility

superareas = {
    2: { "id":2, "internalName":"sea", "displayName":"The Great Sea", "addrOverride": 0x00ab78c9},3: { "id":3, "internalName":"majroom", "displayName":"Forsaken Fortress", "addrOverride": 0},4: { "id":4, "internalName":"M_NewD2", "displayName":"Dragon Roost Cavern", "addrOverride": 0},
}

areas = {
859204975: { "name": "Forest of Fairies", "internalName": "A_mori", "roomId": 0, "key": "", "isStatic": 0 },660955507: { "name": "Title Screen", "internalName": "sea_T", "roomId": 44, "key": "", "isStatic": 1 },1315007817: { "name": "File Select", "internalName": "Name", "roomId": 44, "key": "", "isStatic": 1 },1315007845: { "name": "File Select", "internalName": "Name", "roomId": 0, "key": "", "isStatic": 1 },1936023852: { "name": "Outset Island", "internalName": "sea", "roomId": 44, "key": "", "isStatic": 0 },974743663: { "name": "Orca and Sturgeon's House (1F)", "internalName": "Ojhous", "roomId": 0, "key": "", "isStatic": 0 },974740078: { "name": "Orca and Sturgeon's House (2F)", "internalName": "Ojhous2", "roomId": 1, "key": "", "isStatic": 0 },771907955: { "name": "Mesa's House", "internalName": "Omasao", "roomId": 0, "key": "", "isStatic": 0 },974786146: { "name": "Abe and Rose's House", "internalName": "Onobuta", "roomId": 0, "key": "", "isStatic": 0 },505704043: { "name": "Link's House", "internalName": "LinkRM", "roomId": 0, "key": "", "isStatic": 0 },538080106: { "name": "Beedle's Shop Ship", "internalName": "Obshop", "roomId": 2, "key": "", "isStatic": 0 },674500461: { "name": "Tetra's Ship, On Deck", "internalName": "A_umikz", "roomId": 0, "key": "", "isStatic": 0 },779317099: { "name": "Tetra's Ship, Below Deck", "internalName": "Asoko", "roomId": 0, "key": "", "isStatic": 0 },941910649: { "name": "Forsaken Fortress", "internalName": "MajyuE", "roomId": 0, "key": "ForsakenFortressBailey", "isStatic": 0 },34473840: { "name": "Gallery", "internalName": "majroom", "roomId": 2, "key": "ForsakenFortressGallery", "isStatic": 0 },34473842: { "name": "Prison", "internalName": "majroom", "roomId": 0, "key": "ForsakenFortressPrison", "isStatic": 0 },34473846: { "name": "Barracks", "internalName": "majroom", "roomId": 4, "key": "ForsakenFortressBarracks", "isStatic": 0 },34473841: { "name": "Docks", "internalName": "majroom", "roomId": 3, "key": "ForsakenFortressDocks", "isStatic": 0 },34473843: { "name": "Dining Area", "internalName": "majroom", "roomId": 1, "key": "ForsakenFortressDining", "isStatic": 0 },974063215: { "name": "Forsaken Fortress: Tower", "internalName": "Mjtower", "roomId": 0, "key": "ForsakenFortressTower", "isStatic": 0 },1936023819: { "name": "Windfall Island", "internalName": "sea", "roomId": 11, "key": "", "isStatic": 0 },588018279: { "name": "Chu Jelly Juice Shop", "internalName": "Pdrgsh", "roomId": 0, "key": "", "isStatic": 0 },656042339: { "name": "House of Wealth", "internalName": "Orichh", "roomId": 0, "key": "", "isStatic": 0 },1332770146: { "name": "Cafe", "internalName": "Opub", "roomId": 0, "key": "", "isStatic": 0 },1023569253: { "name": "Lenzo's Studio", "internalName": "Ocmera", "roomId": 0, "key": "", "isStatic": 0 },923140457: { "name": "Joy School", "internalName": "Nitiyou", "roomId": 0, "key": "", "isStatic": 0 },772761971: { "name": "Game Room", "internalName": "Kaisen", "roomId": 0, "key": "", "isStatic": 0 },620956794: { "name": "Windfall Island Jail", "internalName": "Pnezumi", "roomId": 0, "key": "", "isStatic": 0 },755658605: { "name": "Bomb Shop", "internalName": "Obombh", "roomId": 0, "key": "", "isStatic": 0 },672007282: { "name": "Mail Center", "internalName": "Atorizk", "roomId": 0, "key": "", "isStatic": 0 },738526318: { "name": "Dragon Roost Cavern Entrance", "internalName": "Adanmae", "roomId": 0, "key": "", "isStatic": 0 },974879845: { "name": "1F", "internalName": "M_NewD2", "roomId": 0, "key": "CavernEntrance", "isStatic": 0 },1936023820: { "name": "Pawprint Isle", "internalName": "sea", "roomId": 12, "key": "", "isStatic": 0 },1936023821: { "name": "Dragon Roost Island", "internalName": "sea", "roomId": 13, "key": "", "isStatic": 0 },538080104: { "name": "Beedle's Shop Ship", "internalName": "Obshop", "roomId": 0, "key": "", "isStatic": 0 },974879847: { "name": "Main", "internalName": "M_NewD2", "roomId": 2, "key": "CavernMain", "isStatic": 0 },974879848: { "name": "1F", "internalName": "M_NewD2", "roomId": 13, "key": "CavernPots", "isStatic": 0 },974879844: { "name": "1F", "internalName": "M_NewD2", "roomId": 1, "key": "CavernBarricades", "isStatic": 0 },974879854: { "name": "1F", "internalName": "M_NewD2", "roomId": 11, "key": "CavernSwingBarricades", "isStatic": 0 },974879846: { "name": "Outside", "internalName": "M_NewD2", "roomId": 3, "key": "CavernOutside", "isStatic": 0 },974879851: { "name": "Block Climb", "internalName": "M_NewD2", "roomId": 14, "key": "CavernBlockClimb", "isStatic": 0 },974879841: { "name": "2F", "internalName": "M_NewD2", "roomId": 4, "key": "CavernDark", "isStatic": 0 },974879843: { "name": "2F", "internalName": "M_NewD2", "roomId": 6, "key": "CavernTreasureChart", "isStatic": 0 },974879853: { "name": "Geyser", "internalName": "M_NewD2", "roomId": 8, "key": "CavernGeyser", "isStatic": 0 },974879855: { "name": "3F", "internalName": "M_NewD2", "roomId": 10, "key": "CavernBossDoor", "isStatic": 0 },745504123: { "name": "Dragon Roost Cavern: 4F", "internalName": "M_Dra09", "roomId": 9, "key": "", "isStatic": 0 },974879842: { "name": "3F", "internalName": "M_NewD2", "roomId": 7, "key": "CavernBridge", "isStatic": 0 },974879850: { "name": "1F", "internalName": "M_NewD2", "roomId": 15, "key": "CavernTingleStatue", "isStatic": 0 },974879849: { "name": "1F", "internalName": "M_NewD2", "roomId": 12, "key": "CavernFireChest", "isStatic": 0 },741869170: { "name": "Dragon Roost Cavern: 3F", "internalName": "M_DragB", "roomId": 0, "key": "CavernBoss", "isStatic": 0 },1936023808: { "name": "Dragon Roost Island", "internalName": "sea", "roomId": 0, "key": "DragonRoostIslandCutscene", "isStatic": 0 },1648779056: { "name": "Mysterious Labyrinth", "internalName": "TF_06", "roomId": 0, "key": "", "isStatic": 0 },1936023828: { "name": "Fire Mountain", "internalName": "sea", "roomId": 20, "key": "", "isStatic": 0 },1936023835: { "name": "Eastern Triangle Island", "internalName": "sea", "roomId": 27, "key": "", "isStatic": 0 },1936023842: { "name": "Bomb Island", "internalName": "sea", "roomId": 34, "key": "", "isStatic": 0 },672297832: { "name": "Inside a submarine...", "internalName": "Abship", "roomId": 0, "key": "", "isStatic": 0 },1936023849: { "name": "Forest Haven", "internalName": "sea", "roomId": 41, "key": "", "isStatic": 0 },644706162: { "name": "Inside the Forest Haven", "internalName": "Omori", "roomId": 0, "key": "", "isStatic": 0 },
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
function mapNamePart1() => dword_be(0x003d1664)
function mapNamePart2() => dword_be(0x003d1668)
function roomPointer() => dword_be(0x003d21f4) & 0x7FFFFFFF
function roomId() => byte(roomPointer() + 0x66d)
function staticRoomId() => byte(0x003cccd8)

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
    return ascii_string_equals(mapNameAddr(), area["internalName"])
}

function IsInAreaByInternalName(name)
{
    area = GetAreaByInternalName(name)
    return ascii_string_equals(mapNameAddr(), area["internalName"])
}

function IsInAreaByHash(hash)
{
    return hash == GetAreaHash()
}

function IsOnTitleScreen() => IsInArea("Title Screen")
internalNamesAddedToRP = []

function maxLifeEnergy() => word_be(0x003cc530)
function Hearts() => maxLifeEnergy() / 4

for hash in areas
{
    area = GetAreaByHash(hash)
    superarea = GetSuperareaByName(area["internalName"])
    lookupForArea = lookups[GetLookupKey(area["internalName"])]
    display = ""
    roomIdToUse = roomId()
    
    if (area["isStatic"] == 1)
    {
        roomIdToUse = staticRoomId()
    }

    if (DoesSuperareaExist(area["internalName"]))
    {
        display = superarea["displayName"] + ": "
    }

    if (!any_of(internalNamesAddedToRP, input => input == area["internalName"]))
    {
        rich_presence_conditional_display(IsInArea(area["name"]), display + "{0} | {1} ❤️",
            rich_presence_lookup(GetLookupKey(area["internalName"]), roomIdToUse, lookupForArea),
            rich_presence_value("Hearts", Hearts())
        )
        array_push(internalNamesAddedToRP, area["internalName"])
    }
}

rich_presence_conditional_display(IsOnTitleScreen(), "On the title screen...")
rich_presence_display("Somewhere on the Great Sea...")

function outsetIslandCutscenePlayed() => bit4(0x003ccb89)
function IsLoadingSaveFile() => IsValueSet(outsetIslandCutscenePlayed(), 0, 1)
function FileIsLoaded() => Delta(outsetIslandCutscenePlayed()) == 1

function SecondsToFormat(value)
{
    leadingZero = ""
    if (value % 60 < 10)
    {
        leadingZero = "0"
    }
    return value / 60 + ":" + leadingZero + value % 60
}

// $3ffc3c: (32-bit BE) System timer. Increments by one every frame.
function framesCounter() => dword_be(0x3ffc3c)

function frameIncremented() => prev(framesCounter()) != framesCounter()

function SecondsToFrames(seconds) => seconds * 60 // Assuming a 60 FPS framerate (yes, apparently, this game assumes 60FPS on PAL, too)

function stageId() => byte(0x003ccccc)
function layerId() => byte(0x003ccd24)
function swordActionPointer() => dword_be(0x003c1060)
function swordAnimationId() => byte(swordActionPointer() + 0x1b8 + 0x80000000)
function swordSwingState() => byte(swordActionPointer() + 0x1cf + 0x80000000)
function AreaJustChanged() => swordActionPointer() != Delta(swordActionPointer()) && Delta(swordActionPointer()) == 0

function dialoguePointer() => dword_be(0x003c21b8)
function messageId() => word_be(dialoguePointer() + 0x40 + 0x80000000)
function DisplayingMessageWithId(id) => messageId() == id

function baitBagSlot() => byte(0x003cc577)
achievement(title = "Ready for Hunting", points = 3, description = "Obtain the Bait Bag.", id = 402391,
    trigger = IsValueSetInGame(baitBagSlot(), 0xff, 0x2c)
)

function rupees() => word_be(0x003cc534)
achievement(title = "Birthday Fine", points = 1, description = "Destroy the pot Sue-Belle's carrying and pay the full fine.", id = 402392, type = "missable",
    trigger = once(DisplayingMessageWithId(2207)) && Delta(rupees()) == rupees() + 10
)

function crawlingStatus() => bit3(0x3d21f8)
function gavePinkPig() => bit0(0x003ccc0a)
function gaveSpottedPig() => bit1(0x003ccc0a)
function gaveBlackPig() => bit2(0x003ccc0a)
achievement(title = "Hog Wild", points = 5, description = "Wrangle all three pigs on Outset Island and claim all three Rupee rewards without crawling or going indoors.", id = 402393,
    type = "missable",
    trigger = WasBitflagSetInGame(gavePinkPig()) && WasBitflagSetInGame(gaveSpottedPig()) && WasBitflagSetInGame(gaveBlackPig()) && unless(once(crawlingStatus() == 1))
        && (always_false() || never(AreaJustChanged()))
)

function bokoblinsDroppedIn() => bit0(0x003cccaf) // when stageId is 0xb
function tetraAwakens() => bit1(0x003cccaf) // when stageId is 0xb
achievement(title = "With Enemies Like These", points = 25, description = "Rescue Tetra from the two Bokoblins without using your sword and without leaving the area.", id = 402394,
    type = "missable",
    trigger = trigger_when(once(IsInArea("Forest of Fairies") && IsValueSet(bokoblinsDroppedIn(), 0, 1)) && stageId() == 0xb)
        && WasBitflagJustSetInGame(tetraAwakens())
        && never(swordActionPointer() == 0)
        && never(swordAnimationId() != 0)
        && never(!IsInArea("Forest of Fairies"))
)


niko1TimeLimit = 20
tetraPlatformMaxTime = 0x708
function tetraPlatformPointer() => dword_be(0x003c0d7c) // todo: Even more narrowing down of potential pointers needs to be done, but I haven't figured out what causes memory to shift...
function tetraPlatformTimeRemaining() => word_be(tetraPlatformPointer() + 0x1be + 0x80000000)
function TetraPlatformTimerFrozen() => byte(tetraPlatformPointer() + 0x1c0 + 0x80000000) > 0
function TetraPlatformTimeElapsed() => (tetraPlatformMaxTime - tetraPlatformTimeRemaining()) * 2
function WithinPlatformTimeLimit() => TetraPlatformTimeElapsed() <= SecondsToFrames(niko1TimeLimit)
function TetraPlatformsAreUp() => bit0(tetraPlatformPointer() + 0x1bb + 0x80000000) == 1
function NinjaWarriorChallengeActive() => TetraPlatformsAreUp()
function CompletedFirstObstacleCourse() => bit4(0x003ccb5b) == 1
achievement(title = "Ninja Warrior I", points = 10, description = "Complete Niko's obstacle course within " + niko1TimeLimit + " seconds.", id = 402395, type = "missable",
    trigger = trigger_when(NinjaWarriorChallengeActive() && TetraPlatformTimerFrozen()) && WithinPlatformTimeLimit() && !CompletedFirstObstacleCourse()
)

leaderboard(title = "Ninja Warrior I", description = "Reach the end of Niko's first obstacle course as quickly as you can.", id = 90099,
    start = NinjaWarriorChallengeActive() && !CompletedFirstObstacleCourse(),
    cancel = !NinjaWarriorChallengeActive(),
    submit = NinjaWarriorChallengeActive() && TetraPlatformTimerFrozen(),
    value = TetraPlatformTimeElapsed(),
    format = "FRAMES"
)

function metKoRL() => bit2(0x003cc8b6)
achievement(title = "Carried by the Currents", description = "Meet the King of Red Lions.", points = 3, id = 402396, type = "progression",
    trigger = WasBitflagJustSetInGame(metKoRL())
)

function pictographSidequestProgress() => byte(0x003ccc18)
achievement(title = "Apprentice Pictographer", description = "Complete Lenzo's pictograph sidequest.", points = 5, id = 404243,
    trigger = WasValueJustSetInGame(pictographSidequestProgress(), 5, 6)
        && measured(pictographSidequestProgress() == 6)
)

function windWakerSlot() => byte(0x003cc56e)
achievement(title = "Maestro of the Mistral", description = "Obtain the Wind Waker.", points = 3, type = "progression",
    trigger = IsValueSetInGame(windWakerSlot(), 0xff, 0x22)
)

function letterSortingQuestProgress() => byte(0x003ccc16)
achievement(title = "Part-Time Clerk", description = "Complete the first letter-sorting sidequest.", points = 5,
    trigger = WasValueJustSetInGame(letterSortingQuestProgress(), 2, 3)
        && measured(letterSortingQuestProgress() == 3)
)

possessedTreasureChartAddressBits = {
    2: { "addr": 0x003cc604, "bit": 0 },3: { "addr": 0x003cc604, "bit": 1 },4: { "addr": 0x003cc604, "bit": 2 },5: { "addr": 0x003cc604, "bit": 5 },6: { "addr": 0x003cc604, "bit": 6 },7: { "addr": 0x003cc605, "bit": 1 },8: { "addr": 0x003cc605, "bit": 2 },9: { "addr": 0x003cc605, "bit": 3 },10: { "addr": 0x003cc605, "bit": 4 },11: { "addr": 0x003cc605, "bit": 5 },12: { "addr": 0x003cc605, "bit": 7 },13: { "addr": 0x003cc606, "bit": 0 },14: { "addr": 0x003cc606, "bit": 1 },15: { "addr": 0x003cc606, "bit": 2 },16: { "addr": 0x003cc606, "bit": 3 },17: { "addr": 0x003cc606, "bit": 5 },18: { "addr": 0x003cc606, "bit": 6 },19: { "addr": 0x003cc606, "bit": 7 },20: { "addr": 0x003cc607, "bit": 4 },21: { "addr": 0x003cc609, "bit": 2 },22: { "addr": 0x003cc60b, "bit": 0 },23: { "addr": 0x003cc60b, "bit": 2 },24: { "addr": 0x003cc60b, "bit": 4 },25: { "addr": 0x003cc60b, "bit": 5 },26: { "addr": 0x003cc60b, "bit": 6 },
}

GenerateCheevoFromBits(name = "Treasure Hunter - Dragon Roost Cavern", description = "Open all treasure chests in Dragon Roost Cavern.", points = 5,
    onlyAvailableWhen = IsInAreaByInternalName("M_NewD2"), oneAtATime = true,
    addresses = {
        1: { "addr": 0x003cccab, "bit": 0 },
        2: { "addr": 0x003cccab, "bit": 1 },
        3: { "addr": 0x003cccab, "bit": 2 },
        4: { "addr": 0x003cccab, "bit": 3 },
        5: { "addr": 0x003cccab, "bit": 4 },
        6: { "addr": 0x003cccab, "bit": 6 },
        7: { "addr": 0x003cccab, "bit": 7 },
        8: { "addr": 0x003cccaa, "bit": 2 },
        9: { "addr": 0x003cccaa, "bit": 3 },
        10: { "addr": 0x003cccaa, "bit": 4 },
        11: { "addr": 0x003cccaa, "bit": 5 },
        12: { "addr": 0x003cccaa, "bit": 6 },
        13: { "addr": 0x003cccaa, "bit": 7 }
    }
)

function dinsPearl() => bit1(0x003cc5ef)
achievement(title = "Jewel of Power", description = "Obtain Din's Pearl.", points = 3, type = "progression",
    trigger = WasBitflagJustSetInGame(dinsPearl())
)

function dragonRoostGrottoChestOpened() => bit0(0x003cccab)
achievement(title = "The Labyrinth of Dragon Roost", description = "Claim the treasure in the grotto on Dragon Roost Island.", points = 1,
    trigger = WasBitflagJustSetInGame(dragonRoostGrottoChestOpened()) && IsInArea("Mysterious Labyrinth") && staticRoomId() == 6
)

cartographerBits = {}
for i in range(0, 48)
{
    baseChartAddr = 0x003cc634
    cartographerBits[i] = { "addr": (baseChartAddr + i), "bit": 0 }
}

GenerateCheevoFromBits(name = "Rookie Cartographer", description = "Map 50% of the islands on your Sea Chart.", points = 5,
    onlyAvailableWhen = IsInAreaByInternalName("sea"),
    addresses = cartographerBits,
    threshold = length(cartographerBits) / 2
)

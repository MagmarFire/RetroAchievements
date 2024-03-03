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
// /utility

superareas = {
    2: { "id":2, "internalName":"sea", "displayName":"The Great Sea", "addrOverride": 0x00ab78c9},3: { "id":3, "internalName":"majroom", "displayName":"Forsaken Fortress", "addrOverride": 0},
}

areas = {
    859204975: { "name": "Forest of Fairies", "internalName": "A_mori", "roomId": 0, "key": "" },660955507: { "name": "Title Screen", "internalName": "sea_T", "roomId": 44, "key": "" },1315007817: { "name": "File Select", "internalName": "Name", "roomId": 44, "key": "" },1936023852: { "name": "Outset Island", "internalName": "sea", "roomId": 44, "key": "" },974743663: { "name": "Orca and Sturgeon's House (1F)", "internalName": "Ojhous", "roomId": 0, "key": "" },974740078: { "name": "Orca and Sturgeon's House (2F)", "internalName": "Ojhous2", "roomId": 1, "key": "" },771907955: { "name": "Mesa's House", "internalName": "Omasao", "roomId": 0, "key": "" },974786146: { "name": "Abe and Rose's House", "internalName": "Onobuta", "roomId": 0, "key": "" },505704043: { "name": "Link's House", "internalName": "LinkRM", "roomId": 0, "key": "" },538080106: { "name": "Beedle's Shop Ship", "internalName": "Obshop", "roomId": 2, "key": "" },674500461: { "name": "Tetra's Ship, On Deck", "internalName": "A_umikz", "roomId": 0, "key": "" },779317099: { "name": "Tetra's Ship, Below Deck", "internalName": "Asoko", "roomId": 0, "key": "" },941910649: { "name": "Forsaken Fortress", "internalName": "MajyuE", "roomId": 0, "key": "ForsakenFortressBailey" },34473840: { "name": "Gallery", "internalName": "majroom", "roomId": 2, "key": "ForsakenFortressGallery" },34473842: { "name": "Prison", "internalName": "majroom", "roomId": 0, "key": "ForsakenFortressPrison" },34473846: { "name": "Barracks", "internalName": "majroom", "roomId": 4, "key": "ForsakenFortressBarracks" },34473841: { "name": "Docks", "internalName": "majroom", "roomId": 3, "key": "ForsakenFortressDocks" },34473843: { "name": "Dining Area", "internalName": "majroom", "roomId": 1, "key": "ForsakenFortressDining" },974063215: { "name": "Forsaken Fortress: Tower", "internalName": "Mjtower", "roomId": 0, "key": "ForsakenFortressTower" },1936023819: { "name": "Windfall Island", "internalName": "sea", "roomId": 11, "key": "" },588018279: { "name": "Chu Jelly Juice Shop", "internalName": "Pdrgsh", "roomId": 0, "key": "" },656042339: { "name": "House of Wealth", "internalName": "Orichh", "roomId": 0, "key": "" },1332770146: { "name": "Cafe", "internalName": "Opub", "roomId": 0, "key": "" },1023569253: { "name": "Lenzo's Studio", "internalName": "Ocmera", "roomId": 0, "key": "" },923140457: { "name": "Joy School", "internalName": "Nitiyou", "roomId": 0, "key": "" },772761971: { "name": "Game Room", "internalName": "Kaisen", "roomId": 0, "key": "" },620956794: { "name": "Jail", "internalName": "Pnezumi", "roomId": 0, "key": "" },755658605: { "name": "Bomb Shop", "internalName": "Obombh", "roomId": 0, "key": "" },672007282: { "name": "test1", "internalName": "Atorizk", "roomId": 0, "key": "" },738526318: { "name": "test2", "internalName": "Adanmae", "roomId": 0, "key": "" },974879845: { "name": "test3", "internalName": "M_NewD2", "roomId": 0, "key": "" },1936023820: { "name": "Pawprint Isle", "internalName": "sea", "roomId": 12, "key": "" },1936023821: { "name": "Dragon Roost Island", "internalName": "sea", "roomId": 13, "key": "" },
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
function roomId() => byte(0x003cccd8)
function greatSeaRoomId() => byte(0x00ab78c9) // Dynamic but is one of the few room ID values that updates in real time, not just when the player changes rooms.
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

function IsInAreaByHash(hash)
{
    return hash == GetAreaHash()
}

function IsOnTitleScreen() => IsInArea("Title Screen")
internalNamesAddedToRP = []

for hash in areas
{
    area = GetAreaByHash(hash)
    superarea = GetSuperareaByName(area["internalName"])
    lookupForArea = lookups[GetLookupKey(area["internalName"])]
    display = ""
    roomIdToUse = roomId()

    if (DoesSuperareaExist(area["internalName"]))
    {
        display = superarea["displayName"] + ": "

        if (superarea["addrOverride"] != 0)
        {
            roomIdToUse = byte(superarea["addrOverride"])
        }
    }

    if (!any_of(internalNamesAddedToRP, input => input == area["internalName"]))
    {
        rich_presence_conditional_display(IsInArea(area["name"]), display + "{0}",
            rich_presence_lookup(GetLookupKey(area["internalName"]), roomIdToUse, lookupForArea)
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
achievement(title = "Birthday Fine [m]", points = 1, description = "Destroy the pot Sue-Belle's carrying and pay the full fine.", id = 402392,
    trigger = once(DisplayingMessageWithId(2207)) && Delta(rupees()) == rupees() + 10
)

function crawlingStatus() => bit3(0x3d21f8)
function gavePinkPig() => bit0(0x003ccc0a)
function gaveSpottedPig() => bit1(0x003ccc0a)
function gaveBlackPig() => bit2(0x003ccc0a)
achievement(title = "Hog Wild [m]", points = 5, description = "Wrangle all three pigs on Outset Island and claim all three Rupee rewards without crawling or going indoors.", id = 402393,
    trigger = WasBitflagSetInGame(gavePinkPig()) && WasBitflagSetInGame(gaveSpottedPig()) && WasBitflagSetInGame(gaveBlackPig()) && unless(once(crawlingStatus() == 1))
        && (always_false() || never(AreaJustChanged()))
)

function bokoblinsDroppedIn() => bit0(0x003cccaf) // when stageId is 0xb
function tetraAwakens() => bit1(0x003cccaf) // when stageId is 0xb
achievement(title = "With Enemies Like These [m]", points = 25, description = "Rescue Tetra from the two Bokoblins without using your sword and without leaving the area.", id = 402394,
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
achievement(title = "Ninja Warrior I [m]", points = 10, description = "Complete Niko's obstacle course within " + niko1TimeLimit + " seconds.", id = 402395,
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
achievement(title = "Carried by the Currents", description = "Meet the King of Red Lions.", points = 3, id = 402396,
    trigger = WasBitflagJustSetInGame(metKoRL())
)

function pictographSidequestProgress() => byte(0x003ccc18)
achievement(title = "Apprentice Pictographer", description = "Complete Lenzo's pictograph sidequest.", points = 5, id = 404243,
    trigger = WasValueJustSetInGame(pictographSidequestProgress(), 5, 6)
        && measured(pictographSidequestProgress() == 6)
)

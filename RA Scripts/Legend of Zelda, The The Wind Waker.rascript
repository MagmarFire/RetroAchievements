// Legend of Zelda, The: The Wind Waker
// #ID = 9190

// UTILITY
function Delta(addr) => prev(addr)

function WasBitflagSetInGame(bit)
{
    return IsValueSet(bit, 0, 1)
        && FileIsLoaded()
}

function IsBitflagSetInGame(bit)
{
    return IsValueSetInGame(bit, 0, 1)
}

function WasValueSetInGame(mem, oldValue, newValue)
{
    return IsValueSet(mem, oldValue, newValue)
        && FileIsLoaded()
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

function IsValueSet(mem, oldValue, newValue)
{
    return Delta(mem) == oldValue && mem == newValue
}

areas = {
    859204975: { "name": "Forest of Fairies", "internalName": "A_mori", "hash": 859204975 },660955487: { "name": "Title Screen", "internalName": "sea_T", "hash": 660955487 },1315007845: { "name": "File Select", "internalName": "Name", "hash": 1315007845 },1936023852: { "name": "Outset Island", "internalName": "sea", "hash": 1936023852 },974743663: { "name": "Orca and Sturgeon's House (1F)", "internalName": "Ojhous", "hash": 974743663 },974740079: { "name": "Orca and Sturgeon's House (2F)", "internalName": "Ojhous2", "hash": 974740079 },
}

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

function GetAreaByHash(inHash)
{
    return areas[inHash]
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

function mapNamePart1() => dword_be(0x003d1664)
function mapNamePart2() => dword_be(0x003d1668)
function roomId() => byte(0x003cccd8)
function GetAreaHash()
{
    return (mapNamePart1() ^ mapNamePart2()) + roomId()
}

function IsInArea(name)
{
    area = GetAreaByName(name)
    return IsInAreaByHash(area["hash"])
}

function IsInAreaByHash(hash)
{
    return hash == GetAreaHash()
}

function IsOnTitleScreen() => IsInArea("Title Screen")
for hash in areas
{
    area = GetAreaByHash(hash)
    rich_presence_conditional_display(IsInAreaByHash(GetAreaHash()), area["name"])
}

//rich_presence_conditional_display(IsOnTitleScreen(), "On the title screen...")

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

function SecondsToFrames(seconds) => seconds * 60 // Assuming a 60 FPS framerate

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
achievement(title = "Ready for Hunting", points = 3, description = "Obtain the Bait Bag.",
    trigger = IsValueSetInGame(baitBagSlot(), 0xff, 0x2c)
)

function rupees() => word_be(0x003cc534)
achievement(title = "Birthday Fine [m]", points = 1, description = "Destroy the pot Sue-Belle's carrying and pay the full fine.",
    trigger = once(DisplayingMessageWithId(2207)) && Delta(rupees()) == rupees() + 10
)

function crawlingStatus() => bit3(0x3d21f8)
function gavePinkPig() => bit0(0x003ccc0a)
function gaveSpottedPig() => bit1(0x003ccc0a)
function gaveBlackPig() => bit2(0x003ccc0a)
achievement(title = "Hog Wild [m]", points = 5, description = "Wrangle all three pigs on Outset Island and claim all three Rupee rewards without crawling or going indoors.",
    trigger = WasBitflagSetInGame(gavePinkPig()) && WasBitflagSetInGame(gaveSpottedPig()) && WasBitflagSetInGame(gaveBlackPig()) && unless(once(crawlingStatus() == 1))
        && (always_false() || never(AreaJustChanged()))
)

function mapNameAddr() => 0x003d1664
function bokoblinsDroppedIn() => bit0(0x003cccaf) // when stageId is 0xb
function tetraAwakens() => bit1(0x003cccaf) // when stageId is 0xb
achievement(title = "With Enemies Like These [m]", points = 25, description = "Rescue Tetra from the two Bokoblins without using your sword and without leaving the area.",
    trigger = trigger_when(once(IsInArea("Forest of Fairies") && IsValueSet(bokoblinsDroppedIn(), 0, 1)) && stageId() == 0xb)
        && WasBitflagSetInGame(tetraAwakens())
        && never(swordActionPointer() == 0)
        && never(swordAnimationId() != 0)
        && never(!IsInArea("Forest of Fairies"))
)
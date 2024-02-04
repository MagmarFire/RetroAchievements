// Legend of Zelda, The: The Wind Waker
// #ID = 9190

// UTILITY
function Delta(addr) => prev(addr)

function WasBitflagSetInGame(bit)
{
    return once(Delta(bit) != bit && bit == 1)
        && never(IsLoadingSaveFile())
}

function IsBitflagSetInGame(bit)
{
    return IsValueSetInGame(bit, 0, 1)
}

function WasValueSetInGame(mem, oldValue, newValue)
{
    return WasValueSet(mem, oldValue, newValue)
        && never(IsLoadingSaveFile())
}

function IsValueSetInGame(mem, oldValue, newValue)
{
    return IsValueSet(mem, oldValue, newValue)
        && never(IsLoadingSaveFile())
}

function WasValueSet(mem, oldValue, newValue)
{
    return once(Delta(mem) == oldValue && mem == newValue)
}

function WasBitflagSet(mem)
{
    return WasValueSet(mem, 0, 1)
}

function IsValueSet(mem, oldValue, newValue)
{
    return Delta(mem) == oldValue && mem == newValue
}

function DidValueBecomeGreaterThanGivenInGame(mem, value)
{
    return once(Delta(mem) <= value && mem > value) && never(IsLoadingSaveFile())
}

function outsetIslandCutscenePlayed() => bit4(0x003ccb89)
function IsLoadingSaveFile() => IsValueSet(outsetIslandCutscenePlayed(), 0, 1)

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

function mapId() => byte(0x003ccccc)
function roomId() => byte(0x003cccd8)
function layerId() => byte(0x003ccd24)
function JustChangedRooms() => Delta(roomId()) != 0xff && roomId() == 0xff

function dialoguePointer() => dword_be(0x003c21b8)
function messageId() => word_be(dialoguePointer() + 0x40 + 0x80000000)
function DisplayingMessageWithId(id) => messageId() == id

function baitBagSlot() => byte(0x003cc577)
achievement(title = "Ready for Hunting", points = 3, description = "Obtain the Bait Bag.",
    trigger = WasValueSetInGame(baitBagSlot(), 0xff, 0x2c)
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
        && (always_false() || never(JustChangedRooms()))
)

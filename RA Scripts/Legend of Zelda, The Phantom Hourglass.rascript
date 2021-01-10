// Legend of Zelda, The: Phantom Hourglass
// #ID = 14323

// The global offset has not been found and may not be found for a while. However, we're designing the script with potential multilanguage support
// in mind early to limit the pain to implement later.
function GetGlobalOffset() => 0x0

function systemTimer() => odword(0x3ffc3c)

function obit0(addr) => bit0(addr + GetGlobalOffset())
function obit1(addr) => bit1(addr + GetGlobalOffset())
function obit2(addr) => bit2(addr + GetGlobalOffset())
function obit3(addr) => bit3(addr + GetGlobalOffset())
function obit4(addr) => bit4(addr + GetGlobalOffset())
function obit5(addr) => bit5(addr + GetGlobalOffset())
function obit6(addr) => bit6(addr + GetGlobalOffset())
function obit7(addr) => bit7(addr + GetGlobalOffset())

function obyte(addr) => byte(addr + GetGlobalOffset())
function oword(addr) => word(addr + GetGlobalOffset())
function odword(addr) => dword(addr + GetGlobalOffset())

function Delta(addr) => prev(addr)

function WasBitflagSetInGame(bit)
{
    return WasValueSetInGame(bit, 0, 1)
}

function WasBitflagSet(bit)
{
    return WasValueSet(bit, 0, 1)
}

function WasValueSetInGame(mem, oldValue, newValue)
{
    return WasValueSet(mem, oldValue, newValue)
        && never(!IsInGame()) && never(IsLoadingSaveFile())
}

function WasValueSet(mem, oldValue, newValue)
{
    return once(Delta(mem) == oldValue && mem == newValue)
}

function DidValueBecomeGreaterThanGivenInGame(mem, value)
{
    return once(Delta(mem) <= value && mem > value) && never(!IsInGame())
}

function SecondsToFormat(value)
{
    leadingZero = ""
    if (value % 60 < 10)
    {
        leadingZero = "0"
    }
    return value / 60 + ":" + leadingZero + value % 60
}

// $19f998: 0x3 = is loading save file(?)
function IsLoadingSaveFile() => obyte(0x19f998) == 0x3

function IsInGame() => !IsInLocationWithCode("File") && !WasInLocationWithCode("File")
    && !IsInLocationWithCode("WFC") && !IsInLocationWithCode("Title")
    && !IsInLocationWithCode("Battle")

// $1b7f9c: File selection menu (16-bit)
//          0x1 = File selection
//          0x2 = Copy, Erase, Start
//          0x3 = Adventure or Battle Mode
//          0x4 = Battle
//          0xb = Big Plays
//          0xc = Return fr Battle Mode
//          0x75 = Battle Mode
function MayHaveBeenInBootState() => oword(0x1b7f9c) == 0x0

// $1b2e20: Current location (US)
function currentLocation() => oword(0x1b2e20)

// This function allows the creation of achievements with built-in save protection that deal with a collection of values being set
// throughout the game. The schemas for both parameters are as follows:
//
// cheevo: "name": title
//         "description": self-explanatory
//         "points": self-explanatory
//         "threshold": how many values in the "addresses" dictionary must be set before this achievement is triggered
//
// conditions: "countsWhen": the condition that must be true in order for it to be counted in the total
//             "recalculateWhen": the condition that indicates that relevant values in the condition have changed,
//                                and so everything must be recalculated
function GenerateSaveProtectedAchievementFromConditions(cheevo, conditions)
{
    loadedCounts = []
    totalCounts = []
    resetAlt = always_false()

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

    achievement(title = cheevo["name"], description = cheevo["description"], points = cheevo["points"],
        trigger = never(!IsInGame())
            && never(MayHaveBeenInBootState()) // Prevent save protection from failing in the event of a manual game reset.
            && measured(tally(cheevo["threshold"], totalCounts)) && unless(tally(cheevo["threshold"], loadedCounts))
            && never(resetAlt)
    )
}

// $1B2E60: Current Location [8-bit]
//          61 = Main Menu
//          00 = Wi-Fi Connection
//          ac = Wi-Fi Connection
//          44 = Multiplayer
//          25 = DS Download Play
// $1B2E64: Can be used as current Part of Map
// $1B2E94: Location that will load

// $1B553C: Bit 2: Learned Swordplay from Oshus
function learnedSwordplay() => obit2(0x1B553C)

// $1B5554: Bit 1: First cutscene with Oshus
// $1B555B: Bit 6: Earthquake after talking to Oshus(?)
// $1B5658: [Pointer]
//          Can be used for most dialogs (Offset -0x2134)
// $1B8124: Select File [8-bit]
//          00 = File 1
//          01 = File 2
// $1B85D5: Options Menu
// $1B85ED: Options Mic Test [8-bit]
// $1B85FC: Options Message Speed [8-bit]
//          00 = Slow
//          01 = Normal
//          02 = Fast
// $1B85FD: Options Sound Settings [8-bit]
//          00 = Surround
//          01 = Stereo
//          02 = Headphones
//          03 = Mono
// $1B85FE: Options Hand Setting [8-bit]
//          00 = Right-handed
//          01 = Left-handed

// $1BA348: Max HP (US)
function maxHp() => obyte(0x1BA348)

// $1BA34A: HP (US)
function hp() => obyte(0x1BA34A)

// $1BA388: Max Health
// $1BA38A: Health (Static)
// $1BA4FE: Rupees (US)

// $1BA500: Courage Gem count
function courageGems() => obyte(0x1BA500)

// $1BA501: Power Gem count
function powerGems() => obyte(0x1BA501)

// $1BA502: Wisdom Gem count
function wisdomGems() => obyte(0x1BA502)

// $1BA53E: Rupees

// $1BA53E: Rupees
function rupees() => oword(0x1BA53E)

// $1BA56C: Pink Coral count
function pinkCoralCount() => obyte(0x1BA56C)

// $1BA56D: Pearl Necklace count
function pearlNecklaceCount() => obyte(0x1BA56D)

// $1BA56E: Dark Pearl Loop count
function darkPearlLoopCount() => obyte(0x1BA56E)

// $1BA56F: Zora Scale count
function zoraScaleCount() => obyte(0x1BA56F)

// $1BA570: Goron Amber count
function goronAmberCount() => obyte(0x1BA570)

// $1BA571: Ruto Crown count
function rutoCrownCount() => obyte(0x1BA571)

// $1BA572: Helmaroc Plume count
function helmarocPlumeCount() => obyte(0x1BA572)

// $1BA574: Skippyjacks caught
function skippyjacksCaught() => obyte(0x1BA574)

// $1BA575: Toonas caught
function toonasCaught() => obyte(0x1BA575)

// $1BA576: Loovars caught
function loovarsCaught() => obyte(0x1BA576)

// $1BA577: Rusty Swordfish caught
function rustySwordfishCaught() => obyte(0x1BA577)

// $1BA578: Neptoona caught
function neptoonaCaught() => obyte(0x1BA578)

// $1BA579: Stowfish caught
function stowfishCaught() => obyte(0x1BA579)

// $1BA57A: Largest Skippyjack caught (cm) (for US, divide by 2.54 to get inches) (16-bit)
function largestSkippyjackLength() => oword(0x1BA57A)

// $1BA57C: Largest Toona caught (cm) (for US, divide by 2.54 to get inches) (16-bit)
function largestToonaLength() => oword(0x1BA57C)

// $1BA57E: Largest Loovar caught (cm) (for US, divide by 2.54 to get inches) (16-bit)
function largestLoovarLength() => oword(0x1BA57E)

// $1BA580: Largest Rusty Swordfish caught (cm) (for US, divide by 2.54 to get inches) (16-bit)
function largestRustySoowordfishLength() => oword(0x1BA580)

// $1BA582: Largest Neptoona caught (cm) (for US, divide by 2.54 to get inches) (16-bit)
function largestNeptoonaLength() => oword(0x1BA582)

// $1BA590: Quiver upgrades obtained
function quiverUpgradesObtained() => obyte(0x1BA590)

// $1BA592: Bomb upgrades obtained
function bombUpgradesObtained() => obyte(0x1BA592)

// $1BA594: Bombchu upgrades obtained
function bombchuUpgradesObtained() => obyte(0x1BA594)

// $1BA604: Bit 0: Oshus's Sword (collection)
function hasOshusSword() => obyte(0x1BA604)

// $1BA678: Bit 0: Oshus's Sword
// $1CB08E: Current Health (Not Static)
// $2173DC: Current Dialog
// $217404: Can be used as current Dialog ID?
// $21740F: Current Dialog Part
// $263DBC: Bit2=Oshus' Sword Found
// $263DE8: Bit0=Oshus' Sword Chest

locations = {
0xb: { "id": 0xb, "name": "On Mercay Island", "code": "Mercay", },
0x27: { "id": 0x27, "name": "Trekking the Mountain Passage", "code": "Passage", },
0x26: { "id": 0x26, "name": "At the entrance to the Temple of the Ocean King", "code": "OceanKingLobby", },
0x25: { "id": 0x25, "name": "In the Temple of the Ocean King", "code": "OceanKing", },
0x65: { "id": 0x65, "name": "On the file select screen", "code": "File", },
0xcccc: { "id": 0xcccc, "name": "On the Nintendo WFC Setup screen", "code": "WFC", },
0x409: { "id": 0x409, "name": "In Battle Mode", "code": "Battle", },
0x35: { "id": 0x35, "name": "On the title screen", "code": "Title", },
0xd: { "id": 0xd, "name": "On the Isle of Ember", "code": "Ember", },
0x1c: { "id": 0x1c, "name": "In the Temple of Fire", "code": "TempleOfFire", },
0x2b: { "id": 0x2b, "name": "In Blaaz’s lair…", "code": "Blaaz", },

}

function GetLocationByCode(code)
{
    for id in locations
    {
        if (locations[id]["code"] == code)
        {
            return locations[id]
        }
    }
}

function IsInLocationWithCode(code)
{
    location = GetLocationByCode(code)
    return currentLocation() == location["id"]
}

function WasInLocationWithCode(code)
{
    location = GetLocationByCode(code)
    return Delta(currentLocation()) == location["id"]
}

achievement(title = "Permission Shmermission", points = 1,
    description = "Learn swordplay from Oshus after raiding his storage.",
    trigger = WasBitflagSetInGame(learnedSwordplay())
)

// "Treasure Hunter"
pinkCoralCountAddr = 0x1ba56c
totalTreasureTypes = 8
totalConditions = 0
treasureConditions = {}

for i in range(0, totalTreasureTypes - 1)
{
    treasureCount = obyte(pinkCoralCountAddr + i)
    treasureTypeRegistered = treasureCount != 0xff
    treasureTypeWasUnregistered = Delta(treasureCount) == 0xff
    treasureConditions[totalConditions] = { "countsWhen": treasureTypeRegistered, "recalculateWhen": (treasureTypeWasUnregistered && treasureTypeRegistered) }
    totalConditions = totalConditions + 1
}

GenerateSaveProtectedAchievementFromConditions({
    "name": "Treasure Hunter",
    "description": "Obtain one of every type of treasure.",
    "points": 5,
    "threshold": totalTreasureTypes
}, treasureConditions)

// Power, Wisdom, and Courage Gem achievements

achievement(title = "Seeker of Power", points = 5,
    description = "Collect 10 Power Gems.",
    trigger = WasValueSetInGame(powerGems(), 9, 10) && measured(powerGems() == 10)
)

achievement(title = "Omnipotence", points = 10,
    description = "Collect all 20 Power Gems.",
    trigger = WasValueSetInGame(powerGems(), 19, 20) && measured(powerGems() == 20)
)

achievement(title = "Seeker of Wisdom", points = 5,
    description = "Collect 10 Wisdom Gems.",
    trigger = WasValueSetInGame(wisdomGems(), 9, 10) && measured(wisdomGems() == 10)
)

achievement(title = "Omniscience", points = 10,
    description = "Collect all 20 Wisdom Gems.",
    trigger = WasValueSetInGame(wisdomGems(), 19, 20) && measured(wisdomGems() == 20)
)

achievement(title = "Seeker of Courage", points = 5,
    description = "Collect 10 Courage Gems.",
    trigger = WasValueSetInGame(courageGems(), 9, 10) && measured(courageGems() == 10)
)

achievement(title = "Omnibenevolence", points = 10,
    description = "Collect all 20 Courage Gems.",
    trigger = WasValueSetInGame(courageGems(), 19, 20) && measured(courageGems() == 20)
)

// SEA CHART ACHIEVEMENTS
// $1ba608: Bit 1: Sea Chart - Southwest quadrant
//          Bit 2: Sea Chart - Northwest quadrant
//          Bit 3: Sea Chart - Southeast quadrant
//          Bit 4: Sea Chart - Northeast quadrant
seaChartBaseAddr = 0x1ba608
// The title should reflect Seneca's names for the classical compass winds in Latin, to match the Latin origin for Bellum's name.
achievement(title = "Africus", points = 3,
    description = "Acquire the Southwestern Sea Chart.",
    trigger = WasBitflagSetInGame(obit1(seaChartBaseAddr))
)

achievement(title = "Corus", points = 3,
    description = "Acquire the Northwestern Sea Chart.",
    trigger = WasBitflagSetInGame(obit2(seaChartBaseAddr))
)

achievement(title = "Vulturnus", points = 3,
    description = "Acquire the Southeastern Sea Chart.",
    trigger = WasBitflagSetInGame(obit3(seaChartBaseAddr))
)

achievement(title = "Caecias", points = 3,
    description = "Acquire the Northeastern Sea Chart.",
    trigger = WasBitflagSetInGame(obit4(seaChartBaseAddr))
)

function astridRescued() => obit5(0x1b5544)
achievement(title = "A Vision of Darkness", points = 1,
    description = "Rescue Astrid, the fortuneteller on the Isle of Ember.",
    trigger = WasBitflagSetInGame(astridRescued())
)

function boomerang() => obit2(0x1ba604)
achievement(title = "Back at Ya!", points = 1,
    description = "Acquire the boomerang.",
    trigger = WasBitflagSetInGame(boomerang())
)

function IsBlaazDying() => obyte(0x25f050) == 0x16
achievement(title = "Scorching Earth [m]", points = 5,
    description = "Defeat Blaaz without recovering any life energy.",
    trigger = once(IsInLocationWithCode("Blaaz") && WasInLocationWithCode("TempleOfFire"))
        && IsBlaazDying() && never(hp() > Delta(hp()))
)

function leafAwakened() => obit3(0x1b5554)
achievement(title = "Hidden in Flame", points = 3,
    description = "Awaken the Spirit of Power.",
    trigger = WasBitflagSetInGame(leafAwakened())
)

// End Sea Chart achievements

// RICH PRESENCE
mapLookup = {}
for i in locations {
    location = locations[i]
    mapLookup[i] = location["name"]
}

rich_presence_conditional_display(currentLocation() == 0x00, "On the title screen")
rich_presence_display("{0}",
    rich_presence_lookup("map", currentLocation(), mapLookup, fallback="Somewhere on the Great Sea...")
)

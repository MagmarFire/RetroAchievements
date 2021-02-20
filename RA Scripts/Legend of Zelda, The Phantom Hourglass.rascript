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
function otbyte(addr) => tbyte(addr + GetGlobalOffset())
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

function IsInGame() => !IsInLocation("File") && !WasInLocation("File")
    && !IsInLocation("WFC") && !IsInLocation("Title")
    && !IsInLocation("Battle")

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

// $1ba682: Arrows remaining
function arrowsRemaining() => obyte(0x1ba682)

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
0x13: { "id": 0x13, "name": "On Cannon Island", "code": "Cannon", },
0x28: { "id": 0x28, "name": "In the Bomb Garden", "code": "BombGarden", },
0xc: { "id": 0xc, "name": "On Molida Island", "code": "Molida", },
0xe: { "id": 0xe, "name": "On the Isle of Gust", "code": "Gust", },
0xa: { "id": 0xa, "name": "On a traveler’s ship", "code": "Traveler", },
0x0: { "id": 0x0, "name": "Somewhere on the Great Sea…", "code": "Sea", },
0x1d: { "id": 0x1d, "name": "In the Temple of Wind", "code": "TempleOfWind", },
0x2a: { "id": 0x2a, "name": "In Cyclok’s lair…", "code": "Cyclok", },
0x3: { "id": 0x3, "name": "Salvaging in the Great Sea", "code": "Salvage", },
0x1e: { "id": 0x1e, "name": "In the Temple of Courage", "code": "TempleOfCourage", },
0x2c: { "id": 0x2c, "name": "In Crayk’s lair…", "code": "Crayk", },
0x4: { "id": 0x4, "name": "Below deck on Linebeck’s ship", "code": "BelowDeck", },
0x29: { "id": 0x29, "name": "On the Ghost Ship", "code": "GhostShip", },
0x30: { "id": 0x30, "name": "Playing Dead Man’s Volley…", "code": "Cubus", },
0x16: { "id": 0x16, "name": "On Zauz’s Island", "code": "Zauz", },
0x10: { "id": 0x10, "name": "On Goron Island", "code": "Goron", },
0x20: { "id": 0x20, "name": "In the Goron Temple", "code": "GoronTemple", },
0x2e: { "id": 0x2e, "name": "In Dongorongo’s lair…", "code": "Dongorongo", },
0xf: { "id": 0xf, "name": "On the Isle of Frost", "code": "Frost", },
0x1f: { "id": 0x1f, "name": "In the Temple of Ice", "code": "TempleOfIce", },
0x2d: { "id": 0x2d, "name": "In Gleeok’s lair…", "code": "Gleeok", },
0x15: { "id": 0x15, "name": "On the Isle of the Dead", "code": "Dead", },
0x11: { "id": 0x11, "name": "On the Isle of Ruins", "code": "Ruins", },
0x22: { "id": 0x22, "name": "In Doylan’s Temple", "code": "Doylan", },
0x24: { "id": 0x24, "name": "In Bremeur’s Temple", "code": "Bremeur", },
0x12: { "id": 0x12, "name": "On the Isle of Ruins", "code": "Ruins2", },
0x23: { "id": 0x23, "name": "In Max’s Temple", "code": "Max", },
0x21: { "id": 0x21, "name": "In Mutoh’s Temple", "code": "Mutoh", },
0x2f: { "id": 0x2f, "name": "In Eox’s lair…", "code": "Eox", },
0x1b: { "id": 0x1b, "name": "On Dee Ess Island", "code": "DS", },
0x17: { "id": 0x17, "name": "On Spirit Island", "code": "Spirit", },
0x5: { "id": 0x5, "name": "On the Masked Ship", "code": "Masked", },
0x7: { "id": 0x7, "name": "On a traveler’s ship", "code": "Traveler2", },
0x1a: { "id": 0x1a, "name": "On an uncharted island", "code": "Uncharted", },
0x14: { "id": 0x14, "name": "On Bannan Island", "code": "Bannan", },
0x1: { "id": 0x1, "name": "Playing the cannon minigame", "code": "CannonMinigame", },
0x2: { "id": 0x2, "name": "Fishing somewhere on the Great Sea", "code": "Fish", },
}

// RICH PRESENCE
mapLookup = {}
for i in locations {
    location = locations[i]
    mapLookup[i] = location["name"]
}

rich_presence_display("{0}",
    rich_presence_lookup("map", currentLocation(), mapLookup, fallback="Somewhere on the Great Sea...")
)
// END RICH PRESENCE

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

function IsInLocation(code)
{
    location = GetLocationByCode(code)
    return currentLocation() == location["id"]
}

function WasInLocation(code)
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

function northeasternSeaChart() => obit4(seaChartBaseAddr)
achievement(title = "Caecias", points = 3,
    description = "Acquire the Northeastern Sea Chart.",
    trigger = WasBitflagSetInGame(northeasternSeaChart())
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
    trigger = once(IsInLocation("Blaaz") && WasInLocation("TempleOfFire"))
        && IsBlaazDying() && never(hp() > Delta(hp()))
)

function leafFreed() => obit3(0x1b5554)
achievement(title = "Hidden in Flame", points = 3,
    description = "Free the Spirit of Power.",
    trigger = WasBitflagSetInGame(leafFreed())
)

function phantomHourglass() => obit0(0x1ba608)
achievement(title = "Tempus Fugit", points = 3,
    description = "Acquire the Phantom Hourglass.",
    trigger = WasBitflagSetInGame(phantomHourglass())
)

function eddoCannon() => obyte(0x1ba53f)
achievement(title = "Open Fire!", points = 3,
    description = "Buy Eddo's cannon.",
    trigger = WasValueSetInGame(eddoCannon(), 0xff, 0x1)
)

function shovel() => obit3(0x1ba604)
achievement(title = "Dig to the Center of the Earth!", points = 3,
    description = "Obtain the shovel.",
    trigger = WasBitflagSetInGame(shovel())
)

// This cheevo will trigger whenever you enter the Isle of Gust from the Great Sea, but without a bitflag to prevent this,
// we'll have to simply lock it out by other means. Best we can do at this point is to check for the existence of an item.
// We're adding this cheevo simply due to the existence of a microphone-dependent obstacle (MDO) on the island.
function bombs() => obit4(0x1ba604)
achievement(title = "Where the Wind Blows", points = 1,
    description = "Reach the Isle of Gust for the first time.",
    trigger = WasInLocation("Sea") && IsInLocation("Gust") && bombs() != 1
)

achievement(title = "And Kablooey!", points = 3,
    description = "Obtain bombs.",
    trigger = WasBitflagSetInGame(bombs())
)

function cyclokState() => obyte(0x255a0c)
function IsCyclokDying() => cyclokState() == 0x8
function CyclokStarted() => once(Delta(cyclokState()) == 1 && cyclokState() == 2)
cyclokFrameLimit = 2700
function TimeAdvancedAgainstCyclok() => repeated(0, CyclokStarted() && Delta(systemTimer()) != systemTimer())
achievement(title = "A Short Fuse [m]", points = 10,
    description = "Defeat Cyclok within " + (cyclokFrameLimit / 60) + " seconds.",
    trigger = once(IsInLocation("Cyclok") && WasInLocation("TempleOfWind")) && never(!IsInLocation("Cyclok"))
        && IsCyclokDying() && never(repeated(cyclokFrameLimit, TimeAdvancedAgainstCyclok()))
)

function neriFreed() => obit4(0x1b5554)
achievement(title = "Hidden in Wind", points = 3,
    description = "Free the Spirit of Wisdom.",
    trigger = WasBitflagSetInGame(neriFreed())
)

function crestPuzzleSolved() => obit2(0x1b554c)
achievement(title = "Thinking with Wax", points = 3,
    description = "Solve the crest puzzle in the second section of the Temple of the Ocean King.",
    trigger = WasBitflagSetInGame(crestPuzzleSolved())
)

function salvageArm() => obit4(0x1ba609)
achievement(title = "And Arm and a Leg", points = 1,
    description = "Buy the Salvage Arm.",
    trigger = WasBitflagSetInGame(salvageArm())
)

function bow() => obit5(0x1ba604)
achievement(title = "A Bowyer's Pride", points = 3,
    description = "Obtain the bow.",
    trigger = WasBitflagSetInGame(bow())
)

function IsCraykDying() => obyte(0x259f00) == 0x1e
achievement(title = "Minimalist [m]", points = 10,
    description = "Defeat Crayk using at most one arrow.",
    trigger = once(IsInLocation("Crayk") && WasInLocation("TempleOfCourage")) && never(!IsInLocation("Crayk"))
        && IsCraykDying() && never(repeated(2, arrowsRemaining() < Delta(arrowsRemaining())))
)

function cielaHalfFreed() => obit5(0x1b5554)
achievement(title = "Hidden in Oblivion", points = 3,
    description = "Free the Spirit of Courage.",
    trigger = WasBitflagSetInGame(cielaHalfFreed())
)

// 0xff = not swinging sword
// 0x1 = right-to-left swing
// 0x2 = left-to-right swing
// 0x3 = stab
// 0x4 = targeted attack
// 0x6 = Spin Attack
function swordDataPointer() => otbyte(0x1ba600)
function swordItemAnimationId() => obyte(swordDataPointer() + 0x58)
function swordStatus() => obyte(swordDataPointer() + 0x64)
function IsUsingSword() => swordStatus() == 0x3 && swordItemAnimationId() != 0xff
function JustUsedSword() => Delta(swordStatus()) != 0x3 && IsUsingSword()
function ghostKey() => obit5(0x1b5542)
achievement(title = "Quadruple Break Up [m]", points = 25,
    description = "Win at Dead Man's Volley and earn the Ghost Key using thirty-six sword swings or fewer.",
    trigger = once(IsInLocation("Cubus") && WasInLocation("GhostShip")) && never(repeated(36, JustUsedSword()))
        && never(!IsInLocation("Cubus")) && WasBitflagSetInGame(ghostKey())
)

function endOfGhostShip() => obit1(0x1b555b)
achievement(title = "Petraphobia", points = 3,
    description = "Find Tetra.",
    trigger = WasBitflagSetInGame(endOfGhostShip())
)

function grapplingHook() => obit6(0x1ba604)
function bombchus() => obit7(0x1ba604)
achievement(title = "Two in a Row [m]", points = 5,
    description = "Obtain the Northeastern Sea chart before having obtained both the Bombchu bag and the grappling hook.",
    trigger = WasBitflagSetInGame(northeasternSeaChart()) && grapplingHook() == 0 && bombchus() == 0 && never(!IsInLocation("OceanKing"))
)

achievement(title = "Pikachu Used Explosion!", points = 3,
    description = "Obtain the Bombchu bag.",
    trigger = WasBitflagSetInGame(bombchus())
)

function characterControlStatus() => obyte(0x1dc2e1)
function JustSwitchedFromLinkToGongoron() => Delta(characterControlStatus()) == 0 && characterControlStatus() == 1
function JustSwitchedFromGongoronToLink() => Delta(characterControlStatus()) == 1 && characterControlStatus() == 0
function dongorongoState() => obyte(0x269e20)
function DongorongoFirstPhaseComplete() => dongorongoState() == 0x16
achievement(title = "Seamless Relay [m]", points = 5,
    description = "Complete Dongorongo's first phase without switching between Link and Gongoron more than eight times.",
    trigger = once(IsInLocation("Dongorongo") && WasInLocation("GoronTemple")) && never(!IsInLocation("Dongorongo"))
        && DongorongoFirstPhaseComplete() && never(tally(9, [ repeated(0, JustSwitchedFromLinkToGongoron()), repeated(0, JustSwitchedFromGongoronToLink()) ]))
)

function DongorongoSecondPhaseBeginning() => dongorongoState() == 0x17
function DongorongoDying() => dongorongoState() == 0x18
function dongorongoHP() => obyte(0x269e10)
achievement(title = "Why Don't Ya Just Shoot Him? [m]", points = 10,
    description = "Complete Dongorongo's second phase without using your sword on it.",
    trigger = never(!IsInLocation("Dongorongo")) && once(DongorongoSecondPhaseBeginning()) && DongorongoDying()
        && never(IsUsingSword()
            && Delta(dongorongoHP()) < dongorongoHP()) // HP value goes up as it takes damage in its second phase.
)

function crimsonine() => obit6(0x1b554b)
achievement(title = "Sanguine Ore", points = 3,
    description = "Obtain Crimsonine.",
    trigger = WasBitflagSetInGame(crimsonine())
)

achievement(title = "The Hooks!", points = 3,
    description = "Obtain the grappling hook.",
    trigger = WasBitflagSetInGame(grapplingHook())
)

function cutsceneAfterGleeok() => obit3(0x1b555b)
achievement(title = "One Head Is Better than Two [m]", points = 5,
    description = "Defeat Gleeok and take its Sand of Hours without taking damage.",
    trigger = once(IsInLocation("Gleeok") && WasInLocation("TempleOfIce")) && Delta(cutsceneAfterGleeok()) == 0 && cutsceneAfterGleeok() == 1
        && never(!IsInLocation("Gleeok")) && never(hp() < Delta(hp()))
)

function azurine() => obit5(0x1b554b)
achievement(title = "Lacrimal Ore", points = 3,
    description = "Obtain Azurine.",
    trigger = WasBitflagSetInGame(azurine())
)

function hammer() => obit0(0x1ba605)
achievement(title = "Stop!", points = 3,
    description = "Obtain the hammer.",
    trigger = WasBitflagSetInGame(hammer())
)

eoxTimeLimit = 150
function eoxState() => obyte(0x255bdc)
function IsEoxDying() => eoxState() == 0xd
function EoxStarted() => once(Delta(eoxState()) == 0 && eoxState() != 0)
function TimeAdvancedAgainstEox() => repeated(0, EoxStarted() && Delta(systemTimer()) != systemTimer())
achievement(title = "Hammer Time! [m]", points = 5,
    description = "Defeat Eox within " + SecondsToFormat(eoxTimeLimit) + ".",
    trigger = once(IsInLocation("Eox") && WasInLocation("Mutoh")) && never(!IsInLocation("Eox"))
        && IsEoxDying() && never(repeated(eoxTimeLimit * 60, TimeAdvancedAgainstEox()))
)

function aquanine() => obit7(0x1b554b)
achievement(title = "Sudorific Ore", points = 3,
    description = "Obtain Aquanine.",
    trigger = WasBitflagSetInGame(aquanine()) 
)

function salvageArmHealth() => obyte(0x1f56e0) // May be dynamic
function salvageArmSpeedMode() => obyte(0x1f56ec)

// Starts at rising, normal before going straight to diving, normal.
function StartedSalvageMinigame() => once(Delta(salvageArmSpeedMode()) == 0x0 && salvageArmSpeedMode() == 0x3)
function salvageMinigameState() => obyte(0x1f56dc)
function PrematurelyReturningFromMinigame() => salvageMinigameState() == 0x4
achievement(title = "Be the Crane [m]", points = 5,
    description = "Salvage treasure without damaging the Salvage Arm.",
    trigger = once(WasInLocation("Sea") && IsInLocation("Salvage"))
        && IsInLocation("Sea") && WasInLocation("Salvage")
        && never(StartedSalvageMinigame() && Delta(salvageArmHealth()) > salvageArmHealth())
        && never(WasInLocation("Sea") && IsInLocation("Sea")) // Reset checkpoints if we're on the Great Sea for too long.
        && never(PrematurelyReturningFromMinigame())
)

goronTimeLimit = 30
function GoronGameDisplayIsActive() => obyte(0x26123c) == 0x1
function goronGameState() => odword(0x26124c)
function goronGameCountdown() => odword(0x261248)
function goronGameTime() => odword(0x197ba4)
function goronGameTargetsRemaining() => obyte(0x197bd0)
achievement(title = "Rollin', Rollin', Rollin'", points = 25,
    description = "Finish the Goron Game in thirty seconds or less.",
    trigger = never(!IsInLocation("DS")) && once(goronGameState() != 0xffffffff && goronGameCountdown() == 0x3)
        && never(Delta(goronGameTargetsRemaining()) == 0 && goronGameTargetsRemaining() == 30)
        && GoronGameDisplayIsActive() && goronGameTargetsRemaining() == 0
        && goronGameTime() <= goronTimeLimit * 30 // The time is stored as frames; assumes 30 FPS.
)

cannonScoreTarget = 2640
function CannonGameDisplayIsActive() => obyte(0x233f0c)
function cannonGameState() => odword(0x233f1c)
function cannonGameCountdown() => odword(0x233f18)
function cannonGameScore() => odword(0x11f548)
function cannonGameDisplaySize() => obyte(0x233f15)
function CannonGameStarted() => once(cannonGameCountdown() == 0x3 && Delta(cannonGameDisplaySize()) == 0x10)
achievement(title = "Action Port", points = 10,
    description = "Get a score of " + cannonScoreTarget + " in the cannon minigame.",
    trigger = never(!IsInLocation("CannonMinigame")) && CannonGameStarted()
        && never(cannonGameCountdown() == 0x4)
        && cannonGameScore() >= cannonScoreTarget
)

function trainingPointsInCurrentGame() => oword(0x267164)
function trainingTimesHitInCurrentGame() => obyte(0x26716a)
achievement(title = "Second Intention", points = 5,
    description = "Score a total of 90 hits in a row during training without getting hit yourself.",
    trigger = never(!IsInLocation("Traveler2")) && never(Delta(trainingTimesHitInCurrentGame()) < trainingTimesHitInCurrentGame())
        && repeated(90, Delta(trainingPointsInCurrentGame()) < trainingPointsInCurrentGame()) && never(trainingPointsInCurrentGame() == 0)
)

function quiverUpgrades() => obyte(0x1ba590)
function bombUpgrades() => obyte(0x1ba592)
function bombchuUpgrades() => obyte(0x1ba594)
achievement(title = "Armed to the Teeth", points = 10,
    description = "Get all bomb, Bombchu, and quiver upgrades.",
    trigger = quiverUpgrades() == 2 && bombUpgrades() == 2 && WasValueSetInGame(bombchuUpgrades(), 1, 2)
        || quiverUpgrades() == 2 && WasValueSetInGame(bombUpgrades(), 1, 2) && bombchuUpgrades() == 2
        || WasValueSetInGame(quiverUpgrades(), 1, 2) && bombUpgrades() == 2 && bombchuUpgrades() == 2
)

achievement(title = "Heartthrob", points = 10,
    description = "Collect all thirteen Heart Containers.",
    trigger = WasValueSetInGame(maxHp(), 0x3c, 0x40)
)

function phantomHourglassMaxTime() => odword(0x1ba4e8)
maxTime = 25 * 3600
achievement(title = "The Sands of Time", points = 10,
    description = "Fill the Phantom Hourglass with 25 minutes' worth of Sand of Hours.",
    trigger = Delta(phantomHourglassMaxTime()) < maxTime && measured(phantomHourglassMaxTime() == maxTime) && IsInGame()
)

treasureMaps = [
    obit4(0x1ba610), obit7(0x1ba610),
    obit0(0x1ba611), obit2(0x1ba611), obit5(0x1ba611), obit7(0x1ba611),
    obit3(0x1ba612), obit4(0x1ba612), obit6(0x1ba612),
    obit4(0x1ba613), obit5(0x1ba613)
]

treasureMapConditions = {}
i = 0

for map in treasureMaps
{
    treasureMapConditions[i] = { "countsWhen": (map == 1), "recalculateWhen": (Delta(map) != map) }
    i = i + 1
}

GenerateSaveProtectedAchievementFromConditions({
    "name": "Rookie Cartographer",
    "description": "Collect three treasure maps.",
    "points": 3,
    "threshold": 3
}, treasureMapConditions)

GenerateSaveProtectedAchievementFromConditions({
    "name": "Regular Cartographer",
    "description": "Collect seven treasure maps.",
    "points": 5,
    "threshold": 7
}, treasureMapConditions)

GenerateSaveProtectedAchievementFromConditions({
    "name": "Veteran Cartographer",
    "description": "Collect fifteen treasure maps.",
    "points": 10,
    "threshold": 15
}, treasureMapConditions)

GenerateSaveProtectedAchievementFromConditions({
    "name": "Legendary Cartographer",
    "description": "Collect all thirty-one treasure maps.",
    "points": 25,
    "threshold": 31
}, treasureMapConditions)

// End Sea Chart achievements

// Begin island achievement
islands = [
    obyte(0x1b4c64), // Zauz's Island
    obyte(0x1b4d2c), // Dee Ess Island
    obyte(0x1b4bec), // Spirit Island
    obyte(0x1b4c8c) // Uncharted Island
]

islandConditions = {}
i = 0

for island in islands
{
    islandConditions[i] = { "countsWhen": (island == 1), "recalculateWhen": (Delta(island) != island) }
    i = i + 1
}

GenerateSaveProtectedAchievementFromConditions({
    "name": "World Explorer",
    "description": "Discover all uncharted islands.",
    "points": 10,
    "threshold": 6
}, islandConditions)

// End island achievement

// Begin fish achievement
fishes = [
    obyte(0x1ba574), // Skippyjacks
    obyte(0x1ba575), // Toonas
    obyte(0x1ba576), // Loovars
    obyte(0x1ba577), // Rusty swordfish
    obyte(0x1ba578), // Neptoona
    obyte(0x1ba579) // Stowfish
]

fishConditions = {}
i = 0

for fish in fishes
{
    fishConditions[i] = { "countsWhen": (fish > 0), "recalculateWhen": (Delta(fish) != fish) }
    i = i + 1
}

GenerateSaveProtectedAchievementFromConditions({
    "name": "Angler of Renown",
    "description": "Catch all types of fish.",
    "points": 10,
    "threshold": 6
}, fishConditions)

// End fish achievement

// Begin frog achievement
frogs = [
    obit1(0x1b5563) // Northwestern 1
]

frogConditions = {}
i = 0

for frog in frogs
{
    frogConditions[i] = { "countsWhen": (frog == 1), "recalculateWhen": (Delta(frog) != frog) }
    i = i + 1
}

GenerateSaveProtectedAchievementFromConditions({
    "name": "Gale Treader",
    "description": "Find all six Golden Frogs.",
    "points": 10,
    "threshold": 6
}, frogConditions)

// End fish achievement

leaderboard(title = "Time Attack - Cyclok", description = "Defeat Cyclok as quickly as you can.",
    start = once(IsInLocation("Cyclok") && WasInLocation("TempleOfWind")) && CyclokStarted(),
    cancel = !IsInLocation("Cyclok"),
    submit = IsCyclokDying(),
    value = measured(TimeAdvancedAgainstCyclok())
)

leaderboard(title = "Time Attack - Eox", description = "Defeat Eox as quickly as you can.",
    start = once(IsInLocation("Eox") && WasInLocation("Mutoh")) && EoxStarted(),
    cancel = !IsInLocation("Eox"),
    submit = IsEoxDying(),
    value = measured(TimeAdvancedAgainstEox())
)

leaderboard(title = "Goron Game", description = "Finish the Goron Game in the fastest time you can.",
    start = IsInLocation("DS") && goronGameState() != 0xffffffff && goronGameCountdown() == 0x3,
    cancel = !IsInLocation("DS"),
    submit = GoronGameDisplayIsActive() && goronGameTargetsRemaining() == 0,
    value = goronGameTime() * 2
)

leaderboard(title = "Cannon Game", description = "Get the highest score you can.",
    start = IsInLocation("CannonMinigame") && CannonGameStarted(),
    cancel = !IsInLocation("CannonMinigame"),
    submit = cannonGameCountdown() == 0x4,
    value = cannonGameScore()
)

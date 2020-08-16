// Legend of Zelda, The: Phantom Hourglass
// #ID = 14323

// The global offset has not been found and may not be found for a while. However, we're designing the script with potential multilanguage support
// in mind early to limit the pain to implement later.
function GetGlobalOffset() => 0x0

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
    return once(Delta(bit) != bit && bit == 1)
        && never(IsLoadingSaveFile())
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

// $0ee520: 0x1 = in game, more or less. Seems to be 0 during the opening cutscenes, but that's probably fine for our purposes.
function IsLoadingSaveFile() => obyte(0x0ee520) == 0x0

// $1b2e20: Current location (US)
function currentLocation() => obyte(0x1b2e20)

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
    0x11: { "id": 0x11, "name": "West Exit Bus Terminal", },
    0x12: { "id": 0x12, "name": "Station Underpass", },
}

achievement(title = "Permission Shmermission", points = 1,
    description = "Learn swordplay from Oshus after raiding his storage.",
    trigger = WasBitflagSetInGame(learnedSwordplay())
)

mapLookup = {}
for i in locations {
    location = locations[i]
    mapLookup[i] = location["name"]
}

rich_presence_conditional_display(obyte(0x1B2E60) == 0x00, "In the Titlescreen")

rich_presence_conditional_display(obyte(0x1B2E60) == 0x00, "In the File Select")

rich_presence_display("Link is {0} [❤️{1}] [💰{2}]",
    rich_presence_lookup("map", obyte(0x1B2E60), mapLookup, fallback="somewhere"),
    rich_presence_value("num", obyte(0x1BA388) / 4),
    rich_presence_value("num", rupees())
)

// ~Hack~ Legend of Zelda, The: Master of Time
// #ID = 16509

// Utility

function Delta(addr) => prev(addr)

function Min(x, y)
{
    if (x > y)
    {
        return x
    }
    else
    {
        return y
    }
}

function IsBitflagSetInGame(bit)
{
    return IsValueSetInGame(bit, 0, 1)
}

function WasBitflagSetInGame(bit)
{
    return WasValueSetInGame(bit, 0, 1)
}

function IsValueSetInGame(bit)
{
    return IsValueSet(bit, 0, 1)
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

function IsLoadingSaveFile() => Delta(status()) == 2 && status() == 0 || status() == 1 || status() == 2

// $11A5D0: Entrance ID (16-bit)
function entranceId() => word(0x11A5D0)

// $11A5F4: Save file name, character 4 (8-bit)
function char4() => byte(0x11A5F4)

// $11A5F5: Save file name, character 3 (8-bit)
function char3() => byte(0x11A5F5)

// $11A5F6: Save file name, character 2 (8-bit)
function char2() => byte(0x11A5F6)

// $11A5F7: Save file name, character 1 (8-bit)
function char1() => byte(0x11A5F7)

// $11A5F8: Save file name, character 8 (8-bit)
function char8() => byte(0x11A5F8)

// $11A5F9: Save file name, character 7 (8-bit)
function char7() => byte(0x11A5F9)

// $11A5FA: Save file name, character 6 (8-bit)
function char6() => byte(0x11A5FA)

// $11A5FB: Save file name, character 5 (8-bit)
function char5() => byte(0x11A5FB)

function rupees() => word(0x11a606)

// $11b92c: 00: Boot, Gameplay
//          01: Title Screen
//          02: File select
function status() => byte(0x11b92c)

// $11B4A7: Bit 5: Sagnol Village cutscene (first time exiting the inn)
// $11B4F9: Bit 0: Magic Jar (first time)
// $1CA1D8: Chest flags for the current area
// $11a642: Top 4: Shield equipped
function shield() => high4(0x11a642)
function HasShieldEquipped() => shield() > 0

// $11a6a2: Gold Skulltula tokens collected (16-bit)
function goldSkulltulas() => word(0x11a6a2)

// This function allows the creation of achievements with built-in save protection that deal with a collection of values being set
// throughout the game. The schemas for both parameters are as follows:
//
// cheevo: "name": title
//         "description": self-explanatory
//         "points": self-explanatory
//         "threshold": how many values in the "addresses" dictionary must be set before this achievement is triggered
//         "id": the ID of the achievement on the RA server
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

    achievement(title = cheevo["name"], description = cheevo["description"], points = cheevo["points"], id = cheevo["id"],
        trigger = !IsLoadingSaveFile() && never(IsBooting())
            && measured(tally(cheevo["threshold"], totalCounts)) && unless(tally(cheevo["threshold"], loadedCounts))
            && never(resetAlt)
    )
}

function SlotHasBottleItem(mem)
{
    return mem >= 0x14 && mem <= 0x20
}

function WasItemSlotFilled(mem)
{
    return Delta(mem) == 0xff && mem != 0xff
}

function areaId() => word(0x1c8546)

locations = [
{ "name": "Sagnol Village", "id": 0x28, "conj": "in", },
{ "name": "Sagnol Village", "id": 0x2b, "conj": "in", },
{ "name": "Sagnol Village Shop", "id": 0x2d, "conj": "browsing the", },
{ "name": "Scrub Cliff", "id": 0x29, "conj": "climbing", },
{ "name": "Sagnol Village Inn", "id": 0x34, "conj": "visiting", },
{ "name": "Path of Gods", "id": 0x4a, "conj": "walking the", },
{ "name": "Sagnol Tomb", "id": 0x2a, "conj": "raiding the", },
{ "name": "Title Screen", "id": 0x27, "conj": "", },
{ "name": "Song Cave", "id": 0x3e, "conj": "in the", },
{ "name": "Temple of Agility Boss Room", "id": 0x11, "conj": "in the", },
{ "name": "Abello Field", "id": 0x1f, "conj": "in", },
{ "name": "a grotto in Abello Field", "id": 0x3e, "conj": "in", },
{ "name": "Abello Field", "id": 0x46, "conj": "in", },
{ "name": "Abello Field", "id": 0x32, "conj": "in", },
{ "name": "Abello gatehouse", "id": 0x21, "conj": "in an", },
{ "name": "Abello Sewers", "id": 0x8, "conj": "in the", },
{ "name": "Abello Lake", "id": 0x36, "conj": "at", },
{ "name": "Canyon", "id": 0x4e, "conj": "at the", },
{ "name": "Temple of Strength", "id": 0x1, "conj": "in the", },
{ "name": "Temple of Agility Boss Room", "id": 0x0, "conj": "in the", },
{ "name": "Abello Town", "id": 0x39, "conj": "in", },
{ "name": "Abello Shooting Gallery", "id": 0x42, "conj": "at the", },
{ "name": "Abello Town", "id": 0x26, "conj": "somewhere in", },
{ "name": "???", "id": 0x23, "conj": "in", },
{ "name": "Abello Town Tavern", "id": 0x33, "conj": "at the", },
{ "name": "Bazaar", "id": 0x2c, "conj": "at the", },
{ "name": "Bombchu Bowling Alley", "id": 0x4b, "conj": "at the", },
{ "name": "Abello Castle", "id": 0x1e, "conj": "at", },
{ "name": "Abello Castle", "id": 0x45, "conj": "inside", },
{ "name": "Abello Castle", "id": 0x5c, "conj": "deep inside", },
{ "name": "Zora Lair", "id": 0x22, "conj": "at", },
{ "name": "Zora Lair shop", "id": 0x2f, "conj": "at the", },
]

function GetLocationByName(name)
{
    for location in locations
    {
        if (location["name"] == name)
        {
            return location
        }
    }
}

function GetLocationById(id)
{
    for location in locations
    {
        if (location["id"] == id)
        {
            return location
        }
    }
}

function IsInLocation(name)
{
    location = GetLocationByName(name)
    return areaId() == location["id"]
}


achievement(title = "Save Protection Test", description = "If this pops when the game loads, save protection is broken.", points = 0,
    trigger = DidValueBecomeGreaterThanGivenInGame(rupees(), 0) || DidValueBecomeGreaterThanGivenInGame(goldSkulltulas(), 0)
)

function currentAreaChestBuffer() => byte(0x1ca1d8)
chestFlags = {
    "medicine": { "storage": 0x11ab58, "buffer": 0x1ca1d8, "bit": 7 }
}

medicineChest = chestFlags["medicine"]
achievement(title = "Are You Proud of Yourself?", description = "Raid the chest in the sleeping man's room in Sagnol Village.", points = 1,
    trigger = WasBitflagSetInGame(bit(medicineChest["bit"], medicineChest["buffer"])) && unless(bit(medicineChest["bit"], medicineChest["storage"]) == 1)
)

function bottle1() => byte(0x11a655)
function bottle2() => byte(0x11a654)
function bottle3() => byte(0x11a65b)
function bottle4() => byte(0x11a65a)
achievement(title = "Take One Down, Pass It Around", description = "Obtain four bottles.", points = 10,
    // All bottle slots have to be filled with a bottle item, and any one of those slots must have just been an empty slot.
    trigger = SlotHasBottleItem(bottle1()) && SlotHasBottleItem(bottle2()) && SlotHasBottleItem(bottle3()) && SlotHasBottleItem(bottle4()) && 
        (WasItemSlotFilled(bottle1()) || WasItemSlotFilled(bottle2()) || WasItemSlotFilled(bottle3()) || WasItemSlotFilled(bottle4()))
        && never(IsLoadingSaveFile())
)

skulltulaCheevos = [
    { "name": "Rookie Exterminator", "points": 3, "threshold": 10 },
    { "name": "Regular Exterminator", "points": 5, "threshold": 25 },
    { "name": "Veteran Exterminator", "points": 10, "threshold": 50 },
    { "name": "Legendary Exterminator", "points": 25, "threshold": 100 },
]

for cheevo in skulltulaCheevos
{
    achievement(title = cheevo["name"], points = cheevo["points"], description = "Collect " + cheevo["threshold"] + " Gold Skulltula tokens.",
        trigger = Delta(goldSkulltulas()) == cheevo["threshold"] - 1 && measured(goldSkulltulas() == cheevo["threshold"]) && never(IsLoadingSaveFile())
    )
}

function bracelet() => bit6(0x11a670)
achievement(title = "Nighthawk", points = 3, description = "Obtain the bracelet from the Sagnol Tomb.",
    trigger = WasBitflagSetInGame(bracelet())
)

function maxHP() => word(0x11a5fc)
achievement(title = "Heartthrob", points = 25, description = "Complete and obtain seventeen Heart Containers.",
    trigger = WasValueSetInGame(maxHP(), 0x130, 0x140)
)

// We need to check for both here in case the player leaves the room immediately after entering; one of the flags is set upon leaving, for some reason.
function stalfosChestAppearFlag() => bit0(0x1ca1e0)
function stalfosChestFlag() => bit0(0x1ca1dc)
achievement(title = "No Guard [m]", points = 10, description = "Defeat the Stalfos in the Temple of Agility without having a shield equipped.",
    trigger = never(!IsInLocation("Temple of Agility Boss Room")) && WasBitflagSetInGame(stalfosChestAppearFlag()) && WasBitflagSetInGame(stalfosChestFlag()) && !HasShieldEquipped()
)

function stoneOfAgility() => bit2(0x11a676)
achievement(title = "Swift Run", points = 5, description = "Acquire the Stone of Agility",
    trigger = WasBitflagSetInGame(stoneOfAgility())
)

function ShootingGalleryGameIsOver() => byte(0x1e3326) == 2
function ArrowsRemainingInShootingGalleryGame() => byte(0x1da2ff) - 1
function shootingGalleryScore() => byte(0x1e3324)
achievement(title = "Sniper of Legend", points = 10, description = "Get a perfect score at the Abello Shooting Gallery using at most eleven arrows.",
    trigger = IsInLocation("Abello Shooting Gallery") && ShootingGalleryGameIsOver() && ArrowsRemainingInShootingGalleryGame() >= 4 && shootingGalleryScore() == 0xa
)

function abelloSong() => bit3(0x11a675)
achievement(title = "Thievery Rewarded", points = 3, description = "Learn Abello's Song from King Routelika.",
    trigger = WasBitflagSetInGame(abelloSong())
)

// RICH PRESENCE
function IsOutsideGameplay() => status() != 0
function GetCharactersForRichPresence()
{
    characters = {
        0xab: "A",
        0xac: "B",
        0xad: "C",
        0xae: "D",
        0xaf: "E",
        0xb0: "F",
        0xb1: "G",
        0xb2: "H",
        0xb3: "I",
        0xb4: "J",
        0xb5: "K",
        0xb6: "L",
        0xb7: "M",
        0xb8: "N",
        0xb9: "O",
        0xba: "P",
        0xbb: "Q",
        0xbc: "R",
        0xbd: "S",
        0xbe: "T",
        0xbf: "U",
        0xc0: "V",
        0xc1: "W",
        0xc2: "X",
        0xc3: "Y",
        0xc4: "Z",
        0xc5: "a",
        0xc6: "b",
        0xc7: "c",
        0xc8: "d",
        0xc9: "e",
        0xca: "f",
        0xcb: "g",
        0xcc: "h",
        0xcd: "i",
        0xce: "j",
        0xcf: "k",
        0xd0: "l",
        0xd1: "m",
        0xd2: "n",
        0xd3: "o",
        0xd4: "p",
        0xd5: "q",
        0xd6: "r",
        0xd7: "s",
        0xd8: "t",
        0xd9: "u",
        0xda: "v",
        0xdb: "w",
        0xdc: "x",
        0xdd: "y",
        0xde: "z",
        0x1: "1",
        0x2: "2",
        0x3: "3",
        0x4: "4",
        0x5: "5",
        0x6: "6",
        0x7: "7",
        0x8: "8",
        0x9: "9",
        0x0: "0",
        0xea: ".",
        0xe4: "-",
    }
    return characters
}

function GetLocationsForRichPresence()
{
    rpLocations = {}
    for location in locations
    {
        rpLocations[location["id"]] = location["conj"] + " " + location["name"]
    }
    return rpLocations
}

rich_presence_conditional_display(IsOutsideGameplay(), "Title Screen/Main Menu")

rich_presence_display("{0}{1}{2}{3}{4}{5}{6}{7} is {8}",
    rich_presence_lookup("Characters", char1(), GetCharactersForRichPresence()),
    rich_presence_lookup("Characters", char2(), GetCharactersForRichPresence()),
    rich_presence_lookup("Characters", char3(), GetCharactersForRichPresence()),
    rich_presence_lookup("Characters", char4(), GetCharactersForRichPresence()),
    rich_presence_lookup("Characters", char5(), GetCharactersForRichPresence()),
    rich_presence_lookup("Characters", char6(), GetCharactersForRichPresence()),
    rich_presence_lookup("Characters", char7(), GetCharactersForRichPresence()),
    rich_presence_lookup("Characters", char8(), GetCharactersForRichPresence()),
    rich_presence_lookup("Locations", areaId(), GetLocationsForRichPresence(), "somewhere in the world")
)
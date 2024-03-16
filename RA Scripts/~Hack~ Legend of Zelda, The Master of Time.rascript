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

function musicId() => word(0x124e54)

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

function equippedTunic() => low4(0x11a643)

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
function actualAreaId() => word(0x120c42)

locations = [
{ "name": "Sagnol Village", "id": 0x28, "conj": "in", },
{ "name": "Sagnol Village (indoors)", "id": 0x2b, "conj": "in", },
{ "name": "Sagnol Village Shop", "id": 0x2d, "conj": "browsing the", },
{ "name": "Scrub Cliff", "id": 0x29, "conj": "climbing", },
{ "name": "Sagnol Village Inn", "id": 0x34, "conj": "visiting the", },
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
{ "name": "Temple of Agility", "id": 0x0, "conj": "in the", },
{ "name": "Abello Town", "id": 0x39, "conj": "in", },
{ "name": "Abello Shooting Gallery", "id": 0x42, "conj": "at the", },
{ "name": "Abello Town", "id": 0x26, "conj": "somewhere in", },
{ "name": "Abello Town butcher shop", "id": 0x23, "conj": "in the", },
{ "name": "Abello Town Tavern", "id": 0x33, "conj": "at the", },
{ "name": "Abello Town Bazaar", "id": 0x2c, "conj": "at the", },
{ "name": "Bombchu Bowling Alley", "id": 0x4b, "conj": "at the", },
{ "name": "Abello Castle", "id": 0x1e, "conj": "at", },
{ "name": "Abello Castle", "id": 0x45, "conj": "inside", },
{ "name": "Abello Castle", "id": 0x5c, "conj": "deep inside", },
{ "name": "Zora Lair", "id": 0x22, "conj": "at", },
{ "name": "Zora Lair shop", "id": 0x2f, "conj": "at the", },
{ "name": "Coastal Fortress", "id": 0x3a, "conj": "at the", },
{ "name": "Kalki’s Forest", "id": 0x37, "conj": "in", },
{ "name": "Kalki’s Forest", "id": 0x40, "conj": "deep inside", },
{ "name": "Patrick’s Manor", "id": 0x3, "conj": "in", },
{ "name": "Abello Castle Hospital", "id": 0x31, "conj": "in the", },
{ "name": "somewhere damp", "id": 0x2, "conj": "", },
{ "name": "Goron Cave", "id": 0x38, "conj": "in", },
{ "name": "Goron Cave shop", "id": 0x23, "conj": "in the", },
{ "name": "Moblin’s Lair", "id": 0x3f, "conj": "at", },
{ "name": "Moblin’s Lair", "id": 0x20, "conj": "at", },
{ "name": "confronting his fate", "id": 0x5f, "conj": "", },
{ "name": "Temple of Wisdom", "id": 0x30, "conj": "in the", },
{ "name": "Fire Temple", "id": 0x4, "conj": "in the", },
{ "name": "Fire Temple", "id": 0x15, "conj": "in the", },
{ "name": "Temple of Strength", "id": 0x12, "conj": "in the", },
{ "name": "Temple of Strength", "id": 0x60, "conj": "in the", },
{ "name": "house by Abello Lake", "id": 0x1c, "conj": "in the", },
{ "name": "Lozan", "id": 0x41, "conj": "in", },
{ "name": "Ice Cavern", "id": 0x9, "conj": "in the", },
{ "name": "Lozan Castle", "id": 0x4c, "conj": "in", },
{ "name": "Lozan Castle", "id": 0x4d, "conj": "at", },
{ "name": "Death Temple", "id": 0x5, "conj": "in the", },
{ "name": "Lozan Jail", "id": 0x48, "conj": "in the", },
{ "name": "bomb factory at the Canyon", "id": 0x1b, "conj": "in the", },
{ "name": "Bombchu shop in the Canyon", "id": 0x24, "conj": "at the", },
{ "name": "Coastal Fortress", "id": 0xb, "conj": "inside the", },
{ "name": "Jafre Desert", "id": 0x50, "conj": "in", },
{ "name": "Light Temple", "id": 0x6, "conj": "in the", },
{ "name": "Light Temple", "id": 0x17, "conj": "in the", },
{ "name": "Water Temple", "id": 0x7, "conj": "in the", },
{ "name": "Water Temple", "id": 0x18, "conj": "in the", },
{ "name": "?", "id": 0x25, "conj": "in", },
{ "name": "edge of the world", "id": 0x5e, "conj": "at the", },
{ "name": "Space Link", "id": 0x3c, "conj": "playing", },
{ "name": "Defenseless", "id": 0x10, "conj": "playing", },
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

function GenerateChestAchievement(id, name, description, points, chestInfo, badge, addlLogic)
{
    achievement(title = name, description = description, points = points, badge = badge, id = id,
        trigger = WasBitflagSetInGame(bit(chestInfo["bit"], chestInfo["buffer"])) && unless(bit(chestInfo["bit"], chestInfo["storage"]) == 1) && addlLogic
    )
}


function currentAreaChestBuffer() => byte(0x1ca1d8)
chestFlags = {
    "medicine": { "storage": 0x11ab58, "buffer": 0x1ca1d8, "bit": 7 },
    "Giant's Knife": { "storage": 0x11aa78, "buffer": 0x1ca1d8, "bit": 1 }
}

GenerateChestAchievement(
    id = 133579,
    name = "Are You Proud of Yourself?",
    description = "Raid the chest in the sleeping man's room in Sagnol Village.",
    points = 1,
    chestInfo = chestFlags["medicine"],
    badge = "147845",
    addlLogic = never(!IsInLocation("Sagnol Village (indoors)"))
)

function bottle1() => byte(0x11a655)
function bottle2() => byte(0x11a654)
function bottle3() => byte(0x11a65b)
function bottle4() => byte(0x11a65a)
achievement(title = "Take One Down, Pass It Around", description = "Obtain four bottles.", points = 25,
    // All bottle slots have to be filled with a bottle item, and any one of those slots must have just been an empty slot.
    trigger = SlotHasBottleItem(bottle1()) && SlotHasBottleItem(bottle2()) && SlotHasBottleItem(bottle3()) && SlotHasBottleItem(bottle4()) && 
        (WasItemSlotFilled(bottle1()) || WasItemSlotFilled(bottle2()) || WasItemSlotFilled(bottle3()) || WasItemSlotFilled(bottle4()))
        && never(IsLoadingSaveFile())
)

skulltulaCheevos = [
    { "name": "Rookie Exterminator", "points": 3, "threshold": 10 },
    { "name": "Regular Exterminator", "points": 5, "threshold": 25 },
    { "name": "Veteran Exterminator", "points": 10, "threshold": 50 },
    { "name": "Legendary Exterminator", "points": 50, "threshold": 100 },
]

for cheevo in skulltulaCheevos
{
    achievement(title = cheevo["name"], points = cheevo["points"], description = "Collect " + cheevo["threshold"] + " Gold Skulltula tokens.",
        trigger = Delta(goldSkulltulas()) == cheevo["threshold"] - 1 && measured(goldSkulltulas() == cheevo["threshold"]) && never(IsLoadingSaveFile())
    )
}

function braceletAndGauntletAddr() => 0x11a670
function bracelet() => bit6(braceletAndGauntletAddr())
achievement(title = "Nighthawk", points = 3, description = "Obtain the bracelet from the Sagnol Tomb.",
    trigger = WasBitflagSetInGame(bracelet()) && never(bit7(braceletAndGauntletAddr()) == 1)
)

achievement(title = "I Have the Power!", points = 10, description = "Obtain the Golden Gauntlets.",
    trigger = WasBitflagSetInGame(bracelet()) && never(bit7(braceletAndGauntletAddr()) == 0)
)

function quiverAddr() => 0x11a670
function largestQuiver() => bit0(quiverAddr())
achievement(title = "To Blot out the Sun", points = 10, description = "Obtain the Biggest Quiver.",
    trigger = WasBitflagSetInGame(largestQuiver()) && never(bit1(quiverAddr()) == 0)
)

function maxHP() => word(0x11a5fc)
achievement(title = "Heartthrob", points = 50, description = "Have a total of 20 hearts' worth of life energy.",
    trigger = WasValueSetInGame(maxHP(), 0x130, 0x140)
)

// We need to check for both here in case the player leaves the room immediately after entering; one of the flags is set upon leaving, for some reason.
function stalfosChestAppearFlag() => bit0(0x1ca1e0)
function stalfosChestFlag() => bit0(0x1ca1dc)
achievement(title = "No Guard [m]", points = 10, description = "Defeat the Stalfos in the Temple of Agility without having a shield equipped.",
    trigger = never(!IsInLocation("Temple of Agility Boss Room")) && WasBitflagSetInGame(stalfosChestAppearFlag()) && WasBitflagSetInGame(stalfosChestFlag())
        && !HasShieldEquipped()
)

function stoneOfAgility() => bit2(0x11a676)
achievement(title = "Swift Run", points = 5, description = "Acquire the Stone of Agility.",
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

function lensOfTruthSlot() => byte(0x11a652)
achievement(title = "Peering from the Shadows", points = 10, description = "Retrieve the Lens of Truth from the sewers.",
    trigger = WasValueSetInGame(lensOfTruthSlot(), 0xff, 0xf)
)

function masterSong() => bit4(0x11a675)
achievement(title = "Tale as Old as Time", points = 3, description = "Learn the Master Song.",
    trigger = WasBitflagSetInGame(masterSong())
)

function preludeOfForest() => bit6(0x11a674)
achievement(title = "First Step Towards a Jailbreak", points = 3, description = "Learn the Prelude of Forest.",
    trigger = WasBitflagSetInGame(preludeOfForest())
)

function hookshotSlot() => byte(0x11a64e)
achievement(title = "The Hooks!", points = 3, description = "Obtain the Hookshot.",
    trigger = WasValueSetInGame(hookshotSlot(), 0xff, 0xa)
)

achievement(title = "More Hooks!", points = 10, description = "Upgrade your Hookshot to the Longshot.",
    trigger = WasValueSetInGame(hookshotSlot(), 0xa, 0xb)
)

function faroresWindSlot() => byte(0x11a64c)
achievement(title = "Old Kokiri Magic", points = 5, description = "Learn the Skull Kid's Wind spell.",
    trigger = WasValueSetInGame(faroresWindSlot(), 0xff, 0xd)
)

function forestMedallion() => bit0(0x11a674)
achievement(title = "Empty Cells", points = 10, description = "Rescue the imprisoned Kokiri and obtain the Forest Medallion.",
    trigger = WasBitflagSetInGame(forestMedallion())
)

function fireMedallion() => bit1(0x11a674)
achievement(title = "Vengeance for the Gorons", points = 10, description = "Obtain the Fire Medallion.",
    trigger = WasBitflagSetInGame(fireMedallion())
)

GenerateChestAchievement(
    id = 133594,
    name = "Remains of a Butcher",
    description = "Open the chest in the basement of the butcher shop in Abello Town.",
    points = 5,
    chestInfo = chestFlags["Giant's Knife"],
    badge = "147860",
    addlLogic = never(!IsInLocation("Abello Town butcher shop"))
)

function iceArrowSlot() => byte(0x11a64d)
achievement(title = "Frozen Flesh", points = 10, description = "Obtain the Ice Arrows.",
    trigger = WasValueSetInGame(iceArrowSlot(), 0xff, 0xc)
)

function moblinMarch() => bit7(0x11a674)
achievement(title = "One, Two, One, Two", points = 3, description = "Learn the Moblin March.",
    trigger = WasBitflagSetInGame(moblinMarch())
)

function badEnding() => bit4(0x11b4b1)
achievement(title = "A Quick Drop", points = 10, description = "Unlock the bad ending.",
    trigger = WasBitflagSetInGame(badEnding()) && IsInLocation("confronting his fate") && musicId() == 0x3f // The "music ID" is checked to trigger the cheevo on the last shot.
)

function stoneOfWisdom() => bit4(0x11a676)
achievement(title = "Outsmarting a Goddess", points = 10, description = "Acquire the Stone of Wisdom.",
    trigger = WasBitflagSetInGame(stoneOfWisdom())
)

function flareDancerDefeate() => bit7(0x1ca1dc)
function GoronTunicIsEquipped() => equippedTunic() == 2
achievement(title = "My Bow Runs Hot [m]", points = 10, description = "Defeat any Flare Dancer in the Fire Temple without the Goron Tunic equipped.",
    trigger = once(Delta(musicId()) == 0x67 && musicId() == 0x38) // Checkpoint for when the battle with the flare Dancer begins.
        && Delta(musicId()) == 0x38 && musicId() == 0x67 // Trigger when the battle ends.
        && WasBitflagSetInGame(flareDancerDefeate())
        && never(!IsInLocation("Fire Temple") || GoronTunicIsEquipped())
)

function bombBagObtained() => bit3(0x11a670)
achievement(title = "One Errant Twitch...", points = 5, description = "Obtain the Bomb Bag.",
    trigger = WasBitflagSetInGame(bombBagObtained())
)

function stoneOfStrength() => bit3(0x11a676)
achievement(title = "Blood and Tears", points = 10, description = "Acquire the Stone of Strength.",
    trigger = WasBitflagSetInGame(stoneOfStrength())
)

function bombchuBowlingState() => byte(0x0eb24d)
function bombchusRemainingInBowling() => byte(0x1da2fe)
achievement(title = "No-Tap", points = 10, description = "Win a game at the Bombchu Bowling Alley using no more than six Bombchus.",
    trigger = IsInLocation("Bombchu Bowling Alley") && bombchuBowlingState() == 2 && bombchusRemainingInBowling() >= 4
)

function requiemOfIce() => bit0(0x11a675)
achievement(title = "Anthem of a Fallen Kingdom", points = 3, description = "Learn the Requiem of Ice.",
    trigger = WasBitflagSetInGame(requiemOfIce())
)

function iceMedallion() => bit2(0x11a674)
achievement(title = "Snowy Fate", points = 10, description = "Obtain the Ice Medallion.",
    trigger = WasBitflagSetInGame(iceMedallion())
)

function hoverBoots() => bit6(0x11a66f)
achievement(title = "On Cloud Nine", points = 10, description = "Obtain the Hover Boots from the Lozan Jail.",
    trigger = WasBitflagSetInGame(hoverBoots())
)

function cowsLullaby() => bit5(0x11a675)
achievement(title = "Bovine Bliss", points = 5, description = "Learn the Cow's Lullaby.",
    trigger = WasBitflagSetInGame(cowsLullaby())
)

function bombchuSlot() => byte(0x11a64f)
achievement(title = "Boom Guy", points = 5, description = "Obtain Bombchus.",
    trigger = WasValueSetInGame(bombchuSlot(), 0xff, 0x9)
)

function dekuNutUpgrade() => bit5(0x11a672)
achievement(title = "You're Gonna Love My Nuts", points = 5, id = 133606, badge = "147872",
    description = "Upgrade your Deku Nut carrying capacity.",
    trigger = WasBitflagSetInGame(dekuNutUpgrade())
)

function desertCall() => bit1(0x11a675)
achievement(title = "Forty Years Wandering", points = 5, description = "Learn the Desert Call.",
    trigger = WasBitflagSetInGame(desertCall())
)

function mirrorShield() => bit6(0x11a66e)
achievement(title = "The Fairest One of All", points = 10, description = "Obtain the Mirror Shield.",
    trigger = WasBitflagSetInGame(mirrorShield())
)

function lightMedallion() => bit3(0x11a674)
achievement(title = "The Desert Rays", points = 10, description = "Obtain the Light Medallion.",
    trigger = WasBitflagSetInGame(lightMedallion())
)

function waterMedallion() => bit4(0x11a674)
achievement(title = "What's in That Water?", points = 10, description = "Obtain the Water Medallion.",
    trigger = WasBitflagSetInGame(waterMedallion())
)

function songOfStorms() => bit1(0x11a676)
achievement(title = "Enter the Tempest", points = 10, description = "Learn the Song of Storms.",
    trigger = WasBitflagSetInGame(songOfStorms())
)

function oceanVibes() => bit2(0x11a675)
achievement(title = "Towards the Tower", points = 10, description = "Learn the Ocean Vibes.",
    trigger = WasBitflagSetInGame(oceanVibes())
)

function trueEnding() => bit3(0x11b4b1)
achievement(title = "The Only Winning Move Is Not to Play", points = 25, description = "Unlock the 'good' ending.",
    trigger = WasBitflagSetInGame(trueEnding()) && IsInLocation("edge of the world") && musicId() == 0x3f // The "music ID" is checked to trigger the cheevo on the last shot.
)

function fightingScroll() => bit6(0x11a676)
achievement(title = "The Art of War", points = 10, description = "Obtain the Fighting Scroll.",
    trigger = WasBitflagSetInGame(fightingScroll())
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

rich_presence_conditional_display((IsOutsideGameplay() || actualAreaId() == 0), "Title Screen/Main Menu")

rich_presence_display("Link is {0}",
    rich_presence_lookup("Locations", areaId(), GetLocationsForRichPresence(), "somewhere in the world")
)
// World Ends with You, The
// #ID = 4887

// UTILITY

framesPerSecond = 60

function Delta(addr) => prev(addr)

function WasBitflagSetInGame(bit)
{
    return WasValueSetInGame(bit, 0, 1)
}

function WasValueSetInGame(mem, oldValue, newValue)
{
    return once(Delta(mem) == oldValue && mem == newValue)
        && never(IsLoadingSaveFile())
}

function DidValueBecomeGreaterThanGivenInGame(mem, value)
{
    return once(Delta(mem) <= value && mem > value) && never(IsLoadingSaveFile())
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

function SecondsToFrames(value)
{
    return value * framesPerSecond
}

// This function allows the creation of achievements with built-in save protection that deal with a collection of values being set
// throughout the game. The schemas for both parameters are as follows:
//
// cheevo: "name": title
//         "description": self-explanatory
//         "points": self-explanatory
//         "threshold": how many values in the "addresses" dictionary must be set before this achievement is triggered
//
// conditions: "countsWhen": the condition that must be true in order for it to be counted in the total
//             "resetWhen": the condition that indicates that relevant values in the condition have changed, forcing the state to refresh
function GenerateSaveProtectedAchievementFromConditions(cheevo, conditions)
{
    counts = always_true()
    resetalt = always_false()

    for i in conditions
    {
        condition = conditions[i]
        counts = counts || once(condition["countsWhen"])
    
        // We want to reset the hit counts each time the resetWhen condition is true in order
        // to refresh the hitcount state that represents each individual condition.
        resetalt = resetalt || never(condition["resetWhen"]) && unless(IsLoadingSaveFile())
    }

    // However, we also don't want to do anything if no condition is changed on a given frame
    // as a save protection measure. A two-frame target is used for the same reason as the above, as well.
    unlessValueStatesAreIdle = unless(repeated(2, always_true()))

    achievement(title = cheevo["name"], description = cheevo["description"], points = cheevo["points"],
        trigger = isOnTitleScreen() == 0x0
            && measured(repeated(cheevo["threshold"], counts)) && unlessValueStatesAreIdle
            && resetalt
    ) 
}

// $074194: 0x1 = transitioning into game mode after clicking Adventure or Battle
function IsLoadingSaveFile() => Delta(isOnTitleScreen()) == 0x1 && isOnTitleScreen() == 0x0

function isOnTitleScreen() => byte(0x074194)

// $071D1C: Money (32-bit)
// $071D14: Current LV
function currentLevel() => byte(0x071D14)

// $071D28: Partner ID (8-bit)
//          
//          0x0 = Shiki
//          0x1 = Joshua
//          0x2 = Beat
function partner() => byte(0x071D28)

function GetPartnerByName(name)
{
    if (name == "Shiki")
    {
        return 0x0
    }
    else if (name == "Joshua")
    {
        return 0x1
    }
    else if (name == "Beat")
    {
        return 0x2
    }
    else
    {
        return 0xFF
    }
}

// $071d29: Bits 0-1: Difficulty
//          - 0x0 = Easy
//          - 0x1 = Medium
//          - 0x2 = Hard
//          - 0x3 = Ultimate
//          Bits 2-3: Partner behavior
//          Bits 4-7: Currently-equipped deck (2-bit)

function difficulty() => bit0(0x071d29) + bit1(0x071d29) + bit1(0x071d29) // Can't multiply by 2 because reasons.

function IsAtLeastOnDifficulty(value)
{
    if (value == "Easy")
    {
        return always_true()
    }
    else if (value == "Normal")
    {
        return difficulty() >= 0x1
    }
    else if (value == "Hard")
    {
        return difficulty() >= 0x2
    }
    else if (value == "Ultimate")
    {
        return difficulty() >= 0x3
    }
}

// $071D84: Deck 1, Slot 1, Pin ID (16-bit)
// $0737B8: ESP'er Points
// $0737c0: Chapter
function chapter() => byte(0x0737c0)

function currentShopkeeperFriendshipLevel() => byte(0x3a354c)
function currentShopkeeperFriendshipEXP() => word(0x3a355c)

function WasShopkeeperLeveledUpToLevel(level)
{
    return Delta(currentShopkeeperFriendshipLevel()) == level - 1 && currentShopkeeperFriendshipLevel() == level
        && currentShopkeeperFriendshipEXP() != 0xffff
}

chapters = {
0x0: { "id": 0x0, "name": "Shiki, Day 1", },
0x1: { "id": 0x1, "name": "Shiki, Day 2", },
0x2: { "id": 0x2, "name": "Shiki, Day 3", },
0x3: { "id": 0x3, "name": "Shiki, Day 4", },
0x4: { "id": 0x4, "name": "Shiki, Day 5", },
0x5: { "id": 0x5, "name": "Shiki, Day 6", },
0x6: { "id": 0x6, "name": "Shiki, Day 7", },
0x7: { "id": 0x7, "name": "Joshua, Day 1", },
0x8: { "id": 0x8, "name": "Joshua, Day 2", },
0x9: { "id": 0x9, "name": "Joshua, Day 3", },
0xA: { "id": 0xA, "name": "Joshua, Day 4", },
0xB: { "id": 0xB, "name": "Joshua, Day 5", },
0xC: { "id": 0xC, "name": "Joshua, Day 6", },
0xD: { "id": 0xD, "name": "Joshua, Day 7", },
0xE: { "id": 0xE, "name": "Beat, Day 1", },
0xF: { "id": 0xF, "name": "Beat, Day 2", },
0x10: { "id": 0x10, "name": "Beat, Day 3", },
0x11: { "id": 0x11, "name": "Beat, Day 4", },
0x12: { "id": 0x12, "name": "Beat, Day 5", },
0x13: { "id": 0x13, "name": "Beat, Day 6", },
0x14: { "id": 0x14, "name": "Beat, Day 7", },
0x15: { "id": 0x15, "name": "Another Day", },
}

function GetChapterByName(name)
{
    for i in chapters
    {
        chapter = chapters[i]
        if (chapter["name"] == name)
        {
            return chapters[i]
        }
    }
}

function CurrentChapterIs(name)
{
    chapter = GetChapterByName(name)
    return chapter() == chapter["id"]
}

// $073AA4: Play time (32-bit)
function playTime() => dword(0x073aa4)

// $07415C: Overworld x-coordinate (32-bit)
// $074160: Overworld y-coordinate (32-bit)
// $074168: Map ID (16-bit)
function mapId() => word(0x074168)

locations = {
    0x11: { "id": 0x11, "name": "West Exit Bus Terminal", },
0x12: { "id": 0x12, "name": "Station Underpass", },
0x0: { "id": 0x0, "name": "Spain Hill", },
0x1: { "id": 0x1, "name": "Scramble Crossing", },
0x2: { "id": 0x2, "name": "AMX", },
0x3: { "id": 0x3, "name": "104 Building", },
0x4: { "id": 0x4, "name": "Center Street Entrance", },
0x5: { "id": 0x5, "name": "Statue of Hachiko", },
0x6: { "id": 0x6, "name": "Tipsy Tose Hall", },
0x7: { "id": 0x7, "name": "Shibu-Q Heads", },
0x8: { "id": 0x8, "name": "Molco", },
0x9: { "id": 0x9, "name": "Udagawa Back Streets", },
0xa: { "id": 0xa, "name": "TEST", },
0xb: { "id": 0xb, "name": "Shibu Department Store", },
0xc: { "id": 0xc, "name": "Cadoi City", },
0xd: { "id": 0xd, "name": "Towa Records", },
0xe: { "id": 0xe, "name": "Miyashita Park", },
0xf: { "id": 0xf, "name": "Miyashita Park Underpass", },
0x10: { "id": 0x10, "name": "Cat Street", },
0x13: { "id": 0x13, "name": "Dogenzaka", },
0x14: { "id": 0x14, "name": "Pork City, 1st Floor", },
0x15: { "id": 0x15, "name": "A-East", },
0x16: { "id": 0x16, "name": "Shibukyu Main Store", },
0x17: { "id": 0x17, "name": "Concert Stage", },
0x18: { "id": 0x18, "name": "Pork City, 1st Floor", },
0x19: { "id": 0x19, "name": "Pork City, 2nd Floor", },
0x1a: { "id": 0x1a, "name": "Pork City, 3rd Floor", },
0x1b: { "id": 0x1b, "name": "Pork City, 4th Floor", },
0x1c: { "id": 0x1c, "name": "Pork City, 5th Floor", },
0x1d: { "id": 0x1d, "name": "Pork City, 6th Floor", },
0x1e: { "id": 0x1e, "name": "Pork City, 7th Floor", },
0x1f: { "id": 0x1f, "name": "Pork City, 8th Floor", },
0x20: { "id": 0x20, "name": "Pork City, 9th Floor", },
0x21: { "id": 0x21, "name": "Pork City, 10th Floor", },
0x22: { "id": 0x22, "name": "Pork City, 11th Floor", },
0x23: { "id": 0x23, "name": "Pork City, 12th Floor", },
0x24: { "id": 0x24, "name": "Pork City, 13th Floor", },
0x25: { "id": 0x25, "name": "Pork City, 1st Floor", },
0x26: { "id": 0x26, "name": "Trail of the Sinner", },
0x27: { "id": 0x27, "name": "Rubicon", },
0x28: { "id": 0x28, "name": "Trail of the Bygone", },
0x29: { "id": 0x29, "name": "Dead God’s Pad", },
0x2a: { "id": 0x2a, "name": "Trail of the Judged", },
0x2b: { "id": 0x2b, "name": "Room of Reckoning", },
0x2c: { "id": 0x2c, "name": "Trail of the Sinner, Roof", },
0x2d: { "id": 0x2d, "name": "Trail of the Sinner, Roof", },
0x2e: { "id": 0x2e, "name": "Trail of the Sinner, Roof", },
0x2f: { "id": 0x2f, "name": "Statue of Hachiko", },
0x30: { "id": 0x30, "name": ".....", },
0x31: { "id": 0x31, "name": "The mission!", },
0x32: { "id": 0x32, "name": "Missing No.", },
}

function GetLocationByName(name)
{
    for i in locations
    {
        location = locations[i]
        if (location["name"] == name)
        {
            return location
        }
    }
}

// RICH PRESENCE

function GetRPLookup(dict)
{
    ret = {}
    for i in dict
    {
        element = dict[i]
        ret[i] = element["name"]
    }
    return ret
}

rich_presence_conditional_display(isOnTitleScreen() == 0x1, "On the title screen")
rich_presence_display("{0} | {1} | Play Time: {2}",
    rich_presence_lookup("Chapter", chapter(), GetRPLookup(chapters)),
    rich_presence_lookup("Location", mapId(), GetRPLookup(locations)),
    rich_presence_value("Time", playTime(), "FRAMES")
)

// END RICH PRESENCE


// $074171: Bit 3: "Noise!?"
function noiseInterrobang() => bit3(0x074171)

function lengthOfBattleChain() => byte(0x074e54)

// $074E52: Current battle in the chain:
//
//          0x0 when first battle begins
//
//          Increases by 1 when you win a battle, and the chain is complete when this number is 1 greater than the total length of the chain.
function currentBattleInChain() => byte(0x074e52)
function WonBattle() => currentBattleInChain() == lengthOfBattleChain() + 1
function EnterBattleCheckpointValid() => once(battleTime() > 0 && Delta(battleTime()) == 0) && never(currentBattleInChain() == 0x0)
function WonBattleAndOnResultsScreen() => once(WonBattle()) && never(currentBattleInChain() == 0x0)

// $074E56: Enemy ID
function enemyId() => word(0x074e56)

enemies = {
"Metal Corehog": { "id": 0x7d, "name": "Metal Corehog", },
"Vespertilio Canor": { "id": 0x7, "name": "Vespertilio Canor", },
"Swing Shark": { "id": 0x81, "name": "Swing Shark", },
}

function GetEnemyByName(name)
{
    for i in enemies
    {
        if (i == name)
        {
            return enemies[i]
        }
    }
}

function GetEnemyIdByName(name)
{
    enemy = GetEnemyByName(name)
    return enemy["id"]
}

// $074E98: Time elapsed in battle (frames) (32-bit)
function battleTime() => dword(0x074E98)

// $074E9C: Number of consecutive hits in battle (16-bit)
// $074E9F: Hits taken in battle

// $06879A: Like 0x06879c, appears to be related to the top-screen rank sprite that pops in at the end of battles.
//          This address appears to dictate rotation and screen position.
//
//          0xc002 is its final position.
function rankingGraphicXPosition() => word(0x06879A)
function currentRankingGraphic() => byte(0x06879c)

function RankingGraphicIsInFinalPosition()
{
    return currentRankingGraphic() == GetRankingGraphicIndexByName("Star") && rankingGraphicXPosition() == 0xc002
        || rankingGraphicXPosition() == 0xc004 && currentRankingGraphic() != GetRankingGraphicIndexByName("Star")
}

rankingGraphicIndices = {
    "Star": { "index": 0x10 },
    "A": { "index": 0x80 },
    "B": { "index": 0x30 },
    "C": { "index": 0x70 },
    "D": { "index": 0x40 },
    "E": { "index": 0x50 }
}

function GetRankingGraphicIndexByName(name)
{
    for index in rankingGraphicIndices
    {
        if (index == name)
        {
            return rankingGraphicIndices[index]["index"]
        }
    }
}

function AcquiredAtLeastRank(rank)
{
    ret = always_false()
    break = 0
    for i in rankingGraphicIndices
    {
        if (break == 0)
        {
            ret = ret || currentRankingGraphic() == GetRankingGraphicIndexByName(i)
            
            if (rank == i)
            {
                break = 1
            }
        }
        
    }
    return ret
}

function IsRankingRevealed()
{
    return WonBattleAndOnResultsScreen() && RankingGraphicIsInFinalPosition()
}

// Pin-related functionality
// ---
// The data structures for pins vary depending on whether or not they're in a player's deck/stockpile or if they're in the Mastered collection.
//
// DECK/STOCKPILE (11 bytes each)
// ***
// Bytes 0-1: Pin ID. Equal to 0xffff if there is no pin equipped in that slot. IDs go from 0x0 to 0x12f.
// Bytes 2-3: Battle PP.
// Bytes 4-5: Mingle PP.
// Bytes 6-7: Shutdown PP.
// Byte 9: Bit 0 determines if a pin is in a subslot.
// Byte A: Pin LV (lower 4 only)
//
// MASTERED (4 bytes each)
// ***
// Bytes 0-1: Pin ID. Equal to 0xffff if there is no pin in that slot.
// Byte 2: Count.
// Byte 3: Pin LV (lower 4 only; probably redundant?)
//
// To check mastery, we'll have to check both the deck and Mastered collection.

pins = {
0x0: { "ID": 0x0, "Name": "Ice Blow", "MaxLevel": 7, "Mingle?": 0, "Recovery?": 0 },
0x1: { "ID": 0x1, "Name": "Ice Risers", "MaxLevel": 10, "Mingle?": 0, "Recovery?": 0 },
0x2: { "ID": 0x2, "Name": "Frozen Cool", "MaxLevel": 4, "Mingle?": 0, "Recovery?": 0 },
0x3: { "ID": 0x3, "Name": "Blizzard Cool", "MaxLevel": 4, "Mingle?": 1, "Recovery?": 0 },
0x4: { "ID": 0x4, "Name": "Earthshake", "MaxLevel": 5, "Mingle?": 0, "Recovery?": 0 },
0x5: { "ID": 0x5, "Name": "Sexy D", "MaxLevel": 4, "Mingle?": 0, "Recovery?": 0 },
0x6: { "ID": 0x6, "Name": "Sexy +", "MaxLevel": 4, "Mingle?": 0, "Recovery?": 0 },
0x7: { "ID": 0x7, "Name": "Sexy B", "MaxLevel": 5, "Mingle?": 0, "Recovery?": 0 },
0x8: { "ID": 0x8, "Name": "Straitjacket", "MaxLevel": 5, "Mingle?": 0, "Recovery?": 0 },
0x9: { "ID": 0x9, "Name": "Blown Kiss", "MaxLevel": 2, "Mingle?": 0, "Recovery?": 1 },
0xA: { "ID": 0xA, "Name": "D+B", "MaxLevel": 3, "Mingle?": 0, "Recovery?": 0 },
0xB: { "ID": 0xB, "Name": "Happy Beam", "MaxLevel": 6, "Mingle?": 0, "Recovery?": 0 },
0xC: { "ID": 0xC, "Name": "Natural Magnum", "MaxLevel": 5, "Mingle?": 0, "Recovery?": 0 },
0xD: { "ID": 0xD, "Name": "Wonder Magnum", "MaxLevel": 4, "Mingle?": 0, "Recovery?": 0 },
0xE: { "ID": 0xE, "Name": "Beauty Launcher", "MaxLevel": 5, "Mingle?": 1, "Recovery?": 0 },
0xF: { "ID": 0xF, "Name": "One Love Magnum", "MaxLevel": 6, "Mingle?": 0, "Recovery?": 0 },
0x10: { "ID": 0x10, "Name": "Hounder Magnum", "MaxLevel": 5, "Mingle?": 0, "Recovery?": 0 },
0x11: { "ID": 0x11, "Name": "Bear Hug Magnum", "MaxLevel": 5, "Mingle?": 0, "Recovery?": 0 },
0x12: { "ID": 0x12, "Name": "Sparkle Beam", "MaxLevel": 4, "Mingle?": 1, "Recovery?": 0 },
0x13: { "ID": 0x13, "Name": "Lil' Terror Bazooka", "MaxLevel": 3, "Mingle?": 0, "Recovery?": 0 },
0x14: { "ID": 0x14, "Name": "Angel Magnum", "MaxLevel": 4, "Mingle?": 0, "Recovery?": 0 },
0x15: { "ID": 0x15, "Name": "Cutie Beam", "MaxLevel": 5, "Mingle?": 0, "Recovery?": 0 },
0x16: { "ID": 0x16, "Name": "Lovely Beam", "MaxLevel": 6, "Mingle?": 0, "Recovery?": 0 },
0x17: { "ID": 0x17, "Name": "Sexy Beam", "MaxLevel": 7, "Mingle?": 0, "Recovery?": 0 },
0x18: { "ID": 0x18, "Name": "Superfine Beam", "MaxLevel": 8, "Mingle?": 0, "Recovery?": 0 },
0x19: { "ID": 0x19, "Name": "Playmate Beam", "MaxLevel": 3, "Mingle?": 0, "Recovery?": 0 },
0x1A: { "ID": 0x1A, "Name": "Purity Launcher", "MaxLevel": 3, "Mingle?": 0, "Recovery?": 0 },
0x1B: { "ID": 0x1B, "Name": "Innocence Beam", "MaxLevel": 5, "Mingle?": 0, "Recovery?": 0 },
0x1C: { "ID": 0x1C, "Name": "Pop Pendulum", "MaxLevel": 5, "Mingle?": 0, "Recovery?": 0 },
0x1D: { "ID": 0x1D, "Name": "Casual Pendulum", "MaxLevel": 3, "Mingle?": 0, "Recovery?": 0 },
0x1E: { "ID": 0x1E, "Name": "Love Me Tether", "MaxLevel": 5, "Mingle?": 0, "Recovery?": 0 },
0x1F: { "ID": 0x1F, "Name": "Pamper Me Tether", "MaxLevel": 5, "Mingle?": 0, "Recovery?": 0 },
0x20: { "ID": 0x20, "Name": "Sweet Talk Tether", "MaxLevel": 5, "Mingle?": 0, "Recovery?": 0 },
0x21: { "ID": 0x21, "Name": "Natural Puppy", "MaxLevel": 3, "Mingle?": 0, "Recovery?": 0 },
0x22: { "ID": 0x22, "Name": "Frantic", "MaxLevel": 3, "Mingle?": 0, "Recovery?": 0 },
0x23: { "ID": 0x23, "Name": "Blink Step", "MaxLevel": 3, "Mingle?": 0, "Recovery?": 0 },
0x24: { "ID": 0x24, "Name": "First Gear", "MaxLevel": 5, "Mingle?": 0, "Recovery?": 0 },
0x25: { "ID": 0x25, "Name": "Top Gear", "MaxLevel": 3, "Mingle?": 0, "Recovery?": 0 },
0x26: { "ID": 0x26, "Name": "Egg Bomb", "MaxLevel": 4, "Mingle?": 0, "Recovery?": 0 },
0x27: { "ID": 0x27, "Name": "Meteor Magnet", "MaxLevel": 6, "Mingle?": 0, "Recovery?": 0 },
0x28: { "ID": 0x28, "Name": "Meteor Hook", "MaxLevel": 7, "Mingle?": 1, "Recovery?": 0 },
0x29: { "ID": 0x29, "Name": "Meteor Spike", "MaxLevel": 8, "Mingle?": 1, "Recovery?": 0 },
0x2A: { "ID": 0x2A, "Name": "Strong Heart", "MaxLevel": 5, "Mingle?": 0, "Recovery?": 0 },
0x2B: { "ID": 0x2B, "Name": "Strong Spirit", "MaxLevel": 5, "Mingle?": 0, "Recovery?": 0 },
0x2C: { "ID": 0x2C, "Name": "Strong Body", "MaxLevel": 5, "Mingle?": 0, "Recovery?": 0 },
0x2D: { "ID": 0x2D, "Name": "Strong 'n Proud", "MaxLevel": 5, "Mingle?": 0, "Recovery?": 0 },
0x2E: { "ID": 0x2E, "Name": "Poison Scorpion", "MaxLevel": 2, "Mingle?": 0, "Recovery?": 0 },
0x2F: { "ID": 0x2F, "Name": "Poison Skull", "MaxLevel": 2, "Mingle?": 0, "Recovery?": 0 },
0x30: { "ID": 0x30, "Name": "Poison Bones", "MaxLevel": 3, "Mingle?": 0, "Recovery?": 0 },
0x31: { "ID": 0x31, "Name": "Poison Chains", "MaxLevel": 3, "Mingle?": 0, "Recovery?": 0 },
0x32: { "ID": 0x32, "Name": "Rapier Glance", "MaxLevel": 3, "Mingle?": 1, "Recovery?": 0 },
0x33: { "ID": 0x33, "Name": "Love Charge", "MaxLevel": 1, "Mingle?": 0, "Recovery?": 0 },
0x34: { "ID": 0x34, "Name": "Guardian Angel", "MaxLevel": 5, "Mingle?": 0, "Recovery?": 0 },
0x35: { "ID": 0x35, "Name": "Archangel", "MaxLevel": 3, "Mingle?": 0, "Recovery?": 1 },
0x36: { "ID": 0x36, "Name": "Energy Factor", "MaxLevel": 5, "Mingle?": 0, "Recovery?": 0 },
0x37: { "ID": 0x37, "Name": "Speed Factor", "MaxLevel": 1, "Mingle?": 0, "Recovery?": 0 },
0x38: { "ID": 0x38, "Name": "Supply Factor", "MaxLevel": 3, "Mingle?": 0, "Recovery?": 0 },
0x39: { "ID": 0x39, "Name": "Chaos", "MaxLevel": 3, "Mingle?": 0, "Recovery?": 0 },
0x3A: { "ID": 0x3A, "Name": "Pavo Real", "MaxLevel": 3, "Mingle?": 0, "Recovery?": 0 },
0x3B: { "ID": 0x3B, "Name": "Lightning Moon", "MaxLevel": 5, "Mingle?": 0, "Recovery?": 0 },
0x3C: { "ID": 0x3C, "Name": "Lightning Storm", "MaxLevel": 5, "Mingle?": 0, "Recovery?": 0 },
0x3D: { "ID": 0x3D, "Name": "Burning Cherry", "MaxLevel": 5, "Mingle?": 0, "Recovery?": 0 },
0x3E: { "ID": 0x3E, "Name": "Burning Melon", "MaxLevel": 5, "Mingle?": 0, "Recovery?": 0 },
0x3F: { "ID": 0x3F, "Name": "Burning Berry", "MaxLevel": 5, "Mingle?": 0, "Recovery?": 0 },
0x40: { "ID": 0x40, "Name": "Aqua Monster", "MaxLevel": 4, "Mingle?": 0, "Recovery?": 0 },
0x41: { "ID": 0x41, "Name": "Aqua Ghost", "MaxLevel": 5, "Mingle?": 0, "Recovery?": 0 },
0x42: { "ID": 0x42, "Name": "Aqua Demon", "MaxLevel": 5, "Mingle?": 0, "Recovery?": 0 },
0x43: { "ID": 0x43, "Name": "Cornered Rat", "MaxLevel": 5, "Mingle?": 0, "Recovery?": 0 },
0x44: { "ID": 0x44, "Name": "Blast Warning", "MaxLevel": 5, "Mingle?": 0, "Recovery?": 0 },
0x45: { "ID": 0x45, "Name": "Candle Service", "MaxLevel": 3, "Mingle?": 0, "Recovery?": 0 },
0x46: { "ID": 0x46, "Name": "Shock Warning", "MaxLevel": 5, "Mingle?": 0, "Recovery?": 0 },
0x47: { "ID": 0x47, "Name": "Kinetic Warning", "MaxLevel": 5, "Mingle?": 0, "Recovery?": 0 },
0x48: { "ID": 0x48, "Name": "Impact Warning", "MaxLevel": 5, "Mingle?": 0, "Recovery?": 0 },
0x49: { "ID": 0x49, "Name": "Storm Warning", "MaxLevel": 5, "Mingle?": 0, "Recovery?": 0 },
0x4A: { "ID": 0x4A, "Name": "Electric Warning", "MaxLevel": 1, "Mingle?": 0, "Recovery?": 0 },
0x4B: { "ID": 0x4B, "Name": "Teleport Warning", "MaxLevel": 3, "Mingle?": 0, "Recovery?": 0 },
0x4C: { "ID": 0x4C, "Name": "Shout", "MaxLevel": 5, "Mingle?": 0, "Recovery?": 0 },
0x4D: { "ID": 0x4D, "Name": "Psych Support", "MaxLevel": 3, "Mingle?": 0, "Recovery?": 0 },
0x4E: { "ID": 0x4E, "Name": "Stopper Spark", "MaxLevel": 1, "Mingle?": 0, "Recovery?": 0 },
0x4F: { "ID": 0x4F, "Name": "Mus Rattus", "MaxLevel": 3, "Mingle?": 0, "Recovery?": 0 },
0x50: { "ID": 0x50, "Name": "Masamune", "MaxLevel": 7, "Mingle?": 0, "Recovery?": 0 },
0x51: { "ID": 0x51, "Name": "Onikiri", "MaxLevel": 7, "Mingle?": 0, "Recovery?": 0 },
0x52: { "ID": 0x52, "Name": "Nenekiri", "MaxLevel": 7, "Mingle?": 0, "Recovery?": 0 },
0x53: { "ID": 0x53, "Name": "Kanesada", "MaxLevel": 7, "Mingle?": 0, "Recovery?": 0 },
0x54: { "ID": 0x54, "Name": "Enju", "MaxLevel": 7, "Mingle?": 0, "Recovery?": 0 },
0x55: { "ID": 0x55, "Name": "Yoshimitsu", "MaxLevel": 7, "Mingle?": 0, "Recovery?": 0 },
0x56: { "ID": 0x56, "Name": "Ichimonji", "MaxLevel": 5, "Mingle?": 0, "Recovery?": 0 },
0x57: { "ID": 0x57, "Name": "Nikkari", "MaxLevel": 5, "Mingle?": 0, "Recovery?": 0 },
0x58: { "ID": 0x58, "Name": "Mikazuki", "MaxLevel": 3, "Mingle?": 1, "Recovery?": 0 },
0x59: { "ID": 0x59, "Name": "Shiro", "MaxLevel": 20, "Mingle?": 0, "Recovery?": 0 },
0x5A: { "ID": 0x5A, "Name": "Unjo", "MaxLevel": 5, "Mingle?": 0, "Recovery?": 0 },
0x5B: { "ID": 0x5B, "Name": "Izanagi", "MaxLevel": 5, "Mingle?": 0, "Recovery?": 0 },
0x5C: { "ID": 0x5C, "Name": "Murasame", "MaxLevel": 4, "Mingle?": 0, "Recovery?": 0 },
0x5D: { "ID": 0x5D, "Name": "Rakuyo", "MaxLevel": 4, "Mingle?": 0, "Recovery?": 0 },
0x5E: { "ID": 0x5E, "Name": "Kusanagi", "MaxLevel": 4, "Mingle?": 1, "Recovery?": 0 },
0x5F: { "ID": 0x5F, "Name": "Ohabari", "MaxLevel": 7, "Mingle?": 0, "Recovery?": 0 },
0x60: { "ID": 0x60, "Name": "Zantetsu", "MaxLevel": 10, "Mingle?": 0, "Recovery?": 0 },
0x61: { "ID": 0x61, "Name": "Mitama", "MaxLevel": 6, "Mingle?": 0, "Recovery?": 0 },
0x62: { "ID": 0x62, "Name": "Izanami", "MaxLevel": 1, "Mingle?": 0, "Recovery?": 0 },
0x63: { "ID": 0x63, "Name": "Onmyo", "MaxLevel": 5, "Mingle?": 0, "Recovery?": 0 },
0x64: { "ID": 0x64, "Name": "Konohana", "MaxLevel": 3, "Mingle?": 0, "Recovery?": 1 },
0x65: { "ID": 0x65, "Name": "Konohana Sakuya", "MaxLevel": 4, "Mingle?": 0, "Recovery?": 1 },
0x66: { "ID": 0x66, "Name": "Jupiter of the Monkey", "MaxLevel": 3, "Mingle?": 0, "Recovery?": 0 },
0x67: { "ID": 0x67, "Name": "Long Live the Rock", "MaxLevel": 4, "Mingle?": 0, "Recovery?": 0 },
0x68: { "ID": 0x68, "Name": "Long Live the Ice", "MaxLevel": 5, "Mingle?": 0, "Recovery?": 0 },
0x69: { "ID": 0x69, "Name": "Long Live the Floe", "MaxLevel": 5, "Mingle?": 0, "Recovery?": 0 },
0x6A: { "ID": 0x6A, "Name": "Eyes Full of Hope", "MaxLevel": 5, "Mingle?": 0, "Recovery?": 0 },
0x6B: { "ID": 0x6B, "Name": "Eyes Full of Light", "MaxLevel": 5, "Mingle?": 0, "Recovery?": 0 },
0x6C: { "ID": 0x6C, "Name": "Hot Gaze", "MaxLevel": 4, "Mingle?": 0, "Recovery?": 0 },
0x6D: { "ID": 0x6D, "Name": "Sizzling Gaze", "MaxLevel": 4, "Mingle?": 0, "Recovery?": 0 },
0x6E: { "ID": 0x6E, "Name": "Cold Stare", "MaxLevel": 10, "Mingle?": 0, "Recovery?": 0 },
0x6F: { "ID": 0x6F, "Name": "Icy Stare", "MaxLevel": 10, "Mingle?": 0, "Recovery?": 0 },
0x70: { "ID": 0x70, "Name": "Wassup Thunder!", "MaxLevel": 5, "Mingle?": 0, "Recovery?": 0 },
0x71: { "ID": 0x71, "Name": "Wassup Lightning!", "MaxLevel": 5, "Mingle?": 0, "Recovery?": 0 },
0x72: { "ID": 0x72, "Name": "Wassup Voltage!", "MaxLevel": 6, "Mingle?": 1, "Recovery?": 0 },
0x73: { "ID": 0x73, "Name": "Indestructo Man", "MaxLevel": 1, "Mingle?": 0, "Recovery?": 0 },
0x74: { "ID": 0x74, "Name": "Hip Snake", "MaxLevel": 3, "Mingle?": 0, "Recovery?": 0 },
0x75: { "ID": 0x75, "Name": "Octo Squeeze", "MaxLevel": 6, "Mingle?": 0, "Recovery?": 0 },
0x76: { "ID": 0x76, "Name": "Snail Squeeze", "MaxLevel": 5, "Mingle?": 0, "Recovery?": 0 },
0x77: { "ID": 0x77, "Name": "Vacu Squeeze", "MaxLevel": 5, "Mingle?": 1, "Recovery?": 0 },
0x78: { "ID": 0x78, "Name": "Gimme Dat Sheep", "MaxLevel": 2, "Mingle?": 0, "Recovery?": 0 },
0x79: { "ID": 0x79, "Name": "Gimme Dat Elephant", "MaxLevel": 2, "Mingle?": 0, "Recovery?": 0 },
0x7A: { "ID": 0x7A, "Name": "Gimme Dat Hippo", "MaxLevel": 2, "Mingle?": 1, "Recovery?": 0 },
0x7B: { "ID": 0x7B, "Name": "Crackle Pop Barrier", "MaxLevel": 5, "Mingle?": 0, "Recovery?": 0 },
0x7C: { "ID": 0x7C, "Name": "Splish Splash Barrier", "MaxLevel": 5, "Mingle?": 0, "Recovery?": 0 },
0x7D: { "ID": 0x7D, "Name": "Creepy Weepy Barrier", "MaxLevel": 3, "Mingle?": 0, "Recovery?": 0 },
0x7E: { "ID": 0x7E, "Name": "Whirlygig Juggle", "MaxLevel": 3, "Mingle?": 0, "Recovery?": 0 },
0x7F: { "ID": 0x7F, "Name": "Healing Bunny", "MaxLevel": 2, "Mingle?": 0, "Recovery?": 1 },
0x80: { "ID": 0x80, "Name": "Healing Flamingo", "MaxLevel": 4, "Mingle?": 0, "Recovery?": 1 },
0x81: { "ID": 0x81, "Name": "Healing Whale", "MaxLevel": 3, "Mingle?": 0, "Recovery?": 1 },
0x82: { "ID": 0x82, "Name": "Croc Leisure", "MaxLevel": 5, "Mingle?": 0, "Recovery?": 1 },
0x83: { "ID": 0x83, "Name": "Monkey Leisure", "MaxLevel": 6, "Mingle?": 0, "Recovery?": 1 },
0x84: { "ID": 0x84, "Name": "Bear Leisure", "MaxLevel": 4, "Mingle?": 0, "Recovery?": 1 },
0x85: { "ID": 0x85, "Name": "Squirrel Leisure", "MaxLevel": 5, "Mingle?": 0, "Recovery?": 1 },
0x86: { "ID": 0x86, "Name": "Sparkle Charge", "MaxLevel": 3, "Mingle?": 0, "Recovery?": 0 },
0x87: { "ID": 0x87, "Name": "Handsfree Healing", "MaxLevel": 1, "Mingle?": 0, "Recovery?": 0 },
0x88: { "ID": 0x88, "Name": "Sheep Heavenly", "MaxLevel": 1, "Mingle?": 0, "Recovery?": 0 },
0x89: { "ID": 0x89, "Name": "Distortion", "MaxLevel": 4, "Mingle?": 0, "Recovery?": 0 },
0x8A: { "ID": 0x8A, "Name": "Velocity Attack", "MaxLevel": 5, "Mingle?": 0, "Recovery?": 0 },
0x8B: { "ID": 0x8B, "Name": "Velocity Tackle", "MaxLevel": 10, "Mingle?": 1, "Recovery?": 0 },
0x8C: { "ID": 0x8C, "Name": "Demon's Hatred", "MaxLevel": 1, "Mingle?": 0, "Recovery?": 0 },
0x8D: { "ID": 0x8D, "Name": "Go 2 Hell", "MaxLevel": 5, "Mingle?": 0, "Recovery?": 0 },
0x8E: { "ID": 0x8E, "Name": "Go 2 Heaven", "MaxLevel": 4, "Mingle?": 1, "Recovery?": 0 },
0x8F: { "ID": 0x8F, "Name": "Lightning Anger", "MaxLevel": 10, "Mingle?": 0, "Recovery?": 0 },
0x90: { "ID": 0x90, "Name": "Lightning Rage", "MaxLevel": 5, "Mingle?": 0, "Recovery?": 0 },
0x91: { "ID": 0x91, "Name": "LIVE!", "MaxLevel": 5, "Mingle?": 0, "Recovery?": 0 },
0x92: { "ID": 0x92, "Name": "Peace Full", "MaxLevel": 5, "Mingle?": 0, "Recovery?": 1 },
0x93: { "ID": 0x93, "Name": "Thanx", "MaxLevel": 3, "Mingle?": 0, "Recovery?": 1 },
0x94: { "ID": 0x94, "Name": "D.I.Y.", "MaxLevel": 1, "Mingle?": 0, "Recovery?": 0 },
0x95: { "ID": 0x95, "Name": "Tigre Punks", "MaxLevel": 3, "Mingle?": 0, "Recovery?": 0 },
0x96: { "ID": 0x96, "Name": "One Stone, Many Birds", "MaxLevel": 6, "Mingle?": 0, "Recovery?": 0 },
0x97: { "ID": 0x97, "Name": "One Stroke, Vast Wealth", "MaxLevel": 10, "Mingle?": 0, "Recovery?": 0 },
0x98: { "ID": 0x98, "Name": "One Grain, Infinite Promise", "MaxLevel": 7, "Mingle?": 1, "Recovery?": 0 },
0x99: { "ID": 0x99, "Name": "Self Found, Others Lost", "MaxLevel": 4, "Mingle?": 0, "Recovery?": 0 },
0x9A: { "ID": 0x9A, "Name": "Fiery Spirit, Spirited Fire", "MaxLevel": 5, "Mingle?": 0, "Recovery?": 0 },
0x9B: { "ID": 0x9B, "Name": "Flames Afar, Foes Aflame", "MaxLevel": 5, "Mingle?": 0, "Recovery?": 0 },
0x9C: { "ID": 0x9C, "Name": "Final Pyre, All Expired", "MaxLevel": 5, "Mingle?": 0, "Recovery?": 0 },
0x9D: { "ID": 0x9D, "Name": "Blue Blood Burns Blue", "MaxLevel": 3, "Mingle?": 0, "Recovery?": 0 },
0x9E: { "ID": 0x9E, "Name": "Live Slow, Die Fast", "MaxLevel": 6, "Mingle?": 0, "Recovery?": 0 },
0x9F: { "ID": 0x9F, "Name": "Local Fire, Distant Sea", "MaxLevel": 5, "Mingle?": 0, "Recovery?": 0 },
0xA0: { "ID": 0xA0, "Name": "June Hearth, January Fan", "MaxLevel": 4, "Mingle?": 1, "Recovery?": 0 },
0xA1: { "ID": 0xA1, "Name": "Swift Storm, Swift End", "MaxLevel": 5, "Mingle?": 0, "Recovery?": 0 },
0xA2: { "ID": 0xA2, "Name": "Black Sky, White Bolt", "MaxLevel": 5, "Mingle?": 0, "Recovery?": 0 },
0xA3: { "ID": 0xA3, "Name": "Follow Suit, Fall in Turn", "MaxLevel": 5, "Mingle?": 0, "Recovery?": 0 },
0xA4: { "ID": 0xA4, "Name": "Dragon Couture", "MaxLevel": 3, "Mingle?": 0, "Recovery?": 0 },
0xA5: { "ID": 0xA5, "Name": "Lolita Bat", "MaxLevel": 5, "Mingle?": 0, "Recovery?": 0 },
0xA6: { "ID": 0xA6, "Name": "Skull Rabbit", "MaxLevel": 5, "Mingle?": 0, "Recovery?": 0 },
0xA7: { "ID": 0xA7, "Name": "Kaleidoscope", "MaxLevel": 10, "Mingle?": 0, "Recovery?": 0 },
0xA8: { "ID": 0xA8, "Name": "Lolita Emblem", "MaxLevel": 3, "Mingle?": 0, "Recovery?": 0 },
0xA9: { "ID": 0xA9, "Name": "Lolita Chopper", "MaxLevel": 4, "Mingle?": 0, "Recovery?": 0 },
0xAA: { "ID": 0xAA, "Name": "Link Spider", "MaxLevel": 5, "Mingle?": 0, "Recovery?": 0 },
0xAB: { "ID": 0xAB, "Name": "Web Spider", "MaxLevel": 5, "Mingle?": 0, "Recovery?": 0 },
0xAC: { "ID": 0xAC, "Name": "Network Spider", "MaxLevel": 5, "Mingle?": 0, "Recovery?": 0 },
0xAD: { "ID": 0xAD, "Name": "Lolita Mic", "MaxLevel": 1, "Mingle?": 0, "Recovery?": 0 },
0xAE: { "ID": 0xAE, "Name": "Spider's Silk", "MaxLevel": 15, "Mingle?": 0, "Recovery?": 0 },
0xAF: { "ID": 0xAF, "Name": "Leopard", "MaxLevel": 4, "Mingle?": 0, "Recovery?": 1 },
0xB0: { "ID": 0xB0, "Name": "Lolita Skull", "MaxLevel": 4, "Mingle?": 0, "Recovery?": 1 },
0xB1: { "ID": 0xB1, "Name": "Black Rose", "MaxLevel": 3, "Mingle?": 0, "Recovery?": 0 },
0xB2: { "ID": 0xB2, "Name": "Lapin Angelique", "MaxLevel": 3, "Mingle?": 0, "Recovery?": 0 },
0xB3: { "ID": 0xB3, "Name": "Thunder Pawn", "MaxLevel": 5, "Mingle?": 0, "Recovery?": 0 },
0xB4: { "ID": 0xB4, "Name": "Lightning Pawn", "MaxLevel": 4, "Mingle?": 0, "Recovery?": 0 },
0xB5: { "ID": 0xB5, "Name": "Aqua Pawn", "MaxLevel": 3, "Mingle?": 0, "Recovery?": 0 },
0xB6: { "ID": 0xB6, "Name": "Swing Bishop", "MaxLevel": 7, "Mingle?": 0, "Recovery?": 0 },
0xB7: { "ID": 0xB7, "Name": "Pegaso Bishop", "MaxLevel": 5, "Mingle?": 0, "Recovery?": 0 },
0xB8: { "ID": 0xB8, "Name": "King Arthur", "MaxLevel": 3, "Mingle?": 0, "Recovery?": 0 },
0xB9: { "ID": 0xB9, "Name": "Excalibur", "MaxLevel": 5, "Mingle?": 0, "Recovery?": 0 },
0xBA: { "ID": 0xBA, "Name": "Thunder Rook", "MaxLevel": 3, "Mingle?": 0, "Recovery?": 0 },
0xBB: { "ID": 0xBB, "Name": "Lightning Rook", "MaxLevel": 4, "Mingle?": 0, "Recovery?": 0 },
0xBC: { "ID": 0xBC, "Name": "Jack's Knight", "MaxLevel": 4, "Mingle?": 0, "Recovery?": 0 },
0xBD: { "ID": 0xBD, "Name": "King's Knight", "MaxLevel": 4, "Mingle?": 0, "Recovery?": 0 },
0xBE: { "ID": 0xBE, "Name": "Queen's Knight", "MaxLevel": 4, "Mingle?": 0, "Recovery?": 0 },
0xBF: { "ID": 0xBF, "Name": "Her Royal Highness", "MaxLevel": 3, "Mingle?": 0, "Recovery?": 0 },
0xC0: { "ID": 0xC0, "Name": "Pegaso", "MaxLevel": 3, "Mingle?": 0, "Recovery?": 0 },
0xC1: { "ID": 0xC1, "Name": "Lazy Bomber", "MaxLevel": 7, "Mingle?": 0, "Recovery?": 0 },
0xC2: { "ID": 0xC2, "Name": "Flower of Flame", "MaxLevel": 3, "Mingle?": 0, "Recovery?": 0 },
0xC3: { "ID": 0xC3, "Name": "Flower of Fire", "MaxLevel": 4, "Mingle?": 0, "Recovery?": 0 },
0xC4: { "ID": 0xC4, "Name": "Kewl Line", "MaxLevel": 5, "Mingle?": 0, "Recovery?": 0 },
0xC5: { "ID": 0xC5, "Name": "Dope Line", "MaxLevel": 5, "Mingle?": 0, "Recovery?": 0 },
0xC6: { "ID": 0xC6, "Name": "Wild Line", "MaxLevel": 4, "Mingle?": 0, "Recovery?": 0 },
0xC7: { "ID": 0xC7, "Name": "Fly Line", "MaxLevel": 5, "Mingle?": 0, "Recovery?": 0 },
0xC8: { "ID": 0xC8, "Name": "Fresh Line", "MaxLevel": 5, "Mingle?": 0, "Recovery?": 0 },
0xC9: { "ID": 0xC9, "Name": "Microcosmic Pull", "MaxLevel": 4, "Mingle?": 0, "Recovery?": 0 },
0xCA: { "ID": 0xCA, "Name": "Cosmic Pull", "MaxLevel": 3, "Mingle?": 0, "Recovery?": 0 },
0xCB: { "ID": 0xCB, "Name": "Macrocosmic Pull", "MaxLevel": 2, "Mingle?": 0, "Recovery?": 0 },
0xCC: { "ID": 0xCC, "Name": "Diss", "MaxLevel": 1, "Mingle?": 0, "Recovery?": 0 },
0xCD: { "ID": 0xCD, "Name": "Wild Boar", "MaxLevel": 3, "Mingle?": 0, "Recovery?": 0 },
0xCE: { "ID": 0xCE, "Name": "Big Bang", "MaxLevel": 10, "Mingle?": 0, "Recovery?": 0 },
0xCF: { "ID": 0xCF, "Name": "Big Crunch", "MaxLevel": 10, "Mingle?": 0, "Recovery?": 0 },
0xD0: { "ID": 0xD0, "Name": "Swift as the Wind", "MaxLevel": 10, "Mingle?": 0, "Recovery?": 0 },
0xD1: { "ID": 0xD1, "Name": "Hushed as the Wood", "MaxLevel": 10, "Mingle?": 0, "Recovery?": 0 },
0xD2: { "ID": 0xD2, "Name": "Fierce as the Flame", "MaxLevel": 10, "Mingle?": 0, "Recovery?": 0 },
0xD3: { "ID": 0xD3, "Name": "Stalwart as the Mount", "MaxLevel": 10, "Mingle?": 0, "Recovery?": 0 },
0xD4: { "ID": 0xD4, "Name": "Black Mars", "MaxLevel": 10, "Mingle?": 0, "Recovery?": 0 },
0xD5: { "ID": 0xD5, "Name": "Black Jupiter", "MaxLevel": 10, "Mingle?": 0, "Recovery?": 0 },
0xD6: { "ID": 0xD6, "Name": "Black Uranus", "MaxLevel": 10, "Mingle?": 0, "Recovery?": 0 },
0xD7: { "ID": 0xD7, "Name": "Black Venus", "MaxLevel": 10, "Mingle?": 0, "Recovery?": 0 },
0xD8: { "ID": 0xD8, "Name": "Black Saturn", "MaxLevel": 10, "Mingle?": 0, "Recovery?": 0 },
0xD9: { "ID": 0xD9, "Name": "Black Mercury", "MaxLevel": 10, "Mingle?": 0, "Recovery?": 0 },
0xDA: { "ID": 0xDA, "Name": "Righty Cat", "MaxLevel": 3, "Mingle?": 0, "Recovery?": 0 },
0xDB: { "ID": 0xDB, "Name": "Brainy Cat", "MaxLevel": 3, "Mingle?": 0, "Recovery?": 0 },
0xDC: { "ID": 0xDC, "Name": "Lefty Cat", "MaxLevel": 3, "Mingle?": 0, "Recovery?": 0 },
0xDD: { "ID": 0xDD, "Name": "One Jump from Eden", "MaxLevel": 5, "Mingle?": 0, "Recovery?": 0 },
0xDE: { "ID": 0xDE, "Name": "One Skip from Eden", "MaxLevel": 5, "Mingle?": 0, "Recovery?": 0 },
0xDF: { "ID": 0xDF, "Name": "One Hop from Eden", "MaxLevel": 5, "Mingle?": 0, "Recovery?": 0 },
0xE0: { "ID": 0xE0, "Name": "One Step from Eden", "MaxLevel": 5, "Mingle?": 0, "Recovery?": 0 },
0xE1: { "ID": 0xE1, "Name": "Eden's Door", "MaxLevel": 5, "Mingle?": 0, "Recovery?": 0 },
0xE2: { "ID": 0xE2, "Name": "Visionary Blend", "MaxLevel": 1, "Mingle?": 0, "Recovery?": 1 },
0xE3: { "ID": 0xE3, "Name": "Red Skull", "MaxLevel": 1, "Mingle?": 0, "Recovery?": 0 },
0xE4: { "ID": 0xE4, "Name": "Gatito", "MaxLevel": 1, "Mingle?": 0, "Recovery?": 0 },
0xE5: { "ID": 0xE5, "Name": "Tin Pin Fire", "MaxLevel": 4, "Mingle?": 0, "Recovery?": 0 },
0xE6: { "ID": 0xE6, "Name": "Tin Pin Custom", "MaxLevel": 1, "Mingle?": 0, "Recovery?": 0 },
0xE7: { "ID": 0xE7, "Name": "Tin Pin Wind", "MaxLevel": 6, "Mingle?": 0, "Recovery?": 0 },
0xE8: { "ID": 0xE8, "Name": "Tin Pin Blade", "MaxLevel": 6, "Mingle?": 0, "Recovery?": 0 },
0xE9: { "ID": 0xE9, "Name": "Tin Pin Wheel", "MaxLevel": 3, "Mingle?": 0, "Recovery?": 0 },
0xEA: { "ID": 0xEA, "Name": "Tin Pin Dash", "MaxLevel": 4, "Mingle?": 0, "Recovery?": 0 },
0xEB: { "ID": 0xEB, "Name": "Tin Pin Thrift", "MaxLevel": 3, "Mingle?": 0, "Recovery?": 0 },
0xEC: { "ID": 0xEC, "Name": "Tin Pin Hellfire", "MaxLevel": 7, "Mingle?": 0, "Recovery?": 0 },
0xED: { "ID": 0xED, "Name": "Tin Pin Sunscorch", "MaxLevel": 3, "Mingle?": 0, "Recovery?": 0 },
0xEE: { "ID": 0xEE, "Name": "Tin Pin Rocker", "MaxLevel": 2, "Mingle?": 0, "Recovery?": 0 },
0xEF: { "ID": 0xEF, "Name": "Tin Pin Artist", "MaxLevel": 4, "Mingle?": 0, "Recovery?": 0 },
0xF0: { "ID": 0xF0, "Name": "Tin Pin Devil", "MaxLevel": 8, "Mingle?": 0, "Recovery?": 0 },
0xF1: { "ID": 0xF1, "Name": "Tin Pin Ifrit", "MaxLevel": 3, "Mingle?": 0, "Recovery?": 0 },
0xF2: { "ID": 0xF2, "Name": "Tin Pin Shiva", "MaxLevel": 4, "Mingle?": 0, "Recovery?": 0 },
0xF3: { "ID": 0xF3, "Name": "Tin Pin Golem", "MaxLevel": 5, "Mingle?": 0, "Recovery?": 0 },
0xF4: { "ID": 0xF4, "Name": "Tin Pin Bahamut", "MaxLevel": 6, "Mingle?": 0, "Recovery?": 0 },
0xF5: { "ID": 0xF5, "Name": "1 Yen", "MaxLevel": 2, "Mingle?": 0, "Recovery?": 0 },
0xF6: { "ID": 0xF6, "Name": "5 Yen", "MaxLevel": 2, "Mingle?": 0, "Recovery?": 0 },
0xF7: { "ID": 0xF7, "Name": "10 Yen", "MaxLevel": 2, "Mingle?": 0, "Recovery?": 0 },
0xF8: { "ID": 0xF8, "Name": "50 Yen", "MaxLevel": 2, "Mingle?": 0, "Recovery?": 0 },
0xF9: { "ID": 0xF9, "Name": "100 Yen", "MaxLevel": 2, "Mingle?": 0, "Recovery?": 0 },
0xFA: { "ID": 0xFA, "Name": "500 Yen", "MaxLevel": 2, "Mingle?": 0, "Recovery?": 0 },
0xFB: { "ID": 0xFB, "Name": "1,000 Yen", "MaxLevel": 2, "Mingle?": 0, "Recovery?": 0 },
0xFC: { "ID": 0xFC, "Name": "5,000 Yen", "MaxLevel": 2, "Mingle?": 0, "Recovery?": 0 },
0xFD: { "ID": 0xFD, "Name": "10,000 Yen", "MaxLevel": 1, "Mingle?": 0, "Recovery?": 0 },
0xFE: { "ID": 0xFE, "Name": "Scarletite", "MaxLevel": 1, "Mingle?": 0, "Recovery?": 0 },
0xFF: { "ID": 0xFF, "Name": "Rare Metal", "MaxLevel": 1, "Mingle?": 0, "Recovery?": 0 },
0x100: { "ID": 0x100, "Name": "Tektite", "MaxLevel": 1, "Mingle?": 0, "Recovery?": 0 },
0x101: { "ID": 0x101, "Name": "Adamantite", "MaxLevel": 1, "Mingle?": 0, "Recovery?": 0 },
0x102: { "ID": 0x102, "Name": "Orichalcum", "MaxLevel": 1, "Mingle?": 0, "Recovery?": 0 },
0x103: { "ID": 0x103, "Name": "Shadow Matter", "MaxLevel": 1, "Mingle?": 0, "Recovery?": 0 },
0x104: { "ID": 0x104, "Name": "Dark Matter", "MaxLevel": 1, "Mingle?": 0, "Recovery?": 0 },
0x105: { "ID": 0x105, "Name": "Rhyme", "MaxLevel": 1, "Mingle?": 0, "Recovery?": 0 },
0x106: { "ID": 0x106, "Name": "Lucky Star", "MaxLevel": 3, "Mingle?": 0, "Recovery?": 0 },
0x107: { "ID": 0x107, "Name": "Lady Luck", "MaxLevel": 3, "Mingle?": 0, "Recovery?": 0 },
0x108: { "ID": 0x108, "Name": "Lucky Panda", "MaxLevel": 3, "Mingle?": 0, "Recovery?": 0 },
0x109: { "ID": 0x109, "Name": "Pyrokinesis", "MaxLevel": 3, "Mingle?": 0, "Recovery?": 0 },
0x10A: { "ID": 0x10A, "Name": "Shockwave", "MaxLevel": 3, "Mingle?": 0, "Recovery?": 0 },
0x10B: { "ID": 0x10B, "Name": "Cure Drink", "MaxLevel": 3, "Mingle?": 0, "Recovery?": 1 },
0x10C: { "ID": 0x10C, "Name": "Force Rounds", "MaxLevel": 3, "Mingle?": 0, "Recovery?": 0 },
0x10D: { "ID": 0x10D, "Name": "Psychokinesis", "MaxLevel": 2, "Mingle?": 0, "Recovery?": 0 },
0x10E: { "ID": 0x10E, "Name": "Thunderbolt", "MaxLevel": 2, "Mingle?": 0, "Recovery?": 0 },
0x10F: { "ID": 0x10F, "Name": "The Eyes Have It", "MaxLevel": 3, "Mingle?": 0, "Recovery?": 0 },
0x110: { "ID": 0x110, "Name": "I Live for Food", "MaxLevel": 3, "Mingle?": 0, "Recovery?": 1 },
0x111: { "ID": 0x111, "Name": "Walk on, Walk off", "MaxLevel": 3, "Mingle?": 0, "Recovery?": 0 },
0x112: { "ID": 0x112, "Name": "Me Time is Free Time", "MaxLevel": 3, "Mingle?": 0, "Recovery?": 0 },
0x113: { "ID": 0x113, "Name": "Fuji Yama", "MaxLevel": 5, "Mingle?": 0, "Recovery?": 0 },
0x114: { "ID": 0x114, "Name": "Daruma", "MaxLevel": 5, "Mingle?": 0, "Recovery?": 0 },
0x115: { "ID": 0x115, "Name": "Sushi", "MaxLevel": 5, "Mingle?": 0, "Recovery?": 0 },
0x116: { "ID": 0x116, "Name": "Shinobi", "MaxLevel": 5, "Mingle?": 0, "Recovery?": 0 },
0x117: { "ID": 0x117, "Name": "Tigris", "MaxLevel": 10, "Mingle?": 0, "Recovery?": 0 },
0x118: { "ID": 0x118, "Name": "Corehog", "MaxLevel": 5, "Mingle?": 0, "Recovery?": 0 },
0x119: { "ID": 0x119, "Name": "Jelly", "MaxLevel": 7, "Mingle?": 0, "Recovery?": 0 },
0x11A: { "ID": 0x11A, "Name": "Shark", "MaxLevel": 3, "Mingle?": 0, "Recovery?": 0 },
0x11B: { "ID": 0x11B, "Name": "Leo", "MaxLevel": 3, "Mingle?": 0, "Recovery?": 0 },
0x11C: { "ID": 0x11C, "Name": "Ovis", "MaxLevel": 9, "Mingle?": 0, "Recovery?": 0 },
0x11D: { "ID": 0x11D, "Name": "Cornix", "MaxLevel": 4, "Mingle?": 0, "Recovery?": 0 },
0x11E: { "ID": 0x11E, "Name": "Popguin", "MaxLevel": 3, "Mingle?": 0, "Recovery?": 0 },
0x11F: { "ID": 0x11F, "Name": "Pteropus", "MaxLevel": 6, "Mingle?": 0, "Recovery?": 0 },
0x120: { "ID": 0x120, "Name": "Mink", "MaxLevel": 4, "Mingle?": 0, "Recovery?": 0 },
0x121: { "ID": 0x121, "Name": "Boomer", "MaxLevel": 5, "Mingle?": 0, "Recovery?": 0 },
0x122: { "ID": 0x122, "Name": "Sprog", "MaxLevel": 4, "Mingle?": 0, "Recovery?": 0 },
0x123: { "ID": 0x123, "Name": "Fox", "MaxLevel": 3, "Mingle?": 0, "Recovery?": 0 },
0x124: { "ID": 0x124, "Name": "Bat", "MaxLevel": 5, "Mingle?": 0, "Recovery?": 0 },
0x125: { "ID": 0x125, "Name": "Rhino", "MaxLevel": 4, "Mingle?": 0, "Recovery?": 0 },
0x126: { "ID": 0x126, "Name": "Shrew", "MaxLevel": 6, "Mingle?": 0, "Recovery?": 0 },
0x127: { "ID": 0x127, "Name": "Woolly", "MaxLevel": 4, "Mingle?": 0, "Recovery?": 0 },
0x128: { "ID": 0x128, "Name": "Raven", "MaxLevel": 9, "Mingle?": 0, "Recovery?": 0 },
0x129: { "ID": 0x129, "Name": "Drake", "MaxLevel": 15, "Mingle?": 0, "Recovery?": 0 },
0x12A: { "ID": 0x12A, "Name": "Anguis", "MaxLevel": 20, "Mingle?": 0, "Recovery?": 0 },
0x12B: { "ID": 0x12B, "Name": "Pig", "MaxLevel": 1, "Mingle?": 0, "Recovery?": 0 },
0x12C: { "ID": 0x12C, "Name": "Carcin", "MaxLevel": 3, "Mingle?": 0, "Recovery?": 0 },
0x12D: { "ID": 0x12D, "Name": "Grizzly", "MaxLevel": 3, "Mingle?": 0, "Recovery?": 0 },
0x12E: { "ID": 0x12E, "Name": "Wolf", "MaxLevel": 5, "Mingle?": 0, "Recovery?": 0 },
0x12F: { "ID": 0x12F, "Name": "Frog", "MaxLevel": 4, "Mingle?": 0, "Recovery?": 0 },
}

numberOfMasteredPinSlots = 304

function GetPinById(id)
{
    for i in pins
    {
        if (id == i)
        {
            return pins[i]
        }
    }
}

function GetRecoveryPins()
{
    recoveryPins = {}
    length = 0
    for i in pins
    {
        pin = pins[i]
        if (pin["Recovery?"] == 1)
        {
            recoveryPins[length] = pin
            length = length + 1
        }
    }
    
    return recoveryPins
}
recoveryPins = GetRecoveryPins() // Attempt to cache the result

function GetPinsByMaxLevel(maxLevel)
{
    ret = {}
    for i in pins
    {
        pin = pins[i]
        if (pin["MaxLevel"] == maxLevel)
        {
            ret[pin["ID"]] = pin["ID"]
        }
    }
    return ret
}

// Level classes are used to optimize the size of pin mastery achievements.
function GetLevelClassesForPins()
{
    ret = {}
    for i in pins
    {
        pin = pins[i]
        ret[pin["MaxLevel"]] = 1
    }
    return ret
}
levelClasses = GetLevelClassesForPins() // Attempt to cache

function deckSlot1BaseAddr() => 0x071d84
function deckPinByteSize() => 10

function IsDeckPinMasteredByAddr(baseAddr)
{
    id = word(baseAddr)
    level = low4(baseAddr + 0x9)
    result = always_false()
    
    for maxLevel in levelClasses
    {
        pinAlt = always_false()
        pinsInLevel = GetPinsByMaxLevel(maxLevel)
        
        for i in pinsInLevel
        {
            pin = pins[i]
            pinAlt = pinAlt || id == pin["ID"]
        }
        result = result ||
            Delta(level) != level // Trigger only if the level changes.
            && level == maxLevel // Trigger if the level is changed to the max level.
            && once(pinAlt) // Trigger if we're dealing with any of the pins in this level class.
            && Delta(id) == id // Don't trigger if we're just moving mastered pins around.
    }

    return result
}

function IsDeckPinMastered(slotId)
{
    return IsDeckPinMasteredByAddr(deckSlot1BaseAddr() + slotId * deckPinByteSize())
}

function IsDeckPinARecoveryPin(slotId)
{
    isARecoveryPin = always_false()
    for i in recoveryPins
    {
        pin = recoveryPins[i]
        isARecoveryPin = isARecoveryPin || word(deckSlot1BaseAddr() + slotId * deckPinByteSize()) == pin["ID"]
    }
    return isARecoveryPin
}

function IsAnyDeckPinMastered()
{
    result = always_false()
    for i in range(0, 5)
    {
        result = result || IsDeckPinMastered(i)
    }
    return result
}

function HasRecoveryPinsEquipped()
{
    result = always_false()
    for i in range(0, 5)
    {
        result = result || IsDeckPinARecoveryPin(i)
    }
    return result
}

function masteredPinSlotBaseAddr() => 0x0727c0

function MasteredPinSlotIsFilled(slot)
{
    return word(masteredPinSlotBaseAddr() + 4 * slot) != 0xffff
}

function MasteredPinSlotChanged(slot)
{
    addr = masteredPinSlotBaseAddr() + 4 * slot
    return Delta(word(addr)) != word(addr)
}

// ITEMS

items = {
0x2A8: { "id": 0x2A8, "name": "(S) Extra Slot", },
0xFFFF: { "id": 0xFFFF, "name": "None", },
0x2ce: { "id": 0x2ce, "name": "(S) Noise Report", },
0x2ae: { "id": 0x2ae, "name": "(S) Game Cleared", }
}

// $071d2c: Neku thread, slot 1 (16-bit)
// $071d2e: Neku thread, slot 2 (16-bit)
// $071d30: Neku thread, slot 3 (16-bit)
// $071d32: Neku thread, slot 4 (16-bit)
function nekuThreadSlot1BaseAddr() => 0x071d2c

itemSlots = 472
firstItemSlotBaseAddr = 0x072c80

function GetItemByName(name)
{
    for i in items
    {
        item = items[i]
        if (item["name"] == name)
        {
            return item
        }
    }
}

// TODO: VERY SLOW
function JustGotNumberOfItemsByName(name, count)
{
    item = GetItemByName(name)
    result = always_false()
    
    for i in range(0, itemSlots - 1)
    {
        addr = firstItemSlotBaseAddr + 4 * i
        result = result || word(addr) == item["id"] && WasValueSetInGame(low4(addr + 2), count - 1, count)
            && unless(word(addr) != item["id"]) // We don't want achievements to trigger if the inventory is sorted.
    }
    
    return result
}

// With this function, we don't have to check if the value was set in game. We just want to know if
// an item exists in the inventory.
function HasNumberOfItemsByName(name, count)
{
    item = GetItemByName(name)
    result = always_false()
    
    for i in range(0, itemSlots - 1)
    {
        addr = firstItemSlotBaseAddr + 4 * i
        result = result || word(addr) == item["id"]
    }
    
    return result
}

playingOnClearedGame = HasNumberOfItemsByName("(S) Game Cleared", 1) // Attempt to cache

// END ITEMS

// NOISE REPORT

// $073cda: Noise Report, first entry - Min LV
noiseReportBaseAddr = 0x073cda
numberOfNoiseEntries = 96

function GetNoiseEntryAddressByIndex(index)
{
    return noiseReportBaseAddr + 4 * index + 2
}

function NoiseEntryIsUnlocked(index)
{
    noiseDefeatedAddr = GetNoiseEntryAddressByIndex(index)
    return word(noiseDefeatedAddr) > 0
}

function AnyNoiseEntryWasJustUnlocked()
{
    alt = always_false()
    for index in range(0, numberOfNoiseEntries - 1)
    {
        noiseDefeatedAddr = GetNoiseEntryAddressByIndex(index)
        alt = alt || Delta(word(noiseDefeatedAddr)) == 0 && word(noiseDefeatedAddr) > 0
    }
    return alt
}

anyNoiseEntryWasJustUnlocked = AnyNoiseEntryWasJustUnlocked() // Attempt to cache

// END NOISE REPORT

achievement(title = "In the Nick of Time", points = 1,
    description = "Forge a pact with Shiki.",
    trigger = WasValueSetInGame(partner(), GetPartnerByName("NONE"), GetPartnerByName("Shiki"))
        && never(IsLoadingSaveFile())
        && CurrentChapterIs("Shiki, Day 1")
)

// TODO: May trigger at wrong time. Investigate further.
achievement(title = "It's a Step Forward", points = 3,
    description = "Master a pin in your deck.",
    trigger = IsAnyDeckPinMastered() && isOnTitleScreen() == 0x0
)

achievement(title = "Befriending the Shopkeeper", points = 5,
    description = "Attain a Friendship Level of 5 with a shopkeeper.",
    trigger = WasShopkeeperLeveledUpToLevel(5)
)

achievement(title = "Crushing on the Shopkeeper", points = 10,
    description = "Max out your friendship level with a shopkeeper.",
    trigger = WasShopkeeperLeveledUpToLevel(10)
)

// TODO: Optimize; searching for items is VERY SLOW
//achievement(title = "With All Six Pins", points = 5,
//    description = "Obtain four Extra Slot stickers.",
//    trigger = JustGotNumberOfItemsByName("(S) Extra Slot", 4)
//)

// Noise achievements
noiseAchievements = [
    { "name": "Rookie Eraser", "description": "Complete 10% of the Noise Report.", "threshold": 10, "points": 3 },
    { "name": "Regular Eraser", "description": "Complete 25% of the Noise Report.", "threshold": 24, "points": 5 },
    { "name": "Veteran Eraser", "description": "Complete 50% of the Noise Report.", "threshold": 48, "points": 10 },
    { "name": "Legendary Eraser", "description": "Complete 100% of the Noise Report.", "threshold": 96, "points": 25 }
]

noiseConditions = {}
for i in range(0, numberOfNoiseEntries - 1)
{
    //noiseConditions[i] = { "countsWhen": NoiseEntryIsUnlocked(i), "resetWhen": anyNoiseEntryWasJustUnlocked }
}

for cheevo in noiseAchievements
{
    //GenerateSaveProtectedAchievementFromConditions(cheevo, noiseConditions) // TODO: Uncomment when "recursion" fix is implemented
}

// End Noise achievements

// Pin mastery achievements (TODO: Attempt to optimize; VERY SLOW TO GENERATE)

pinMasteryConditions = {}
//for i in range(0, numberOfMasteredPinSlots - 1)
//{
    // Resetting the game can trigger the achievements; checking if the play time is greater than 0 should prevent this.
    //resetWhen = MasteredPinSlotChanged(i) && playTime() > 0
    //pinMasteryConditions[i] = { "countsWhen": MasteredPinSlotIsFilled(i), "resetWhen": resetWhen }
//}

pinMasteryAchievements = [
    //{ "name": "A Couple Lanyards Full", "description": "Have 30 types of pins in your Mastered collection.", "threshold": 30, "points": 3 },
    //{ "name": "Flea Market Vendor", "description": "Have 75 types of pins in your Mastered collection.", "threshold": 75, "points": 5 },
    //{ "name": "Comiket Vendor", "description": "Have 150 types of pins in your Mastered collection.", "threshold": 150, "points": 10 },
    //{ "name": "Pioneer of the Trade", "description": "Have all 289 types of pins that do not require mingling in your Mastered collection.",
    //    "threshold": 289, "points": 25 }
]

for cheevo in pinMasteryAchievements
{
    GenerateSaveProtectedAchievementFromConditions(cheevo, pinMasteryConditions)
}

// End pin mastery achievements

achievement(title = "Battle Star", points = 5,
    description = "Earn a 🟊 ranking in battle on Hard or Ultimate difficulty.",
    trigger = AcquiredAtLeastRank("Star") && IsRankingRevealed()
        && IsAtLeastOnDifficulty("Hard")
)

timeLimit = 30
achievement(title = "Don't Kill Me Slowly", points = 5,
    description = "Defeat the Metal Corehog on Week 1, Day 2, within " + SecondsToFormat(timeLimit)
        + " (Normal or higher; Level 2 or below).",
    trigger = enemyId() == GetEnemyIdByName("Metal Corehog") && IsRankingRevealed() && battleTime() <= SecondsToFrames(timeLimit)
        && IsAtLeastOnDifficulty("Normal") && currentLevel() <= 2
)

function fusionLevel() => byte(0x37212d)

achievement(title = "No 1 2 Trust", points = 5,
    description = "Defeat the Vespertilio Canor on Week 1, Day 3, without activating a Fusion (Normal or higher; Level 3 or below).",
    trigger = enemyId() == GetEnemyIdByName("Vespertilio Canor") && EnterBattleCheckpointValid()
        && IsAtLeastOnDifficulty("Normal") && currentLevel() <= 3 && never(Delta(fusionLevel()) > fusionLevel())
        && IsRankingRevealed()
)

achievement(title = "Avenged", points = 25,
    description = "Defeat the Swing Shark on Week 1, Day 4, without any recovery pins equipped (Normal or higher; Level 4 or below).",
    trigger = enemyId() == GetEnemyIdByName("Swing Shark") && EnterBattleCheckpointValid()
        && IsAtLeastOnDifficulty("Normal") && currentLevel() <= 4 && IsRankingRevealed() && !HasRecoveryPinsEquipped()
)

achievement(title = "It's My Asskicking Outfit, Bitch!", points = 0,
    description = "Defeat X with Neku wearing only threads that don't share the same brand.",
    trigger = always_false()
)

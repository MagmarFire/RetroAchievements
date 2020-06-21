// World Ends with You, The
// #ID = 4887

// UTILITY

framesPerSecond = 60

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

function WasBitflagSetInGame(bit)
{
    return WasValueSetInGame(bit, 0, 1)
}

function WasValueSetInGame(mem, oldValue, newValue)
{
    return WasValueSet(mem, oldValue, newValue)
        && never(IsLoadingSaveFile())
}

function WasValueSet(mem, oldValue, newValue)
{
    return once(Delta(mem) == oldValue && mem == newValue)
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
        
        // This is the score when the game is loaded. If he loaded score is greater than or equal to the threshold--that is,
        // if the save file would satisfy enough conditions to trigger the achievement on load--this should trigger a
        // permanant pauselock to serve as save protection.
        array_push(loadedCounts, once(condition["countsWhen"] && IsLoadingSaveFile()))
        
        // We want both loaded and session counts here (that is, we don't care if we're loading a save file when these are tallied).
        // This way, loading a save doesn't invalidate the achievement outright if a player hasn't actually earned it yet.
        array_push(totalCounts, once(condition["countsWhen"]))
        
        resetAlt = resetAlt || condition["recalculateWhen"]
    }

    achievement(title = cheevo["name"], description = cheevo["description"], points = cheevo["points"],
        trigger = isOnTitleScreen() == 0x0
            && measured(tally(cheevo["threshold"], totalCounts)) && unless(tally(cheevo["threshold"], loadedCounts))
            && never(resetAlt)
    )
}

// This function serves the same purpose as the above save protection implementation and accepts the same parameters. However,
// this solution is less robust due to its lack of reliance on checking for both total counts and loaded counts. In exchange,
// the code generated from this function tends to be smaller, so it's useful if more robust save protection just isn't possible.
function GenerateSaveProtectedAchievementFromConditions_Naive(cheevo, conditions)
{
    counts = []
    resetalt = always_false()

    for i in conditions
    {
        condition = conditions[i]
        array_push(counts, once(condition["countsWhen"]))
    
        // We want to reset the hit counts each time the recalculateWhen condition is true in order
        // to refresh the hitcount state that represents each individual condition.
        resetalt = resetalt || never(condition["recalculateWhen"]) && unless(IsLoadingSaveFile())
    }

    // However, we also don't want to do anything if no condition is changed on a given frame
    // as a save protection measure. A two-frame target is used for the same reason as the above, as well.
    unlessValueStatesAreIdle = unless(repeated(2, always_true()))

    achievement(title = cheevo["name"], description = cheevo["description"], points = cheevo["points"],
        trigger = isOnTitleScreen() == 0x0
            && measured(tally(cheevo["threshold"], counts)) && unlessValueStatesAreIdle
            && resetalt
    )
}

// $066a30: Appears to correlate to the screen you're on in some way:
//
//          0x3 = battle
//          0x1c = Noise Report
//          0x1e = overworld
//          0x25 = title screen
//          0x2b = Phone Menu (items, pins, save only)
//          0x2c = battle results
//          0x2d = Friends
function screen() => word(0x066a30)
function IsOnResultsScreen() => screen() == 0x2c

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
function IsRetryingOnEasy() => byte(0x074e51) == 0x0

function IsAtLeastOnDifficulty(value)
{
    if (value == "Easy")
    {
        return difficulty() == 0x0 || IsRetryingOnEasy()
    }
    else if (value == "Normal")
    {
        return difficulty() >= 0x1 && !IsRetryingOnEasy()
    }
    else if (value == "Hard")
    {
        return difficulty() >= 0x2 && !IsRetryingOnEasy()
    }
    else if (value == "Ultimate")
    {
        return difficulty() >= 0x3 && !IsRetryingOnEasy()
    }
}

// $071D84: Deck 1, Slot 1, Pin ID (16-bit)
// $0737B8: ESP'er Points
// $0737c0: Chapter
function chapter() => byte(0x0737c0)

function PlayerHasAccessedChapterSelectMenuBefore()
{
    return bit5(0x074034) == 0x1
}

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
0x25: { "id": 0x25, "name": "Somewhere in Shibuya...", },
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
function WonBattleAndOnResultsScreen() => once(WonBattle()) && IsOnResultsScreen()

// $074E56: Enemy ID
function enemyId() => word(0x074e56)

enemies = {
"Metal Corehog": { "id": 0x7d, "name": "Metal Corehog", },
"Vespertilio Canor": { "id": 0x7, "name": "Vespertilio Canor", },
"Swing Shark": { "id": 0x81, "name": "Swing Shark", },
"Circle Pit Grizzly": { "id": 0x84, "name": "Circle Pit Grizzly", },
"Cornix Canor": { "id": 0x9, "name": "Cornix Canor", },
"Ovis Cantus": { "id": 0x13, "name": "Ovis Cantus", },
"Dub Rhino": { "id": 0x89, "name": "Dub Rhino", },
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
// DECK/STOCKPILE (10 bytes each)
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
0x0: { "ID": 0x0, "Name": "Ice Blow", "MaxLevel": 7, "Mingle?": 0, "Psych": "Piercing Pillar", "Recovery?": 0, "Element": "Neg", "Brand": "D+B", "Ev. fr. pin?": 0 },
0x1: { "ID": 0x1, "Name": "Ice Risers", "MaxLevel": 10, "Mingle?": 0, "Psych": "Piercing Pillar", "Recovery?": 0, "Element": "Neg", "Brand": "D+B", "Ev. fr. pin?": 1 },
0x2: { "ID": 0x2, "Name": "Frozen Cool", "MaxLevel": 4, "Mingle?": 0, "Psych": "Piercing Pillar", "Recovery?": 0, "Element": "Neg", "Brand": "D+B", "Ev. fr. pin?": 0 },
0x3: { "ID": 0x3, "Name": "Blizzard Cool", "MaxLevel": 4, "Mingle?": 1, "Psych": "Piercing Pillar", "Recovery?": 0, "Element": "Neg", "Brand": "D+B", "Ev. fr. pin?": 1 },
0x4: { "ID": 0x4, "Name": "Earthshake", "MaxLevel": 5, "Mingle?": 0, "Psych": "Earthquake", "Recovery?": 0, "Element": "Pos", "Brand": "D+B", "Ev. fr. pin?": 0 },
0x5: { "ID": 0x5, "Name": "Sexy D", "MaxLevel": 4, "Mingle?": 0, "Psych": "Psychokinesis", "Recovery?": 0, "Element": "Neu", "Brand": "D+B", "Ev. fr. pin?": 0 },
0x6: { "ID": 0x6, "Name": "Sexy +", "MaxLevel": 4, "Mingle?": 0, "Psych": "Psychokinesis", "Recovery?": 0, "Element": "Neu", "Brand": "D+B", "Ev. fr. pin?": 0 },
0x7: { "ID": 0x7, "Name": "Sexy B", "MaxLevel": 5, "Mingle?": 0, "Psych": "Psychokinesis", "Recovery?": 0, "Element": "Neu", "Brand": "D+B", "Ev. fr. pin?": 1 },
0x8: { "ID": 0x8, "Name": "Straitjacket", "MaxLevel": 5, "Mingle?": 0, "Psych": "Mobility Blight+", "Recovery?": 0, "Element": "Abi", "Brand": "D+B", "Ev. fr. pin?": 0 },
0x9: { "ID": 0x9, "Name": "Blown Kiss", "MaxLevel": 2, "Mingle?": 0, "Psych": "Subconscious", "Recovery?": 1, "Element": "---", "Brand": "D+B", "Ev. fr. pin?": 0 },
0xA: { "ID": 0xA, "Name": "D+B", "MaxLevel": 3, "Mingle?": 0, "Psych": "Resonance: DB", "Recovery?": 0, "Element": "Abi", "Brand": "D+B", "Ev. fr. pin?": 0 },
0xB: { "ID": 0xB, "Name": "Happy Beam", "MaxLevel": 6, "Mingle?": 0, "Psych": "Energy Rounds", "Recovery?": 0, "Element": "Neg", "Brand": "Natural Puppy", "Ev. fr. pin?": 0 },
0xC: { "ID": 0xC, "Name": "Natural Magnum", "MaxLevel": 5, "Mingle?": 0, "Psych": "Energy Rounds", "Recovery?": 0, "Element": "Neg", "Brand": "Natural Puppy", "Ev. fr. pin?": 1 },
0xD: { "ID": 0xD, "Name": "Wonder Magnum", "MaxLevel": 4, "Mingle?": 0, "Psych": "Energy Rounds", "Recovery?": 0, "Element": "Neg", "Brand": "Natural Puppy", "Ev. fr. pin?": 1 },
0xE: { "ID": 0xE, "Name": "Beauty Launcher", "MaxLevel": 5, "Mingle?": 1, "Psych": "Energy Rounds", "Recovery?": 0, "Element": "Neg", "Brand": "Natural Puppy", "Ev. fr. pin?": 1 },
0xF: { "ID": 0xF, "Name": "One Love Magnum", "MaxLevel": 6, "Mingle?": 0, "Psych": "Energy Rounds", "Recovery?": 0, "Element": "Neg", "Brand": "Natural Puppy", "Ev. fr. pin?": 0 },
0x10: { "ID": 0x10, "Name": "Hounder Magnum", "MaxLevel": 5, "Mingle?": 0, "Psych": "Energy Rounds", "Recovery?": 0, "Element": "Neg", "Brand": "Natural Puppy", "Ev. fr. pin?": 1 },
0x11: { "ID": 0x11, "Name": "Bear Hug Magnum", "MaxLevel": 5, "Mingle?": 0, "Psych": "Energy Rounds", "Recovery?": 0, "Element": "Neg", "Brand": "Natural Puppy", "Ev. fr. pin?": 1 },
0x12: { "ID": 0x12, "Name": "Sparkle Beam", "MaxLevel": 4, "Mingle?": 1, "Psych": "Energy Rounds", "Recovery?": 0, "Element": "Neg", "Brand": "Natural Puppy", "Ev. fr. pin?": 1 },
0x13: { "ID": 0x13, "Name": "Lil' Terror Bazooka", "MaxLevel": 3, "Mingle?": 0, "Psych": "Energy Rounds", "Recovery?": 0, "Element": "Neg", "Brand": "Natural Puppy", "Ev. fr. pin?": 1 },
0x14: { "ID": 0x14, "Name": "Angel Magnum", "MaxLevel": 4, "Mingle?": 0, "Psych": "Energy Rounds", "Recovery?": 0, "Element": "Neg", "Brand": "Natural Puppy", "Ev. fr. pin?": 1 },
0x15: { "ID": 0x15, "Name": "Cutie Beam", "MaxLevel": 5, "Mingle?": 0, "Psych": "Force Rounds", "Recovery?": 0, "Element": "Neg", "Brand": "Natural Puppy", "Ev. fr. pin?": 0 },
0x16: { "ID": 0x16, "Name": "Lovely Beam", "MaxLevel": 6, "Mingle?": 0, "Psych": "Force Rounds", "Recovery?": 0, "Element": "Neg", "Brand": "Natural Puppy", "Ev. fr. pin?": 1 },
0x17: { "ID": 0x17, "Name": "Sexy Beam", "MaxLevel": 7, "Mingle?": 0, "Psych": "Force Rounds", "Recovery?": 0, "Element": "Neg", "Brand": "Natural Puppy", "Ev. fr. pin?": 1 },
0x18: { "ID": 0x18, "Name": "Superfine Beam", "MaxLevel": 8, "Mingle?": 0, "Psych": "Force Rounds", "Recovery?": 0, "Element": "Neg", "Brand": "Natural Puppy", "Ev. fr. pin?": 1 },
0x19: { "ID": 0x19, "Name": "Playmate Beam", "MaxLevel": 3, "Mingle?": 0, "Psych": "Force Rounds", "Recovery?": 0, "Element": "Neg", "Brand": "Natural Puppy", "Ev. fr. pin?": 0 },
0x1A: { "ID": 0x1A, "Name": "Purity Launcher", "MaxLevel": 3, "Mingle?": 0, "Psych": "Force Rounds", "Recovery?": 0, "Element": "Neg", "Brand": "Natural Puppy", "Ev. fr. pin?": 1 },
0x1B: { "ID": 0x1B, "Name": "Innocence Beam", "MaxLevel": 5, "Mingle?": 0, "Psych": "Force Rounds", "Recovery?": 0, "Element": "Neg", "Brand": "Natural Puppy", "Ev. fr. pin?": 1 },
0x1C: { "ID": 0x1C, "Name": "Pop Pendulum", "MaxLevel": 5, "Mingle?": 0, "Psych": "Patrol Rounds", "Recovery?": 0, "Element": "Neg", "Brand": "Natural Puppy", "Ev. fr. pin?": 0 },
0x1D: { "ID": 0x1D, "Name": "Casual Pendulum", "MaxLevel": 3, "Mingle?": 0, "Psych": "Patrol Rounds", "Recovery?": 0, "Element": "Neg", "Brand": "Natural Puppy", "Ev. fr. pin?": 0 },
0x1E: { "ID": 0x1E, "Name": "Love Me Tether", "MaxLevel": 5, "Mingle?": 0, "Psych": "Entanglement", "Recovery?": 0, "Element": "Neg", "Brand": "Natural Puppy", "Ev. fr. pin?": 0 },
0x1F: { "ID": 0x1F, "Name": "Pamper Me Tether", "MaxLevel": 5, "Mingle?": 0, "Psych": "Entanglement", "Recovery?": 0, "Element": "Neg", "Brand": "Natural Puppy", "Ev. fr. pin?": 1 },
0x20: { "ID": 0x20, "Name": "Sweet Talk Tether", "MaxLevel": 5, "Mingle?": 0, "Psych": "Entanglement", "Recovery?": 0, "Element": "Neg", "Brand": "Natural Puppy", "Ev. fr. pin?": 1 },
0x21: { "ID": 0x21, "Name": "Natural Puppy", "MaxLevel": 3, "Mingle?": 0, "Psych": "Resonance: NP", "Recovery?": 0, "Element": "Abi", "Brand": "Natural Puppy", "Ev. fr. pin?": 0 },
0x22: { "ID": 0x22, "Name": "Frantic", "MaxLevel": 3, "Mingle?": 0, "Psych": "Twister", "Recovery?": 0, "Element": "Neg", "Brand": "Pavo Real", "Ev. fr. pin?": 0 },
0x23: { "ID": 0x23, "Name": "Blink Step", "MaxLevel": 3, "Mingle?": 0, "Psych": "Invisibility", "Recovery?": 0, "Element": "---", "Brand": "Pavo Real", "Ev. fr. pin?": 0 },
0x24: { "ID": 0x24, "Name": "First Gear", "MaxLevel": 5, "Mingle?": 0, "Psych": "Teleport", "Recovery?": 0, "Element": "---", "Brand": "Pavo Real", "Ev. fr. pin?": 1 },
0x25: { "ID": 0x25, "Name": "Top Gear", "MaxLevel": 3, "Mingle?": 0, "Psych": "Teleport", "Recovery?": 0, "Element": "---", "Brand": "Pavo Real", "Ev. fr. pin?": 1 },
0x26: { "ID": 0x26, "Name": "Egg Bomb", "MaxLevel": 4, "Mingle?": 0, "Psych": "Pressure Mine", "Recovery?": 0, "Element": "Neu", "Brand": "Pavo Real", "Ev. fr. pin?": 0 },
0x27: { "ID": 0x27, "Name": "Meteor Magnet", "MaxLevel": 6, "Mingle?": 0, "Psych": "Apport", "Recovery?": 0, "Element": "Neg", "Brand": "Pavo Real", "Ev. fr. pin?": 0 },
0x28: { "ID": 0x28, "Name": "Meteor Hook", "MaxLevel": 7, "Mingle?": 1, "Psych": "Apport", "Recovery?": 0, "Element": "Neg", "Brand": "Pavo Real", "Ev. fr. pin?": 1 },
0x29: { "ID": 0x29, "Name": "Meteor Spike", "MaxLevel": 8, "Mingle?": 1, "Psych": "Apport", "Recovery?": 0, "Element": "Neg", "Brand": "Pavo Real", "Ev. fr. pin?": 1 },
0x2A: { "ID": 0x2A, "Name": "Strong Heart", "MaxLevel": 5, "Mingle?": 0, "Psych": "Life Blight", "Recovery?": 0, "Element": "Abi", "Brand": "Pavo Real", "Ev. fr. pin?": 0 },
0x2B: { "ID": 0x2B, "Name": "Strong Spirit", "MaxLevel": 5, "Mingle?": 0, "Psych": "Attack Blight", "Recovery?": 0, "Element": "Abi", "Brand": "Pavo Real", "Ev. fr. pin?": 0 },
0x2C: { "ID": 0x2C, "Name": "Strong Body", "MaxLevel": 5, "Mingle?": 0, "Psych": "Defense Blight", "Recovery?": 0, "Element": "Abi", "Brand": "Pavo Real", "Ev. fr. pin?": 0 },
0x2D: { "ID": 0x2D, "Name": "Strong 'n Proud", "MaxLevel": 5, "Mingle?": 0, "Psych": "Mobility Blight", "Recovery?": 0, "Element": "Abi", "Brand": "Pavo Real", "Ev. fr. pin?": 0 },
0x2E: { "ID": 0x2E, "Name": "Poison Scorpion", "MaxLevel": 2, "Mingle?": 0, "Psych": "Doomed Life", "Recovery?": 0, "Element": "Abi", "Brand": "Pavo Real", "Ev. fr. pin?": 0 },
0x2F: { "ID": 0x2F, "Name": "Poison Skull", "MaxLevel": 2, "Mingle?": 0, "Psych": "Doomed Attack", "Recovery?": 0, "Element": "Abi", "Brand": "Pavo Real", "Ev. fr. pin?": 0 },
0x30: { "ID": 0x30, "Name": "Poison Bones", "MaxLevel": 3, "Mingle?": 0, "Psych": "Doomed Defense", "Recovery?": 0, "Element": "Abi", "Brand": "Pavo Real", "Ev. fr. pin?": 0 },
0x31: { "ID": 0x31, "Name": "Poison Chains", "MaxLevel": 3, "Mingle?": 0, "Psych": "Doomed Mobility", "Recovery?": 0, "Element": "Abi", "Brand": "Pavo Real", "Ev. fr. pin?": 0 },
0x32: { "ID": 0x32, "Name": "Rapier Glance", "MaxLevel": 3, "Mingle?": 1, "Psych": "Doomed Attack+", "Recovery?": 0, "Element": "Abi", "Brand": "Pavo Real", "Ev. fr. pin?": 1 },
0x33: { "ID": 0x33, "Name": "Love Charge", "MaxLevel": 1, "Mingle?": 0, "Psych": "Cure Boost", "Recovery?": 0, "Element": "Abi", "Brand": "Pavo Real", "Ev. fr. pin?": 0 },
0x34: { "ID": 0x34, "Name": "Guardian Angel", "MaxLevel": 5, "Mingle?": 0, "Psych": "Subconscious", "Recovery?": 0, "Element": "---", "Brand": "Pavo Real", "Ev. fr. pin?": 0 },
0x35: { "ID": 0x35, "Name": "Archangel", "MaxLevel": 3, "Mingle?": 0, "Psych": "Subconscious", "Recovery?": 1, "Element": "---", "Brand": "Pavo Real", "Ev. fr. pin?": 1 },
0x36: { "ID": 0x36, "Name": "Energy Factor", "MaxLevel": 5, "Mingle?": 0, "Psych": "Turbo Gauge", "Recovery?": 0, "Element": "Abi", "Brand": "Pavo Real", "Ev. fr. pin?": 0 },
0x37: { "ID": 0x37, "Name": "Speed Factor", "MaxLevel": 1, "Mingle?": 0, "Psych": "Turbo Reboot", "Recovery?": 0, "Element": "Abi", "Brand": "Pavo Real", "Ev. fr. pin?": 0 },
0x38: { "ID": 0x38, "Name": "Supply Factor", "MaxLevel": 3, "Mingle?": 0, "Psych": "Supply Boost", "Recovery?": 0, "Element": "Abi", "Brand": "Pavo Real", "Ev. fr. pin?": 0 },
0x39: { "ID": 0x39, "Name": "Chaos", "MaxLevel": 3, "Mingle?": 0, "Psych": "Doomed Life+", "Recovery?": 0, "Element": "Abi", "Brand": "Pavo Real", "Ev. fr. pin?": 1 },
0x3A: { "ID": 0x3A, "Name": "Pavo Real", "MaxLevel": 3, "Mingle?": 0, "Psych": "Resonance: PR", "Recovery?": 0, "Element": "Abi", "Brand": "Pavo Real", "Ev. fr. pin?": 0 },
0x3B: { "ID": 0x3B, "Name": "Lightning Moon", "MaxLevel": 5, "Mingle?": 0, "Psych": "Spark Core", "Recovery?": 0, "Element": "Neg", "Brand": "Mus Rattus", "Ev. fr. pin?": 0 },
0x3C: { "ID": 0x3C, "Name": "Lightning Storm", "MaxLevel": 5, "Mingle?": 0, "Psych": "Spark Core", "Recovery?": 0, "Element": "Neg", "Brand": "Mus Rattus", "Ev. fr. pin?": 0 },
0x3D: { "ID": 0x3D, "Name": "Burning Cherry", "MaxLevel": 5, "Mingle?": 0, "Psych": "Flame Core", "Recovery?": 0, "Element": "Neg", "Brand": "Mus Rattus", "Ev. fr. pin?": 0 },
0x3E: { "ID": 0x3E, "Name": "Burning Melon", "MaxLevel": 5, "Mingle?": 0, "Psych": "Flame Core", "Recovery?": 0, "Element": "Neg", "Brand": "Mus Rattus", "Ev. fr. pin?": 1 },
0x3F: { "ID": 0x3F, "Name": "Burning Berry", "MaxLevel": 5, "Mingle?": 0, "Psych": "Flame Core", "Recovery?": 0, "Element": "Neg", "Brand": "Mus Rattus", "Ev. fr. pin?": 1 },
0x40: { "ID": 0x40, "Name": "Aqua Monster", "MaxLevel": 4, "Mingle?": 0, "Psych": "Splash Core", "Recovery?": 0, "Element": "Neg", "Brand": "Mus Rattus", "Ev. fr. pin?": 0 },
0x41: { "ID": 0x41, "Name": "Aqua Ghost", "MaxLevel": 5, "Mingle?": 0, "Psych": "Splash Core", "Recovery?": 0, "Element": "Neg", "Brand": "Mus Rattus", "Ev. fr. pin?": 0 },
0x42: { "ID": 0x42, "Name": "Aqua Demon", "MaxLevel": 5, "Mingle?": 0, "Psych": "Splash Core", "Recovery?": 0, "Element": "Neg", "Brand": "Mus Rattus", "Ev. fr. pin?": 1 },
0x43: { "ID": 0x43, "Name": "Cornered Rat", "MaxLevel": 5, "Mingle?": 0, "Psych": "Holy Light", "Recovery?": 0, "Element": "Neg", "Brand": "Mus Rattus", "Ev. fr. pin?": 0 },
0x44: { "ID": 0x44, "Name": "Blast Warning", "MaxLevel": 5, "Mingle?": 0, "Psych": "Pyrokinesis", "Recovery?": 0, "Element": "Neg", "Brand": "Mus Rattus", "Ev. fr. pin?": 0 },
0x45: { "ID": 0x45, "Name": "Candle Service", "MaxLevel": 3, "Mingle?": 0, "Psych": "Explosion", "Recovery?": 0, "Element": "Neg", "Brand": "Mus Rattus", "Ev. fr. pin?": 0 },
0x46: { "ID": 0x46, "Name": "Shock Warning", "MaxLevel": 5, "Mingle?": 0, "Psych": "Shockwave", "Recovery?": 0, "Element": "Pos", "Brand": "Mus Rattus", "Ev. fr. pin?": 0 },
0x47: { "ID": 0x47, "Name": "Kinetic Warning", "MaxLevel": 5, "Mingle?": 0, "Psych": "Psychokinesis", "Recovery?": 0, "Element": "Neu", "Brand": "Mus Rattus", "Ev. fr. pin?": 0 },
0x48: { "ID": 0x48, "Name": "Impact Warning", "MaxLevel": 5, "Mingle?": 0, "Psych": "Apport", "Recovery?": 0, "Element": "Neg", "Brand": "Mus Rattus", "Ev. fr. pin?": 0 },
0x49: { "ID": 0x49, "Name": "Storm Warning", "MaxLevel": 5, "Mingle?": 0, "Psych": "Thunderbolt", "Recovery?": 0, "Element": "Neg", "Brand": "Mus Rattus", "Ev. fr. pin?": 0 },
0x4A: { "ID": 0x4A, "Name": "Electric Warning", "MaxLevel": 1, "Mingle?": 0, "Psych": "Lightning Arrester", "Recovery?": 0, "Element": "Neg", "Brand": "Mus Rattus", "Ev. fr. pin?": 0 },
0x4B: { "ID": 0x4B, "Name": "Teleport Warning", "MaxLevel": 3, "Mingle?": 0, "Psych": "Invisibility", "Recovery?": 0, "Element": "---", "Brand": "Mus Rattus", "Ev. fr. pin?": 0 },
0x4C: { "ID": 0x4C, "Name": "Shout", "MaxLevel": 5, "Mingle?": 0, "Psych": "Street Jam", "Recovery?": 0, "Element": "Neg", "Brand": "Mus Rattus", "Ev. fr. pin?": 0 },
0x4D: { "ID": 0x4D, "Name": "Psych Support", "MaxLevel": 3, "Mingle?": 0, "Psych": "Supply Boost+", "Recovery?": 0, "Element": "Abi", "Brand": "Mus Rattus", "Ev. fr. pin?": 0 },
0x4E: { "ID": 0x4E, "Name": "Stopper Spark", "MaxLevel": 1, "Mingle?": 0, "Psych": "Doomed Mobility+", "Recovery?": 0, "Element": "Abi", "Brand": "Mus Rattus", "Ev. fr. pin?": 0 },
0x4F: { "ID": 0x4F, "Name": "Mus Rattus", "MaxLevel": 3, "Mingle?": 0, "Psych": "Resonance: MR", "Recovery?": 0, "Element": "Abi", "Brand": "Mus Rattus", "Ev. fr. pin?": 0 },
0x50: { "ID": 0x50, "Name": "Masamune", "MaxLevel": 7, "Mingle?": 0, "Psych": "Shockwave", "Recovery?": 0, "Element": "Pos", "Brand": "Jupiter of the Monkey", "Ev. fr. pin?": 0 },
0x51: { "ID": 0x51, "Name": "Onikiri", "MaxLevel": 7, "Mingle?": 0, "Psych": "Shockwave", "Recovery?": 0, "Element": "Pos", "Brand": "Jupiter of the Monkey", "Ev. fr. pin?": 1 },
0x52: { "ID": 0x52, "Name": "Nenekiri", "MaxLevel": 7, "Mingle?": 0, "Psych": "Shockwave", "Recovery?": 0, "Element": "Pos", "Brand": "Jupiter of the Monkey", "Ev. fr. pin?": 1 },
0x53: { "ID": 0x53, "Name": "Kanesada", "MaxLevel": 7, "Mingle?": 0, "Psych": "Shockwave", "Recovery?": 0, "Element": "Pos", "Brand": "Jupiter of the Monkey", "Ev. fr. pin?": 1 },
0x54: { "ID": 0x54, "Name": "Enju", "MaxLevel": 7, "Mingle?": 0, "Psych": "Shockwave", "Recovery?": 0, "Element": "Pos", "Brand": "Jupiter of the Monkey", "Ev. fr. pin?": 1 },
0x55: { "ID": 0x55, "Name": "Yoshimitsu", "MaxLevel": 7, "Mingle?": 0, "Psych": "Shockwave", "Recovery?": 0, "Element": "Pos", "Brand": "Jupiter of the Monkey", "Ev. fr. pin?": 1 },
0x56: { "ID": 0x56, "Name": "Ichimonji", "MaxLevel": 5, "Mingle?": 0, "Psych": "Lance Lunge", "Recovery?": 0, "Element": "Pos", "Brand": "Jupiter of the Monkey", "Ev. fr. pin?": 0 },
0x57: { "ID": 0x57, "Name": "Nikkari", "MaxLevel": 5, "Mingle?": 0, "Psych": "Lance Lunge", "Recovery?": 0, "Element": "Pos", "Brand": "Jupiter of the Monkey", "Ev. fr. pin?": 1 },
0x58: { "ID": 0x58, "Name": "Mikazuki", "MaxLevel": 3, "Mingle?": 1, "Psych": "Lance Lunge", "Recovery?": 0, "Element": "Pos", "Brand": "Jupiter of the Monkey", "Ev. fr. pin?": 1 },
0x59: { "ID": 0x59, "Name": "Shiro", "MaxLevel": 20, "Mingle?": 0, "Psych": "Lance Lunge", "Recovery?": 0, "Element": "Pos", "Brand": "Jupiter of the Monkey", "Ev. fr. pin?": 0 },
0x5A: { "ID": 0x5A, "Name": "Unjo", "MaxLevel": 5, "Mingle?": 0, "Psych": "Stellar Flurry", "Recovery?": 0, "Element": "Pos", "Brand": "Jupiter of the Monkey", "Ev. fr. pin?": 0 },
0x5B: { "ID": 0x5B, "Name": "Izanagi", "MaxLevel": 5, "Mingle?": 0, "Psych": "Stellar Flurry", "Recovery?": 0, "Element": "Pos", "Brand": "Jupiter of the Monkey", "Ev. fr. pin?": 1 },
0x5C: { "ID": 0x5C, "Name": "Murasame", "MaxLevel": 4, "Mingle?": 0, "Psych": "Vulcan Uppercut", "Recovery?": 0, "Element": "Pos", "Brand": "Jupiter of the Monkey", "Ev. fr. pin?": 0 },
0x5D: { "ID": 0x5D, "Name": "Rakuyo", "MaxLevel": 4, "Mingle?": 0, "Psych": "Vulcan Uppercut", "Recovery?": 0, "Element": "Pos", "Brand": "Jupiter of the Monkey", "Ev. fr. pin?": 1 },
0x5E: { "ID": 0x5E, "Name": "Kusanagi", "MaxLevel": 4, "Mingle?": 1, "Psych": "Vulcan Uppercut", "Recovery?": 0, "Element": "Pos", "Brand": "Jupiter of the Monkey", "Ev. fr. pin?": 1 },
0x5F: { "ID": 0x5F, "Name": "Ohabari", "MaxLevel": 7, "Mingle?": 0, "Psych": "Grave Marker", "Recovery?": 0, "Element": "Pos", "Brand": "Jupiter of the Monkey", "Ev. fr. pin?": 0 },
0x60: { "ID": 0x60, "Name": "Zantetsu", "MaxLevel": 10, "Mingle?": 0, "Psych": "Spear Strike", "Recovery?": 0, "Element": "Pos", "Brand": "Jupiter of the Monkey", "Ev. fr. pin?": 1 },
0x61: { "ID": 0x61, "Name": "Mitama", "MaxLevel": 6, "Mingle?": 0, "Psych": "Vortex Saber", "Recovery?": 0, "Element": "Pos", "Brand": "Jupiter of the Monkey", "Ev. fr. pin?": 0 },
0x62: { "ID": 0x62, "Name": "Izanami", "MaxLevel": 1, "Mingle?": 0, "Psych": "Pyrokinesis", "Recovery?": 0, "Element": "Neg", "Brand": "Jupiter of the Monkey", "Ev. fr. pin?": 0 },
0x63: { "ID": 0x63, "Name": "Onmyo", "MaxLevel": 5, "Mingle?": 0, "Psych": "Street Jam", "Recovery?": 0, "Element": "Neg", "Brand": "Jupiter of the Monkey", "Ev. fr. pin?": 0 },
0x64: { "ID": 0x64, "Name": "Konohana", "MaxLevel": 3, "Mingle?": 0, "Psych": "Cure Drink", "Recovery?": 1, "Element": "---", "Brand": "Jupiter of the Monkey", "Ev. fr. pin?": 0 },
0x65: { "ID": 0x65, "Name": "Konohana Sakuya", "MaxLevel": 4, "Mingle?": 0, "Psych": "Healing", "Recovery?": 1, "Element": "---", "Brand": "Jupiter of the Monkey", "Ev. fr. pin?": 0 },
0x66: { "ID": 0x66, "Name": "Jupiter of the Monkey", "MaxLevel": 3, "Mingle?": 0, "Psych": "Resonance: JM", "Recovery?": 0, "Element": "Abi", "Brand": "Jupiter of the Monkey", "Ev. fr. pin?": 0 },
0x67: { "ID": 0x67, "Name": "Long Live the Rock", "MaxLevel": 4, "Mingle?": 0, "Psych": "Rock Bind", "Recovery?": 0, "Element": "Neg", "Brand": "Hip Snake", "Ev. fr. pin?": 0 },
0x68: { "ID": 0x68, "Name": "Long Live the Ice", "MaxLevel": 5, "Mingle?": 0, "Psych": "Freeze", "Recovery?": 0, "Element": "Neg", "Brand": "Hip Snake", "Ev. fr. pin?": 0 },
0x69: { "ID": 0x69, "Name": "Long Live the Floe", "MaxLevel": 5, "Mingle?": 0, "Psych": "Freeze", "Recovery?": 0, "Element": "Neg", "Brand": "Hip Snake", "Ev. fr. pin?": 1 },
0x6A: { "ID": 0x6A, "Name": "Eyes Full of Hope", "MaxLevel": 5, "Mingle?": 0, "Psych": "Holy Light", "Recovery?": 0, "Element": "Neg", "Brand": "Hip Snake", "Ev. fr. pin?": 0 },
0x6B: { "ID": 0x6B, "Name": "Eyes Full of Light", "MaxLevel": 5, "Mingle?": 0, "Psych": "Holy Light", "Recovery?": 0, "Element": "Neg", "Brand": "Hip Snake", "Ev. fr. pin?": 1 },
0x6C: { "ID": 0x6C, "Name": "Hot Gaze", "MaxLevel": 4, "Mingle?": 0, "Psych": "Ignition", "Recovery?": 0, "Element": "Neg", "Brand": "Hip Snake", "Ev. fr. pin?": 0 },
0x6D: { "ID": 0x6D, "Name": "Sizzling Gaze", "MaxLevel": 4, "Mingle?": 0, "Psych": "Ignition", "Recovery?": 0, "Element": "Neg", "Brand": "Hip Snake", "Ev. fr. pin?": 1 },
0x6E: { "ID": 0x6E, "Name": "Cold Stare", "MaxLevel": 10, "Mingle?": 0, "Psych": "Frostbite", "Recovery?": 0, "Element": "Neg", "Brand": "Hip Snake", "Ev. fr. pin?": 1 },
0x6F: { "ID": 0x6F, "Name": "Icy Stare", "MaxLevel": 10, "Mingle?": 0, "Psych": "Frostbite", "Recovery?": 0, "Element": "Neg", "Brand": "Hip Snake", "Ev. fr. pin?": 1 },
0x70: { "ID": 0x70, "Name": "Wassup Thunder!", "MaxLevel": 5, "Mingle?": 0, "Psych": "Thunderstorm", "Recovery?": 0, "Element": "Neg", "Brand": "Hip Snake", "Ev. fr. pin?": 0 },
0x71: { "ID": 0x71, "Name": "Wassup Lightning!", "MaxLevel": 5, "Mingle?": 0, "Psych": "Thunderstorm", "Recovery?": 0, "Element": "Neg", "Brand": "Hip Snake", "Ev. fr. pin?": 1 },
0x72: { "ID": 0x72, "Name": "Wassup Voltage!", "MaxLevel": 6, "Mingle?": 1, "Psych": "Thunderstorm", "Recovery?": 0, "Element": "Neg", "Brand": "Hip Snake", "Ev. fr. pin?": 1 },
0x73: { "ID": 0x73, "Name": "Indestructo Man", "MaxLevel": 1, "Mingle?": 0, "Psych": "Life Blight+", "Recovery?": 0, "Element": "Abi", "Brand": "Hip Snake", "Ev. fr. pin?": 0 },
0x74: { "ID": 0x74, "Name": "Hip Snake", "MaxLevel": 3, "Mingle?": 0, "Psych": "Resonance: HS", "Recovery?": 0, "Element": "Abi", "Brand": "Hip Snake", "Ev. fr. pin?": 0 },
0x75: { "ID": 0x75, "Name": "Octo Squeeze", "MaxLevel": 6, "Mingle?": 0, "Psych": "Sweeper", "Recovery?": 0, "Element": "---", "Brand": "Sheep Heavenly", "Ev. fr. pin?": 0 },
0x76: { "ID": 0x76, "Name": "Snail Squeeze", "MaxLevel": 5, "Mingle?": 0, "Psych": "Sweeper", "Recovery?": 0, "Element": "---", "Brand": "Sheep Heavenly", "Ev. fr. pin?": 1 },
0x77: { "ID": 0x77, "Name": "Vacu Squeeze", "MaxLevel": 5, "Mingle?": 1, "Psych": "Sweeper", "Recovery?": 0, "Element": "---", "Brand": "Sheep Heavenly", "Ev. fr. pin?": 1 },
0x78: { "ID": 0x78, "Name": "Gimme Dat Sheep", "MaxLevel": 2, "Mingle?": 0, "Psych": "Black Hole", "Recovery?": 0, "Element": "---", "Brand": "Sheep Heavenly", "Ev. fr. pin?": 1 },
0x79: { "ID": 0x79, "Name": "Gimme Dat Elephant", "MaxLevel": 2, "Mingle?": 0, "Psych": "Black Hole", "Recovery?": 0, "Element": "---", "Brand": "Sheep Heavenly", "Ev. fr. pin?": 1 },
0x7A: { "ID": 0x7A, "Name": "Gimme Dat Hippo", "MaxLevel": 2, "Mingle?": 1, "Psych": "Black Hole", "Recovery?": 0, "Element": "---", "Brand": "Sheep Heavenly", "Ev. fr. pin?": 1 },
0x7B: { "ID": 0x7B, "Name": "Crackle Pop Barrier", "MaxLevel": 5, "Mingle?": 0, "Psych": "Fire Barrier", "Recovery?": 0, "Element": "Pos", "Brand": "Sheep Heavenly", "Ev. fr. pin?": 0 },
0x7C: { "ID": 0x7C, "Name": "Splish Splash Barrier", "MaxLevel": 5, "Mingle?": 0, "Psych": "Aqua Barrier", "Recovery?": 0, "Element": "---", "Brand": "Sheep Heavenly", "Ev. fr. pin?": 1 },
0x7D: { "ID": 0x7D, "Name": "Creepy Weepy Barrier", "MaxLevel": 3, "Mingle?": 0, "Psych": "Dark Barrier", "Recovery?": 0, "Element": "Pos", "Brand": "Sheep Heavenly", "Ev. fr. pin?": 0 },
0x7E: { "ID": 0x7E, "Name": "Whirlygig Juggle", "MaxLevel": 3, "Mingle?": 0, "Psych": "Teleport", "Recovery?": 0, "Element": "---", "Brand": "Sheep Heavenly", "Ev. fr. pin?": 0 },
0x7F: { "ID": 0x7F, "Name": "Healing Bunny", "MaxLevel": 2, "Mingle?": 0, "Psych": "Cure Drink", "Recovery?": 1, "Element": "---", "Brand": "Sheep Heavenly", "Ev. fr. pin?": 0 },
0x80: { "ID": 0x80, "Name": "Healing Flamingo", "MaxLevel": 4, "Mingle?": 0, "Psych": "Cure Drink", "Recovery?": 1, "Element": "---", "Brand": "Sheep Heavenly", "Ev. fr. pin?": 0 },
0x81: { "ID": 0x81, "Name": "Healing Whale", "MaxLevel": 3, "Mingle?": 0, "Psych": "Cure Drink", "Recovery?": 1, "Element": "---", "Brand": "Sheep Heavenly", "Ev. fr. pin?": 1 },
0x82: { "ID": 0x82, "Name": "Croc Leisure", "MaxLevel": 5, "Mingle?": 0, "Psych": "Healing", "Recovery?": 1, "Element": "---", "Brand": "Sheep Heavenly", "Ev. fr. pin?": 0 },
0x83: { "ID": 0x83, "Name": "Monkey Leisure", "MaxLevel": 6, "Mingle?": 0, "Psych": "Healing", "Recovery?": 1, "Element": "---", "Brand": "Sheep Heavenly", "Ev. fr. pin?": 1 },
0x84: { "ID": 0x84, "Name": "Bear Leisure", "MaxLevel": 4, "Mingle?": 0, "Psych": "Healing", "Recovery?": 1, "Element": "---", "Brand": "Sheep Heavenly", "Ev. fr. pin?": 1 },
0x85: { "ID": 0x85, "Name": "Squirrel Leisure", "MaxLevel": 5, "Mingle?": 0, "Psych": "Healing", "Recovery?": 1, "Element": "---", "Brand": "Sheep Heavenly", "Ev. fr. pin?": 1 },
0x86: { "ID": 0x86, "Name": "Sparkle Charge", "MaxLevel": 3, "Mingle?": 0, "Psych": "Cure Boost+", "Recovery?": 0, "Element": "Abi", "Brand": "Sheep Heavenly", "Ev. fr. pin?": 0 },
0x87: { "ID": 0x87, "Name": "Handsfree Healing", "MaxLevel": 1, "Mingle?": 0, "Psych": "Subconscious", "Recovery?": 0, "Element": "---", "Brand": "Sheep Heavenly", "Ev. fr. pin?": 0 },
0x88: { "ID": 0x88, "Name": "Sheep Heavenly", "MaxLevel": 1, "Mingle?": 0, "Psych": "Resonance: SH", "Recovery?": 0, "Element": "Abi", "Brand": "Sheep Heavenly", "Ev. fr. pin?": 0 },
0x89: { "ID": 0x89, "Name": "Distortion", "MaxLevel": 4, "Mingle?": 0, "Psych": "Discharge", "Recovery?": 0, "Element": "Neg", "Brand": "Tigre Punks", "Ev. fr. pin?": 0 },
0x8A: { "ID": 0x8A, "Name": "Velocity Attack", "MaxLevel": 5, "Mingle?": 0, "Psych": "Velocity Attack", "Recovery?": 0, "Element": "Pos", "Brand": "Tigre Punks", "Ev. fr. pin?": 0 },
0x8B: { "ID": 0x8B, "Name": "Velocity Tackle", "MaxLevel": 10, "Mingle?": 1, "Psych": "Velocity Crash", "Recovery?": 0, "Element": "Pos", "Brand": "Tigre Punks", "Ev. fr. pin?": 1 },
0x8C: { "ID": 0x8C, "Name": "Demon's Hatred", "MaxLevel": 1, "Mingle?": 0, "Psych": "Explosion", "Recovery?": 0, "Element": "Neg", "Brand": "Tigre Punks", "Ev. fr. pin?": 0 },
0x8D: { "ID": 0x8D, "Name": "Go 2 Hell", "MaxLevel": 5, "Mingle?": 0, "Psych": "Spear Strike", "Recovery?": 0, "Element": "Pos", "Brand": "Tigre Punks", "Ev. fr. pin?": 0 },
0x8E: { "ID": 0x8E, "Name": "Go 2 Heaven", "MaxLevel": 4, "Mingle?": 1, "Psych": "Spear Strike", "Recovery?": 0, "Element": "Pos", "Brand": "Tigre Punks", "Ev. fr. pin?": 1 },
0x8F: { "ID": 0x8F, "Name": "Lightning Anger", "MaxLevel": 10, "Mingle?": 0, "Psych": "Vortex Saber", "Recovery?": 0, "Element": "Pos", "Brand": "Tigre Punks", "Ev. fr. pin?": 0 },
0x90: { "ID": 0x90, "Name": "Lightning Rage", "MaxLevel": 5, "Mingle?": 0, "Psych": "Vortex Saber", "Recovery?": 0, "Element": "Pos", "Brand": "Tigre Punks", "Ev. fr. pin?": 1 },
0x91: { "ID": 0x91, "Name": "LIVE!", "MaxLevel": 5, "Mingle?": 0, "Psych": "Street Jam", "Recovery?": 0, "Element": "Neg", "Brand": "Tigre Punks", "Ev. fr. pin?": 0 },
0x92: { "ID": 0x92, "Name": "Peace Full", "MaxLevel": 5, "Mingle?": 0, "Psych": "Cure Drink", "Recovery?": 1, "Element": "---", "Brand": "Tigre Punks", "Ev. fr. pin?": 0 },
0x93: { "ID": 0x93, "Name": "Thanx", "MaxLevel": 3, "Mingle?": 0, "Psych": "Healing", "Recovery?": 1, "Element": "---", "Brand": "Tigre Punks", "Ev. fr. pin?": 1 },
0x94: { "ID": 0x94, "Name": "D.I.Y.", "MaxLevel": 1, "Mingle?": 0, "Psych": "Attack Blight+", "Recovery?": 0, "Element": "Abi", "Brand": "Tigre Punks", "Ev. fr. pin?": 0 },
0x95: { "ID": 0x95, "Name": "Tigre Punks", "MaxLevel": 3, "Mingle?": 0, "Psych": "Resonance: TP", "Recovery?": 0, "Element": "Abi", "Brand": "Tigre Punks", "Ev. fr. pin?": 0 },
0x96: { "ID": 0x96, "Name": "One Stone, Many Birds", "MaxLevel": 6, "Mingle?": 0, "Psych": "Burst Rounds", "Recovery?": 0, "Element": "Neg", "Brand": "Dragon Couture", "Ev. fr. pin?": 0 },
0x97: { "ID": 0x97, "Name": "One Stroke, Vast Wealth", "MaxLevel": 10, "Mingle?": 0, "Psych": "Burst Rounds", "Recovery?": 0, "Element": "Neg", "Brand": "Dragon Couture", "Ev. fr. pin?": 1 },
0x98: { "ID": 0x98, "Name": "One Grain, Infinite Promise", "MaxLevel": 7, "Mingle?": 1, "Psych": "Burst Rounds", "Recovery?": 0, "Element": "Neg", "Brand": "Dragon Couture", "Ev. fr. pin?": 1 },
0x99: { "ID": 0x99, "Name": "Self Found, Others Lost", "MaxLevel": 4, "Mingle?": 0, "Psych": "Discharge", "Recovery?": 0, "Element": "Neg", "Brand": "Dragon Couture", "Ev. fr. pin?": 0 },
0x9A: { "ID": 0x9A, "Name": "Fiery Spirit, Spirited Fire", "MaxLevel": 5, "Mingle?": 0, "Psych": "Pyrokinesis", "Recovery?": 0, "Element": "Neg", "Brand": "Dragon Couture", "Ev. fr. pin?": 0 },
0x9B: { "ID": 0x9B, "Name": "Flames Afar, Foes Aflame", "MaxLevel": 5, "Mingle?": 0, "Psych": "Pyrokinesis", "Recovery?": 0, "Element": "Neg", "Brand": "Dragon Couture", "Ev. fr. pin?": 1 },
0x9C: { "ID": 0x9C, "Name": "Final Pyre, All Expired", "MaxLevel": 5, "Mingle?": 0, "Psych": "Pyrokinesis", "Recovery?": 0, "Element": "Neg", "Brand": "Dragon Couture", "Ev. fr. pin?": 1 },
0x9D: { "ID": 0x9D, "Name": "Blue Blood Burns Blue", "MaxLevel": 3, "Mingle?": 0, "Psych": "Flame Blast", "Recovery?": 0, "Element": "Neg", "Brand": "Dragon Couture", "Ev. fr. pin?": 1 },
0x9E: { "ID": 0x9E, "Name": "Live Slow, Die Fast", "MaxLevel": 6, "Mingle?": 0, "Psych": "Psychokinesis", "Recovery?": 0, "Element": "Neu", "Brand": "Dragon Couture", "Ev. fr. pin?": 0 },
0x9F: { "ID": 0x9F, "Name": "Local Fire, Distant Sea", "MaxLevel": 5, "Mingle?": 0, "Psych": "Psychokinesis", "Recovery?": 0, "Element": "Neu", "Brand": "Dragon Couture", "Ev. fr. pin?": 1 },
0xA0: { "ID": 0xA0, "Name": "June Hearth, January Fan", "MaxLevel": 4, "Mingle?": 1, "Psych": "Psychokinesis", "Recovery?": 0, "Element": "Neu", "Brand": "Dragon Couture", "Ev. fr. pin?": 1 },
0xA1: { "ID": 0xA1, "Name": "Swift Storm, Swift End", "MaxLevel": 5, "Mingle?": 0, "Psych": "Thundercloud", "Recovery?": 0, "Element": "Neg", "Brand": "Dragon Couture", "Ev. fr. pin?": 0 },
0xA2: { "ID": 0xA2, "Name": "Black Sky, White Bolt", "MaxLevel": 5, "Mingle?": 0, "Psych": "Thundercloud", "Recovery?": 0, "Element": "Neg", "Brand": "Dragon Couture", "Ev. fr. pin?": 1 },
0xA3: { "ID": 0xA3, "Name": "Follow Suit, Fall in Turn", "MaxLevel": 5, "Mingle?": 0, "Psych": "Thundercloud", "Recovery?": 0, "Element": "Neg", "Brand": "Dragon Couture", "Ev. fr. pin?": 1 },
0xA4: { "ID": 0xA4, "Name": "Dragon Couture", "MaxLevel": 3, "Mingle?": 0, "Psych": "Resonance: DC", "Recovery?": 0, "Element": "Abi", "Brand": "Dragon Couture", "Ev. fr. pin?": 0 },
0xA5: { "ID": 0xA5, "Name": "Lolita Bat", "MaxLevel": 5, "Mingle?": 0, "Psych": "Force Rounds", "Recovery?": 0, "Element": "Neg", "Brand": "Lapin Angelique", "Ev. fr. pin?": 0 },
0xA6: { "ID": 0xA6, "Name": "Skull Rabbit", "MaxLevel": 5, "Mingle?": 0, "Psych": "Force Rounds", "Recovery?": 0, "Element": "Neg", "Brand": "Lapin Angelique", "Ev. fr. pin?": 1 },
0xA7: { "ID": 0xA7, "Name": "Kaleidoscope", "MaxLevel": 10, "Mingle?": 0, "Psych": "Burst Rounds", "Recovery?": 0, "Element": "Neg", "Brand": "Lapin Angelique", "Ev. fr. pin?": 0 },
0xA8: { "ID": 0xA8, "Name": "Lolita Emblem", "MaxLevel": 3, "Mingle?": 0, "Psych": "Stellar Flurry", "Recovery?": 0, "Element": "Pos", "Brand": "Lapin Angelique", "Ev. fr. pin?": 0 },
0xA9: { "ID": 0xA9, "Name": "Lolita Chopper", "MaxLevel": 4, "Mingle?": 0, "Psych": "Stellar Flurry", "Recovery?": 0, "Element": "Pos", "Brand": "Lapin Angelique", "Ev. fr. pin?": 1 },
0xAA: { "ID": 0xAA, "Name": "Link Spider", "MaxLevel": 5, "Mingle?": 0, "Psych": "Thunderbolt", "Recovery?": 0, "Element": "Neg", "Brand": "Lapin Angelique", "Ev. fr. pin?": 0 },
0xAB: { "ID": 0xAB, "Name": "Web Spider", "MaxLevel": 5, "Mingle?": 0, "Psych": "Thunderbolt", "Recovery?": 0, "Element": "Neg", "Brand": "Lapin Angelique", "Ev. fr. pin?": 1 },
0xAC: { "ID": 0xAC, "Name": "Network Spider", "MaxLevel": 5, "Mingle?": 0, "Psych": "Thunderbolt", "Recovery?": 0, "Element": "Neg", "Brand": "Lapin Angelique", "Ev. fr. pin?": 1 },
0xAD: { "ID": 0xAD, "Name": "Lolita Mic", "MaxLevel": 1, "Mingle?": 0, "Psych": "Street Jam", "Recovery?": 0, "Element": "Neg", "Brand": "Lapin Angelique", "Ev. fr. pin?": 0 },
0xAE: { "ID": 0xAE, "Name": "Spider's Silk", "MaxLevel": 15, "Mingle?": 0, "Psych": "Apport", "Recovery?": 0, "Element": "Neg", "Brand": "Lapin Angelique", "Ev. fr. pin?": 0 },
0xAF: { "ID": 0xAF, "Name": "Leopard", "MaxLevel": 4, "Mingle?": 0, "Psych": "Cure Drink", "Recovery?": 1, "Element": "---", "Brand": "Lapin Angelique", "Ev. fr. pin?": 0 },
0xB0: { "ID": 0xB0, "Name": "Lolita Skull", "MaxLevel": 4, "Mingle?": 0, "Psych": "Healing", "Recovery?": 1, "Element": "---", "Brand": "Lapin Angelique", "Ev. fr. pin?": 1 },
0xB1: { "ID": 0xB1, "Name": "Black Rose", "MaxLevel": 3, "Mingle?": 0, "Psych": "Doomed Defense+", "Recovery?": 0, "Element": "Abi", "Brand": "Lapin Angelique", "Ev. fr. pin?": 0 },
0xB2: { "ID": 0xB2, "Name": "Lapin Angelique", "MaxLevel": 3, "Mingle?": 0, "Psych": "Resonance: LA", "Recovery?": 0, "Element": "Abi", "Brand": "Lapin Angelique", "Ev. fr. pin?": 0 },
0xB3: { "ID": 0xB3, "Name": "Thunder Pawn", "MaxLevel": 5, "Mingle?": 0, "Psych": "Spark Core", "Recovery?": 0, "Element": "Neg", "Brand": "Pegaso", "Ev. fr. pin?": 0 },
0xB4: { "ID": 0xB4, "Name": "Lightning Pawn", "MaxLevel": 4, "Mingle?": 0, "Psych": "Spark Core", "Recovery?": 0, "Element": "Neg", "Brand": "Pegaso", "Ev. fr. pin?": 1 },
0xB5: { "ID": 0xB5, "Name": "Aqua Pawn", "MaxLevel": 3, "Mingle?": 0, "Psych": "Splash Core", "Recovery?": 0, "Element": "Neg", "Brand": "Pegaso", "Ev. fr. pin?": 0 },
0xB6: { "ID": 0xB6, "Name": "Swing Bishop", "MaxLevel": 7, "Mingle?": 0, "Psych": "Patrol Rounds", "Recovery?": 0, "Element": "Neg", "Brand": "Pegaso", "Ev. fr. pin?": 0 },
0xB7: { "ID": 0xB7, "Name": "Pegaso Bishop", "MaxLevel": 5, "Mingle?": 0, "Psych": "Patrol Rounds", "Recovery?": 0, "Element": "Neg", "Brand": "Pegaso", "Ev. fr. pin?": 1 },
0xB8: { "ID": 0xB8, "Name": "King Arthur", "MaxLevel": 3, "Mingle?": 0, "Psych": "Lightning Bolt", "Recovery?": 0, "Element": "Neg", "Brand": "Pegaso", "Ev. fr. pin?": 0 },
0xB9: { "ID": 0xB9, "Name": "Excalibur", "MaxLevel": 5, "Mingle?": 0, "Psych": "Lightning Bolt", "Recovery?": 0, "Element": "Neg", "Brand": "Pegaso", "Ev. fr. pin?": 1 },
0xBA: { "ID": 0xBA, "Name": "Thunder Rook", "MaxLevel": 3, "Mingle?": 0, "Psych": "Lightning Arrester", "Recovery?": 0, "Element": "Neg", "Brand": "Pegaso", "Ev. fr. pin?": 0 },
0xBB: { "ID": 0xBB, "Name": "Lightning Rook", "MaxLevel": 4, "Mingle?": 0, "Psych": "Lightning Arrester", "Recovery?": 0, "Element": "Neg", "Brand": "Pegaso", "Ev. fr. pin?": 1 },
0xBC: { "ID": 0xBC, "Name": "Jack's Knight", "MaxLevel": 4, "Mingle?": 0, "Psych": "Psychokinesis", "Recovery?": 0, "Element": "Neu", "Brand": "Pegaso", "Ev. fr. pin?": 0 },
0xBD: { "ID": 0xBD, "Name": "King's Knight", "MaxLevel": 4, "Mingle?": 0, "Psych": "Psychokinesis", "Recovery?": 0, "Element": "Neu", "Brand": "Pegaso", "Ev. fr. pin?": 1 },
0xBE: { "ID": 0xBE, "Name": "Queen's Knight", "MaxLevel": 4, "Mingle?": 0, "Psych": "Psychokinesis", "Recovery?": 0, "Element": "Neu", "Brand": "Pegaso", "Ev. fr. pin?": 1 },
0xBF: { "ID": 0xBF, "Name": "Her Royal Highness", "MaxLevel": 3, "Mingle?": 0, "Psych": "Turbo Gauge+", "Recovery?": 0, "Element": "Abi", "Brand": "Pegaso", "Ev. fr. pin?": 0 },
0xC0: { "ID": 0xC0, "Name": "Pegaso", "MaxLevel": 3, "Mingle?": 0, "Psych": "Resonance: PG", "Recovery?": 0, "Element": "Abi", "Brand": "Pegaso", "Ev. fr. pin?": 0 },
0xC1: { "ID": 0xC1, "Name": "Lazy Bomber", "MaxLevel": 7, "Mingle?": 0, "Psych": "Time Bomb", "Recovery?": 0, "Element": "Neg", "Brand": "Wild Boar", "Ev. fr. pin?": 0 },
0xC2: { "ID": 0xC2, "Name": "Flower of Flame", "MaxLevel": 3, "Mingle?": 0, "Psych": "Explosion", "Recovery?": 0, "Element": "Neg", "Brand": "Wild Boar", "Ev. fr. pin?": 0 },
0xC3: { "ID": 0xC3, "Name": "Flower of Fire", "MaxLevel": 4, "Mingle?": 0, "Psych": "Explosion", "Recovery?": 0, "Element": "Neg", "Brand": "Wild Boar", "Ev. fr. pin?": 1 },
0xC4: { "ID": 0xC4, "Name": "Kewl Line", "MaxLevel": 5, "Mingle?": 0, "Psych": "Massive Hit", "Recovery?": 0, "Element": "Pos", "Brand": "Wild Boar", "Ev. fr. pin?": 0 },
0xC5: { "ID": 0xC5, "Name": "Dope Line", "MaxLevel": 5, "Mingle?": 0, "Psych": "Massive Hit", "Recovery?": 0, "Element": "Pos", "Brand": "Wild Boar", "Ev. fr. pin?": 1 },
0xC6: { "ID": 0xC6, "Name": "Wild Line", "MaxLevel": 4, "Mingle?": 0, "Psych": "Massive Hit", "Recovery?": 0, "Element": "Pos", "Brand": "Wild Boar", "Ev. fr. pin?": 1 },
0xC7: { "ID": 0xC7, "Name": "Fly Line", "MaxLevel": 5, "Mingle?": 0, "Psych": "Grave Marker", "Recovery?": 0, "Element": "Pos", "Brand": "Wild Boar", "Ev. fr. pin?": 0 },
0xC8: { "ID": 0xC8, "Name": "Fresh Line", "MaxLevel": 5, "Mingle?": 0, "Psych": "Grave Marker", "Recovery?": 0, "Element": "Pos", "Brand": "Wild Boar", "Ev. fr. pin?": 1 },
0xC9: { "ID": 0xC9, "Name": "Microcosmic Pull", "MaxLevel": 4, "Mingle?": 0, "Psych": "Apport", "Recovery?": 0, "Element": "Neg", "Brand": "Wild Boar", "Ev. fr. pin?": 0 },
0xCA: { "ID": 0xCA, "Name": "Cosmic Pull", "MaxLevel": 3, "Mingle?": 0, "Psych": "Apport", "Recovery?": 0, "Element": "Neg", "Brand": "Wild Boar", "Ev. fr. pin?": 1 },
0xCB: { "ID": 0xCB, "Name": "Macrocosmic Pull", "MaxLevel": 2, "Mingle?": 0, "Psych": "Apport", "Recovery?": 0, "Element": "Neg", "Brand": "Wild Boar", "Ev. fr. pin?": 1 },
0xCC: { "ID": 0xCC, "Name": "Diss", "MaxLevel": 1, "Mingle?": 0, "Psych": "Defense Blight+", "Recovery?": 0, "Element": "Abi", "Brand": "Wild Boar", "Ev. fr. pin?": 0 },
0xCD: { "ID": 0xCD, "Name": "Wild Boar", "MaxLevel": 3, "Mingle?": 0, "Psych": "Resonance: WB", "Recovery?": 0, "Element": "Abi", "Brand": "Wild Boar", "Ev. fr. pin?": 0 },
0xCE: { "ID": 0xCE, "Name": "Big Bang", "MaxLevel": 10, "Mingle?": 0, "Psych": "Nexus Ray", "Recovery?": 0, "Element": "Neg", "Brand": "Gatito", "Ev. fr. pin?": 0 },
0xCF: { "ID": 0xCF, "Name": "Big Crunch", "MaxLevel": 10, "Mingle?": 0, "Psych": "Nexus Ray", "Recovery?": 0, "Element": "Neg", "Brand": "Gatito", "Ev. fr. pin?": 0 },
0xD0: { "ID": 0xD0, "Name": "Swift as the Wind", "MaxLevel": 10, "Mingle?": 0, "Psych": "Irregular Note", "Recovery?": 0, "Element": "Neu", "Brand": "Gatito", "Ev. fr. pin?": 0 },
0xD1: { "ID": 0xD1, "Name": "Hushed as the Wood", "MaxLevel": 10, "Mingle?": 0, "Psych": "Irregular Note", "Recovery?": 0, "Element": "Neu", "Brand": "Gatito", "Ev. fr. pin?": 0 },
0xD2: { "ID": 0xD2, "Name": "Fierce as the Flame", "MaxLevel": 10, "Mingle?": 0, "Psych": "Irregular Note", "Recovery?": 0, "Element": "Neu", "Brand": "Gatito", "Ev. fr. pin?": 0 },
0xD3: { "ID": 0xD3, "Name": "Stalwart as the Mount", "MaxLevel": 10, "Mingle?": 0, "Psych": "Irregular Note", "Recovery?": 0, "Element": "Neu", "Brand": "Gatito", "Ev. fr. pin?": 0 },
0xD4: { "ID": 0xD4, "Name": "Black Mars", "MaxLevel": 10, "Mingle?": 0, "Psych": "Pyrokinesis", "Recovery?": 0, "Element": "Neg", "Brand": "Gatito", "Ev. fr. pin?": 0 },
0xD5: { "ID": 0xD5, "Name": "Black Jupiter", "MaxLevel": 10, "Mingle?": 0, "Psych": "Lightning Bolt", "Recovery?": 0, "Element": "Neg", "Brand": "Gatito", "Ev. fr. pin?": 0 },
0xD6: { "ID": 0xD6, "Name": "Black Uranus", "MaxLevel": 10, "Mingle?": 0, "Psych": "Piercing Pillar", "Recovery?": 0, "Element": "Neg", "Brand": "Gatito", "Ev. fr. pin?": 0 },
0xD7: { "ID": 0xD7, "Name": "Black Venus", "MaxLevel": 10, "Mingle?": 0, "Psych": "Force Rounds", "Recovery?": 0, "Element": "Neg", "Brand": "Gatito", "Ev. fr. pin?": 0 },
0xD8: { "ID": 0xD8, "Name": "Black Saturn", "MaxLevel": 10, "Mingle?": 0, "Psych": "Dark Barrier", "Recovery?": 0, "Element": "Pos", "Brand": "Gatito", "Ev. fr. pin?": 0 },
0xD9: { "ID": 0xD9, "Name": "Black Mercury", "MaxLevel": 10, "Mingle?": 0, "Psych": "Splash Core", "Recovery?": 0, "Element": "Neg", "Brand": "Gatito", "Ev. fr. pin?": 0 },
0xDA: { "ID": 0xDA, "Name": "Righty Cat", "MaxLevel": 3, "Mingle?": 0, "Psych": "Over the Top RH", "Recovery?": 0, "Element": "Abi", "Brand": "Gatito", "Ev. fr. pin?": 0 },
0xDB: { "ID": 0xDB, "Name": "Brainy Cat", "MaxLevel": 3, "Mingle?": 0, "Psych": "Over the Top BR", "Recovery?": 0, "Element": "Abi", "Brand": "Gatito", "Ev. fr. pin?": 0 },
0xDC: { "ID": 0xDC, "Name": "Lefty Cat", "MaxLevel": 3, "Mingle?": 0, "Psych": "Over the Top LH", "Recovery?": 0, "Element": "Abi", "Brand": "Gatito", "Ev. fr. pin?": 0 },
0xDD: { "ID": 0xDD, "Name": "One Jump from Eden", "MaxLevel": 5, "Mingle?": 0, "Psych": "Holy Field I", "Recovery?": 0, "Element": "Abi", "Brand": "Gatito", "Ev. fr. pin?": 1 },
0xDE: { "ID": 0xDE, "Name": "One Skip from Eden", "MaxLevel": 5, "Mingle?": 0, "Psych": "Holy Field II", "Recovery?": 0, "Element": "Abi", "Brand": "Gatito", "Ev. fr. pin?": 1 },
0xDF: { "ID": 0xDF, "Name": "One Hop from Eden", "MaxLevel": 5, "Mingle?": 0, "Psych": "Holy Field III", "Recovery?": 0, "Element": "Abi", "Brand": "Gatito", "Ev. fr. pin?": 1 },
0xE0: { "ID": 0xE0, "Name": "One Step from Eden", "MaxLevel": 5, "Mingle?": 0, "Psych": "Holy Field IV", "Recovery?": 0, "Element": "Abi", "Brand": "Gatito", "Ev. fr. pin?": 1 },
0xE1: { "ID": 0xE1, "Name": "Eden's Door", "MaxLevel": 5, "Mingle?": 0, "Psych": "Holy Field V", "Recovery?": 0, "Element": "Abi", "Brand": "Gatito", "Ev. fr. pin?": 1 },
0xE2: { "ID": 0xE2, "Name": "Visionary Blend", "MaxLevel": 1, "Mingle?": 0, "Psych": "Subconscious", "Recovery?": 1, "Element": "---", "Brand": "Gatito", "Ev. fr. pin?": 0 },
0xE3: { "ID": 0xE3, "Name": "Red Skull", "MaxLevel": 1, "Mingle?": 0, "Psych": "Crawler", "Recovery?": 0, "Element": "Abi", "Brand": "Gatito", "Ev. fr. pin?": 0 },
0xE4: { "ID": 0xE4, "Name": "Gatito", "MaxLevel": 1, "Mingle?": 0, "Psych": "Resonance: GT", "Recovery?": 0, "Element": "Abi", "Brand": "Gatito", "Ev. fr. pin?": 0 },
0xE5: { "ID": 0xE5, "Name": "Tin Pin Fire", "MaxLevel": 4, "Mingle?": 0, "Psych": "Ignition", "Recovery?": 0, "Element": "Neg", "Brand": "Unbranded", "Ev. fr. pin?": 0 },
0xE6: { "ID": 0xE6, "Name": "Tin Pin Custom", "MaxLevel": 1, "Mingle?": 0, "Psych": "Burst Rounds", "Recovery?": 0, "Element": "Neg", "Brand": "Unbranded", "Ev. fr. pin?": 0 },
0xE7: { "ID": 0xE7, "Name": "Tin Pin Wind", "MaxLevel": 6, "Mingle?": 0, "Psych": "Patrol Rounds", "Recovery?": 0, "Element": "Neg", "Brand": "Unbranded", "Ev. fr. pin?": 0 },
0xE8: { "ID": 0xE8, "Name": "Tin Pin Blade", "MaxLevel": 6, "Mingle?": 0, "Psych": "Vortex Saber", "Recovery?": 0, "Element": "Pos", "Brand": "Unbranded", "Ev. fr. pin?": 0 },
0xE9: { "ID": 0xE9, "Name": "Tin Pin Wheel", "MaxLevel": 3, "Mingle?": 0, "Psych": "Velocity Attack", "Recovery?": 0, "Element": "Pos", "Brand": "Unbranded", "Ev. fr. pin?": 0 },
0xEA: { "ID": 0xEA, "Name": "Tin Pin Dash", "MaxLevel": 4, "Mingle?": 0, "Psych": "Velocity Crash", "Recovery?": 0, "Element": "Pos", "Brand": "Unbranded", "Ev. fr. pin?": 0 },
0xEB: { "ID": 0xEB, "Name": "Tin Pin Thrift", "MaxLevel": 3, "Mingle?": 0, "Psych": "Sacrifice", "Recovery?": 0, "Element": "Abi", "Brand": "Unbranded", "Ev. fr. pin?": 0 },
0xEC: { "ID": 0xEC, "Name": "Tin Pin Hellfire", "MaxLevel": 7, "Mingle?": 0, "Psych": "Flame Core", "Recovery?": 0, "Element": "Neg", "Brand": "Unbranded", "Ev. fr. pin?": 0 },
0xED: { "ID": 0xED, "Name": "Tin Pin Sunscorch", "MaxLevel": 3, "Mingle?": 0, "Psych": "Flame Blast", "Recovery?": 0, "Element": "Neg", "Brand": "Unbranded", "Ev. fr. pin?": 0 },
0xEE: { "ID": 0xEE, "Name": "Tin Pin Rocker", "MaxLevel": 2, "Mingle?": 0, "Psych": "Street Jam", "Recovery?": 0, "Element": "Neg", "Brand": "Unbranded", "Ev. fr. pin?": 0 },
0xEF: { "ID": 0xEF, "Name": "Tin Pin Artist", "MaxLevel": 4, "Mingle?": 0, "Psych": "Lightning Bolt", "Recovery?": 0, "Element": "Neg", "Brand": "Unbranded", "Ev. fr. pin?": 0 },
0xF0: { "ID": 0xF0, "Name": "Tin Pin Devil", "MaxLevel": 8, "Mingle?": 0, "Psych": "Thunderstorm", "Recovery?": 0, "Element": "Neg", "Brand": "Unbranded", "Ev. fr. pin?": 0 },
0xF1: { "ID": 0xF1, "Name": "Tin Pin Ifrit", "MaxLevel": 3, "Mingle?": 0, "Psych": "Time Bomb", "Recovery?": 0, "Element": "Neg", "Brand": "Unbranded", "Ev. fr. pin?": 0 },
0xF2: { "ID": 0xF2, "Name": "Tin Pin Shiva", "MaxLevel": 4, "Mingle?": 0, "Psych": "Piercing Pillar", "Recovery?": 0, "Element": "Neg", "Brand": "Unbranded", "Ev. fr. pin?": 0 },
0xF3: { "ID": 0xF3, "Name": "Tin Pin Golem", "MaxLevel": 5, "Mingle?": 0, "Psych": "Earthquake", "Recovery?": 0, "Element": "Pos", "Brand": "Unbranded", "Ev. fr. pin?": 0 },
0xF4: { "ID": 0xF4, "Name": "Tin Pin Bahamut", "MaxLevel": 6, "Mingle?": 0, "Psych": "Nexus Ray", "Recovery?": 0, "Element": "Neg", "Brand": "Unbranded", "Ev. fr. pin?": 0 },
0xF5: { "ID": 0xF5, "Name": "1 Yen", "MaxLevel": 2, "Mingle?": 0, "Psych": "---", "Recovery?": 0, "Element": "---", "Brand": "Unbranded", "Ev. fr. pin?": 1 },
0xF6: { "ID": 0xF6, "Name": "5 Yen", "MaxLevel": 2, "Mingle?": 0, "Psych": "---", "Recovery?": 0, "Element": "---", "Brand": "Unbranded", "Ev. fr. pin?": 1 },
0xF7: { "ID": 0xF7, "Name": "10 Yen", "MaxLevel": 2, "Mingle?": 0, "Psych": "---", "Recovery?": 0, "Element": "---", "Brand": "Unbranded", "Ev. fr. pin?": 1 },
0xF8: { "ID": 0xF8, "Name": "50 Yen", "MaxLevel": 2, "Mingle?": 0, "Psych": "---", "Recovery?": 0, "Element": "---", "Brand": "Unbranded", "Ev. fr. pin?": 1 },
0xF9: { "ID": 0xF9, "Name": "100 Yen", "MaxLevel": 2, "Mingle?": 0, "Psych": "---", "Recovery?": 0, "Element": "---", "Brand": "Unbranded", "Ev. fr. pin?": 1 },
0xFA: { "ID": 0xFA, "Name": "500 Yen", "MaxLevel": 2, "Mingle?": 0, "Psych": "---", "Recovery?": 0, "Element": "---", "Brand": "Unbranded", "Ev. fr. pin?": 1 },
0xFB: { "ID": 0xFB, "Name": "1,000 Yen", "MaxLevel": 2, "Mingle?": 0, "Psych": "---", "Recovery?": 0, "Element": "---", "Brand": "Unbranded", "Ev. fr. pin?": 1 },
0xFC: { "ID": 0xFC, "Name": "5,000 Yen", "MaxLevel": 2, "Mingle?": 0, "Psych": "---", "Recovery?": 0, "Element": "---", "Brand": "Unbranded", "Ev. fr. pin?": 1 },
0xFD: { "ID": 0xFD, "Name": "10,000 Yen", "MaxLevel": 1, "Mingle?": 0, "Psych": "---", "Recovery?": 0, "Element": "---", "Brand": "Unbranded", "Ev. fr. pin?": 1 },
0xFE: { "ID": 0xFE, "Name": "Scarletite", "MaxLevel": 1, "Mingle?": 0, "Psych": "---", "Recovery?": 0, "Element": "---", "Brand": "Unbranded", "Ev. fr. pin?": 0 },
0xFF: { "ID": 0xFF, "Name": "Rare Metal", "MaxLevel": 1, "Mingle?": 0, "Psych": "---", "Recovery?": 0, "Element": "---", "Brand": "Unbranded", "Ev. fr. pin?": 0 },
0x100: { "ID": 0x100, "Name": "Tektite", "MaxLevel": 1, "Mingle?": 0, "Psych": "---", "Recovery?": 0, "Element": "---", "Brand": "Unbranded", "Ev. fr. pin?": 0 },
0x101: { "ID": 0x101, "Name": "Adamantite", "MaxLevel": 1, "Mingle?": 0, "Psych": "---", "Recovery?": 0, "Element": "---", "Brand": "Unbranded", "Ev. fr. pin?": 0 },
0x102: { "ID": 0x102, "Name": "Orichalcum", "MaxLevel": 1, "Mingle?": 0, "Psych": "---", "Recovery?": 0, "Element": "---", "Brand": "Unbranded", "Ev. fr. pin?": 0 },
0x103: { "ID": 0x103, "Name": "Shadow Matter", "MaxLevel": 1, "Mingle?": 0, "Psych": "---", "Recovery?": 0, "Element": "---", "Brand": "Unbranded", "Ev. fr. pin?": 0 },
0x104: { "ID": 0x104, "Name": "Dark Matter", "MaxLevel": 1, "Mingle?": 0, "Psych": "---", "Recovery?": 0, "Element": "---", "Brand": "Unbranded", "Ev. fr. pin?": 0 },
0x105: { "ID": 0x105, "Name": "Rhyme", "MaxLevel": 1, "Mingle?": 0, "Psych": "Summon Rhyme", "Recovery?": 0, "Element": "Pos", "Brand": "Unbranded", "Ev. fr. pin?": 0 },
0x106: { "ID": 0x106, "Name": "Lucky Star", "MaxLevel": 3, "Mingle?": 0, "Psych": "Mother Lode", "Recovery?": 0, "Element": "Abi", "Brand": "Unbranded", "Ev. fr. pin?": 0 },
0x107: { "ID": 0x107, "Name": "Lady Luck", "MaxLevel": 3, "Mingle?": 0, "Psych": "Mother Lode", "Recovery?": 0, "Element": "Abi", "Brand": "Unbranded", "Ev. fr. pin?": 0 },
0x108: { "ID": 0x108, "Name": "Lucky Panda", "MaxLevel": 3, "Mingle?": 0, "Psych": "Mother Lode", "Recovery?": 0, "Element": "Abi", "Brand": "Unbranded", "Ev. fr. pin?": 0 },
0x109: { "ID": 0x109, "Name": "Pyrokinesis", "MaxLevel": 3, "Mingle?": 0, "Psych": "Pyrokinesis", "Recovery?": 0, "Element": "Neg", "Brand": "Unbranded", "Ev. fr. pin?": 0 },
0x10A: { "ID": 0x10A, "Name": "Shockwave", "MaxLevel": 3, "Mingle?": 0, "Psych": "Shockwave", "Recovery?": 0, "Element": "Pos", "Brand": "Unbranded", "Ev. fr. pin?": 0 },
0x10B: { "ID": 0x10B, "Name": "Cure Drink", "MaxLevel": 3, "Mingle?": 0, "Psych": "Cure Drink", "Recovery?": 1, "Element": "---", "Brand": "Unbranded", "Ev. fr. pin?": 0 },
0x10C: { "ID": 0x10C, "Name": "Force Rounds", "MaxLevel": 3, "Mingle?": 0, "Psych": "Force Rounds", "Recovery?": 0, "Element": "Neg", "Brand": "Unbranded", "Ev. fr. pin?": 0 },
0x10D: { "ID": 0x10D, "Name": "Psychokinesis", "MaxLevel": 2, "Mingle?": 0, "Psych": "Psychokinesis", "Recovery?": 0, "Element": "Neu", "Brand": "Unbranded", "Ev. fr. pin?": 0 },
0x10E: { "ID": 0x10E, "Name": "Thunderbolt", "MaxLevel": 2, "Mingle?": 0, "Psych": "Thunderbolt", "Recovery?": 0, "Element": "Neg", "Brand": "Unbranded", "Ev. fr. pin?": 0 },
0x10F: { "ID": 0x10F, "Name": "The Eyes Have It", "MaxLevel": 3, "Mingle?": 0, "Psych": "Frostbite", "Recovery?": 0, "Element": "Neg", "Brand": "Unbranded", "Ev. fr. pin?": 0 },
0x110: { "ID": 0x110, "Name": "I Live for Food", "MaxLevel": 3, "Mingle?": 0, "Psych": "Cure Drink", "Recovery?": 1, "Element": "---", "Brand": "Unbranded", "Ev. fr. pin?": 0 },
0x111: { "ID": 0x111, "Name": "Walk on, Walk off", "MaxLevel": 3, "Mingle?": 0, "Psych": "Invisibility", "Recovery?": 0, "Element": "---", "Brand": "Unbranded", "Ev. fr. pin?": 0 },
0x112: { "ID": 0x112, "Name": "Me Time is Free Time", "MaxLevel": 3, "Mingle?": 0, "Psych": "Sweeper", "Recovery?": 0, "Element": "---", "Brand": "Unbranded", "Ev. fr. pin?": 0 },
0x113: { "ID": 0x113, "Name": "Fuji Yama", "MaxLevel": 5, "Mingle?": 0, "Psych": "Discharge", "Recovery?": 0, "Element": "Neg", "Brand": "Unbranded", "Ev. fr. pin?": 0 },
0x114: { "ID": 0x114, "Name": "Daruma", "MaxLevel": 5, "Mingle?": 0, "Psych": "Apport", "Recovery?": 0, "Element": "Neg", "Brand": "Unbranded", "Ev. fr. pin?": 0 },
0x115: { "ID": 0x115, "Name": "Sushi", "MaxLevel": 5, "Mingle?": 0, "Psych": "Stellar Flurry", "Recovery?": 0, "Element": "Pos", "Brand": "Unbranded", "Ev. fr. pin?": 0 },
0x116: { "ID": 0x116, "Name": "Shinobi", "MaxLevel": 5, "Mingle?": 0, "Psych": "Energy Rounds", "Recovery?": 0, "Element": "Neg", "Brand": "Unbranded", "Ev. fr. pin?": 0 },
0x117: { "ID": 0x117, "Name": "Tigris", "MaxLevel": 10, "Mingle?": 0, "Psych": "Piercing Pillar", "Recovery?": 0, "Element": "Neg", "Brand": "Unbranded", "Ev. fr. pin?": 0 },
0x118: { "ID": 0x118, "Name": "Corehog", "MaxLevel": 5, "Mingle?": 0, "Psych": "Burst Rounds", "Recovery?": 0, "Element": "Neg", "Brand": "Unbranded", "Ev. fr. pin?": 0 },
0x119: { "ID": 0x119, "Name": "Jelly", "MaxLevel": 7, "Mingle?": 0, "Psych": "Discharge", "Recovery?": 0, "Element": "Neg", "Brand": "Unbranded", "Ev. fr. pin?": 0 },
0x11A: { "ID": 0x11A, "Name": "Shark", "MaxLevel": 3, "Mingle?": 0, "Psych": "Black Hole", "Recovery?": 0, "Element": "---", "Brand": "Unbranded", "Ev. fr. pin?": 0 },
0x11B: { "ID": 0x11B, "Name": "Leo", "MaxLevel": 3, "Mingle?": 0, "Psych": "Teleport", "Recovery?": 0, "Element": "---", "Brand": "Unbranded", "Ev. fr. pin?": 0 },
0x11C: { "ID": 0x11C, "Name": "Ovis", "MaxLevel": 9, "Mingle?": 0, "Psych": "Thunderbolt", "Recovery?": 0, "Element": "Neg", "Brand": "Unbranded", "Ev. fr. pin?": 0 },
0x11D: { "ID": 0x11D, "Name": "Cornix", "MaxLevel": 4, "Mingle?": 0, "Psych": "Apport", "Recovery?": 0, "Element": "Neg", "Brand": "Unbranded", "Ev. fr. pin?": 0 },
0x11E: { "ID": 0x11E, "Name": "Popguin", "MaxLevel": 3, "Mingle?": 0, "Psych": "Force Rounds", "Recovery?": 0, "Element": "Neg", "Brand": "Unbranded", "Ev. fr. pin?": 0 },
0x11F: { "ID": 0x11F, "Name": "Pteropus", "MaxLevel": 6, "Mingle?": 0, "Psych": "Patrol Rounds", "Recovery?": 0, "Element": "Neg", "Brand": "Unbranded", "Ev. fr. pin?": 0 },
0x120: { "ID": 0x120, "Name": "Mink", "MaxLevel": 4, "Mingle?": 0, "Psych": "Twister", "Recovery?": 0, "Element": "Neg", "Brand": "Unbranded", "Ev. fr. pin?": 0 },
0x121: { "ID": 0x121, "Name": "Boomer", "MaxLevel": 5, "Mingle?": 0, "Psych": "Grave Marker", "Recovery?": 0, "Element": "Pos", "Brand": "Unbranded", "Ev. fr. pin?": 0 },
0x122: { "ID": 0x122, "Name": "Sprog", "MaxLevel": 4, "Mingle?": 0, "Psych": "Freeze", "Recovery?": 0, "Element": "Neg", "Brand": "Unbranded", "Ev. fr. pin?": 0 },
0x123: { "ID": 0x123, "Name": "Fox", "MaxLevel": 3, "Mingle?": 0, "Psych": "Flame Core", "Recovery?": 0, "Element": "Neg", "Brand": "Unbranded", "Ev. fr. pin?": 0 },
0x124: { "ID": 0x124, "Name": "Bat", "MaxLevel": 5, "Mingle?": 0, "Psych": "Patrol Rounds", "Recovery?": 0, "Element": "Neg", "Brand": "Unbranded", "Ev. fr. pin?": 0 },
0x125: { "ID": 0x125, "Name": "Rhino", "MaxLevel": 4, "Mingle?": 0, "Psych": "Massive Hit", "Recovery?": 0, "Element": "Pos", "Brand": "Unbranded", "Ev. fr. pin?": 0 },
0x126: { "ID": 0x126, "Name": "Shrew", "MaxLevel": 6, "Mingle?": 0, "Psych": "Time Bomb", "Recovery?": 0, "Element": "Neg", "Brand": "Unbranded", "Ev. fr. pin?": 0 },
0x127: { "ID": 0x127, "Name": "Woolly", "MaxLevel": 4, "Mingle?": 0, "Psych": "Earthquake", "Recovery?": 0, "Element": "Pos", "Brand": "Unbranded", "Ev. fr. pin?": 0 },
0x128: { "ID": 0x128, "Name": "Raven", "MaxLevel": 9, "Mingle?": 0, "Psych": "Psychokinesis", "Recovery?": 0, "Element": "Neu", "Brand": "Unbranded", "Ev. fr. pin?": 0 },
0x129: { "ID": 0x129, "Name": "Drake", "MaxLevel": 15, "Mingle?": 0, "Psych": "Flame Blast", "Recovery?": 0, "Element": "Neg", "Brand": "Unbranded", "Ev. fr. pin?": 0 },
0x12A: { "ID": 0x12A, "Name": "Anguis", "MaxLevel": 20, "Mingle?": 0, "Psych": "Nexus Ray", "Recovery?": 0, "Element": "Neg", "Brand": "Unbranded", "Ev. fr. pin?": 0 },
0x12B: { "ID": 0x12B, "Name": "Pig", "MaxLevel": 1, "Mingle?": 0, "Psych": "Grandmother Lode", "Recovery?": 0, "Element": "Abi", "Brand": "Unbranded", "Ev. fr. pin?": 0 },
0x12C: { "ID": 0x12C, "Name": "Carcin", "MaxLevel": 3, "Mingle?": 0, "Psych": "Fire Barrier", "Recovery?": 0, "Element": "Pos", "Brand": "Unbranded", "Ev. fr. pin?": 0 },
0x12D: { "ID": 0x12D, "Name": "Grizzly", "MaxLevel": 3, "Mingle?": 0, "Psych": "Street Jam", "Recovery?": 0, "Element": "Neg", "Brand": "Unbranded", "Ev. fr. pin?": 0 },
0x12E: { "ID": 0x12E, "Name": "Wolf", "MaxLevel": 5, "Mingle?": 0, "Psych": "Velocity Attack", "Recovery?": 0, "Element": "Pos", "Brand": "Unbranded", "Ev. fr. pin?": 0 },
0x12F: { "ID": 0x12F, "Name": "Frog", "MaxLevel": 4, "Mingle?": 0, "Psych": "Splash Core", "Recovery?": 0, "Element": "Neg", "Brand": "Unbranded", "Ev. fr. pin?": 0 },
}

emptySlot = { "ID": 0xffff, "Name": "", "MaxLevel": 0, "Mingle?": 0, "Psych": "", "Recovery?": 0, }


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

function GetPinsByTrait(traitName, traitValue)
{
    pinsToReturn = {}
    for i in pins
    {
        pin = pins[i]
        if (pin[traitName] == traitValue)
        {
            pinsToReturn[pin["ID"]] = pin
        }
    }
    return pinsToReturn
}

function GetRecoveryPins()
{
    recoveryPins = {}
    for i in pins
    {
        pin = pins[i]
        if (pin["Recovery?"] == 1)
        {
            recoveryPins[pin["ID"]] = pin
        }
    }
    
    return recoveryPins
}
recoveryPins = GetRecoveryPins() // Attempt to cache the result

function GetPinsByPsych(psych)
{
    psychPins = {}
    for i in pins
    {
        pin = pins[i]
        if (pin["Psych"] == psych)
        {
            psychPins[pin["ID"]] = pin
        }
    }
    return psychPins
}

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

function IsDeckPinEvolvedByAddr(baseAddr)
{
    id = word(baseAddr)
    return Delta(id) != id && IsOnResultsScreen()
}

function GetDeckSlotAddrBySlotId(slotId)
{
    return deckSlot1BaseAddr() + slotId * deckPinByteSize()
}

function IsDeckPinMastered(slotId)
{
    return IsDeckPinMasteredByAddr(GetDeckSlotAddrBySlotId(slotId))
}

function IsDeckPinEvolved(slotId)
{
    return IsDeckPinEvolvedByAddr(GetDeckSlotAddrBySlotId(slotId))
}

function IsDeckPinARecoveryPin(slotId)
{
    isARecoveryPin = always_false()
    for i in recoveryPins
    {
        pin = recoveryPins[i]
        isARecoveryPin = isARecoveryPin || word(GetDeckSlotAddrBySlotId(slotId)) == pin["ID"]
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

function IsAnyDeckPinEvolved()
{
    result = always_false()
    for i in range(0, 5)
    {
        result = result || IsDeckPinEvolved(i)
    }
    return result
}

function HasPinLoadoutChanged()
{
    result = always_false()
    for slotId in range(0, 5)
    {
        result = result || word(GetDeckSlotAddrBySlotId(slotId)) != Delta(word(GetDeckSlotAddrBySlotId(slotId)))
    }
    return result
}

function OnlyTheGivenPinsAreEquipped(allowedPins)
{
    result = always_true()
    for slotId in range(0, 5)
    {
        subclause = always_false()
        for i in allowedPins
        {
            pin = allowedPins[i]
            subclause = subclause || word(GetDeckSlotAddrBySlotId(slotId)) == pin["ID"]
        }
        
        result = result && repeated(0, subclause)
    }
    
    return result
}

function AnyOfTheGivenPinsAreEquipped(requestedPins)
{
    result = always_false()
    for slotId in range(0, 5)
    {
        for i in requestedPins
        {
            pin = requestedPins[i]
            result = result || word(GetDeckSlotAddrBySlotId(slotId)) == pin["ID"]
        }
    }
    
    return tally(1, result)
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

function deckPinSlotBaseAddr() => 0x071d84
function masteredPinSlotBaseAddr() => 0x0727c0

function MasteredPinSlot(slot)
{
    return word(masteredPinSlotBaseAddr() + 4 * slot)
}

// This takes a SORTED collection of pins and generates a collection of ranges
// for the purpose of optimized pin conditions.
// Ex.:
// {
//    0x0: ...,
//    0x1: ...,
//    0x2: ...,
//    0x3: ...,
//    0x5: ...,
//    0x6: ...
// }
// ...would evaluate to a range set equivalent to the following:
// {
//    { "min": 0x0, "max": 0x3 },
//    { "min": 0x5, "max": 0x6 }
// }

function GetValueRangesFromSortedPins(pinPool)
{
    result = []
    min = 0
    max = 0
    rangeReset = 1
    for i in pinPool
    {
        pin = pinPool[i]
        
        if (rangeReset == 1)
        {
            min = pin["ID"]
            max = min
            rangeReset = 0
        }
        else if (pin["ID"] == max + 1)
        {
            max = max + 1
        }
        else
        {
            array_push(result, { "min": min, "max": max })
            min = pin["ID"]
            max = min
        }
    }
    
    array_push(result, { "min": min, "max": max })
    
    return result
}

function StockpilePinSlotIsFilled(slot)
{
    return word(deckPinSlotBaseAddr() + deckPinByteSize() * slot) != 0xffff
}

function MasteredPinSlotChanged(slot)
{
    addr = masteredPinSlotBaseAddr() + 4 * slot
    return Delta(word(addr)) != word(addr)
}

function StockpilePinSlotChanged(slot)
{
    addr = deckPinSlotBaseAddr() + 10 * slot
    return Delta(word(addr)) != word(addr)
}

// ITEMS

items = {
0x2A8: { "id": 0x2A8, "name": "(S) Extra Slot", "type": "Sticker", },
0xFFFF: { "id": 0xFFFF, "name": "None", "type": "None", },
0x2ce: { "id": 0x2ce, "name": "(S) Noise Report", "type": "Sticker", },
0x2ae: { "id": 0x2ae, "name": "(S) Game Cleared", "type": "Sticker", },
0x285: { "id": 0x285, "name": "(CD) Track 1", "type": "CD", },
0x286: { "id": 0x286, "name": "(CD) Track 2", "type": "CD", },
0x287: { "id": 0x287, "name": "(CD) Track 3", "type": "CD", },
0x288: { "id": 0x288, "name": "(CD) Track 4", "type": "CD", },
0x289: { "id": 0x289, "name": "(CD) Track 5", "type": "CD", },
0x28A: { "id": 0x28A, "name": "(CD) Track 6", "type": "CD", },
0x28B: { "id": 0x28B, "name": "(CD) Track 7", "type": "CD", },
0x28C: { "id": 0x28C, "name": "(CD) Track 8", "type": "CD", },
0x28D: { "id": 0x28D, "name": "(CD) Track 9", "type": "CD", },
0x28E: { "id": 0x28E, "name": "(CD) Track 10", "type": "CD", },
0x28F: { "id": 0x28F, "name": "(CD) Track 11", "type": "CD", },
0x290: { "id": 0x290, "name": "(CD) Track 12", "type": "CD", },
0x291: { "id": 0x291, "name": "(CD) Track 13", "type": "CD", },
0x292: { "id": 0x292, "name": "(CD) Track 14", "type": "CD", },
0x293: { "id": 0x293, "name": "(CD) Track 15", "type": "CD", },
0x294: { "id": 0x294, "name": "(CD) Track 16", "type": "CD", },
0x295: { "id": 0x295, "name": "(CD) Track 17", "type": "CD", },
0x296: { "id": 0x296, "name": "(CD) Track 18", "type": "CD", },
0x297: { "id": 0x297, "name": "(CD) Track 19", "type": "CD", },
0x298: { "id": 0x298, "name": "(CD) Track 20", "type": "CD", },
0x299: { "id": 0x299, "name": "(CD) Track 21", "type": "CD", },
0x29A: { "id": 0x29A, "name": "(CD) Track 22", "type": "CD", },
0x29B: { "id": 0x29B, "name": "(CD) Track 23", "type": "CD", },
0x29C: { "id": 0x29C, "name": "(CD) Track 24", "type": "CD", },
0x29D: { "id": 0x29D, "name": "(CD) Track 25", "type": "CD", },
0x29E: { "id": 0x29E, "name": "(CD) Track 26", "type": "CD", },
0x29F: { "id": 0x29F, "name": "(CD) Track 27", "type": "CD", },
0x2A0: { "id": 0x2A0, "name": "(CD) Track 28", "type": "CD", },
0x2A1: { "id": 0x2A1, "name": "(CD) Track 29", "type": "CD", },
0x2A2: { "id": 0x2A2, "name": "(CD) Track 30", "type": "CD", },
0x2A3: { "id": 0x2A3, "name": "(CD) Track 31", "type": "CD", },
0x2A4: { "id": 0x2A4, "name": "(CD) Track 32", "type": "CD", },
0x2A5: { "id": 0x2A5, "name": "(CD) Track 33", "type": "CD", },
0x2A6: { "id": 0x2A6, "name": "(CD) Track 34", "type": "CD", },
}

function GetAllItemsOfType(type)
{
    result = {}
    for i in items
    {
        item = items[i]
        if (item["type"] == type)
        {
            result[i] = item
        }
    }
    return result
}

threads = {
    0x130: { "id": 0x130, "name": "M Cap", "brand": "Mus Rattus", },
0x131: { "id": 0x131, "name": "Yellow Tee", "brand": "Mus Rattus", },
0x132: { "id": 0x132, "name": "Mowzy Tee (Red)", "brand": "Mus Rattus", },
0x133: { "id": 0x133, "name": "Mint Polo", "brand": "Mus Rattus", },
0x134: { "id": 0x134, "name": "Runner's Tank", "brand": "Mus Rattus", },
0x135: { "id": 0x135, "name": "Mowzy Sweatshirt", "brand": "Mus Rattus", },
0x136: { "id": 0x136, "name": "Brown Baby Tee", "brand": "Mus Rattus", },
0x137: { "id": 0x137, "name": "Pink Blouse", "brand": "Mus Rattus", },
0x138: { "id": 0x138, "name": "Peach Turtleneck", "brand": "Mus Rattus", },
0x139: { "id": 0x139, "name": "Classic Jeans", "brand": "Mus Rattus", },
0x13A: { "id": 0x13A, "name": "Khaki Chinos", "brand": "Mus Rattus", },
0x13B: { "id": 0x13B, "name": "Green Warm-ups", "brand": "Mus Rattus", },
0x13C: { "id": 0x13C, "name": "Beach Sandals", "brand": "Mus Rattus", },
0x13D: { "id": 0x13D, "name": "3-for-1 Sock Pak", "brand": "Mus Rattus", },
0x13E: { "id": 0x13E, "name": "Mowzy", "brand": "Mus Rattus", },
0x13F: { "id": 0x13F, "name": "Backpack", "brand": "Mus Rattus", },
0x140: { "id": 0x140, "name": "Canvas Tote", "brand": "Mus Rattus", },
0x141: { "id": 0x141, "name": "Nylon Waist Pack", "brand": "Mus Rattus", },
0x142: { "id": 0x142, "name": "Stronger Cap", "brand": "D+B", },
0x143: { "id": 0x143, "name": "Star Cap", "brand": "D+B", },
0x144: { "id": 0x144, "name": "Knit Casquette", "brand": "D+B", },
0x145: { "id": 0x145, "name": "Svelte Parka", "brand": "D+B", },
0x146: { "id": 0x146, "name": "Denim Blouse", "brand": "D+B", },
0x147: { "id": 0x147, "name": "Cupid Tee", "brand": "D+B", },
0x148: { "id": 0x148, "name": "Satin Camisole", "brand": "D+B", },
0x149: { "id": 0x149, "name": "Vest-Blouse Combo", "brand": "D+B", },
0x14A: { "id": 0x14A, "name": "Leather Shorts", "brand": "D+B", },
0x14B: { "id": 0x14B, "name": "Skinny Jeans (Black)", "brand": "D+B", },
0x14C: { "id": 0x14C, "name": "Denim Miniskirt", "brand": "D+B", },
0x14D: { "id": 0x14D, "name": "Plaid Miniskirt", "brand": "D+B", },
0x14E: { "id": 0x14E, "name": "Knee-high Boots", "brand": "D+B", },
0x14F: { "id": 0x14F, "name": "Cowboy Boots (Red)", "brand": "D+B", },
0x150: { "id": 0x150, "name": "Purple Bikini", "brand": "D+B", },
0x151: { "id": 0x151, "name": "Black Bikini", "brand": "D+B", },
0x152: { "id": 0x152, "name": "Studded Belt", "brand": "D+B", },
0x153: { "id": 0x153, "name": "D+B Ring", "brand": "D+B", },
0x154: { "id": 0x154, "name": "Biker Jacket", "brand": "Tigre Punks", },
0x155: { "id": 0x155, "name": "Patchy Biker Jacket", "brand": "Tigre Punks", },
0x156: { "id": 0x156, "name": "Cotton Biker Vest", "brand": "Tigre Punks", },
0x157: { "id": 0x157, "name": "Tiger Biker Vest", "brand": "Tigre Punks", },
0x158: { "id": 0x158, "name": "Fitted Coat", "brand": "Tigre Punks", },
0x159: { "id": 0x159, "name": "Tartan Coat", "brand": "Tigre Punks", },
0x15A: { "id": 0x15A, "name": "Pink Gauze Shirt", "brand": "Tigre Punks", },
0x15B: { "id": 0x15B, "name": "Grey Gauze Shirt", "brand": "Tigre Punks", },
0x15C: { "id": 0x15C, "name": "Black Raglan Tee", "brand": "Tigre Punks", },
0x15D: { "id": 0x15D, "name": "Blue Raglan Tee", "brand": "Tigre Punks", },
0x15E: { "id": 0x15E, "name": "Bondage Pants (Black)", "brand": "Tigre Punks", },
0x15F: { "id": 0x15F, "name": "Skirt Bondage Combo", "brand": "Tigre Punks", },
0x160: { "id": 0x160, "name": "Bondage Half-pants", "brand": "Tigre Punks", },
0x161: { "id": 0x161, "name": "Work Boots", "brand": "Tigre Punks", },
0x162: { "id": 0x162, "name": "Purple Sneaks", "brand": "Tigre Punks", },
0x163: { "id": 0x163, "name": "Custom Sneaks", "brand": "Tigre Punks", },
0x164: { "id": 0x164, "name": "White Rubbersoles", "brand": "Tigre Punks", },
0x165: { "id": 0x165, "name": "Double-spiked Cuff", "brand": "Tigre Punks", },
0x166: { "id": 0x166, "name": "Spiked Choker", "brand": "Tigre Punks", },
0x167: { "id": 0x167, "name": "Red Mohawk Set", "brand": "Tigre Punks", },
0x168: { "id": 0x168, "name": "Gold Padlock Necklace", "brand": "Tigre Punks", },
0x169: { "id": 0x169, "name": "Custom Waist Pack", "brand": "Tigre Punks", },
0x16A: { "id": 0x16A, "name": "Tiger Waist Pack", "brand": "Tigre Punks", },
0x16B: { "id": 0x16B, "name": "Lace Bonnet", "brand": "Lapin Angelique", },
0x16C: { "id": 0x16C, "name": "Ribbon Bonnet", "brand": "Lapin Angelique", },
0x16D: { "id": 0x16D, "name": "Ribbon Mini-hat", "brand": "Lapin Angelique", },
0x16E: { "id": 0x16E, "name": "Mini-crown", "brand": "Lapin Angelique", },
0x16F: { "id": 0x16F, "name": "Goth Bondage Coat", "brand": "Lapin Angelique", },
0x170: { "id": 0x170, "name": "Asymmetric Jersey", "brand": "Lapin Angelique", },
0x171: { "id": 0x171, "name": "Spiderweb Jersey", "brand": "Lapin Angelique", },
0x172: { "id": 0x172, "name": "Bunny Parka", "brand": "Lapin Angelique", },
0x173: { "id": 0x173, "name": "Shirt & Arm Warmers", "brand": "Lapin Angelique", },
0x174: { "id": 0x174, "name": "Bandage Pants", "brand": "Lapin Angelique", },
0x175: { "id": 0x175, "name": "Red Two-tier Skirt", "brand": "Lapin Angelique", },
0x176: { "id": 0x176, "name": "Double-breasted Suit", "brand": "Lapin Angelique", },
0x177: { "id": 0x177, "name": "Lace-up Dress", "brand": "Lapin Angelique", },
0x178: { "id": 0x178, "name": "Ribbon-laced Dress", "brand": "Lapin Angelique", },
0x179: { "id": 0x179, "name": "Vampire Dress", "brand": "Lapin Angelique", },
0x17A: { "id": 0x17A, "name": "Ribbon Shoes", "brand": "Lapin Angelique", },
0x17B: { "id": 0x17B, "name": "Platform Shoes", "brand": "Lapin Angelique", },
0x17C: { "id": 0x17C, "name": "Cape", "brand": "Lapin Angelique", },
0x17D: { "id": 0x17D, "name": "Frilly Parasol", "brand": "Lapin Angelique", },
0x17E: { "id": 0x17E, "name": "Blond Wig", "brand": "Lapin Angelique", },
0x17F: { "id": 0x17F, "name": "M'sieur Lapin", "brand": "Lapin Angelique", },
0x180: { "id": 0x180, "name": "White Dragon", "brand": "Dragon Couture", },
0x181: { "id": 0x181, "name": "Light and Shadow", "brand": "Dragon Couture", },
0x182: { "id": 0x182, "name": "Yin Blazer", "brand": "Dragon Couture", },
0x183: { "id": 0x183, "name": "Midnight Thoughts", "brand": "Dragon Couture", },
0x184: { "id": 0x184, "name": "Plum Blossom", "brand": "Dragon Couture", },
0x185: { "id": 0x185, "name": "Vernal Equinox", "brand": "Dragon Couture", },
0x186: { "id": 0x186, "name": "Autumn Dragon", "brand": "Dragon Couture", },
0x187: { "id": 0x187, "name": "Sun Emperor", "brand": "Dragon Couture", },
0x188: { "id": 0x188, "name": "Dragon Lady", "brand": "Dragon Couture", },
0x189: { "id": 0x189, "name": "A Flash, A Spark", "brand": "Dragon Couture", },
0x18A: { "id": 0x18A, "name": "One Man, No Equals", "brand": "Dragon Couture", },
0x18B: { "id": 0x18B, "name": "Old Wisdom Made New", "brand": "Dragon Couture", },
0x18C: { "id": 0x18C, "name": "Typhoon", "brand": "Dragon Couture", },
0x18D: { "id": 0x18D, "name": "Dandy Hat", "brand": "Hip Snake", },
0x18E: { "id": 0x18E, "name": "Zephyr's Elegy", "brand": "Hip Snake", },
0x18F: { "id": 0x18F, "name": "Tree Leaf Serenade", "brand": "Hip Snake", },
0x190: { "id": 0x190, "name": "Dappled Light Waltz", "brand": "Hip Snake", },
0x191: { "id": 0x191, "name": "Zephyr's Sonata", "brand": "Hip Snake", },
0x192: { "id": 0x192, "name": "North Wind Concerto", "brand": "Hip Snake", },
0x193: { "id": 0x193, "name": "Spring Breeze Rhapsody", "brand": "Hip Snake", },
0x194: { "id": 0x194, "name": "Sky Blue Paean", "brand": "Hip Snake", },
0x195: { "id": 0x195, "name": "High Sun Paean", "brand": "Hip Snake", },
0x196: { "id": 0x196, "name": "Sunflower", "brand": "Hip Snake", },
0x197: { "id": 0x197, "name": "Hydrangea", "brand": "Hip Snake", },
0x198: { "id": 0x198, "name": "Tulip", "brand": "Hip Snake", },
0x199: { "id": 0x199, "name": "Sunshine One-piece", "brand": "Hip Snake", },
0x19A: { "id": 0x19A, "name": "Flower One-piece", "brand": "Hip Snake", },
0x19B: { "id": 0x19B, "name": "Youth's March", "brand": "Hip Snake", },
0x19C: { "id": 0x19C, "name": "Young Folks", "brand": "Hip Snake", },
0x19D: { "id": 0x19D, "name": "When You're in Love", "brand": "Hip Snake", },
0x19E: { "id": 0x19E, "name": "Love in a Heartbeat", "brand": "Hip Snake", },
0x19F: { "id": 0x19F, "name": "Let's Dance", "brand": "Hip Snake", },
0x1A0: { "id": 0x1A0, "name": "Young American", "brand": "Hip Snake", },
0x1A1: { "id": 0x1A1, "name": "Funky Shades", "brand": "Hip Snake", },
0x1A2: { "id": 0x1A2, "name": "Love & Peace", "brand": "Hip Snake", },
0x1A3: { "id": 0x1A3, "name": "Slogan Bandannas", "brand": "Hip Snake", },
0x1A4: { "id": 0x1A4, "name": "Cocktail Queen", "brand": "Pegaso", },
0x1A5: { "id": 0x1A5, "name": "Regal Presence", "brand": "Pegaso", },
0x1A6: { "id": 0x1A6, "name": "Tweed Gentleman", "brand": "Pegaso", },
0x1A7: { "id": 0x1A7, "name": "Lavender Lotus", "brand": "Pegaso", },
0x1A8: { "id": 0x1A8, "name": "Classic Half-boots", "brand": "Pegaso", },
0x1A9: { "id": 0x1A9, "name": "Crimson Stilettos", "brand": "Pegaso", },
0x1AA: { "id": 0x1AA, "name": "Silver Baron", "brand": "Pegaso", },
0x1AB: { "id": 0x1AB, "name": "Liberty Duke", "brand": "Pegaso", },
0x1AC: { "id": 0x1AC, "name": "Royal Splendor", "brand": "Pegaso", },
0x1AD: { "id": 0x1AD, "name": "Revolution", "brand": "Pegaso", },
0x1AE: { "id": 0x1AE, "name": "Sparkling Flight", "brand": "Pegaso", },
0x1AF: { "id": 0x1AF, "name": "Darling Lock", "brand": "Pegaso", },
0x1B0: { "id": 0x1B0, "name": "Pitter Patter Plaid", "brand": "Sheep Heavenly", },
0x1B1: { "id": 0x1B1, "name": "Frilly Camisole", "brand": "Sheep Heavenly", },
0x1B2: { "id": 0x1B2, "name": "Aqua Puffy Blouse", "brand": "Sheep Heavenly", },
0x1B3: { "id": 0x1B3, "name": "Retro Dot One-piece", "brand": "Sheep Heavenly", },
0x1B4: { "id": 0x1B4, "name": "Easy Breezy Dress", "brand": "Sheep Heavenly", },
0x1B5: { "id": 0x1B5, "name": "Green With Envy", "brand": "Sheep Heavenly", },
0x1B6: { "id": 0x1B6, "name": "Lemon Sherbert", "brand": "Sheep Heavenly", },
0x1B7: { "id": 0x1B7, "name": "Mint Ice Cream", "brand": "Sheep Heavenly", },
0x1B8: { "id": 0x1B8, "name": "Spangle Sorbet", "brand": "Sheep Heavenly", },
0x1B9: { "id": 0x1B9, "name": "Iris Gelato", "brand": "Sheep Heavenly", },
0x1BA: { "id": 0x1BA, "name": "Strawberry Chocolate", "brand": "Sheep Heavenly", },
0x1BB: { "id": 0x1BB, "name": "Mint Choco-chip", "brand": "Sheep Heavenly", },
0x1BC: { "id": 0x1BC, "name": "Angel Frill Skirt", "brand": "Sheep Heavenly", },
0x1BD: { "id": 0x1BD, "name": "Citrus Shorts", "brand": "Sheep Heavenly", },
0x1BE: { "id": 0x1BE, "name": "Sparkling Capris", "brand": "Sheep Heavenly", },
0x1BF: { "id": 0x1BF, "name": "Ribbon Cargos", "brand": "Sheep Heavenly", },
0x1C0: { "id": 0x1C0, "name": "Flaming Knee-highs", "brand": "Sheep Heavenly", },
0x1C1: { "id": 0x1C1, "name": "Cloud Nine Scarf", "brand": "Sheep Heavenly", },
0x1C2: { "id": 0x1C2, "name": "Lucky Rainbow Bracelets", "brand": "Sheep Heavenly", },
0x1C3: { "id": 0x1C3, "name": "Rounded Specs", "brand": "Sheep Heavenly", },
0x1C4: { "id": 0x1C4, "name": "Shining Star Dangles", "brand": "Sheep Heavenly", },
0x1C5: { "id": 0x1C5, "name": "Princess Ring", "brand": "Sheep Heavenly", },
0x1C6: { "id": 0x1C6, "name": "Happy Necklace", "brand": "Sheep Heavenly", },
0x1C7: { "id": 0x1C7, "name": "Heart Pochette", "brand": "Sheep Heavenly", },
0x1C8: { "id": 0x1C8, "name": "Polka Dot Bag", "brand": "Sheep Heavenly", },
0x1C9: { "id": 0x1C9, "name": "Wadatsumi", "brand": "Jupiter of the Monkey", },
0x1CA: { "id": 0x1CA, "name": "Fudo", "brand": "Jupiter of the Monkey", },
0x1CB: { "id": 0x1CB, "name": "Dharma", "brand": "Jupiter of the Monkey", },
0x1CC: { "id": 0x1CC, "name": "Suiten", "brand": "Jupiter of the Monkey", },
0x1CD: { "id": 0x1CD, "name": "Haramitsu", "brand": "Jupiter of the Monkey", },
0x1CE: { "id": 0x1CE, "name": "Amida", "brand": "Jupiter of the Monkey", },
0x1CF: { "id": 0x1CF, "name": "Ashura", "brand": "Jupiter of the Monkey", },
0x1D0: { "id": 0x1D0, "name": "Brahma", "brand": "Jupiter of the Monkey", },
0x1D1: { "id": 0x1D1, "name": "Komokuten", "brand": "Jupiter of the Monkey", },
0x1D2: { "id": 0x1D2, "name": "Togenkyo", "brand": "Jupiter of the Monkey", },
0x1D3: { "id": 0x1D3, "name": "Inazuma", "brand": "Jupiter of the Monkey", },
0x1D4: { "id": 0x1D4, "name": "Hannya", "brand": "Jupiter of the Monkey", },
0x1D5: { "id": 0x1D5, "name": "Aun", "brand": "Jupiter of the Monkey", },
0x1D6: { "id": 0x1D6, "name": "Gekirin", "brand": "Jupiter of the Monkey", },
0x1D7: { "id": 0x1D7, "name": "Karma", "brand": "Jupiter of the Monkey", },
0x1D8: { "id": 0x1D8, "name": "Naraka", "brand": "Jupiter of the Monkey", },
0x1D9: { "id": 0x1D9, "name": "Plumeria Ring", "brand": "Pavo Real", },
0x1DA: { "id": 0x1DA, "name": "Gold Band", "brand": "Pavo Real", },
0x1DB: { "id": 0x1DB, "name": "Coral Necklace", "brand": "Pavo Real", },
0x1DC: { "id": 0x1DC, "name": "Turquoise Necklace", "brand": "Pavo Real", },
0x1DD: { "id": 0x1DD, "name": "Garden Bracelet", "brand": "Pavo Real", },
0x1DE: { "id": 0x1DE, "name": "Wheel Bracelet", "brand": "Pavo Real", },
0x1DF: { "id": 0x1DF, "name": "Gold Bangle", "brand": "Pavo Real", },
0x1E0: { "id": 0x1E0, "name": "Pureheart Pendant", "brand": "Pavo Real", },
0x1E1: { "id": 0x1E1, "name": "Skull Pendant", "brand": "Pavo Real", },
0x1E2: { "id": 0x1E2, "name": "Chandelier Dangles", "brand": "Pavo Real", },
0x1E3: { "id": 0x1E3, "name": "Diamond Studs", "brand": "Pavo Real", },
0x1E4: { "id": 0x1E4, "name": "Plumeria Studs", "brand": "Pavo Real", },
0x1E5: { "id": 0x1E5, "name": "Navel Piercing", "brand": "Pavo Real", },
0x1E6: { "id": 0x1E6, "name": "Heart Nails", "brand": "Pavo Real", },
0x1E7: { "id": 0x1E7, "name": "Blue Nails", "brand": "Pavo Real", },
0x1E8: { "id": 0x1E8, "name": "Silver Screen Sweetheart", "brand": "Natural Puppy", },
0x1E9: { "id": 0x1E9, "name": "Silver Screen Starlet", "brand": "Natural Puppy", },
0x1EA: { "id": 0x1EA, "name": "Plain Shirt", "brand": "Natural Puppy", },
0x1EB: { "id": 0x1EB, "name": "Negative Polo", "brand": "Natural Puppy", },
0x1EC: { "id": 0x1EC, "name": "Positive Polo", "brand": "Natural Puppy", },
0x1ED: { "id": 0x1ED, "name": "Pink Stripe", "brand": "Natural Puppy", },
0x1EE: { "id": 0x1EE, "name": "Black Stripe", "brand": "Natural Puppy", },
0x1EF: { "id": 0x1EF, "name": "Lovely Camisole", "brand": "Natural Puppy", },
0x1F0: { "id": 0x1F0, "name": "White Cache-coeur", "brand": "Natural Puppy", },
0x1F1: { "id": 0x1F1, "name": "Chic Black Turtleneck", "brand": "Natural Puppy", },
0x1F2: { "id": 0x1F2, "name": "Midday Kitten Knit", "brand": "Natural Puppy", },
0x1F3: { "id": 0x1F3, "name": "Black Jeans", "brand": "Natural Puppy", },
0x1F4: { "id": 0x1F4, "name": "Brown Jeans", "brand": "Natural Puppy", },
0x1F5: { "id": 0x1F5, "name": "Skinny Jeans (Blue)", "brand": "Natural Puppy", },
0x1F6: { "id": 0x1F6, "name": "My Favorite One-piece", "brand": "Natural Puppy", },
0x1F7: { "id": 0x1F7, "name": "Angelic One-piece", "brand": "Natural Puppy", },
0x1F8: { "id": 0x1F8, "name": "Lovely One-piece", "brand": "Natural Puppy", },
0x1F9: { "id": 0x1F9, "name": "Simple Mules", "brand": "Natural Puppy", },
0x1FA: { "id": 0x1FA, "name": "Blossom Mules", "brand": "Natural Puppy", },
0x1FB: { "id": 0x1FB, "name": "Enamel Pumps", "brand": "Natural Puppy", },
0x1FC: { "id": 0x1FC, "name": "Simple Necktie", "brand": "Natural Puppy", },
0x1FD: { "id": 0x1FD, "name": "Waffle Necktie", "brand": "Natural Puppy", },
0x1FE: { "id": 0x1FE, "name": "Seattle", "brand": "Wild Boar", },
0x1FF: { "id": 0x1FF, "name": "San Francisco", "brand": "Wild Boar", },
0x200: { "id": 0x200, "name": "Las Vegas", "brand": "Wild Boar", },
0x201: { "id": 0x201, "name": "Chicago", "brand": "Wild Boar", },
0x202: { "id": 0x202, "name": "New York", "brand": "Wild Boar", },
0x203: { "id": 0x203, "name": "Negotiator", "brand": "Wild Boar", },
0x204: { "id": 0x204, "name": "Hey Boy", "brand": "Wild Boar", },
0x205: { "id": 0x205, "name": "Hey Girl", "brand": "Wild Boar", },
0x206: { "id": 0x206, "name": "Hey Everybody", "brand": "Wild Boar", },
0x207: { "id": 0x207, "name": "Alive", "brand": "Wild Boar", },
0x208: { "id": 0x208, "name": "Sabotage", "brand": "Wild Boar", },
0x209: { "id": 0x209, "name": "3 MC's 1 DJ", "brand": "Wild Boar", },
0x20A: { "id": 0x20A, "name": "Pass the Mic", "brand": "Wild Boar", },
0x20B: { "id": 0x20B, "name": "Won't Stop", "brand": "Wild Boar", },
0x20C: { "id": 0x20C, "name": "Don't Stop", "brand": "Wild Boar", },
0x20D: { "id": 0x20D, "name": "Camouflage", "brand": "Wild Boar", },
0x20E: { "id": 0x20E, "name": "Darkness", "brand": "Wild Boar", },
0x20F: { "id": 0x20F, "name": "Denim Coveralls", "brand": "Wild Boar", },
0x210: { "id": 0x210, "name": "Work Coveralls", "brand": "Wild Boar", },
0x211: { "id": 0x211, "name": "Gold Die", "brand": "Wild Boar", },
0x212: { "id": 0x212, "name": "Wild Boar Pendant", "brand": "Wild Boar", },
0x213: { "id": 0x213, "name": "King Pendant", "brand": "Wild Boar", },
0x214: { "id": 0x214, "name": "Skull Deck", "brand": "Wild Boar", },
0x215: { "id": 0x215, "name": "Camo Deck", "brand": "Wild Boar", },
0x216: { "id": 0x216, "name": "Cat Deck", "brand": "Wild Boar", },
0x217: { "id": 0x217, "name": "WEWY Promo Coat", "brand": "Gatito", },
0x218: { "id": 0x218, "name": "WEWY Promo Tee", "brand": "Gatito", },
0x219: { "id": 0x219, "name": "WEWY Promo Tote", "brand": "Gatito", },
0x21A: { "id": 0x21A, "name": "Pinky's Lipstick", "brand": "Gatito", },
0x21B: { "id": 0x21B, "name": "Lollipop's Parka", "brand": "Gatito", },
0x21C: { "id": 0x21C, "name": "Big Guy's Buckle", "brand": "Gatito", },
0x21D: { "id": 0x21D, "name": "Pi-Face's Cap", "brand": "Gatito", },
0x21E: { "id": 0x21E, "name": "Pi-Face's Coat", "brand": "Gatito", },
0x21F: { "id": 0x21F, "name": "Pi-Face's Jeans", "brand": "Gatito", },
0x220: { "id": 0x220, "name": "Pi-Face's Bandanna", "brand": "Gatito", },
0x221: { "id": 0x221, "name": "Iron Maiden's One-piece", "brand": "Gatito", },
0x222: { "id": 0x222, "name": "Shade's Headphones", "brand": "Gatito", },
0x223: { "id": 0x223, "name": "Sis's Pendant", "brand": "Gatito", },
0x224: { "id": 0x224, "name": "Wizard's Glasses", "brand": "Gatito", },
0x225: { "id": 0x225, "name": "My Phones", "brand": "Gatito", },
0x226: { "id": 0x226, "name": "Your Cap", "brand": "Gatito", },
0x227: { "id": 0x227, "name": "Her Stuffed Animal", "brand": "Gatito", },
0x228: { "id": 0x228, "name": "Angel Feather", "brand": "Gatito", },
0x229: { "id": 0x229, "name": "Gakuran", "brand": "Unbranded", },
0x22A: { "id": 0x22A, "name": "Sailor Suit", "brand": "Unbranded", },
0x22B: { "id": 0x22B, "name": "Boys' Uniform with Blazer", "brand": "Unbranded", },
0x22C: { "id": 0x22C, "name": "Girls' Uniform with Blazer", "brand": "Unbranded", },
0x22D: { "id": 0x22D, "name": "Girls' Uniform with Sweater", "brand": "Unbranded", },
0x22E: { "id": 0x22E, "name": "Head Honcho", "brand": "Unbranded", },
0x22F: { "id": 0x22F, "name": "Yukata", "brand": "Unbranded", },
0x230: { "id": 0x230, "name": "The Dead Slammurai", "brand": "Unbranded", },
0x231: { "id": 0x231, "name": "The Black Slammurai", "brand": "Unbranded", },
0x232: { "id": 0x232, "name": "Nose Glasses", "brand": "Unbranded", },
0x233: { "id": 0x233, "name": "Samurai Wig", "brand": "Unbranded", },
0x234: { "id": 0x234, "name": "Mr. Mew Suit", "brand": "Unbranded", },
0x235: { "id": 0x235, "name": "New Year's Gift", "brand": "Unbranded", },
0x236: { "id": 0x236, "name": "Pirate Hat", "brand": "Unbranded", },
0x237: { "id": 0x237, "name": "Potted Plant", "brand": "Unbranded", },
0x238: { "id": 0x238, "name": "Mr. Claus", "brand": "Unbranded", },
0x239: { "id": 0x239, "name": "Mrs. Claus", "brand": "Unbranded", },
0x23A: { "id": 0x23A, "name": "Black Book Bag", "brand": "Unbranded", },
0x23B: { "id": 0x23B, "name": "Red Book Bag", "brand": "Unbranded", },
0x23C: { "id": 0x23C, "name": "Biker Gloves", "brand": "Unbranded", },
0x23D: { "id": 0x23D, "name": "Maid Costume", "brand": "Unbranded", },
0x23E: { "id": 0x23E, "name": "Supermask's Mask", "brand": "Unbranded", },
0x23F: { "id": 0x23F, "name": "Ninja Garb", "brand": "Unbranded", },
0x240: { "id": 0x240, "name": "Samurai Helm", "brand": "Unbranded", },
0x241: { "id": 0x241, "name": "Samurai Armor", "brand": "Unbranded", },
0x242: { "id": 0x242, "name": "Fan of the Rising Sun", "brand": "Unbranded", },
0x243: { "id": 0x243, "name": "Samurai Sword", "brand": "Unbranded", },
0x244: { "id": 0x244, "name": "Solid Slammer", "brand": "Unbranded", },
0x245: { "id": 0x245, "name": "False Teeth", "brand": "Unbranded", },
0x246: { "id": 0x246, "name": "Lucky Mallet", "brand": "Unbranded", },
0x247: { "id": 0x247, "name": "Mr. Ducky", "brand": "Unbranded", },
}

// Hardcode it instead of generate it because array_push() doesn't exist yet.
brands = [
    "D+B", "Mus Rattus", "Dragon Couture", "Gatito", "Hip Snake", "Jupiter of the Monkey",
    "Lapin Angelique", "Natural Puppy", "Pavo Real", "Tigre Punks", "Pegaso", "Sheep Heavenly",
    "Wild Boar", "Unbranded"
]

function GetNumberOfBasePinsInBrand(brand)
{
    result = 0
    for i in pins
    {
        pin = pins[i]
        if (pin["Brand"] == brand && pin["Ev. fr. pin?"] == 0)
        {
            result = result + 1
        }
    }
    return result
}

function GetAllThreadsOfBrand(brand)
{
    result = {}
    for i in threads
    {
        thread = threads[i]
        if (thread["brand"] == brand)
        {
            result[i] = thread
        }
    }
    return result
}

function DoesNekuHaveBrandEquipped(brand)
{
    threadsInBrand = GetAllThreadsOfBrand(brand)
    result = always_false()
    for slot in range(0, 3)
    {
        brandIsInSlot = always_false()
        for i in threadsInBrand
        {
            thread = threadsInBrand[i]
            brandIsInSlot = brandIsInSlot || word(GetNekuThreadAddressBySlot(slot)) == thread["id"]
        }
        
        result = result || brandIsInSlot
    }
    
    return once(result)
}

// $071d2c: Neku thread, slot 1 (16-bit)
// $071d2e: Neku thread, slot 2 (16-bit)
// $071d30: Neku thread, slot 3 (16-bit)
// $071d32: Neku thread, slot 4 (16-bit)
function nekuThreadSlot1BaseAddr() => 0x071d2c

// $071d44: Shiki thread, slot 1 (16-bit)
function shikiThreadSlot1BaseAddr() => 0x071d44

// $071d5c: Joshua thread, slot 1 (16-bit)
function joshuaThreadSlot1BaseAddr() => 0x071d5c

// $071d74: Beat thread, slot 1 (16-bit)
function beatThreadSlot1BaseAddr() => 0x071d74

function GetNekuThreadAddressBySlot(slotId) => GetThreadAddressBySlot(slotId, nekuThreadSlot1BaseAddr())

function GetThreadAddressBySlot(slotId, slot1Addr) => slot1Addr + slotId * 2

function DoesNekuHaveThreadsEquipped()
{
    result = always_false()
    for slot in range(0, 3)
    {
        result = result || word(GetNekuThreadAddressBySlot(slot)) != 0xffff
    }
    
    return result
}

function HasNekuClothingChanged()
{
    result = always_false()
    for slot in range(0, 3)
    {
        result = result || Delta(word(GetNekuThreadAddressBySlot(slot))) != word(GetNekuThreadAddressBySlot(slot))
    }
    
    return result
}

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

function GetItemSlotAddrByIndex(slotNumber)
{
    return firstItemSlotBaseAddr + 4 * slotNumber
}

// TODO: VERY SLOW
function _BaseJustGotNumberOfItemsByName(name, count)
{
    item = GetItemByName(name)
    result = always_false()
    
    for i in range(0, itemSlots - 1)
    {
        addr = GetItemSlotAddrByIndex(i)
        idSubclause = always_false()
        if (count == 1)
        {
            idSubclause = Delta(word(addr)) == 0xffff
        }
        else
        {
            idSubclause = Delta(word(addr)) == item["id"] // We don't want achievements to trigger if the inventory is sorted.
        }
        
        result = result || word(addr) == item["id"] && WasValueSetInGame(low4(addr + 2), count - 1, count)
            && idSubclause 
    }
    
    return result
}

function JustGotNumberOfItemsByName(name, count)
{
    return _BaseJustGotNumberOfItemsByName(name, count)
}

// With this function, we don't have to check if the value was set in game. We just want to know if
// an item exists in the inventory.
function HasItemByName(name)
{
    item = GetItemByName(name)
    result = always_false()
    
    for i in range(0, itemSlots - 1)
    {
        result = result || word(GetItemSlotAddrByIndex(i)) == item["id"]
    }
    
    return result
}

function ItemInSlotIsACD(slot)
{
    id = word(GetItemSlotAddrByIndex(slot))
    return id >= 0x285 && id <= 0x2A6
}

function ItemInSlotJustGotFilledWithACD(slot)
{
    id = word(GetItemSlotAddrByIndex(slot))
    return Delta(id) == 0xffff && ItemInSlotIsACD(slot)
}

function ItemInSlotWasJustEmpty(slot)
{
    id = word(GetItemSlotAddrByIndex(slot))
    return Delta(id) == 0xffff
}

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

achievement(title = "The Seamstress", points = 1,
    description = "Forge a pact with Shiki.",
    trigger = WasValueSetInGame(partner(), GetPartnerByName("NONE"), GetPartnerByName("Shiki"))
        && never(IsLoadingSaveFile()) && unless(once(PlayerHasAccessedChapterSelectMenuBefore()))
        && CurrentChapterIs("Shiki, Day 1")
)

achievement(title = "The Observer", points = 1,
    description = "Forge a pact with Joshua.",
    trigger = WasValueSetInGame(partner(), GetPartnerByName("NONE"), GetPartnerByName("Joshua"))
        && never(IsLoadingSaveFile()) && unless(once(PlayerHasAccessedChapterSelectMenuBefore()))
        && CurrentChapterIs("Joshua, Day 1")
)

// Day progression achievements
// Note: Progressing to different weeks will be their own achievements.

dayAchievements = [
    { "name": "It's Dangerous to Play Alone", "description": "Reach the end of Week 1, Day 1.", "chapterCompleted": "Shiki, Day 1", "points": 1 },
    { "name": "Fratricide", "description": "Reach the end of Week 1, Day 2.", "chapterCompleted": "Shiki, Day 2", "points": 1 },
    { "name": "Cracks in the Shell", "description": "Reach the end of Week 1, Day 3.", "chapterCompleted": "Shiki, Day 3", "points": 1 },
    { "name": "No Greater Love", "description": "Reach the end of Week 1, Day 4.", "chapterCompleted": "Shiki, Day 4", "points": 1 },
    { "name": "Here, There Be Ghosts", "description": "Reach the end of Week 1, Day 5.", "chapterCompleted": "Shiki, Day 5", "points": 1 },
    { "name": "Living for Two", "description": "Reach the end of Week 1, Day 6.", "chapterCompleted": "Shiki, Day 6", "points": 1 },
    { "name": "A Second Chance at Death", "description": "Survive Week 1 of the Reapers' Game.", "chapterCompleted": "Shiki, Day 7", "points": 5 },
]

for cheevo in dayAchievements
{
    chapterCompleted = GetChapterByName(cheevo["chapterCompleted"])
    achievement(title = cheevo["name"], description = cheevo["description"], points = cheevo["points"],
        trigger = Delta(chapter()) == chapterCompleted["id"] && chapter() == chapterCompleted["id"] + 1
            && unless(IsLoadingSaveFile()) && unless(once(PlayerHasAccessedChapterSelectMenuBefore()))
    )
}

// End day progression achievements

achievement(title = "It's a Step Forward", points = 3,
    description = "Master a pin in your deck.",
    trigger = IsAnyDeckPinMastered() && isOnTitleScreen() == 0x0 && never(HasPinLoadoutChanged())
)

achievement(title = "Unnatural Selection", points = 5,
    description = "Evolve a pin.",
    trigger = IsAnyDeckPinEvolved()
)

achievement(title = "Befriending the Clerk", points = 5,
    description = "Attain a Friendship Level of 5 with a shopkeeper.",
    trigger = WasShopkeeperLeveledUpToLevel(5)
)

achievement(title = "Crushing on the Clerk", points = 10,
    description = "Attain a Friendship Level of 10 with a shopkeeper.",
    trigger = WasShopkeeperLeveledUpToLevel(10)
)

// TODO: Optimize; searching for items is VERY SLOW
//achievement(title = "With All Six Pins", points = 5,
//    description = "Obtain four Extra Slot stickers.",
//    trigger = JustGotNumberOfItemsByName("(S) Extra Slot", 4)
//)

// Music achievements
musicAchievements = [
    { "name": "Bronze Discography", "description": "Acquire five music tracks.", "threshold": 5, "points": 3 },
    { "name": "Silver Discography", "description": "Acquire ten music tracks.", "threshold": 10, "points": 5 },
    { "name": "Gold Discography", "description": "Acquire twenty-five music tracks.", "threshold": 25, "points": 10 },
    { "name": "Platinum Discography", "description": "Acquire all thirty-four music tracks.", "threshold": 34, "points": 25 },
]

musicConditions = {}
for i in range(0, itemSlots - 1)
{
    //musicConditions[i] = { "countsWhen": ItemInSlotIsACD(i), "recalculateWhen": ItemInSlotJustGotFilledWithACD(i) }
}

for cheevo in musicAchievements
{
    //GenerateSaveProtectedAchievementFromConditions_Naive(cheevo, musicConditions)
}

// End music achievements

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
    //noiseConditions[i] = { "countsWhen": NoiseEntryIsUnlocked(i), "recalculateWhen": anyNoiseEntryWasJustUnlocked }
}

for cheevo in noiseAchievements
{
    //GenerateSaveProtectedAchievementFromConditions(cheevo, noiseConditions)
}

// End Noise achievements

// Pin mastery achievements (TODO: Attempt to optimize; VERY SLOW TO GENERATE)

function GetPinMasteryScoreFromThreshold(threshold)
{
    if (threshold < 10)
    {
        return 5
    }
    else if (threshold >= 10 && threshold < 25)
    {
        return 10
    }
    else if (threshold >= 25)
    {
        return 25
    }
}

for brand in brands
{
    pinMasteryConditions = {}
    pinsInBrand = GetPinsByTrait("Brand", brand)
    numberOfBasePinsInBrand = GetNumberOfBasePinsInBrand(brand)
    ranges = GetValueRangesFromSortedPins(pinsInBrand)
    range = ranges[0] // Since they're all grouped together, we only care about the first range.
    
    for i in range(0, numberOfMasteredPinSlots - 1)
    {
        // Resetting the game can trigger the achievements; checking if the play time is greater than 0 should prevent this.
        recalculateWhen = MasteredPinSlotChanged(i) && playTime() > 0
        pinMasteryConditions[i] = { 
            "countsWhen": (MasteredPinSlot(i) >= range["min"] && MasteredPinSlot(i) <= range["max"]),
            "recalculateWhen": recalculateWhen
        }
    }

    cheevo = {
        "name": (brand + " Enthusiast"),
        "description": ("Have " + numberOfBasePinsInBrand + " types of " + brand + " pins in your Mastered collection."),
        "threshold": numberOfBasePinsInBrand,
        "points": GetPinMasteryScoreFromThreshold(numberOfBasePinsInBrand)
    }
    //GenerateSaveProtectedAchievementFromConditions(cheevo, pinMasteryConditions)
}

// End pin mastery achievements

achievement(title = "Battle Star", points = 5,
    description = "Earn a 🟊 ranking in battle on Hard or Ultimate difficulty.",
    trigger = AcquiredAtLeastRank("Star") && IsRankingRevealed()
        && IsAtLeastOnDifficulty("Hard")
)

achievement(title = "Battle Asterism", points = 25,
    description = "Earn a 🟊 ranking in a four-reduction battle chain or longer on Hard or Ultimate difficulty.",
    trigger = AcquiredAtLeastRank("Star") && IsRankingRevealed()
        && IsAtLeastOnDifficulty("Hard") && lengthOfBattleChain() >= 4
)

achievement(title = "Battle Constellation", points = 50,
    description = "Earn a 🟊 ranking in a nine-reduction battle chain or longer on Hard or Ultimate difficulty.",
    trigger = AcquiredAtLeastRank("Star") && IsRankingRevealed()
        && IsAtLeastOnDifficulty("Hard") && lengthOfBattleChain() >= 9
)

timeLimit = 30
achievement(title = "Don't Kill Me Slowly", points = 5,
    description = "Defeat the Metal Corehog within " + SecondsToFormat(timeLimit)
        + " (Normal or higher; Level 2 or below).",
    trigger = enemyId() == GetEnemyIdByName("Metal Corehog") && IsRankingRevealed() && battleTime() <= SecondsToFrames(timeLimit)
        && IsAtLeastOnDifficulty("Normal") && currentLevel() <= 2
)

function fusionLevel() => byte(0x37212d)

achievement(title = "No 1 2 Trust", points = 5,
    description = "Defeat the Vespertilio Canor without activating a Fusion (Normal or higher; Level 3 or below).",
    trigger = enemyId() == GetEnemyIdByName("Vespertilio Canor") && EnterBattleCheckpointValid()
        && IsAtLeastOnDifficulty("Normal") && currentLevel() <= 3 && never(Delta(fusionLevel()) > fusionLevel())
        && IsRankingRevealed()
)

achievement(title = "Avenged", points = 25,
    description = "Defeat the Swing Shark without any recovery pins equipped (Normal or higher; Level 4 or below).",
    trigger = enemyId() == GetEnemyIdByName("Swing Shark") && EnterBattleCheckpointValid()
        && IsAtLeastOnDifficulty("Normal") && currentLevel() <= 4 && IsRankingRevealed() && !HasRecoveryPinsEquipped()
)

pinsEquipped = []
for slotId in range(0, 5)
{
    array_push(pinsEquipped, once(word(GetDeckSlotAddrBySlotId(slotId)) != 0xffff))
}
achievement(title = "Empty Wardrobes", points = 5,
    description = "Defeat the Circle Pit Grizzly without Neku wearing threads and with no"
        + " more than two pins equipped (Normal or higher; Level 5 or below).",
    trigger = enemyId() == GetEnemyIdByName("Circle Pit Grizzly") && EnterBattleCheckpointValid()
        && IsAtLeastOnDifficulty("Normal") && currentLevel() <= 5 && IsRankingRevealed()
        && never(tally(3, pinsEquipped)) && !DoesNekuHaveThreadsEquipped()
)

psychokinesisAndRecoveryPins = {}
for i in recoveryPins
{
    pin = pins[i]
    psychokinesisAndRecoveryPins[pin["ID"]] = pin
}

for i in GetPinsByPsych("Psychokinesis")
{
    pin = pins[i]
    psychokinesisAndRecoveryPins[pin["ID"]] = pin
}

psychokinesisAndRecoveryPins[0xffff] = emptySlot

achievement(title = "Two Birds with One Car", points = 10,
    description = "Defeat the Cornix Canor while having only Psychokinesis or recovery pins equipped (Normal or higher; Level 8 or below).",
    trigger = enemyId() == GetEnemyIdByName("Cornix Canor") && EnterBattleCheckpointValid()
        && IsAtLeastOnDifficulty("Normal") && currentLevel() <= 8 && IsRankingRevealed()
        && OnlyTheGivenPinsAreEquipped(psychokinesisAndRecoveryPins)
)

achievement(title = "Enervated Escargot", points = 10,
    description = "Defeat the Ovis Cantus with at most four pins equipped, one of which being the Red Skull pin (Normal or higher; Level 8 or below).",
    trigger = enemyId() == GetEnemyIdByName("Ovis Cantus") && EnterBattleCheckpointValid()
        && IsAtLeastOnDifficulty("Normal") && currentLevel() <= 8 && IsRankingRevealed()
        && never(tally(5, pinsEquipped)) && AnyOfTheGivenPinsAreEquipped(GetPinsByTrait("Name", "Red Skull"))
)

positivePins = GetPinsByTrait("Element", "Pos")
positivePins[0xffff] = emptySlot
achievement(title = "Yoctometers Apart", points = 10,
    description = "Defeat the Dub Rhino with at most four, Positive-type pins equipped (Normal or higher; Level 8 or below).",
    trigger = enemyId() == GetEnemyIdByName("Dub Rhino") && EnterBattleCheckpointValid()
        && IsAtLeastOnDifficulty("Normal") && currentLevel() <= 8 && IsRankingRevealed()
        && never(tally(5, pinsEquipped)) && OnlyTheGivenPinsAreEquipped(positivePins)
)

equippedBrands = []
for i in brands
{
    array_push(equippedBrands, DoesNekuHaveBrandEquipped(i))
}

achievement(title = "It's My Asskicking Outfit, Bitch!", points = 0,
    description = "Defeat X while Neku is wearing threads from four different brands.",
    trigger = tally(4, equippedBrands) && never(HasNekuClothingChanged())
        //&& EnterBattleCheckpointValid() && IsRankingRevealed()
)


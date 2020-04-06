// Legend of Zelda, The: Spirit Tracks
// #ID = 9898

// UTILITY

function Delta(addr) => prev(addr)

function WasBitflagSetInGame(bit)
{
    return once(Delta(bit) != bit && bit == 1)
        && never(isLoadingSaveFile())
}

// $065B68: Max Rupees
// $0B5308: >0x0 = air is being blown into the mic

// $0BB584: Time remaining in the final exam (dynamic?)
function timeRemainingInFinalExam() => word(0x0BB584)

// $261640: Current location (US)
function currentLocation() => word(0x261640)

locationInfo = {
    0x2f: { "id": 0x2f, "name": "Agoda Village", "code": "Agoda", },
    0x8: { "id": 0x8, "name": "Hyrule Field (Forest Realm)", "code": "ForestField", },
    0x29: { "id": 0x29, "name": "Castle Town", "code": "CastleTown", },
    0x28: { "id": 0x28, "name": "Hyrule Castle", "code": "Castle", },
    0x50: { "id": 0x50, "name": "Watching a cutscene…", "code": "Cutscene", },
    0x18: { "id": 0x18, "name": "Tunnel to the Tower", "code": "Tunnel", },
    0x14: { "id": 0x14, "name": "the Tower of Spirits", "code": "Tower", },
    0x17: { "id": 0x17, "name": "the Spiral Staircase", "code": "Staircase", },
    0x13: { "id": 0x13, "name": "the Tower of Spirits, 1F", "code": "TowerDungeon", },
    0x4: { "id": 0x4, "name": "Hyrule Field (Forest Realm)", "code": "ForestField2", },
    0x2a: { "id": 0x2a, "name": "Whittleton", "code": "Whittleton", },
    0x38: { "id": 0x38, "name": "the wilds outside Whittleton", "code": "WhittletonWilds", },
    0x9: { "id": 0x9, "name": "the Lost Woods", "code": "LostWoods", },
    0x30: { "id": 0x30, "name": "the Forest Sanctuary", "code": "ForestSanctuary", },
    0x19: { "id": 0x19, "name": "the Forest Temple", "code": "ForestTemple", },
    0x1e: { "id": 0x1e, "name": "in Stagnox’s lair…", "code": "Stagnox", },
    0xff00: { "id": 0xff00, "name": "On the title screen…", "code": "Title", },
    0x0: { "id": 0x0, "name": "Starting the game…", "code": "Boot", },
}

function GetLocationByCode(code)
{
    for id in locationInfo
    {
        if (locationInfo[id]["code"] == code)
        {
            return locationInfo[id]
        }
    }
}

function IsInLocationWithCode(code)
{
    location = GetLocationByCode(code)
    return currentLocation() == location["id"]
}

function IsInGame()
{
    boot = GetLocationByCode("Boot")
    title = GetLocationByCode("Title")
    return currentLocation() != boot["id"] && currentLocation() != title["id"]
}

// $261654: Current location (US) (changes when level is done loading)
function currentLocationAfterLoad() => word(0x261654)

// $262060: Current Location (EU)
// $262074: Location that will load (EU)

// $26479C: Current HP(?)
function currentHP() => byte(0x26479C)

// $26479D: Max HP(?)
function maxHP() => byte(0x26479D)

// $2648F8: Currently equipped item
function currentlyEquippedItem() => byte(0x2648F8)

// $264900: Bit 0: Whirlwind
//          Bit 1: Boomerang
//          Bit 2: Whip
//          Bit 3: Bow
//          Bit 4: Bombs
//          Bit 5: Sand Wand
// $264902: Bit 1: Recruit's Sword
//          Bit 7: Spirit Flute

function hasRecruitSword() => bit1(0x264902)

// $264908: Rupees
function rupees() => word(0x264908)

// $264914: Potion slot 1:
//          
//          0 = no potion
//          1 = Red Potion
//          2 = Purple Potion
//          3 = Yellow Potion
// $264915: Potion slot 2:
//          
//          0 = no potion
//          1 = Red Potion
//          2 = Purple Potion
//          3 = Yellow Potion
// $264CF4: Bit 4: Forest Temple
//          Bit 5: Snow Temple
//          Bit 6: Ocean Temple
//          Bit 7: Fire Temple
function forestTempleClear() => bit4(0x264CF4)

// $264d0a: Bit 4: Started duet with Gage
// $264CF5: Bit 0: Completed duet with Gage
//          Bit 7: Forest Railmap
function startedDuetWithGage() => bit4(0x264d0a)

function completedDuetWithGage() => bit0(0x264CF5)

function hasForestRailmap() => bit7(0x264CF5)

// $264CF7: Bit 0: Engineer Certificate

// $264CFB: Bit 0: Postman introduction (first time)
function wasPostmanIntroducedForTheFirstTime() => bit0(0x264CFB)

// $264D05: Bit 4: Rolled into the tree (ow...)
// $264D0E: Bit 0: Sand Temple
//          Bit 6: Rabbit Net
// $264D18: Bit 5: Reward for rolling into the tree (ow...)
// $264D19: Bit 1: Stamp Book
//          Bit 5: Compass of Light
// $264D26: Bit 0: Platinum Card (if Bit 4 is 1)
//          Bit 1: Diamond Card (if Bit 4 is 1)
//          Bit 2: Freebie Card
//          Bit 3: Quintuple Points Card
//          Bit 4: Club Card
// $2651BC: Current HP (EU)
// $2651BD: Max HP (EU)
// $2685E0: Demon Fossil count
// $2685E2: Stalfos Skull count
// $2685E4: Star Fragment count
// $2685E6: Bee Larvae count
// $2685E8: Wood Heart count
// $2685EA: Dark Pearl Loop count
// $2685EC: Pearl Necklaces count
// $2685EE: Ruto Crown count
// $2685F0: Dragon Scale count
// $2685F2: Pirate Necklace count
// $2685F4: Palace Dish count
// $2685F6: Goron Amber count
// $2685F8: Mystic Jade count
// $2685FA: Ancient Gold Piece count
// $2685FC: Alchemy Stone count
// $2685FE: Regal Ring count
// $2C3B00: Rupees (display)

// $264cf6: Bit 0: Snow Railmap
//          Bit 4: Trained with the captain
//          Bit 5: Cole appears for the first time
//          Bit 6: Zelda's guard is out of the way
//          Bit 7: Cole has let the guard pass and is at the ceremony
function hasSnowRailmap() => bit0(0x264cf6)

function trainedWithTheRoyalGuard() => bit4(0x264cf6)

// $04a04c: 0x1 = transitioning into game mode after clicking Adventure or Battle
function isLoadingSaveFile() => byte(0x04a04c) != 0

// $264d06: Bit 1: Zelda possessed a Phantom for the first time
function possessedAPhantomForTheFirstTime() => bit1(0x264d06)

// $268590: Bit 0: Song of Awakening
//          Bit 1: Song of Healing
//          Bit 2: Song of Birds
//          Bit 3: Song of Light
//          Bit 4: Song of Discovery
songAddr = 0x268590
function learnedSongOfAwakening() => bit0(songAddr)
function learnedSongOfHealing() => bit1(songAddr)
function learnedSongOfBirds() => bit2(songAddr)
function learnedSongOfLight() => bit3(songAddr)
function learnedSongOfDiscovery() => bit4(songAddr)

// ACHIEVEMENTS

// "Extra Credit"
hyruleField = GetLocationByCode("ForestField")
castleTown = GetLocationByCode("CastleTown")
agoda = GetLocationByCode("Agoda")
achievement(title = "Extra Credit", description = "Pass your final exam with at least 128 seconds left on the clock.", points = 1,
    trigger = once(Delta(currentLocation()) == agoda["id"] && currentLocation() == hyruleField["id"])
        && never(timeRemainingInFinalExam() < 128)
        && currentLocation() == castleTown["id"]
        && unless(timeRemainingInFinalExam() == 0)
        && never(wasPostmanIntroducedForTheFirstTime() == 1)
)

// "Fresh from the Academy"
achievement(title = "Fresh from the Academy",
    description = "Acquire the Recruit's Sword and train under Russell, the Captain of the Guard.", points = 1,
    trigger = WasBitflagSetInGame(trainedWithTheRoyalGuard())
        && IsInLocationWithCode("Castle")
)

// Teamwork Makes the Dream Work
achievement(title = "Teamwork Makes the Dream Work",
    description = "Have Zelda possess a Phantom for the first time.", points = 1,
    trigger = WasBitflagSetInGame(possessedAPhantomForTheFirstTime())
        && IsInLocationWithCode("TowerDungeon")
)

// Forest Mapper
achievement(title = "Forest Mapper",
    description = "Obtain the Forest Railmap.", points = 3,
    trigger = WasBitflagSetInGame(hasForestRailmap())
        && IsInLocationWithCode("TowerDungeon")
)

// Snow Mapper
achievement(title = "Snow Mapper",
    description = "Obtain the Snow Railmap.", points = 3,
    trigger = WasBitflagSetInGame(hasSnowRailmap())
        && IsInLocationWithCode("TowerDungeon")
)

// "Up-and-Coming Musician"
achievement(title = "Up-and-Coming Musician",
    description = "Learn a song on the Spirit Flute.", points = 1,
    trigger = never(IsInLocationWithCode("Title"))
        && (WasBitflagSetInGame(learnedSongOfAwakening())
        || WasBitflagSetInGame(learnedSongOfHealing())
        || WasBitflagSetInGame(learnedSongOfBirds())
        || WasBitflagSetInGame(learnedSongOfLight())
        || WasBitflagSetInGame(learnedSongOfDiscovery()))
)

// "Duet with the Cellist"
achievement(title = "Duet with the Cellist",
    description = "Complete your duet with Gage and open the path to the Forest Temple.",
    points = 3,
    trigger = WasBitflagSetInGame(startedDuetWithGage())
        && WasBitflagSetInGame(completedDuetWithGage())
        && IsInLocationWithCode("ForestSanctuary")
)

// "Shoo, Fly, Shoo"
function IsStagnoxDying() => byte(0x31f538) == 0x15

function stagnoxHP() => byte(0x31f534)

forestTemple = GetLocationByCode("ForestTemple")

achievement(title = "Shoo, Fly, Shoo",
    description = "Defeat Stagnox without taking damage.", points = 10,
    trigger = never(!IsInLocationWithCode("Stagnox"))
        && once(IsInLocationWithCode("Stagnox") && Delta(currentLocation()) == forestTemple["id"])
        && IsStagnoxDying()
        && never(Delta(currentHP()) > currentHP())
)

// "Yet More Shackles Remain"
achievement(title = "Yet More Shackles Remain", points = 5,
    description = "Clear the Forest Temple.",
    trigger = WasBitflagSetInGame(forestTempleClear())
        && IsInLocationWithCode("Stagnox")
)

// "Syrinx Sage"
songTrigger = always_false()

for i in range(0, 4) // 0-4 maps to each Spirit Flute song.
{
    alt = always_true()
    for j in range(0, 4)
    {
        if (j != i) // We want each alt to deal with each song.
        {
            alt = alt && bit(j, songAddr) == 1
        }
        else
        {
            alt = alt && WasBitflagSetInGame(bit(j, songAddr))
        }
    }
    
    songTrigger = songTrigger || alt
}

achievement(title = "Syrinx Sage",
    description = "Learn all five songs on the Spirit Flute.", points = 5,
    trigger = songTrigger
)

// Stamp achievements

// $26856c: ID of stamp on first stamp page (0xff when there's no stamp)
// $26857f: ID of stamp on the last stamp page (0xff when there's no stamp)
function firstStampAddr() => 0x26856c

function stampPageByNumber(pageNo) => byte(firstStampAddr() + pageNo - 1)

function PageNumberIsStamped(pageNo)
{
    return stampPageByNumber(pageNo) != 0xff
}

stampAchievements = [
    { "name": "The Beginning of a Pastime", "points": 1, "description": "Collect your first stamp.", "threshold": 1 },
    { "name": "A Sheet Filled", "points": 3, "description": "Collect five stamps.", "threshold": 5 },
    { "name": "Stamp Hobbyist", "points": 5, "description": "Collect ten stamps.", "threshold": 10 },
    { "name": "First-Class Collector", "points": 10, "description": "Collect fifteen stamps.", "threshold": 15 },
    { "name": "Philately Phanatic", "points": 25, "description": "Collect all twenty stamps.", "threshold": 20 }
]

for info in stampAchievements
{
    stampMade = always_false()
    resetalt = always_false()
    
    for i in range(1, 20)
    {
        stampMade = stampMade || once(stampPageByNumber(i) != 0xff)
        
        // We want to reset the hit counts each time a stamp is made so that the player
        // doesn't simply stamp each page in the book until each achievement is obtained.
        // We want the hit counts to match the state of each stamp page.
        resetalt = resetalt || never(Delta(stampPageByNumber(i)) != stampPageByNumber(i))
            && unless(isLoadingSaveFile())
    }
    
    // We also don't want to do anything if *none* of the stamp pages change. This way,
    // simply loading a save doesn't trigger them immediately. A two-frame target is used
    // to give the achievement time to register a new change on the frame immediately
    // following a reset.
    unlessStampStatesAreIdle = unless(repeated(2, always_true()))
    
    achievement(title = info["name"], description = info["description"], points = info["points"],
        trigger = IsInGame()
            && repeated(info["threshold"], stampMade) && unlessStampStatesAreIdle
            && resetalt
    )
}

// Rabbit rescue achievements

// $261610: Bits 0-7: Grass rabbits rescued
// $261611: Bits 0-1: Grass rabbits rescued
//          Bits 2-7: Snow rabbits rescued
// $261612: Bits 0-3: Snow rabbits rescued
//          Bits 4-7: Ocean rabbits rescued
// $261613: Bits 0-5: Ocean rabbits rescued
//          Bits 6-7: Mountain rabbits rescued
// $261614: Bits 0-7: Mountain rabbits rescued
// $261615: Bits 0-7: Desert rabbits rescued
// $261616: Bits 0-1: Desert rabbits rescued

function RabbitRescueState(index)
{
    if (index >= 0 && index < 32)
    {
        return bit(index, 0x261610)
    }
    else if (index >= 32 && index < 50)
    {
        return bit(index - 32, 0x261614)
    }
}

sheerTotalRabbitAchievements = [
    { "name": "Rookie Rabbit Rescuer", "points": 1, "description": "Rescue a rabbit for the first time.", "threshold": 1 },
    { "name": "Trainee Rabbit Rescuer", "points": 3, "description": "", "threshold": 5 },
    { "name": "Regular Rabbit Rescuer", "points": 5, "description": "", "threshold": 10 },
    { "name": "Veteran Rabbit Rescuer", "points": 10, "description": "", "threshold": 25 },
    { "name": "Legendary Rabbit Rescuer", "points": 25, "description": "Rescue all 50 rabbits.", "threshold": 50 }
]

for info in sheerTotalRabbitAchievements
{
    rabbitRescued = always_false()
    description = info["description"]
    resetalt = always_false()
    
    if (description == "")
    {
        description = "Rescue " + info["threshold"] + " rabbits."
    }
    
    for i in range(0, 49)
    {
        rabbitRescued = rabbitRescued || once(RabbitRescueState(i) == 1)
        
        // Like the above, we want to reset the hit counts each time a rabbit is rescued
        // to refresh the hitcount state that represents each individual rabbit being rescued.
        resetalt = resetalt || never(Delta(RabbitRescueState(i)) != RabbitRescueState(i))
            && unless(isLoadingSaveFile())
    }
    
    // Also like the above, we also don't want to do anything if no rabbit is rescued on a frame
    // as a save protection measure. A two-frame target is used for the same reason as the above, as well.
    unlessRabbitStatesAreIdle = unless(repeated(2, always_true()))
    
    achievement(title = info["name"], description = description, points = info["points"],
        trigger = IsInGame()
            && measured(repeated(info["threshold"], rabbitRescued)) && unlessRabbitStatesAreIdle
            && resetalt
    )
}

// Type IDs must be zero-indexed for offset calculations.
rabbitTypes = [
    { "type": "Forest", "id": 0 },
    { "type": "Snow", "id": 1 },
    { "type": "Ocean", "id": 2 },
    { "type": "Mountain", "id": 3 },
    { "type": "Sand", "id": 4 }
]

rabbitTypeAchievements = [
    { "name": "Forest Cuniculture", "description": "Rescue all ten grass rabbits.", "type": "Forest" },
    { "name": "Snow Cuniculture", "description": "Rescue all ten snow rabbits.", "type": "Snow" },
    { "name": "Ocean Cuniculture", "description": "Rescue all ten ocean rabbits.", "type": "Ocean" },
    { "name": "Mountain Cuniculture", "description": "Rescue all ten mountain rabbits.", "type": "Mountain" },
    { "name": "Sand Cuniculture", "description": "Rescue all ten desert rabbits.", "type": "Sand" }
]

function GetRabbitTypeIdByType(typeName)
{
    for type in rabbitTypes
    {
        if (typeName == type["type"])
        {
            return type["id"]
        }
    }
}

function RabbitRescueStateByType(index, type)
{
    // We need to get the proper index for the rabbit we're looking for.
    // For instance, if we're looking for the third ocean rabbit, the index we're looking
    // for is 22.
    return RabbitRescueState(GetRabbitTypeIdByType(type) * 10 + index)
}
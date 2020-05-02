// Legend of Zelda, The: Spirit Tracks
// #ID = 9898

// UTILITY

function Delta(addr) => prev(addr)

function WasBitflagSetInGame(bit)
{
    return once(Delta(bit) != bit && bit == 1)
        && never(isLoadingSaveFile())
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

// $3ffc3c: (32-bit) System timer. Increments by one every frame.
function framesCounter() => dword(0x3ffc3c)

function frameIncremented() => prev(framesCounter()) != framesCounter()

function SecondsToFrames(seconds) => seconds * 60 // Assuming a 60 FPS framerate

// $04e5ee: 0x1 = makes top screen white during transitions
function topScreenTransitionState() => byte(0x04e5f0)

// $04e5ef: 0xff = makes the top screen black if the previous byte is not 0.
function IsTopScreenBlack() => byte(0x04e5ef) == 0xff

function IsTransitioningInBlack() => IsTopScreenBlack() && topScreenTransitionState() == 1

// $065B68: Max Rupees
// $0B5308: >0x0 = air is being blown into the mic

// $0BB584: Time remaining in the final exam (dynamic?)
function timeRemainingInFinalExam() => word(0x0BB584)

// $1227f8: Training minigame - game state
//
//          0x0 = Not started/After fade in
//          0x1 = Countdown
//          0x2 = Guards are passive
//          0x3 = Guard is attacking
//          0x4 = Game over
//          0x5 = Post game over
function trainingGameState() => byte(0x1227f8)

// $12280c: Training minigame - Hits remaining
function trainingGameHitsRemaining() => word(0x12280c)

// $12280e: Training minigame - Points in current game
function trainingGameScore() => word(0x12280e)

// $15b184: Whip Race - state:
//          0x1 = countdown
//          0x2 = race in progress
//          0x3 = finish
//          0x4 = after finish
function whipRaceState() => byte(0x15b184)

// $15b188: Whip race - current time (16-bit)
function whipRaceTime() => word(0x15b188)

// $15b194: Determines how the whip race ended.
//
//          0x1 = timeout
//          0x2 = forfeit
//          any other value = complete
function reasonWhipRaceEnded() => byte(0x15b194)

// $163fe0: Pirate Hideout minigame state
//
//          0x0 = before countdown
//          0x1 = countdown
//          0x2 = Stage 1
//          0x3 = Stage 2
//          0x5 = captured
function pirateHideoutState() => byte(0x163fe0)

// $17e428: Take 'Em All On! state:
//
//          0x1 = counting down
//          0x2 = in progress
function gauntletState() => byte(0x17e428)

// $17e42c: Gauntlet time (assumes 30fps) (32-bit)
function gauntletTime() => dword(0x17e42c)

// $25ff90: 0x1 = paused
function IsPaused() => byte(0x25ff90) == 1

// $261640: Current location (US)
function currentLocation() => word(0x261640)

locationInfo = {
    0x2f: { "id": 0x2f, "name": "In Agoda Village", "code": "Agoda",  "isDungeon": 0,  "floorAddr": 0 },
    0x8: { "id": 0x8, "name": "In Hyrule Field (Forest Realm)", "code": "ForestRealm",  "isDungeon": 0,  "floorAddr": 0 },
    0x29: { "id": 0x29, "name": "In Castle Town", "code": "CastleTown",  "isDungeon": 0,  "floorAddr": 0 },
    0x28: { "id": 0x28, "name": "Inside Hyrule Castle", "code": "Castle",  "isDungeon": 1,  "floorAddr": 0 },
    0x50: { "id": 0x50, "name": "Watching a cutscene…", "code": "Cutscene",  "isDungeon": 0,  "floorAddr": 0 },
    0x18: { "id": 0x18, "name": "In the Tunnel to the Tower", "code": "Tunnel",  "isDungeon": 0,  "floorAddr": 0 },
    0x14: { "id": 0x14, "name": "In the Tower of Spirits lobby", "code": "Tower",  "isDungeon": 0,  "floorAddr": 0 },
    0x17: { "id": 0x17, "name": "Climbing the Spiral Staircase", "code": "Staircase",  "isDungeon": 0,  "floorAddr": 0 },
    0x13: { "id": 0x13, "name": "In the Tower of Spirits", "code": "TowerDungeon",  "isDungeon": 1,  "floorAddr": 0x2cefe8 },
    0x4: { "id": 0x4, "name": "In Hyrule Field (Forest Realm)", "code": "ForestField2",  "isDungeon": 0,  "floorAddr": 0 },
    0x2a: { "id": 0x2a, "name": "In Whittleton", "code": "Whittleton",  "isDungeon": 0,  "floorAddr": 0 },
    0x38: { "id": 0x38, "name": "In the wilds outside Whittleton", "code": "WhittletonWilds",  "isDungeon": 0,  "floorAddr": 0 },
    0x9: { "id": 0x9, "name": "Stumbling through the Lost Woods", "code": "LostWoods",  "isDungeon": 0,  "floorAddr": 0 },
    0x30: { "id": 0x30, "name": "In the Forest Sanctuary", "code": "ForestSanctuary",  "isDungeon": 0,  "floorAddr": 0 },
    0x19: { "id": 0x19, "name": "In the Forest Temple", "code": "ForestTemple",  "isDungeon": 1,  "floorAddr": 0 },
    0x1e: { "id": 0x1e, "name": "In Stagnox’s lair…", "code": "Stagnox",  "isDungeon": 0,  "floorAddr": 0 },
    0xff00: { "id": 0xff00, "name": "On the title screen…", "code": "Title",  "isDungeon": 0,  "floorAddr": 0 },
    0x0: { "id": 0x0, "name": "Starting the game…", "code": "Boot",  "isDungeon": 0,  "floorAddr": 0 },
    0x3e: { "id": 0x3e, "name": "At Rabbitland Rescue", "code": "Rabbit",  "isDungeon": 0,  "floorAddr": 0 },
    0x5: { "id": 0x5, "name": "In Hyrule Field (Snow Realm)", "code": "SnowRealm",  "isDungeon": 0,  "floorAddr": 0 },
    0x2b: { "id": 0x2b, "name": "Anouki Village", "code": "Anouki",  "isDungeon": 0,  "floorAddr": 0 },
    0xb: { "id": 0xb, "name": "In Hyrule Field (Snow Realm – Tunnel)", "code": "SnowTunnel",  "isDungeon": 0,  "floorAddr": 0 },
    0x31: { "id": 0x31, "name": "In the Snow Sanctuary", "code": "SnowSanctuary",  "isDungeon": 0,  "floorAddr": 0 },
    0x35: { "id": 0x35, "name": "At Wellspring Station", "code": "Wellspring",  "isDungeon": 0,  "floorAddr": 0 },
    0x45: { "id": 0x45, "name": "On the side of the tracks…", "code": "Tracks",  "isDungeon": 0,  "floorAddr": 0 },
    0x1a: { "id": 0x1a, "name": "In the Snow Temple", "code": "SnowTemple",  "isDungeon": 1,  "floorAddr": 0 },
    0x1f: { "id": 0x1f, "name": "In Fraaz’s lair…", "code": "Fraaz",  "isDungeon": 0,  "floorAddr": 0 },
    0x37: { "id": 0x37, "name": "At the Trading Post", "code": "Trading",  "isDungeon": 0,  "floorAddr": 0 },
    0x36: { "id": 0x36, "name": "At the Bridge Worker’s Home", "code": "BridgeWorker",  "isDungeon": 0,  "floorAddr": 0 },
    0x6: { "id": 0x6, "name": "In Hyrule Field (Ocean Realm)", "code": "Ocean",  "isDungeon": 0,  "floorAddr": 0 },
    0x2c: { "id": 0x2c, "name": "In Papuchia Village", "code": "Papuchia",  "isDungeon": 0,  "floorAddr": 0 },
    0x32: { "id": 0x32, "name": "In the Ocean Sanctuary", "code": "OceanSanctuary",  "isDungeon": 0,  "floorAddr": 0 },
    0x43: { "id": 0x43, "name": "Fending off intruders in the Spirit Train!", "code": "Train",  "isDungeon": 0,  "floorAddr": 0 },
    0xa: { "id": 0xa, "name": "Underwater (Ocean Realm)", "code": "UnderOcean",  "isDungeon": 0,  "floorAddr": 0 },
    0x1b: { "id": 0x1b, "name": "In the Ocean Temple", "code": "OceanTemple",  "isDungeon": 1,  "floorAddr": 0 },
    0x20: { "id": 0x20, "name": "In Phytops’s lair…", "code": "Phytops",  "isDungeon": 0,  "floorAddr": 0 },
    0x46: { "id": 0x46, "name": "Competing in Take ‘Em All On! - Level 1", "code": "Gauntlet1",  "isDungeon": 0,  "floorAddr": 0 },
    0x4b: { "id": 0x4b, "name": "Fighting Stagnox in Take ‘Em All On!", "code": "GauntletStagnox",  "isDungeon": 0,  "floorAddr": 0 },
    0x48: { "id": 0x48, "name": "Competing in Take ‘Em All On! - Level 2", "code": "Gauntlet2",  "isDungeon": 0,  "floorAddr": 0 },
    0x7: { "id": 0x7, "name": "In Hyrule Field (Fire Realm)", "code": "FireRealm",  "isDungeon": 0,  "floorAddr": 0 },
    0x3c: { "id": 0x3c, "name": "At the Goron Target Range", "code": "TargetRange",  "isDungeon": 0,  "floorAddr": 0 },
    0x2e: { "id": 0x2e, "name": "In Goron Village", "code": "Goron",  "isDungeon": 0,  "floorAddr": 0 },
    0x2d: { "id": 0x2d, "name": "Walking the path to the Altar of the Mountain Goddess", "code": "AltarPath",  "isDungeon": 0,  "floorAddr": 0 },
    0x33: { "id": 0x33, "name": "In the Fire Sanctuary", "code": "FireSanctuary",  "isDungeon": 0,  "floorAddr": 0 },
    0x3f: { "id": 0x3f, "name": "At Snowdrift or Slippery Station", "code": "Snowdrift",  "isDungeon": 0,  "floorAddr": 0 },
    0x1c: { "id": 0x1c, "name": "In the Fire Temple", "code": "FireTemple",  "isDungeon": 0,  "floorAddr": 0 },
    0x21: { "id": 0x21, "name": "In Cragma’s lair…", "code": "Cragma",  "isDungeon": 0,  "floorAddr": 0 },
    0x23: { "id": 0x23, "name": "In Byrne’s lair…", "code": "Byrne",  "isDungeon": 0,  "floorAddr": 0 },
    0x15: { "id": 0x15, "name": "At the top of the Tower of Spirits", "code": "TowerTop",  "isDungeon": 0,  "floorAddr": 0 },
    0x16: { "id": 0x16, "name": "At the top of the Tower of Spirits", "code": "TowerTop2",  "isDungeon": 0,  "floorAddr": 0 },
    0x44: { "id": 0x44, "name": "Aboard the Spirit Train", "code": "Train2",  "isDungeon": 0,  "floorAddr": 0 },
    0xe: { "id": 0xe, "name": "Competing at the Goron Target Range", "code": "TargetRangeGame",  "isDungeon": 0,  "floorAddr": 0 },
    0x40: { "id": 0x40, "name": "At Disorientation Station", "code": "Disorientation",  "isDungeon": 0,  "floorAddr": 0 },
    0x3a: { "id": 0x3a, "name": "At the Pirate Hideout", "code": "Pirate",  "isDungeon": 0,  "floorAddr": 0 },
    0x3b: { "id": 0x3b, "name": "Inside the Pirate Hideout", "code": "PirateMinigame",  "isDungeon": 0,  "floorAddr": 0 },
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

function WasInLocationWithCode(code)
{
    location = GetLocationByCode(code)
    return Delta(currentLocation()) == location["id"]
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

// $264912: Arrows in inventory
function arrows() => word(0x264912)

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
function snowTempleClear() => bit5(0x264CF4)
function oceanTempleClear() => bit6(0x264CF4)
function fireTempleClear() => bit7(0x264CF4)

// $264d00: Bit 2: Snow Realm Rocktite defeated
//          Bit 4: Purchased Mega Ice for the first time
function snowRealmRocktiteDefeated() => bit2(0x264d00)
function purchasedMegaIceForFirstTime() => bit4(0x264d00)

// $264d0a: Bit 4: Started duet with Gage

// $264d4b: Bit 1: Opened chest for Champion Course at Slippery Station
function openedChampionChest() => bit1(0x264d4b)

// $264CF5: Bit 0: Completed duet with Gage
//          Bit 1: Completed duet with Steem
//          Bit 7: Forest Railmap
function startedDuetWithGage() => bit4(0x264d0a)

function completedDuetWithGage() => bit0(0x264CF5)
function completedDuetWithSteem() => bit1(0x264CF5)
function completedDuetWithCarben() => bit2(0x264CF5)
function completedDuetWithEmbrose() => bit3(0x264CF5)

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

// $264d25: Bit 6: Silver Card
//          Bit 7: Gold Card
function silverCardObtained() => bit6(0x264d25)

function goldCardObtained() => bit7(0x264d25)

// $264D26: Bit 0: Platinum Card (if Bit 4 is 1)
//          Bit 1: Diamond Card (if Bit 4 is 1)
//          Bit 2: Freebie Card
//          Bit 3: Quintuple Points Card
//          Bit 4: Club Card
function platinumCardObtained() => bit0(0x264d26)

function diamondCardObtained() => bit1(0x264d26)

function clubCardObtained() => bit4(0x264d26)

// $2651BC: Current HP (EU)
// $2651BD: Max HP (EU)
// $2685E0: Demon Fossil count
demonFossilCountAddr = 0x2685e0
function demonFossilCount() => word(demonFossilCountAddr)

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
//          Bit 1: Ocean Railmap
//          Bit 2: Fire Railmap
//          Bit 4: Trained with the captain
//          Bit 5: Cole appears for the first time
//          Bit 6: Zelda's guard is out of the way
//          Bit 7: Cole has let the guard pass and is at the ceremony
function hasSnowRailmap() => bit0(0x264cf6)
function hasOceanRailmap() => bit1(0x264cf6)
function hasFireRailmap() => bit2(0x264cf6)

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

// $2d3260: Whistles performed for a pod of dolphins (Ocean Realm only).
//          Loops back to 0 when enough whistles have been made to get a heart from them. (dynamic?)
function whistlesMadeForDolphins() => byte(0x2d3260)

// $2d35f0: Number of times a Squiddy is struck with the cannon.
//          Resets to 0 whenever 8 strikes are reached and increments the Squiddy counter by 1.
function squiddyStrikes() => byte(0x2d35f0)

// $2d35f1: Squiddy counter. Increments by 1 whenever a Squiddy splits off from the primary
//          and decreases by 1 whenever a Squiddy despawns.
function squiddyInstances() => byte(0x2d35f1)

// ACHIEVEMENTS

// "Extra Credit"
hyruleField = GetLocationByCode("ForestRealm")
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

// Ocean Mapper
achievement(title = "Ocean Mapper",
    description = "Obtain the Ocean Railmap.", points = 3,
    trigger = WasBitflagSetInGame(hasOceanRailmap())
        && IsInLocationWithCode("TowerDungeon")
)

// Fire Mapper
achievement(title = "Fire Mapper",
    description = "Obtain the Fire Railmap.", points = 3,
    trigger = WasBitflagSetInGame(hasFireRailmap())
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

// "Duet with the Lutenist"
achievement(title = "Duet with the Lutenist",
    description = "Complete your duet with Steem and open the path to the Snow Temple.",
    points = 3,
    trigger = WasBitflagSetInGame(completedDuetWithSteem())
        && IsInLocationWithCode("SnowSanctuary")
)

// "Duet with the Flautist"
achievement(title = "Duet with the Flautist",
    description = "Complete your duet with Carben and open the path to the Ocean Temple.",
    points = 3,
    trigger = WasBitflagSetInGame(completedDuetWithCarben())
        && IsInLocationWithCode("OceanSanctuary")
)

// "Duet with the Timpanist"
achievement(title = "Duet with the Timpanist",
    description = "Complete your duet with Embrose and open the path to the Fire Temple.",
    points = 3,
    trigger = WasBitflagSetInGame(completedDuetWithEmbrose())
        && IsInLocationWithCode("FireSanctuary")
)

// "Shoo, Fly, Shoo"
function IsStagnoxDying() => byte(0x31f538) == 0x15

function stagnoxHP() => byte(0x31f534)

forestTemple = GetLocationByCode("ForestTemple")
gauntlet1 = GetLocationByCode("Gauntlet1")

achievement(title = "Shoo, Fly, Shoo",
    description = "Defeat Stagnox without taking damage.", points = 10,
    trigger = IsStagnoxDying()
        && never(Delta(currentHP()) > currentHP())
        && (
            // Forest Temple
            never(!IsInLocationWithCode("Stagnox")) && unless(IsInLocationWithCode("GauntletStagnox"))
            && once(IsInLocationWithCode("Stagnox") && Delta(currentLocation()) == forestTemple["id"])
            
            // Take 'Em All On!
            || never(!IsInLocationWithCode("GauntletStagnox")) && unless(IsInLocationWithCode("Stagnox"))
            && once(IsInLocationWithCode("GauntletStagnox") && Delta(currentLocation()) == gauntlet1["id"])
        )
)

// "Whispers from the Forest"
achievement(title = "Whispers from the Forest", points = 5,
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

for cheevo in rabbitTypeAchievements
{
    rabbitRescued = always_false()
    resetalt = always_false()
    
    for i in range(0, 9)
    {
        rabbitRescued = rabbitRescued || once(RabbitRescueStateByType(i, cheevo["type"]) == 1)
        
        // Like the above, we want to reset the hit counts each time a rabbit is rescued
        // to refresh the hitcount state that represents each individual rabbit being rescued.
        resetalt = resetalt || never(Delta(RabbitRescueStateByType(i, cheevo["type"])) != RabbitRescueStateByType(i, cheevo["type"]))
            && unless(isLoadingSaveFile())
    }
    
    // Also like the above, we also don't want to do anything if no rabbit is rescued on a frame
    // as a save protection measure. A two-frame target is used for the same reason as the above, as well.
    unlessRabbitStatesAreIdle = unless(repeated(2, always_true()))
    
    achievement(title = cheevo["name"], description = cheevo["description"], points = 10,
        trigger = IsInGame()
            && measured(repeated(10, rabbitRescued)) && unlessRabbitStatesAreIdle
            && resetalt
    )
}

// "Quick Draw"
function IsFraazRezzing() => byte(0x324f78) == 0x17
function IsFraazGoingToPhase3() => byte(0x324f78) == 0x5
function IsFraazDying() => byte(0x324f78) == 0x3

snowTemple = GetLocationByCode("SnowTemple")
achievement(title = "Quick Draw",
    description = "Proceed to Fraaz's third phase before either Fraaz Jr. has a chance to resurrect the other or run away.",
    points = 3,
    trigger = once(IsInLocationWithCode("Fraaz") && Delta(currentLocation()) == snowTemple["id"])
        && IsFraazGoingToPhase3() && never(IsFraazRezzing()) && never(!IsInLocationWithCode("Fraaz"))
)

// "Howls from the Tundra"
achievement(title = "Howls from the Tundra", points = 5,
    description = "Clear the Snow Temple.",
    trigger = WasBitflagSetInGame(snowTempleClear())
        && IsInLocationWithCode("Fraaz")
)

// "Third Intention"
function StartedTrainingGame() => trainingGameState() == 0x1
function GotHitInTrainingGame() => Delta(trainingGameHitsRemaining()) > trainingGameHitsRemaining()
function TrainingGameIsOver() => trainingGameState() == 0x4
function ScoreIncreasedInTrainingGame()
{
    return Delta(trainingGameScore()) < trainingGameScore()
}

achievement(title = "Third Intention", points = 10,
    description = "Score a total of 90 single hits in a row during training without getting hit yourself.",
    trigger = never(StartedTrainingGame()) && never(GotHitInTrainingGame())
        && repeated(90, ScoreIncreasedInTrainingGame()) && never(!IsInLocationWithCode("Castle"))
        && never(TrainingGameIsOver())
)

leaderboard(title = "Training with the Royal Guard",
    description = "Get as many strikes in as you can before you yourself get hit three times.",
    start = IsInLocationWithCode("Castle") && StartedTrainingGame(),
    cancel = !IsInLocationWithCode("Castle"),
    submit = TrainingGameIsOver(),
    value = trainingGameScore()
)

// "The Price of Loyalty"
achievement(title = "The Price of Loyalty",
    description = "Get your Beedle Club Card in the mail.", points = 1,
    trigger = WasBitflagSetInGame(clubCardObtained()) && IsInGame()
)

// "Buy Nine, Get One Free"
achievement(title = "Buy Nine, Get One Free",
    description = "Get your Silver Card in the mail.", points = 3,
    trigger = WasBitflagSetInGame(silverCardObtained()) && IsInGame()
)

// "Persistent Patron"
achievement(title = "Persistent Patron",
    description = "Get your Gold Card in the mail.", points = 5,
    trigger = WasBitflagSetInGame(goldCardObtained()) && IsInGame()
)

// "Top Investor"
achievement(title = "Top Investor",
    description = "Get your Platinum Card in the mail.", points = 10,
    trigger = WasBitflagSetInGame(platinumCardObtained()) && IsInGame()
)

// "Chairman of the Board"
achievement(title = "Chairman of the Board",
    description = "Get your Diamond Card in the mail.", points = 25,
    trigger = WasBitflagSetInGame(diamondCardObtained()) && IsInGame()
)

// Both of these achievements depend on values that are dynamic in nature, especially when train makeup changes.
// To properly implement these, pointers for these values will need to be found first, which
// may not be possible with the current implementation of DeSmuME.
if (1 == 0)
{
    // "Aquatic Acquaintances"
    achievement(title = "Aquatic Acquaintances", description = "Befriend a pod of dolphins and have them put on a show.",
        points = 1,
        trigger = IsInLocationWithCode("Ocean")
            && Delta(whistlesMadeForDolphins()) == 3 && whistlesMadeForDolphins() == 0
    )
    
    // "Keepie-Uppie"
    achievement(title = "Keepie-Uppie",
        description = "Spawn two Squiddies from a main one and then juggle the latter four times before any Squiddy touches the ground.",
        points = 5,
        trigger = IsInLocationWithCode("Ocean") && squiddyInstances() == 3 && squiddyStrikes() >= 4
    )
}

// "Whip It Good"
oceanTemple = GetLocationByCode("OceanTemple")
timeLimit = 165
frameLimit = SecondsToFrames(timeLimit)
function phytopsState() => byte(0x31fdb8)
function PhytopsIsNotFighting() => phytopsState() == 0x0 || phytopsState() == 0x2 || phytopsState() == 0x3
function PhytopsIsDying() => phytopsState() == 0xe

achievement(title = "Whip It Good",
    description = "Defeat Phytops within " + SecondsToFormat(timeLimit) + ".", points = 5,
    trigger = PhytopsIsDying()
        && never(repeated(frameLimit, frameIncremented())) && unless(IsPaused())
        && unless(PhytopsIsNotFighting()) && never(!IsInLocationWithCode("Phytops"))
        && unless(IsTransitioningInBlack())
        && (
            always_false() || once(Delta(currentLocation()) == oceanTemple["id"] && IsInLocationWithCode("Phytops"))
            // We're putting the checkpoint target in an alt to make sure the pauses
            // in the core group don't also pause the hit target from being reached.
        )
)

// "Roars from the Sea"
achievement(title = "Roars from the Sea", points = 5,
    description = "Clear the Ocean Temple.",
    trigger = WasBitflagSetInGame(oceanTempleClear())
        && IsInLocationWithCode("Phytops")
)

// "Watch out for That Tree!"
function WhipRaceCountingDown() => whipRaceState() == 0x1
function StartedWhipRace() => whipRaceState() == 0x2
function WhipRaceJustEnded() => whipRaceState() == 0x3
function WhipRaceIsOver() => whipRaceState() == 0x4
function WhipRaceVictory() => reasonWhipRaceEnded() != 0x1 && reasonWhipRaceEnded() != 0x2
timeLimit = 65
framesPerSecond = 30 // The system timer uses 60fps, but Spirit Tracks calculates time assuming 30fps instead, for some reason.
achievement(title = "Watch out for That Tree!", points = 25,
    description = "Finish the whip race within " + SecondsToFormat(timeLimit) + ".",
    trigger = IsInLocationWithCode("WhittletonWilds") && whipRaceTime() <= timeLimit * framesPerSecond
        && once(WhipRaceJustEnded()) && WhipRaceIsOver() && never(StartedWhipRace())
        && WhipRaceVictory()
)

leaderboard(title = "Whip Race",
    description = "Swing to the end of the course in the fastest time you can!",
    start = IsInLocationWithCode("WhittletonWilds") && WhipRaceCountingDown(),
    cancel = !WhipRaceVictory() && WhipRaceIsOver(),
    submit = WhipRaceJustEnded() && WhipRaceVictory(),
    value = whipRaceTime() * 2 // Multiply it by 2 to convert the value to its 60fps equivalent so it properly calculates on the RA leaderboard.
)

// Force Gem achievements
forceGemAddresses = [
    { "addr": 0x264d01, "bit": 0 },
    { "addr": 0x264d01, "bit": 1 },
    { "addr": 0x264d01, "bit": 2 },
    { "addr": 0x264d01, "bit": 4 },
    { "addr": 0x264d01, "bit": 5 },
    { "addr": 0x264d01, "bit": 6 },
    { "addr": 0x264d01, "bit": 7 },
    { "addr": 0x264d02, "bit": 0 },
    { "addr": 0x264d02, "bit": 1 },
    { "addr": 0x264d02, "bit": 2 },
    { "addr": 0x264d02, "bit": 3 },
    { "addr": 0x264d02, "bit": 4 },
    { "addr": 0x264d02, "bit": 6 },
    { "addr": 0x264d02, "bit": 7 },
    { "addr": 0x264d03, "bit": 0 },
    { "addr": 0x264d03, "bit": 2 },
    { "addr": 0x264d03, "bit": 3 },
    { "addr": 0x264d08, "bit": 6 }
]

forceGemAchievements = [
    { "name": "Help Wanted", "description": "", "threshold": 5, "points": 3 },
    { "name": "The Gift of Charity", "description": "", "threshold": 10, "points": 10 },
    { "name": "Premier Engineer", "description": "Collect all Force Gems and completely restore the Spirit Tracks.", "threshold": 20, "points": 25 }
]

for cheevo in forceGemAchievements
{
    forceGemObtained = always_false()
    resetalt = always_false()
    description = cheevo["description"]
    
    if (description == "")
    {
        description = "Collect " + cheevo["threshold"] + " Force Gems."
    }
    
    for addr in forceGemAddresses
    {
        relevantBit = bit(addr["bit"], addr["addr"])
        forceGemObtained = forceGemObtained || once(relevantBit == 1)
        
        // Like the above, we want to reset the hit counts each time a rabbit is rescued
        // to refresh the hitcount state that represents each individual rabbit being rescued.
        resetalt = resetalt || never(Delta(relevantBit) != relevantBit)
            && unless(isLoadingSaveFile())
    }
    
    // Also like the above, we also don't want to do anything if no rabbit is rescued on a frame
    // as a save protection measure. A two-frame target is used for the same reason as the above, as well.
    unlessRabbitStatesAreIdle = unless(repeated(2, always_true()))
    
    achievement(title = cheevo["name"], description = description, points = cheevo["points"],
        trigger = IsInGame()
            && measured(repeated(cheevo["threshold"], forceGemObtained)) && unlessRabbitStatesAreIdle
            && resetalt
    )
}

// Take 'Em All On!
function GauntletCountingDown() => gauntletState() == 0x1
function StartedGauntlet() => gauntletState() == 0x2
function ForfeitedGauntlet() => gauntletState() == 0x4

for level in range(1, 2)
{
    leaderboard(title = "Take 'Em All On! - Level " + level,
        description = "Reach the end of Take 'Em All On! Level " + level + " and defeat the boss as quickly as you can!",
        start = IsInLocationWithCode("Gauntlet" + level) && GauntletCountingDown(),
        cancel = ForfeitedGauntlet(),
        submit = Delta(gauntletState()) == 0x2 && gauntletState() == 0x0,
        value = gauntletTime() * 2 // Multiply it by 2 to convert the value to its 60fps equivalent so it properly calculates on the RA leaderboard.
    ) 
}

// "Treasure Hunter"
totalTreasureTypes = 16
treasureRegistered = always_false()
resetalt = always_false()

for i in range(0, totalTreasureTypes - 1)
{
    offset = demonFossilCountAddr + i * 2
    treasureRegistered = treasureRegistered || once(word(offset) != 0xffff)
    
    // We want to reset the hit counts each time a treasure is registered in order to
    // reflect the state of registrations in memory.
    resetalt = resetalt || never(Delta(word(offset)) != word(offset))
        && unless(isLoadingSaveFile())
}

// We also don't want to do anything if *none* of the treasure registrations change. This way,
// simply loading a save doesn't trigger them immediately. A two-frame target is used
// to give the achievement time to register a new change on the frame immediately
// following a reset.
unlessTreasureStatesAreIdle = unless(repeated(2, always_true()))

achievement(title = "Treasure Hunter", description = "Obtain one of every type of treasure.", points = 5,
    trigger = IsInGame()
        && repeated(totalTreasureTypes, treasureRegistered) && unlessTreasureStatesAreIdle
        && resetalt
)

// "Plus Shipping and Handling"
function freightCount() => word(0x264bbc)
function firstLavaPlumeCooled() => bit4(0x264d15)
function freightType() => byte(0x264bb8)
iceMax = 20
iceLossLimit = 7
achievement(title = "Plus Shipping and Handling", points = 5,
    description = "Deliver your first batch of Mega Ice to Goron Village from Wellspring Station without losing more than "
                + iceLossLimit + " lots of ice.",
    trigger = once(WasInLocationWithCode("Wellspring") && IsInLocationWithCode("SnowRealm") && freightCount() == iceMax)
        && IsInLocationWithCode("Goron") && firstLavaPlumeCooled() == 0 && never(freightCount() < iceMax - iceLossLimit)
        && freightType() == 0
)

// "Kiss and Cry"
achievement(title = "Kiss and Cry", points = 10,
    description = "Complete the Champion Course at Slippery Station and take the treasure.",
    trigger = IsInGame() && WasBitflagSetInGame(openedChampionChest())
)

// "Be Efficient"
function IsCragmaDying() => byte(0x3222c8) == 0xc
arrowLimit = 20

achievement(title = "Be Efficient", points = 25,
    description = "Defeat Cragma without using any more than " + arrowLimit + " arrows.",
    trigger = once(WasInLocationWithCode("FireTemple") && IsInLocationWithCode("Cragma"))
        && never(!IsInLocationWithCode("Cragma")) && IsCragmaDying() && never(repeated(arrowLimit + 1, Delta(arrows()) > arrows()))
)

// "Rumbles from the Volcano"
achievement(title = "Rumbles from the Volcano", points = 5,
    description = "Clear the Fire Temple.",
    trigger = WasBitflagSetInGame(fireTempleClear())
        && IsInLocationWithCode("Cragma")
)

// "A Swift Dispatching"
function byrneState() => byte(0x33f378)
function IsByrneDying() => byrneState() == 0x21
timeLimit = 108
transitionFrames = 50 // We need to take into account transition time between when the boss room loads and the cutscene starts.
achievement(title = "A Swift Dispatching", points = 10,
    description = "Defeat Byrne within " + SecondsToFormat(timeLimit) + ".",
    trigger = once(WasInLocationWithCode("TowerDungeon") && IsInLocationWithCode("Byrne"))
        && IsByrneDying()
        && never(repeated(SecondsToFrames(timeLimit) + transitionFrames, Delta(framesCounter()) != framesCounter()))
        && never(!IsInLocationWithCode("Byrne")) && unless(byrneState() == 0)
        && unless(IsPaused())
)

// "Fourteen High Tons"
targetScore = 2100
function goronTargetRangeState() => byte(0x178520)
function goronTargetRangeScore() => word(0x178534)
function IsGoronTargetRangeGameComplete() => goronTargetRangeState() == 0x5
function IsGoronTargetRangeCountingDown() => goronTargetRangeState() == 0x3
function IsGoronTargetRangeInProgress() => goronTargetRangeState() == 0x4
function IsGoronTargetRangeOver() => goronTargetRangeState() == 0x6
achievement(title = "Fourteen High Tons", points = 10,
    description = "Get a score of " + targetScore + " or higher at the Goron Target Range.",
    trigger = once(IsInLocationWithCode("TargetRangeGame") && WasInLocationWithCode("TargetRange"))
        && goronTargetRangeScore() >= targetScore
        && IsGoronTargetRangeGameComplete()
        && never(!IsInLocationWithCode("TargetRangeGame"))
)

leaderboard(title = "Goron Target Range",
    description = "Get the highest score you can!",
    start = IsInLocationWithCode("TargetRangeGame") && IsGoronTargetRangeCountingDown(),
    cancel = once(Delta(goronTargetRangeState()) == 0x4 && IsGoronTargetRangeOver()) && never(IsGoronTargetRangeCountingDown()),
    submit = once(Delta(goronTargetRangeState()) == 0x4 && IsGoronTargetRangeGameComplete()) && never(IsGoronTargetRangeCountingDown()),
    value = goronTargetRangeScore()
)

// "Sharpshooter"
comboTarget = 25
function pirateHideoutComboLength() => byte(0x16422a)
function pirateHideoutMultiplier() => byte(0x164228)
achievement(title = "Sharpshooter", points = 10,
    description = "Get a combo of " + comboTarget + " or more in the Pirate Hideout minigame.",
    trigger = repeated(comboTarget, Delta(pirateHideoutComboLength()) != pirateHideoutComboLength())
        && never(Delta(pirateHideoutMultiplier()) > pirateHideoutMultiplier())
        && never(!IsInLocationWithCode("PirateMinigame"))
)

// "Keep Both Eyes Open"
if (1 == 0)
{
 scoreTarget = 4200
function pirateHideoutIsCountingDown() => byte(0x163fe0) == 0x1
achievement(title = "Keep Both Eyes Open", points = 10,
    description = "Get a score of " + scoreTarget + " or more in the Pirate Hideout minigame.",
    trigger = IsInLocationWithCode("PirateMinigame")
    
)   
}

// RICH PRESENCE
function CurrentFloor() => byte(0x260008) + 1
function GetFloorlessLocationList()
{
    list = {}
    for i in locationInfo
    {
        location = locationInfo[i]
        if (location["isDungeon"] == 0)
        {
            list[location["id"]] = location["name"]
        }
    }
    
    return list
}

// Get any location with floors
for i in locationInfo
{
    location = locationInfo[i]
    if (location["isDungeon"] == 1)
    {
        floor = 0
        if (location["floorAddr"] == 0)
        {
            floor = CurrentFloor()
        }
        else // Sometimes, the generic floor value doesn't cut it. If we find an alternative, we can use that instead.
        {
            floor = byte(location["floorAddr"])
        }
        rich_presence_conditional_display(IsInLocationWithCode(location["code"]), "{0}, Floor {1}", location["name"],
            rich_presence_value("FloorNumber", floor)
        )
    }
}

rich_presence_display("{0}",
    rich_presence_lookup("Location", currentLocation(), GetFloorlessLocationList())
)

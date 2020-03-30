// Croc: Legend of the Gobbos
// #ID = 11399

// General utilities

// Alias for prev()
function Delta(addr)
{
    return prev(addr)
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

// $073AC0: (32-bit) System timer. Increments by one every frame.
function framesCounter() => dword(0x073AC0)

function frameIncremented() => prev(framesCounter()) != framesCounter()

function SecondsToFrames(seconds) => seconds * 60 // Assuming a 60 FPS framerate

// $0748EC: Game state:
//          
//          0x0 = Press Start screen
//          0x1 = Main Menu
//          0x2 = Initial load/Intro
//          0x3 = Demo Mode
//          0x4 = in-level
//          0x5 = on the World Map
//          0x7 = Credits
//          0x8 = Options Menu
//          0x9 = Load Menu
//          0xb = Save Menu
//          0xc = Level Password screen
//          0xd = Password Input screen
//          0xe = Game Over
function gameState() => byte(0x0748EC)

function IsInLevel() => gameState() == 0x4

function IsOnWorldMap() => gameState() == 0x5

function IsInCredits() => gameState() == 0x7

function PasswordWasUsed() => once(prior(gameState()) == 0xd && IsOnWorldMap())

function JustLoadedFromSave() => prior(gameState()) == 0x9 && IsOnWorldMap()

// $0748e0: 0x0 = Normal credits
//          0x1 = Credits for Secret Sentinel
function creditsType() => byte(0x0748e0)

// $074904: Pause state:
//          
//          0x0 = not paused
//          >0x0 = paused
function pauseState() => byte(0x074904)

function IsPaused() => pauseState() > 0

// $074964: Crystals collected in the current level
function currentLevelCrystals() => byte(0x074964)

// $07496C: Gobbos saved in the current level
function currentLevelGobbos() => byte(0x07496C)

// $074AC8: Colored Gems Stored Here during Level.
//          
//          Red Gem 0x01
//          Purple Gem 0x10
//          Blue Gem 0x04
//          Green Gem 0x02
//          Yellow Gem 0x08
//          
//          All Door Gems 0x1f
function currentLevelColoredCrystals() => byte(0x074AC8)

// $074ACC: 0x1 = Level Complete window active
function IsLevelComplete() => byte(0x074ACC) == 0x1

// $074E68: Gobbos saved in current level (final results; for display only)
function currentLevelGobbosResults() => byte(0x074E68)

// $074E78: Display flag for Level Complete screen:
//          
//          0x0 = show Gobbo count
//          0x1 = show puzzle count
function levelCompleteType() => byte(0x074E78)

// $074F70: 0x1 = freezes screen rendering in-level
//          
//          Is set to 0x1 when a level is initially loading.
function IsLevelLoading() => byte(0x074F70) == 0x1

// $074FDC: Lives Count (Value = Amount + 1)
function currentLives() => byte(0x074FDC)

// $0751D4: Selected level on the World Map
function selectedLevel() => byte(0x0751D4)

function IsInLevelWithId(levelId) => selectedLevel() == levelId && IsInLevel()

function IsLevelWithIdComplete(levelId) => IsInLevelWithId(levelId) && IsLevelComplete()

function LevelHasLoadedAndIdHasNotChanged() => once(IsLevelLoading()) && never(Delta(selectedLevel()) != selectedLevel())

function IsLevelCheckpointValid(levelId) => IsInLevelWithId(levelId) && once(IsLevelLoading())

levelCodesToLevelInfo = {
    "1-1": { "id": 0x0, "name": "And So the Adventure Begins", "timeLimit": 39, "hasGobbos": 1, "difficultyBonus": 0 },
    "1-2": { "id": 0x1, "name": "Underground Overground", "timeLimit": 41, "hasGobbos": 1, "difficultyBonus": 0 },
    "1-3": { "id": 0x2, "name": "Shoutin' Lava Lava Lava", "timeLimit": 48, "hasGobbos": 1, "difficultyBonus": 0 },
    "1-B1": { "id": 0x3, "name": "Lair of the Feeble", "timeLimit": 0, "hasGobbos": 0, "difficultyBonus": 0 },
    "1-S1": { "id": 0x4, "name": "The Curvy Caverns", "timeLimit": 84, "hasGobbos": 0, "difficultyBonus": 0 },
    "1-4": { "id": 0x5, "name": "The Tumbling Dantini", "timeLimit": 52, "hasGobbos": 1, "difficultyBonus": 0 },
    "1-5": { "id": 0x6, "name": "Cave Fear", "timeLimit": 45, "hasGobbos": 1, "difficultyBonus": 0 },
    "1-6": { "id": 0x7, "name": "Darkness Descends", "timeLimit": 66, "hasGobbos": 1, "difficultyBonus": 0 },
    "1-B2": { "id": 0x8, "name": "Fight Night with Flibby", "timeLimit": 0, "hasGobbos": 0, "difficultyBonus": 0 },
    "1-S2": { "id": 0x9, "name": "The Twisty Tunnels", "timeLimit": 65, "hasGobbos": 0, "difficultyBonus": 0 },
    "2-1": { "id": 0xa, "name": "The Ice of Life", "timeLimit": 66, "hasGobbos": 1, "difficultyBonus": 0 },
    "2-2": { "id": 0xb, "name": "Be Wheely Careful", "timeLimit": 83, "hasGobbos": 1, "difficultyBonus": 0 },
    "2-3": { "id": 0xc, "name": "Riot Brrrrr", "timeLimit": 92, "hasGobbos": 1, "difficultyBonus": 0 },
    "2-B1": { "id": 0xd, "name": "Chumly's Snow Den", "timeLimit": 0, "hasGobbos": 0, "difficultyBonus": 0 },
    "2-S1": { "id": 0xe, "name": "Clouds of Ice", "timeLimit": 83, "hasGobbos": 0, "difficultyBonus": 0 },
    "2-4": { "id": 0xf, "name": "I Snow Him So Well", "timeLimit": 122, "hasGobbos": 1, "difficultyBonus": 0 },
    "2-5": { "id": 0x10, "name": "Say No Snow", "timeLimit": 104, "hasGobbos": 1, "difficultyBonus": 0 },
    "2-6": { "id": 0x11, "name": "License to Chill", "timeLimit": 82, "hasGobbos": 1, "difficultyBonus": 0 },
    "2-B2": { "id": 0x12, "name": "Demon Itsy's Ice Palace", "timeLimit": 0, "hasGobbos": 0, "difficultyBonus": 0 },
    "2-S2": { "id": 0x13, "name": "Ice Bridge to Eternity", "timeLimit": 91, "hasGobbos": 0, "difficultyBonus": 0 },
    "3-1": { "id": 0x14, "name": "Lights, Camel, Action!", "timeLimit": 74, "hasGobbos": 1, "difficultyBonus": 0 },
    "3-2": { "id": 0x15, "name": "Mud Pit Mania", "timeLimit": 108, "hasGobbos": 1, "difficultyBonus": 0 },
    "3-3": { "id": 0x16, "name": "Goin' Underground", "timeLimit": 142, "hasGobbos": 1, "difficultyBonus": 0 },
    "3-B1": { "id": 0x17, "name": "The Deadly Tank of Neptuna", "timeLimit": 0, "hasGobbos": 0, "difficultyBonus": 0 },
    "3-S1": { "id": 0x18, "name": "Arabian Heights", "timeLimit": 123, "hasGobbos": 0, "difficultyBonus": 1 },
    "3-4": { "id": 0x19, "name": "Sand and Freedom", "timeLimit": 203, "hasGobbos": 1, "difficultyBonus": 1 },
    "3-5": { "id": 0x1a, "name": "Leap of Faith", "timeLimit": 199, "hasGobbos": 1, "difficultyBonus": 1 },
    "3-6": { "id": 0x1b, "name": "Life's a Beach", "timeLimit": 133, "hasGobbos": 1, "difficultyBonus": 1 },
    "3-B2": { "id": 0x1c, "name": "Cactus Jack's Ranch", "timeLimit": 0, "hasGobbos": 0, "difficultyBonus": 0 },
    "3-S2": { "id": 0x1d, "name": "Defeato Burrito", "timeLimit": 116, "hasGobbos": 0, "difficultyBonus": 0 },
    "4-1": { "id": 0x1e, "name": "The Tower of Power", "timeLimit": 200, "hasGobbos": 1, "difficultyBonus": 1 },
    "4-2": { "id": 0x1f, "name": "Hassle in the Castle", "timeLimit": 153, "hasGobbos": 1, "difficultyBonus": 0 },
    "4-3": { "id": 0x20, "name": "Dungeon of Defright", "timeLimit": 89, "hasGobbos": 1, "difficultyBonus": 0 },
    "4-B1": { "id": 0x21, "name": "Fosley's Freaky Donut", "timeLimit": 0, "hasGobbos": 0, "difficultyBonus": 0 },
    "4-S1": { "id": 0x22, "name": "Smash and See", "timeLimit": 175, "hasGobbos": 0, "difficultyBonus": 0 },
    "4-4": { "id": 0x23, "name": "Ballistic Meg's Fairway", "timeLimit": 178, "hasGobbos": 1, "difficultyBonus": 0 },
    "4-5": { "id": 0x24, "name": "Swipe Swiftly's Wicked Ride", "timeLimit": 180, "hasGobbos": 1, "difficultyBonus": 0 },
    "4-6": { "id": 0x25, "name": "Panic at Platform Pete's Lair", "timeLimit": 214, "hasGobbos": 1, "difficultyBonus": 0 },
    "4-B2": { "id": 0x26, "name": "Baron Dante's Funky Inferno", "timeLimit": 0, "hasGobbos": 0, "difficultyBonus": 0 },
    "4-S2": { "id": 0x27, "name": "Jailhouse Croc", "timeLimit": 98, "hasGobbos": 0, "difficultyBonus": 0 },
    "5-1": { "id": 0x28, "name": "And So the Adventure Returns", "timeLimit": 118, "hasGobbos": 0, "difficultyBonus": 1 },
    "5-2": { "id": 0x29, "name": "Diet Brrrrr", "timeLimit": 126, "hasGobbos": 0, "difficultyBonus": 1 },
    "5-3": { "id": 0x2a, "name": "Trial on the Nile", "timeLimit": 163, "hasGobbos": 0, "difficultyBonus": 2 },
    "5-4": { "id": 0x2b, "name": "Crox Interactive", "timeLimit": 119, "hasGobbos": 0, "difficultyBonus": 0 },
    "5-B": { "id": 0x2c, "name": "Secret Sentinel", "timeLimit": 0, "hasGobbos": 0, "difficultyBonus": 0 },
}

function GetLevelCodeFromId(levelId)
{
    for code in levelCodesToLevelInfo
    {
        if (levelCodesToLevelInfo[code] == levelId)
        {
            return code
        }
    }
}

// $075210: Saved Gobbo Total (Updates after Level Completion)
function totalGobbosRescued() => byte(0x075210)

// $07C0A8: Appears to flip between 0 and 1 after each step the player takes.
function stepFlipper() => byte(0x07C0A8)

// $07C0B6: Appears to increment every time the player lands
function timesLanded() => byte(0x07C0B6)

// $07C22E: Blinking time remaining after taking damage (32-bit)
function invincibilityTimeRemaining() => word(0x07c22e)

// $07C246: Jumping state:
//          
//          0x0 = grounded/stomping
//          0x1 = jumping
function isJumping() => byte(0x07C246)

// $07C24A: Stomp state (16-bit):
//          
//          0x1 = wind up
//          0x2-0x10 = stomping
function isStomping() => word(0x07C24A)

// Speed Demon! Achievements and Leaderboards

function GetScore(time, difficultyBonus)
{
    stage = 1
    if (time >= 60 && time < 90)
    {
        stage = 2
    }
    else if (time >= 90)
    {
        stage = 3
    }
    
    stage = stage + difficultyBonus
    
    if (stage == 1)
    {
        return 3
    }
    else if (stage == 2)
    {
        return 5
    }
    else if (stage > 2 && stage < 5)
    {
        return 10
    }
    else if (stage >= 5)
    {
        return 25
    }
}

for levelCode in levelCodesToLevelInfo
{
    levelId = levelCodesToLevelInfo[levelCode]["id"]
    timeLimit = levelCodesToLevelInfo[levelCode]["timeLimit"]
    levelName = levelCodesToLevelInfo[levelCode]["name"]
    difficultyBonus = levelCodesToLevelInfo[levelCode]["difficultyBonus"]
    isLevelComplete = IsLevelWithIdComplete(levelId)
    frameLimit = SecondsToFrames(timeLimit)
    
    // Only compile the achievements and leaderboards if there is an actual time limit greater than zero.
    if (timeLimit > 0)
    {
        achievement(title = "Speed Demon! (" + levelCode + ")",
            description = "Complete \"" + levelName + "\" within " + SecondsToFormat(timeLimit) + ".",
            points = GetScore(timeLimit, difficultyBonus), trigger =
                isLevelComplete && IsLevelCheckpointValid(levelId) && never(selectedLevel() != levelId) // Core
                && (
                always_false() // Alt 1
    
                || never(repeated(frameLimit, frameIncremented())) // Alt 2
                    && never(!IsInLevel()) && unless(IsPaused())
            ))
        
        leaderboard(title = "Time Trial: " + levelCode + " - " + levelCodesToLevelInfo[levelCode]["name"],
            description = "Ring the gong in the fastest time you can!",
            start = IsLevelCheckpointValid(levelId) && IsInLevel() && never(selectedLevel() != Delta(selectedLevel())),
            cancel = !IsInLevel(),
            submit = isLevelComplete && IsLevelCheckpointValid(levelId),
            value = measured(frameIncremented()),
            format = "FRAMES")
    }
}

// Rescuer Achievements

// $0x07bf88: 1-1 Gobbos rescued
function gobbosRescuedIn1_1Addr() => 0x07bf88

// Keys correspond to the world's number.
worldsToGobboLevels = {
    1: [ "1-1", "1-2", "1-3", "1-4", "1-5", "1-6" ],
    2: [ "2-1", "2-2", "2-3", "2-4", "2-5", "2-6" ],
    3: [ "3-1", "3-2", "3-3", "3-4", "3-5", "3-6" ],
    4: [ "4-1", "4-2", "4-3", "4-4", "4-5", "4-6" ]
}

gobboAchievementThresholds = [
    { "name": "Rookie Rescuer", "threshold": 6, "description": "", "points": 1 },
    { "name": "Trainee Rescuer", "threshold": 18, "description": "", "points": 3 },
    { "name": "Regular Rescuer", "threshold": 36, "description": "", "points": 5 },
    { "name": "Veteran Rescuer", "threshold": 72, "description": "", "points": 10 },
    { "name": "Legendary Rescuer", "threshold": 144, "description": "Rescue all Gobbos.", "points": 25 }
]

function GobbosRescuedHighScoreInLevel(levelCode)
{
    // Level 1-1's address is what we'll use to get the other levels' Gobbo scores' addresses.
    levelOffset = levelCodesToLevelInfo[levelCode]["id"] * 2
    return byte(gobbosRescuedIn1_1Addr() + levelOffset)
}

function GobbosRescuedHighScoreInWorldExceptForLevel(worldId, inLevelCode)
{
    total = 0
    for levelCode in worldsToGobboLevels[worldId]
    {
        if (levelCode != inLevelCode)
        {
            total = total + GobbosRescuedHighScoreInLevel(levelCode)
        }
    }
    return total
}

function TotalGobbosRescuedHighScoreExceptForLevel(levelCode)
{
    total = 0
    for worldId in worldsToGobboLevels
    {
        total = total + GobbosRescuedHighScoreInWorldExceptForLevel(worldId, levelCode)
    }
    return total
}

function HasGobboScoreChangedForLevel(levelCode)
{
    return once(Delta(GobbosRescuedHighScoreInLevel(levelCode)) != GobbosRescuedHighScoreInLevel(levelCode)) && IsInLevel()
}

for threshold in gobboAchievementThresholds
{
    description = threshold["description"]
    count = threshold["threshold"]
    alt = always_false()
    
    // We need to check if any level's current score will
    // increase after we leave the Level Complete screen.
    for levelCode in levelCodesToLevelInfo
    {
        if (levelCodesToLevelInfo[levelCode]["hasGobbos"] == 1)
        {
            alt = alt ||
                (TotalGobbosRescuedHighScoreExceptForLevel(levelCode) + currentLevelGobbosResults() >= count)
                && currentLevelGobbosResults() <= 6 && currentLevelGobbosResults() > GobbosRescuedHighScoreInLevel(levelCode)
        }   
    }
    
    if (description == "")
    {
        description = "Rescue " + count + " Gobbos."
    }
    
    achievement(title = threshold["name"], description = description, points = threshold["points"], trigger =
        IsLevelComplete() && unless(PasswordWasUsed()) && never(JustLoadedFromSave()) &&
        LevelHasLoadedAndIdHasNotChanged() && // Core
        (
            alt
        )
    )
}

worldIdToData = {
    1: "Forest Rescue",
    2: "Ice Rescue",
    3: "Desert Rescue",
    4: "Castle Rescue"
}

for worldId in worldIdToData
{
    alt = always_false()
    
    for levelCode in worldsToGobboLevels[worldId]
    {
        levelId = levelCodesToLevelInfo[levelCode]["id"]
        
        alt = alt ||
            (GobbosRescuedHighScoreInWorldExceptForLevel(worldId, levelCode) + currentLevelGobbosResults() <= 6) == 36
            && currentLevelGobbosResults() <= 6 && currentLevelGobbosResults() > GobbosRescuedHighScoreInLevel(levelCode)
    }
    
    achievement(title = worldIdToData[worldId], description = "Rescue all Gobbos in World " + worldId + ".",
        points = 10, trigger =
            IsLevelComplete() && unless(PasswordWasUsed()) && never(JustLoadedFromSave()) &&
            LevelHasLoadedAndIdHasNotChanged() && // Core
            (
                alt
            )
        )
}

// Puzzler Achievements
function DidCollectJigsawPieceInCurrentLevel() => levelCompleteType() == 0x1 && IsLevelComplete()

levelsWithJigsawPiecesToIndex = {
    "1-S1": 0,
    "1-S2": 1,
    "2-S1": 2,
    "2-S2": 3,
    "3-S1": 4,
    "3-S2": 5,
    "4-S1": 6,
    "4-S2": 7
}

// This will be our base. Each puzzle piece "boolean" is a dword,
// and so the offset for subsequent ones is 4.
function puzzlePieceIn1_S1CollectedAddr() => 0x07c3a8

function PuzzlePieceStatusInLevel(levelCode)
{
    return dword(puzzlePieceIn1_S1CollectedAddr() + 4 * levelsWithJigsawPiecesToIndex[levelCode])
}

masterPuzzlerCore = always_true()
masterPuzzlerAlt = always_false()

for levelCode in levelsWithJigsawPiecesToIndex
{
    levelId = levelCodesToLevelInfo[levelCode]["id"]

    achievement(title = "Puzzler (" + levelCode + ")", description = "Collect the Jigsaw Piece hidden in Level " + levelCode + ".",
        points = 5, trigger =
            DidCollectJigsawPieceInCurrentLevel() &&
            once(IsLevelCheckpointValid(levelId) && PuzzlePieceStatusInLevel(levelCode) == 0) &&
            PuzzlePieceStatusInLevel(levelCode) > 0 && never(!IsInLevel())
    )
    
    masterPuzzlerAlt = masterPuzzlerAlt ||
        once(Delta(PuzzlePieceStatusInLevel(levelCode)) != PuzzlePieceStatusInLevel(levelCode))
        && once(IsLevelCheckpointValid(levelId) && PuzzlePieceStatusInLevel(levelCode) == 0)
    
    masterPuzzlerCore = masterPuzzlerCore && PuzzlePieceStatusInLevel(levelCode) > 0 && never(!IsInLevel())
}

achievement(title = "Master Puzzler", description = "Collect all eight Jigsaw Pieces.", points = 10, trigger =
    masterPuzzlerCore && masterPuzzlerAlt
)


// POP GOES THE GOBBO
// $0x0862ea: Popping game score location
function poppingGameScore() => byte(0x0862ea)

achievement(title = "Pop Goes the Gobbo",
    description = "Get a perfect score in the Popping Game in Level 1-3, 2-6, or 4-3.",
    points = 10, trigger = 
        once(poppingGameScore() == 0) && poppingGameScore() == 32 && never(IsLevelLoading()) && // Core
        (
            IsInLevelWithId(levelCodesToLevelInfo["1-3"]["id"]) ||
            IsInLevelWithId(levelCodesToLevelInfo["2-6"]["id"]) ||
            IsInLevelWithId(levelCodesToLevelInfo["4-3"]["id"])
        )
)

// MR. PERFECT ACHIEVEMENTS

achievementInfo = {
    "1-B1": { "title": "Not So Feeble", "description": "Complete Level 1-B1 without taking damage.",
        "points": 3 },
    "1-B2": { "title": "You Can't See Me", "description": "Complete Level 1-B2 without taking damage.",
        "points": 5 },
    "2-B1": { "title": "I Think It's Gonna Be a Long, Long Time",
        "description": "Complete Level 2-B1 without taking damage.", "points": 1 },
    "2-B2":{ "title": "The Abominable Snow Goat", "description": "Complete Level 2-B2 without taking damage.", "points": 5 },
    "3-B1": { "title": "A Fish Called Neptuna", "description": "Complete Level 3-B1 without taking damage.",
        "points": 10 },
    "3-B2": { "title": "This Town Ain't Big Enough for the Two of Us", "description": "Complete Level 3-B2 without taking damage.",
        "points": 5 },
    "4-B1": { "title": "The Balloonatic", "description": "Complete Level 4-B1 without taking damage.",
        "points": 1 },
    "4-B2": { "title": "No Sorcery Required", "description": "Complete Level 4-B2 without taking damage.", "points": 25 },
    "5-B": { "title": "A Perfect Heist", "description": "Defeat Crystal Dante without taking damage.", "points": 5 }
}

function IsLevelCompleteWithoutTakingDamageOrLosingALife(levelId)
{
    return never(Delta(currentLevelCrystals()) > currentLevelCrystals()) && never(Delta(currentLives()) > currentLives())
        && IsLevelComplete() && never(!IsInLevel()) && once(IsLevelCheckpointValid(levelId))
}

for levelCode in achievementInfo
{
    info = achievementInfo[levelCode]
    achievement(title = info["title"], description = info["description"], points = info["points"],
        trigger =
            IsLevelCompleteWithoutTakingDamageOrLosingALife(levelCodesToLevelInfo[levelCode]["id"]) 
    )
}

achievement(title = "Savior of the Archipelago", description = "Defeat Baron Dante and save King Rufus.", points = 10,
    trigger =
        repeated(240, IsInCredits()) && creditsType() == 0 && never(!IsInCredits())
)

achievement(title = "The Crystalline Impostor", description = "Defeat Crystal Dante and attain 100% completion.", points = 25,
    trigger =
        repeated(240, IsInCredits()) && creditsType() == 1 && never(!IsInCredits())
)


// RICH PRESENCE
statesToNames = {
    0: "At the Title Screen",
    1: "At the Main Menu",
    2: "Watching the intro...",
    3: "Watching a demo...",
    4: "In level",
    5: "On the World Map",
    6: "Defeated...",
    7: "Watching the credits...",
    8: "In the Options Menu",
    9: "On the Load Screen",
    0xb: "On the Save Screen",
    0xc: "On the Level Password Screen",
    0xd: "Inputting a password...",
    0xe: "Continue?"
}

levelIdsToNames = {
    0x0: "1-1 - And So the Adventure Begins",
    0x1: "1-2 - Underground Overground",
    0x2: "1-3 - Shoutin’ Lava Lava Lava",
    0x3: "1-B1 - Lair of the Feeble",
    0x4: "1-S1 - The Curvy Caverns",
    0x5: "1-4 - The Tumbling Dantini",
    0x6: "1-5 - Cave Fear",
    0x7: "1-6 - Darkness Descends",
    0x8: "1-B2 - Fight Night with Flibby",
    0x9: "1-S2 - The Twisty Tunnels",
    0xa: "2-1 - The Ice of Life",
    0xb: "2-2 - Be Wheely Careful",
    0xc: "2-3 - Riot Brrrrr",
    0xd: "2-B1 - Chumly’s Snow Den",
    0xe: "2-S1 - Clouds of Ice",
    0xf: "2-4 - I Snow Him So Well",
    0x10: "2-5 - Say No Snow",
    0x11: "2-6 - License to Chill",
    0x12: "2-B2 - Demon Itsy’s Ice Palace",
    0x13: "2-S2 - Ice Bridge to Eternity",
    0x14: "3-1 - Lights, Camel, Action!",
    0x15: "3-2 - Mud Pit Mania",
    0x16: "3-3 - Goin’ Underground",
    0x17: "3-B1 - The Deadly Tank of Neptuna",
    0x18: "3-S1 - Arabian Heights",
    0x19: "3-4 - Sand and Freedom",
    0x1a: "3-5 - Leap of Faith",
    0x1b: "3-6 - Life’s a Beach",
    0x1c: "3-B2 - Cactus Jack’s Ranch",
    0x1d: "3-S2 - Defeato Burrito",
    0x1e: "4-1 - The Tower of Power",
    0x1f: "4-2 - Hassle in the Castle",
    0x20: "4-3 - Dungeon of Defright",
    0x21: "4-B1 - Fosley’s Freaky Donut",
    0x22: "4-S1 - Smash and See",
    0x23: "4-4 - Ballistic Meg’s Fairway",
    0x24: "4-5 - Swipe Swiftly’s Wicked Ride",
    0x25: "4-6 - Panic at Platform Pete’s Lair",
    0x26: "4-B2 - Baron Dante’s Funky Inferno",
    0x27: "4-S2 - Jailhouse Croc",
    0x28: "5-1 - And So the Adventure Returns",
    0x29: "5-2 - Diet Brrrrr",
    0x2a: "5-3 - Trial on the Nile",
    0x2b: "5-4 - Crox Interactive",
    0x2c: "5-B - Secret Sentinel",
}

rich_presence_display("{0}",
    rich_presence_lookup("State", gameState(), statesToNames)
)
rich_presence_conditional_display(IsLevelComplete(), "Viewing level results...")
rich_presence_conditional_display(gameState() == 4, "Running through Level {0}",
    rich_presence_lookup("Level", selectedLevel(), levelIdsToNames)
)


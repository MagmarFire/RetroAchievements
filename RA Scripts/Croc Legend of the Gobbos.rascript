// Croc: Legend of the Gobbos
// #ID = 11399

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
//          0x8 = Options Menu
//          0x9 = Load Menu
//          0xb = Save Menu
//          0xc = Level Password screen
//          0xd = Password Input screen
function gameState() => byte(0x0748EC)

function IsInLevel() => gameState() == 0x4

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

function DidCollectJigsawPieceInCurrentLevel() => levelCompleteType() == 0x1

// $074F70: 0x1 = freezes screen rendering in-level
//          
//          Is set to 0x1 when a level is initially loading.
function IsLevelLoading() => byte(0x074F70) == 0x1

// $074FDC: Lives Count (Value = Amount + 1)
function currentLives() => byte(0x074FDC) + 1

// $0751D4: Selected level on the World Map
function selectedLevel() => byte(0x0751D4)

function IsInLevelWithId(levelId) => selectedLevel() == levelId && IsInLevel()

function IsLevelWithIdComplete(levelId) => IsInLevelWithId(levelId) && IsLevelComplete()

levelCodesToLevelIds = {
    "1-1": 0,
    "1-2": 1,
    "1-3": 2,
    "1-B1": 3,
    "1-S1": 4
}

// $075210: Saved Gobbo Total (Updates after Level Completion)
function totalGobbosRescued() => byte(0x075210)

// $07C0A8: Appears to flip between 0 and 1 after each step the player takes.
function stepFlipper() => byte(0x07C0A8)

// $07C0B6: Appears to increment every time the player lands
function timesLanded() => byte(0x07C0B6)

// $07C22E: Blinking time remaining after taking damage (32-bit)
function invincibilityTimeRemaining() => dword(0x07C22E)

function IsRecoveringFromDamage() => invincibilityTimeRemaining() > 0

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

// Speed Demon! Achievements
levelsToTimeLimits = {
    "1-1": 39,
    "1-2": 41,
    "1-3": 48,
    //"1-B1": 85,
    "1-S1": 85
}

for levelCode in levelsToTimeLimits
{
    levelId = levelCodesToLevelIds[levelCode]
    timeLimit = levelsToTimeLimits[levelCode]
    isLevelComplete = IsLevelWithIdComplete(levelId)
    isLevelCheckpointValid = IsInLevelWithId(levelId) && once(IsLevelLoading())
    frameLimit = SecondsToFrames(levelsToTimeLimits[levelCode])
    
    achievement(title = "Speed Demon! (" + levelCode + ")", description = "Complete Level " + levelCode + " within " + timeLimit + " seconds.",
    points = 5, trigger =
        isLevelComplete && isLevelCheckpointValid // Core
        && (
        always_false() // Alt 1
    
        || never(repeated(frameLimit, frameIncremented())) && never(!IsInLevel()) && unless(IsPaused()) // Alt 2
    ))
}

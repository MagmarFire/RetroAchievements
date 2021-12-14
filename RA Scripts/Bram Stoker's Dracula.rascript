// Bram Stoker's Dracula
// #ID = 4175

// $03F2: [16-bit]
//        This is directly related to the game screens.
//        
//        0xae76=Sega logo
//        0xad7e=Sony logo
//        0xb10a=Presents
//        0xaf62=Bram Stoker's Dracula (with dark background)
//        0xb222=By
//        0xb036=Psygnosis Owl logo
//        0x0942=Game Titles
//        0x8212=Options Screen
function gameScreen() => word(0x0003F2)

// $0483: [8-bit]
//        Bitflag - Boss state
//        
//        bit0 (0=Alive , 1=Defeated)
function bossIsDefeated() => bit0(0x000483)

// $0972: Menu - In Game
//        0x03
//        Demo
//        0x00
function gameState() => byte(0x000972)

// $0974: Difficulty
//        Trainer =0x00
//        Normal =0x01
//        Hard =0x02
function difficulty() => byte(0x000974)

// $097C: [8-bit]
//        Game level select cheat. Activates after the player enters the right commands in the
//        control.
//        0=Off
//        1=ON
function levelSelectCheat() => word(0x00097C)

// $09AA: Chapters
//        0x00 = The Journey to Castle Dracula
//        0x02 = Harker's Escape from the Castle
//        0x05 = The Journey to Civilisation
//        0x09 = Hillingham Estate
//        0x0c = The Trail to Carffax Abbey
//        0x0f = The Final Battle -
//        Back to the castle
//        -------------------------------------------------------------------------
//        Stages
//        0x01 = The Entrance
//        0x03 = Inside the Castle
//        0x04 = Castle/Exit
//        0x06 = Garden/Forest
//        0x07 = Refugue
//        0x08 = Mountains of Transylvania
//        0x0a = Cemetery
//        0x0b = Catacomb
//        0x0d = Carffax Abbey
//        0x15 = The End
function chapter() => word(0x0009AA)

// $09CE: [16-bit]
//        Player position (X)
function playerXCoord() => word(0x0009CE)

// $0A6A: [8-bit]
//        Bitflags associated with the character state
//        
//        bit0 (1= Player is active, 0=Player is inactive)
//        bit1 (1=Player was hit, 0=Player's normal state)
function playerIsActive() => bit0(0x000A6A)

// $0A6A: [8-bit]
//        Bitflags associated with the character state
//        
//        bit0 (1= Player is active, 0=Player is inactive)
//        bit1 (1=Player was hit, 0=Player's normal state)
function playerIsHit() => bit1(0x000A6A)

// $0A94: [8-bit]
//        Player default weapon
//        
//        0x00 = Kris Sword
//        0x04 = Gladius
function defaultWeapon() => byte(0x000A94)

// $0AAE: Number Items
//        0x00 - No Items
//        0x09 - 9 Items
//        0x0a - 10 Items
function numberOfItems() => byte(0x000AAE)

function PlayerWasHitAfterDefeatingBrides() => once(playerXCoord() >= 3024 && playerXCoord() <= 3583 && playerIsHit() == 1)
function PlayerUsedSubweapon() => once(prev(numberOfItems()) > numberOfItems())
function PlayerIsOutsideBrideFight() => playerXCoord() < 0xbd0

achievement(
    title = "Leeches", description = "Defeat Dracula's Brides with 0 items, using only Gladius and without being hit.", points = 10,
    id = 172942, badge = "193320", published = "9/20/2021 2:55:02 AM", modified = "10/2/2021 12:45:49 AM",
    trigger = (playerXCoord() >= 3024 && playerXCoord() <= 3583 && bossIsDefeated() == 1) && 
              unless(PlayerWasHitAfterDefeatingBrides()) && unless(playerIsActive() == 0) && unless(chapter() != 6) && unless(levelSelectCheat() == 1) && 
              unless(PlayerUsedSubweapon()) && defaultWeapon() == 4 && difficulty() >= 1 && unless(gameState() == 0) &&
              (always_false() || never(gameScreen() == 33298) && never(PlayerIsOutsideBrideFight())) // Reset pauselocks
)

function PlayerIsOutsideOfGentlemanFight() => playerXCoord() < 0xcd0
achievement(
    title = "Independent Hunter", description = "Defeat Dracula Gentleman with 0 items, using only Gladius and without being hit.", points = 10,
    id = 172943, badge = "193321", published = "9/20/2021 2:55:03 AM", modified = "10/1/2021 10:45:07 PM",
    trigger = (playerXCoord() >= 3280 && playerXCoord() <= 3807 && bossIsDefeated() == 1) && 
              unless(once(playerXCoord() >= 3280 && playerXCoord() <= 3807 && playerIsHit() == 1)) && unless(playerIsActive() == 0) && unless(chapter() != 8) && unless(levelSelectCheat() == 1) && 
              unless(PlayerUsedSubweapon()) && defaultWeapon() == 4 && difficulty() >= 1 &&
              (always_false() || never(gameScreen() == 33298) && never(PlayerIsOutsideOfGentlemanFight())) // Reset pauselocks
)

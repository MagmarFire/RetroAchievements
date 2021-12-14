// Ninja Master's: Haou Ninou Chou
// #ID = 13799

// $6806: SCREEN ID [16-Bits]
//        
//        0x5776=How To Play/Demo
//        0xcfc6=Tittle Screen/Ending
//        0x0000=Select Character
//        0x4eba=Loading by fighting
//        0x3154=Fighting
function screenId() => word(0x006806)

// $C016: ARCADE PROGRESSION
function arcadeProgression() => byte(0x00C016)

// $C053: 1P - WIN FIGHT
function wonFight() => low4(0x00C053)

// $C13D: OPTION - AES (Difficulty)
//        
//        0x00=Lv1 (Easy)
//        0x03=Lv4 (Default)
//        0x07=Lv8 (Hard)
function difficulty() => byte(0x00C13D)

// $FD82: BIOS INDICATOR
//        
//        00=AES
//        02=MVS
function biosIndicator() => byte(0x00FD82)

// $FD91: SOFT DIP - MVS (Difficulty)
function softDipMvsDifficulty() => byte(0x00FD91)

// $FDB6: < 2P STATUS >
//        
//        00 = INATIVE
//        01 = ACTIVE
//        02 = CONTINUE
//        03 = GAME OVER
function player2Status() => byte(0x00FDB6)

// $FDB7: < 1P STATUS >
//        
//        00 = INATIVE
//        01 = ACTIVE
//        02 = CONTINUE
//        03 = GAME OVER
function player1Status() => byte(0x00FDB7)

function cpuCharacter() => byte(0xc085)

// $FE30: UNIBIOS 32-BITS
function unibios() => dword(0x00FE30)

achievement(
    title = "The Content and Pleasure of the Difficulty", description = "Finish the arcade on maximum difficulty [Lv8]", points = 25,
    id = 132852, badge = "146912", published = "11/20/2020 11:31:07 PM", modified = "11/21/2020 3:42:15 PM",
    trigger = cpuCharacter() == 0xb && never(unibios() != 0) && never(player2Status() != 0) && never(player1Status() != 1) && 
              wonFight() == 2 && arcadeProgression() >= 11 && screenId() != 20154 && prev(screenId()) == 20154 &&
              ((biosIndicator() == 0 && difficulty() == 7) ||
               (biosIndicator() == 2 && softDipMvsDifficulty() == 7))
)

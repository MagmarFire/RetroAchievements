// Duke Nukem 3D
// #ID = 129

// $5518: 00->01 - Level Complete
function levelIsComplete() => byte(0x005518)

// $5532: Level - Proper -- 00 - 08
function level() => byte(0x005532)

// $5572: Player Health
function health() => byte(0x005572)

// $557E: Demo Mode (Not correct)
//        
//        00=In Game (<- Not correct. This address increases while playing the level)
//        64=Demo Mode (Remains 0x64 while in a demo)
function badMemory() => byte(0x00557E)

// $F742: Upper8 - Passwrod input 1
//        Lower8 - Password input 2
function password1() => word(0x00F742)

// $F744: Upper8 - Passwrod input 3
//        Lower8 - Password input 4
function password2() => word(0x00F744)

achievement(
    title = "Who Wants Some?", description = "Complete Lunar Space", points = 10,
    id = 1784, badge = "02235", published = "7/16/2013 1:15:35 PM", modified = "7/16/2021 11:54:41 AM",
    trigger = prev(level()) == 3 && (prev(levelIsComplete()) == 0 && levelIsComplete() == 1) && 
              unless(once(password1() == 260 && password2() == 2064 && byte(0x00F747) == 16)) && unless(once(password1() == 320 && password2() == 528 && byte(0x00F747) == 32)) && 
              unless(once(password1() == 16416 && password2() == 1088 && byte(0x00F747) == 16)) &&
              (always_false() || (never(level() != 3) && never(health() == 0)))
)

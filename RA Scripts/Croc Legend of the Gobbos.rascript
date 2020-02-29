// Croc: Legend of the Gobbos
// #ID = 11399

// $074AC8: Colored Gems Stored Here during Level.
//          
//          Red Gem 0x01
//          Purple Gem 0x10
//          Blue Gem 0x04
//          Green Gem 0x02
//          Yellow Gem 0x08
//          
//          All Door Gems 0x1f
function coloredGemsCollected() => byte(0x074AC8)

// $074FDC: Lives Count (Value = Amount + 1)
function totalLives() => byte(0x074FDC) + 1

// $075210: Saved Gobbo Total (Updates after Level Completion)
function savedGobboTotal() => byte(0x075210)

// $07D3D0: First digit of password display:
//          
//          1 = up
//          2 = right
//          3 = down
//          4 = left
function firstPasswordDigit() => byte(0x07D3D0)

// $07496c: Gobbos saved in the current level
function gobbosSavedInCurrentLevel() => byte(0x07496c)
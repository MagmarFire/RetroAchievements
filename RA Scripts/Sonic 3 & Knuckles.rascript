// Sonic 3 & Knuckles
// #ID = 4874

// $E40E: Slot Machine reel 1
function slotMachineReel1Angle() => word(0x00E40E)

// $E412: Slot Machine reel 2
function slotMachineReel2Angle() => word(0x00E412)

// $E416: Slot Machine reel 3
function slotMachineReel3Angle() => word(0x00E416)

// $FFE0: Level select cheat:
//        0001 = Level exiting, 0100 = Level select
//        The game doesn't care as long as those bits are satisfied.
function cheatFlags() => word(0x00FFE0)

function zoneId() => byte(0x00fe11)

function currentMode() => byte(0x00f601)

function IsInNormalLevel() => currentMode() == 0xc

// Ticket 42423: I got Eggman|Jackpot|Eggman and resetted the game right when the spikes hit Sonic
//               Playing with Sonic &amp; Tails on No Save
//               MD5: c5b1c655c19f462ade0ac4e17a844d10
//               Emulator: RetroArch ()
//               Emulator Version: Genesis Plus GX (v.1.7.4  7dc00cb)
// Ticket 39369: The Cheevo triggered while I was entering the bonus stage and in other playthroughs, when I got a
//               Jackpot, it didn't triggered.
//               MD5: Unknown
//               Emulator: RetroArch (PicoDrive)

function HitJackpotOnGivenReel(reelAngleMem) => once(prev(reelAngleMem) == 0xfff8 && reelAngleMem == 0x0)

achievement(
    title = "My Lucky Day", description = "Get the Jackpot in the Slot Machine Bonus", points = 10,
    id = 36585, badge = "37420", published = "5/27/2016 8:54:41 AM", modified = "10/18/2019 2:35:01 PM",
    trigger = slotMachineReel1Angle() == 0x0 && slotMachineReel2Angle() == 0x0 && slotMachineReel3Angle() == 0x0 && 
              never(cheatFlags() == 257)
              && word(0x00ff90) == 0x1d
              //&& IsInNormalLevel() && never(zoneId() != 0x15)
)
